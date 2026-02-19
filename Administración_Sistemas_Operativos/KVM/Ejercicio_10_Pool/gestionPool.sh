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

informe="Informe_Pool.txt"
rutaPool="/var/lib/libvirt/images/"

##Funciones
# Función continuar
pausa()
{
	echo ""
	read -p "Presione Enter para continuar..."
	clear
}
    			
# Función para verificar si es root
tuSerRoot() 
{
	if [ "$(id -u)" != 0 ]; then
		echo ""
        	echo -e "${ROJO}¡¡ERROR!! Este script sólo puede ser ejecutado por el root. ${NC}"
        exit 1
    	fi
}

# Función para visualizar los pools existentes
verPool() 
{
	clear
	echo ""
    	echo -e "${MAGENTA}Los Pools de almacenamiento existentes son: ${NC}"
    	echo ""
    	virsh pool-list --all
    	pausa
}

# Función para crear discos duros
crearDiscos() 
{
	clear
	echo ""
	echo -e "${MAGENTA}Creando discos duros... ${NC}"
	echo ""
	virsh list --all
	echo ""
    	read -p "¿Cuántos discos deseas crear? " numero
    	if ! [[ "$numero" =~ ^[0-9]+$ ]]; then
    		echo ""
        	echo -e "${ROJO}¡¡ERROR!! Por favor, ingrese un número válido. ${NC}"
        	return 1
    	fi

    for ((i=1; i<=numero; i++)); do
        	read -p "Ingrese el nombre de la VM con número de disco (ej: <VM-nombre>-Disco1): " nombreDisco
        	read -p "Ingrese el tamaño del disco $i (en GB): " tamano
        
        if ! [[ "$tamano" =~ ^[0-9]+$ ]]; then
        	echo ""
           	echo -e "${ROJO}¡¡ERROR!! El tamaño debe ser un número. ${NC}"
           	continue
        fi 
        virsh vol-create-as --pool default --format qcow2 "$nombreDisco".qcow2 "$tamano"G
        if [ $? -eq 0 ]; then
        	echo -e "${VERDE}Disco "$nombreDisco".qcow2 de "$tamano"GB creado correctamente ${NC}"
	else 
		echo -e "${ROJO}Error al crear el disco "$nombreDisco". ${NC}"
	fi
    done
    pausa
}

# Función para mostrar información de discos
informacionDiscos() 
{
	clear
    		echo ""
   		echo -e "${MAGENTA}Información de discos duros ${NC}"
   		echo ""
    		virsh vol-list default --details 		
        pausa 
}

# Función para agregar discos a una VM
agregarDiscoVM() 
{
	clear
		echo ""
		echo -e "${AZUL}Discos disponibles... ${NC}"
			virsh vol-list default --details
		echo ""
		echo -e "$AZUL}Máquinas virtuales disponibles... ${NC}"
			virsh list --all
		echo ""
		
    	read -p "Ingrese el nombre del disco duro a agregar a la VM (sin .qcow2): " nombreDisco
    	read -p "Ingrese el nombre de la MV donde va se va a agregar el disco duro: " nombreVM
    	   	
    	for letra in {b..z};do
    		if ! virsh domblklist "$nombreVM" | grep -q "vd$letra"; then
    			letraDisponible=$letra
    			break
    		fi
    	done
    	
    	echo -e"${AZUL}Cambiando al directorio a $rutaPool ${NC}"
    	
    	 virsh attach-disk $nombreVM --source "$routePool"/"$nombreDisco".qcow2 vd"$letraDisponible" --persistent --subdriver qcow2
    	 if [ $? -eq 0 ]; then
    	 	echo "" 
    	 	echo -e "${VERDE}Disco $nombreDisco-qcow2 agregado correctamente. ${NC}"
    	 	echo ""
    	 	echo -e "${AZUL}Estado actual de los discos: ${NC}"
    		virsh domblklist $nombreVM
    	else
    		echo -e "${ROJO}Error al agregar el disco. ${NC}"
    	fi
          
    pausa
}

