#!/bin/bash
# Autor: Ivana Sánchez Pérez
# Fecha: 10/01/2025
# Descripción: Creación de usuarios en Proxmox
clear

# Variantes y constantes
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NC="\033[0m"

# Función para crear pools
crearPools() {
    local num_usuarios
    echo ""
    read -p "Ingrese el número de usuarios que desea crear: " num_usuarios
    while ! [[ "$num_usuarios" =~ ^[0-9]+$ ]]; do
        echo -e "${ROJO}Error: Debe ingresar un número válido.${NC}"
        read -p "Ingrese el número de usuarios que desea crear: " num_usuarios
    done

    # Crear o limpiar el archivo de informe
    echo ""
    echo -e "${AZUL}Informe de Pools Creado${NC}" > informe_pools.txt
    echo -e "${AZUL}========================${NC}" >> informe_pools.txt

    for ((i=0; i<num_usuarios; i++)); do
        echo ""
        read -p "$(echo -e "${AZUL}Ingrese el nombre del usuario $((i+1)): ${NC} ") " nombre_usuario
        read -p "$(echo -e "${AZUL}Ingrese el grupo al que pertenece el usuario: ${NC} ") " grupo_usuario
        read -sp "$(echo -e "${AZUL}Ingrese la contraseña para el usuario $nombre_usuario: ${NC} ")" contrasena_usuario
        echo ""  # Para nueva línea después de la entrada de contraseña

        # Crear pool
        pool_name=$(printf "pool-%02d-%s" $i $nombre_usuario)
        echo -e "${VERDE}Creando pool: $pool_name${NC}"
        pvesh create /pools --pool $pool_name --storage local --storage local-lvm
        if [ $? -ne 0 ]; then
            echo -e "${ROJO}Error al crear el pool: $pool_name${NC}"
            continue
        fi

        # Asignar roles
        echo -e "${MAGENTA}Asignando roles al pool y grupo...${NC}"
        pvesh set /pools/$pool_name --roles pool.audit,vm.audit --group $grupo_usuario

        # Crear usuario y establecer contraseña
        echo -e "${VERDE}Creando usuario: $nombre_usuario${NC}"
        pvesh create /access/users --userid $nombre_usuario@pve --password $contrasena_usuario

        # Guardar información en el informe
        echo -e "${VERDE}Pool creado: $pool_name, Grupo: $grupo_usuario, Usuario: $nombre_usuario${NC}" >> informe_pools.txt
    done
    echo ""
    echo -e "${AZUL}Se han creado $num_usuarios pools.${NC}"
}

# Ejecutar la función
crearPools
