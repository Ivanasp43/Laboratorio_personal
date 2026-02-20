# colores
AZUL = '\033[94m'
MAGENTA = '\033[95m'
VERDE = '\033[92m'
BLANCO = '\033[0m' 

# Si tenemos una cadena con un nombre y apellidos, realizar un programa que muestre las iniciales en mayúsculas.
nombre_completo = input(f"{AZUL}Introduce tu nombre y apellidos: {BLANCO}")
iniciales = ''.join([palabra[0].upper() for palabra in nombre_completo.split()])
print(f"{MAGENTA}Las iniciales son:{VERDE} {iniciales}{BLANCO}")