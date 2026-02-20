# colores
VERDE = '\033[92m'
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 
# Crear una función que calcule la temperatura media de un día a partir de la temperatura máxima y mínima. Crear un programa principal, que utilizando la función anterior, vaya pidiendo la temperatura máxima y mínima de cada día y vaya mostrando la media. El programa pedirá el número de días que se van a introducir
def calcular_temperatura_media(temperatura_maxima, temperatura_minima):
    return (temperatura_maxima + temperatura_minima) / 2

def main():
    num_dias = int(input(f"{AZUL}¿Cuántos días deseas introducir? {BLANCO}"))
    
    for dia in range(num_dias):
        temperatura_maxima = float(input(f"\n{MAGENTA}Ingrese la temperatura máxima del día {dia + 1}: {BLANCO}"))
        temperatura_minima = float(input(f"{MAGENTA}Ingrese la temperatura mínima del día {dia + 1}: {BLANCO}"))
        
        media = calcular_temperatura_media(temperatura_maxima, temperatura_minima)
        print(f"{VERDE}La temperatura media del día {dia + 1} es: {media:.2f} grados{VERDE}")

if __name__ == "__main__":
    main()