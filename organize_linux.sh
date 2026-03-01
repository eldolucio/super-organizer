#!/bin/bash

# ╔══════════════════════════════════════════════════════════════╗
#  🖥️  SUPER ORGANIZADOR - Linux
#  Organiza: Área de Trabalho, Downloads e Documentos
#  Como usar: bash organize_linux.sh
# ╚══════════════════════════════════════════════════════════════╝

# ── PASTAS PRINCIPAIS ────────────────────────────────────────────────────────

MESA="$HOME/Desktop"
DOWNLOADS="$HOME/Downloads"
DOCUMENTOS="$HOME/Documents"

TOTAL_GERAL=0

# ── CATEGORIAS E EXTENSÕES ──────────────────────────────────────────────────

definir_categorias() {
    declare -gA CATEGORIAS

    # 🖼️ Imagens
    CATEGORIAS["Imagens/Fotos"]="jpg jpeg png heic heif tiff tif bmp"
    CATEGORIAS["Imagens/Vetores"]="svg ai eps"
    CATEGORIAS["Imagens/Ícones"]="ico icns"
    CATEGORIAS["Imagens/Animadas"]="gif webp apng avif"
    CATEGORIAS["Imagens/RAW"]="raw cr2 cr3 nef nrw arw rw2 orf dng"
    CATEGORIAS["Imagens/Design"]="psd psb xd fig sketch afdesign afphoto"

    # 🎬 Vídeos
    CATEGORIAS["Vídeos/Filmes"]="mp4 mkv avi mov m4v"
    CATEGORIAS["Vídeos/Web"]="webm flv f4v"
    CATEGORIAS["Vídeos/Outros"]="wmv mpg mpeg 3gp ts mts m2ts vob"
    CATEGORIAS["Vídeos/Edição"]="prproj aep mogrt"

    # 🎵 Áudios
    CATEGORIAS["Áudios/Músicas"]="mp3 aac m4a flac wav ogg opus"
    CATEGORIAS["Áudios/Podcasts"]="wma ra ram"
    CATEGORIAS["Áudios/Produção"]="aif aiff mid midi"

    # 📄 Documentos
    CATEGORIAS["Documentos/PDF"]="pdf"
    CATEGORIAS["Documentos/Word"]="doc docx odt rtf"
    CATEGORIAS["Documentos/Texto"]="txt md markdown log"
    CATEGORIAS["Documentos/Apresentações"]="ppt pptx key odp"
    CATEGORIAS["Documentos/Planilhas"]="xls xlsx csv numbers ods tsv"
    CATEGORIAS["Documentos/Formulários"]="xps oxps"
    CATEGORIAS["Documentos/Publicação"]="indd pub"

    # 📚 eBooks
    CATEGORIAS["eBooks"]="epub mobi azw azw3 djvu lit cbr cbz fb2"

    # 💻 Código e Dev
    CATEGORIAS["Código/Web"]="html htm css js ts jsx tsx vue svelte"
    CATEGORIAS["Código/Backend"]="py rb php java go rs c cpp cs swift kt"
    CATEGORIAS["Código/Scripts"]="sh bash zsh ps1 bat cmd"
    CATEGORIAS["Código/Dados"]="json xml yaml yml toml ini cfg conf env"
    CATEGORIAS["Código/Banco de Dados"]="sql db sqlite sqlite3 mdb accdb"
    CATEGORIAS["Código/Projetos"]="xcodeproj xcworkspace gradle pom"

    # 🗜️ Compactados e Instaladores
    CATEGORIAS["Compactados"]="zip rar tar gz bz2 7z xz lz"
    CATEGORIAS["Instaladores/macOS"]="dmg pkg app"
    CATEGORIAS["Instaladores/Windows"]="exe msi"
    CATEGORIAS["Instaladores/Linux"]="deb rpm appimage"

    # 🖋️ Fontes
    CATEGORIAS["Fontes"]="ttf otf woff woff2 eot"

    # 🔐 Segurança
    CATEGORIAS["Segurança"]="pem crt cer key p12 pfx gpg asc"

    # 🖨️ CAD e Impressão 3D
    CATEGORIAS["CAD e Impressão 3D"]="stl obj fbx blend dae 3ds dwg dxf step iges"

    # 📦 Máquinas Virtuais
    CATEGORIAS["Máquinas Virtuais"]="iso vmdk ova ovf vdi qcow2 vhd"

    # 🔤 Legendas
    CATEGORIAS["Legendas"]="srt vtt sub ass ssa"

    # 💾 Backups
    CATEGORIAS["Backups"]="bak old backup dump"

    # 🎮 Jogos e ROMs
    CATEGORIAS["Jogos"]="rom nes smc gba gbc nds xci nsp"

    # 📡 Torrents
    CATEGORIAS["Torrents"]="torrent"
}

