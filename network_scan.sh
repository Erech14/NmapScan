#!/bin/bash

# Удаление старых файлов (если есть)
rm -f active_ips.txt open_ports.txt full_os_scan_output.txt os_info.txt device_type.txt active_ips_raw.txt &> /dev/null

# Создание файлов (если не существуют)
create_file() {
    [ ! -f "$1" ] && touch "$1"
}

# Проверка допустимости IP (исключаем .0 и .255)
is_valid_ip() {
    local ip="$1"
    local last_octet=$(echo "$ip" | awk -F '.' '{print $4}')
    if [[ "$last_octet" == "0" || "$last_octet" == "255" ]]; then
        return 1
    fi
    return 0
}

# Запрос данных
echo -n "Введите IP сети (например, 192.168.1.0): " && read network_ip
echo -n "Введите маску сети (например, 24): " && read netmask

# Сканирование активных IP
echo -e "\n📡 Шаг 1: Поиск активных IP-адресов в сети..."
nmap -sn "$network_ip/$netmask" -oG - | awk '/Up$/{print $2}' > active_ips_raw.txt

# Фильтрация допустимых IP
echo "🚦 Шаг 2: Фильтрация недопустимых IP..."
> active_ips.txt
while IFS= read -r ip; do
    if is_valid_ip "$ip"; then
        echo "$ip" >> active_ips.txt
    else
        echo "⚠️ Пропуск IP: $ip (недопустим)"
    fi
done < active_ips_raw.txt

# Создание файлов для хранения результатов
create_file os_info.txt
create_file open_ports.txt
create_file device_type.txt
create_file full_os_scan_output.txt

# Подсчёт IP-адресов
total_ips=$(wc -l < active_ips.txt)
[ "$total_ips" -eq 0 ] && echo "❌ Нет допустимых активных IP. Завершение." && exit 1

echo -e "\n🖥️  Шаг 3: Сканирование IP (ОС, порты, устройство)..."

# Функция динамического прогресс-бара
draw_progress_bar() {
    local progress=$1
    local total=$2
    local ip=$3
    local bar_length=40
    local filled=$((progress * bar_length / total))
    local empty=$((bar_length - filled))
    local percent=$((progress * 100 / total))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="="; done
    bar+=">"
    for ((i=0; i<empty; i++)); do bar+="."; done

    echo -ne "\r[${bar}] ${percent}% ($progress/$total) Обработка IP: ${ip}   "
}

# Основной цикл сканирования
current_ip=0
while IFS= read -r ip; do
    current_ip=$((current_ip + 1))
    draw_progress_bar "$current_ip" "$total_ips" "$ip"

    os_full_info=$(nmap -O -sT "$ip" 2>/dev/null)

    echo -e "\nИнформация о ОС для IP: $ip" >> full_os_scan_output.txt
    echo "$os_full_info" >> full_os_scan_output.txt
    echo "" >> full_os_scan_output.txt

    os_info=$(echo "$os_full_info" | grep -i "OS details")
    open_ports=$(echo "$os_full_info" | grep -E "^([0-9]+)/(tcp|udp)" | awk '{print $1}' | tr '\n' ',' | sed 's/,$//')
    device_info=$(echo "$os_full_info" | grep -i "Device type")

    [[ -n "$os_info" ]] && echo "$ip: $os_info" >> os_info.txt || echo "$ip: Не удалось определить ОС" >> os_info.txt
    [[ -n "$open_ports" ]] && echo "$ip: Открытые порты: $open_ports" >> open_ports.txt || echo "$ip: Нет открытых портов" >> open_ports.txt
    [[ -n "$device_info" ]] && echo "$ip: Тип устройства: $device_info" >> device_type.txt || echo "$ip: Тип устройства не определён" >> device_type.txt

done < active_ips.txt

# Завершение
echo -e "\n\n✅ Сканирование завершено!"
echo -e "📄 Сохранено:\n- active_ips.txt\n- os_info.txt\n- open_ports.txt\n- device_type.txt\n- full_os_scan_output.txt"

