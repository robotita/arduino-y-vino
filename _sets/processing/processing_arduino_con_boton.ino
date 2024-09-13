#define PIN_POT A0       // pin de potenciómetro (analógico) 
#define PIN_LED 9        // pin de la LED (analógico)
#define boton 8

int valor_POT = 0;       // para guardar el valor del potenciómetro
int brillo = 0;          // brillo de la LED

void setup() {
  pinMode(PIN_POT, INPUT);  // configuro pin del potenciómetro como Entrada
  pinMode(PIN_LED, OUTPUT); // configuro pin de la LED como Salida
  pinMode(boton, INPUT);
  Serial.begin(9600);       // inicializo puerto serie
}

void loop() {
  valor_POT = analogRead(PIN_POT);             // obtengo el valor del potenciómetro (0 a 1023)
  brillo = map(valor_POT, 0, 1023, 0, 255);    // calculo el valor del brillo de la LED
  analogWrite(PIN_LED, brillo);                // cambio el brillo de la LED
  int estado_boton = digitalRead(boton);       // leo el estado del botón

  // Envío ambos valores por el puerto serie en formato CSV
  Serial.print(valor_POT);
  Serial.print(",");
  Serial.println(estado_boton);

  if (Serial.available() > 0) {   // Comprobamos si processing envía un valor
    char estado = Serial.read();  // leemos el valor y lo guardamos en la variable estado
    if (estado == '1') {          // Si el valor es 1 encendemos el LED
      digitalWrite(PIN_LED, HIGH);
    } else if (estado == '0') {   // Si el valor es 0 apagamos el LED
      digitalWrite(PIN_LED, LOW);
    }
  }
  delay(100);  // pausa para no saturar el puerto
}