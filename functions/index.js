const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Cloud Function to check auctions and update status to "ended"
exports.updateAuctionStatus = functions.onRun(async () => {
      const now = new Date();

      try {
      response.send("Hello from Firebase!");
      } catch (error) {
        console.error("❌ Error updating auctions: ", error);
      }

      return null;
    });

