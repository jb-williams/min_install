#!/usr/bin/env bash
bold='\e[1m'
red='\e[31m'
lightyellow='\e[93m'
blink='\e[5m'
default='\e[0;39m'
green='\e[32m'

reset2green() {
    printf "%b%b" "\e[0;39m" "\e[32m"
}

error_print() {
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-hardening-error.log
}

change_umask() { printf "\n%b%b%s%b\n" "${default}" "${green}" "Setting Umask...." "${default}"
    sudo sed -i 's/022/027/g' /etc/login.defs 2>/dev/null \
        || error_print "${FUNCNAME[idx]}" 
}
setup_ssh_moduli() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Setting up SSH moduli..." "${default}"
    sudo cp --archive /etc/ssh/moduli /etc/ssh/moduli-COPY-"$(date +'%Y%m%d%H%M%S')"
    sudo sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli.safe \
        || error_print "${FUNCNAME[idx]}" 
    sudo sh -c "mv -f /etc/ssh/moduli.safe /etc/ssh/moduli" \
        || error_print "${FUNCNAME[idx]}" 
}

setup_harden_ssh_conf() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Hardening SSH..." "${default}"
    sudo echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com" | sudo tee /etc/ssh/sshd_config.d/ssh-audit_hardening.conf \
        || error_print "${FUNCNAME[idx]}" 
}

setup_ssh_conf() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Configuring SSH..." "${default}"
    sudo cp --archive /etc/sshd_config /etc/ssh/sshd_config-COPY-"$(date +'%Y%m%d%H%M%S')"
    sudo sed -i 's/#LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#PermitRootLogin prohibit-passowrd/PermitRootLogin no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#MaxSessions 10/MaxSessions 2/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/AllowAgentForwarding yes/AllowAgentForwarding no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
}

restart_ssh() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Restarting SSH..." "${default}"
    sudo systemctl restart sshd \
        || error_print "${FUNCNAME[idx]}" 
}

setup_fail2ban() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Configuring Fail2ban..." "${default}"
    sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#ignoreip = 127.0.0.1/8 ::1/ignoreip = 127.0.0.1/8 ::1/g' /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/findtime = 10m/findtime = 15m/g' /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/maxretry = 5/maxretry = 3/g' /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
}

reset2green
change_umask \
	|| error_print "change_umask"
reset2green
setup_ssh_moduli \
	|| error_print "setup_ssh_moduli"
reset2green \
setup_harden_ssh_conf \
	|| error_print "setup_harden_ssh_conf"
reset2green \
setup_ssh_conf \
	|| error_print "setup_ssh_conf"
reset2green \
restart_ssh \
	|| error_print "restart_ssh"
reset2green \
setup_fail2ban \
	|| error_print "setup_fail2ban"

