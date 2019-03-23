#include "symbols_handler.h"

std::unordered_map<std::string, int>global;
std::unordered_map<std::string, int>methods;

void addSymbolToGlobal(std::string str, int type){
    global.insert(std::make_pair(str, type));
}

void addMethodToGlobal(std::string str, int type){
    methods.insert(std::make_pair(str, type));
}

int getTypeGlobal(std::string name){
    auto symbol = global.find(name);
    if(symbol != global.end()){
        return symbol->second;
    }
    return -1;
}

int getMethodType(std::string met){
    auto method = methods.find(met);
    if(method != global.end()){
        return method->second;
    }
    return -1;
}