#!/bin/sh

GITHUB_TOKEN="${GITHUB_TOKEN}"

REPO_OWNER="sanadivya"
REPO_NAME="gitinfo-demo"
COMMIT_SHA=$(git rev-parse HEAD)

echo "Fetching commit info..."
COMMIT_API="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits/${COMMIT_SHA}"
COMMIT_DATA=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "$COMMIT_API")

echo $COMMIT_API
echo $COMMIT_DATA

# echo "🔹 Commit Message:"
# echo "$COMMIT_DATA" | jq -r '.commit.message'

# echo "🔹 Commit Author:"
# echo "$COMMIT_DATA" | jq -r '.commit.author.name'

# echo ""
# echo "Checking PRs associated with the commit..."
# PR_API="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits/${COMMIT_SHA}/pulls"
# PR_DATA=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.groot-preview+json" "$PR_API")

# PR_COUNT=$(echo "$PR_DATA" | jq 'length')

# if [ "$PR_COUNT" -gt 0 ]; then
#   echo "✅ PR Info Found:"
#   echo "PR Number:   $(echo "$PR_DATA" | jq -r '.[0].number')"
#   echo "PR Title:    $(echo "$PR_DATA" | jq -r '.[0].title')"
#   echo "PR Author:   $(echo "$PR_DATA" | jq -r '.[0].user.login')"
#   echo "Merged By:   $(echo "$PR_DATA" | jq -r '.[0].merged_by.login')"
#   echo "Source → Target: $(echo "$PR_DATA" | jq -r '.[0].head.ref') → $(echo "$PR_DATA" | jq -r '.[0].base.ref')"
# else
#   echo "⚠️  No PR associated with this commit."
# fi