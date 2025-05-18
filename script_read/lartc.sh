#!/bin/bash

# Valida parametros de lartc segun archivo 'parametros.txt'.
# Escribe resultado en [CEDULA].txt (CEDULA=26272957).

INPUT_FILE="parametros.txt"
OUTPUT_FILE="26272957.txt" 

# Limpiar salida al inicio
> "$OUTPUT_FILE"

# Validar archivo de entrada
if [ ! -f "$INPUT_FILE" ] || [ ! -r "$INPUT_FILE" ]; then
    echo "Error: Archivo '$INPUT_FILE' no encontrado o sin permisos de lectura."
    exit 1
fi

# Leer linea a linea
while IFS= read -r LINEA_ORIGINAL
do
    errores_linea="" # Acumular errores para esta linea

    # Dividir linea en palabras. Asume que NO hay comentarios # que interfieran en la linea.
    read -a words <<< "$LINEA_ORIGINAL"

    # Validar cantidad minima de parametros
    if [ ${#words[@]} -lt 4 ]; then
        errores_linea+="Parametros insuficientes-"
    else
        # Extraer parametros clave
        ETH_ARG="${words[2]}" 
        MODE="${words[3]}"    

        # Validar ethN (eth + digito 0-9)
        if ! [[ "$ETH_ARG" =~ ^eth[0-9]$ ]]; then
            errores_linea+="Eth invalido-"
        fi

        # Validar segun modo
        case "$MODE" in
            "-r")
                # Modo -r: lartc -i ethN -r nw clase1 porcentaje1 ...
                if [ ${#words[@]} -lt 5 ]; then
                    errores_linea+="Parametros insuficientes-"
                else
                    NW_ARG="${words[4]}" 
                    # Validar nw (numero entero positivo)
                    if ! [[ "$NW_ARG" =~ ^[0-9]+$ ]]; then
                         errores_linea+="Parametros insuficientes-"
                    else
                        NW=$NW_ARG 
                        # Validar cantidad de pares = 2 * nw
                        ACTUAL_PARAM_COUNT=$(( ${#words[@]} - 5 ))
                        EXPECTED_PARAM_COUNT=$(( 2 * NW ))

                        if [ "$ACTUAL_PARAM_COUNT" -ne "$EXPECTED_PARAM_COUNT" ]; then
                             errores_linea+="Parametros insuficientes-"
                        else
                            # Validar cada par clase porcentaje
                            for (( j = 5; j < ${#words[@]}; j = j + 2 )); do
                                CLASE_ARG="${words[j]}"
                                PERCENT_ARG="${words[j+1]}"

                                # Validar Clase (8 bits binario)
                                if ! [[ "$CLASE_ARG" =~ ^[01]{8}$ ]]; then
                                    errores_linea+="El numero de 8 bit es invalido-"
                                fi

                                # Validar Porcentaje (0-100%)
                                if ! [[ "$PERCENT_ARG" =~ ^[0-9]+%$ ]]; then
                                     errores_linea+="Porcentaje no valido-"
                                else
                                    PERCENT_VAL=$(echo "$PERCENT_ARG" | sed 's/%$//')
                                    if [ "$PERCENT_VAL" -lt 0 ] || [ "$PERCENT_VAL" -gt 100 ]; then
                                        errores_linea+="Porcentaje no valido-"
                                    fi
                                fi
                            done
                        fi
                    fi
                fi
                ;;

            "-voip")
                # Modo -voip: lartc -i ethN -voip bw
                if [ ${#words[@]} -ne 5 ]; then
                    errores_linea+="Parametros insuficientes-"
                else
                    BW_ARG="${words[4]}" 
                    # Validar bw (numero decimal, positivo o negativo)
                    # ^-?[0-9]+(\.[0-9]+)?$ permite enteros o flotantes.
                    if ! [[ "$BW_ARG" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                        errores_linea+="No es decimal-" # Mensaje de error para decimal
                    fi
                fi
                ;;

            *) # Modo no reconocido
                errores_linea+="Modo invalido-"
                ;;
        esac
    fi

    # Formatear y escribir resultado
    if [ -z "$errores_linea" ]; then
        echo "${LINEA_ORIGINAL}-Sin errores" >> "$OUTPUT_FILE"
    else
        errores_linea_formateada="${errores_linea%-}"
        echo "${LINEA_ORIGINAL}-${errores_linea_formateada}" >> "$OUTPUT_FILE"
    fi

done < "$INPUT_FILE"

exit 0