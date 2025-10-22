# Quiz – Sistema Siemens S7-1200

## 1. Descripción General

El sistema está compuesto por un **controlador lógico programable (PLC) Siemens SIMATIC S7-1200**, modelo **CPU 1214C DC/DC/DC**, junto con diversos módulos de expansión, fuente de alimentación, switch industrial y una interfaz HMI.  
El conjunto permite realizar tareas de automatización industrial con entradas/salidas digitales y analógicas, comunicaciones Ethernet y protocolos de campo.

---

## 2. Controlador Principal

**Modelo:** Siemens SIMATIC S7-1200 CPU 1214C DC/DC/DC  
**Referencia:** 6ES7 214-1BG40-0XB0  

**Características técnicas principales:**
- Alimentación: 24 VDC  
- Entradas digitales (DI): 14 (24 VDC)  
- Salidas digitales (DO): 10 (24 VDC, tipo transistor)  
- Entradas analógicas (AI): 2 canales (0–10 VDC, resolución 10 bits)  
- Salidas analógicas (AO): 2 canales (0–20 mA o 0–10 V)  
- Memoria de programa: 100 KB  
- Memoria de datos: 50 KB  
- Procesamiento: 0.08 µs por instrucción bit  
- Interfaz de comunicación integrada: PROFINET (Ethernet industrial)  
- Reloj en tiempo real incorporado  
- Comunicación directa con software **TIA Portal** para programación, monitoreo y diagnóstico  

---

## 3. Módulos y Periféricos del Sistema

### 3.1 Fuente de Alimentación PM 1207
**Referencia:** 6EP1332-1SH43  
**Función:** Proveer tensión de 24 VDC para el PLC y los módulos conectados.  
- Entrada: 120/230 VAC  
- Salida: 24 VDC / 2.5 A  

---

### 3.2 Módulo de Comunicación CM 1241 (RS422/RS485)
**Referencia:** 6ES7241-1CH32-0XB0  
**Función:** Permitir comunicación serial con otros dispositivos.  
**Protocolos soportados:**
- Modbus RTU (Modo Maestro o Esclavo)  
- Comunicación libre (Freeport) mediante tramas definidas por el usuario  

---

### 3.3 Módulo de Entradas Analógicas SM 1231 AI
**Referencia:** 6ES7231-4HF32-0XB0  
**Función:** Ampliar el número de entradas analógicas.  
**Características:**
- 4 canales analógicos (0–10 V o 0–20 mA)  
- Resolución: 13 bits  
- Aislamiento galvánico entre canales  

---

### 3.4 Módulo de Salidas Analógicas SM 1232 AQ
**Referencia:** 6ES7232-4HA30-0XB0  
**Función:** Generar señales analógicas de salida hacia actuadores o instrumentos.  
**Características:**
- 2 canales de salida (0–10 V o 0–20 mA)  
- Resolución: 12 bits  

---

### 3.5 Tarjeta Analógica SB 1232 AQ
**Referencia:** 6ES7232-4HA30-0XB0  
**Función:** Salida analógica adicional instalada directamente sobre la CPU.  
- 1 canal (0–10 V o 0–20 mA)  

---

### 3.6 Switch Industrial Scalance XB005
**Referencia:** 6GK5005-0BA00-1AB2  
**Función:** Distribución de red Ethernet para comunicación entre dispositivos industriales.  
**Características:**
- 5 puertos RJ45 (10/100 Mbps)  
- Tipo: Unmanaged (no gestionable)  
- Uso: Comunicación entre PLC, HMI, PC y red de supervisión  

---

### 3.7 Panel HMI KTP700 Basic
**Referencia:** 6AV2 123-2GB03-0AX0  
**Función:** Interfaz hombre-máquina para operación y monitoreo del sistema.  
**Características:**
- Pantalla táctil de 7” (resolución 800×480 píxeles)  
- Comunicación por PROFINET (Ethernet)  
- Alimentación: 24 VDC / 0.44 A máx  
- Soporte para alarmas, variables, gráficos y control de procesos  

---

## 4. Protocolos y Comunicaciones Soportadas

| Tipo de Comunicación | Protocolo | Descripción |
|----------------------|------------|--------------|
| Ethernet Industrial | PROFINET | Comunicación estándar entre PLCs, HMIs y variadores Siemens. |
| Ethernet TCP/IP | Modbus TCP | Comunicación con dispositivos externos o PC. |
| Serial RS-422/RS-485 | Modbus RTU | Comunicación punto a punto o multipunto con equipos industriales. |
| Serial RS-422/RS-485 | Freeport | Comunicación libre mediante tramas personalizadas. |
| HMI | Siemens HMI Runtime | Intercambio de datos entre PLC y panel HMI. |
| Programación y Diagnóstico | TIA Portal | Comunicación por Ethernet para carga, monitoreo y mantenimiento del sistema. |

---

## 5. Resumen de Hardware

| Módulo | Función | Referencia |
|--------|----------|------------|
| PM 1207 | Fuente 24 VDC | 6EP1332-1SH43 |
| CM 1241 | Comunicación RS-422/485 | 6ES7241-1CH32-0XB0 |
| CPU 1214C DC/DC/DC | Control principal | 6ES7214-1BG40-0XB0 |
| SM 1231 AI | Entradas analógicas | 6ES7231-4HF32-0XB0 |
| SM 1232 AQ | Salidas analógicas | 6ES7232-4HA30-0XB0 |
| SB 1232 AQ | Salida analógica adicional | 6ES7232-4HA30-0XB0 |
| Scalance XB005 | Switch Ethernet industrial | 6GK5005-0BA00-1AB2 |
| KTP700 Basic | HMI táctil | 6AV2 123-2GB03-0AX0 |

---

## 6. Alimentación del Sistema

- Tensión principal: 24 VDC  
- Corriente estimada total: ~2.5 A (dependiente de la carga en salidas)  
- Comunicación interna entre módulos mediante **bus trasero (backplane bus)**  

---

## 7. Observaciones Generales

El sistema Siemens S7-1200 ofrece una arquitectura modular que permite la ampliación de E/S y comunicaciones según las necesidades del proceso.  
Los módulos SM y CM se acoplan lateralmente a la CPU, mientras que el módulo SB se instala en la parte frontal inferior.  
El switch Scalance facilita la integración en redes PROFINET o TCP/IP, y el panel HMI KTP700 permite la supervisión directa del proceso.

---

## 8. Referencias Técnicas

- Siemens S7-1200 System Manual – Edition 2024  
- Siemens TIA Portal V17 Documentation  
- Siemens Industry Online Support (SIOS)  
  - [https://support.industry.siemens.com](https://support.industry.siemens.com)

---
