#!/bin/bash 
# Autor: Ivana Sánchez Pérez
# Fecha: 16/02/2025
# Descripción: Creación masiva de usuarios LDAP e inserción en el directorio con verificación de existencia

# Definición de colores
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NARANJA="\033[38;5;214m"
NC="\033[0m"

# UID inicial (comienza en 2100 y decrece de dos en dos)
uidNumber=2100
gidNumber=10000
GRUPO_DEFECTO="cn=grupo1,ou=grupos,dc=pc302,dc=com"

# Credenciales LDAP
LDAP_ADMIN="cn=admin,dc=pec302,dc=com"

# Crear archivo LDIF
ldif="/home/usuario/techservices/usuarios.ldif"
echo "" > "$ldif"

# Crear archivo de informe generado
informe="/home/usuario/techservices/informe_usuarios.txt"
echo -e "${AZUL}                     Informe de Usuarios Creados${NC}" > "$informe"
echo -e "${AZUL}===============================================================================${NC}" >> "$informe"
echo -e "${AZUL}UID\tNombre\tApellido\tCorreo\tUsuario\tTeléfono\tFecha Creación${NC}" >> "$informe"
echo -e "${AZUL}===============================================================================${NC}" >> "$informe"
echo ""
echo "" >> "$informe"

# Función para verificar si el usuario ya existe
usuario_existe() {
    uid=$1
    resultado=$(ldapsearch -x -D "$LDAP_ADMIN" -W -b "ou=people,dc=ivanasp,dc=com" "uid=$uid" | grep "^dn:")
    if [ -n "$resultado" ]; then
        return 0  # El usuario existe
    else
        return 1  # El usuario no existe
    fi
}

# Función para crear un usuario
crear_usuario() {
    echo ""
    read -p "$(echo -e "${NARANJA}Introduce el nombre: ${NC}")" NOMBRE
    read -p "$(echo -e "${NARANJA}Introduce el apellido: ${NC}")" APELLIDO
    read -p "$(echo -e "${NARANJA}Introduce el correo: ${NC}")" MAIL
    read -p "$(echo -e "${NARANJA}Introduce el nombre de usuario: ${NC}")" USUARIO
    read -p "$(echo -e "${NARANJA}Introduce el teléfono: ${NC}")" TELEFONO

    # Validaciones básicas
    if [ -z "$NOMBRE" ] || [ -z "$APELLIDO" ] || [ -z "$MAIL" ] || [ -z "$USUARIO" ] || [ -z "$TELEFONO" ]; then
        echo ""
        echo -e "${ROJO}¡¡ERROR!! Todos los campos son obligatorios.${NC}"
        return
    fi

    # Verificación de existencia de usuario en LDAP
    if usuario_existe "$USUARIO"; then
        echo -e "${ROJO}El usuario '$USUARIO' ya existe en LDAP. Se omite la creación.${NC}"
        return
    fi

    dn="uid=$USUARIO,ou=people,dc=examen,dc=com"
    sn="$APELLIDO"
    givenName="$USUARIO"
    cn="$NOMBRE $APELLIDO"
    userPassword=$(slappasswd -h {MD5} -s "$USUARIO")
    homeDirectory="/home/$USUARIO"
    telephoneNumber="$TELEFONO"
    loginShell="/bin/bash"
    fecha_creacion=$(date "+%d/%m/%Y")

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
        echo "telephoneNumber: $TELEFONO"
        echo ""
    } >> "$ldif"

    # Asignar grupo al usuario
    {
        echo "dn: $GRUPO_DEFECTO"
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

    # Agregar detalles del usuario al informe generado
    echo -e "$((2101 - uidNumber))\t$NOMBRE\t$APELLIDO\t$MAIL\t$USUARIO\t$TELEFONO\t$fecha_creacion" >> "$informe"

    # Decrecer el UID en dos
    uidNumber=$((uidNumber - 2))
}

# Bucle para crear usuarios de forma masiva
while true; do
    crear_usuario
    echo ""
    read -p "$(echo -e "${AZUL}¿Deseas crear otro usuario? (s/n): ${NC}")" respuesta
    if [[ ! "$respuesta" =~ ^[sS]$ ]]; then
        break
    fi
done

echo ""
echo -e "${MAGENTA}Archivo LDIF generado: $ldif${NC}"
echo -e "${MAGENTA}Informe generado: $informe${NC}"
echo ""

# Insertar usuarios en el directorio LDAP
echo ""
echo -e "${VERDE}Insertando usuarios en LDAP...${NC}"
ldapadd -x -D "$LDAP_ADMIN" -W -f "$ldif"

# Verificación de éxito
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${VERDE}Usuarios insertados correctamente en LDAP.${NC}"
else
    echo -e "${ROJO}Error al insertar usuarios en LDAP.${NC}"
fi

# Mostrar el contenido del informe generado como tabla
echo ""
#echo -e "${AZUL}Informe de Usuarios Creados:${NC}"
column -t -s $'\t' "$informe"
