#!/bin/bash
# Autor: Ivana Sánchez Pérez
# Fecha: 16/02/2025
# Descripción: Creación masiva de usuarios LDAP e inserción en el directorio

# Definición de colores
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NC="\033[0m"

# Ruta al archivo de datos
datos="/home/ivana/practica1/script_usuarios_ldap/datos.txt"

# Verificar que el archivo existe y tiene contenido
if [ ! -s "$datos" ]; then
    echo -e "${ROJO}¡¡ERROR!! El archivo de datos no existe o está vacío.${NC}"
    exit 1
fi

# UID inicial
uidNumber=2006
gidNumber=2000

# Crear archivo LDIF
ldif="/home/ivana/practica1/usuarios.ldif"
echo "" > "$ldif"

# Leer archivo de datos y procesar cada línea
while IFS=',' read -r NOMBRE APELLIDO MAIL USUARIO
do
    if [ "$NOMBRE" != "Nombre" ]; then
        dn="uid=$USUARIO,ou=people,dc=ivanasp,dc=com"


        
        sn="$APELLIDO"
        givenName="$USUARIO"
        cn="$NOMBRE $APELLIDO"
        userPassword=$(slappasswd -h {MD5} -s "$USUARIO")
        homeDirectory="/home/$USUARIO"
        loginShell="/bin/bash"

        # Agregar entradas al archivo LDIF
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

        # Crear directorio del usuario si no existe
        if [ ! -d "$homeDirectory" ]; then
            sudo mkdir -p "$homeDirectory"
            sudo cp -r /etc/skel/. "$homeDirectory"
            sudo chown -R "$uidNumber:$gidNumber" "$homeDirectory"
        fi

        uidNumber=$((uidNumber + 1))
    fi
done < "$datos"

echo -e "${MAGENTA}Archivo LDIF generado: $ldif${NC}"
echo ""

# Insertar usuarios en el directorio LDAP
echo -e "${VERDE}Insertando usuarios en LDAP...${NC}"
ldapadd -x -D "cn=admin,dc=ivanasp,dc=com" -W -f "$ldif"

# Verificación de éxito
if [ $? -eq 0 ]; then
    echo -e "${VERDE}Usuarios insertados correctamente en LDAP.${NC}"
else
    echo -e "${ROJO}Error al insertar usuarios en LDAP.${NC}"
fi
