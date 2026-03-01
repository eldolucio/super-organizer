# Super Organizer Pro 🧹 (Multi-Platform)

Um conjunto de scripts poderosos para organizar automaticamente sua **Mesa**, **Downloads** e **Documentos** em pastas inteligentes por tipo de arquivo e data.

---

## 🚀 Como Usar

### 🍏 macOS (`organize_macos.sh`)
1. Dê permissão de execução:
   ```bash
   chmod +x organize_macos.sh
   ```
2. Execute o script:
   ```bash
   ./organize_macos.sh
   ```

### 🐧 Linux (`organize_linux.sh`)
1. Dê permissão de execução:
   ```bash
   chmod +x organize_linux.sh
   ```
2. Execute o script:
   ```bash
   ./organize_linux.sh
   ```

### 🪟 Windows (`organize_windows.ps1`)
1. Abra o PowerShell como Administrador.
2. Execute o script:
   ```powershell
   .\organize_windows.ps1
   ```
   *(Caso dê erro de permissão, use: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`)*

---

## ⏰ Automatização (Agendamento)

### 🐧/🍏 Linux e macOS (Crontab)
Para rodar o script automaticamente todos os dias às 18:00:

1. No terminal, digite:
   ```bash
   crontab -e
   ```
2. Adicione a seguinte linha ao final do arquivo (ajuste o caminho):
   ```cron
   0 18 * * * /bin/bash /caminho/para/seu/organize_macos.sh
   ```
3. Salve e feche. O script agora rodará sozinho diariamente!

### 🪟 Windows (Agendador de Tarefas)
Para rodar automaticamente no Windows:

1. Abra o **Agendador de Tarefas** (Task Scheduler).
2. Clique em **"Criar Tarefa Básica..."**.
3. Dê um nome (ex: "Organizador de Arquivos").
4. Escolha a frequência (ex: "Diariamente").
5. Na ação, selecione **"Iniciar um programa"**.
6. No campo "Programa/script", digite: `powershell.exe`
7. No campo "Adicionar argumentos", digite:
   ```powershell
   -ExecutionPolicy Bypass -File "C:\caminho\para\seu\organize_windows.ps1"
   ```
8. Conclua. O Windows cuidará do resto!

---

## 📂 Categorias Inteligentes
- **Imagens**: Fotos, Vetores, Ícones, RAW, Design (PSD/FIG).
- **Vídeos**: Filmes, Web, Edição (PRPROJ).
- **Áudios**: Músicas, Podcasts, Produção.
- **Documentos**: PDF, Word, Excel, PowerPoint, Planilhas.
- **Código**: Web, Backend, Scripts, Banco de Dados.
- **Outros**: Organizados automaticamente por **Ano/Mês**.

---

Desenvolvido com ❤️ por [eldolucio](https://github.com/eldolucio).
