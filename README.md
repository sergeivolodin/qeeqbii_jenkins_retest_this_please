### Jenkins auto retest for Qeeqbii team

Do you have a Pull Request open and cannot merge because other people's tests randomly crash? This is the solution

*This script can also be used with other repos, but the very first lines of it must be modified*

1. Create GitHub access token at https://github.com/settings/tokens (need all permissions)
2. Get your commit id and pull request number (example: 19b196c and 311)
3. Run
```
 $ retest_this_please.sh your_username your_access_token your_latest_commit_id your_pr_id
```
4. Wait and see the magic happen! The script will trigger rebuild on each failed build associated with this commit.
5. On success it will try to merge the PR
