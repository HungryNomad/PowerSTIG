<#

CheckListTool v2.10 - Made by HungryNomad

If using this for the first time, make a copy of all of your checklists before running this
tool against them. It can make bulk changes to all of your files. 

Notes: This is a tool that combines many of my random scripts and should hopefully automate 
many of the tasks involved in dealing with SCAPs and STIGs. It's far from perfect as I don't
have many people testing my scripts just yet. My error handling could also be improved. 

Change log
2.9 Added HTML save output on Vuln ID menu
2.8 POAM filtering added
2.7 Supports renaming and upgrading from different versions
2.6 Added multi-select for all menus (for copy and paste)

To-do list:
- Add weighted score: Score = (F1(W1)+F2(W1)+F3(W3))/(W1+W2+W3)
    F1 = CAT1... For each group: F = (NF+NA)/(O+NF+NA+NR)
    W1=10, W2=4, W3=1
- Add better overview screen
 

#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '863,462'
$Form.text                       = "WPC's Checklist Tool v2.9"
$Form.TopMost                    = $false

$ButtonFolderSelect              = New-Object system.Windows.Forms.Button
$ButtonFolderSelect.text         = "Choose CKL Folder"
$ButtonFolderSelect.width        = 180
$ButtonFolderSelect.height       = 30
$ButtonFolderSelect.location     = New-Object System.Drawing.Point(17,24)
$ButtonFolderSelect.Font         = 'Microsoft Sans Serif,10'

$ButtonScanCKL                   = New-Object system.Windows.Forms.Button
$ButtonScanCKL.text              = "Scan CKL Files"
$ButtonScanCKL.width             = 180
$ButtonScanCKL.height            = 30
$ButtonScanCKL.enabled           = $false
$ButtonScanCKL.location          = New-Object System.Drawing.Point(19,162)
$ButtonScanCKL.Font              = 'Microsoft Sans Serif,10'

$TextCklFolder                   = New-Object system.Windows.Forms.TextBox
$TextCklFolder.multiline         = $true
$TextCklFolder.text              = "Scan Folder"
$TextCklFolder.width             = 180
$TextCklFolder.height            = 80
$TextCklFolder.enabled           = $false
$TextCklFolder.location          = New-Object System.Drawing.Point(18,69)
$TextCklFolder.Font              = 'Microsoft Sans Serif,10'

$ButtonRemoveCKL                 = New-Object system.Windows.Forms.Button
$ButtonRemoveCKL.text            = "Remove CKLs"
$ButtonRemoveCKL.width           = 180
$ButtonRemoveCKL.height          = 30
$ButtonRemoveCKL.enabled         = $false
$ButtonRemoveCKL.location        = New-Object System.Drawing.Point(17,252)
$ButtonRemoveCKL.Font            = 'Microsoft Sans Serif,10'

$TextLog                         = New-Object system.Windows.Forms.TextBox
$TextLog.multiline               = $true
$TextLog.text                    = "Choose a CKL folder to get started"
$TextLog.width                   = 443
$TextLog.height                  = 80
$TextLog.enabled                 = $false
$TextLog.location                = New-Object System.Drawing.Point(177,357)
$TextLog.Font                    = 'Consolas,10,style=Bold'

$ButtonRemoveDuplicateCKLs       = New-Object system.Windows.Forms.Button
$ButtonRemoveDuplicateCKLs.text  = "Remove Duplicate CKLs"
$ButtonRemoveDuplicateCKLs.width  = 180
$ButtonRemoveDuplicateCKLs.height  = 30
$ButtonRemoveDuplicateCKLs.enabled  = $false
$ButtonRemoveDuplicateCKLs.location  = New-Object System.Drawing.Point(18,207)
$ButtonRemoveDuplicateCKLs.Font  = 'Microsoft Sans Serif,10'

$ButtonXCCDFFolder               = New-Object system.Windows.Forms.Button
$ButtonXCCDFFolder.text          = "Choose XCCDF Folder"
$ButtonXCCDFFolder.width         = 200
$ButtonXCCDFFolder.height        = 30
$ButtonXCCDFFolder.enabled       = $false
$ButtonXCCDFFolder.location      = New-Object System.Drawing.Point(206,24)
$ButtonXCCDFFolder.Font          = 'Microsoft Sans Serif,10'

$ButtonImportXCCDF               = New-Object system.Windows.Forms.Button
$ButtonImportXCCDF.text          = "Import ACAS XCCDF results"
$ButtonImportXCCDF.width         = 200
$ButtonImportXCCDF.height        = 30
$ButtonImportXCCDF.enabled       = $false
$ButtonImportXCCDF.location      = New-Object System.Drawing.Point(207,162)
$ButtonImportXCCDF.Font          = 'Microsoft Sans Serif,10'

$ButtonImportSomeXCCDF           = New-Object system.Windows.Forms.Button
$ButtonImportSomeXCCDF.text      = "Import some XCCDF results"
$ButtonImportSomeXCCDF.width     = 200
$ButtonImportSomeXCCDF.height    = 30
$ButtonImportSomeXCCDF.enabled   = $false
$ButtonImportSomeXCCDF.location  = New-Object System.Drawing.Point(207,207)
$ButtonImportSomeXCCDF.Font      = 'Microsoft Sans Serif,10'

$ButtonNotReviewed               = New-Object system.Windows.Forms.Button
$ButtonNotReviewed.text          = "Not Reviewed"
$ButtonNotReviewed.width         = 180
$ButtonNotReviewed.height        = 30
$ButtonNotReviewed.enabled       = $false
$ButtonNotReviewed.location      = New-Object System.Drawing.Point(419,70)
$ButtonNotReviewed.Font          = 'Microsoft Sans Serif,10'

$ButtonOpenNoComment             = New-Object system.Windows.Forms.Button
$ButtonOpenNoComment.text        = "Open No Comments"
$ButtonOpenNoComment.width       = 180
$ButtonOpenNoComment.height      = 30
$ButtonOpenNoComment.enabled     = $false
$ButtonOpenNoComment.location    = New-Object System.Drawing.Point(419,116)
$ButtonOpenNoComment.Font        = 'Microsoft Sans Serif,10'

