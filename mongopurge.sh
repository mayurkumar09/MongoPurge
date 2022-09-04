#!/bin/bash


connectionString=`jq '.connectionString' config.json`
startTime=`jq '.startTime' config.json`
endTime=`jq '.endTime' config.json`
db=`jq '.db[]' config.json`

echo $connectionString


for i in $db
do
    i=`echo "$i" | tr -d '"'`
    echo "Db to be Purged is $i"

    echo "########################################"
    echo "Starting Mongo Purge for database $i"
    echo "########################################"

    function MongoPurge {
        mongosh "mongodb+srv://Sh2305:Sg2305kec@cluster0.iwjentv.mongodb.net/?retryWrites=true&w=majority" << EOF
        use $i
        show collections
        db.collection1.deleteMany({ \$and: [{ "createdTime": { \$gte: ISODate($startTime), \$lt: ISODate($endTime) } }, { "gameRoundStatus": "COMPLETED" }] })

EOF
    }

    MongoPurge

done