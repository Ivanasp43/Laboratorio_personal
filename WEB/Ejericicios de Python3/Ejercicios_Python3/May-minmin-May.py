# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 

# Realizar un programa que lea una cadena por teclado y convierta las mayúsculas a minúsculas y viceversa.
cadena = input(f'{AZUL}Introduce una cadena: {BLANCO}')

# Verifico que sean letras
if not all(c.isalpha() or c.isspace() for c in cadena):
    print(f"{ROJO}Error!! Sólo se permiten letras.{BLANCO}")
else:
    cadena_convertida = cadena.swapcase()
    print(f"{VERDE}Cadena convertida: {cadena_convertida}{BLANCO}")
    