$ButtonVulnID                    = New-Object system.Windows.Forms.Button
$ButtonVulnID.text               = "POAM Info by Vuln ID"
$ButtonVulnID.width              = 180
$ButtonVulnID.height             = 30
$ButtonVulnID.enabled            = $false
$ButtonVulnID.location           = New-Object System.Drawing.Point(419,206)
$ButtonVulnID.Font               = 'Microsoft Sans Serif,10'

$ButtonOpenHost                  = New-Object system.Windows.Forms.Button
$ButtonOpenHost.text             = "Requesting POAM"
$ButtonOpenHost.width            = 180
$ButtonOpenHost.height           = 30
$ButtonOpenHost.enabled          = $false
$ButtonOpenHost.location         = New-Object System.Drawing.Point(419,252)
$ButtonOpenHost.Font             = 'Microsoft Sans Serif,10'

$Button8                         = New-Object system.Windows.Forms.Button
$Button8.text                    = "Export raw info to HTML"
$Button8.width                   = 180
$Button8.height                  = 30
$Button8.enabled                 = $false
$Button8.location                = New-Object System.Drawing.Point(419,293)
$Button8.Font                    = 'Microsoft Sans Serif,10'

$TextXCCDFFolder                 = New-Object system.Windows.Forms.TextBox
$TextXCCDFFolder.multiline       = $true
$TextXCCDFFolder.text            = "XCCDF Folder"
$TextXCCDFFolder.width           = 200
$TextXCCDFFolder.height          = 80
$TextXCCDFFolder.enabled         = $false
$TextXCCDFFolder.location        = New-Object System.Drawing.Point(207,69)
$TextXCCDFFolder.Font            = 'Microsoft Sans Serif,10'

$Button9                         = New-Object system.Windows.Forms.Button
$Button9.text                    = "Refresh ?"
$Button9.width                   = 200
$Button9.height                  = 30
$Button9.enabled                 = $false
$Button9.location                = New-Object System.Drawing.Point(207,252)
$Button9.Font                    = 'Microsoft Sans Serif,10'

$ButtonBlankHostName             = New-Object system.Windows.Forms.Button
$ButtonBlankHostName.text        = "Blank Host Name"
$ButtonBlankHostName.width       = 180
$ButtonBlankHostName.height      = 30
$ButtonBlankHostName.enabled     = $false
$ButtonBlankHostName.location    = New-Object System.Drawing.Point(419,24)
$ButtonBlankHostName.Font        = 'Microsoft Sans Serif,10'

$Button11                        = New-Object system.Windows.Forms.Button
$Button11.text                   = "Clone Master CKL to other CKLs"
$Button11.width                  = 230
$Button11.height                 = 30
$Button11.enabled                = $false
$Button11.location               = New-Object System.Drawing.Point(616,298)
$Button11.Font                   = 'Microsoft Sans Serif,10'

$Button12                        = New-Object system.Windows.Forms.Button
$Button12.text                   = "Create Master GPO for a STIG"
$Button12.width                  = 230
$Button12.height                 = 30
$Button12.enabled                = $false
$Button12.location               = New-Object System.Drawing.Point(615,26)
$Button12.Font                   = 'Microsoft Sans Serif,10'

$Button                          = New-Object system.Windows.Forms.Button
$Button.text                     = "Create GPO from  some STIGs"
$Button.width                    = 230
$Button.height                   = 30
$Button.enabled                  = $false
$Button.location                 = New-Object System.Drawing.Point(616,82)
$Button.Font                     = 'Microsoft Sans Serif,10'

$ButtonAllOpen                   = New-Object system.Windows.Forms.Button
$ButtonAllOpen.text              = "All Open Vulnerabilities"
$ButtonAllOpen.width             = 180
$ButtonAllOpen.height            = 30
$ButtonAllOpen.enabled           = $false
$ButtonAllOpen.location          = New-Object System.Drawing.Point(419,162)
$ButtonAllOpen.Font              = 'Microsoft Sans Serif,10'

$ButtonHostList                  = New-Object system.Windows.Forms.Button
$ButtonHostList.text             = "Get Host List per STIG"
$ButtonHostList.width            = 230
$ButtonHostList.height           = 30
$ButtonHostList.enabled          = $false
$ButtonHostList.location         = New-Object System.Drawing.Point(615,139)
$ButtonHostList.Font             = 'Microsoft Sans Serif,10'

$ButtonSTIGList                  = New-Object system.Windows.Forms.Button
$ButtonSTIGList.text             = "Get STIG List per Host"
$ButtonSTIGList.width            = 230
$ButtonSTIGList.height           = 30
$ButtonSTIGList.enabled          = $false
$ButtonSTIGList.location         = New-Object System.Drawing.Point(615,193)
$ButtonSTIGList.Font             = 'Microsoft Sans Serif,10'

$ButtonUpgradeCKL                = New-Object system.Windows.Forms.Button
$ButtonUpgradeCKL.text           = "Upgrade Checklists"
$ButtonUpgradeCKL.width          = 180
$ButtonUpgradeCKL.height         = 30
$ButtonUpgradeCKL.enabled        = $false
$ButtonUpgradeCKL.location       = New-Object System.Drawing.Point(16,295)
$ButtonUpgradeCKL.Font           = 'Microsoft Sans Serif,10'

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Convert Manual STIG to CKL"
$Button1.width                   = 230
$Button1.height                  = 30
$Button1.enabled                 = $false
$Button1.location                = New-Object System.Drawing.Point(615,246)
$Button1.Font                    = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($ButtonFolderSelect,$ButtonScanCKL,$TextCklFolder,$ButtonRemoveCKL,$TextLog,$ButtonRemoveDuplicateCKLs,$ButtonXCCDFFolder,$ButtonImportXCCDF,$ButtonImportSomeXCCDF,$ButtonNotReviewed,$ButtonOpenNoComment,$ButtonVulnID,$ButtonOpenHost,$Button8,$TextXCCDFFolder,$Button9,$ButtonBlankHostName,$Button11,$Button12,$Button,$ButtonAllOpen,$ButtonHostList,$ButtonSTIGList,$ButtonUpgradeCKL,$Button1))

