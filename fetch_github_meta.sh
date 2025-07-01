#!/bin/sh

GITHUB_TOKEN="${GITHUB_TOKEN}"

# echo ${GITHUB_TOKEN}

# if [ -z "$GITHUB_TOKEN" ]; then
#   echo "❌ GITHUB_TOKEN is not set"
# else
#   echo "✅ GITHUB_TOKEN is set"
# fi

REPO_OWNER="sanadivya"
REPO_NAME="gitinfo-demo"
ENV="dev"
PROJECT="demo"
SERVICE="demo"
VERSION="V0.1"
COMMIT_SHA=$(git rev-parse HEAD)

echo "Fetching commit info..."
COMMIT_API="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits/${COMMIT_SHA}"
COMMIT_DATA=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "$COMMIT_API")


echo "API URL: $COMMIT_API"
# echo "Commit Info:"
# echo "$COMMIT_DATA"

# echo "🔹 Commit Message:"
# echo "$COMMIT_DATA" | jq -r '.commit.message'

# echo "🔹 Commit Author:"
# echo "$COMMIT_DATA" | jq -r '.commit.author.name'
COMMIT_MESSAGE=$(echo "$COMMIT_DATA" | jq -r '.commit.message')
COMMIT_AUTHOR=$(echo "$COMMIT_DATA" | jq -r '.commit.author.name')

echo "Checking PRs associated with the commit..."
PR_API="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits/${COMMIT_SHA}/pulls"
PR_DATA=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.groot-preview+json" "$PR_API")

PR_COUNT=$(echo "$PR_DATA" | jq 'length')

# 🔧 Build Git Details section
if [ "$PR_COUNT" -gt 0 ]; then
    echo "✅ PR Info Found:"
    echo "PR Number:   $(echo "$PR_DATA" | jq -r '.[0].number')"
    echo "PR Title:    $(echo "$PR_DATA" | jq -r '.[0].title')"
    echo "Source → Target: $(echo "$PR_DATA" | jq -r '.[0].head.ref') → $(echo "$PR_DATA" | jq -r '.[0].base.ref')"
    DETAILS="**PR Title**: ${PR_TITLE}\n**PR Number**: #${PR_NUMBER}\n**Branch**: ${PR_SOURCE} → ${PR_TARGET}"
else
    DETAILS="\n- **Commit Message**: `${COMMIT_MESSAGE}`\n- **Author**: `${COMMIT_AUTHOR}`\n"
fi

curl -X POST -H "Content-Type: application/json" \
-d '{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "summary": "Deployment Notification",
    "themeColor": "00FF00",
    "title": "✅ New version deployed to '"${ENV}"' environment",
    "sections": [
    {
        "activityTitle": "Deployment Details",
        "text": "\n- **Environment**: `${ENV}`\n- **Project**: `${PROJECT_ID}`\n- **Service**: `${SERVICE_NAME}`\n- **Version**: `$SHORT_SHA`"
    },
    {
        "activityTitle": "Git Info",
        "text": "'"${DETAILS}"'"
    }
    ]
}' "https://pakompetens.webhook.office.com/webhookb2/3b361490-df1e-4317-91e4-c3aec626287f@fdb820d5-bcd4-43fc-ac72-c1638a72ae9c/IncomingWebhook/09fd98c09d6b4b26a21c1a22bc2c02e7/da953398-22b5-4e5d-b7c2-1ae89b32899e/V2mNV7H_or53WYxH5WJ0zZ97U62fWP-I_r_iWR3ox9k781"