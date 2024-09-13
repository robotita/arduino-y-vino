import processing.serial.*;

int numBalls;
float spring = 0.05;
float gravity = 0.03;
float friction = -0.9;
Ball[] balls = new Ball[numBalls];
SpecialBurst specialBurst; 

Serial mi_puerto; // Inicializamos la variable mi_puerto
float background_color = 150; // Variable para cambiar el color, valor inicial
float potValue = 0; // Valor del potenciómetro
int botonState = 0; // Estado del botón
int lastBotonState = 0; // Último estado del botón
float randomNro = random(50, 800);
String randomText;

//void settings() {
//  size(displayWidth, displayHeight);
//}

void setup() {
  fullScreen();

  numBalls = int(random(20, 60));
  balls = new Ball[numBalls];
    
  specialBurst = new SpecialBurst(width / 2, height / 2, 800);
  
  
  String puerto = Serial.list()[0];
  mi_puerto = new Serial(this, puerto, 9600);
  mi_puerto.bufferUntil('\n');
  
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
  noStroke();
  fill(255, 204);
  textAlign(RIGHT, BOTTOM); 
  textSize(22);
  generateRandomText(); 
}

void serialEvent(Serial mi_puerto) {
  String inString = mi_puerto.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    String[] values = split(inString, ',');
    if (values.length == 2) {
      potValue = float(values[0]); // Guardamos el valor del potenciómetro
      botonState = int(values[1]); // Guardamos el estado del botón
      background_color = map(potValue, 0, 1023, 0, 255); // Cambiamos el color de fondo basado en el potenciómetro
    }
  }
}

void draw() {
  background(randomNro, background_color/randomNro, background_color);

  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();
  }

  specialBurst.move();
  specialBurst.display();
  
  // Mostrar el valor del potenciómetro y el estado del botón en el centro de la pantalla
  fill(255);
  text(randomText, width - 10, height - 10);
  //text("Potenciómetro: " + potValue, width / 2, height / 2 - 20);
  //text("Botón: " + (botonState == 0 ? "Presionado" : "No presionado"), width / 2, height / 2 + 20);

  // Si el botón está presionado y el estado ha cambiado
  if (botonState == 0 && lastBotonState == 1) {
    background(0);
    randomNro = random(50, 400);
    colapsarBolas(); // Colapsar bolas
    delay(500); // Espera un poco para ver la colisión
    background(randomNro, background_color/randomNro, background_color);
    regenerarBolas(); // Regenerar bolas
    
    generateRandomText();
  }

  lastBotonState = botonState; // Actualizar el último estado del botón
}

void colapsarBolas() {
  float colapseX = width / 2;
  float colapseY = height / 2;
  for (Ball ball : balls) {
    ball.x = colapseX;
    ball.y = colapseY;
  }
}

void regenerarBolas() {
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
}

class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
  String shapeType;

  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    shapeType = random(1) < 0.5 ? "burst" : "burstSquare"; // Randomly choose shape type
  } 

  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx * dx + dy * dy);
      float minDist = others[i].diameter / 2 + diameter / 2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }
  }

  void move() {
    vy += gravity;
    float speed = map(potValue, 0, 1023, 0, 10); // Ajustamos la velocidad basada en el potenciómetro
    x += vx * speed;
    y += vy * speed;
    if (x + diameter / 2 > width) {
      x = width - diameter / 2;
      vx *= friction; 
    } else if (x - diameter / 2 < 0) {
      x = diameter / 2;
      vx *= friction;
    }
    if (y + diameter / 2 > height) {
      y = height - diameter / 2;
      vy *= friction; 
    } else if (y - diameter / 2 < 0) {
      y = diameter / 2;
      vy *= friction;
    }
  }

  void display() {
    if (shapeType.equals("burst")) {
      burst(x, y, diameter / 2, 10, 10);
    } else {
      burstSquare(x, y, diameter / 2, 10, diameter / 4);
    }
  }

  void burst(float cx, float cy, float radius, int nodes, float vary) {
    beginShape(); 
    for (float i = 0; i < TWO_PI; i += 0.01) {
      float ri = radius + sin(i * nodes) * vary;
      float x1 = cx + cos(i) * ri;
      float y1 = cy + sin(i) * ri;
      vertex(x1, y1);
    }
    endShape(CLOSE);
  }

  void burstSquare(float cx, float cy, float radius, int nodes, float radius2) {
    if (radius2 == 0) radius2 = radius * 0.5;
    float step = TWO_PI / (nodes * 2);
    beginShape(); 
    for (int i = 0; i < nodes * 2; i++) {
      float ri = i % 2 == 0 ? radius : radius2;
      float x1 = cx + cos(i * step) * ri;
      float y1 = cy + sin(i * step) * ri;
      vertex(x1, y1);
    }
    endShape(CLOSE);
  }
}
class SpecialBurst {
  float x, y;
  float diameter;
  float vx;
  float vy;
  float gravity = 0.01; // Gravedad baja para el movimiento flotante
  float transparency = 0.05; // Transparencia del objeto

  SpecialBurst(float xin, float yin, float din) {
    x = xin;
    y = yin;
    diameter = din;
    vx = random(-1, 1) * 0.5; // Velocidad horizontal aleatoria inicial baja
    vy = random(-1, 1) * 0.5; // Velocidad vertical aleatoria inicial baja
  }

  void move() {
    vy += gravity;
    x += vx;
    y += vy;

    // Colisiones con los bordes
    if (x - diameter / 2 < 0 || x + diameter / 2 > width) {
      vx *= -1; // Invertir la dirección horizontal al chocar con los bordes
    }
    if (y - diameter / 2 < 0 || y + diameter / 2 > height) {
      vy *= -1; // Invertir la dirección vertical al chocar con los bordes
    }
  }

  void display() {
    // Dibujar el burst especial en forma de "burst" con puntas redondeadas
    int nodes = 18; // Número de puntas
    float angleStep = TWO_PI / nodes; // Dividir el círculo en 8 segmentos
    float innerRadius = diameter / 4; // Radio interno del "burst"

    fill(255, 255 * transparency); // Color con transparencia
    noStroke(); // Sin borde
    beginShape();
    for (float angle = 0; angle < TWO_PI; angle += angleStep) {
      float x1 = x + cos(angle) * innerRadius;
      float y1 = y + sin(angle) * innerRadius;
      curveVertex(x1, y1);

      float x2 = x + cos(angle + angleStep / 2) * diameter / 2;
      float y2 = y + sin(angle + angleStep / 2) * diameter / 2;
      curveVertex(x2, y2);
    }
    endShape(CLOSE);
  }
}


void generateRandomText() {
  int nroRandom = int(random(0, 5));
  if (nroRandom == 0) {
    randomText = "VINO Y ARDUINO TE AMA! (^ _ ^)/";
  } else if (nroRandom == 1) {
    randomText = "X LA PATRIA NO SE VENDE X";
  } else if (nroRandom == 2) {
    randomText = "¿Consultaste a la pitonisa de vinoyarduino?";
  } else if (nroRandom == 3) {
    randomText = "Es mejor que estarse quieto, es mejor que ser un vigilante.";
  } else {
    randomText = "Recorda no votar a la derecha O_O";
  }
}
