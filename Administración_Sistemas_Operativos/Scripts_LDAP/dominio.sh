#!/bin/bash
# Autor: Ivana Sánchez Pérez
# Fecha: 16/02/2025
# Descripción: Script para crear un dominio en LDAP

# Definición de colores
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NC="\033[0m"

# Función para validar el nombre del dominio
validar_dominio() {
    if [[ ! "$1" =~ ^[a-zA-Z0-9.-]+$ ]]; then
        echo -e "${ROJO}El nombre del dominio es inválido.${NC}"
        exit 1
    fi
}

# Datos del dominio
read -p "${AZUL}Introduce el nombre del dominio (ej. ivanasp.com): ${NC}" DOMINIO
validar_dominio "$DOMINIO"  # Validar el dominio

read -p "${AZUL}Introduce el nombre del administrador: ${NC}" ADMIN
read -p "${AZUL}Introduce la contraseña del administrador: ${NC}" -s PASSWORD
echo ""

# Transformar el dominio en formato LDAP
IFS='.' read -r -a DOMINIO_PARTS <<< "$DOMINIO"
DC=""
for PART in "${DOMINIO_PARTS[@]}"; do
    DC="$DC,dc=$PART"
done
DC="${DC:1}"

# Crear archivo LDIF para el nuevo dominio
ldif="/tmp/nuevo_dominio.ldif"
echo "" > "$ldif"
{
    echo "dn: $DC"
    echo "objectClass: top"
    echo "objectClass: dcObject"
    echo "objectClass: organization"
    echo "o: $DOMINIO"
    echo "dc: ${DOMINIO_PARTS[0]}"
    echo ""
    echo "dn: cn=admin,$DC"
    echo "objectClass: simpleSecurityObject"
    echo "objectClass: organizationalRole"
    echo "cn: admin"
    echo "description: LDAP Administrator"
    echo "userPassword: $(slappasswd -h {SSHA} -s $PASSWORD)"
    echo ""
    echo "dn: ou=people,$DC"
    echo "objectClass: organizationalUnit"
    echo "ou: people"
    echo ""
    echo "dn: ou=groups,$DC"
    echo "objectClass: organizationalUnit"
    echo "ou: groups"
} >> "$ldif"

# Mostrar contenido del archivo LDIF
echo ""
echo -e "${MAGENTA}Contenido del archivo LDIF:${NC}"
cat "$ldif"

# Insertar el nuevo dominio en el directorio LDAP
echo ""
echo -e "${VERDE}Insertando el nuevo dominio en LDAP...${NC}"
if ! sudo ldapadd -x -D "cn=admin,$DC" -W -f "$ldif"; then
    echo -e "${ROJO}Error al crear el dominio en LDAP.${NC}"
    exit 1
fi

# Verificación de éxito
echo ""
echo -e "${VERDE}Dominio creado correctamente en LDAP.${NC}"