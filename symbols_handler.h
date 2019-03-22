#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>

void addSymbolToGlobal(std::string str, int type);
void addMethodToGlobal(std::string str, int type);
int getType(std::string name);
int getMethodType(std::string met);

class Context{
public:
    Context(){}
    std::unordered_map<std::string, int> symbols;

    void addToCtx(std::string str, int type){
        symbols.insert(std::make_pair(str,type));
    }

    int getType(std::string name){
        auto symbol = symbols.find(name);
        if(symbol != symbols.end()){
            return symbol->second;
        }
        return -1;
    }
};

class MethodDef{
public:
    std::string name;
    int return_type;
    std::unordered_map<std::string, int> params;
    std::vector<Context*> ctxs;

    int getType(std::string name){
        for(int i = ctxs.size()-1; i >= 0; i++){
            int type = ctxs[i]->getType(name);
            if(type >= 1){
                return type;
            }
        }
        auto param = params.find(name);
        if(param != params.end()){
            return param->second;
        }
        auto symglobal = getType(name);
        return symglobal;
    }
};