import java.net.*;
import org.rsg.carnivore.*;
import org.rsg.carnivore.net.*;
import java.util.Map;
import java.util.Iterator;

CarnivoreP5 c;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Packet> packets = new ArrayList<Packet>();
//ArrayList<String> IPs = new ArrayList<String>();
HashMap<String,Node> hm = new HashMap<String,Node>();



void setup(){
  fullScreen();
  smooth();
  background(0);
  c = new CarnivoreP5(this); 
//  nodes.add(new Node("127.0.0.1"));
  //hm.put("
//  IPs.add("127.0.0.1");
}

void draw(){
  background(0);
  //thread("drawNodes");
  //thread("drawPackets");
  
  for (int i = 0; i < nodes.size(); i++) {
    Node curNode = nodes.get(i);
    curNode.draw();
    if (second()-curNode.s > 2 && curNode.radius < 20) {
      nodes.remove(i);
      //IPs.remove(curNode.IP);
    }
  }
  //for (Map.Entry iter : hm.entrySet()) {
    //Node curNode = (Node)iter.getValue();
   // String curIP = (String)iter.getKey();
   // if (curNode != null) {
    //curNode.draw();
   // }
   // if (second()-curNode.s > 2000 && curNode.radius == 5) {
      //hm.put(curIP, null);
      //iter.remove();
      //IPs.remove(curNode.IP);
   // }
  //}
  /*for (Iterator<Map.Entry<String, Node>> cur = hm.entrySet().iterator(); cur.hasNext(); ) {
    Map.Entry<String, Node> entry = cur.next();
    Node curNode = (Node)entry.getValue();
    String curIP = (String)entry
    if (second()-curNode.s > 2000 && curNode.radius == 5) {
      //entry.remove();
    }
  }*/
 for (int i = 0; i < packets.size(); i++) {
    Packet curPack = packets.get(i);
    if (curPack != null) {
      curPack.draw();
      if (second()-curPack.s > 0.5) {
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
  /*Node source = nodes.get(nodes.size()-1);
  Node dest = nodes.get(nodes.size()-1);
  if (IPs.contains(rIP)) {
    for (int i = 0; i < nodes.size(); i++) {
      Node curNode = nodes.get(i);
      if (rIP.equals(curNode.IP)) {
        if (curNode.radius < 100) {
          curNode.radius+=1;
        }        
        dest = curNode;
      }
    }
  } else {
    IPs.add(rIP);
    nodes.add(new Node(rIP));
    dest = nodes.get(nodes.size()-1);
  }*/
  Node source = hm.get(sIP);
  Node dest = hm.get(rIP);
  if (source != null) {
    if (source.radius < 100) {
      source.radius+=1;
    }
  } else {
    nodes.add(new Node(sIP));
    hm.put(sIP, nodes.get(nodes.size()-1));
    source = nodes.get(nodes.size()-1);
  }
  
  if (dest != null) {
    if (source.radius < 100) {
      source.radius+=1;
    }
  } else {
    nodes.add(new Node(rIP));
    hm.put(rIP, nodes.get(nodes.size()-1));
    dest = nodes.get(nodes.size()-1);
  }
  /*
  if (IPs.contains(sIP)) {
    for (int i = 0; i < nodes.size(); i++) {
      Node curNode = nodes.get(i);
      if (sIP.equals(curNode.IP)) {   
        source = curNode;
      }
    }
  } else {
    IPs.add(sIP);
    nodes.add(new Node(sIP));
    source = nodes.get(nodes.size()-1);
  }
  */
  packets.add(new Packet(source, dest));    
  
}


class Node {
  PVector pos = new PVector(random(0, width),random(0, height));
  int radius = 5;
  int s = second();
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
  int s = second();
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

void drawNodes() {
 for (int i = 0; i < nodes.size(); i++) {
   Node curNode = nodes.get(i);
   curNode.draw();
   if (second()-curNode.s > 2 && curNode.radius == 5) {
     nodes.remove(i);
      //IPs.remove(curNode.IP);
    }
  }
}
void drawPackets() {
  for (int i = 0; i < packets.size(); i++) {
    Packet curPack = packets.get(i);
    if (curPack != null) {
      curPack.draw();
      if (second()-curPack.s > 1) {
        packets.remove(i);
      }
    }
  }
}