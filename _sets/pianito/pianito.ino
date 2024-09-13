//Arduino Piano
/*

Visit the Channel for more interesting projects

https://www.youtube.com/channel/UCks-9JSnVb22dlqtMgPjrlg

*/

/*PANTALLA*/
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);


/*NOTAS*/
#define T_C 262
#define T_D 294
#define T_E 330
#define T_F 349
#define T_G 392
#define T_A 440
#define T_B 493

const int C = 4;
const int D = 5;
const int E = 6;
const int F = 7;
const int G = 8;
const int A = 9;
const int B = 10;

const int Buzz = 12;
const int LED = 13;


void setup() {
  pinMode(LED, OUTPUT);
  pinMode(C, INPUT);
  digitalWrite(C,HIGH);

  pinMode(D, INPUT);
  digitalWrite(D,HIGH);
  
  pinMode(E, INPUT);

  digitalWrite(E,HIGH);
  
  pinMode(F, INPUT);
  digitalWrite(F,HIGH);

  
  pinMode(G, INPUT);
  digitalWrite(G,HIGH);
  
  pinMode(A, INPUT);

  digitalWrite(A,HIGH);
  
  pinMode(B, INPUT);
  digitalWrite(B,HIGH);


  digitalWrite(LED,LOW);

  // PANTALLA
  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ;
  }

  // Clear the buffer
  display.clearDisplay();
  display.display(); 
}

// Functions for right alignment of integers

void loop() {
  while(digitalRead(C) == LOW) {
    tone(Buzz,T_C);
    digitalWrite(LED,HIGH);
    displayNota("DO :)");
  }

  while(digitalRead(D) == LOW) {
    tone(Buzz,T_D);
    digitalWrite(LED,HIGH);
    displayNota("RE :X");
  }

  while(digitalRead(E) == LOW) {
    tone(Buzz,T_E);
    digitalWrite(LED,HIGH);
    displayNota("MI <3");
  }

  while(digitalRead(F) == LOW) {
    tone(Buzz,T_F);
    digitalWrite(LED,HIGH);
    displayNota("FA");
  }

  while(digitalRead(G) == LOW) {
    tone(Buzz,T_G);
    digitalWrite(LED,HIGH);
    displayNota("SOL");
  }

  while(digitalRead(A) == LOW) {
    tone(Buzz,T_A);
    digitalWrite(LED,HIGH);
    displayNota("LA");
  }

  while(digitalRead(B) == LOW) {
    tone(Buzz,T_B);
    digitalWrite(LED,HIGH);
    displayNota("SI");
  }

  noTone(Buzz);
  digitalWrite(LED,LOW);

  //PANTALLA



}

void displayNota(const char* nota) {
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
  display.setCursor(0,0);
  display.println("Mini pianito");
  display.drawLine(0, 16, 128, 16, SSD1306_WHITE);
  display.setTextSize(3);
  display.setCursor(28,27);
  display.println(nota);
  display.display();
}