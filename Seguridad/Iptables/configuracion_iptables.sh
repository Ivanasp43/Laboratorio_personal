#!/bin/bash

# Habilitar el enrutamiento IP
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Limpiar reglas previas de iptables
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# 🔹 Reemplaza 'enp0s3' con la interfaz correcta 🔹
IFACE_WAN="enp0s3"   # Interfaz con salida a Internet
IFACE_LAN="enp0s8"   # Interfaz de la red interna

# Permitir tráfico de loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 🔹 Reglas DNS (consultas y respuestas)
iptables -A OUTPUT -o $IFACE_WAN -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i $IFACE_WAN -p udp --sport 53 -j ACCEPT

# 🔹 Permitir tráfico HTTP/HTTPS (para navegación web)
iptables -A FORWARD -i $IFACE_LAN -o $IFACE_WAN -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i $IFACE_LAN -o $IFACE_WAN -p tcp --dport 443 -j ACCEPT

# 🔹 Configurar NAT para permitir salida a Internet
iptables -t nat -A POSTROUTING -o $IFACE_WAN -j MASQUERADE

# 🔹 Permitir respuestas de tráfico establecido
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# 🔹 Bloquear todo lo demás (política por defecto)
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Guardar configuración
iptables-save > /etc/iptables.rules
echo "🔥 Configuración de iptables aplicada exitosamente."
