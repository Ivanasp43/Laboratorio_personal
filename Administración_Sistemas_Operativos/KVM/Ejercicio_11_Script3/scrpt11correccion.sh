#!/bin/bash
#Autor:Ivana Sánchez Pérez
#Fecha: 09/11/2024
#Descripción: Este escript muestra un menú para gestionar pools
clear

# variables y constantes
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NC="\033[0m"

archivo_nombres="maquinas.txt"
archivo_nuevo="temp.txt"
ISO="/home/ivana/Descargas/alpine-virt-3.17.8-x86_64.iso"
directorio_disco="/var/lib/libvirt/images"
total_ram=0
contador_VM=0

##Funciones
# Función para verificar si es root
tuSerRoot() 
{
        if [ "$(id -u)" != 0 ]; then
                echo ""
        echo -e "${ROJO}¡¡ERROR!! Este script sólo puede ser ejecutado por el r>
        exit 1
    fi
}

# Verificar si el archivo maquinas.txt existe
verificarArchivo()
{
    if [ ! -f "$archivo_nombres" ]; then
        echo""
        echo -e "${ROJO}El archivo maquinas.txt no existe. ${NC}"
        exit 1
    fi
}

# Crear el archivo temp.txt
generarArchivo_temp()
{
        echo""
        echo -e "${MAGENTA}Generando el archivo temp.txt... ${NC}"
        rm -f "$archivo_nuevo"
    while IFS=':' read -r nombre apellido1 apellido2 hd ram; do
        nombre_maquina="MV${contador_VM}-$(echo ${nombre:0:1}${apellido1:0:3} | tr '[:upper:]' '[:lower:]')"

            echo""
            echo -e "${AZUL}$nombre_maquina:${ram}:${hd} ${NC}" >> "$archivo_nu>
        total_ram=$((total_ram + ram))
        contador_VM=$((contador_VM + 1))
    done < "$archivo_nombres"
        echo""
        echo -e "${VERDE}Archivo temp.txt ha sido generado con éxito ${NC}"
}

# Mostrar el contenido en pantalla del archivo temp.txt
mostrarArchivo_temp()
{
 echo""
    echo -e "${MAGENTA}Contenido de temp.txt: ${NC}"
    echo""
    cat "$archivo_nuevo"
}

# Creación de la máquinas virtuales
crearVM()
{
    maquinas_creadas=0

        echo""
        echo -e "${AZUL}Creando máquinas virtuales en KVM... ${NC}"
    while IFS=: read -r nombre_maquina ram hd; do  
        disco="${directorio_disco}/${nombre_maquina}.qcow2"
            echo""
            echo -e "${AZUL}Creando disco: $disco (${hd}G)... ${NC}"
        if ! qemu-img create -f qcow2 "$disco" "${hd}G"; then
            echo -e "${ROJO}Error al crear disco: $disco. ${NC}"
            continue
        fi
            echo""
            echo -e "${AZUL}Creando máquina virtual: $nombre_maquina con RAM ${>
        if  ! virt-install --connect qemu:///system --name "$nombre_maquina" -->
            continue
        fi
        maquinas_creadas=$((maquinas_creadas + 1)) # Contador para ver las máqu>
    done < "$archivo_nuevo"

                    echo ""
        if [ $maquinas_creadas -eq 0 ]; then
            echo -e "${ROJO}¡¡ERROR!! No se han creado las máquinas virtuales. >
        else
                    echo -e "${VERDE}Todas las máquinas virtuales se han creado>
        fi
}

# Informe final
generarInforme() 
{
    echo ""
    echo -e "${MAGENTA}Generando informe... ${NC}"
echo ""
        echo "-----------------------------------------" > informe.txt
        echo "Informe de Creación de Máquinas Virtuales" >> informe.txt
        echo "-----------------------------------------" >> informe.txt
        echo ""
        echo "Número total de máquinas: $contador_VM" >> informe.txt
        echo "Tamaño total de RAM: ${total_ram}MB" >> informe.txt
        echo ""
        echo "-----------------------------------------" >> informe.txt
        echo ""
        cat informe.txt
}

# Bloque principal

tuSerRoot
verificarArchivo
generarArchivo_temp
mostrarArchivo_temp
crearVM
generarInforme

