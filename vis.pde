import java.net.*;
import org.rsg.carnivore.*;
import org.rsg.carnivore.net.*;
import java.util.Map;
import java.util.Iterator;

CarnivoreP5 c;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Packet> packets = new ArrayList<Packet>();
HashMap<String,Node> hm = new HashMap<String,Node>(); //HM to store the IP, and the corresponding nodes

void setup(){
  fullScreen();
  smooth();
  background(0);
  c = new CarnivoreP5(this); 
  nodes.add(new Node("127.0.0.1")); //Add an initial node
}

void draw(){
  background(0);
  //thread("drawNodes");
  //thread("drawPackets");
 for (int i = 0; i < nodes.size(); i++) { //Iterate and draw each node
    Node curNode = nodes.get(i);
    curNode.draw();
 }
 
 shrinkRadii();
 deleteOldPackets();

}

// Called each time a new packet arrives
void packetEvent(CarnivorePacket p){
  String rIP = p.receiverAddress.ip.toString();
  String sIP = p.senderAddress.ip.toString();

  Node source = hm.get(sIP); //Add the IPs to a hashmap
  Node dest = hm.get(rIP);   //And turn it into a Node
  if (source != null && source.radius < 100 && nodes.contains(source)) {
    source.radius+=5; //Increase the radius each time a packet arrives for an existing node
  } else {
    nodes.add(new Node(sIP)); //Add the new node
    hm.put(sIP, nodes.get(nodes.size()-1)); //Put the node and text into the Hashmap
    source = nodes.get(nodes.size()-1); //Fetch the source Node
  }
  
  if (dest != null && dest.radius < 100 && nodes.contains(dest)) {
    //dest.radius+=1;
  } else {
    nodes.add(new Node(rIP)); //Add the new node
    hm.put(rIP, nodes.get(nodes.size()-1)); //Put the node and text into the Hashmap
    dest = nodes.get(nodes.size()-1); //Fetch the destination Node
  }
  
  packets.add(new Packet(source, dest)); //Add a packet object which contains both source and dest
  
}

//Class to store and draw nodes for source and dest IPs
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
    stroke(col);
    fill(col);
    ellipse(pos.x, pos.y, radius, radius);
    fill(255);
    stroke(255);
    try {
      inetHost = InetAddress.getByName(IP); //Attempt to get regular host name
      host = inetHost.getHostName();
    } catch (UnknownHostException e) {
      host = IP; //Catch an make it the IP text
    }
    text(host, pos.x, pos.y); //Text at the center of the node
  }
}

//Class to store and draw each packet path between nodes
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

//Iterate and shrink node radius if larger than 10
void shrinkRadii() { 
  for (int i = 0; i < nodes.size(); i++) {
    Node curNode = nodes.get(i);
    if (curNode.radius > 10) {
      curNode.radius-=0.1;
    }
  }
}

//Delete packets older than 20 seconds
void deleteOldPackets() {
 for (int i = 0; i < packets.size(); i++) {
    Packet curPack = packets.get(i);
    if (curPack != null) {
      curPack.draw();
      if (millis()-curPack.m > 20000) {
        packets.remove(i); //If a packet has existed for more than 20 seconds delete it
      }
    } 
  }
}


//Unessary except for threading
void drawNodes() {
  for (int i = 0; i < nodes.size(); i++) {
    Node curNode = nodes.get(i);
    curNode.draw();
    if (millis()-curNode.m > 2000 && curNode.radius > 50) {
      nodes.remove(i);
    }
  }
}
void drawPackets() {
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
