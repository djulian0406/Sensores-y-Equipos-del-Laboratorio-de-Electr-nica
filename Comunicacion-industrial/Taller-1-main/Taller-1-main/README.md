# Métodos de Detección y Control de Errores en Comunicaciones

Resumen y comparación de los mecanismos más usados para detección y control de errores en comunicaciones y almacenamiento de datos: Bit de Paridad, Checksum, VRC, LRC, CRC y ARQ. Al final se listan patentes relacionadas con aplicaciones industriales y de potencia.

---

## 1. Bit de Paridad — Parity Bit

- **Descripción:** Se añade un bit extra a un conjunto de bits de datos para que el número total de unos sea par o impar.
- **Detección:** Solo detecta errores en un número impar de bits por carácter. Si dos bits cambian, el error puede pasar desapercibido.
- **Overhead:** Muy bajo — un bit extra por trama o por byte de datos. Aproximadamente 12,5 % en datos de 8 bits.
- **Usos:** Comunicaciones simples, memoria RAM con detección básica, puertos serie antiguos como UART.
- **Ventajas:**
  - Extremadamente simple de implementar en hardware y software.
  - Overhead mínimo con impacto casi nulo en el rendimiento.
- **Desventajas:**
  - Capacidad de detección muy limitada. No detecta errores pares como dos, cuatro o seis bits cambiados.
  - No permite corrección de errores, solo detección.
  - Poco eficaz en entornos ruidosos o críticos en integridad.

---

## 2. Checksum — Suma de Verificación

- **Descripción:** Se calcula un valor mediante suma aritmética o mediante XOR sobre todos los bytes del mensaje y se envía al final del bloque.
- **Detección:** Detecta errores aleatorios, aunque es vulnerable a ciertos patrones. Dos bytes que cambian de forma compensatoria pueden dejar la suma sin cambios.
- **Variantes:**
  - **Suma simple:** suma aritmética con uso frecuente de complemento a uno.
  - **XOR:** operación bit a bit. Más simple y menos robusta.
- **Overhead:** Bajo — uno o dos bytes por mensaje.
- **Usos:** Protocolos de red como TCP, UDP e IPv4, transferencia de archivos como TFTP y aplicaciones simples.
- **Ventajas:**
  - Mayor poder de detección que el bit de paridad.
  - Implementación sencilla y cómputo ligero.
  - Overhead bajo.
- **Desventajas:**
  - Vulnerable al reordenamiento de datos.
  - Detección mediocre, en especial con la variante XOR.
  - En contextos de alta integridad suele sustituirse por CRC.

---

## 3. VRC — Vertical Redundancy Check o Checksum de Paridad

- **Descripción:** Bit de paridad por carácter. Se entiende como paridad por columna en una matriz conceptual de bits.
- **Detección:** Detecta errores de un bit por byte. Si dos bits en la misma posición de bytes distintos cambian, el error puede no detectarse.
- **Overhead:** Un bit por byte, es decir cerca de 12,5 % para datos de 8 bits.
- **Usos:** Transmisión de caracteres simple como ASCII en sistemas antiguos.
- **Ventajas:**
  - Detección inmediata por carácter. Los bytes corruptos se identifican al instante.
- **Desventajas:**
  - Hereda las limitaciones del bit de paridad.
  - Poco efectivo frente a ráfagas que afecten la misma posición en distintos bytes.

---

## 4. LRC — Longitudinal Redundancy Check

- **Descripción:** Cálculo de un bit de paridad por posición de bit a lo largo de todos los bytes. Al final del mensaje se envía un byte adicional que contiene estos bits, llamado LRC.
- **Detección:** Complementa a VRC y mejora la detección de ráfagas con número impar de errores en la misma posición.
- **Overhead:** Un byte adicional por mensaje.
- **Usos:** Protocolos industriales como Modbus RTU y almacenamiento en cintas magnéticas.
- **Ventajas:**
  - Mejor que VRC para ráfagas de errores.
  - Cálculo muy simple.
- **Desventajas:**
  - Limitado por sí solo. Dos errores en la misma posición de bytes distintos pueden anular la paridad.
  - Suele combinarse con VRC para una paridad bidimensional, aunque CRC ofrece una protección superior.

---

## 5. CRC — Cyclic Redundancy Check

- **Descripción:** Interpreta los datos como un polinomio y los divide por un polinomio generador. El resto de la división llamado CRC se envía junto con los datos.
- **Detección:** Muy efectivo para
  - Errores de un bit y de dos bits.
  - Cualquier número impar de errores.
  - Ráfagas cuya longitud sea menor o igual al grado del polinomio. Un ejemplo es CRC 32 que detecta ráfagas de hasta 32 bits.
  - La gran mayoría de ráfagas más largas.
- **Overhead:** Superior al de paridad o checksum. Típicamente 16 o 32 bits.
- **Usos:** Ethernet con CRC 32, discos duros como SATA, Wi-Fi 802.11, formatos ZIP y PNG y la mayoría de protocolos modernos.
- **Ventajas:**
  - Poder de detección excepcional cercano al 99,99 % para errores comunes.
  - Implementación eficiente en hardware con registros de desplazamiento.
  - Excelente relación entre protección y overhead.
- **Desventajas:**
  - Más complejo de comprender e implementar que un checksum simple. Existen bibliotecas maduras.
  - Proporciona detección pero no corrección. Suele combinarse con ARQ.

---

## 6. ARQ — Automatic Repeat Request

