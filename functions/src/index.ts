import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
// import * as admin from "firebase-admin";
import admin from "firebase-admin";
// Initialize Firebase Admin SDK
admin.initializeApp();

/**
 * Sends a push notification to a single device.
 * @param {string} token - The FCM token of the device.
 * @param {string} title - The notification title.
 * @param {string} body - The notification body.
 * @param {Record<string, string>} data - The custom data to send with the notification.
 */
async function sendNotification(
  token: string,
  title: string,
  body: string,
  data: Record<string, string>
) {
  const message = {
    notification: { title, body },
    data, // Send custom data here
    token,
  };

  try {
    const response = await admin.messaging().send(message);
    logger.info("Notification sent successfully:", response);
    return { success: true, response };
  } catch (error) {
    logger.error("Error sending notification:", error);
    return { success: false, error };
  }
}

/**
 * Sends a push notification to multiple devices.
 * @param {string[]} tokens - Array of FCM tokens.
 * @param {string} title - The notification title.
 * @param {string} body - The notification body.
 * @param {Record<string, string>} data - The custom data to send with the notification.
 */
async function sendNotificationToMultipleDevices(
  tokens: string[],
  title: string,
  body: string,
  data: Record<string, string>
) {
  const message = {
    notification: { title, body },
    data, // Send custom data here
  };

  try {
    // Send notification to each token
    const responses = await Promise.all(
      tokens.map((token) => admin.messaging().send({ ...message, token }))
    );
    logger.info(
      `Successfully sent notifications to ${responses.length} devices`
    );
    return { success: true, responses };
  } catch (error) {
    logger.error("Error sending notifications:", error);
    return { success: false, error };
  }
}

/**
 * Fetches the FCM tokens from Firestore from the 'tokens' collection.
 * @return {Promise<string[]>} - A list of FCM tokens.
 */
async function getFcmTokensFromFirestore(): Promise<string[]> {
  const tokensSnapshot = await admin.firestore().collection("tokens").get();
  const tokens: string[] = [];

  tokensSnapshot.forEach((doc) => {
    const token: string | undefined = doc.data().token; // Explicitly type token
    if (token) {
      tokens.push(token);
    }
  });

  return tokens;
}

/**
 * HTTP Trigger to Send Notifications
 */
export const sendPushNotification = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).json({ error: "Method Not Allowed" });
    return;
  }

  const {
    token,
    tokens,
    title,
    body,
    data,
  }: {
    token?: string;
    tokens?: string[];
    title: string;
    body: string;
    data: Record<string, string>;
  } = req.body;

  // Check if required fields are present
  if (!title || !body) {
    res.status(400).json({ error: "Missing required fields: title or body" });
    return;
  }

  let result;

  if (token) {
    result = await sendNotification(token, title, body, data);
  } else if (tokens) {
    result = await sendNotificationToMultipleDevices(tokens, title, body, data);
  } else {
    res
      .status(400)
      .json({ error: "Invalid request parameters: missing token or tokens" });
    return;
  }

  res.status(result.success ? 200 : 500).json(result);
});

/**
 * HTTP Trigger to Send Notifications Using Tokens from Firestore
 */
export const sendNotificationByGetTokensFromCloudStore = onRequest(
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method Not Allowed" });
      return;
    }

    const {
      title,
      body,
      data,
    }: { title: string; body: string; data: Record<string, string> } = req.body;

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
      res.status(result.success ? 200 : 500).json(result);
    } catch (error) {
      logger.error("Error fetching tokens from Firestore:", error);
      res
        .status(500)
        .json({
          success: false,
          error: "Error fetching tokens from Firestore",
        });
    }
  }
);
