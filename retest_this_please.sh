#!/bin/bash
usg="Usage: $0 username auth_token commit_id pr_id"
message="jenkins retest this please"
owner="sweng-epfl"
repo="team-qeeq"

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
    curl -s -u $username:$auth_token https://api.github.com/repos/$owner/$repo/commits/$commit_id/statuses > status.json
    state=$(python -c "import json; print(json.loads(open('status.json', 'r').read())[0]['state'])")
    echo "$(date) LAST STATE: $state"
    if [ "X$state" == "Xfailure" ]
    then
        echo "$(date) Last build failed. Restarting build..."
        curl -s -u $username:$auth_token --data "{\"body\": \"$message\"}" https://api.github.com/repos/$owner/$repo/issues/$pr_id/comments
        echo "$(date) Added comment: [$message]"
    fi

    if [ "X$state" == "Xsuccess" ]
    then
        echo "$(date) Congratulations! Your build was successful. Now I will try to merge the PR"
        curl -s -X PUT -u $username:$auth_token https://api.github.com/repos/$owner/$repo/pulls/$pr_id/merge
        echo "$(date) Exiting"
        exit 0
    fi

    sleep 10
done