# ── FUNÇÃO: MOVER ARQUIVO ────────────────────────────────────────────────────

mover_arquivo() {
    local ARQUIVO="$1"
    local DESTINO="$2"
    local BASE_DIR="$3"
    local NOME
    NOME=$(basename "$ARQUIVO")

    mkdir -p "$DESTINO"

    if [ -f "$DESTINO/$NOME" ]; then
        local TIMESTAMP
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        local BASE="${NOME%.*}"
        local EXT="${NOME##*.}"
        NOME="${BASE}_${TIMESTAMP}.${EXT}"
    fi

    mv "$ARQUIVO" "$DESTINO/$NOME"
    echo "    ✅ $NOME → ${DESTINO#$BASE_DIR/}/"
}

# ── ARQUIVOS PROTEGIDOS (nunca serão movidos) ────────────────────────────────

NOME_SCRIPT=$(basename "$0")

é_protegido() {
    local ARQUIVO="$1"
    local NOME
    NOME=$(basename "$ARQUIVO")
    local PROTEGIDOS=("$NOME_SCRIPT" "organize_macos.sh" "organize_linux.sh" "organize_windows.ps1")

    for P in "${PROTEGIDOS[@]}"; do
        if [ "$NOME" = "$P" ]; then
            echo "  🔒 Protegido (ignorado): $NOME"
            return 0
        fi
    done
    return 1
}

# ── FUNÇÃO: ORGANIZAR POR TIPO ───────────────────────────────────────────────

organizar_por_tipo() {
    local PASTA="$1"
    local TOTAL=0

    # Ensure the directory exists
    [ ! -d "$PASTA" ] && return 0

    for CATEGORIA in "${!CATEGORIAS[@]}"; do
        local EXTENSOES="${CATEGORIAS[$CATEGORIA]}"
        local DESTINO="$PASTA/$CATEGORIA"

        for EXT in $EXTENSOES; do
            while IFS= read -r -d '' ARQUIVO; do
                é_protegido "$ARQUIVO" && continue
                mover_arquivo "$ARQUIVO" "$DESTINO" "$PASTA"
                ((TOTAL++))
            done < <(find "$PASTA" -maxdepth 1 -iname "*.$EXT" -print0 2>/dev/null)
        done
    done

    # Arquivos sem extensão conhecida → Outros
    while IFS= read -r -d '' ARQUIVO; do
        if [ -f "$ARQUIVO" ]; then
            é_protegido "$ARQUIVO" && continue
            mover_arquivo "$ARQUIVO" "$PASTA/Outros" "$PASTA"
            ((TOTAL++))
        fi
    done < <(find "$PASTA" -maxdepth 1 -type f -print0 2>/dev/null)

    echo $TOTAL
}

# ── FUNÇÃO: ORGANIZAR "OUTROS" POR DATA ─────────────────────────────────────

organizar_outros_por_data() {
    local OUTROS="$1/Outros"
    local TOTAL=0

    [ ! -d "$OUTROS" ] && return 0

    while IFS= read -r -d '' ARQUIVO; do
        if [ -f "$ARQUIVO" ]; then
            local ANO MES_NUM MES
            # Linux (GNU) date command
            ANO=$(date -r "$ARQUIVO" +%Y)
            MES_NUM=$(date -r "$ARQUIVO" +%m)

            case $MES_NUM in
                01) MES="01 - Janeiro" ;;   02) MES="02 - Fevereiro" ;;
                03) MES="03 - Março" ;;     04) MES="04 - Abril" ;;
                05) MES="05 - Maio" ;;      06) MES="06 - Junho" ;;
                07) MES="07 - Julho" ;;     08) MES="08 - Agosto" ;;
                09) MES="09 - Setembro" ;;  10) MES="10 - Outubro" ;;
                11) MES="11 - Novembro" ;;  12) MES="12 - Dezembro" ;;
            esac

            local DESTINO="$OUTROS/$ANO/$MES"
            local NOME
            NOME=$(basename "$ARQUIVO")

            mkdir -p "$DESTINO"

            if [ -f "$DESTINO/$NOME" ]; then
                local TIMESTAMP BASE EXT
                TIMESTAMP=$(date +%H%M%S)
                BASE="${NOME%.*}"
                EXT="${NOME##*.}"
                NOME="${BASE}_${TIMESTAMP}.${EXT}"
            fi

            mv "$ARQUIVO" "$DESTINO/$NOME"
            echo "    ✅ $NOME → Outros/$ANO/$MES/"
            ((TOTAL++))
        fi
    done < <(find "$OUTROS" -maxdepth 1 -type f -print0 2>/dev/null)

    echo $TOTAL
}

