const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

exports.createUser = functions.firestore
    .document('saloons/{saloonId}/all_reviews/{reviewId}')
    .onCreate((snap, context) => {
      // Get an object representing the document

      const newValue = snap.data();
      db.doc('saloons/{saloonId}/all_reviews/{reviewId}').set({ ... });

      console.log(context.params.saloonId);

    });
