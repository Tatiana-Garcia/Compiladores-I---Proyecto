//
// Created by tatig on 9/15/2025.
//

#ifndef COMPILADORES_I___PROYECTO_NODE_H
#define COMPILADORES_I___PROYECTO_NODE_H
#include <iostream>
#include <vector>
using namespace std;

class Node {
    //metodos y parametros
    string token;
    string value;
    vector<Node*> children;
    public:
        Node(string token, string value);
        string getValue();
        string getToken();
        vector<Node*>&getChildren();
        void setValue(string token);
        void setToken(string token);
        void setChildren(vector<Node*> children);
        void print(int tam);
        ~Node();

};


#endif //COMPILADORES_I___PROYECTO_NODE_H