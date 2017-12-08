#!/bin/bash
usg="Usage: $0 username auth_token commit_id pr_id"
message="jenkins retest this please"

if [ "X$4" == "X" ]
then
    echo $usg
    echo "Example: $0 george alsdkjalskdj 19b196c 311"
    echo "Token can be obtained at https://github.com/settings/tokens"
    exit 1
fi

username=$1
auth_token=$2
commit_id=$3
pr_id=$4


while true
do
    curl -u $username:$auth_token https://api.github.com/repos/sweng-epfl/team-qeeq/commits/$commit_id/statuses > status.json
    state=$(python -c "import json; print(json.loads(open('status.json', 'r').read())[0]['state'])")
    echo "LAST STATE: $state"
    if [ "X$state" == "Xfailure" ]
    then
        echo "Last build failed. Restarting build..."
        curl -u $username:$auth_token --data "{\"body\": \"$message\"}" https://api.github.com/repos/sweng-epfl/team-qeeq/issues/$pr_id/comments
        echo "Added comment: [$message]"
    fi

    sleep 10
done
