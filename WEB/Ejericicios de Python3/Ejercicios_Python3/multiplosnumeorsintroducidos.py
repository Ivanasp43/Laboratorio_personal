# colores
ROJO = '\033[91m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
ROSA = '\033[38;5;200m'

# Crea un programa que pida dos número enteros al usuario y diga si alguno de ellos es múltiplo del otro. Crea una función EsMultiplo que reciba los dos números, y devuelve si el primero es múltiplo del segundo.
def EsMultiplo(num1, num2):
    return num1 % num2 == 0

def main():
    print()
    numero1 = int(input(f"{AZUL}Introduce el primer número entero: {BLANCO}"))
    numero2 = int(input(f"{AZUL}Introduce el segundo número entero: {BLANCO}"))
    
    # Verificar si alguno es múltiplo del otro
    if EsMultiplo(numero1, numero2):
        print(f"\n{ROSA}{numero1} es múltiplo de {numero2}.{BLANCO}")
    elif EsMultiplo(numero2, numero1):
        print(f"{AMARILLO}{numero2} es múltiplo de {numero1}.{BLANCO}")
    else:
        print(f"\n{ROJO}Ninguno de los números es múltiplo del otro.{ROJO}")

if __name__ == "__main__":
    main()
    