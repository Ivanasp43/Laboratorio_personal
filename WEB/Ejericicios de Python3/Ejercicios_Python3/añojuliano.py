# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
ROSA = '\033[38;5;200m'

# El día juliano correspondiente a una fecha es un número entero que indica los días que han transcurrido desde el 1 de enero del año indicado. Queremos crear un programa principal que al introducir una fecha nos diga el día juliano que corresponde. Para ello podemos hacer las siguientes subrutinas: 
# LeerFecha: Nos permite leer por teclado una fecha (día, mes y año).
# DiasDelMes: Recibe un mes y un año y nos dice los días de ese mes en ese año.
# EsBisiesto: Recibe un año y nos dice si es bisiesto.
# Calcular_Dia_Juliano: recibe una fecha y nos devuelve el día juliano.
def obtener_numero(mensaje, minimo=None, maximo=None):
    while True:
        try:
            valor = input(f"{AZUL}{mensaje}{BLANCO}")
            numero = int(valor)
            
            
            if mensaje.find("día") != -1:
                if numero < 1 or numero > 31:
                    print(f"{ROJO}ERROR!! El día debe estar entre 1 y 31{BLANCO}")
                    continue
            elif mensaje.find("mes") != -1:
                if numero < 1 or numero > 12:
                    print(f"{ROJO}ERROR!! El mes debe estar entre 1 y 12{BLANCO}")
                    continue
            elif mensaje.find("año") != -1:
                if numero < 1:
                    print(f"{ROJO}ERROR!! El año debe ser positivo{BLANCO}")
                    continue
                    
            return numero
        except ValueError:
            print(f"{ROJO}ERROR!! '{valor}' no es un número válido{BLANCO}")

def leer_fecha():
    while True:
        dia = obtener_numero("Introduce el día: ")
        mes = obtener_numero("Introduce el mes: ")
        año = obtener_numero("Introduce el año: ")
        
        # Validar que la fecha sea válida
        if mes in [1, 3, 5, 7, 8, 10, 12] and dia > 31:
            print(f"{ROJO}ERROR!! El mes {mes} solo tiene 31 días{BLANCO}")
            continue
        elif mes in [4, 6, 9, 11] and dia > 30:
            print(f"{ROJO}ERROR!! El mes {mes} solo tiene 30 días{BLANCO}")
            continue
        elif mes == 2:
            max_dias = 29 if es_bisiesto(año) else 28
            if dia > max_dias:
                print(f"{ROJO}ERROR!! Febrero del año {año} tiene {max_dias} días{BLANCO}")
                continue
        return dia, mes, año

def dias_del_mes(mes, año):
    if mes in [1, 3, 5, 7, 8, 10, 12]:
        return 31
    elif mes in [4, 6, 9, 11]:
        return 30
    elif mes == 2:
        return 29 if es_bisiesto(año) else 28
    return 0

def es_bisiesto(año):
    return (año % 4 == 0 and año % 100 != 0) or (año % 400 == 0)

def calcular_dia_juliano(fecha):
    dia, mes, año = fecha
    dia_juliano = sum(dias_del_mes(m, año) for m in range(1, mes)) + dia
    return dia_juliano


try:
    fecha = leer_fecha()
    dia_juliano = calcular_dia_juliano(fecha)
    print(f"\n{VERDE}El día juliano correspondiente es: {dia_juliano}{BLANCO}")
except Exception as e:
    print(f"{ROJO}ERROR!! Ocurrió un error inesperado: {str(e)}{BLANCO}")