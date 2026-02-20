# colores
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m'

# Escribir por pantalla cada carácter de una cadena introducida por teclado.
cadena = input(f'{AZUL}Introduce una cadena: {BLANCO}')
for caracter in cadena:
    print(f'{MAGENTA}{caracter}{BLANCO}')
