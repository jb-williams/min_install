#!/usr/bin/env bash
# MIT License
# Copyright (c) 2023 Jb Williams
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Get Golang Version and the Given Golang Hash for linux
GO_DLPAGE="$(/usr/bin/curl https://go.dev/dl/ | /usr/bin/grep -iE 'href="/dl/go[0-9].[0-9]{2}.[0-9]{1,2}.linux-amd64.tar.gz"' -m 2 -A 6 | tail -7 | sed -e 's/<[^>]*.//g' | tr '\n' ' ')"
GO_VERSION="$(printf "%s" "$GO_DLPAGE" | awk '{print $1}')"
#GO_VERSION="$(echo "$GO_DLPAGE" | awk '{print $1}')"
DL_HASH="$(printf "%s" "$GO_DLPAGE" | awk '{print $6}')"

# Prompt User, asking if they want to continue
#echo "Your version of golang is '$(go version 2>/dev/null)'"
printf "%s!\n" "Your version of golang is '$(go version 2>/dev/null)'"
read -p "Curl read the current version as $GO_VERSION : Would you like to Continue?(Y/n): " -n 1 -r
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
	# Download to  $TEMP dir
    #pushd /tmp || exit 1
	cd $TEMP || exit || exit 1
    /usr/bin/wget https://go.dev/dl/"$GO_VERSION" || exit 1

	# get sha256 of the file you are wanting to verify
	if [[ -n "$GO_VERSION" ]] && [[ -f "$GO_VERSION" ]] && [[ ! -d "$GO_VERSION" ]]; then
		TAR_HASH="$(shasum -a256 "$GO_VERSION" | awk '{print $1}')"
		[[ "$TAR_HASH" ]] || exit 1
	else
		#echo "Unable to find the '.tar.gz', may have been an error downloading!"
		printf "%s\n" "Unable to find the '.tar.gz', may have been an error downloading!"
		#popd || exit 1
		cd "$OLDPWD" || exit 1
		exit 1
	fi

	# Check if the Golang .tar.gz's hash matches the given hash from the download page
	if [[ "$DL_HASH" == "$TAR_HASH" ]]; then
		# Decompress and move to proper place removing the older version if it exists
		printf "%s!\n" "Hashes Match"
		/usr/bin/tar xfz "$GO_VERSION" || exit 1
		if [[ -d /usr/local/go ]]; then
			/usr/bin/sudo rm -rf /usr/local/go || exit 1
			/usr/bin/sudo mv go /usr/local/ || exit 1
			/usr/bin/rm "$GO_VERSION" || exit 1
		else 
			/usr/bin/sudo mv go /usr/local/ || exit 1
			/usr/bin/rm "$GO_VERSION" || exit 1
		fi
	else
		# Abort if the .tar.gz's hash doesn't match the given hash from the download page
		printf "%s!!!!\n" "HASHES DON'T MATCH!!! ABORTING!!"
		rm "$GO_VERSION" || exit 1
	fi
    #popd || return
	cd "$OLDPWD" || exit 1
else
    printf "\n" && exit 0
fi
exit 0

