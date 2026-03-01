# Super Organizer Pro 🧹 (Banana Edition 🍌)

Um conjunto de scripts poderosos para organizar automaticamente sua **Mesa**, **Downloads** e **Documentos** em pastas inteligentes por tipo de arquivo e data. Agora com o toque especial da **Banana Edition**!

---

## 📸 Prévias do Sistema

### 🍏 macOS
![macOS Banana Organizer](https://github.com/eldolucio/super-organizer/raw/main/public/assets/macos_preview.png)

### 🐧 Linux
![Linux Banana Organizer](https://github.com/eldolucio/super-organizer/raw/main/public/assets/linux_preview.png)

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

---

Desenvolvido com ❤️ e 🍌 por [eldolucio](https://github.com/eldolucio).
