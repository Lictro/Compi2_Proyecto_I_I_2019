#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>
#include <stack>

void addSymbolToGlobal(std::string str, int type);
void addMethodToGlobal(std::string str, int type);
int getTypeGlobal(std::string name);
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

    int getCount(){
        return symbols.size();
    }
};

class MethodDef{
public:
    std::string name;
    int return_type;
    std::vector<std::string> params;
    std::vector<Context*> ctxs;
    int actual = 0;


    int getType(std::string name){
        for(int i = ctxs.size()-1; i >= 0; i--){
            int type = ctxs[i]->getType(name);
            //std::cout << "gettyo" << std::endl;
            if(type >= 1){
                return type;
            }
        }
        auto symglobal = getTypeGlobal(name);
        return symglobal;
    }

    void addToParams(std::string str, int type){
        params.push_back(str);
        ctxs[0]->addToCtx(str, type);
    }

    void createNewCtx(){
        ctxs.push_back(new Context());
    }

    int getCountParam(){
        return params.size();
    }

    void addToCtx(std::string str, int type){
        ctxs[actual]->addToCtx(str, type);
    }

    void incrementar(){
        actual++;
    }

    void decrementar(){
        actual--;
    }
};