# colores
ROJO = '\033[91m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
ROSA = '\033[38;5;200m'
# Crear una función recursiva que permita calcular el factorial de un número. Realiza un programa principal donde se lea un entero y se muestre el resultado del factorial.
def factorial(n):
    if n < 0:
        raise ValueError(f"{ROJO}ERROR!! El factorial no está definido para números negativos.{BLANCO}")
    elif n == 0 or n == 1:
        return 1
    else:
        return n * factorial(n - 1)

def main():
    try:
        numero = int(input(f"{AZUL}Ingrese un número entero: {BLANCO}"))
        resultado = factorial(numero)
        print(f"{ROSA}El factorial de {numero} es: {resultado}{BLANCO}")
    except ValueError as e:
        print(f"{ROJO}Error: {e}{BLANCO}")

if __name__ == "__main__":
    main()