import { onSchedule } from "firebase-functions/v2/scheduler";
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import admin from "firebase-admin";

admin.initializeApp();

/**
 * Saves a notification to Firestore under the "notifications" collection.
 * @param email - The recipient's email (if available).
 * @param title - The notification title.
 * @param body - The notification body.
 * @param data - Custom data sent with the notification.
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
      tokens.map(
        (token) => sendNotification(token, title, body, data, null) // null email for bulk
      )
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

export const checkLicenseExpiry = onSchedule(
  {
    // schedule: "0 0 * * *", // Every day at 12:00 AM
    // schedule: "* * * * *", // For testing: every minute
    // schedule: "*/5 * * * *", // Every 5 minutes
    schedule: "*/30 * * * *", // Every 30 minutes
    timeZone: "Africa/Lusaka",
  },
  async () => {
    const db = admin.firestore();
    const now = admin.firestore.Timestamp.now();
    const sevenDaysLater = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    );

    try {
      const snapshot = await db
        .collection("DriverLicense")
        .where("expiryDate", ">=", now)
        .where("expiryDate", "<=", sevenDaysLater)
        .get();

      if (snapshot.empty) {
        logger.info("No licenses expiring soon.");
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

        if (!fcmToken) {
          logger.warn(`Token field missing for email: ${userEmail}`);
          return;
        }

        const title = "License Expiry Reminder";
        const body = `Your license is expiring on ${data.expiryDate
          .toDate()
          .toLocaleDateString()}. Please renew it soon.`;
        const notificationData = { type: "license_expiry" };

        await sendNotification(
          fcmToken,
          title,
          body,
          notificationData,
          userEmail
        );
      });

      await Promise.all(promises);
    } catch (error) {
      logger.error("Error checking license expiries:", error);
    }
  }
);
