#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
 
const char* ssid = "c19";
const char* password = "c19ohsem";
 
ESP8266WebServer server(80);
 
// defines pins numbers trigger and echo
const int trigPin = 14;  //Digital port D5
const int echoPin = 12;  //Digital port D6
 
// defines variables
long duration;
float distance;
float Mdistance;
 
const int led = LED_BUILTIN;
 
void setup(void){
  pinMode(led, OUTPUT);
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input
  digitalWrite(led, 0);
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  Serial.println("");
 
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
 
  server.on("/", webserver);
  server.onNotFound(handleNotFound);
  server.begin();
  Serial.println("HTTP server started");
}
 
void loop(void){
  server.handleClient();
}
 
void distanceData(){
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  
  // Calculating the distance
  distance= (duration*0.034)/2;
}
 
void webserver() {
  digitalWrite(led, !digitalRead(led));
  distanceData();
  String content = "<html> <head> <meta http-equiv='refresh' content='1'> </head><body>";
  content += "<center><h2>The distance is: ";
  content += distance;
  content += " cm </h2></center> </body></html>";
  if (distance <=10)
  {
     content += "<center><h3>FULL ";
  }else
  {
    content += "<center><h3>FREE ";
  }
  
 
  server.send(200, "text/html", content);
}
 
void handleNotFound(){
  digitalWrite(led, 1);
  String message = "File Not Found\n\n";
  server.send(404, "text/plain", message);
  digitalWrite(led, 0);
}
