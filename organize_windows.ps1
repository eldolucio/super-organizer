# ╔══════════════════════════════════════════════════════════════╗
#  🖥️  SUPER ORGANIZADOR - Windows
#  Organiza: Desktop, Downloads e Documentos
#  Como usar: .\organize_windows.ps1
# ╚══════════════════════════════════════════════════════════════╝

# ── PASTAS PRINCIPAIS ────────────────────────────────────────────────────────

$USER_PATH = [System.Environment]::GetFolderPath("UserProfile")
$MESA = "$USER_PATH\Desktop"
$DOWNLOADS = "$USER_PATH\Downloads"
$DOCUMENTOS = [System.Environment]::GetFolderPath("MyDocuments")

$TOTAL_GERAL = 0

# ── CATEGORIAS E EXTENSÕES ──────────────────────────────────────────────────

$CATEGORIAS = @{
    "Imagens\Fotos" = @("jpg", "jpeg", "png", "heic", "heif", "tiff", "tif", "bmp")
    "Imagens\Vetores" = @("svg", "ai", "eps")
    "Imagens\Ícones" = @("ico", "icns")
    "Imagens\Animadas" = @("gif", "webp", "apng", "avif")
    "Imagens\RAW" = @("raw", "cr2", "cr3", "nef", "nrw", "arw", "rw2", "orf", "dng")
    "Imagens\Design" = @("psd", "psb", "xd", "fig", "sketch", "afdesign", "afphoto")
    
    "Vídeos\Filmes" = @("mp4", "mkv", "avi", "mov", "m4v")
    "Vídeos\Web" = @("webm", "flv", "f4v")
    "Vídeos\Edição" = @("prproj", "aep")

    "Áudios\Músicas" = @("mp3", "aac", "m4a", "flac", "wav")
    
    "Documentos\PDF" = @("pdf")
    "Documentos\Word" = @("doc", "docx", "odt", "rtf")
    "Documentos\Texto" = @("txt", "md")
    "Documentos\Planilhas" = @("xls", "xlsx", "csv")
    "Documentos\Apresentações" = @("ppt", "pptx")

    "Compactados" = @("zip", "rar", "7z", "tar", "gz")
    "Instaladores\Windows" = @("exe", "msi")
    "Código\Scripts" = @("ps1", "bat", "cmd", "sh", "ahk")
    "Código\Web" = @("html", "css", "js", "json")
}

# ── FUNÇÃO: MOVER ARQUIVO ────────────────────────────────────────────────────

function Mover-Arquivo($Arquivo, $Destino) {
    if (-not (Test-Path $Destino)) {
        New-Item -ItemType Directory -Path $Destino -Force | Out-Null
    }

    $Nome = $Arquivo.Name
    $DestPath = Join-Path $Destino $Nome

    if (Test-Path $DestPath) {
        $Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $Base = $Arquivo.BaseName
        $Ext = $Arquivo.Extension
        $Nome = "${Base}_${Timestamp}${Ext}"
        $DestPath = Join-Path $Destino $Nome
    }

    Move-Item -Path $Arquivo.FullName -Destination $DestPath -Force
    Write-Host "    ✅ $Nome → $($Destino.Replace($MESA, 'Desktop').Replace($DOWNLOADS, 'Downloads').Replace($DOCUMENTOS, 'Documents'))"
}

# ── FUNÇÃO: ORGANIZAR ───────────────────────────────────────────────────────

function Organizar-Pasta($Pasta) {
    if (-not (Test-Path $Pasta)) { return 0 }
    $Total = 0
    
    $Arquivos = Get-ChildItem -Path $Pasta -File
    
    foreach ($Arq in $Arquivos) {
        # Ignora o próprio script
        if ($Arq.Name -eq $MyInvocation.MyCommand.Name) { continue }
        
        $Ext = $Arq.Extension.Trim('.').ToLower()
        $Movido = $false
        
        foreach ($Cat in $CATEGORIAS.Keys) {
            if ($CATEGORIAS[$Cat] -contains $Ext) {
                $DestDir = Join-Path $Pasta $Cat
                Mover-Arquivo $Arq $DestDir
                $Total++
                $Movido = $true
                break
            }
        }
        
        if (-not $Movido) {
            # Se não cair em categoria, vai para Outros por Data
            $Data = $Arq.LastWriteTime
            $Ano = $Data.Year.ToString()
            $Mes = $Data.ToString("MM - MMMM")
            $DestDir = Join-Path $Pasta "Outros\$Ano\$Mes"
            Mover-Arquivo $Arq $DestDir
            $Total++
        }
    }
    return $Total
}

# ════════════════════════════════════════════════════════════════════
#  EXECUÇÃO
# ════════════════════════════════════════════════════════════════════

Clear-Host
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "   🖥️   SUPER ORGANIZADOR DE WINDOWS - Iniciando...           " -ForegroundColor Cyan
Write-Host "   📂  Desktop • Downloads • Documentos                       " -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$T_Mesa = Organizar-Pasta $MESA
Write-Host "  ✔️  Desktop: $T_Mesa arquivo(s) organizados."

$T_Down = Organizar-Pasta $DOWNLOADS
Write-Host "  ✔️  Downloads: $T_Down arquivo(s) organizados."

$T_Docs = Organizar-Pasta $DOCUMENTOS
Write-Host "  ✔️  Documentos: $T_Docs arquivo(s) organizados."

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ✨  ORGANIZAÇÃO COMPLETA!" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
