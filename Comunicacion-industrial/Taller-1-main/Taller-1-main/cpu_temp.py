import subprocess

def get_temp_c():
    out = subprocess.check_output(["vcgencmd", "measure_temp"]).decode()
    return float(out.split("=")[1].split("'")[0])

if __name__ == "__main__":
    print(f"Temperatura CPU: {get_temp_c():.2f} °C")
