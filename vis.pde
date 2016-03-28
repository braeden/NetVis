import java.net.*;
import org.rsg.carnivore.*;
import org.rsg.carnivore.net.*;

CarnivoreP5 c;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Packet> packets = new ArrayList<Packet>();
ArrayList<String> IPs = new ArrayList<String>();

void setup(){
  fullScreen();
  smooth();
  background(0);
  c = new CarnivoreP5(this); 
  nodes.add(new Node("127.0.0.1"));
}

void draw(){
  background(0);
  for (int i = 0; i < nodes.size(); i++) {
    Node curNode = nodes.get(i);
    curNode.draw();
    if (millis()-curNode.m > 2000 && curNode.radius == 5) {
      nodes.remove(i);
    }
  }
  for (int i = 0; i < packets.size(); i++) {
    Packet curPack = packets.get(i);
    if (curPack != null) {
      curPack.draw();
      if (millis()-curPack.m > 1000) {
        packets.remove(i);
      }
    }
  }
}

// Called each time a new packet arrives
void packetEvent(CarnivorePacket p){
  //text("(" + p.strTransportProtocol + " packet) " + p.senderSocket() + " > " + p.receiverSocket(), 500, 500);
  String rIP = p.receiverAddress.ip.toString();
  String sIP = p.senderAddress.ip.toString();
  Node source = nodes.get(nodes.size()-1);
  Node dest = nodes.get(nodes.size()-1);
  if (IPs.contains(rIP)) {
    for (int i = 0; i < nodes.size(); i++) {
      Node curNode = nodes.get(i);
      if (rIP.equals(curNode.IP)) {
        if (curNode.radius < 100) {
          curNode.radius+=1;
        }        dest = curNode;
      }
    }
  } else {
    IPs.add(rIP);
    nodes.add(new Node(rIP));
    dest = nodes.get(nodes.size()-1);
  }
  
  if (IPs.contains(sIP)) {
    for (int i = 0; i < nodes.size(); i++) {
      Node curNode = nodes.get(i);
      if (sIP.equals(curNode.IP)) {
        //curNode.radius+=1;
        source = curNode;
      }
    }
  } else {
    IPs.add(sIP);
    nodes.add(new Node(sIP));
    source = nodes.get(nodes.size()-1);
  }
  
  packets.add(new Packet(source, dest));      
}


class Node {
  PVector pos = new PVector(random(0, width),random(0, height));
  int radius = 5;
  int m = millis();
  color col = color(int(random(0,255)), int(random(0,255)), int(random(0,255)));
  String IP;
  String host;
  InetAddress inetHost;
  Node(String IP_) {
    IP = IP_;
  }
  void draw() {
    try {
      inetHost = InetAddress.getByName(IP);
      host = inetHost.getHostName();
      println(host);
    } catch (UnknownHostException e) {
      host = IP;
    }
    stroke(col);
    fill(col);
    ellipse(pos.x, pos.y, radius, radius);
    fill(255);
    stroke(255);
    text(host, pos.x, pos.y);
  }
}

class Packet {
  Node source;
  Node dest;
  int width = 1;
  color col = color(int(random(0,255)), int(random(0,255)), int(random(0,255)));
  int m = millis();
  Packet(Node source_, Node dest_) {
    source = source_;
    dest = dest_;
  }
  void draw() {
    stroke(col);
    strokeWeight(width);
    line(source.pos.x, source.pos.y, dest.pos.x, dest.pos.y);
  }
}

void shrinkRadii() {
  for (int i = 0; i < nodes.size(); i++) {
    Node curNode = nodes.get(i);
    if (curNode.radius > 5) {
      curNode.radius--;
    }
  }
}