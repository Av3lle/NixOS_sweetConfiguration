<div align="center"><img src="assets/logo.png" width="300px"></div>

<h1 align="center">✨ NixOS Sweet Configuration ✨</h1>
<p align="center">
	<a href="https://github.com/Av3lle/NixOS_sweetConfiguration">
		<img alt="Av3lle" src="https://img.shields.io/github/stars/Av3lle/NixOS_sweetConfiguration?label=Stars&color=FF3899&labelColor=303446&style=flat&logo=starship&logoColor=FF3899">
	</a>
	<a href="https://github.com/NixOS/nixpkgs/tree/nixos-25.05">
		<img alt="NixOS" src="https://img.shields.io/badge/NixOS-stable-blue.svg?style=flat&logo=nixos&logoColor=FE78B0&colorA=24273A&colorB=FE78B0">
	</a>
	<a href="https://wiki.nixos.org/wiki/Flakes">
		<img alt="Flake" src="https://img.shields.io/static/v1?label=Nix%20Flake&message=Check&style=flat&logo=nixos&colorA=24273A&colorB=FE1A88&logoColor=FE1A88">
	</a>
</p>
Моя конфигурация NixOS + Home Manager, настроенная под личные предпочтения и эстетические вкусы.

---

## 📋 Содержание

- [Особенности](#-особенности)  
- [Структура репозитория](#-структура-репозитория)  
- [Превью рабочего стола](#-превью-рабочего-стола)  
- [Используемое ПО](#-используемое-по)  
- [Установка / Использование](#-установка--использование)  
- [Благодарности](#-благодарности)

---

## ✨ Особенности

- Использование **Flakes** для декларативного управления конфигурацией.  
- Настройка через **Home Manager** для пользовательских программ.  
- Много различных модулей на вкус и цвет.  
- Возможность легкого расширения под новые машины или окружения.  
- Caelestia-shell из коробки.

---

## 📂 Структура репозитория
.
├── flake.nix
├── configuration.nix
├── lib
│   ├── default.nix
│   ├── devShells.nix
│   ├── packages.nix
│   └── sweet
│       ├── imports.nix
│       ├── mkHome.nix
│       ├── mkMachine.nix
│       └── options.nix
├── disko
│   ├── pc.nix
│   └── server.nix
├── hosts
│   ├── default.nix
│   └── template
│       ├── default.nix
│       ├── hardware-configuration.nix
│       └── system
│           └── packages.nix
├── users
│   ├── default.nix
│   └── username
│       ├── default.nix
│       ├── packages.nix
├── derivations
│   ├── default
│   │   ├── default.nix
├── modules
│   ├── example.nix
│   ├── home
│   │   ├── example
│   ├── hosts
│   │   ├── example
├── secrets
    └── sops.nix

> Путь и названия могут немного отличаться, т.к. их слишком много.

---

## 🖼 Превью рабочего стола

<p align="center">
  <img src="./assets/preview1.png" alt="Desktop preview" width="100%" />
</p>
<p align="center">
  <img src="./assets/preview2.png" alt="Desktop preview" width="100%" />
</p>
<p align="center">
  <img src="./assets/preview3.png" alt="Desktop preview" width="100%" />
</p>
<p align="center">
  <img src="./assets/preview4.png" alt="Desktop preview" width="100%" />
</p>

---

## 🖥 Используемое ПО

| Категория        | Используемый софт / инструменты |
| ---------------- | ------------------------------- |
| ОC / менеджмент  | NixOS, Flakes                   |
| Конфиги юзера    | Home Manager                    |
| Композитор       | Hyprland                        |
| Тема / стиль     | Custom base16 theme             |
| Панели / виджеты | Caelestia-shell                 |
| Терминал / шелл  | Kitty + fish + starship         |
| Редактор         | Helix                           |

---

## 🚀 Установка / Использование

> ⚠️ **Внимание**: этот конфиг адаптирован под моё железо и предпочтения. Используй на свой страх и риск.

```bash
git clone https://github.com/Av3lle/NixOS_sweetConfiguration.git
cd NixOS_sweetConfiguration

# Применяем конфигурацию (для конкретного хоста)
sudo nixos-rebuild switch --flake .#pc
sudo home-manager switch --flake .#pc
```
