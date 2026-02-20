# colores
ROJO = '\033[91m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'


# Diseñar una función que calcule el área y el perímetro de una circunferencia. Utiliza dicha función en un programa principal que lea el radio de una circunferencia y muestre su área y perímetro.
import math

def calcular_area_perimetro(radio):
    area = math.pi * (radio ** 2)
    perimetro = 2 * math.pi * radio
    return area, perimetro

def main():
    try:
        radio = float(input(f"{AZUL}Ingrese el radio de la circunferencia: {BLANCO}"))
        if radio < 0:
            print(f"{ROJO}ERROR!! El radio no puede ser negativo.{BLANCO}")
            return
        
        area, perimetro = calcular_area_perimetro(radio)
        print(f"{AMARILLO}Área de la circunferencia: {area:.2f}{BLANCO}")
        print(f"{AMARILLO}Perímetro de la circunferencia: {perimetro:.2f}{BLANCO}")
    except ValueError:
        print(f"{ROJO}ERROR!! Por favor, ingrese un número válido.{BLANCO}")

if __name__ == "__main__":
    main()
    