# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'
ROSA = '\033[38;5;200m'

# Diccionario de precios de frutas
precios_frutas = {
    "manzana": 1.5,
    "banana": 1.2,
    "naranja": 1.0,
    "uva": 2.0
}

while True:
    # Mostrar listado de frutas y precios
    print(f"\n{VERDE}=== LISTADO DE FRUTAS Y PRECIOS ==={BLANCO}")
    for fruta, precio in precios_frutas.items():
        print(f"{AMARILLO}{fruta.capitalize()}: {precio}€/kilo{BLANCO}")
    print()  

    fruta = input(f"{AZUL}Introduce una fruta de la lista: {BLANCO}").lower()
    if fruta in precios_frutas:
        cantidad = int(input(f"{ROSA}Introduce la cantidad: {BLANCO}"))
        precio_final = precios_frutas[fruta] * cantidad
        print(f"{AMARILLO}El precio final de {cantidad} kilos de {fruta}(s) es: {precio_final}€{BLANCO}")
    else:
        print(f"{ROJO}Error: La fruta no existe.{BLANCO}")

    otra_consulta = input(f"{VERDE}¿Quieres hacer otra consulta? (si/no): {BLANCO}")
    if otra_consulta.lower() != "si":
        break