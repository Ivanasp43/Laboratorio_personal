#!/bin/bash
# Autor: Ivana Sánchez Pérez
# Versión: 1.0
# Fecha: 09/11/2024
# Descripción: Este script muestra un menú para crear una máquina virtual.
clear

## variables y constantes
ROJO="\033[1;31m"
VERDE="\033[1;32m"
MAGENTA="\033[1;95m"
AZUL="\033[1;34m"
NC="\033[0m"

ISO_DIR="/home/ivana/Descargas"
MIN_RAM=512
MIN_DISK=5
MIN_CPU=1


##Funciones 

# Función para comprobar que el usuario que ejecuta el script sea root
tuSerRoot()
{
	if [ "$(id -u)" != 0 ]; then
		echo -e "${ROJO}¡¡ERROR!! Este script sólo puede ser ejecutado por el root. ${NC}"
		exit 1
	fi
}
# Validar número
validar_numero()
{
	local valor=$1
	local nombre=$2
	local minimo=$3

	if ! [[ $valor =~ ^[0-9]+$ ]]; then
		echo ""
		echo -e "${ROJO} ¡¡ERROR!! El valor $nombre debe ser un número. ${NC}"
		return 1
	fi

	if [ $valor -lt $minimo ]; then
		echo ""
		echo -e "${ROJO}¡¡ERROR!! El valor $nombre debe ser mayor o igual a $minimo. ${NC}"
		return 1
	fi
	return 0
}
# Función para crear la máquina virtual
crearVM()
{
	clear
	echo ""
	echo -e "${AZUL}Creación de una máquina virtual ${NC}"
	echo "=========================================="
	read -p "Nombre de la máquina virtual: " nombre
	read -p "Cantidad de RAM (en MB, mínimo $MIN_RAM): " ram
	read -p "Cantidad de disco duro (en GB, mínimo $MIN_DISK): " disco
	read -p "Tipo de Sistema Operativo (debian, centos, ubuntu, alpine): " os_variant
	read -p "Número de CPUs (mínimo $MIN_CPU): " cpus
	read -p "Nombre de la ISO: " iso 

	# Validar datos
	validar_numero $ram "RAM" $MIN_RAM || return 1
	validar_numero $disco "Disco duro" $MIN_DISK || return 1
	validar_numero $cpus "CPUs" $MIN_CPU || return 1


	# Verificar que la ISO existe
	ISO_PATH="$ISO_DIR/$iso"
	if [[ ! -f "$ISO_PATH" ]]; then
		echo -e "${ROJO}¡¡ERROR!! La ISO $ISO_PATH no existe. Verifique el nombre. ${NC}"
		return 1
	fi
	
	# Asignar un valor a --os-variant
	case $os_variant in
		debian)
			os_tipo="debian10" ;;
		ubuntu)
			os_tipo="linux2022" ;;
		centos)
			os_tipo="centos8" ;;
		alpine)
			os_tipo="alpinelinux3.17" ;;
		*)
			echo -e "${ROJO}¡¡ERROR!! Tipo de SO no reconocido. Use debian, centos, linux o alpine. ${NC}"
			return 1
			;;
	esac
	
	# Confirmar creación
	echo ""
	echo -e "${MAGENTA}Se va a crear la máquina virtual: ${NC}"
	echo "- Nombre: $nombre"
	echo "- RAM: $ram MB"
	echo "- Disco duro: $disco GB"
	echo "- CPUs: $cpus"
	echo "- Sistema operativo: $os_variant"
	read -p "¿Desea continuar? (s/n): " confirmacion
	if [[ $confirmacion != "s" ]]; then
		echo ""
		echo -e "${MAGENTA}Creación de máquina virtual cancelada. ${NC}"
		return 0 
	fi
	
	#Comando para crear la VM
	if virt-install --connect qemu:///system --name "$nombre" --cdrom "$ISO_PATH" --os-variant "$os_tipo" --disk size="$disco" --memory "$ram" --vcpus "$cpus"; then
		echo ""
		echo -e "${VERDE}Máquina virtual $nombre creada. ${NC}"
	else
		echo -e "${ROJO}Error al crear la máquina virtual $nombre. ${NC}"
		return 1
	fi
}
		
# Función para eliminar la máquina virtual
eliminarVM()
{
	clear
	echo ""
	echo -e "${AZUL}Eliminación de una máquina virtual ${NC}"
	echo "=============================================="
	echo -e "${MAGENTA}Máquinas virtuales existentes: ${NC} "
	echo "--------------------------------"
	virsh list --all
	echo ""
	read -p "Ingrese el nombre de la VM a eliminar: " nombre
	if ! virsh list --all | grep -q "$nombre"; then
		echo ""
		echo -e "${ROJO}No se encontró la máquina virtual $nombre. ${NC}"
		return 1
	fi
	echo ""
	echo -e "${MAGENTA}¡¡ADVERTENCIA!! Esta acción es irreversible y eliminará la máquina virtual $nombre permanentemente. ${NC}"
	read -p "¿Está seguro que desea continuar? (s/n): " confirmacion
	if [[ $confirmacion == "s" ]]; then
		
		if virsh list | grep -q "$nombre"; then
			virsh destroy "$nombre"
		fi
		
		if virsh undefine "$nombre" --remove-all-storage; then
			echo -e "${VERDE} La máquina virtual $nombre ha sido eliminada correctamente. ${NC}"
		else
		echo -e "${ROJO} Error al eliminar la máquina virtual $nombre. ${NC}"
	fi
	else
		echo -e "${MAGENTA}Operación cancelada. ${NC}"
	fi
	sleep 3
	return 0
}

# Función menú principal
menu()
{
	while true;
	do
		echo ""
		echo -e "${AZUL} Creación de una máquina virtual"
		echo "================================="
		echo "1.- Crear una máquina virtual"
		echo "2.- Eliminar una máquina virtual"
		echo -e "3.- Salir ${NC}"
		echo ""
		read -p "Indique una de las opciones: " opcion
	case $opcion in
		1)
			crearVM ;;
		2)
			eliminarVM ;;
		3)
			clear
			echo ""
			echo -e "${VERDE}Saliendo del script... ${NC}";
			echo "";
			exit;;
		*)
			clear
			echo -e "${ROJO}¡¡ERROR!! Opción no válida. Por favor, seleccione del 1 al 3. ${NC}";;
		esac
	done
}
#bloque principal
tuSerRoot
clear
menu
			
			
	


