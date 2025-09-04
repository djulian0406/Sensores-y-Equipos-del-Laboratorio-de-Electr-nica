from gpiozero import LED
from time import sleep

led = LED(17)  # GPIO BCM 17 (pin físico 11)
try:
    while True:
        led.toggle()
        sleep(0.5)
except KeyboardInterrupt:
    led.off()
