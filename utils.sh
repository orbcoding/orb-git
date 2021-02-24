declare -A forget_args=(
  ['1']='file to forget'
); function forget() { # Completely forget file from local branch history (with confirmation prompt)
	validate_is_repo
	if [ -e "$1" ]; then
		echo -n "Forget $1? y/n: "
		local reply
		read reply
	else
		orb core _raise_error +t "file not found"
		echo 'file not found'
		exit 1
	fi;

	if [[ $reply == 'y' ]]; then
		echo "Forgetting ${path}"
		git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch ${path}" HEAD
	fi
}

function validate_is_repo() { # Check if in git repo
	local validate_is_repo=$([ -d .git ] && echo .git || git rev-parse --git-dir > /dev/null 2>&1)
	[[ -z "$validate_is_repo" ]] && orb core _raise_error 'not in git repo'
}

function pullall() { # Pull all updates including submodules
  git pull && git submodule update && git submodule status
}

# commitall
declare -A commitall_args=(
  ['1']='commit msg'
); function commitall() { #
  # if orb git has_uncommited; then
  #   git add .
  #   git commit -m "$1"
  # fi

  git submodule foreach bash -c "orb git has_uncommitted && git add . && git commit -m \"$1\" || :"
}

function pushall() {
  :
}

function has_uncommitted() {
  ! git diff-index --quiet HEAD --
}
