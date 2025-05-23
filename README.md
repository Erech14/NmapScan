
# 🔍 Сетевой сканер на базе Nmap


**NmapScan** — это мощный Bash-скрипт для автоматизированного сканирования локальной сети с использованием [`nmap`](https://nmap.org/). Он определяет активные IP-адреса, открытые порты, типы устройств и операционные системы хостов. Все результаты сохраняются в структурированные файлы.

---

## 📦 Возможности

- Сканирование IP-диапазона в формате CIDR (например, `192.168.1.0/24`)
- Исключение недопустимых IP-адресов (`.0`, `.255`)
- Определение:
  - Активных хостов
  - Открытых портов
  - Типов устройств
  - Операционных систем (OS details)
- Отображение прогресса выполнения
- Сохранение результатов в отдельные файлы для дальнейшего анализа

---

## ⚙️ Требования

- **ОС:** Linux / macOS / WSL
- **Пакеты:** 
  - [`nmap`](https://nmap.org/)
  - Bash-совместимая оболочка

---

## 🧪 Установка

Установите `nmap`, если он ещё не установлен:

```bash
# Debian/Ubuntu
sudo apt install nmap

# macOS (через Homebrew)
brew install nmap
```

Скачайте скрипт и сделайте его исполняемым:

```bash
chmod +x network_scan.sh
```

---

## 🚀 Использование

Запустите скрипт:

```bash
./network_scan.sh
```

При запуске скрипт запросит у вас:

- **IP-адрес сети** (например: `192.168.1.0`)
- **Маску сети** (например: `24`)

Далее последовательно выполняются три шага:

1. 🔍 Сканирование подсети на активные IP
2. 🧹 Фильтрация IP-адресов с окончанием `.0` и `.255`
3. 🔬 Подробное сканирование каждого активного хоста

---

## 📁 Создаваемые файлы

После выполнения скрипта будут сгенерированы:

- `active_ips.txt` — список активных IP-адресов
- `scan_results/` — подробные отчёты по каждому IP (открытые порты, ОС, устройства и т.д.)

---

## 📝 Пример сессии


Введите IP сети (например, 192.168.1.0):
> 192.168.0.0

Введите маску сети (например, 24):
> 24

📡 Шаг 1: Поиск активных IP...
🚦 Шаг 2: Фильтрация недопустимых IP...
🖥️  Шаг 3: Сканирование активных IP...
✅ Сканирование завершено!


---

## ⚠️ Важно

> Используйте данный скрипт **только в пределах своей сети** или с разрешения администратора. Несанкционированное сканирование чужих сетей может быть **противозаконным**.

---

## 📚 Лицензия

Этот проект распространяется под лицензией **MIT** — свободное использование с указанием авторства.

---

## ❤️ Авторы

Разработано с заботой о сетевой безопасности и автоматизации процессов.

---


