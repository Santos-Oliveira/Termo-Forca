// =====================
// CONFIG
// =====================
String[] palavras = {
  "carta", "jogar", "tempo", "mouse", "tecla", "linha"
};

String palavra;

// GRID
int tentativasMax = 6;
int tamanhoPalavra = 5;

String[] tentativas = new String[tentativasMax];
int tentativaAtual = 0;
String digitando = "";

int[][] estado = new int[tentativasMax][tamanhoPalavra];

// FORCA
int erros = 0;
int maxErros = 6;

// ESTADOS
int tela = 0; // 0 = menu, 1 = jogo
boolean acabou = false;
boolean venceu = false;

// =====================
// SETUP
// =====================
void setup() {
  size(900, 600);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  novaRodada();
}

// =====================
// DRAW
// =====================
void draw() {
  background(245);

  if (tela == 0) {
    desenharMenu();
  } else if (tela == 1) {
    desenharJogo();
  }
}

// =====================
// MENU
// =====================
void desenharMenu() {
  fill(0);
  textSize(50);
  text("TERMO + FORCA", width/2, 150);

  // botão jogar
  desenharBotao(width/2, 300, 200, 60, "JOGAR");
}

// =====================
// JOGO
// =====================
void desenharJogo() {
  desenharTitulo();
  desenharGrid();
  desenharInput();
  desenharForca(600, 150);
  desenharStatus();

  // botão reiniciar
  if (acabou) {
    desenharBotao(width/2, 550, 200, 50, "REINICIAR");
  }
}

// =====================
// INPUT TECLADO
// =====================
void keyPressed() {
  if (tela != 1 || acabou) return;

  if (key == ENTER || key == RETURN) {
    if (digitando.length() == tamanhoPalavra) {
      avaliarTentativa();
    }
    return;
  }

  if (key == BACKSPACE && digitando.length() > 0) {
    digitando = digitando.substring(0, digitando.length()-1);
    return;
  }

  if (key >= 'a' && key <= 'z' && digitando.length() < tamanhoPalavra) {
    digitando += key;
  }
}

// =====================
// INPUT MOUSE
// =====================
void mousePressed() {

  // MENU
  if (tela == 0) {
    if (botaoClicado(width/2, 300, 200, 60)) {
      tela = 1;
      novaRodada();
    }
  }

  // JOGO
  else if (tela == 1 && acabou) {
    if (botaoClicado(width/2, 550, 200, 50)) {
      novaRodada();
    }
  }
}

// =====================
// LÓGICA
// =====================
void novaRodada() {
  palavra = palavras[int(random(palavras.length))];

  for (int i = 0; i < tentativasMax; i++) {
    tentativas[i] = "";
    for (int j = 0; j < tamanhoPalavra; j++) {
      estado[i][j] = 0;
    }
  }

  tentativaAtual = 0;
  digitando = "";
  erros = 0;
  acabou = false;
  venceu = false;
}

void avaliarTentativa() {
  tentativas[tentativaAtual] = digitando;

  for (int i = 0; i < tamanhoPalavra; i++) {
    char c = digitando.charAt(i);

    if (c == palavra.charAt(i)) estado[tentativaAtual][i] = 3;
    else if (palavra.indexOf(c) != -1) estado[tentativaAtual][i] = 2;
    else estado[tentativaAtual][i] = 1;
  }

  if (digitando.equals(palavra)) {
    venceu = true;
    acabou = true;
  } else {
    erros++;
    tentativaAtual++;
  }

  digitando = "";

  if (tentativaAtual >= tentativasMax || erros >= maxErros) {
    acabou = true;
  }
}

// =====================
// DESENHO UI
// =====================
void desenharTitulo() {
  fill(0);
  textSize(40);
  text("TERMO + FORCA", width/2, 50);
}

void desenharGrid() {
  int startX = 150;
  int startY = 120;
  int t = 60;

  textSize(24);

  for (int i = 0; i < tentativasMax; i++) {
    for (int j = 0; j < tamanhoPalavra; j++) {

      int x = startX + j * t;
      int y = startY + i * t;

      if (estado[i][j] == 3) fill(0, 180, 0);
      else if (estado[i][j] == 2) fill(200, 180, 0);
      else if (estado[i][j] == 1) fill(150);
      else fill(220);

      rect(x, y, t, t);

      fill(0);
      if (tentativas[i].length() > j) {
        text(tentativas[i].charAt(j), x, y);
      }
    }
  }
}

void desenharInput() {
  fill(0);
  textSize(20);
  text("Digite: " + digitando, 300, 500);
}

void desenharStatus() {
  fill(0);
  textSize(18);
  text("Erros: " + erros + "/" + maxErros, 750, 500);

  if (acabou) {
    textSize(28);

    if (venceu) {
      fill(0, 150, 0);
      text("VENCEU!", 750, 450);
    } else {
      fill(200, 0, 0);
      text("PERDEU!", 750, 450);
      fill(0);
      textSize(16);
      text("Palavra: " + palavra, 750, 480);
    }
  }
}

// =====================
// BOTÃO
// =====================
void desenharBotao(int x, int y, int w, int h, String txt) {
  if (mouseSobre(x, y, w, h)) {
    fill(180);
  } else {
    fill(200);
  }

  rect(x, y, w, h, 10);
  fill(0);
  textSize(20);
  text(txt, x, y);
}

boolean mouseSobre(int x, int y, int w, int h) {
  return mouseX > x - w/2 && mouseX < x + w/2 &&
         mouseY > y - h/2 && mouseY < y + h/2;
}

boolean botaoClicado(int x, int y, int w, int h) {
  return mouseSobre(x, y, w, h);
}

// =====================
// FORCA
// =====================
void desenharForca(int x, int y) {
  stroke(0);
  strokeWeight(3);

  line(x, y+200, x+100, y+200);
  line(x+50, y+200, x+50, y);
  line(x+50, y, x+120, y);
  line(x+120, y, x+120, y+30);

  if (erros > 0) ellipse(x+120, y+50, 30, 30);
  if (erros > 1) line(x+120, y+65, x+120, y+130);
  if (erros > 2) line(x+120, y+80, x+90, y+110);
  if (erros > 3) line(x+120, y+80, x+150, y+110);
  if (erros > 4) line(x+120, y+130, x+95, y+170);
  if (erros > 5) line(x+120, y+130, x+145, y+170);

  noStroke();
}
