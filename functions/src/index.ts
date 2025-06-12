import { onSchedule } from "firebase-functions/v2/scheduler";
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import admin from "firebase-admin";
// import * as functions from "firebase-functions";

admin.initializeApp();
const db = admin.firestore();

/**
 * Saves a notification to Firestore under the "notifications" collection.
 */
async function saveNotificationToFirestore(
  email: string | null,
  title: string,
  body: string,
  data: { [key: string]: string }
) {
  try {
    await admin.firestore().collection("notifications").add({
      email,
      title,
      body,
      data,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    logger.info("Notification saved to Firestore.");
  } catch (error) {
    logger.error("Failed to save notification to Firestore:", error);
  }
}

async function sendNotification(
  token: string,
  title: string,
  body: string,
  data: { [key: string]: string },
  email: string | null = null
) {
  const message = {
    notification: { title, body },
    data,
    token,
  };

  try {
    const response = await admin.messaging().send(message);
    logger.info("Notification sent successfully:", response);

    await saveNotificationToFirestore(email, title, body, data);

    return { success: true, response };
  } catch (error) {
    logger.error("Error sending notification:", error);
    return { success: false, error };
  }
}

async function sendNotificationToMultipleDevices(
  tokens: string[],
  title: string,
  body: string,
  data: { [key: string]: string }
) {
  try {
    const responses = await Promise.all(
      tokens.map((token) => sendNotification(token, title, body, data, null))
    );
    return { success: true, responses };
  } catch (error) {
    logger.error("Error sending notifications:", error);
    return { success: false, error };
  }
}

export const sendPushNotification = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).json({ error: "Method Not Allowed" });
    return;
  }

  const { token, tokens, title, body, data, email } = req.body;

  if (!title || !body) {
    res.status(400).json({ error: "Missing required fields: title or body" });
    return;
  }

  let result;

  if (token) {
    result = await sendNotification(token, title, body, data, email ?? null);
  } else if (tokens) {
    result = await sendNotificationToMultipleDevices(tokens, title, body, data);
  } else {
    res
      .status(400)
      .json({ error: "Invalid request parameters: missing token or tokens" });
    return;
  }

  if (result.success) {
    res.status(200).json({
      success: true,
      message: "Notification sent",
      response: result,
    });
  } else {
    res.status(500).json({ success: false, error: result.error });
  }
});

async function getFcmTokensFromFirestore(): Promise<string[]> {
  const tokensSnapshot = await admin.firestore().collection("tokens").get();
  const tokens: string[] = [];

  tokensSnapshot.forEach((doc) => {
    const token = doc.data().token;
    if (token) {
      tokens.push(token);
    }
  });

  return tokens;
}

export const sendNotificationByGetTokensFromCloudStore = onRequest(
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method Not Allowed" });
      return;
    }

    const { title, body, data } = req.body;

    if (!title || !body) {
      res.status(400).json({ error: "Missing required fields: title or body" });
      return;
    }

    try {
      const tokens = await getFcmTokensFromFirestore();

      if (tokens.length === 0) {
        res.status(400).json({ error: "No tokens found in Firestore" });
        return;
      }

      const result = await sendNotificationToMultipleDevices(
        tokens,
        title,
        body,
        data
      );

      if (result.success) {
        res.status(200).json({
          success: true,
          message: "Notification sent",
          response: result,
        });
      } else {
        res.status(500).json({ success: false, error: result.error });
      }
    } catch (error) {
      logger.error("Error fetching tokens from Firestore:", error);
      res.status(500).json({
        success: false,
        error: "Error fetching tokens from Firestore",
      });
    }
  }
);

const sendSms = async (recipient: string, message: string) => {
  const url = "https://probasesms.com/api/json/multi/res/bulk/sms";
  const payload = {
    username: "Nexapp Technologies",
    password: "hax5mppuuYvphcfdrwnf",
    source: "Monitoring",
    senderid: "MotorAlert",
    recipient: [recipient],
    message,
    msg_ref: "",
  };

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    const result = await response.json();
    logger.info("SMS sent successfully:", result);
  } catch (error) {
    logger.error("Failed to send SMS:", error);
  }
};

