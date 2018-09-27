write-host "`n  ## NODEJS INSTALLER ## `n"

### CONFIGURATION

# nodejs
$version = "4.4.7-x64"
$url = "https://nodejs.org/dist/v8.12.0/node-v8.12.0-x64.msi"

# npm packages
$gulp_version = ">=1.2.2 <1.3.0"



# activate / desactivate any install
$install_node = $TRUE
$install_git = $FALSE
$install_gulp = $FALSE
$install_jspm = $FALSE
$install_eslint = $FALSE

write-host "`n----------------------------"
write-host " system requirements checking  "
write-host "----------------------------`n"

### require administator rights

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   write-Warning "This setup needs admin permissions. Please run this file as admin."     
   break
}

### nodejs version check

if (Get-Command node -errorAction SilentlyContinue) {
    $current_version = (node -v)
}
 

write-host "`n"



if ($install_node) {
    
    ### download nodejs msi file
    # warning : if a node.msi file is already present in the current folder, this script will simply use it
        
    write-host "`n----------------------------"
    write-host "  nodejs msi file retrieving  "
    write-host "----------------------------`n"

    $filename = "node.msi"
    $node_msi = "$PSScriptRoot\$filename"
    
    $download_node = $TRUE

    
    if ($download_node) {
        write-host "[NODE] downloading nodejs install"
        write-host "url : $url"
        $start_time = Get-Date
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($url, $node_msi)
        write-Output "$filename downloaded"
        write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
    } else {
        write-host "using the existing node.msi file"
    }

    ### nodejs install

    write-host "`n----------------------------"
    write-host " nodejs installation  "
    write-host "----------------------------`n"

    write-host "[NODE] running $node_msi"
    Start-Process $node_msi /qn
    
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    
} else {
    write-host "Proceeding with the previously installed nodejs version ..."
}

### npm packages install

write-host "`n----------------------------"
write-host " npm packages installation  "
write-host "----------------------------`n"

if (Get-Command gulp -errorAction SilentlyContinue) {
    $gulp_prev_v = (gulp -v)
}

if ($gulp_prev_v) {
    write-host "[GULP] Gulp is already installed :"
    write-host $gulp_prev_v
    
    $confirmation = read-host "Are you sure you want to replace this version ? [y/N]"
    if ($confirmation -ne "y") {
        $install_gulp = $FALSE
    }
}

if ($install_gulp) {
    write-host "Installing gulp-cli"
    npm install --global gulp-cli@"$gulp_version"
}

if (Get-Command jspm -errorAction SilentlyContinue) {
    $jspm_prev_v = (jspm -v)
}

if ($jspm_prev_v) {
    write-host "[JSPM] jspm is already installed :"
    write-host $jspm_prev_v
    
    $confirmation = read-host "Are you sure you want to replace this version ? [y/N]"
    if ($confirmation -ne "y") {
        $install_jspm = $FALSE
    }
}

if ($install_jspm) {
    write-host "Installing jspm globally"
    npm install --global jspm
}


if (Get-Command eslint -errorAction SilentlyContinue) {
    $eslint_prev_v = (eslint -v)
}

if ($eslint_prev_v) {
    write-host "[ESLINT] eslint is already installed :"
    write-host $eslint_prev_v

    $confirmation = read-host "Are you sure you want to replace this version ? [y/N]"
    if ($confirmation -ne "y") {
        $install_eslint = $FALSE
    }
}

if ($install_eslint) {
    write-host "Installing eslint globally"
    npm install --global eslint
}



write-host "Done !"

#$acctKey = ConvertTo-SecureString -String "3eaDeDNH50phwz8ykd9jE4sKlweV2fRFtxh4raTE/H5r9oImpnZLC1LXgbG54prjwKqaQi4KyAzm/tkAbY88GQ==" -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\webfiles09", $acctKey
#New-PSDrive -Name Z -PSProvider FileSystem -Root "\\webfiles09.file.core.windows.net\web" -Credential $credential -Persist
#net use Z: \\webfiles09.file.core.windows.net\web /u:AZURE\webfiles09 3eaDeDNH50phwz8ykd9jE4sKlweV2fRFtxh4raTE/H5r9oImpnZLC1LXgbG54prjwKqaQi4KyAzm/tkAbY88GQ==
#net use Z: \\webfiles09.file.core.windows.net\webtest /u:AZURE\webfiles09 3eaDeDNH50phwz8ykd9jE4sKlweV2fRFtxh4raTE/H5r9oImpnZLC1LXgbG54prjwKqaQi4KyAzm/tkAbY88GQ==
net use Z: \\webfiles09.file.core.windows.net\wtest /u:AZURE\webfiles09 3eaDeDNH50phwz8ykd9jE4sKlweV2fRFtxh4raTE/H5r9oImpnZLC1LXgbG54prjwKqaQi4KyAzm/tkAbY88GQ==
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
New-Item -ItemType directory -Path D:\test
Copy-Item Z:\test -Destination D:\test -Recurse
cd D:\test\test
npm i
node index
