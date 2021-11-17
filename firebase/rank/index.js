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
let dateTimestamp = admin.firestore.Timestamp.now();

/**
 * Run once a day at midnight, to cleanup the users
 * Manually run the task here https://console.cloud.google.com/cloudscheduler
 */
exports.rankusers = functions.pubsub.schedule('* * * * *').onRun(async context => {
    dateTimestamp = admin.firestore.Timestamp.now()
    functions.logger.log('User Rank Update running');
    // Fetch all user details.
    const users = await getUsersInOrder();
    await updateRank(users);
    await setRank(users);
    functions.logger.log('User Rank Update finished');
});

/**
 * Returns the list of all users in database.
 */
async function getUsersInOrder() {
    const userSnapshot = await admin.firestore()
        .collection('user')
        .get();
    if (userSnapshot.empty) {
        functions.logger.log('User Data is empty!');
        return [];
    }
    const userDict = {};
    userSnapshot.forEach(doc => {
        userDict[doc.id] = doc.data();
    });

    const snapshot = await admin.firestore()
        .collection('rankAccount')
        .orderBy('balance', 'desc')
        .get();
    if (snapshot.empty) {
        functions.logger.log('User Data is empty!');
        return [];
    }
    var usersInOrder = [];
    snapshot.forEach(doc => {
        if (!(doc.id in userDict)) return;
        const data = doc.data();
        usersInOrder.push({
            "uid": doc.id,
            "user": userDict[doc.id],
            "rankAccount": data,
            "rank": usersInOrder.length + 1,
            "balance": data["balance"],
        });
    });
    return usersInOrder;
}

async function updateRank(usersInOrder) {
    const dateStringInYYYY_MM_DD = (new Date()).toISOString().slice(0, 10);
    await admin.firestore()
        .collection('rank')
        .doc(dateStringInYYYY_MM_DD).set({
            "list": usersInOrder,
            "lastUpdate": dateTimestamp,
        }, {merge: true});
    const maxBalanceUser = usersInOrder.length === 0 ? -1 : usersInOrder.reduce((prev, current) => {
        return (prev.balance > current.balance) ? prev : current
    });
    const minBalanceUser = usersInOrder.length === 0 ? -1 : usersInOrder.reduce((prev, current) => {
        return (prev.balance < current.balance) ? prev : current
    });

    await admin.firestore()
        .collection('rank')
        .doc("lastUpdateInfo").set({
            "maxBalanceUser": maxBalanceUser,
            "minBalanceUser": minBalanceUser,
            "updateDate": dateTimestamp,
            "userCount": usersInOrder.length,
            "updatePath": dateStringInYYYY_MM_DD,
        });
}

async function setRank(usersInOrder) {
    const promises = []
    while(usersInOrder.length > 0) {
        const userToSetRank = usersInOrder.pop();
        const promise = admin.firestore()
            .collection('user')
            .doc(userToSetRank.uid).set({
                "rank": userToSetRank.rank,
                "rankUpdateDate": dateTimestamp,
            }, {merge: true}).then(() => {
            return functions.logger.log('set user:', userToSetRank.uid, 'rank as', userToSetRank.rank);
        }).catch((e) => {
            return functions.logger.error(
                'Deletion of inactive user account',
                userToSetRank.uid,
                'failed:',
                e
            );
        });
        promises.push(promise);
    }
    await Promise.all(promises);
}
