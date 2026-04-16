$ErrorActionPreference = 'SilentlyContinue'
$base = "C:\Users\jason\Documents\sunzi_recoder\32426326"
$out = Join-Path $base "clips"

$cuts = @(
    # === 3/23 ===
    @{ flv="$base\20260323\32426326-20260323-151622-890.all.flv"; start="00:55:24"; dur="00:04:00"; name="0323_zoumadeng" }
    @{ flv="$base\20260323\32426326-20260323-151622-890.all.flv"; start="01:13:00"; dur="00:03:30"; name="0323_yage_scene" }
    @{ flv="$base\20260323\32426326-20260323-151622-890.all.flv"; start="01:51:00"; dur="00:04:00"; name="0323_pangge_linke" }
    @{ flv="$base\20260323\32426326-20260323-151622-890.all.flv"; start="03:21:00"; dur="00:04:00"; name="0323_peak_door" }
    # === 3/24 ===
    @{ flv="$base\20260324\32426326-20260324-153815-248.all.flv"; start="00:31:00"; dur="00:04:30"; name="0324_zoumadeng_peak" }
    @{ flv="$base\20260324\32426326-20260324-153815-248.all.flv"; start="02:12:00"; dur="00:03:00"; name="0324_yage_blacklist" }
    @{ flv="$base\20260324\32426326-20260324-153815-248.all.flv"; start="03:02:00"; dur="00:04:00"; name="0324_novel_freedom" }
    @{ flv="$base\20260324\32426326-20260324-153815-248.all.flv"; start="03:40:00"; dur="00:04:00"; name="0324_huangque_finale" }
    # === 3/25 ===
    @{ flv="$base\20260325\32426326-20260325-150021-988.all.flv"; start="00:28:00"; dur="00:04:00"; name="0325_dlc_value" }
    @{ flv="$base\20260325\32426326-20260325-150021-988.all.flv"; start="03:18:00"; dur="00:03:30"; name="0325_masochist" }
    @{ flv="$base\20260325\32426326-20260325-150021-988.all.flv"; start="05:54:00"; dur="00:04:00"; name="0325_boss_3hours" }
    @{ flv="$base\20260325\32426326-20260325-150021-988.all.flv"; start="07:39:00"; dur="00:04:00"; name="0325_night_owls" }
)

$total = $cuts.Count; $done = 0
foreach ($cut in $cuts) {
    $done++
    $dest = Join-Path $out "$($cut.name).flv"
    Write-Host "[$done/$total] $($cut.name) ..." -ForegroundColor Cyan
    & ffmpeg -ss $cut.start -i $cut.flv -t $cut.dur -c copy -avoid_negative_ts make_zero $dest -y 2>$null
    if ((Test-Path $dest) -and (Get-Item $dest).Length -gt 1000) {
        $sz = [math]::Round((Get-Item $dest).Length/1MB,1)
        Write-Host "  Done! ${sz}MB" -ForegroundColor Green
    } else {
        Write-Host "  FAILED" -ForegroundColor Red
    }
}
$files = Get-ChildItem $out -Filter "*.flv"
$totMB = [math]::Round(($files | Measure-Object Length -Sum).Sum/1MB,0)
Write-Host "`n$($files.Count) clips total, ${totMB}MB" -ForegroundColor Yellow
