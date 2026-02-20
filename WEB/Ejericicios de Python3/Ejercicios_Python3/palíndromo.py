# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 

# Introducir una cadena de caracteres e indicar si es un palíndromo. Una palabra palíndroma es aquella que se lee igual adelante que atrás.
cadena = input(f"{AZUL}Introduce una cadena: {BLANCO}")
cadena_limpia = ''.join(cadena.split()).lower()  # Elimina espacios y pasa a minúsculas
if cadena_limpia == cadena_limpia[::-1]:
    print(f"{VERDE}La cadena '{cadena}'es un palíndromo.{BLANCO}")
else:
    print(f"{ROJO}La cadena '{cadena}'no es un palíndromo. {BLANCO}")