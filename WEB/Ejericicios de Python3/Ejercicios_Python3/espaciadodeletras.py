# colores
AZUL = '\033[94m'
BLANCO = '\033[0m' 
ROSA = '\033[38;5;200m'

# Crea un función “ConvertirEspaciado”, que reciba como parámetro un texto y devuelve una cadena con un espacio adicional tras cada letra. Por ejemplo, “Hola, tú” devolverá “H o l a , t ú “. Crea un programa principal donde se use dicha función.
def ConvertirEspaciado(texto):
    return ' '.join(texto)

def main():
    texto = input(f"{AZUL}Ingrese un texto: {BLANCO}")
    texto_convertido = ConvertirEspaciado(texto)
    print(f"{ROSA}Texto con espacios: '{texto_convertido}'{BLANCO}")

if __name__ == "__main__":
    main()
    