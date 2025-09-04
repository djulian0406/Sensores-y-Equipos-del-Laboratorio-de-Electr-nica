# Raspberry Pi 3: Exploración, instalación de Raspberry Pi OS y prueba de Grafana con Streamlit

---

## 0. Materiales y condiciones
- Raspberry Pi 3 Model B con fuente oficial de 5 V a 2.5 A  
- microSD de 16 GB o superior, clase 10  
- Conexión a Internet por Ethernet o Wi‑Fi  
- Monitor, teclado y mouse del laboratorio  
- PC para preparar la microSD con Raspberry Pi Imager  

---

## 1. Preparación de la microSD con Raspberry Pi Imager

1. En el PC se descarga e instala Raspberry Pi Imager.  
2. Se abre la aplicación, se elige la opción **Choose OS** y se selecciona **Raspberry Pi OS de 64 bits**.  
3. En **Choose Storage** se selecciona la microSD.  
4. En el ícono de **configuración** se define:  
   - Hostname: `rpi3-usta`  
   - Usuario y contraseña  
   - Wi‑Fi del laboratorio con su SSID y contraseña  
   - Región, idioma y zona horaria **America/Bogota**  
   - SSH habilitado  
5. Se escribe la imagen, se expulsa la microSD y se inserta en la Raspberry Pi.  

**Primer arranque**
```bash
# Inicio de sesión local o por SSH
# Usuario por defecto si así se configuró: pi
sudo apt update && sudo apt full-upgrade -y
sudo raspi-config   # Verificación de localización, teclado y activación de interfaces adicionales si se requieren
```

**Verificación de red y datos básicos**
```bash
hostname -I           # Dirección IP en la red
cat /proc/cpuinfo | grep -E 'Model|Revision'
vcgencmd measure_temp # Temperatura del SoC
free -h               # Memoria disponible
df -h /               # Espacio libre en la microSD
```

---

## 2. Exploración de hardware y GPIO

### 2.1. LED parpadeante en GPIO 17
**Cableado:** LED con resistencia de 220 Ω al **GPIO 17** (pin físico 11) y GND al pin físico 6.  

**Archivo de prueba `gpio_led.py`:**
```python
from gpiozero import LED
from time import sleep

led = LED(17)
try:
    while True:
        led.toggle()
        sleep(0.5)
except KeyboardInterrupt:
    led.off()
```

**Ejecución**
```bash
python3 -m venv ~/venv_gpio && source ~/venv_gpio/bin/activate
pip install gpiozero
python gpio_led.py
```

### 2.2. Lectura de temperatura del SoC con Python
**Archivo `cpu_temp.py`:**
```python
import subprocess

def get_temp_c():
    out = subprocess.check_output(["vcgencmd", "measure_temp"]).decode()
    return float(out.split("=")[1].split("'")[0])

if __name__ == "__main__":
    print(f"Temperatura CPU: {get_temp_c():.2f} °C")
```

---

## 3. Entorno de Python para visualizaciones

Se crea un entorno aislado para Streamlit con el fin de evitar cambios en el sistema:
```bash
python3 -m venv ~/vis_env
source ~/vis_env/bin/activate
python -m pip install --upgrade pip
```

---

## 4. Streamlit: ruta recomendada y alternativa

### 4.1. Ruta recomendada en Raspberry Pi OS de 64 bits
Instalación en el entorno creado:
```bash
pip install streamlit pandas plotly
```

Prueba inicial:
```bash
streamlit hello
```

Ejecución de la aplicación de ejemplo `app_streamlit.py`:
```bash
streamlit run app_streamlit.py --server.address 0.0.0.0 --server.port 8501
```
- Acceso en la Raspberry: `http://localhost:8501`  
- Acceso desde otra PC en la red USTA: `http://IP_DE_LA_RASPBERRY:8501`

### 4.2. Ruta alternativa en Raspberry Pi OS de 32 bits
Cuando la instalación directa no es posible, se sugiere lo siguiente:

**Opción A.** Uso de versiones previas compatibles:
```bash
pip install "streamlit<1.25" pandas "plotly<5.20"
```

**Opción B.** Instalación sin dependencias pesadas y carga previa de bibliotecas del sistema:
```bash
pip install --no-deps streamlit
pip install pandas numpy plotly protobuf blinker watchdog tornado
LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libatomic.so.1 streamlit run app_streamlit.py
```

Si no resulta viable, se documenta el intento y se justifica el uso de **Dash** como alternativa.

---

## 5. Aplicación de ejemplo con Streamlit

**Archivo `app_streamlit.py`**  
La aplicación visualiza una serie de temperatura simulada y presenta indicadores clave.

```python
import time
import random
import pandas as pd
import plotly.express as px
import streamlit as st

st.set_page_config(page_title="Demo Streamlit en Raspberry Pi", layout="centered")

st.title("Demo de Streamlit en Raspberry Pi 3")
st.caption("Serie de temperatura simulada con KPIs simples")

# Estado persistente en la sesión
if "serie" not in st.session_state:
    base = 24.0
    st.session_state.serie = [round(base + random.uniform(-0.3, 0.3), 2) for _ in range(24)]

def nueva_muestra(valor):
    paso = random.uniform(-0.35, 0.6)
    nuevo = max(min(valor + paso, 30.0), 18.0)
    return round(nuevo, 2)

placeholder = st.empty()

for _ in range(1):
    last = st.session_state.serie[-1]
    st.session_state.serie.append(nueva_muestra(last))
    if len(st.session_state.serie) > 120:
        st.session_state.serie = st.session_state.serie[-120:]

    df = pd.DataFrame({
        "muestra": list(range(len(st.session_state.serie))),
        "temperatura_c": st.session_state.serie
    })
    fig = px.line(df, x="muestra", y="temperatura_c", title="Temperatura simulada")
    fig.update_traces(mode="lines+markers")

    col1, col2, col3 = st.columns(3)
    col1.metric("Última", f"{df['temperatura_c'].iloc[-1]:.2f} °C")
    col2.metric("Promedio", f"{df['temperatura_c'].mean():.2f} °C")
    col3.metric("Rango", f"{df['temperatura_c'].min():.2f} — {df['temperatura_c'].max():.2f} °C")

    st.plotly_chart(fig, use_container_width=True)

st.info("Ejecuta con:  streamlit run app_streamlit.py --server.address 0.0.0.0 --server.port 8501")
```

---

## 6. Instalación de Grafana en Raspberry Pi OS

Se añade el repositorio oficial y se habilita el servicio:
```bash
sudo apt-get install -y software-properties-common wget gpg
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server --no-pager
```

Acceso por navegador:
- En la Raspberry: `http://localhost:3000`  
- Desde otra PC: `http://IP_DE_LA_RASPBERRY:3000`  

Credenciales iniciales: usuario `admin` y contraseña `admin`. Se recomienda cambiar la contraseña en el primer inicio.

---

## 7. Primer panel en Grafana

1. En la barra lateral se ingresa a **Connections** y luego a **Data sources**.  
2. Se agrega **TestData DB** para generar datos de prueba.  
3. Se crea un tablero nuevo con la opción **New dashboard** y se añade un panel.  
4. Se selecciona el tipo de visualización, por ejemplo línea, barras o gauge.  
5. Se guarda el tablero y se verifica la vista.  

Para integrar datos reales se sugiere usar **InfluxDB** o **Prometheus** como fuentes de series de tiempo.

---