# ── FUNÇÃO: EXIBIR ESTRUTURA ─────────────────────────────────────────────────

exibir_estrutura() {
    local PASTA="$1"
    [ ! -d "$PASTA" ] && return 0
    find "$PASTA" -mindepth 1 -maxdepth 3 -type d | sort | while read -r DIR; do
        local PROF QTD INDENT NOME_DIR
        PROF=$(echo "$DIR" | awk -F'/' '{print NF}')
        QTD=$(find "$DIR" -maxdepth 1 -type f | wc -l | tr -d ' ')
        # Standard indent for Linux find paths
        local BASE_COUNT=$(echo "$PASTA" | awk -F'/' '{print NF}')
        INDENT=$(printf '%*s' $(( (PROF - BASE_COUNT) * 3 )) '')
        NOME_DIR=$(basename "$DIR")
        if [ "$QTD" -gt 0 ]; then
            echo "      ${INDENT}📂 $NOME_DIR ($QTD arquivo(s))"
        fi
    done
}

# ════════════════════════════════════════════════════════════════════
#  INÍCIO DA EXECUÇÃO
# ════════════════════════════════════════════════════════════════════

clear
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "   🖥️   SUPER ORGANIZADOR DE LINUX - Iniciando...             "
echo "   📂  Área de Trabalho • Downloads • Documentos               "
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

definir_categorias

# ── 🖥️ MESA ──────────────────────────────────────────────────────────────────
if [ -d "$MESA" ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  🖥️  ÁREA DE TRABALHO"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    T1=$(organizar_por_tipo "$MESA")
    T2=$(organizar_outros_por_data "$MESA")
    TOTAL_MESA=$(( T1 + T2 ))
    TOTAL_GERAL=$(( TOTAL_GERAL + TOTAL_MESA ))
    echo "  ✔️  Mesa: $TOTAL_MESA arquivo(s) organizados."
    exibir_estrutura "$MESA"
    echo ""
fi

# ── 📥 DOWNLOADS ──────────────────────────────────────────────────────────────
if [ -d "$DOWNLOADS" ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  📥  DOWNLOADS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    T1=$(organizar_por_tipo "$DOWNLOADS")
    T2=$(organizar_outros_por_data "$DOWNLOADS")
    TOTAL_DOWNLOADS=$(( T1 + T2 ))
    TOTAL_GERAL=$(( TOTAL_GERAL + TOTAL_DOWNLOADS ))
    echo "  ✔️  Downloads: $TOTAL_DOWNLOADS arquivo(s) organizados."
    exibir_estrutura "$DOWNLOADS"
    echo ""
fi

# ── 📄 DOCUMENTOS ─────────────────────────────────────────────────────────────
if [ -d "$DOCUMENTOS" ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  📄  DOCUMENTOS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    T1=$(organizar_por_tipo "$DOCUMENTOS")
    T2=$(organizar_outros_por_data "$DOCUMENTOS")
    TOTAL_DOCUMENTOS=$(( T1 + T2 ))
    TOTAL_GERAL=$(( TOTAL_GERAL + TOTAL_DOCUMENTOS ))
    echo "  ✔️  Documentos: $TOTAL_DOCUMENTOS arquivo(s) organizados."
    exibir_estrutura "$DOCUMENTOS"
fi

# ── RESUMO FINAL ──────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "  ✨  ORGANIZAÇÃO COMPLETA!"
echo ""
echo "  📦  Total geral: $TOTAL_GERAL arquivo(s) organizados"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
