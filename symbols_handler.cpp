#include "symbols_handler.h"

std::unordered_map<std::string, int>global;
std::unordered_map<std::string, int>methods;
std::unordered_map<std::string, std::string>globa_places;

void addSymbolToGlobal(std::string str, int type){
    global.insert(std::make_pair(str, type));
}

void addMethodToGlobal(std::string str, int type){
    methods.insert(std::make_pair(str, type));
}

int getTypeGlobal(std::string name){
    //std::cout<<"buscando en global "<<name<<std::endl;
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

void addPlaceToGlobal(std::string place, std::string init){
    globa_places.insert(std::make_pair(place, init));
}

std::string getGlobal(){
    std::ostringstream code;
    for( const auto& sm_pair : globa_places ){
        code << sm_pair.first << " dd "<<sm_pair.second << "\n";
    }
    return code.str();
}