- **Descripción:** Mecanismo de control de errores que se apoya en un método de detección como CRC para solicitar la retransmisión de datos corruptos.
- **Funcionamiento:** El receptor valida la integridad con CRC. Si el resultado es correcto envía ACK. Si hay error envía NAK o permanece en silencio y el emisor retransmite.
- **Variantes:**
  - **Stop and Wait:** espera un acuse de recibo tras cada trama. Muy simple y poco eficiente.
  - **Go Back N:** permite una ventana de varias tramas y ante un error retrocede y retransmite desde la trama fallada.
  - **Selective Repeat:** retransmite solo las tramas con error. Es la opción más eficiente y la más compleja. El receptor debe reordenar las tramas.
- **Usos:** Protocolos de enlace como HDLC y PPP y en la capa de transporte con TCP que mezcla ideas de Go Back N y Selective Repeat.
- **Ventajas:**
  - Entrega lógica libre de errores mediante retransmisión.
  - Muy efectivo con tasas de error moderadas.
- **Desventajas:**
  - Introduce latencia y reduce el rendimiento por las retransmisiones.
  - Requiere canal de retorno y búferes en ambos extremos.
  - Poco eficiente en enlaces de gran latencia o con tasas de error muy altas.

---

## Comparativa rápida

| Método   | Tipo        | ¿Corrige?                 | Poder de detección aproximado | Overhead                            | Complejidad |
|---------|-------------|---------------------------|-------------------------------|-------------------------------------|-------------|
| Paridad | Detección   | No                        | Muy bajo                      | Muy bajo — un bit por byte          | Muy baja    |
| Checksum| Detección   | No                        | Bajo a medio                  | Bajo — uno o dos bytes por mensaje  | Baja        |
| VRC     | Detección   | No                        | Bajo por byte                 | Medio — un bit por byte             | Baja        |
| LRC     | Detección   | No                        | Bajo a medio en ráfagas impares | Bajo — un byte por mensaje        | Baja        |
| CRC     | Detección   | No                        | Muy alto                      | Medio — de 16 a 32 bits por mensaje | Media       |
| ARQ     | Control     | Sí por retransmisión      | Depende del detector asociado | Variable — tráfico de control       | Media a alta|

En capas donde la integridad es crítica el CRC suele sustituir al checksum. ARQ opera junto a un método de detección como CRC.

---

## Patentes relacionadas con aplicaciones industriales

1. **CN 461979307 — Protección contra sobretemperatura en transmisores de radiofrecuencia**  
Esta patente se centra en un protector de sobretemperatura para transmisores y sistemas de antena en estaciones de radiodifusión. El sistema utiliza fibras ópticas con sensores distribuidos para detectar la temperatura en tiempo real a lo largo de diferentes puntos críticos de la línea de transmisión, como conectores, divisores de potencia y guías de onda.

El diseño incluye un módulo de control central (MCU) que recopila los datos de temperatura mediante un detector y los procesa con algoritmos de calibración y filtrado, eliminando errores y ruido en las mediciones. Cuando la temperatura supera umbrales definidos, el controlador envía instrucciones al transmisor para reducir o cortar la potencia de salida, evitando daños en los amplificadores y asegurando la continuidad de la transmisión.

![1](https://github.com/user-attachments/assets/f9fd09e7-b2d5-4525-98c1-b4bff94042a5)


2. **DE 10 2024 106 799 B3 — Protocolo FAAD para convertidores multinivel**  
Esta patente introduce un protocolo de comunicación denominado FAAD (Fast Acknowledge and Diagnosis), diseñado específicamente para convertidores multinivel de potencia. Estos sistemas están compuestos por múltiples módulos (celdas), que deben trabajar de forma sincronizada y segura.

El protocolo FAAD organiza la comunicación en tres fases:

Comando: el controlador principal envía instrucciones a cada módulo.

Diagnóstico: cada módulo responde con información mínima (solo un bit) indicando su estado.

Confirmación rápida: el sistema valida la integridad de las respuestas y toma decisiones en tiempo real.

Gracias a este esquema, se reduce la sobrecarga de datos en comparación con protocolos tradicionales, lo que se traduce en mayor velocidad y fiabilidad de diagnóstico.

La implementación se hace mediante UART, lo que lo hace directamente compatible con RS232. Esto significa que los convertidores pueden comunicarse usando un estándar muy extendido en la industria, facilitando su integración en sistemas de control industrial y automatización que todavía utilizan PLC, variadores o controladores basados en RS232.
   
![2](https://github.com/user-attachments/assets/e78a30fc-1b26-4c4c-b7b1-c03fd5a86b64)

![3](https://github.com/user-attachments/assets/2ceae54d-6c52-404f-9953-3dfba1ae1454)

![4](https://github.com/user-attachments/assets/96895f21-3305-4566-945e-753f1da39167)

![5](https://github.com/user-attachments/assets/02f93254-1211-4983-81e6-c953e2b4c21a)


4. **Pasarela IoT con RS 232, RS 485 y CAN — Asignación dinámica de recursos**  
Este invento describe una pasarela de comunicaciones IoT diseñada para entornos industriales. Su principal innovación es la gestión dinámica de interfaces: el sistema detecta qué buses están activos (RS232, RS485, CAN) y solo carga el firmware necesario, lo que ahorra recursos de memoria y energía.

El gateway también soporta actualizaciones diferenciales de firmware a través de redes 4G y nube, lo que permite mantenerlo actualizado de forma remota sin interrumpir el servicio. Además, puede integrarse con sistemas de monitoreo industrial, mejorando la seguridad y la eficiencia en el mantenimiento.

RS232: se incluye para compatibilidad con dispositivos antiguos que siguen usándose en fábricas y sistemas legacy.

RS485 y CAN: permiten conexión multipunto y comunicación más robusta, necesarias en redes modernas de sensores y controladores industriales.
   
![6](https://github.com/user-attachments/assets/79335ed7-1265-445b-8cc2-1c00c9db0430)

![7](https://github.com/user-attachments/assets/32a45007-c634-4d4e-a806-db9e7e8353b1)

