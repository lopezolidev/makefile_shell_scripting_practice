#include <stdio.h>
#include <stdlib.h>

typedef struct Nodo{
	char data;
	struct Nodo *next;
}Nodo;
Nodo *first,*last;

void Agregar_elemento(char data) {
	struct Nodo *Auxiliar=malloc(sizeof(struct Nodo)); // creamos un puntero de nodo auxiliar reservando espacio de memoria en el heap

	Auxiliar->data = data;
    Auxiliar->next = NULL; // El nuevo nodo siempre será el último al agregarlo

	if ( first == NULL ) {
		// Si la lista está vacía, el nuevo nodo es el primero Y el último
        first = Auxiliar;
        last = Auxiliar;
	}else{
		// Si la lista NO está vacía, enlazar el *actual* último nodo al nuevo nodo
        last->next = Auxiliar;
        // Y luego, actualizar el puntero 'last' para que apunte al nuevo nodo (Auxiliar)
        last = Auxiliar;

		// En este caso, el nuevo nodo se convierte en el último nodo de la lista
		// y el puntero 'last' se actualiza para apuntar a él.

		// Además reducimos el código de la función eliminando el bucle while y disminuyendo la complejidad 
	}
	return;
} 

void printword( char *string ) {
	printf("%s",string);
	return;
}

void Imprimir_cedula() {
	struct Nodo *current = first; // Usamos un puntero temporal para recorrer la lista sin perder 'first'

	while(current != NULL){ // aquí el bucle no tenía condición de parada. Por lo tanto el proceso era terminado con señal de SIGKILL
		// se modificó comparando el nodo actual con el puntero NULL del sistema, así no se detiene un valor antes del último nodo e imprime todos los valores
		printf("%c",current->data);
		
		current = current->next;
	}

	printf("\n") ; // agregamos un salto de línea
}

int main () {		
	// char *string; ← no se emplea un puntero de string sino un arreglo de caracteres corriente
	char string[100];
	char *frase="Escriba su nombre:";

	printf("%s",frase);
	scanf("%s",string); // se pasa el puntero para escribir sobre lo que apunta
	printword(string);
 
	printf("Ingrese su C.I: ");

    // Consumir el caracter de salto de línea que dejó scanf("%s", ...)
    // Esto es necesario para que el primer getchar() lea el primer caracter de la C.I. y no el '\n'
    int c; // Usamos int para getchar() porque puede retornar EOF (-1)

 	while ((c = getchar()) != '\n' && c != EOF);
	// consumo de caracteres residuales

	// Bucle para leer la C.I. caracter por caracter
    while ((c = getchar()) != '\n' && c != EOF) {
        // Si el caracter leído NO es un salto de línea, lo agregamos a la lista
        // Usamos (char)c para convertir el int a char antes de pasarlo a la función

        Agregar_elemento((char)c);
    }
    // -----------------------------------------------

    // --- Parte para imprimir la C.I. desde la lista ---
    Imprimir_cedula();
 
	return 0;
}
