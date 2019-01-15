#!/bin/bash

set -x

version=$(grep "version: " ./pubspec.yaml)
echo "$version"
versionBuildNumber=$(grep "version: " ./pubspec.yaml | sed /version.*\+/s///g)
echo "build number: $versionBuildNumber"
newVersionBuildNumber=$(($versionBuildNumber + 1))
echo "new build number: $newVersionBuildNumber"
newVersion=$(sed "s/\+.*/+$newVersionBuildNumber/"<<<"$version")
echo "new version: $newVersion"

if [ "$(uname)" == "Darwin" ]; then
    sed -i '' "s/$version/$newVersion/" ./pubspec.yaml
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sed -i "s/$version/$newVersion/" ./pubspec.yaml
fi