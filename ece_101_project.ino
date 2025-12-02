#include "SR04.h"
#define TRIG_PIN1 12
#define ECHO_PIN1 11
#define TRIG_PIN2 7
#define ECHO_PIN2 6
SR04 sr04 = SR04(ECHO_PIN1,TRIG_PIN1);
SR04 sr04_2 = SR04(ECHO_PIN2, TRIG_PIN2);
long a;
long b;
int numPeople;

void setup() {
  numPeople = 0;
  pinMode(13, OUTPUT);
  Serial.begin(9600);
  delay(1000);

}

void loop() {
  a=sr04.Distance();
  b=sr04_2.Distance();
  if (a < 100){
    numPeople = numPeople + 1;
    delay(500);
  }
  else if (b < 100){
    numPeople = numPeople - 1;
    delay(500);
  }
  if (numPeople > 0){
    digitalWrite(13, HIGH);
  }
  else if (numPeople == 0){
    digitalWrite(13, LOW);
  }
  else if (numPeople < 0){
    numPeople = 0;
  }
  Serial.print(a);
  Serial.println(" cms");
  Serial.print(b);
  Serial.println(" cms");
  Serial.print(numPeople);
  Serial.println(" people");
}
