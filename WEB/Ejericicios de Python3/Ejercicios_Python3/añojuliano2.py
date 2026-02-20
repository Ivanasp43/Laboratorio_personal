# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
MAGENTA = '\033[95m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'
ROSA = '\033[38;5;200m'

# Vamos a mejorar el ejercicio anterior haciendo una función para validar la fecha. De tal forma que al leer una fecha se asegura que es válida.
# colores

def es_bisiesto(año):
    return (año % 4 == 0 and año % 100 != 0) or (año % 400 == 0)

def validar_fecha(dia, mes, año):
    """Función específica para validar la fecha"""
    try:
        
        if not (1 <= mes <= 12):
            return False, f"{ROJO}ERROR!! El mes debe estar entre 1 y 12{BLANCO}"
        
        if año < 1:
            return False, f"{ROJO}ERROR!! El año debe ser positivo{BLANCO}"
        
        
        if mes in [4, 6, 9, 11]:
            dias_maximos = 30
        elif mes == 2:
            dias_maximos = 29 if es_bisiesto(año) else 28
        else:
            dias_maximos = 31
        
        if not (1 <= dia <= dias_maximos):
            return False, f"{ROJO}ERROR!! El mes {mes} tiene {dias_maximos} días{BLANCO}"
        
        return True, "Fecha válida"
        
    except Exception as e:
        return False, f"{ROJO}ERROR!! Error en la validación: {str(e)}{BLANCO}"

def obtener_numero(mensaje):
    """Función para obtener y validar entrada numérica"""
    while True:
        try:
            valor = input(f"{AZUL}{mensaje}{BLANCO}")
            return int(valor)
        except ValueError:
            print(f"{ROJO}ERROR!! Debe introducir un número válido{BLANCO}")

def leer_fecha():
    """Función para leer y validar una fecha completa"""
    while True:
        dia = obtener_numero("Introduce el día: ")
        mes = obtener_numero("Introduce el mes: ")
        año = obtener_numero("Introduce el año: ")
        
        es_valida, mensaje = validar_fecha(dia, mes, año)
        if es_valida:
            return dia, mes, año
        else:
            print(mensaje)

def calcular_dia_juliano(fecha):
    dia, mes, año = fecha
    dia_juliano = sum(dias_del_mes(m, año) for m in range(1, mes)) + dia
    return dia_juliano

def dias_del_mes(mes, año):
    if mes in [1, 3, 5, 7, 8, 10, 12]:
        return 31
    elif mes in [4, 6, 9, 11]:
        return 30
    elif mes == 2:
        return 29 if es_bisiesto(año) else 28
    return 0


try:
    print(f"\n{VERDE}=== Cálculo del Día Juliano ==={BLANCO}")
    fecha = leer_fecha()
    dia_juliano = calcular_dia_juliano(fecha)
    print(f"\n{VERDE}El día juliano correspondiente es: {dia_juliano}{BLANCO}")
except Exception as e:
    print(f"{ROJO}ERROR!! Ocurrió un error inesperado: {str(e)}{BLANCO}")