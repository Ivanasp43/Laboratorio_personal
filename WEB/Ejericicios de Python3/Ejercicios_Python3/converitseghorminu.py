# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'
ROSA = '\033[38;5;200m'

def convertir_a_segundos(horas, minutos, segundos):
    return horas * 3600 + minutos * 60 + segundos

def convertir_a_hms(segundos):
    horas = segundos // 3600
    minutos = (segundos % 3600) // 60
    segundos = segundos % 60
    return horas, minutos, segundos

def obtener_numero(mensaje):
    while True:
        try:
            valor = input(f"{AMARILLO}{mensaje}{BLANCO}")
            numero = int(valor)
            if numero < 0:
                print(f"{ROJO}ERROR!! El número no puede ser negativo.{BLANCO}")
                continue
            return numero
        except ValueError:
            print(f"{ROJO}ERROR!! '{valor}' no es un número válido. Intente de nuevo.{BLANCO}")

def main():
    while True:
        try:
            print(f"\n{AZUL}Menú:{BLANCO}")
            print(f"{MAGENTA}1. Convertir horas, minutos y segundos a segundos{BLANCO}")
            print(f"{MAGENTA}2. Convertir segundos a horas, minutos y segundos{BLANCO}")
            print(f"{MAGENTA}3. Salir{BLANCO}")
            
            opcion = input(f"\n{ROSA}Elige una opción (1, 2, 3): {BLANCO}")

            if opcion == '1':
                horas = obtener_numero("Ingresa las horas: ")
                minutos = obtener_numero("Ingresa los minutos: ")
                segundos = obtener_numero("Ingresa los segundos: ")
                total_segundos = convertir_a_segundos(horas, minutos, segundos)
                print(f"\n{VERDE}Total en segundos: {total_segundos} segundos{BLANCO}")

            elif opcion == '2':
                segundos = obtener_numero("Ingresa los segundos: ")
                horas, minutos, segundos_restantes = convertir_a_hms(segundos)
                print(f"{VERDE}{horas} horas, {minutos} minutos y {segundos_restantes} segundos{BLANCO}")

            elif opcion == '3':
                print(f"{VERDE}Saliendo del programa...{BLANCO}")
                break

            else:
                print(f"{ROJO}ERROR!! Opción no válida. Por favor intenta de nuevo.{BLANCO}")
                
        except Exception as e:
            print(f"{ROJO}ERROR!! Ocurrió un error inesperado. Intente de nuevo.{BLANCO}")

if __name__ == "__main__":
    main()