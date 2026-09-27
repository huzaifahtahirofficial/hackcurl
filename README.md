<div align="center">

# 🖥️ HACKCURL PRO

### The Swiss Knife of HTTP — Now With a Hacking Console

**An interactive, hacker-themed `curl` toolkit for bug bounty, pentesting, and CTF**

[![Bash](https://img.shields.io/badge/Bash-4.0%2B-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-informational?logo=linux&logoColor=white)]()
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-2.1-brightgreen)]()
[![Status](https://img.shields.io/badge/Status-Active-success)]()

⚠️ **FOR AUTHORIZED TESTING ONLY** ⚠️

</div>

---

## 📖 What Is This?

**HACKCURL PRO** is a single-file Bash tool that turns raw `curl` commands into an interactive, menu-driven cyber-ops console. Instead of memorizing dozens of flag combinations, you pick a module — the tool handles headers, payloads, timing analysis, output highlighting, and logging for you.

Built around **real bug bounty attack chains** and shipped with a **Matrix-inspired terminal UI**, it's the fastest way to go from "new target" to "first findings" without leaving your shell.

> *"Because remembering 40 curl flags at 3 AM isn't fun."*

---

## ✨ Features

| | Feature |
|---|---|
| 🎨 | **Hacker UI** — Matrix rain, glitch banner, neon colors, blinking findings |
| 🧩 | **9 Modules** — Recon, SSRF, Auth, Injection, Race, Stealth, Fuzzer, Full Auto |
| 📚 | **Self-Documenting** — every module shows WHAT / GIVES / EXAMPLE before running |
| 🩹 | **Self-Healing** — auto-installs missing `curl`, `jq`, `dnsutils` |
| 📝 | **Auto-Logging** — every request saved to `/tmp/hackcurl_reports/` |
| 🎯 | **CTF + Bounty Ready** — payloads from real-world writeups |
| 🕶️ | **Stealth Mode** — HTTP proxy, Tor, random User-Agent rotation |
| ⚡ | **Zero Framework** — one `.sh` file, runs on any Linux with bash |

---

## 🚀 Installation

### Quick Install

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/hackcurl-pro.git
cd hackcurl-pro

# Make it executable
chmod +x hackcurl.sh

# Run
./hackcurl.sh
```

### Install Globally

```bash
sudo cp hackcurl.sh /usr/local/bin/hackcurl
sudo chmod +x /usr/local/bin/hackcurl

# Now run from anywhere
hackcurl
```

### Dependencies

The tool **auto-installs** these on first run, but you can also install them manually:

```bash
# Debian / Ubuntu / Kali
sudo apt install -y curl jq dnsutils

# Fedora / RHEL
sudo dnf install -y curl jq bind-utils

# Arch / Manjaro
sudo pacman -S --noconfirm curl jq bind
```

| Dependency | Purpose |
|---|---|
| `curl` | Every HTTP request |
| `jq` | URL encoding + JSON parsing |
| `dig` / `dnsutils` | DNS resolution in recon module |

---

## 🎮 Usage

### Quick Start

```bash
./hackcurl.sh
```

1. **Set a target** — press `0` and paste your URL (e.g. `https://test.example.com`)
2. **Pick a module** — press `1` through `8` from the menu
3. **Watch findings** — anything suspicious is highlighted in red with `[★ FINDING]`
4. **Review logs** — check `/tmp/hackcurl_reports/` for full transcripts

### Menu Overview

```
[0] Set Target            Define the base URL all modules attack
[1] Auto Recon            DNS → headers → WAF → sensitive paths
[2] SSRF / Redirect       SSRF, open redirect, host header injection
[3] Auth Attacks          JWT alg:none, cookie tamper, IDOR
[4] Injection             SQLi, XSS, SSTI, LFI, XXE, NoSQL
[5] Race Condition        Fire 30+ parallel requests (aggressive)
[6] Stealth Mode          Proxy, Tor, random User-Agent
[7] Param Fuzzer          Wordlist injection into URL/header/cookie/body
[8] FULL AUTO CHAIN       recon → ssrf → injection in one shot
[9] Exit

[h] Help / usage guide    [q] Quit
```

### Global Keys

| Key | Action |
|---|---|
| `h` | Show help / usage guide |
| `b` | Back / cancel current prompt |
| `q` | Quit tool |
| `ENTER` | Skip optional prompts / return to menu |

---

## 🔬 Modules In Detail

<details>
<summary><b>[1] Auto Recon Pipeline</b></summary>

Walks six phases against the target:

1. **DNS** — `dig +short` on the hostname
2. **Fingerprint** — extracts `Server`, `X-Powered-By`, `CF-Ray`, etc.
3. **Raw headers** — full response header dump
4. **WAF / CDN detection** — Cloudflare, Sucuri, Akamai, CloudFront, Fastly
5. **robots.txt / sitemap.xml / security.txt**
6. **Sensitive paths** — `.git/config`, `.env`, `admin/`, `swagger.json`, `phpinfo.php`, `server-status`, `backup.zip`

**Output:** A fingerprint of the target + list of exposed files, saved to `/tmp/hackcurl_reports/recon_*.txt`.

</details>

<details>
<summary><b>[2] SSRF / Open Redirect / Host Header Injection</b></summary>

Injects internal URLs into redirect/url/fetch parameters:

- `http://127.0.0.1`, `http://localhost:8080`, `http://[::1]`
- `http://169.254.169.254/latest/meta-data/` (AWS IMDS)
- `file:///etc/passwd`, `gopher://127.0.0.1:6379/_INFO`, `dict://`

Also tests:
- Open redirect (`//evil.com`, `https:evil.com`, `/\\evil.com`)
- Host header poisoning (`Host: evil.com`, `Host: localhost`)

</details>

<details>
<summary><b>[3] Auth Attacks</b></summary>

- **JWT `alg:none` forgery** — paste a token, get a forged one back
- **Cookie tampering** — tries `role=admin`, `admin=true`, `role=root`
- **IDOR enumeration** — iterates IDs on `/api/user/{id}`-style endpoints

</details>

<details>
<summary><b>[4] Injection Playground</b></summary>

Six sub-modules, each with curated payloads:

| Class | Payloads |
|---|---|
| **SQLi** | `' OR '1'='1`, `1' AND SLEEP(3)-- -` (time-based) |
| **XSS** | `<script>alert(1)</script>`, `"><svg onload=alert(1)>` |
| **SSTI** | `{{7*7}}`, `${7*7}`, `#{7*7}` — looks for `49` |
| **LFI** | `../../../etc/passwd`, `....//....//etc/passwd` |
| **XXE** | Sends XML with `<!ENTITY xxe SYSTEM "file:///etc/passwd">` |
| **NoSQL** | JSON `{"$ne":null}`, `{"$gt":""}` on login |

</details>

<details>
<summary><b>[5] Race Condition Burst</b></summary>

Fires **N parallel requests** (default 30) to detect TOCTOU bugs:

```bash
for i in $(seq 1 30); do
  curl -X POST "$TARGET$PATH" -d "$DATA" -o "/tmp/race_$i.out" &
done
wait
```

Analyzes response **size histogram** — multiple distinct sizes = possible race.

</details>

<details>
<summary><b>[6] Stealth Mode</b></summary>

- Set HTTP proxy (Burp, ZAP, mitmproxy)
- Route through **Tor** (`socks5h://127.0.0.1:9050`)
- Rotate **User-Agents** (Chrome, Firefox, Safari, Googlebot)

</details>

<details>
<summary><b>[7] Parameter Fuzzer</b></summary>

Inject a wordlist into:
1. **URL path** (`/$word`)
2. **Header** (`X-Test: $word`)
3. **Cookie** (`test=$word`)
4. **POST body** (`in=$word`)

Flags any response whose **size differs** from baseline.

</details>

<details>
<summary><b>[8] FULL AUTO CHAIN</b></summary>

One keystroke runs:
- Phase 1: Recon (headers + sensitive paths)
- Phase 2: SSRF probes
- Phase 3: SQLi probes

Ideal for first-pass triage on new bounty scopes.

</details>

---

## 🖼️ Screenshots

> *Add your own screenshots here. Suggested captures:*

```
docs/
├── 01-boot.png          # Matrix rain + glitch banner
├── 02-menu.png          # Main operations menu
├── 03-recon.png         # Auto recon in progress
├── 04-finding.png       # [★ FINDING] highlighted output
└── 05-help.png          # Usage guide screen
```

---

## 📂 Project Structure

```
hackcurl-pro/
├── hackcurl.sh              # Main tool (single file)
├── README.md                # This file
├── LICENSE                  # MIT
└── docs/
    └── screenshots/
```

**Log output location:**

```
/tmp/hackcurl_reports/
├── scan_<host>_<timestamp>.log     # Full session log
├── recon_<host>_<timestamp>.txt    # Recon report
└── auto_recon_<timestamp>.txt      # Full auto chain output
```

---

## 🧠 Real-World Combo Inspiration

HACKCURL PRO's payloads and sequences are pulled from **published research**:

| Combo | Source Pattern |
|---|---|
| `Host:` header + password reset → ATO | HackerOne classic |
| SSRF → `169.254.169.254` → AWS keys | Capital One (2019) |
| JWT `alg:none` + role claim → admin | Frequent CTF/wild |
| Race condition on coupon redeem | Turbo Intruder docs |
| GraphQL introspection → IDOR chain | Modern API bugs |
| `X-Forwarded-Host` + cache poisoning | James Kettle research |
| `.git/config` → source review → keys | Auto-recon staple |

---

## ⚠️ Legal Disclaimer

> **HACKCURL PRO is intended strictly for authorized security testing.**
>
> You may only run this tool against:
> - ✅ Your own servers and infrastructure
> - ✅ Bug bounty programs where you are in-scope
> - ✅ Training labs (HackTheBox, TryHackMe, DVWA, OWASP Juice Shop, PortSwigger Web Security Academy)
>
> You may **NOT** run this tool against:
> - ❌ Systems you do not own and lack **written authorization** to test
> - ❌ Public infrastructure, government systems, or third-party services
>
> Running aggressive modules (injection, race condition, full auto) without authorization is **illegal** in most jurisdictions and carries criminal penalties. The author assumes **no liability** for misuse.

---

## 🤝 Contributing

Pull requests are welcome! Here's how to help:

1. **Fork** the repo
2. **Create a branch** (`git checkout -b feature/new-module`)
3. **Commit** (`git commit -m 'Add Nuclei-style templates'`)
4. **Push** (`git push origin feature/new-module`)
5. **Open a PR**

### Ideas for Contributors

- [ ] GraphQL introspection module
- [ ] Subdomain enumeration via `crt.sh`
- [ ] Nuclei-style YAML template support
- [ ] JSON / Markdown report export
- [ ] Dockerfile for containerized runs
- [ ] Auto-copy findings to clipboard
- [ ] Integration with `ffuf` and `nuclei`

---

## 🗺️ Roadmap

- [x] v1.0 — Basic cheatsheet viewer
- [x] v2.0 — Automated execution modules
- [x] v2.1 — Interactive UI + descriptions
- [ ] v2.2 — GraphQL + subdomain modules
- [ ] v2.3 — JSON/Markdown report export
- [ ] v3.0 — Plugin system + YAML templates

---

## 📜 License

MIT License — see [LICENSE](LICENSE) for details.

You are free to use, modify, and distribute this tool. **Attribution appreciated, not required.**

---

## 🙏 Credits

- Payload inspiration from **PortSwigger Research**, **HackerOne Hacktivity**, and countless community writeups
- ASCII banner style inspired by the `figlet` and `toilet` communities
- Matrix rain effect — a love letter to the 1999 classic

---

## ⭐ Show Your Support

If this tool helped you land a bug, ace a CTF, or pass a cert — **give it a star** ⭐

It helps others find the project and keeps the motivation alive.

---

<div align="center">

**Made with 🖤 by hackers, for hackers**

*Stay legal. Stay curious. Stay dangerous.*

```
                    ┌─────────────────────────────┐
                    │   root@hackcurl:~# _        │
                    └─────────────────────────────┘
```

</div>
