#!/bin/bash
# initNFT.sh — 生成 nftables 防火墙规则配置 (/etc/nftables.conf)
# 规则: 仅放行 SSH(22)/HTTP(80,443) + 内网全通 + 回环 + 已建立连接

cat > /etc/nftables.conf << 'EOF'
#!/usr/sbin/nft -f

table inet filter {
    chain INPUT {
        type filter hook input priority 0; policy drop;

        tcp dport { 22, 80, 443 } accept

        ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } ip protocol { tcp, udp } accept

        iif lo accept

        ct state established,related accept

        ct state invalid counter drop

        ip protocol icmp drop

        counter reject with icmpx type admin-prohibited
    }

    chain FORWARD {
        type filter hook forward priority 0; policy drop;
    }
}
table ip nat {
    chain PREROUTING  {
        type nat hook prerouting priority -100; policy accept;
    }

    chain INPUT {
        type nat hook input priority 100; policy accept;
    }

    chain POSTROUTING {
        type nat hook postrouting priority 100; policy accept;
    }

    chain OUTPUT {
        type nat hook output priority -100; policy accept;
    }
    chain DOCKER {
    }
}
table ip filter {
    chain FORWARD {
        type filter hook forward priority 0; policy accept;
    }
    chain DOCKER {
    }
    chain DOCKER-ISOLATION-STAGE-1 {
    }
    chain DOCKER-ISOLATION-STAGE-2 {
    }
}
EOF
