#!/bin/sh
## SCRIPT de IPTABLES –FIREWALL PARA LA RED 192.168.8.0/24
## 
echo -n Aplicando Reglas de Firewall...

## INICIALIZACIÓN
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

## Establecemos politica por defecto ACEPTAR
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

### Política de INPUT (servicios locales)

# Política de FORWARD (acceso a Internet y otras redes)

# Enmascaramiento
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 -o enp0s3 -j MASQUERADE

#Activar forwarding (reenvío de paquetes)
echo 1 > /proc/sys/net/ipv4/ip_forward

echo ""
echo " OK . Verifique  el filtrado  con: iptables -L -n"
echo " Verifique el enmascaramiento con: iptables -L -n -t nat"
# Fin del script
