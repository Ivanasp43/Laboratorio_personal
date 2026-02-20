# Realizar un programa que inicialice una lista con 10 valores aleatorios (del 1 al 10) y posteriormente muestre en pantalla cada elemento de la lista junto con su cuadrado y su cubo.
import random

# colores
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 

# 10 valores aleatorios del 1 al 10
valores = [random.randint(1, 10) for _ in range(10)]

# Muestra cada elemento junto con su cuadrado y su cubo
for valor in valores:
    cuadrado = valor ** 2
    cubo = valor ** 3
    print(f'{AZUL}Valor: {MAGENTA}{valor}, Cuadrado: {cuadrado}, Cubo: {cubo}{BLANCO}')