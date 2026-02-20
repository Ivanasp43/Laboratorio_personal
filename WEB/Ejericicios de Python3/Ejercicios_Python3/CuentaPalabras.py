# colores
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 

# Suponiendo que hemos introducido una cadena por teclado que representa una frase (palabras separadas por espacios), realiza un programa que cuente cuantas palabras tiene.
frase = input(f"{AZUL}Introduce una frase: {BLANCO}")
palabras = frase.split()
print(f'{MAGENTA}La frase tiene {len(palabras)} palabras.{BLANCO}')