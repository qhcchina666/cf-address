$ARROW='url("data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''12'' height=''12'' viewBox=''0 0 12 12''%3E%3Cpath fill=''%2364748b'' d=''M6 8L1 3h10z''/%3E%3C/svg%3E")'
$FLAG_ZH='url("data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' viewBox=''0 0 24 16''%3E%3Crect width=''24'' height=''16'' fill=''%23DE2910''/%3E%3Cg fill=''%23FFDE00''%3E%3Cpolygon points=''6,3 7,5.5 9,5.5 7.5,7 8,9.5 6,8 4,9.5 4.5,7 3,5.5 5,5.5''/%3E%3C/g%3E%3C/svg%3E")'
$FLAG_EN='url("data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' viewBox=''0 0 24 16''%3E%3Crect width=''24'' height=''16'' fill=''%23012169''/%3E%3Cpath d=''M0 0l24 16M24 0L0 16'' stroke=''%23fff'' stroke-width=''3''/%3E%3Cpath d=''M0 0l24 16M24 0L0 16'' stroke=''%23C8102E'' stroke-width=''1''/%3E%3Cpath d=''M12 0v16M0 8h24'' stroke=''%23fff'' stroke-width=''5''/%3E%3Cpath d=''M12 0v16M0 8h24'' stroke=''%23C8102E'' stroke-width=''2.5''/%3E%3C/svg%3E")'
$FLAG_JA='url("data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' viewBox=''0 0 24 16''%3E%3Crect width=''24'' height=''16'' fill=''%23fff''/%3E%3Ccircle cx=''12'' cy=''8'' r=''5'' fill=''%23BC002D''/%3E%3C/svg%3E")'
$FLAG_KO='url("data:image/svg+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' viewBox=''0 0 24 16''%3E%3Crect width=''24'' height=''16'' fill=''%23fff''/%3E%3Ccircle cx=''12'' cy=''8'' r=''5'' fill=''%23C60C30''/%3E%3Cpath d=''M12 3a5 5 0 0 1 0 10'' fill=''%23003478''/%3E%3C/svg%3E")'

$FLAGS = @{
  'zh' = $FLAG_ZH
  'en' = $FLAG_EN
  'ja' = $FLAG_JA
  'ko' = $FLAG_KO
}

$folders = @(
  @{path='c:\Users\89588\Desktop\9666';lang='zh'},
  @{path='c:\Users\89588\Desktop\9666\en';lang='en'},
  @{path='c:\Users\89588\Desktop\9666\ja';lang='ja'},
  @{path='c:\Users\89588\Desktop\9666\ko';lang='ko'},
  @{path='c:\Users\89588\Desktop\9666\articles';lang='zh'},
  @{path='c:\Users\89588\Desktop\9666\articles\en';lang='en'},
  @{path='c:\Users\89588\Desktop\9666\articles\ja';lang='ja'},
  @{path='c:\Users\89588\Desktop\9666\articles\ko';lang='ko'}
)

$count = 0
foreach ($f in $folders) {
  $lang = $f.lang
  $flag = $FLAGS[$lang]
  $files = Get-ChildItem $f.path -Filter *.html -File -ErrorAction SilentlyContinue
  foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    
    # Step 1: Add data-lang attribute to select.lang-switch
    if ($content -match '<select class="lang-switch"' -and $content -notmatch 'data-lang=') {
      $content = $content.Replace('<select class="lang-switch"', "<select class=`"lang-switch`" data-lang=`"$lang`"")
    }
    
    # Step 2: Replace globe icon in inline .lang-switch CSS
    # The globe icon is the first url() in the background-image property
    $pattern = 'background-image:url\("data:image/svg\+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''14'' height=''14'' viewBox=''0 0 24 24'' fill=''none'' stroke=''%2364748b''[^)]+\)\),url\("data:image/svg\+xml,%3Csvg xmlns=''http://www.w3.org/2000/svg'' width=''12'' height=''12''[^)]+\)\)'
    $replacement = "background-image:$flag,$ARROW"
    if ($content -match $pattern) {
      $content = [regex]::Replace($content, $pattern, $replacement)
    }
    
    [System.IO.File]::WriteAllText($file.FullName, $content)
    $count++
  }
}
Write-Output "Updated $count files"