$ButtonFolderSelect.Add_Click({ Get-CKLFolder })
$ButtonScanCKL.Add_Click({ Scan-CLKFolder })
$ButtonRemoveDuplicateCKLs.Add_Click({ Remove-DupCKLs })
$ButtonRemoveCKL.Add_Click({ Remove-CKL })
$ButtonAllOpen.Add_Click({ View-AllOpen })
$ButtonBlankHostName.Add_Click({ View-BlankHostName })
$ButtonNotReviewed.Add_Click({ View-NotReviewed })
$ButtonOpenNoComment.Add_Click({ View-OpenNoComment })
$ButtonHostList.Add_Click({ View-HostList })
$ButtonSTIGList.Add_Click({ View-STIGList })
$ButtonOpenHost.Add_Click({ View-OpenHost })
$ButtonVulnID.Add_Click({ View-VulnID })
$ButtonXCCDFFolder.Add_Click({ Get-XCCDFFolder })
$ButtonImportXCCDF.Add_Click({ Import-XCCDF })
$ButtonImportSomeXCCDF.Add_Click({ Import-SomeXCCDF })
$ButtonUpgradeCKL.Add_Click({ Upgrade-CKL })

function View-VulnID { 
    Disable-Buttons
    while (1){
        $choice1 = $VIDmenu | Out-GridView -PassThru -Title "All Vulnerabilities by Vuln ID"
        if ($choice1){
            $saveData = $ScanDetails | Where-Object {$choice1.VulnID -contains $_.VID} | 
                Select-Object -Property VID,host,stig,Severity,Title,status,FINDING_DETAILS,COMMENTS,location |                     
                Out-GridView -PassThru -Title "$($choice1.VulnID) $($choice1.Title)"
            if ($saveData){
                $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
                $SaveFileDialog.initialDirectory = $initialDirectory
                $SaveFileDialog.filter = “Text files (*.html)|*.html|All files (*.*)|*.*”
                $SaveFileDialog.ShowDialog() | Out-Null
                $SaveFileDialog.filename
                if ($SaveFileDialog.FileName){
                    $saveData | ConvertTo-Html | Out-File -FilePath $SaveFileDialog.FileName
                    $SaveFileDialog.FileName | clip
                }
            }


        }else{break}   
    }

    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons
}

function View-AllOpen { 
    Disable-Buttons
    while (1){
        $choice1 = $AVmenu | Out-GridView -PassThru -Title "All Open Vulnerabilities"
        if ($choice1) {
            $subMenu = $null
            while(1){
                $choice2 = $openVulns | Where-Object {
                    $choice1.Host -contains $_.Host -and
                    $choice1.STIG -contains $_.STIG -and
                    $choice1.Location -contains $_.Location
                } | Out-GridView -PassThru -Title "Pick a VulnID to see other affected systems"

                if ($choice2){
                    $ScanDetails | Where-Object {$choice2.VID -contains $_.VID} | 
                        Select-Object -Property host,stig,status,FINDING_DETAILS,COMMENTS,location |                     
                        Out-GridView -PassThru -Title "$($choice2.VID) $($choice2.Title)" 
                }else{break}   
            }
        }else{break}   
    }

    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons

}

function Upgrade-CKL { 
    Disable-Buttons
    # Display the list and let the user choose
    $upgradeList = $upgradableCKL | Out-GridView -OutputMode Multiple -Title "Old checklists detected, which ones do you want to upgrade?"

    # Based on your selection above, upgrade to the latest CKLs
    foreach ($upgrade in $upgradeList){

        # Pull in old CKL
        $xmlFile = $upgrade.location
        [xml]$xml = gc $xmlFile

        # Rename it as a fallback
        Rename-Item -path $upgrade.location -newname "$($upgrade.location).bak"

        # Pull in lasted CKL
        $benchXmlFile = $latestCKL | ?{$_.STIG -match $upgrade.STIG}
        [xml]$benchXml = gc $benchXmlFile.location

        # Copy Host info into the Benchmark CKL
        $benchXml.CHECKLIST.ASSET.HOST_NAME = $xml.CHECKLIST.ASSET.HOST_NAME
        $benchXml.CHECKLIST.ASSET.HOST_IP = $xml.CHECKLIST.ASSET.HOST_IP
        $benchXml.CHECKLIST.ASSET.HOST_MAC = $xml.CHECKLIST.ASSET.HOST_MAC
        $benchXml.CHECKLIST.ASSET.HOST_FQDN = $xml.CHECKLIST.ASSET.HOST_FQDN

        Write-Host -NoNewline "`nUpdating $($upgrade.host) - $($benchXmlFile.STIG) to V$($benchXmlFile.STIG_VER)R$($benchXmlFile.STIG_REV) "

        # Iterate through the vulns and copy over if it matches
        for ($i= 0; $i -lt $benchXml.CHECKLIST.STIGS.iSTIG.VULN.Count; $i++){

            # Vuln-ID
            Write-host -NoNewline "."

            # Clear existing settings first then overlay the results, if any.
            $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].STATUS = "Not_Reviewed"
            $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].FINDING_DETAILS = ""
            $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].COMMENTS = ""
            $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].SEVERITY_OVERRIDE = ""
            $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].SEVERITY_JUSTIFICATION = ""

            # Look for this Vuln-ID in the other CKL
            $xml.CHECKLIST.STIGS.iSTIG.VULN | 
                ? {$_.STIG_DATA[0].ATTRIBUTE_DATA -match $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].STIG_DATA[0].ATTRIBUTE_DATA} |
                % { $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].STATUS = $_.STATUS
                    $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].FINDING_DETAILS = $_.FINDING_DETAILS
                    $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].COMMENTS = $_.COMMENTS
                    $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].SEVERITY_OVERRIDE = $_.SEVERITY_OVERRIDE
                    $benchXml.CHECKLIST.STIGS.iSTIG.VULN[$i].SEVERITY_JUSTIFICATION = $_.SEVERITY_JUSTIFICATION
            }
        }

        $newName = "$(Split-Path $xmlFile)\$($upgrade.host) $($benchXmlFile.STIG) V$($benchXmlFile.STIG_VER)R$($benchXmlFile.STIG_REV) $(date -Format yyyyMMdd).ckl"


        # Export to XML
        $benchXml.Save($newName)
        # Grab the raw export
        $raw = gc -Raw $newName
        # Restack the XML file to be complaint with CKL Schema
        $raw2 = $raw -replace "\s*<([a-zA-z_]+)>\s\n\s*<\/([a-zA-z_]+)>\s\n", ("`r`n" + '<$1></$2>' + "`r`n")
        $raw2 = $raw2 -replace "`r`n`r`n","`r`n"
        # Save using .NET IO to write in UTF8 encoding
        [IO.File]::WriteAllLines($newName, $raw2)

        # Make a new line
        Write-host " "
        $RemoveCKLs += $upgrade
    }
    
    if ($RemoveCKLs) {
        Remove-FromDB
        Update-DB
    }


    $TextLog.text = "Upgrade finished, rescan the folder to get the most up to date info. Also delete the .bak files if everything worked."
    $TextLog.refresh()
    Enable-Buttons

}

