# colores
ROJO = '\033[91m'
VERDE = '\033[92m'
AZUL = '\033[94m'
BLANCO = '\033[0m' 
AMARILLO = '\033[93m'

# Crear una subrutina llamada “Login”, que recibe un nombre de usuario y una contraseña y te devuelve Verdadero si el nombre de usuario es “usuario1” y la contraseña es “asdasd”. Además recibe el número de intentos que se ha intentado hacer login y si no se ha podido hacer login incremente este valor.
# Crear un programa principal donde se pida un nombre de usuario y una contraseña y se intente hacer login, solamente tenemos tres oportunidades para intentarlo.
def Login(nombre_usuario, contrasena, intentos):
    if nombre_usuario == "usuario1" and contrasena == "asdasd":
        return True, intentos
    else:
        intentos += 1
        return False, intentos

def main():
    intentos = 0
    max_intentos = 3

    while intentos < max_intentos:
        nombre_usuario = input(f"{AZUL}Ingrese su nombre de usuario: {BLANCO}")
        contrasena = input(f"{AZUL}Ingrese su contraseña: {BLANCO}")
        
        exito, intentos = Login(nombre_usuario, contrasena, intentos)
        
        if exito:
            print(f"\n{VERDE}Login exitoso.{BLANCO}")
            break
        else:
            print(f"\n{ROJO}ERROR!!Login fallido. Intentos restantes: {max_intentos - intentos}{BLANCO}")

    if intentos == max_intentos:
        print(f"{AMARILLO}Se han agotado los intentos de login.{BLANCO}")

if __name__ == "__main__":
    main()