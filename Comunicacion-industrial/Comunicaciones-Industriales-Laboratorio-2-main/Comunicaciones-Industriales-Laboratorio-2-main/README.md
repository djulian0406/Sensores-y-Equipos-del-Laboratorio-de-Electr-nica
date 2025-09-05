

## Punto 1 — UART con **checksum** (suma mod 256)

**Objetivo.** Validar integridad del payload con un checksum ligero.

**Qué hicimos.**
- Trama: `STX | LEN | PAYLOAD | CS | ETX`, con `CS = sum(PAYLOAD) & 0xFF`.
- **Arduino** arma la trama y la envía (9600, 8N1).
- **Pico** acumula bytes, detecta `STX/ETX`, reconstruye payload y recalcula `CS`.

**Cómo probar.**
- Subir `UART_Validation.ino` al Arduino y `UART_Validation.py` a la Pico.
- Forzar error cambiando un byte o desconectando RX/TX un instante: la Pico debe imprimir **ERROR**.

**Resultado esperado.**
- Nominal: `OK` y lista de bytes.  
- Con perturbación: `ERROR` por `CS` inconsistente.

---

## Punto 2 — **ARQ** (ACK/NACK + retransmisión)

**Objetivo.** Añadir fiabilidad: el emisor **reintenta** si no recibe ACK.

**Qué hicimos.**
- Trama: `STX | LEN | SEQ | DATA | CHK | ETX` (CHK cubre `LEN|SEQ|DATA`).
- **Arduino (emisor)**: envía, inicia **timeout**, espera **'A'** (ACK) o **'N'** (NACK); si falla, **retransmite** hasta `max_tries`.
- **Pico (receptor)**: valida y responde ACK/NACK; se puede **inyectar** NACK con probabilidad `p` (10–30%).

**Cómo probar.**
- Subir `UART_Retransfer.ino` y `UART_Retransfer.py`.
- Ajustar `timeout` (~500 ms) y `p` en la Pico.  
- Observar en el Monitor Serial de Arduino los **reintentos** y **ACK/NACK**.

**Resultado esperado.**
- `p=0`: entrega al primer intento (reintentos = 0).  
- `p>0`: aumentan reintentos; con `max_tries=3` la pérdida teórica es `p^3` (ej. 2.7% para `p=0.3`).

---

## Punto 3 — RS-232 con **MAX3232**: **VRC** vs **LRC**

**Objetivo.** Comparar métodos de **detección** en RS-232 (niveles ±7–12 V).

**Por qué MAX3232.** Convierte niveles RS-232 (inversión y ±V) a TTL/CMOS (3.3/5 V).  
> Nunca conectar RS-232 directo a un GPIO.

**Cableado DB9.**
- Pin 2 = RX, Pin 3 = TX (**cruzar** entre extremos), Pin 5 = GND  
- Capacitores 0.1 µF en C1+/C1− y C2+/C2− del MAX3232

**Qué hicimos.**
- **VRC (paridad)**: por cada byte, generar paridad par (en la práctica se envió como byte auxiliar didáctico).  
- **LRC (XOR longitudinal)**: XOR de todo el bloque (5 bytes) y envío de 1 byte final.
- **Pico** recalcula VRC/LRC y reporta **OK/ERROR**; se introducen errores volteando bits.

**Overhead.**
- **VRC** (bit de frame): **12.5%** fijo por byte.  
- **LRC**: **1 byte por bloque** ⇒ **100/N %** (20% si N=5); mejora al crecer el bloque.

**Resultado esperado.**
- VRC detecta 1 bit por byte pero puede fallar con dos bits invertidos en el mismo byte.  
- LRC detecta mejor errores de **bloque** (múltiples bits), con overhead decreciente.

