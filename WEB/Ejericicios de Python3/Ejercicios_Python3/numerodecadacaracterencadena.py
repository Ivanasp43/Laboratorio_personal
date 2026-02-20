# colores
AZUL = '\033[94m'
BLANCO = '\033[0m' 
ROSA = '\033[38;5;200m'
AMARILLO = '\033[93m'


# Escribe un programa que lea una cadena y devuelva un diccionario con la cantidad de apariciones de cada carácter en la cadena
cadena = input(f"{AZUL}Introduce una cadena: {BLANCO}")
contador = {}

for caracter in cadena:
    if caracter in contador:
        contador[caracter] += 1
    else:
        contador[caracter] = 1

# Resultado
print(f"\n{ROSA}==== Cantidad de apariciones de cada carácter ===={BLANCO}")
for caracter, cantidad in contador.items():
    print(f"{ROSA} {AMARILLO}'{caracter}': {cantidad} {'vez' if cantidad == 1 else 'veces'}{BLANCO}")