
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

resultado_archivo="temp.txt"
entrada_archivo="maquinas.txt"
contador=0
total_ram=0
numVM=0



##Funciones 			
# Función para verificar si es root
tuSerRoot() 
{
	if [ "$(id -u)" != 0 ]; then
		echo ""
        	echo -e "${ROJO}¡¡ERROR!! Este script sólo puede ser ejecutado por el root. ${NC}"
        exit 1
    	fi
}

# Función para generar el archivo informe
generarInforme() 
{
	> "$resultado_archivo"  # Limpiamos el archivo temp.txt

    while IFS=: read -r nombre apellido1 apellido2 hd_size ram_size; do #Leemos archivo línea por línea
        # Generamos el nombre de la máquina
        nombre_maquina="MV$((contador + 1))-${nombre:0:1}${apellido1:0:3}${apellido2:0:3}"
        
        # Escribimos en temp.txt
        echo "$nombre_maquina:$ram:$hd_size" >> "$resultado_archivo"
        
        # Actualizamos el contador y el total de RAM
        contador=$((contador + 1))
        total_ram=$((total_ram + ram))
    done < $entrada_archivo
}
Función para mostrar el contenido de temp.txt
mostrarArchivo() {
    echo "Contenido de $resultado_archivo:"
    cat "$resultado_archivo"
}

# Función para crear máquinas virtuales KVM
crearVM() {
    local nombre=$1
    local ram=$2
    local hd=$3

    
    while IFS=: read -r nombre_maquina ram hd; do
        # Comando para crear la máquina virtual (ejemplo)
        # qemu-img create -f qcow2 "${nombre_maquina}.qcow2" "${hd}G"
        echo "Creando máquina virtual: $nombre_maquina con RAM: ${ram}MB y HD: ${hd}GB"
    done < "$temp_file"
}

# Bloque de ejecución
if [ ! -f maquinas.txt ]; then
    echo "El archivo maquinas.txt no existe."
    exit 1
fi

generar_temp_file
mostrar_temp_file
crear_maquinas_virtuales

# Generamos el informe
echo "Informe:"
echo "Número de máquinas virtuales creadas: $contador"
echo "Tamaño total de RAM: $total_ram MB"