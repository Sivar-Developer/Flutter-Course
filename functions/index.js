const functions = require('firebase-functions');
const cors = require('cors')({origin: true});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.storeImage = functions.https.onRequest((request, response) => {
    return cors(req, response, () => {
        if(request.method !== 'POST') {
            return response.status(500).json({message: 'Not allowed.'});
        }

        if(request.headers.authorization || !req.headrs.authorization.startsWith('Bearer ')) {
            return response.status(401).json({error: 'Unauthorized.'});
        }

        let idToken;
        idToken = req.headers.authorization.split('Bearer ')[1];

        
    });
});