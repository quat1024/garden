# Fixing weird powershell colors

In windows terminal I'd get these horrible colors after typing a "space" or pressing "backspace" in powershell.

![Dark grey text on black background clashing with the color theme](/img/powershell-colors/bad.png)\ 

[This issue](https://github.com/microsoft/terminal/pull/17666) told me to "update psreadline". Ok but how do you do that

## add PowerShellGet

Following instructions [here](https://github.com/PowerShell/PSReadLine). This from an administrator Powershell.

```powershell
Install-Module -Name PowerShellGet -Force
```

This first asked me to install a "NuGet provider". Alright, sure, whatever.

## install and/or update PSReadLine

Closed that powershell and opened a new regular one in windows terminal. Ran this.

```powershell
Install-Module PSReadLine -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force
```

I guess the `CurrentUser` scope is fine, i'm the only user on this pc. Not sure if other options work.

Closed that powershell tab as well and opened a new one. That seemed to fix the colors.

![Grey text on white background looking okay](/img/powershell-colors/good.png)\ 

## what does this actually change about the powershell installation

No idea.