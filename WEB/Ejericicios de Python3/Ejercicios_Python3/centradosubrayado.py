# Crea un función EscribirCentrado, que reciba como parámetro un texto y lo escriba centrado en pantalla (suponiendo una anchura de 80 columnas; pista: deberás escribir 40 - longitud/2 espacios antes del texto). Además subraya el mensaje utilizando el carácter =.
# colores
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'
ROSA = '\033[38;5;200m'

def EscribirCentrado(texto):
    # Calculo de los espacios necesarios para centrar
    longitud = len(texto)
    espacios = 40 - longitud//2
    
    # centrado
    print(f"{AZUL}")  
    print(" " * espacios + texto)
    
    print(f"{ROSA}" + " " * espacios + "=" * longitud + f"{BLANCO}")

texto = input(f"{AMARILLO}Introduce un texto: {BLANCO}")
EscribirCentrado(texto)
