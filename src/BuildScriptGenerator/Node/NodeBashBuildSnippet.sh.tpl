tempSource="/tmp/src"
tempDest="/tmp/dst"

mkdir -p "$tempSource"
mkdir -p "$tempDest"

# Copy source to a 'local' folder in the container for faster builds.
cd "$SOURCE_DIR"
cp -rf . "$tempSource"

{{ if InstallProductionOnlyDependencies }}
if [ -f "$tempSource/package.json" ]; then
	cp -f "$tempSource/package.json" "$tempDest"
fi

if [ -f "$tempSource/package-lock.json" ]; then
	cp -f "$tempSource/package-lock.json" "$tempDest"
fi

if [ -f "$tempSource/yarn.lock" ]; then
	cp -f "$tempSource/yarn.lock" "$tempDest"
fi

echo Installing production-only packages ...
echo
echo "Running '{{ ProductionOnlyPackageInstallCommand }}' ..."
echo

cd "$tempDest"

{{ ProductionOnlyPackageInstallCommand }}

cp -rf node_modules "$tempSource"

{{ end }}

echo Installing packages ...
echo
echo "Running '{{ PackageInstallCommand }}' ..."
echo

cd "$tempSource"
{{ PackageInstallCommand }}

echo
echo "Running '{{ NpmRunBuildCommand }}' ..."
echo
cd "$tempSource"
{{ NpmRunBuildCommand }}

echo
echo "Running '{{ NpmRunBuildAzureCommand }}' ..."
echo
{{ NpmRunBuildAzureCommand }}

{{ if InstallProductionOnlyDependencies }}
echo
echo Copying production only packages ...
echo
cd "$tempDest"
cp -rf node_modules "$DESTINATION_DIR"
	
echo Copying source files ...
cd "$tempSource"
cp -rf `ls -A | grep -v "node_modules"` "$DESTINATION_DIR"
{{ else }}
cd "$tempSource"
cp -rf . "$DESTINATION_DIR"
{{ end }}