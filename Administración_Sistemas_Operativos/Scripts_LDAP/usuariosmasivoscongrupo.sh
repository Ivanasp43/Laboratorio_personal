#!/bin/bash
# Autor: Ivana Sánchez Pérez
# Fecha: 16/02/2025
# Descripción: Creación masiva de usuarios LDAP e inserción en el directorio con asociación a grupo

# Definición de colores
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NC="\033[0m"

# UID y GID iniciales
uidNumber=2006
gidNumber=2000

# Nombre del grupo
groupName="usuarios"

# Crear archivo LDIF
ldif="/home/ivana/practica1/usuarios.ldif"
echo "" > "$ldif"

# Añadir el grupo si no existe en el archivo LDIF
if ! grep -q "cn=$groupName" "$ldif"; then
    {
        echo "dn: cn=$groupName,ou=groups,dc=ivanasp,dc=com"
        echo "objectClass: top"
        echo "objectClass: posixGroup"
        echo "cn: $groupName"
        echo "gidNumber: $gidNumber"
        echo ""
    } >> "$ldif"
fi

# Función para crear un usuario
crear_usuario() 
{
    echo ""
    read -p "${AZUL}Introduce el nombre: ${NC}" NOMBRE
    read -p "${AZUL}Introduce el apellido: ${NC}" APELLIDO
    read -p "${AZUL}Introduce el correo: ${NC}" MAIL
    read -p "${AZUL}Introduce el nombre de usuario: ${NC}" USUARIO

    # Validaciones básicas
    if [ -z "$NOMBRE" ] || [ -z "$APELLIDO" ] || [ -z "$MAIL" ] || [ -z "$USUARIO" ]; then
        echo ""
        echo -e "${ROJO}¡¡ERROR!! Todos los campos son obligatorios.${NC}"
        return
    fi

    dn="uid=$USUARIO,ou=people,dc=ivanasp,dc=com"
    sn="$APELLIDO"
    givenName="$USUARIO"
    cn="$NOMBRE $APELLIDO"
    userPassword=$(slappasswd -h {MD5} -s "$USUARIO")
    homeDirectory="/home/$USUARIO"
    loginShell="/bin/bash"

    # Agregar entradas del usuario al archivo LDIF
    {
        echo "dn: $dn"
        echo "objectClass: top"
        echo "objectClass: posixAccount"
        echo "objectClass: inetOrgPerson"
        echo "objectClass: shadowAccount"
        echo "uid: $USUARIO"
        echo "sn: $sn"
        echo "givenName: $givenName"
        echo "cn: $cn"
        echo "uidNumber: $uidNumber"
        echo "gidNumber: $gidNumber"
        echo "userPassword: $userPassword"
        echo "homeDirectory: $homeDirectory"
        echo "loginShell: $loginShell"
        echo "mail: $MAIL"
        echo ""
    } >> "$ldif"

    # Agregar usuario al grupo
    {
        echo "dn: cn=$groupName,ou=groups,dc=ivanasp,dc=com"
        echo "changetype: modify"
        echo "add: memberUid"
        echo "memberUid: $USUARIO"
        echo ""
    } >> "$ldif"

    # Crear directorio del usuario si no existe
    if [ ! -d "$homeDirectory" ]; then
        sudo mkdir -p "$homeDirectory"
        sudo cp -r /etc/skel/. "$homeDirectory"
        sudo chown -R "$uidNumber:$gidNumber" "$homeDirectory"
    fi

    uidNumber=$((uidNumber + 1))
}

# Bucle para crear usuarios de forma masiva
while true; do
    crear_usuario
    echo ""
    read -p "${AZUL}¿Deseas crear otro usuario? (s/n): ${NC}" respuesta
    if [[ ! "$respuesta" =~ ^[sS]$ ]]; then
        break
    fi
done

echo ""
echo -e "${MAGENTA}Archivo LDIF generado: $ldif${NC}"
echo ""

# Insertar usuarios en el directorio LDAP
echo ""
echo -e "${VERDE}Insertando usuarios en LDAP...${NC}"
ldapadd -x -D "cn=admin,dc=ivanasp,dc=com" -W -f "$ldif"

# Verificación de éxito
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${VERDE}Usuarios y grupo insertados correctamente en LDAP.${NC}"
else
    echo -e "${ROJO}Error al insertar usuarios en LDAP.${NC}"
fi
