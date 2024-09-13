#include <Servo.h>

int buzzerPin = 8;
int pinServo = 9;
int pinSensor = 0;
Servo miServo;

void setup() {
    pinMode(buzzerPin, OUTPUT);
    miServo.attach(pinServo);
    Serial.begin(9600);
}

void loop() {
    int valorSensor = analogRead(pinSensor);
    int tono = map(valorSensor, 0, 1023, 50, 1000); 
    tone(buzzerPin, tono);
    
    int valorServo = map(valorSensor, 0, 1023, 0, 270); 
    miServo.write(valorServo);

    Serial.print("valorSensor = ");
    Serial.println(valorSensor);

    delay(50); 
}