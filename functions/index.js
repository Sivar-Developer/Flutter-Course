const functions = require('firebase-functions');
const cors = require('cors')({ origin: true });
const Busboy = require('busboy');
const os = require('os');
const path = require('path');
const fs = require('fs');
const fbAdmin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');
const { Storage } = require('@google-cloud/storage');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const gcconfig = {
    projectId: 'flutter-products-7ddd6',
    keyfilename: 'flutter-products.json'
};

const gcs = new Storage(gcconfig);

fbAdmin.initializeApp({ credential: fbAdmin.credential.cert(require('./flutter-products.json')) })

exports.storeImage = functions.https.onRequest((request, response) => {
    return cors(req, response, () => {
        if (request.method !== 'POST') {
            return response.status(500).json({ message: 'Not allowed.' });
        }

        if (request.headers.authorization || !req.headrs.authorization.startsWith('Bearer ')) {
            return response.status(401).json({ error: 'Unauthorized.' });
        }

        let idToken;
        idToken = req.headers.authorization.split('Bearer ')[1];

        const busboy = new Busboy({ headers: req.headers });
        let uploadData;

        busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {
            const filepath = path.join(os.tmpdir(), filename);
            uploadData = { filepath: filepath, type: mimetype, name: filename };
            file.pipe(fs.createWriteStream(filepath));
        });

        busboy.on('field', (fieldname, value) => {
            oldImagePath = decodeURIComponent(value);
        });

        busboy.on('finish', () => {
            const bucket = gcs.bucket('flutter-products-7ddd6.appspot.com/');
            const id = uuidv4();
            let imagePath = 'images/' + id + '-' + uploadData.name
            if (oldImagePath) {
                imagePath = oldImagePath;
            }

            return fbAdmin
                .auth()
                .verifyIdToken(idToken)
                .then(decodedToken => {
                    return bucket.upload(uploadData.filepath, {
                        uploadType: 'media',
                        destination: imagePath,
                        metadata: {
                            metadata: {
                                contentType: uploadData.type,
                                firebaseStorageDownloadToken: id
                            }
                        }
                    });
                })
                .then(() => {
                    return response.status(201).json({
                        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/' + bucket.name + '/o/' + encodeURIComponent(imagePath) + '?alt=media&token=' + id,
                        imagePath: imagePath
                    });
                })
                .catch(error => {
                    return response.status(401).json({ error: 'Unauthorized.' });
                });
        });
        return busboy.end(request.rawBody);
    });
});