function StopErrorsInPowerShellFromGitCommands()
{

    ##https://github.com/dahlbyk/posh-git/issues/109
    ##https://stackoverflow.com/a/47232450
    $env:GIT_REDIRECT_STDERR = '2>&1'
}

function GetLastReleaseVersion(){
    return git tag | sort -descending | Select-Object -First 1
}

function CreateTag($version, $message, $commit)
{
    git tag -a $version -m "$message" $commit
    git push --tags 
}


function GetComparedVersions($prevousRelease, $currentRelease){
    
    $remoteUrl = git config --get remote.origin.url;
    $projectUrl = $remoteUrl.Replace(".git","")

    return "$projectUrl/compare/$prevousRelease...$currentRelease";
}


function CreateRelease($version, $message, $commit)
{
    StopErrorsInPowerShellFromGitCommands
    $LastReleaseVersion = GetLastReleaseVersion;
    CreateTag $version $message $commit;
    return GetComparedVersions $LastReleaseVersion $version
}
