/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";


// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
// Initialize Firebase Admin SDK
admin.initializeApp();

/**
 * Sends a push notification to a single device.
 * @param token - The FCM token of the device.
 * @param title - The notification title.
 * @param body - The notification body.
 * @param data - The custom data to send with the notification.
 */
async function sendNotification(
  token: string,
  title: string,
  body: string,
  data: { [key: string]: string }
) {
  const message = {
    notification: { title, body },
    data: data, // Send custom data here
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
 * @param tokens - Array of FCM tokens.
 * @param title - The notification title.
 * @param body - The notification body.
 * @param data - The custom data to send with the notification.
 */
async function sendNotificationToMultipleDevices(
  tokens: string[],
  title: string,
  body: string,
  data: { [key: string]: string }
) {
  const message = {
    notification: { title, body },
    data: data, // Send custom data here
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
 * HTTP Trigger to Send Notifications
 */
export const sendPushNotification = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).json({ error: "Method Not Allowed" });
    return;
  }

  const { token, tokens, title, body, data } = req.body;

  // Check if required fields are present
  if (!title || !body) {
    res.status(400).json({ error: "Missing required fields: title or body" });
    return;
  }

  let result;

  // Determine whether to send to a single token, multiple tokens, or send data message
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

  // Return success or error response
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
/**
 * Fetches the FCM tokens from Firestore from the 'tokens' collection.
 * @return {Promise<string[]>} - A list of FCM tokens.
 */
async function getFcmTokensFromFirestore(): Promise<string[]> {
  const tokensSnapshot = await admin.firestore().collection("tokens").get();
  const tokens: string[] = [];

  tokensSnapshot.forEach((doc) => {
    const token = doc.data().token; // Access the 'token' field in each document
    if (token) {
      tokens.push(token); // Add the token to the list if it exists
    }
  });

  return tokens;
}
/**
 * HTTP Trigger to Send Notifications
 */
export const sendNotificationByGetTokensFromCloudStore = onRequest(
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method Not Allowed" });
      return;
    }

    const { title, body, data } = req.body;

    // Check if required fields are present
    if (!title || !body) {
      res.status(400).json({ error: "Missing required fields: title or body" });
      return;
    }

    let result;

    try {
      // Fetch tokens from Firestore
      const tokens = await getFcmTokensFromFirestore();

      if (tokens.length === 0) {
        res.status(400).json({ error: "No tokens found in Firestore" });
        return;
      }

      // Send notification to all tokens
      result = await sendNotificationToMultipleDevices(
        tokens,
        title,
        body,
        data
      );
    } catch (error) {
      logger.error("Error fetching tokens from Firestore:", error);
      res.status(500).json({
        success: false,
        error: "Error fetching tokens from Firestore",
      });
      return;
    }

    // Return success or error response
    if (result.success) {
      res.status(200).json({
        success: true,
        message: "Notification sent",
        response: result,
      });
    } else {
      res.status(500).json({ success: false, error: result.error });
    }
  }
);
