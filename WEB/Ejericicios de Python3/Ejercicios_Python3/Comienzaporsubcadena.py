# Colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 

# Realizar un programa que comprueba si una cadena leída por teclado comienza por una subcadena introducida por teclado.
cadena = input(f"{AZUL}Introduce una cadena: {BLANCO}")
subcadena = input(f"{AZUL}Introduce una subcadena: {BLANCO}")
if cadena.startswith(subcadena):
    print(f"{VERDE}La cadena comienza con la subcadena.{BLANCO}")
else:
    print(f"{ROJO}La cadena no comienza con la subcadena.{BLANCO}")
    