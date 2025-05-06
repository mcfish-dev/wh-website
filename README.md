# wh-website

將原本合併的 Windows 伺服器，拆分成 Ubuntu Web 與既有 Mail 兩台主機，並以 Docker + Nginx + Let’s Encrypt 快速完成 HTTPS。

# 🚀 Web Server 容器化與自動化部署

**技術棧**: `Docker` `Nginx` `Let's Encrypt` `Ubuntu` `UFW`  
**演示環境**: [https://www.twwinhome.com](https://www.twwinhome.com) (需替換為實際網址)

## 📌 專案目標
將原共用伺服器的 Web/Mail 服務分離，實現：
- **安全隔離**：降低單點故障風險
- **自動化 HTTPS**：Certbot 自動更新 SSL 證書
- **快速部署**：Docker 容器化環境
