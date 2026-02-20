# colores
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 

# Pide una cadena y un carácter por teclado (valida que sea un carácter) y muestra cuantas veces aparece el carácter en la cadena
cadena = input(f'{AZUL}Introduce una cadena: {BLANCO}')
caracter = input(f'{AZUL}Introduce un carácter: {BLANCO}')
if len(caracter) == 1:
    print(f'{MAGENTA}El carácter {caracter} aparece {cadena.count(caracter)} vez/es. {BLANCO}')
else:
    print(F'{ROJO}No es un carácter válido. {ROJO}')
