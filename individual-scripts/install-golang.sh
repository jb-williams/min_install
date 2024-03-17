#!/usr/bin/env bash
#
usageMessage () {
  CMD_ECHO="${GBL_ECHO:-echo -e }"
  #[[ "_${SHCODE}" == "_korn" ]] && typeset CMD_ECHO="${GBL_ECHO:-echo -e }"
  [[ "_${SHCODE}" == "_bash" ]] && declare CMD_ECHO="${GBL_ECHO:-echo -e }"
  ${CMD_ECHO} ""
  ${CMD_ECHO} "${1:+Program: ${1}}${2:+        }"
  ${CMD_ECHO} ""
  ${CMD_ECHO} "\tVersion: ${VERSION}"
  ${CMD_ECHO} "
This program checks if the local Alacritty repo is behind, if so, pull latest,
build and copy the binary, manuals, and icon files to the proper directories.

Usage: ${1##*/} [-?hvV]

  Where:
    -v = Version -- show current version, then exit 
    -V = Verbose -- debug output displayed
    -h = Help	 -- display this message
    -? = Help	 -- display this message

Author: Jb Williams (jb.williams016@gmail.com)
"
}

checkUpdate () {
	# check if remote repo is ahead of local repo
	posibleUpdate="$(/usr/bin/git remote update &>/dev/null && /usr/bin/git status -uno | /usr/bin/grep -o "up to date")"
	if [[ "${posibleUpdate}" == "up to date" ]]; then
		printf "Git Repo already up to date!" && exit 0
	else
		printf "Seems there is an update! Continue?(Y/n): "
		read -r -n 1
		if [[ "$REPLY" =~ ^[Yy]$ ]]; then
			return
		else
			printf "%s\n" "Not updating Local Repo!" && exit 0
		fi
	fi
	return
}

changePerm () {
	## takes in file name if its the binary 755, if man 644
	if [[ "$(echo "${1}" | /usr/bin/awk -F'/' '{print $NF}')" == "alacritty" ]]; then
		/usr/bin/sudo chmod u=rwx,g=rx,o=rx "${1}" || printf "%s %s!\n" "failed changing perm on" "${1}${2}"
	elif [[ "$(echo "${1}" | /usr/bin/awk -F'.' '{print $NF}')" == "gz" ]]; then
		/usr/bin/sudo chmod u=rw,g=r,o=r  "${1}" || printf "%s %s!\n" "failed changing perm on" "${1}"
	else
		printf "%s!\n" "some error, wasn't passed anything named 'alacritty' or 'gz'" && exit 2
	fi
	return
}

copyFile () {
	sudo /usr/bin/cp "${1}" "${2}" || printf "%s %s %s!\n" "failed to copy" "${1}" "${2}"
	return
}

buildBin () {
	/usr/bin/git pull || exit 1
	~/.cargo/bin/cargo build --release --no-default-features --features=x11 || exit 1
	return
}

buildMan () {
	oldFilename="${1}"
	newFilename="$(echo "${oldFilename}" |/usr/bin/awk -F'.' '{print $1"."$2}')"
	whichMan="$(echo "${newFilename}" | /usr/bin/awk -F'.' '{print $2}')"
	/usr/bin/scdoc < "${oldFilename}" >> "$newFilename" || printf "%s %s!\n" "failed making sdoc from" "${oldFilename}"
	/usr/bin/gzip "${newFilename}" || printf "%s %s!\n" "failed gzipping" "${newFilename}"
	return
}

VERSION="0.1"
VERBOSE="FALSE"
CHK_VERS="FALSE"

while getopts ":vVh?" OPTION
do
	case "${OPTION}" in
		'v') CHK_VERS="TRUE";;
		'V') VERBOSE="TRUE";;
		'?') usageMessage "${0}" && exit 1 ;;
		'h') usageMessage "${0}" && exit 1 ;;
		#':') usageMessage && exit 1 ;;
	esac
done

shift "$($OPTIND - 1)"
#shift $(( $OPTIND - 1 ))

[[ $VERBOSE == TRUE ]] && set -x
[[ "$CHK_VERS" == "TRUE" ]] && printf "#\n%s\n" "# ${0}"
[[ "$CHK_VERS" == "TRUE" ]] && printf "%s\n" "## Version........: ${VERSION}" && exit 0

# go to alacritty git repo
cd "${HOME}"/Gits/alacritty || exit 1
# check if local repo is behind
checkUpdate || exit 1

binDest="/usr/loca/bin/"
binFile="target/release/alacritty"
man1Dest="/usr/share/man/man1/"
man5Dest="/usr/share/man/man5/"
alacrittyManFiles=("extra/man/alacritty.1.scd
extra/man/alacritty-msg.1.scd
extra/man/alacritty.5.scd
extra/man/alacritty-bindings.5.scd
")

# Make sure man dirs are created
sudo mkdir -p /usr/local/share/man/man1 \
	/usr/local/share/man/man5 || exit 1


# compile binary
buildBin || exit 1

# change perm of binary
changePerm "${binFile}" || exit

# copy binary to destination
copyFile "${binFile}" "${binDest}" || exit 1

# build man files
for manFile in "${alacrittyManFiles[@]}"; do
	buildMan "${manFile}" || exit 1
done

# change file permissions then copy them to proper man destination
for manFile in "${alacrittyManFiles[@]}"; do
	gzFile="$(/usr/bin/ls "${manFile}" | awk -F'.' '{print $1"."$2".gz"}')"
	whichMan="$(/usr/bin/ls "${manFile}" | awk -F'.' '{print $2}')"
	changePerm "${gzFile}" || exit 1
	if  [[ "${whichMan}"  == 1 ]]; then
		copyFile "${gzFile}" "${man1Dest}" || exit 1
	elif  [[ "$whichMan"  == 5 ]]; then
		copyFile "${gzFile}" "${man5Dest}" || exit 1
	fi
done

# install desktop file and update-desktop database
/usr/bin/sudo desktop-file-install extra/linux/Alacritty.desktop \
	&& /usr/bin/sudo update-desktop-database

# Copy icon file to proper spot
/usr/bin/sudo cp extra/logo/alacritty-term+scanlines.svg /usr/share/pixmaps/Alacritty.svg \
	&& /usr/bin/sudo chmod u=rw,g=r,o=r /usr/share/pixmaps/Alacritty.svg

cd "${OLDPWD}" || exit 1
exit 0

## requires
# * cmake
## * pkg_config
# * libfontconfig1-dev
