const admin = require('firebase-admin');
const path = require('path');

const serviceAccountPath = path.resolve(__dirname, '../config/firebase-admin.json');

admin.initializeApp({
  credential: admin.credential.cert(require(serviceAccountPath)),
});


module.exports = async ({ title, body, tokens, data = {} }) => {
  try {
    await admin.messaging().sendEachForMulticast({
      notification: { title, body },
      data,
      tokens
    });
  } catch (e) {
    // Do Nothing
  }
};
