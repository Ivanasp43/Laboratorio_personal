#!/bin/bash
# Autor: Ivana Sánchez Pérez
# Fecha: 24/02/2025
# Descripción: Creación de dominio, grupo y usuarios en LDAP

# Definición de colores
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NC="\033[0m"

# Configuración del dominio y grupo
DOMINIO="dc=ivanasp,dc=com"
OU_PEOPLE="ou=people,$DOMINIO"
OU_GROUPS="ou=groups,$DOMINIO"
GRUPO_DEFECTO="cn=usuarios,$OU_PEOPLE"
uidNumber=2006
gidNumber=2000

# Archivos de salida
ldif="/home/ivana/practica1/usuarios.ldif"
usuarios_creados="/home/ivana/practica1/usuarios_creados.txt"
echo "" > "$ldif"
echo "Usuarios creados (Fecha: $(date)):" > "$usuarios_creados"
echo "" >> "$usuarios_creados"

# Función para crear el dominio si no existe
crear_dominio() {
    echo -e "${MAGENTA}Verificando el dominio...${NC}"
    ldapsearch -x -b "$DOMINIO" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${AZUL}Dominio no encontrado. Creando dominio...${NC}"
        cat <<EOF > dominio.ldif
dn: $DOMINIO
objectClass: top
objectClass: dcObject
objectClass: organization
o: ivanasp
dc: ivanasp

dn: $OU_PEOPLE
objectClass: organizationalUnit
ou: people

dn: $OU_GROUPS
objectClass: organizationalUnit
ou: groups
EOF
        ldapadd -x -D "cn=admin,$DOMINIO" -W -f dominio.ldif
        echo -e "${VERDE}Dominio y OUs creados correctamente.${NC}"
    else
        echo -e "${VERDE}El dominio ya existe.${NC}"
    fi
}

# Función para crear el grupo si no existe
crear_grupo() {
    echo -e "${MAGENTA}Verificando el grupo...${NC}"
    ldapsearch -x -b "$GRUPO_DEFECTO" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${AZUL}Grupo no encontrado. Creando grupo...${NC}"
        cat <<EOF >> "$ldif"
dn: $GRUPO_DEFECTO
objectClass: top
objectClass: posixGroup
cn: usuarios
gidNumber: $gidNumber
EOF
    else
        echo -e "${VERDE}El grupo ya existe.${NC}"
    fi
}

# Función para crear un usuario
crear_usuario() {
    echo ""
    read -p "${AZUL}Introduce el nombre: ${NC}" NOMBRE
    read -p "${AZUL}Introduce el apellido: ${NC}" APELLIDO
    read -p "${AZUL}Introduce el correo: ${NC}" MAIL
    read -p "${AZUL}Introduce el nombre de usuario: ${NC}" USUARIO

    # Validaciones básicas
    if [ -z "$NOMBRE" ] || [ -z "$APELLIDO" ] || [ -z "$MAIL" ] || [ -z "$USUARIO" ]; then
        echo -e "${ROJO}¡¡ERROR!! Todos los campos son obligatorios.${NC}"
        return
    fi

    # Verificar si el usuario ya existe
    ldapsearch -x -b "$OU_PEOPLE" "(uid=$USUARIO)" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${ROJO}El usuario $USUARIO ya existe en LDAP.${NC}"
        return
    fi

    dn="uid=$USUARIO,$OU_PEOPLE"
    sn="$APELLIDO"
    givenName="$USUARIO"
    cn="$NOMBRE $APELLIDO"
    userPassword=$(slappasswd -h {MD5} -s "$USUARIO")
    homeDirectory="/home/$USUARIO"
    loginShell="/bin/bash"

    # Agregar usuario al archivo LDIF
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

    # Agregar al grupo
    {
        echo "dn: $GRUPO_DEFECTO"
        echo "changetype: modify"
        echo "add: memberUid"
        echo "memberUid: $USUARIO"
        echo ""
    } >> "$ldif"

    # Registro en archivo
    {
        echo "| $USUARIO | $NOMBRE $APELLIDO | $MAIL | $uidNumber |"
        echo "|----------|-------------------|--------|------------|"
    } >> "$usuarios_creados"

    uidNumber=$((uidNumber + 1))
}

# Ejecutar funciones
crear_dominio
crear_grupo
while true; do
    crear_usuario
    read -p "${AZUL}¿Deseas crear otro usuario? (s/n): ${NC}" respuesta
    if [[ ! "$respuesta" =~ ^[sS]$ ]]; then
        break
    fi
done

# Insertar en LDAP
ldapadd -x -D "cn=admin,$DOMINIO" -W -f "$ldif"

# Mostrar tabla de usuarios creados
echo -e "${AZUL}Usuarios creados:${NC}"
cat "$usuarios_creados"
