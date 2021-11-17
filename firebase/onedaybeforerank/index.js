/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Run once a day at midnight, to cleanup the users
 * Manually run the task here https://console.cloud.google.com/cloudscheduler
 */
exports.onedaybeforerank = functions.pubsub.schedule('* * * * *').onRun(async context => {
    functions.logger.log('User onedaybeforeRank Update running');
    // Fetch all user details.
    const users = await getUsersNotRankEmpty();
    await setUnitTimeBeforeRank(users);
    functions.logger.log('User onedaybeforeRank Update finished');
});

/**
 * Returns the list of all users in database.
 */
async function getUsersNotRankEmpty() {
    const userSnapshot = await admin.firestore()
        .collection('user')
        .get();
    if (userSnapshot.empty) {
        functions.logger.log('User Data is empty!');
        return [];
    }
    const users = [];
    userSnapshot.forEach(doc => {
        const data = doc.data()
        if (typeof data["rank"] === "undefined") {
            return;
        }
        users.push({"uid": doc.id, "data": data});
    });

    return users;
}

async function setUnitTimeBeforeRank(users) {
    const promises = []
    while(users.length > 0) {
        const userToSetUnitTimeBeforeRank = users.pop();
        const promise = admin.firestore()
            .collection('user')
            .doc(userToSetUnitTimeBeforeRank.uid).set({
                "unitTimeBeforeRank": userToSetUnitTimeBeforeRank.data.rank,
            }, {merge: true}).then(() => {
            return functions.logger.log('set user:', userToSetUnitTimeBeforeRank.uid, 'userToSetUnitTimeBeforeRank as', userToSetUnitTimeBeforeRank.data.rank);
        }).catch((e) => {
            return functions.logger.error(
                'userToSetUnitTimeBeforeRank',
                userToSetUnitTimeBeforeRank.uid,
                'failed:',
                e
            );
        });
        promises.push(promise);
    }
    await Promise.all(promises);
}
