# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'
ROSA = '\033[38;5;200m'

# Se quiere realizar un programa que lea por teclado las 5 notas obtenidas por un alumno
print(f"{AZUL}============= REGISTRO DE NOTAS ============={BLANCO}")

# Leer 5 notas del alumno
notas = []
for i in range(5):
    try:
        nota = float(input(f'{VERDE}Ingrese la nota {i + 1} (entre 0 y 10): {BLANCO}'))
        while nota < 0 or nota > 10:
            print(f"{ROJO}Error!! La nota debe estar entre 0 y 10{BLANCO}")
            nota = float(input(f'{VERDE}Ingrese nuevamente la nota {i + 1}: {BLANCO}'))
        notas.append(nota)
    except ValueError:
        print(f"{ROJO}¡Error! Debe ingresar un número válido{BLANCO}")
        nota = float(input(f'{VERDE}Ingrese nuevamente la nota {i + 1}: {BLANCO}'))

# Calcular la media, la nota más alta y la más baja
media = sum(notas) / len(notas)
nota_maxima = max(notas)
nota_minima = min(notas)

# Resultados
print(f"\n{AZUL}================= RESULTADOS ================={BLANCO}")
print(f'{ROSA}Notas ingresadas: {", ".join(map(str, notas))}{BLANCO}')
print(f'{MAGENTA}Nota media: {media:.2f}{BLANCO}')
print(f'{VERDE}Nota más alta: {nota_maxima}{BLANCO}')
print(f'{AMARILLO}Nota más baja: {nota_minima}{BLANCO}')