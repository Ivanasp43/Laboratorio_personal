# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'

# Queremos guardar los nombres y la edades de los alumnos de un curso. Realiza un programa que introduzca el nombre y la edad de cada alumno. El proceso de lectura de datos terminará cuando se introduzca como nombre un asterisco (*) Al finalizar se mostrará los siguientes datos: Todos los alumnos mayores de edad y los alumnos mayores (los que tienen más edad)
print(f'{AZUL}Introduce el nombre y la edad de los alumnos. Pulsa "*" para finalizar.{BLANCO}')

alumnos = []
while True:
    try:
        nombre = str(input(f"{MAGENTA}Nombre del alumno: {BLANCO}"))
        if nombre == "*":
            break 
        edad = int(input(f"{MAGENTA}Introduce su edad: {BLANCO}"))
        alumnos.append((nombre, edad))
        
    except ValueError:  
        print(f"{ROJO}ERROR!! Vuelva a introducir los datos.{BLANCO}")
    

# Filtrar alumnos mayores de edad
mayores_de_edad = [alumno for alumno in alumnos if alumno[1] >= 18]
print(f"{AMARILLO}Alumnos mayores de edad:{BLANCO}", ', '.join(f"{nombre} ({edad})" for nombre, edad in mayores_de_edad))  # {{ edit_1 }} Cambia la forma de imprimir

# Encontrar el alumno mayor
alumno_mayor = max(alumnos, key=lambda x: x[1])
print(f"{VERDE}El alumno mayor es: {alumno_mayor}{BLANCO}")
