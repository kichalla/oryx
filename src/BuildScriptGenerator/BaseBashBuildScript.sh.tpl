#!/bin/bash
set -e

SOURCE_DIR=$1
DESTINATION_DIR=$2

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory '$SOURCE_DIR' does not exist." 1>&2
    exit 1
fi

if [ -z "$DESTINATION_DIR" ]
then
    DESTINATION_DIR="$SOURCE_DIR"
fi

# Get full file paths to source and destination directories
cd $SOURCE_DIR
SOURCE_DIR=$(pwd -P)

if [ -d "$DESTINATION_DIR" ]
then
    cd $DESTINATION_DIR
    DESTINATION_DIR=$(pwd -P)
fi

echo
echo "Source directory     : $SOURCE_DIR"
echo "Destination directory: $DESTINATION_DIR"
echo

{{ if BenvArgs | IsNotBlank }}
if [ -f /usr/local/bin/benv ]; then
	source /usr/local/bin/benv {{ BenvArgs }}
fi
{{ end }}

if [ "$SOURCE_DIR" != "$DESTINATION_DIR" ]
then
	if [ -d "$DESTINATION_DIR" ]
	then
		echo
		echo Destination directory is not empty. Deleting content under it ...
		rm -rf "$DESTINATION_DIR"/*
	fi
fi

{{ if PreBuildScriptPath | IsNotBlank }}
# Make sure to cd to the source directory so that the pre-build script runs from there
cd $SOURCE_DIR
echo "{{ PreBuildScriptPrologue }}"
"{{ PreBuildScriptPath }}"
echo "{{ PreBuildScriptEpilogue }}"
{{ end }}

{{ for Snippet in BuildScriptSnippets }}
{{~ Snippet }}
{{ end }}

if [ "$CopyFilesToDestination" != false ]
then
	if [ "$SOURCE_DIR" != "$DESTINATION_DIR" ]
	then
		appTempDir=`mktemp -d`
		cd "$SOURCE_DIR"
		# Use temporary directory in case the destination directory is a subfolder of $SOURCE
		cp -rf `ls -A | grep -v ".git" || echo .` "$appTempDir"
		mkdir -p "$DESTINATION_DIR"
		cd "$appTempDir"
		echo "Copying files to destination '$DESTINATION_DIR'"
		cp -rf . "$DESTINATION_DIR"
	fi
fi

{{ if PostBuildScriptPath | IsNotBlank }}
# Make sure to cd to the source directory so that the post-build script runs from there
cd $SOURCE_DIR
echo "{{ PostBuildScriptPrologue }}"
"{{ PostBuildScriptPath }}"
echo "{{ PostBuildScriptEpilogue }}"
{{ end }}

echo
echo Done.
