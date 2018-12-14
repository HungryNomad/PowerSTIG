<###############

Converts Manual STIG XCCDF to CKL
using the STIG Viewer.jar and sendKey
Must be opened in ISE not powershell CL

Only tested on Viewer version 2.8

###############>

$viewerTitle = "DISA STIG Viewer : 2.8 :"
$viewerTitleExplorer = "DISA STIG Viewer : 2.8 : STIG Explorer"
$viewerTitleOverwrite = "STIG Overwrite Warning!"
$viewerTitleNew = "DISA STIG Viewer : 2.8 : *New Checklist"

#Adjust the launch wait for Java
$sleepTimer = 10

# Check if running in ISE
# - Not implemented yet

# Open File Dialog to choose STIG Viewer (Requires ISE)
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'STIG Viewer 2.8 (*.jar)|*.jar'
    Title = "Select the STIG Viewer 2.8 applet"
}
if ($FileBrowser.ShowDialog()){
    $stigViewer = $FileBrowser.FileName
}

# GUI, get starting folder
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
$folder = $null
$foldername = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    rootfolder = "MyComputer"
    Description = "Choose base folder that contains all of the Manual STIG XML files that you want to scan"
}

if($foldername.ShowDialog() -eq "OK") {
    $folder += $foldername.SelectedPath
}
# Non-recursive .xml file search
$xmlFiles = Get-ChildItem -Path $folder -Filter "*.xml"

# Setup for active window detection
$code = @'
    [DllImport("user32.dll")]
     public static extern IntPtr GetForegroundWindow();
'@
Add-Type $code -Name Utils -Namespace Win32
$wshell = New-Object -ComObject wscript.shell;

# Sloppy one-liner but it should work
function Get-ActvieTitle() {
    (Get-Process | 
        Where-Object { $_.mainWindowHandle -eq ([Win32.Utils]::GetForegroundWindow()) } | 
        Select-Object processName, MainWindowTItle, MainWindowHandle ).MainWindowTitle
    }

# Itterate through 
foreach ($xmlFile in $xmlFiles.fullname) {

    # Launch STIG Viewer
    & $stigViewer
    sleep -Seconds $sleepTimer
    # From STIG Explorer delete all listed STIGs
    if (Get-ActvieTitle -like "$viewerTitleExplorer"){
        $wshell.SendKeys('{TAB}{TAB}^a+{F10}{ESC}{UP}~')
    }
    sleep 1

    # STIG Open Menu
    if (Get-ActvieTitle -like "$viewerTitleExplorer"){
        $wshell.SendKeys('%')
        $wshell.SendKeys('{DOWN}{DOWN}{ENTER}')
        sleep 3
        # Paste in current STIG file
        $wshell.SendKeys("$xmlFile")
        $wshell.SendKeys('~')
    }
    sleep 1.5

    # Check STIG box
    if (Get-ActvieTitle -like "$viewerTitleExplorer"){
        $wshell.SendKeys('~+{F10}{ESC}{DOWN}~')
        $wshell.SendKeys('%')
        $wshell.SendKeys('{RIGHT}{RIGHT}{DOWN}{DOWN}{DOWN}{ENTER}')
    }
    sleep 1.5

    # Save the file
    if (Get-ActvieTitle -like "$viewerTitleNew"){
        $wshell.SendKeys('%')
        $wshell.SendKeys('{DOWN}{DOWN}{ENTER}')
        sleep 1.5
        $wshell.SendKeys("$($xmlFile.TrimEnd('.xml'))")
        $wshell.SendKeys('~')
    }
    sleep 1.5

    # Quit App
    if (Get-ActvieTitle -like "$viewerTitle*"){
        $wshell.SendKeys('+{F10}{UP}{UP}~')
    }
    sleep 1.5

} # Repeat