export const checkLicenseExpiry = onSchedule(
  {
    schedule: "0 * * * *", // Every hour
    timeZone: "Africa/Lusaka",
  },
  async () => {
    const now = admin.firestore.Timestamp.now();
    const sevenDaysLater = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    );

    const SIX_HOURS_MS = 6 * 60 * 60 * 1000;

    const handleSnapshot = async (
      snapshot: FirebaseFirestore.QuerySnapshot,
      isExpired: boolean,
      type: "license" | "roadtax"
    ) => {
      if (snapshot.empty) {
        logger.info(
          isExpired ? `No expired ${type}s.` : `No ${type}s expiring soon.`
        );
        return;
      }

      const promises = snapshot.docs.map(async (doc) => {
        const data = doc.data();
        const userEmail = data.email;

        if (!userEmail) {
          logger.warn(`Missing email for document ${doc.id}`);
          return;
        }

        const tokenSnapshot = await db
          .collection("tokens")
          .where("email", "==", userEmail)
          .limit(1)
          .get();

        if (tokenSnapshot.empty) {
          logger.warn(`No FCM token found for email: ${userEmail}`);
          return;
        }

        const tokenData = tokenSnapshot.docs[0].data();
        const fcmToken = tokenData.token;
        const fullPhone = tokenData.fullPhone;

        if (!fcmToken || !fullPhone) {
          logger.warn(`Token or phone missing for email: ${userEmail}`);
          return;
        }

        const expiryDateStr = data.expiryDate
          .toDate()
          .toLocaleDateString("en-ZM");

        const title = isExpired
          ? `${type === "license" ? "License" : "Road Tax"} Expired`
          : `${type === "license" ? "License" : "Road Tax"} Expiry Reminder`;
        const body = isExpired
          ? `Your ${type} expired on ${expiryDateStr}. Please renew it immediately.`
          : `Your ${type} is expiring on ${expiryDateStr}. Please renew it soon.`;
        const notificationData = {
          type: isExpired ? `${type}_expired` : `${type}_expiry`,
        };

        await sendNotification(
          fcmToken,
          title,
          body,
          notificationData,
          userEmail
        );

        const lastSmsSent = data.lastSmsSent?.toDate();
        const nowDate = new Date();

        if (
          !lastSmsSent ||
          nowDate.getTime() - lastSmsSent.getTime() >= SIX_HOURS_MS
        ) {
          await sendSms(fullPhone, body);

          await db
            .collection(type === "license" ? "DriverLicense" : "roadTax")
            .doc(doc.id)
            .update({
              lastSmsSent: admin.firestore.Timestamp.fromDate(nowDate),
            });
        } else {
          logger.info(
            `Skipping SMS for ${userEmail} (${type}, last sent less than 6 hours ago)`
          );
        }
      });

      await Promise.all(promises);
    };

    try {
      const licenseExpiringSoon = await db
        .collection("DriverLicense")
        .where("expiryDate", ">=", now)
        .where("expiryDate", "<=", sevenDaysLater)
        .get();

      const licenseExpired = await db
        .collection("DriverLicense")
        .where("expiryDate", "<", now)
        .get();

      const roadTaxExpiringSoon = await db
        .collection("roadTax")
        .where("expiryDate", ">=", now)
        .where("expiryDate", "<=", sevenDaysLater)
        .get();

      const roadTaxExpired = await db
        .collection("roadTax")
        .where("expiryDate", "<", now)
        .get();

      await handleSnapshot(licenseExpiringSoon, false, "license");
      await handleSnapshot(licenseExpired, true, "license");
      await handleSnapshot(roadTaxExpiringSoon, false, "roadtax");
      await handleSnapshot(roadTaxExpired, true, "roadtax");
    } catch (error) {
      logger.error("Error checking expiries:", error);
    }
  }
);

export const notifyLicenseExpiryHttp = onRequest(async (req, res) => {
  try {
    const now = admin.firestore.Timestamp.now();
    const sevenDaysLater = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    );
    const SIX_HOURS_MS = 6 * 60 * 60 * 1000;

    const handleSnapshot = async (
      snapshot: FirebaseFirestore.QuerySnapshot,
      isExpired: boolean,
      type: "license" | "roadtax"
    ) => {
      const promises = snapshot.docs.map(async (doc) => {
        const data = doc.data();
        const userEmail = data.email;

        if (!userEmail) return;

        const tokenSnapshot = await db
          .collection("tokens")
          .where("email", "==", userEmail)
          .limit(1)
          .get();

        if (tokenSnapshot.empty) return;

        const tokenData = tokenSnapshot.docs[0].data();
        const fcmToken = tokenData.token;
        const fullPhone = tokenData.fullPhone;

        if (!fcmToken || !fullPhone) return;

        const expiryDateStr = data.expiryDate
          .toDate()
          .toLocaleDateString("en-ZM");

        const title = isExpired
          ? `${type === "license" ? "License" : "Road Tax"} Expired`
          : `${type === "license" ? "License" : "Road Tax"} Expiry Reminder`;
        const body = isExpired
          ? `Your ${type} expired on ${expiryDateStr}. Please renew it immediately.`
          : `Your ${type} is expiring on ${expiryDateStr}. Please renew it soon.`;

        const notificationData = {
          type: isExpired ? `${type}_expired` : `${type}_expiry`,
        };

        await sendNotification(
          fcmToken,
          title,
          body,
          notificationData,
          userEmail
        );

        const lastSmsSent = data.lastSmsSent?.toDate();
        const nowDate = new Date();

        if (
          !lastSmsSent ||
          nowDate.getTime() - lastSmsSent.getTime() >= SIX_HOURS_MS
        ) {
          await sendSms(fullPhone, body);

          await db
            .collection(type === "license" ? "DriverLicense" : "roadTax")
            .doc(doc.id)
            .update({
              lastSmsSent: admin.firestore.Timestamp.fromDate(nowDate),
            });
        }
      });

      await Promise.all(promises);
    };

    const licenseExpiringSoon = await db
      .collection("DriverLicense")
      .where("expiryDate", ">=", now)
      .where("expiryDate", "<=", sevenDaysLater)
      .get();

    const licenseExpired = await db
      .collection("DriverLicense")
      .where("expiryDate", "<", now)
      .get();

    const roadTaxExpiringSoon = await db
      .collection("roadTax")
      .where("expiryDate", ">=", now)
      .where("expiryDate", "<=", sevenDaysLater)
      .get();

    const roadTaxExpired = await db
      .collection("roadTax")
      .where("expiryDate", "<", now)
      .get();

    await handleSnapshot(licenseExpiringSoon, false, "license");
    await handleSnapshot(licenseExpired, true, "license");
    await handleSnapshot(roadTaxExpiringSoon, false, "roadtax");
    await handleSnapshot(roadTaxExpired, true, "roadtax");

    res.status(200).send("Notifications processed successfully.");
  } catch (error) {
    logger.error("Error processing notifications:", error);
    res.status(500).send("Error processing notifications.");
  }
});
