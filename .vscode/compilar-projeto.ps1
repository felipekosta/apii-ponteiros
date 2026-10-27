<#
    Compila todos os arquivos .c de uma pasta em um único programa.
    Usado pelas tarefas do tasks.json (cenário a: projeto com vários arquivos).
    Recebe os parâmetros já prontos do VSCode - não precisa editar este arquivo
    para mudar de pasta, apenas para mudar as flags de compilação do gcc.
#>
param(
    [Parameter(Mandatory = $true)][string]$Pasta,
    [Parameter(Mandatory = $true)][string]$Saida,
    [switch]$Executar
)

$arquivos = Get-ChildItem -Path $Pasta -Filter *.c -File | Select-Object -ExpandProperty FullName

if (-not $arquivos) {
    Write-Host "Nenhum arquivo .c encontrado em: $Pasta" -ForegroundColor Red
    exit 1
}

Write-Host "Compilando os arquivos:" -ForegroundColor Cyan
$arquivos | ForEach-Object { Write-Host "  - $_" }
Write-Host ""

& gcc -g -Wall -Wextra -std=c17 $arquivos -o $Saida

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Erro de compilação. Corrija o código e tente novamente." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Compilação concluída: $Saida" -ForegroundColor Green

if ($Executar) {
    Write-Host ""
    Write-Host "--- Executando ---" -ForegroundColor Green
    & $Saida
}