definirIniciar() 
{
    clear
   	echo ""
    	read -p "Nombre del Pool a crear: " nombrePool
    	echo ""

    # Verificar si el pool ya existe
    if virsh pool-info "$nombrePool" >/dev/null 2>&1; then
    	echo ""
        echo -e "${ROJO}¡¡ERROR!! El pool $nombrePool ya existe. ${NC}"
        pausa
        return 1
   fi

    mkdir -p "$rutaPool/$nombrePool"
    
        virsh pool-define-as "$nombrePool" --type dir --target "$rutaPool/$nombrePool"
        virsh pool-build "$nombrePool"
        virsh pool-start "$nombrePool"
        virsh pool-autostart "$nombrePool"
        virsh pool-refresh $nombrePool
        	echo ""
    		echo -e "${VERDE}El pool $nombrePool ha sido definido, iniciado y configurado con arranque automático y luego actualizado${NC}"
    pausa
}

# Función para configurar un pool
configurarPool() 
{
	clear
    while true; do
	echo ""
        echo -e "${AZUL}====================================================="
        echo "a. Crear discos duros"
        echo "b. Mostrar información de discos duros"
        echo "c. Agregar discos duros a una máquina virtual"
        echo "d. Definir, iniciar y configurar arranque automático"
        echo -e "e. Volver al menú principal ${NC}"
        echo "====================================================="
        echo ""
        read -p "Seleccione una opción: " sub_opcion
        case $sub_opcion in
            a) crearDiscos ;;
            b) informacionDiscos ;;
            c) agregarDiscoVM ;;
            d) definirIniciar ;;
            e) clear
               echo ""
               echo -e "${VERDE}Saliendo del submenú... ${NC}";
               break;;
            *) clear
               echo ""
               echo -e "${ROJO}¡¡ERROR!! Opción no válida. Por favor, seleccione a, b, c, d ò e ${NC}";;
        esac
    done
    pausa
}

# Función para borrar pools
borrarPool() 
{
   	clear
    while true; do
    	echo ""
        echo -e "${MAGENTA}Pools de almacenamiento existentes: ${NC}"
        virsh pool-list --all
        echo ""
        read -p "Nombre del pool a borrar ( escriba 'salir' para cancelar): " nombrePool
        
        if [ "$nombrePool" = 'salir' ]; then
            break
        else
        	virsh pool-destroy $nombrePool
        	virsh pool-undefine $nombrePool
        	echo ""
        	echo -e "${VERDE}Pool $nombrePool eliminado con éxito. ${NC}"
               	echo ""
               	read -p "¿Deseas borrar otro pool? (s/n): " respuesta
               		if [[ "$respuesta" != "s" ]]; then
               			break
               	        fi
         fi
    done
    pausa
}

# Función para generar informe de pools
generarInforme() 
{
    clear
    echo ""
    echo -e "${MAGENTA}Generando informe en $informe... ${NC}"
  	echo ""
        echo -e "${AZUL}Informe de Pools de Almacenamiento" 
        echo "Fecha: $(date)"
        echo "----------------------------------------" 
        echo "Número total de pools: $(virsh pool-list --all | tail -n +3 | wc -l)" 
        echo "Número de pools activos: $(virsh pool-list | tail -n +3 | wc -l)" 
        echo "Número de pools inactivos: $(($(virsh pool-list --all | tail -n +3 | wc -l) - $(virsh pool-list | tail -n +3 | wc -l)))" 
        echo "Número de pools con arranque automático: $(virsh pool-list --all --details | grep 'yes' | wc -l)" 
        echo "----------------------------------------" 
        echo ""
        echo -e "Detalle de pools:  ${NC}" 
        echo ""
        virsh pool-list --all >> informe
    
    	echo -e "${VERDE}Informe generado en $informe. ${NC}"
    pausa
}

# Menú principal
menu() 
{
    while true; do
        clear
        echo ""
        echo -e "${AZUL}Gestión de Pools de almacenamiento en KVM"
        echo "==========================================="
        echo "1. Visualizar pools existentes"
        echo "2. Configurar un pool"
        echo "3. Borrar pool"
        echo "4. Generar informe de pools"
        echo -e "5. Salir ${NC}"
        echo ""
        read -p "Seleccione una opción: " opcion
        
        case $opcion in
            1) verPool ;;
            2) configurarPool ;;
            3) borrarPool ;;
            4) generarInforme ;;
            5) clear
               echo ""
               echo -e "${VERDE}Saliendo del programa... ${NC}"
               echo ""
               exit 0 ;;
            *) echo -e "${ROJO}¡¡ERROR!! Opción no válida. Por favor seleccione 1,2,3,4 o 5. ${NC}";;
        esac
    done
}

# Bloque principal
tuSerRoot
clear
menu

 


