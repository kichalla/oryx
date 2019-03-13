cd "$SOURCE_DIR"

# Yarn config is per user, and since the build might run with a non-root account, we make sure
# the yarn cache is set on every build.
YARN_CACHE_DIR=/usr/local/share/yarn-cache
if [ -d $YARN_CACHE_DIR ]
then
	echo
    echo "Configuring Yarn cache folder ..."
    yarn config set cache-folder $YARN_CACHE_DIR
fi

echo
echo Installing packages ...
echo
echo "Running '{{ PackageInstallCommand }}' ..."
echo
{{ PackageInstallCommand }}

{{ if NpmRunBuildCommand | IsNotBlank }}
echo
echo "Running '{{ NpmRunBuildCommand }}' ..."
echo
{{ NpmRunBuildCommand }}
{{ end }}

{{ if NpmRunBuildAzureCommand | IsNotBlank }}
echo
echo "Running '{{ NpmRunBuildAzureCommand }}' ..."
echo
{{ NpmRunBuildAzureCommand }}
{{ end }}

# If source and destination are the same, then we need not zip the contents again, but if they are different
# then we want to copy the zipped node modules to destination directory as this directory could be in a volume share.
if [ "$SOURCE_DIR" != "$DESTINATION_DIR" ]
then
	mkdir -p "$DESTINATION_DIR"

	{{ if ZipNodeModulesDir }}
	echo
	echo Zipping 'node_modules' folder ...
	rm -f "node_modules.zip"
	tar -zcf node_modules.zip node_modules
	cp -f node_modules.zip "$DESTINATION_DIR"
	{{ else }}
	cp -rf node_modules "$DESTINATION_DIR"
	{{ end }}

	echo
	echo "Copying source files to '$DESTINATION_DIR'..."
	cd "$SOURCE_DIR"
	# Do not copy node_modules folder/zip file again
	cp -rf `ls -A | grep -v "node_modules" | grep -v "node_modules.zip"` "$DESTINATION_DIR"

	CopyFilesToDestination=false
fi
