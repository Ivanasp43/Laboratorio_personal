#!/bin/bash
# Autor: Ivana Sánchez Pérez
# Versión: 1.0
# Fecha: 09/11/2024
# Descripción:Este script muestra un menú para automatizar la configuración de la red en KVM
clear
## variables y constantes
ROJO="\033[1;31m"
VERDE="\033[1;32m"
AMARILLO="\033[1;33m"
AZUL="\033[1;34m"
MAGENTA="\033[1;95m"
NC="\033[0m"

NOMBRE_RED="default"

##Funciones
pausa()
{
	echo ""
	read -p "Presiona Enter para continuar..."
	clear
}

# Función 
tuSerRoot()
{
	if [ "$(id -u)" != 0 ]; then
		echo -e "${ROJO}¡¡ERROR!! Este script sólo puede ser ejecutado por el root. ${NC}"
		exit 1
	fi
}
# Función para consultar el estado de la red
estadoRed()
{
	clear
	echo ""
	echo -e "${AZUL}El estado de la red $NOMBRE_RED es el siguiente: ${NC} "
	echo ""
	virsh net-list --all | grep -q $NOMBRE_RED
		virsh net-list --all 
	pausa
}

# Función para ver la configuración de la red
configuracionRed()
{
	clear
	echo ""
	echo -e "${AZUL}La configuración de la red $NOMBRE_RED es: ${NC}"
	echo ""
	virsh net-list --all | grep -q $NOMBRE_RED
		virsh net-dumpxml $NOMBRE_RED
	pausa
}

# Función par activar o no la red
activar_desactivarRed ()
{
	clear
	echo ""
	echo -e "${MAGENTA}Activar o desactivar la red $NOMBRE_RED. ${NC}"
	echo ""
	read -p "¿Deseas activar (a) o desactivar (d) la red? (a/d): " opcion
	if [ "$opcion" = "d" ]; then
	   echo -e "${VERDE}Desactivando la red $NOMBRE_RED... ${NC}"
	   virsh net-destroy $NOMBRE_RED
	elif [ "$opcion" = "a" ]; then	
	   echo -e "${VERDE}Activando la red $NOMBRE_RED... ${NC}"
	   virsh net-start $NOMBRE_RED
	else
	   echo -e "${ROJO}¡¡ERROR!! Opción no válida. ${NC}"
	fi
	pausa
}

# Función para iniciar o no la red
iniciar_noiniciarRed ()
{
	clear
	echo ""
	echo -e "${AMARILLO}Inicializar o no inicializar la red $NOMBRE_RED. ${NC}"
	echo ""
	read -p "Desea iniciar o no la red? (s/n): " eleccion
	if [ "$eleccion" = "s" ]; then
	   echo -e "${VERDE}Activando el autoinicio de la red $NOMBRE_RED... ${NC}"
	   virsh net-autostart $NOMBRE_RED
	elif [ "$eleccion" = "n" ]; then
	   echo -e "${VERDE}Desactivando el autoinicio de la red $NOMBRE_RED... ${NC}"
	   virsh net-autostart --disable $NOMBRE_RED
	else
	   echo -e "${ROJO}¡¡ERROR!! Opción no válida. ${NC}"
	fi
	pausa
}

# Función para modificar la configuración de la red
modificarConfiguracionRed ()
{
	clear
	echo ""
	echo -e "${AZUL} Modificar la configuración de la red $NOMBRE_RED: ${NC}"
	echo -e "${MAGENTA}Se abrirá el editor para modificar la configuración de la red $NOMBRE_RED. ${NC}"
	echo -e "${MAGENTA}Guarde y salga del editor para aplicar los cambios. ${NC}"
	pausa
	if virsh net-edit $NOMBRE_RED; then
	   echo -e "${VERDE}Los cambios se han aplicado correctamente. ${NC}"
	else
	   echo -e "${ROJO}¡¡ERROR!! No se han podido aplicar los cambios. ${NC}"
	fi
	pausa
}
				
# Función menú
menu()
{
	while true;
	do 
		echo ""
		echo -e "${AZUL} Configuración de la red en KVM"
		echo "================================"	
		echo "1.- Ver el estado de la red"
		echo "2.- Ver la configuración de la red"
		echo "3.- Activar/no-activar la red"
		echo "4.- Iniciar/no-iniciar la red"
		echo "5.- Modificar la configuración"
		echo -e "6.- Salir ${NC}"
		echo ""
		read -p "Indique una de las opciones:" opcion
		
	case $opcion in
		1)
			estadoRed ;;
		2)
			configuracionRed ;;
		3) 	
			activar_desactivarRed ;;
		4)
			iniciar_noiniciarRed ;;
		5)
			modificarConfiguracionRed ;;
		6)
			clear
			echo -e "${VERDE}Saliendo del script... ${NC}";
			echo "";
			exit ;;
		*)
			clear
			echo -e "${ROJO}¡¡ERROR!! Opción no válida. Por favor, seleccione del 1 al 6 ${NC}";;
		esac
	done
}

#Bloque principal
tuSerRoot
clear
menu
