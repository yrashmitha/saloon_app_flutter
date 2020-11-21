const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

exports.addReview = functions.firestore
    .document('saloons/{saloonId}/all_reviews/{reviewId}')
    .onCreate((snap, context) => {
        // Get an object representing the document

        const newValue = snap.data();
        const id = context.params.saloonId;

        var arr=[];

        return db.collection("saloons/"+id+"/all_reviews").orderBy("date", "desc").limit(2)
            .get().then(function (snap) {
                snap.forEach(function(doc) {
                    arr.push(doc.data());
                });

                db.collection("saloons/"+id+"/data").doc(id).update({
                    'reviews':arr
                }).then(function () {
                    return null;
                })


            });
    });



