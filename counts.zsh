# work out the current branch name
currentbranch=$(expr $(git symbolic-ref HEAD) : 'refs/heads/\(.*\)')
[ -n "$currentbranch" ] || die "You don't seem to be on a branch"

echo "branch name $currentbranch"

# look up this branch in the configuration
remote=$(git config branch.$currentbranch.remote)
remote_ref=$(git config branch.$currentbranch.merge)

echo "remote '$remote', remote ref '$remote_ref'"

if [[ -n $remote ]]; then
  # convert the remote ref into the tracking ref... this is a hack
  remote_branch=$(expr $remote_ref : 'refs/heads/\(.*\)')
  tracking_branch=refs/remotes/$remote/$remote_branch

  # now $tracking_branch should be the local ref tracking HEAD
  echo "$tracking_branch"
  ahead=$(git rev-list $tracking_branch..HEAD | wc -l | tr -d ' ')
  behind=$(git rev-list HEAD..$tracking_branch | wc -l | tr -d ' ')
  echo "⬆ $ahead : ⬇ $behind"
fi