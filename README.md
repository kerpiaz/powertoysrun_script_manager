# PowerToys Run Third-Party Plugins Installer

This PowerShell script simplifies the installation of third-party plugins for **PowerToys Run**, a powerful launcher for Windows. It fetches the list of available plugins from the official PowerToys GitHub repository and allows you to interactively install them.

---

## 🚀 Features

- **🔹 Interactive Installation** – Choose plugins to install from the official list.
- **📖 Plugin Details** – View the `README.md` of each plugin before installation.
- **📌 List Installed Plugins** – Check which plugins are already installed.
- **🔗 Git Integration** – Automatically clones plugin repositories using Git.

---

## 🔧 Prerequisites

Before running the script, ensure the following are installed on your system:

1. **Git** – Required for cloning plugin repositories.
   - 📥 Download and install Git from [git-scm.com](https://git-scm.com/).
2. **PowerToys** – Ensure PowerToys is installed and running.
   - 🔗 Download PowerToys from [Microsoft PowerToys](https://github.com/microsoft/PowerToys).

---

## 📌 Usage

### 1️⃣ Run the Script

Open PowerShell and navigate to the directory containing the script. Run the script using:

```powershell
.\powertoys_extension_github.ps1
```

### 2️⃣ Interactive Installation

The script will display a list of available plugins.

- You can choose to view details (e.g., `README.md`) or skip a plugin.
- Confirm installation for each plugin.

### 3️⃣ List Installed Plugins

To list all installed plugins, run the script with the `-list` parameter:

```powershell
.\powertoys_extension_github.ps1 -list
```

---

## ⚙️ Script Parameters

| Parameter | Description |
|-----------|-------------|
| `-list`   | Lists all installed plugins. No installation is performed. |
| _(None)_  | Starts interactive installation of plugins. |

---

## 📖 Example Workflow

### ▶️ Run the Script:

```powershell
.\powertoys_extension_github.ps1
```

### 📌 Choose an Action:

- Enter `1` to list installed plugins.
- Enter `2` or press **Enter** to start installation.

### 🔽 Install Plugins:

For each plugin, you can:

- View details (e.g., `README.md`).
- Confirm installation (**y**) or skip (**n**).

### ✅ Verify Installation:

After installation, the script lists all installed plugins.

---

## ⚠️ Notes

- **GitHub Access** – The script fetches the plugin list from the official PowerToys GitHub repository. Ensure you have an active internet connection.
- **Plugin Path** – Plugins are installed in the default PowerToys Run plugins directory:
  
  ```
  %LocalAppData%\Microsoft\PowerToys\PowerToys Run\Plugins
  ```

---

## 🛠 Troubleshooting

- **❌ Git Not Found** – If Git is not installed, the script will exit with an error. Install Git and try again.
- **📌 Failed Cloning** – If a plugin fails to install, ensure the GitHub URL is accessible and your internet connection is stable.

---

## 📜 License

This script is provided as-is under the **MIT License**. Feel free to modify and distribute it as needed.

---

## 🤝 Contributing

If you find any issues or have suggestions for improvement, please open an issue or submit a pull request on the GitHub repository.

Enjoy enhancing your **PowerToys Run** experience with third-party plugins! 🚀

