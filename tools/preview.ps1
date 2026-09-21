# Converteix un .docx a PDF (amb Word) i en treu una imatge per pàgina, per revisar el resultat.
# Ús:  powershell -File tools/preview.ps1 -In "C#/XuletaBàsica.docx"
# Requereix Word instal·lat i:  pip install pymupdf
param(
    [Parameter(Mandatory = $true)][string]$In,
    [string]$OutDir = "$env:TEMP\cheatsheet-preview"
)

$src = (Resolve-Path $In).Path
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
[string]$pdf = [System.IO.Path]::Combine($OutDir, [System.IO.Path]::GetFileNameWithoutExtension($src) + ".pdf")

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$doc = $word.Documents.Open($src, $false, $true)
$doc.SaveAs([ref]$pdf, [ref]17)   # 17 = wdFormatPDF
$doc.Close([ref]$false)
$word.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null

python -c @"
import pymupdf, sys
d = pymupdf.open(r'$pdf')
print('Pàgines:', d.page_count)
for i, pg in enumerate(d):
    out = rf'$OutDir\page-{i+1}.png'
    pg.get_pixmap(dpi=110).save(out)
    print(out)
"@