function Import-XCCDF { 
    
    disable-buttons

    # Choose only the ZIPs
    $zipFiles = Get-ChildItem -Path $XCCDFFolder -Filter "*.zip"
    if ($zipFiles){

        foreach ($zip in $zipFiles){

        #Extract all XCCDFs from Zip files and put them in the the main folder
        Add-Type -Assembly System.IO.Compression.FileSystem
        $workingzip = [IO.Compression.ZipFile]::OpenRead("$($zip.FullName)")
        # Only extract XCCDF manual XML files
        $workingzip.Entries | where {$_.Name -like '*xccdf*'} | foreach {[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$XCCDFFolder\" + $_.Name, $true)}
        $workingzip.Dispose()
    

        # Recursively look for xccdf.xml files and rename them
        $XCCDFFiles = Get-ChildItem -Path $XCCDFFolder -Filter "**xccdf*.xml" -Recurse
    
        foreach ($xccdf in $XCCDFFiles){
            $xccdfInfo = $null

            # Grab some basic info and 
            [xml]$analyze = gc $xccdf.FullName

            # Check if it's SCC format
            if ($analyze.'#comment'){
                $xccdfInfo =,[pscustomobject]@{
                    name = $analyze.'#comment'.Split(',')[1].split(':')[-1].trimend(' ')
                    STIG = $analyze.'#comment'.Split(',')[3].split(':')[-1].trimend(' ')
                    file = $xccdf.FullName
                    source = "SCC"
                }
            }

            # Check if it's ACAS format
            if ($analyze.TestResult){
                $xccdfInfo =,[pscustomobject]@{
                    name = $analyze.TestResult.target.Split('.')[0] # Host name up the the dot
                    STIG = $analyze.TestResult.id.TrimStart('xccdf_mil.disa.stig_testresult_') #Clean the STIG name
                    file = $xccdf.FullName
                    source = "ACAS"
                }
            }
            # Rename file
            Rename-Item -Path $xccdf.FullName -NewName "$($xccdfInfo.name) - $($xccdfInfo.STIG) $($xccdfInfo.source) xccdf.xml" -Force
        }

    }

    }

    # Scan folders again
    $XCCDFFiles = Get-ChildItem -Path $XCCDFFolder -Filter "**xccdf*.xml" -Recurse
    $selectedXCCDFFiles = $XCCDFFiles | Out-GridView -PassThru -Title "Which XCCDFs do you want to import?"

    # Stage the vars
    $xccdf2CKL = $null
    Remove-Variable xccdf -ErrorAction SilentlyContinue
    foreach ($xccdf in $selectedXCCDFFiles){

        # Iterate through each found XCCDF (SCC specific)
        $xccdfInfo = $null
        
        # Grab some basic info and 
        [xml]$analyze = gc $xccdf.FullName


        # Check if it's SCC format
        if ($analyze.'#comment'){
            $xccdfInfo =,[pscustomobject]@{
                name = $analyze.'#comment'.Split(',')[1].split(':')[-1].trimend(' ')
                STIG = $analyze.'#comment'.Split(',')[3].split(':')[-1].trimend(' ').split(' ')[0]
                file = $xccdf.FullName
                source = "SCC"
            }
        }

        # Check if it's ACAS format
        if ($analyze.TestResult){
            $xccdfInfo =,[pscustomobject]@{
                name = $analyze.TestResult.target.Split('.')[0] # Host name up the the dot
                STIG = $analyze.TestResult.id.TrimStart('xccdf_mil.disa.stig_testresult_') #Clean the STIG name
                file = $xccdf.FullName
                source = "ACAS"
            }
        }


        #Write-host "Analyzing $($xccdfInfo.source) XCCDF $($xccdfInfo.name) - $($xccdfInfo.STIG)"
        
        # Get matches for XCCDF
        # Looping though the main list
        $CKLOnly | ForEach-Object {
            # If matches up with existing...
            if ($_.Host -match $xccdfInfo.name -and $_.STIG -match $xccdfInfo.STIG){
                $xccdf2CKL +=,[pscustomobject]@{
                    host = $xccdfInfo.name
                    source = $xccdfInfo.source
                    xccdf = $xccdfInfo.file
                    ckl = $_.Location
                        newName = "$(Split-Path $_.Location)\$([string]$xccdfInfo.name) $($_.STIG) V$($_.STIG_VER)R$($_.STIG_REV) $(date -Format yyyyMMdd).ckl"
                }
                
            }
        } # End the Main List check

        # The XCCDF didn't match up with the main list, let's create a new one
        
        if ($xccdf2CKL -eq $null){$lastCKL = 0}
        else {$lastCKL =$xccdf2CKL[-1].xccdf}

        if ($lastCKL -notlike $xccdfInfo.file){
            $latestCKL | ForEach-Object {
                # If matches up with latest blank CKL
                if ($_.STIG -match $xccdfInfo.STIG){
                    $newCKL = "$CKLFolder\$([string]$xccdfInfo.name) $($_.STIG) V$($_.STIG_VER)R$($_.STIG_REV) $(date -Format yyyyMMdd).ckl"
                    Copy-Item -Path $_.location -Destination $newCKL
                    $xccdf2CKL +=,[pscustomobject]@{
                        host = $xccdfInfo.name
                        source = $xccdfInfo.source
                        xccdf = $xccdfInfo.file
                        ckl = $newCKL
                        newName = "$($CKLFolder)\$([string]$xccdfInfo.name) $($_.STIG) V$($_.STIG_VER)R$($_.STIG_REV) $(date -Format yyyyMMdd).ckl"
                    }
                    Write-Host "Using blank CKL for $(Split-Path $xccdfInfo.file -Leaf)"

                }
            } 
        } # End the  List check
        
        # Copy the unprocessed XCCDF files to the report folder 
        if ($xccdf2CKL -eq $null){$lastCKL = 0}
        else {$lastCKL =$xccdf2CKL[-1].xccdf}

        if ($lastCKL -notlike $xccdfInfo.file){
            # No matching CKL found, moving XCCDFs for later processing
            $newXCCDF = "$XCCDFFolder\$($xccdfInfo.name) - $($xccdfInfo.STIG) $($xccdfInfo.source) xccdf.xml" 
            Copy-Item -Path $xccdfInfo.file -Destination $newXCCDF -ErrorAction SilentlyContinue
            Write-Host "Skipped - No similar CKL found for $(Split-Path $xccdfInfo.file -Leaf)"

        }

        # Use the XCCDF2CKL variable and import XCCDF settings into CKL
        
    } # End loop through XCCDFs
            
    # Process each XML / CKL
    if ($xccdf2CKL){
        $xccdf2CKL | ForEach-Object {


        #### Change back to $_
        [xml]$xccdf = Get-Content $_.xccdf
        [xml]$ckl = Get-Content $_.ckl
        if ($_.source -match "ACAS"){
            $xccdfData = $xccdf.TestResult
        }else{
            $xccdfData = $xccdf.Benchmark.TestResult
        }

        # Set the host info
        $ckl.CHECKLIST.ASSET.HOST_NAME = [string]$_.host
        $ckl.CHECKLIST.ASSET.HOST_IP = [string]$xccdfData.'target-address'
        $ckl.CHECKLIST.ASSET.HOST_MAC = [string]$($xccdfData.'target-facts'.fact | ? {$_.name -match "identifier:mac"} | Select-Object -First 1).'#text'
        $ckl.CHECKLIST.ASSET.HOST_FQDN = [string]$xccdfData.target

        $xccdfHost = $_.host

        Write-Host "`nProcessing $xccdfHost $($_.newName) " -NoNewline

        # Loop through results in xccdf
        foreach ($xresult in $xccdfData.'rule-result') {
           
            # Loop though checks in checklist
            foreach ($check in $ckl.CHECKLIST.STIGS.iSTIG.VULN ){
                
                # Match up the CKL and XCCDF
                if ($check.STIG_DATA.ATTRIBUTE_DATA -contains $xresult.version){
                    # Pass or fail
                    if ($xresult.result -like "pass"){
                        Write-Host "+" -NoNewline
                        $check.STATUS = "NotAFinding"
                    }

                    if ($xresult.result -like "fail"){
                        Write-Host "-" -NoNewline
                        $check.STATUS = "Open"
                    }
                }
            }
        }

        # Export to XML
        $updatedCKL= "$($_.newName)" 
        $ckl.Save($updatedCKL)
        Write-Host "`nSaving to $updatedCKL"
        # Grab the raw export
        $raw = gc -Raw $updatedCKL
        # Restack the XML file to be complaint xwith CKL Schema
        $raw2 = $raw -replace "\s*<([a-zA-z_]+)>\s\n\s*<\/([a-zA-z_]+)>\s\n", ("`r`n" + '<$1></$2>' + "`r`n")
        $raw2 = $raw2 -replace "`r`n`r`n","`r`n"
        # Save using .NET IO to write in UTF8 encoding
        [IO.File]::WriteAllLines($updatedCKL, $raw2)

        # Delete old CLK
        
        if ($_.ckl -notlike $updatedCKL){
            Remove-Item -Path $_.ckl
            # Write-Host "Renaming old CKL"
            # Rename-Item -Path $_.ckl -NewName "$($_.ckl).bak"
        }
    }
    }

    $TextLog.text = "Import finished, check the root of the CKL folder for CKLs that I couldn't match up with. Also rescan the folder to get updated data"
    $TextLog.refresh()
    Enable-Buttons
}

function Get-XCCDFFolder { 
    Disable-Buttons
    $TextLog.text = "Working... "
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.rootfolder = "MyComputer"
    $foldername.Description = "Choose base folder that contains all of the CKL files that you want to scan"

    if($foldername.ShowDialog() -eq "OK") {
        $XCCDFFolder = $foldername.SelectedPath
        $TextXCCDFFolder.text = $XCCDFFolder
    }
    
    $TextLog.text = "Changed XCCDF folder, click scan to import the CKLs."
    $TextLog.refresh()
    Enable-Buttons
}

function View-STIGList { 
    Disable-Buttons
    while (1){
        $choice1 = $ScanDetails | Select-Object -unique -Property stig,host | 
            Group-Object host | Out-GridView -OutputMode Multiple -Title "Hosts to STIGs list"
        if ($choice1) {
            $choice1.Group | Select-Object -unique -Property stig | 
                Out-GridView -OutputMode Multiple -Title "STIGs to Host list: $($choice1.Group[0].host)"
        }else{break}   
    }

    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons
}

function View-HostList { 
    Disable-Buttons
    while (1){
        $choice1 = $ScanDetails | Select-Object -unique -Property stig,host | 
            Group-Object stig | Out-GridView -OutputMode Multiple -Title "STIGs to Host list"
        if ($choice1) {
            $choice1.Group | Select-Object -unique -Property host | 
                Out-GridView -OutputMode Multiple -Title "STIGs to Host list: $($choice1.Group[0].stig)"
        }else{break}   
    }

    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons
}

function View-OpenNoComment { 
    Disable-Buttons
    while (1){
        $choice1 = $NCmenu | Out-GridView -PassThru -Title "Open and No comments"
        if ($choice1) {
            $subMenu = $null
            while(1){
                $choice2 = $NClist | Where-Object {
                    $choice1.Host -contains $_.Host -and
                    $choice1.STIG -contains $_.STIG -and
                    $choice1.Location -contains $_.Location
                } | Out-GridView -PassThru -Title "Pick a VulnID to see other affected systems"

                if ($choice2){
                    $ScanDetails | Where-Object {$choice2.VID -contains $_.VID} | 
                        Select-Object -Property host,stig,status,FINDING_DETAILS,COMMENTS,location |                     
                        Out-GridView -PassThru -Title "$($choice2.VID) $($choice2.Title)" 
                }else{break}   
            }
        }else{break}   
    }

    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons
}

function View-NotReviewed { 
    Disable-Buttons 
    while (1){
        $choice1 = $NRmenu | Out-GridView -PassThru -Title "Not Reviewed"
        if ($choice1) {
            $subMenu = $null
            while(1){
                $choice2 = $NRlist | Where-Object {
                    $choice1.Host -contains $_.Host -and
                    $choice1.STIG -contains $_.STIG -and
                    $choice1.Location -contains $_.Location
                } | Out-GridView -PassThru -Title "Pick a VulnID to see other affected systems"

                if ($choice2){
                    $ScanDetails | Where-Object {$choice2.VID -contains $_.VID} | 
                        Select-Object -Property host,stig,FINDING_DETAILS,COMMENTS,location |                     
                        Out-GridView -PassThru -Title "$($choice2.VID) $($choice2.Title)" 
                }else{break}   
            }
        }else{break}   
    }

    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons

}

function View-BlankHostName {
    Disable-Buttons
    $blankHostList |  Out-GridView -PassThru -Title "CLKs with Blank Host Names"
    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons
}

function View-OpenByVID { 
    Disable-Buttons
    while (1){
        $choice1 = $openVulns | Group-Object severity | Out-GridView -PassThru
        if ($choice1) {
            while (1){
                $choice2 = $choice1.Group | Group-Object VID | Out-GridView -OutputMode Multiple
                if ($choice2){
                    $choice2.Group | Select-Object -Property host,stig,FINDING_DETAILS,COMMENTS,location | 
                    Out-GridView -PassThru -Title "$($choice2.Group[0].VID) $($choice2.Group[0].Title)"
                }else{break}
            }
        }else{break}   
    }

    $TextLog.text = "Reporting finished. "
    $TextLog.refresh()
    Enable-Buttons
}

function Remove-CKL { 
    Disable-Buttons
    $TextLog.text = "Updating DB, please wait..."
    $TextLog.refresh()
    $RemoveCKLs = $ScanDetails | Select-Object -Unique -Property host,stig,stig_ver,stig_rev,location | 
        Out-GridView -PassThru -Title "Which one(s) do you want to remove?"
    
    if ($RemoveCKLs) {
        Remove-FromDB
        Update-DB
    }
    $TextLog.text = "Remove finished. "
    $TextLog.refresh()
    Enable-Buttons

}

function Remove-DupCKLs {
    Disable-Buttons
    $TextLog.text = "Updating DB, please wait..."
    $TextLog.refresh()

    while (1){
        $choice1 = $ScanDetails | Select-Object -Unique -Property host,stig,stig_ver,stig_rev,location | Group-Object host,stig |
        ? {$_.count -gt 1} | Out-GridView -Title "Multiple CKLs per Host/STIG detected. Which do you want to look at?" -PassThru
        if ($choice1) {
            $RemoveCKLs = $choice1.Group | Out-GridView -Title "Which one(s) do you want to remove?" -PassThru
            if ($RemoveCKLs) {
                Remove-FromDB
                Update-DB
            }
        }else{break}   
    }
    $TextLog.text = "Dupe Check done. "
    $TextLog.refresh()
    Enable-Buttons
} 

function Scan-CLKFolder {
    Disable-Buttons
    $TextLog.text = "Working... "
    # Clear it out
    $checkLists = $null
    $newScanDetails = $null
    
    # If the folder is blank, then it will skip the checklist scan
    if ($cklFolder -notlike ""){
        $checkLists = Get-ChildItem -Path $cklFolder -Filter "*.ckl" -Recurse
    }
    
    # Won't run if $checklist is empty
    foreach ($checklist in $checklists){
    
        [xml]$analyze = gc $checkList.FullName
        $logText = "Analyzing $($checkList.FullName)"
        #$logText = "Analyzing $($analyze.CHECKLIST.ASSET.HOST_NAME) - $($analyze.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA[3].SID_DATA.trimstart('xccdf_mil.disa.stig_benchmark_')) - $($checkList.FullName)"
        write-host $logText
        $TextLog.text = $logText
        $TextLog.refresh()
    
        # Stats is cleared on each system, details is not
        $stats = $null
        foreach ($vuln in $analyze.CHECKLIST.STIGS.iSTIG.VULN){
    
            $stats += ,[pscustomobject]@{
                VID = $vuln.STIG_DATA[0].ATTRIBUTE_DATA
                Severity = $vuln.STIG_DATA[1].ATTRIBUTE_DATA
                Status = $vuln.STATUS
            }

            $newScanDetails += ,[pscustomobject]@{
                VID = $vuln.STIG_DATA[0].ATTRIBUTE_DATA
                Severity = $vuln.STIG_DATA[1].ATTRIBUTE_DATA
                Status = $vuln.STATUS
                stig = $analyze.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA[3].SID_DATA.trimstart('xccdf_mil.disa.stig_benchmark_')
                STIG_VER = [int]$analyze.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA[0].SID_DATA.split('.')[0].trimstart('0')
                STIG_REV = [int]$analyze.CHECKLIST.STIGS.iSTIG.STIG_INFO.SI_DATA[6].SID_DATA.split(' ')[1].split('.')[-1].trimstart('0')
                FINDING_DETAILS = $vuln.FINDING_DETAILS
                COMMENTS = $vuln.COMMENTS
                host = $analyze.CHECKLIST.ASSET.HOST_NAME
                location = $checkList.FullName
                Title = $vuln.STIG_DATA[5].ATTRIBUTE_DATA
                Discussion = $vuln.STIG_DATA[6].ATTRIBUTE_DATA
                Fix = $vuln.STIG_DATA[9].ATTRIBUTE_DATA
                CCIRef = $vuln.STIG_DATA[24].ATTRIBUTE_DATA
            }
        }
    }
     
    $comboList = $scanDetails | Select-Object -Unique -Property host,stig,stig_ver,stig_rev,location
    $comboList += $newScanDetails | Select-Object -Unique -Property host,stig,stig_ver,stig_rev,location


    $RemoveCKLs = $($comboList | Group-Object -Property location | ? {$_.count -gt 1}).group | Select-Object -Unique -Property host,stig,location
    Remove-FromDB

    $scanDetails += $newScanDetails


    # Logic for combining records
    if ($CKLDetails -eq $null){
        $CKLDetails += $scanDetails
    }
    
    Update-DB
    $TextLog.text = "Done importing CKLs to the database."
    $TextLog.refresh()
    Enable-Buttons
}




function Get-CKLFolder { 
    Disable-Buttons
    $TextLog.text = "Working... "
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.rootfolder = "MyComputer"
    $foldername.Description = "Choose base folder that contains all of the CKL files that you want to scan"

    if($foldername.ShowDialog() -eq "OK") {
        $CKLFolder = $foldername.SelectedPath
        $TextCklFolder.text = $cklFolder
    }
    $TextLog.text = "Changed CLK folder, click scan to import the CKLs."
    $TextLog.refresh()
    Enable-Buttons
}


#Write your logic code here

Set-Variable -Name CKLFolder -Value $null -Option AllScope
#Set-Variable -Name CKLDetails -Value $null -Option AllScope # Remove, not needed
Set-Variable -Name CKLOnly -Value $null -Option AllScope
Set-Variable -Name upgradableCKL -Value $null -Option AllScope
Set-Variable -Name latestCKL -Value $null -Option AllScope
Set-Variable -Name XCCDFFolder -Value $null -Option AllScope
Set-Variable -Name XCCDFFiles -Value $null -Option AllScope
Set-Variable -Name ScanDetails -Value $null -Option AllScope
Set-Variable -Name RemoveCKLs -Value $null -Option AllScope
Set-Variable -Name openVulns -Value $null -Option AllScope
Set-Variable -Name dupeVulns -Value $null -Option AllScope
Set-Variable -Name NRVulns -Value $null -Option AllScope
Set-Variable -Name xccdf2CKL -Value $null -Option AllScope # Remove? Used for testing
Set-Variable -Name NRmenu -Value $null -Option AllScope
Set-Variable -Name NRlist -Value $null -Option AllScope
Set-Variable -Name NCmenu -Value $null -Option AllScope
Set-Variable -Name NClist -Value $null -Option AllScope
Set-Variable -Name VIDmenu -Value $null -Option AllScope
Set-Variable -Name VIDlist -Value $null -Option AllScope
Set-Variable -Name AVmenu -Value $null -Option AllScope
Set-Variable -Name blankHostList -Value $null -Option AllScope

function Remove-FromDB{
    # If anything was chosen to be removed, then pipe out $scanDetails and remove those entries
    if ($RemoveCKLs){
        $ScanDetails = $ScanDetails | Where-Object {
            ($RemoveCKLs.host -notcontains $_.host) -or
            ($RemoveCKLs.stig -notcontains $_.stig) -or
            ($RemoveCKLs.location -notcontains $_.location)
        }
    }
    $RemoveCKLs = $null
}

function Disable-Buttons{
    $ButtonFolderSelect.enabled = $false
    $ButtonScanCKL.enabled = $false
    $ButtonRemoveCKL.enabled = $false
    $ButtonRemoveDuplicateCKLs.enabled  = $false
    $ButtonBlankHostName.enabled        = $false
    $ButtonNotReviewed.enabled       = $false
    $ButtonOpenNoComment.enabled     = $false
    $ButtonHostList.enabled          = $false
    $ButtonSTIGList.enabled          = $false
    $ButtonXCCDFFolder.enabled       = $false
    $ButtonNotReviewed.enabled       = $false
    $ButtonAllOpen.enabled           = $false
    $ButtonVulnID.enabled            = $false

}

function Update-DB {

    # Probably need to refactor this whole section 
    Write-host "Updating DB, please be patient, watch the task manager to see how hard I'm working."

    Write-host -nonewline "Updating: DupeVuln"
    $dupeVulns = $ScanDetails | Select-Object -Unique -Property host,stig,location | group host,stig | ? {$_.count -gt 1}
    Write-host -nonewline ", OpenVuln"
    $openVulns =  $ScanDetails | Where-Object {($_.Status -match "Open")} |
        Select-Object -unique -Property host,stig,severity,VID,Title,FINDING_DETAILS,COMMENTS,location
    # $NRVulns = $ScanDetails | Where-Object { $_.Status -match "Not_Reviewed"}

    Write-host -nonewline ", CKLOnly"
    $CKLOnly = $ScanDetails | Select-Object -unique -Property host,STIG,STIG_VER,STIG_REV,Location 

    # Sort by ID,VER,REV and take the most recent one
    Write-host -nonewline ", LatestCKL"
    $latestCKL = $CKLOnly |
        Group-Object -Property STIG | 
        ForEach-Object{$_.Group | 
        Sort-Object -Property STIG_VER,STIG_REV -Descending -Unique | 
        Select-Object -First 1}
    
    # Grab a list of systems that don't match the above list
    Write-host -nonewline ", UpgradeableCKL"
    $upgradableCKL = ($CKLOnly |
        Group-Object STIG,STIG_VER,STIG_REV | 
        ? {(($latestCKL | Group-Object STIG,STIG_VER,STIG_REV).Name) -notcontains $_.name}).group

    # Not reviewed menu builder
    Write-host -nonewline ", NRList"
    $NRmenu = $null
    $NRlist = $ScanDetails | Where-Object { $_.Status -match "Not_Reviewed"} |
        Select-Object -unique -Property host,stig,status,severity,VID,Title,location

    $NRList | Group-Object stig,host | ForEach-Object {
        
        $NRmenu +=,[pscustomobject]@{
            CAT1 = [int]$($_.group | Where-Object {$_.severity -match "high"} | Measure-Object).Count
            CAT2 = [int]$($_.group | Where-Object {$_.severity -match "medium"} | Measure-Object).Count
            CAT3 = [int]$($_.group | Where-Object {$_.severity -match "low"} | Measure-Object).Count
            STIG = $_.group[0].stig
            Host = $_.group[0].host
            Location = $_.group[0].Location
        }
    }

    # No Comment menu builder
    Write-host -nonewline ", NCList"
    $NCmenu = $null
    $NClist = $openVulns | Where-Object {($_.FINDING_DETAILS -like "") -and ($_.COMMENTS -like "")} |
        Select-Object -unique -Property host,stig,severity,VID,Title,location

    $NCList | Group-Object stig,host | ForEach-Object {
        
        $NCmenu +=,[pscustomobject]@{
            CAT1 = [int]$($_.group | Where-Object {$_.severity -match "high"} | Measure-Object).Count
            CAT2 = [int]$($_.group | Where-Object {$_.severity -match "medium"} | Measure-Object).Count
            CAT3 = [int]$($_.group | Where-Object {$_.severity -match "low"} | Measure-Object).Count
            STIG = $_.group[0].stig
            Host = $_.group[0].host
            Location = $_.group[0].Location
        }
    }

    # All Vulnerability menu builder
    Write-host -nonewline ", AllVuln"
    $AVmenu = $null
    $openVulns | Group-Object stig,host | ForEach-Object {        
        $AVmenu +=,[pscustomobject]@{
            CAT1 = [int]$($_.group | Where-Object {$_.severity -match "high"} | Measure-Object).Count
            CAT2 = [int]$($_.group | Where-Object {$_.severity -match "medium"} | Measure-Object).Count
            CAT3 = [int]$($_.group | Where-Object {$_.severity -match "low"} | Measure-Object).Count
            STIG = $_.group[0].stig
            Host = $_.group[0].host
            Location = $_.group[0].Location
        }
    }

    # VID List for POAMs menu builder
    Write-host -nonewline ", VulnByID"
    $VIDmenu = $null
    $openVulns | Group-Object vid | ForEach-Object {
        $VIDmenu +=,[pscustomobject]@{
            VulnID = $_.name
            NoComment = [int]$($_.group | Where-Object {($_.FINDING_DETAILS -like "") -and ($_.COMMENTS -like "")} | Measure-Object).Count
            POAM_Needed = [int]$($_.group | Where-Object {($_.FINDING_DETAILS -like "*POAM Needed*") -or ($_.COMMENTS -like "*POAM Needed*")} | Measure-Object).Count
            Policy_Needed = [int]$($_.group | Where-Object {($_.FINDING_DETAILS -like "*Policy Needed*") -or ($_.COMMENTS -like "*Policy Needed*")} | Measure-Object).Count
            Exemption_Needed = [int]$($_.group | Where-Object {($_.FINDING_DETAILS -like "*Exemption Needed*") -or ($_.COMMENTS -like "*Exemption Needed*")} | Measure-Object).Count
            Total_Open = [int]$_.count
            Severity = $_.group[0].severity
            Title = $_.group[0].title
        }
    }

    Write-host -nonewline ", BlankHost"
    $blankHostList = $ScanDetails | Where-Object {$_.host -like ""} | Select-Object -Unique -Property stig,location 
    Write-host ". Done!"

}

function Enable-Buttons{
    $ButtonFolderSelect.enabled = $true
    if ($CKLFolder){$ButtonScanCKL.enabled = $true}


    if ($NRVulns){
        $ButtonNotReviewed.enabled       = $true
    }
    

    # If there are duplicate files found
    if ($DupeVulns){
        $ButtonRemoveDuplicateCKLs.enabled  = $true
        $TextLog.text += "`n Duplicate CKLs found, please remove the extras."
        $TextLog.refresh()
    }
        
    if ($upgradableCKL){
        $ButtonUpgradeCKL.enabled        = $true
    }
    
    if ($XCCDFFolder -and (-not $dupeVulns)){
        $ButtonImportXCCDF.enabled       = $true
    }
    
    if ($openVulns){
#        $ButtonOpenSTIG.enabled          = $true
#        $ButtonOpenHost.enabled          = $true
#        $ButtonOpenVID.enabled           = $true
    }

    # If there is scan info, then enable these buttons
    if ($scanDetails) {
        $ButtonRemoveCKL.enabled         = $true
        $ButtonBlankHostName.enabled     = $true
        $ButtonHostList.enabled          = $true
        $ButtonSTIGList.enabled          = $true
        $ButtonXCCDFFolder.enabled       = $true
        $ButtonOpenNoComment.enabled     = $true
        $ButtonNotReviewed.enabled       = $true
        $ButtonAllOpen.enabled           = $true
        $ButtonVulnID.enabled            = $true
    }
    
}

[void]$Form.ShowDialog()
