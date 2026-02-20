# colores
AZUL = '\033[94m'
MAGENTA = '\033[95m'
VERDE = '\033[92m'
BLANCO = '\033[0m' 

# Realizar un programa que dada una cadena de caracteres, genere otra cadena resultado de invertir la primera.
cadena = input(f"{AZUL}Introduce una cadena: {BLANCO}")
cadena_invertida = cadena[::-1]
print(f"{MAGENTA}Cadena invertida: {VERDE} {cadena_invertida}{BLANCO}")
