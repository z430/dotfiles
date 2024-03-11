using namespace System.Management.Automation

# Prompt
Import-Module posh-git

# Load prompt config
function GetScriptDirectory { Split-Path $MyInvocation.ScriptName }
$PROMPT_CONFIG = Join-Path (GetScriptDirectory) 'powerline.omp.json'
oh-my-posh init pwsh --config $PROMPT_CONFIG | Invoke-Expression

# Icons
Import-Module -Name Terminal-Icons

# make ls like in the unix
Import-Module PowerColorLS
Set-Alias -Name ls -Value PowerColorLS -Option AllScope

# Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteCharOrExit
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReserverHistory 'Ctrl+r'

# Utilities
function which ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# SSH Autocomplete
Register-ArgumentCompleter -CommandName ssh, scp, sftp -Native -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)

	function Get-SSHHostList ($sshConfigPath) {
		Get-Content -Path $sshConfigPath `
		| Select-String -Pattern '^Host ' `
		| ForEach-Object { $_ -replace 'Host ', '' } `
		| ForEach-Object { $_ -split ' ' } `
		| Sort-Object -Unique `
		| Select-String -Pattern '^.*[*!?].*$' -NotMatch
	}

	function Get-SSHConfigFileList ($sshConfigFilePath) {
		$sshConfigDir = Split-Path -Path $sshConfigFilePath -Resolve -Parent
	
		$sshConfigFilePaths = @()
		$sshConfigFilePaths += $sshConfigFilePath
	
		$pathsPatterns = @()
		Get-Content -Path $sshConfigFilePath `
		| Select-String -Pattern '^Include ' `
		| ForEach-Object { $_ -replace 'Include ', '' }  `
		| ForEach-Object { $_ -replace '~', $Env:USERPROFILE } `
		| ForEach-Object { $_ -replace '\$Env:USERPROFILE', $Env:USERPROFILE } `
		| ForEach-Object { $_ -replace '\$Env:HOMEPATH', $Env:USERPROFILE } `
		| ForEach-Object { 
			$sshConfigFilePaths += $(Get-ChildItem -Path $sshConfigDir\$_ -File -ErrorAction SilentlyContinue -Force).FullName `
			| ForEach-Object { Get-SSHConfigFileList $_ } 
		}
	
		if (($sshConfigFilePaths.Length -eq 1) -and ($sshConfigFilePaths.item(0) -eq $sshConfigFilePath) ) {
			return $sshConfigFilePath
		}
	
		return $sshConfigFilePaths | Sort-Object -Unique
	}

	$sshPath = "$Env:USERPROFILE\.ssh"
	$hosts = Get-SSHConfigFileList "$sshPath\config" `
	| ForEach-Object { Get-SSHHostList $_ } `

	# For now just assume it's a hostname.
	$textToComplete = $wordToComplete
	$generateCompletionText = {
		param($x)
		$x
	}
	if ($wordToComplete -match "^(?<user>[-\w/\\]+)@(?<host>[-.\w]+)$") {
		$textToComplete = $Matches["host"]
		$generateCompletionText = {
			param($hostname)
			$Matches["user"] + "@" + $hostname
		}
	}

	$hosts `
	| Where-Object { $_ -like "${textToComplete}*" } `
	| ForEach-Object { [CompletionResult]::new((&$generateCompletionText($_)), $_, [CompletionResultType]::ParameterValue, $_) }
}

Set-PSReadLineKeyHandler -Chord '"', "'" `
	-BriefDescription SmartInsertQuote `
	-LongDescription "Insert paired quotes if not already on a quote" `
	-ScriptBlock {
	param($key, $arg)

	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

	if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
		# Just move the cursor
		[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
	}
	else {
		# Insert matching quotes, move cursor to be in between the quotes
		[Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
		[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
	}
}