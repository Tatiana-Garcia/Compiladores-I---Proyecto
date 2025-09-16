//
// Created by tatig on 9/15/2025.
//

#include "Node.h"

//Codigo de metodos
Node::Node(string token, string value) {
    this->token = token;
    this->value = value;
}
vector<Node*>&Node::getChildren() {
    return children;
}

string Node::getToken() {
    return token;
}

string Node::getValue() {
    return value;
}

void Node::setChildren(vector<Node *> children) {
    this->children = children;
}

void Node::setToken(string token) {
    this->token = token;
}

void Node::setValue(string token) {
    this->value = token;
}

void Node::print(int tam) {
    //impresion del arbol ast
    for (int i = 0; i < tam; i++) cout << "  ";
    cout << token;
    if (!value.empty()) cout << " (" << value << ")";
    cout << endl;
    for (auto child : children) {
        child->print(tam + 1);
    }
}

Node::~Node() {
    this->children.clear();
    this->token.clear();
    this->value.clear();
}


