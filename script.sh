#!/bin/bash

# Kolory
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Brak koloru

# Plik logów
LOG_FILE="skrypt_log.txt"

# Funkcja do wyświetlania menu
show_menu() {
    echo -e "${YELLOW}#################################################${NC}"
    echo -e "${YELLOW}#                                               #${NC}"
    echo -e "${YELLOW}#                 SKRYPT MENU                   #${NC}"
    echo -e "${YELLOW}#                                               #${NC}"
    echo -e "${YELLOW}#################################################${NC}"
}

# Funkcja do logowania wyników
log_results() {
    echo "$1" >> $LOG_FILE
}

# Funkcja do walidacji adresu IP
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        echo -e "${RED}Invalid IP address${NC}"
        return 1
    fi
}

# Funkcja do skanowania portów
scan_ports() {
    read -p "$1: " ip
    if validate_ip $ip; then
        local results=$(nmap $ip)
        echo -e "${GREEN}$results${NC}"
        log_results "$results"
    fi
}

# Funkcja do analizy protokołów
analyze_protocols() {
    read -p "$1: " interface
    local results=$(tshark -i $interface)
    echo -e "${GREEN}$results${NC}"
    log_results "$results"
}

# Funkcja do skanowania podatności
scan_vulnerabilities() {
    read -p "$1: " ip
    if validate_ip $ip; then
        local results=$(nmap --script vuln $ip)
        echo -e "${GREEN}$results${NC}"
        log_results "$results"
    fi
}

# Funkcja do monitorowania sieci
monitor_network() {
    read -p "$1: " interface
    local results=$(tcpdump -i $interface)
    echo -e "${GREEN}$results${NC}"
    log_results "$results"
}

# Funkcja do wyboru języka
choose_language() {
    show_menu
    echo "1. English"
    echo "2. Deutsch"
    echo "3. Polski"
    read -p "Choose language/Wählen Sie eine Sprache/Wybierz język: " lang_choice
    case $lang_choice in
        1) lang="en";;
        2) lang="de";;
        3) lang="pl";;
        *) echo -e "${RED}Invalid choice/Ungültige Wahl/Nieprawidłowy wybór${NC}"; exit 1;;
    esac
}

# Wybór języka
choose_language

# Wybór zadania w zależności od wybranego języka
case $lang in
    "en")
        show_menu
        echo "1. Port Scanning"
        echo "2. Protocol Analysis"
        echo "3. Vulnerability Scanning"
        echo "4. Network Monitoring"
        read -p "Choose task: " task_choice
        case $task_choice in
            1) scan_ports "Enter IP address";;
            2) analyze_protocols "Enter network interface";;
            3) scan_vulnerabilities "Enter IP address";;
            4) monitor_network "Enter network interface";;
            *) echo -e "${RED}Invalid choice${NC}"; exit 1;;
        esac
        ;;
    "de")
        show_menu
        echo "1. Port-Scanning"
        echo "2. Protokollanalyse"
        echo "3. Schwachstellenscanning"
        echo "4. Netzwerküberwachung"
        read -p "Aufgabe wählen: " task_choice
        case $task_choice in
            1) scan_ports "IP-Adresse eingeben";;
            2) analyze_protocols "Netzwerkschnittstelle eingeben";;
            3) scan_vulnerabilities "IP-Adresse eingeben";;
            4) monitor_network "Netzwerkschnittstelle eingeben";;
            *) echo -e "${RED}Ungültige Wahl${NC}"; exit 1;;
        esac
        ;;
    "pl")
        show_menu
        echo "1. Skanowanie Portów"
        echo "2. Analiza Protokołów"
        echo "3. Skanowanie Podatności"
        echo "4. Monitorowanie Sieci"
        read -p "Wybierz zadanie: " task_choice
        case $task_choice in
            1) scan_ports "Podaj adres IP";;
            2) analyze_protocols "Podaj interfejs sieciowy";;
            3) scan_vulnerabilities "Podaj adres IP";;
            4) monitor_network "Podaj interfejs sieciowy";;
            *) echo -e "${RED}Nieprawidłowy wybór${NC}"; exit 1;;
        esac
        ;;
esac
