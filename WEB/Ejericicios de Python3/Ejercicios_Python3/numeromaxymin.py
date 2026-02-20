# colores
# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'
ROSA = '\033[38;5;200m'

# Crea una función “calcularMaxMin” que recibe una lista con valores numéricos y devuelve el valor máximo y el mínimo. Crea un programa que pida números por teclado y muestre el máximo y el mínimo, utilizando la función anterior.
def calcularMaxMin(lista_numeros):
    maximo = max(lista_numeros)
    minimo = min(lista_numeros)
    return maximo, minimo

def main():
    lista_numeros = []
    while True:
        entrada = input(f"{AZUL}Ingrese un número (o 'fin' para terminar): {BLANCO}")
        if entrada.lower() == 'fin':
            break
        try:
            numero = float(entrada)
            lista_numeros.append(numero)
        except ValueError:
            print(f"{AMARILLO}Por favor, ingrese un número válido.{BLANCO}")

    if lista_numeros:
        maximo, minimo = calcularMaxMin(lista_numeros)
        print(f"{ROSA}El valor máximo es: {maximo}{BLANCO}")
        print(f"{ROSA}El valor mínimo es: {minimo}{BLANCO}")
    else:
        print(f"{ROJO}No se ingresaron números.{BLANCO}")

if __name__ == "__main__":
    main()
    