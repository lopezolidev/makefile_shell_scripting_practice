#
# Programa de calculadora
#

CFLAGS = -Wall
# inicializamos con una flag para permitir advertencias comunes por buena práctica

DEBUG ?= 0
# Delcaramos e inicializamos una variable llamada DEBUG
# ?= significa que la asignación sólo ocurre si DEBUG no fue inicializada previamente y el valor es 0 para indicar que está "apagada" (no se usará) por defecto

# Comparar si DEBUG = 1
ifeq ($(DEBUG), 1)
    
	CFLAGS += -g

endif
# Si DEBUG = 1 se concatena -g a las CFLAGS las cuales indican que no sólo se permitirán las advertencias comunes al compilar sino que también se incluirá información de debugging en los objetos compilados y el archivo final ejecutable

all: calc 

clean:	
	rm -rf calc arit.o calc.o

calc:   calc.o arit.o
# se enlazarán los archivos calc.o y arit.o para crear a calc usando las directivas implícitas

calc.o: calc.c arit.h
# calc.o se compilará como código objeto reubicable a partir de calc.c y arit.h usando las reglas implícitas del compilador GCC

arit.o: arit.c arit.h
# caso equivalentecon arit.o

# con las directivas gcc -o <archivo.o> o gcc -c <archivo.c> de los targets, estamos permitiendo la ejecución de las reglas implícitas por convención que tiene make 
