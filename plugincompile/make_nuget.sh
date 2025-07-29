url=$(git config --get remote.origin.url)
year=$(date +%Y)

infoLua=$(printf "$1\\%s" "01-info.lua")
echo "infoLua is $infoLua"

# Extract values from info.lua
name=$(grep 'Name' $infoLua | sed -E 's/.*"([^"]+)".*/\1/')
version=$(grep 'Version' $infoLua | sed -E 's/.*"([^"]+)".*/\1/')
build_version=$(grep 'BuildVersion' $infoLua | sed -E 's/.*"([^"]+)".*/\1/')
id=$(grep 'Id' $infoLua | sed -E 's/.*"([^"]+)".*/\1/')
author=$(grep 'Author' $infoLua | sed -E 's/.*"([^"]+)".*/\1/')
description=$(grep 'Description' $infoLua | sed -E 's/.*"([^"]+)".*/\1/')

# echo "folder directory is $1"
# echo "repo name is $2"
# echo "url is $url"

# Example usage
# echo "Name: $name"
# echo "Version: $version"
# echo "BuildVersion: $build_version"
# echo "Id: $id"
# echo "Author: $author"
# echo "Description: $description"

nuspec=$(cat <<EOF
<?xml version="1.0"?>
<package >
  <metadata>
    <id>$2</id>
    <version>$build_version</version>
    <title>$2</title>
    <authors>$author</authors>
    <owners>Aligned Vision Group</owners>
    <license type="expression">GPL-3.0-or-later</license>
    <projectUrl>$url</projectUrl>
    <icon>./assets/images/logo.png</icon>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>$description</description>
    <releaseNotes>AutoGenerateFromGitCommitMessages</releaseNotes>
    <copyright>Copyright $year</copyright>
    <tags>Q-Sys Plugins</tags>
    <summary>$description</summary>
    <readme>README.md</readme>
  </metadata>
</package>
EOF )

echo "$nuspec" > "${1}/content/${2}.nuspec"
$1/.vscode/plugincompile/nuget.exe pack $2.nuspec -outputdirectory $1