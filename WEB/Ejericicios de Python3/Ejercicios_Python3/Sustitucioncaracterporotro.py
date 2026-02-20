# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 

# Pide una cadena y dos caracteres por teclado (valida que sea un carácter), sustituye la aparición del primer carácter en la cadena por el segundo carácter
cadena = input(f"{AZUL}Introduce una cadena: {BLANCO}")
caracter1 = input(f"{MAGENTA}Introduce el primer carácter: {BLANCO}")

# Validar que el primer carácter es de longitud 1 y alfabético
if len(caracter1) != 1:
    print(f"{ROJO}ERROR!! El primer valor debe ser un solo carácter. {BLANCO}")
elif not caracter1.isalpha():
    print(f"{ROJO}ERROR!! El primer valor no es un carácter alfabético válido. {BLANCO}")
else:
    caracter2 = input(f"{MAGENTA}Introduce el segundo carácter: {BLANCO}")

    # Validar que el segundo carácter es de longitud 1 y alfabético
    if len(caracter2) != 1:
        print(f"{ROJO}ERROR!! El segundo valor debe ser un único carácter. {BLANCO}")
    elif not caracter2.isalpha():
        print(f"{ROJO}ERROR!! El segundo valor no es un carácter alfabético válido. {BLANCO}")
    else:
        nueva_cadena = cadena.replace(caracter1, caracter2)
        print(f"{VERDE}La nueva cadena es: {nueva_cadena}{BLANCO}")