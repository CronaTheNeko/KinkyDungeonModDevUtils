#!/bin/bash

# Archive name
name_p1="../builds/ModDevUtils"
name_p2=".zip"
# Check for argument
if [[ -z $1 ]]; then
	>&2 echo "Version (such as V123) required!"
	exit 1
fi
# Put together the file name
filename="${name_p1}-$1${name_p2}"
# CD to script's directory to easily work with zip
cd $(dirname $0)
# Remove old archives if they exist
[ -e "${filename}" ] && rm "${filename}"
# Zip full version of mod
zip -qr "${filename}" * -x "*.sh"
