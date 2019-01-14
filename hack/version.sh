#!/bin/bash

version=$(grep "version: " ./pubspec.yaml)
echo "$version"
versionBuildNumber=$(grep "version: " ./pubspec.yaml | sed /version.*\+/s///g)
echo "build number: $versionBuildNumber"
newVersionBuildNumber=$(($versionBuildNumber + 1))
echo "new build number: $newVersionBuildNumber"
newVersion=$(sed "s/\+.*/+$newVersionBuildNumber/"<<<"$version")
echo "new version: $newVersion"
sed -i "s/$version/$newVersion/" ./pubspec.yaml
