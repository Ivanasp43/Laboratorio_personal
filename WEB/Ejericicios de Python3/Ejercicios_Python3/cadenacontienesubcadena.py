# colores
ROJO = '\033[91m'
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 

# Realizar un programa que compruebe si una cadena contiene una subcadena. Las dos cadenas se introducen por teclado.
cadena = input(f"{AZUL}Introduce la cadena principal: {BLANCO}")
subcadena = input(f"{AZUL}Introduce la subcadena a buscar: {BLANCO}")

if subcadena in cadena:
    print(f"{MAGENTA}La subcadena '{subcadena}' está en la cadena.{BLANCO}")
else:
    print(f"{ROJO}La subcadena '{subcadena}'no está en la cadena.{BLANCO}")