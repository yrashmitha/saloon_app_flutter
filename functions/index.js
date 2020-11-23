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



exports.appointmentCloudMessage = functions.firestore
.document('appointments/{id}')
.onUpdate((change, context) =>{
    const newValue = change.after.data();
    const previousValue = change.before.data();
    const name = newValue.name;
    const id = context.params.id;
    const status = newValue.status;
    const saloonName = newValue['saloon_name'];


    var notificationTitle = "";
    var notificationToken="";
    const userToken = newValue['user_token'];



    if(status=="CANCELLED"){
        notificationTitle = "Your appointment was cancelled by the user";

    }
    else if(status=="DECLINED"){
            notificationTitle = "Your appointment was cancelled by the saloon";
            notificationToken = newValue['user_token'];

    }
    else if(status=="ACCEPTED"){
             notificationTitle = "Your appointment was Accepted by the "+saloonName+".";
             notificationToken = newValue['user_token'];
    }
    else if(status=="COMPLETED"){
                 notificationTitle = "Your appointment was Completed";
                 notificationToken = newValue['user_token'];
        }

         const payload = {
                notification: {
                    title: ""+notificationTitle+"",
                    body: 'Tap here to check it out!',
                    clickAction : 'FLUTTER_NOTIFICATION_CLICK',
                },
                data: {
                    appointment_id : id
                }
            }

     admin.messaging().sendToDevice(notificationToken,payload);

    });


