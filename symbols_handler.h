#include <iostream>
#include <utility> 
#include <unordered_map>
#include <vector>
#include <string>
#include <stack>
#include <sstream>

void addSymbolToGlobal(std::string str, int type);
void addMethodToGlobal(std::string str, int type);
int getTypeGlobal(std::string name);
int getMethodType(std::string met);
void addPlaceToGlobal(std::string place, std::string init);
std::string getGlobal();
std::vector<std::string> split(std::string phrase, std::string delimiter);


class Context{
public:
    Context(){}
    std::vector<std::string> symbols;
    std::vector<int> types;

    void addToCtx(std::string str, int type){
        //std::cout<<"add en ctx "<<str<<std::endl;
        symbols.push_back(str);
        types.push_back(type);
    }

    int getType(std::string name){
        for(int i = 0; i<symbols.size(); i++){
            if(symbols[i]==name){
                return types[i];
            }
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
    Context* params_c;
    int local;
    int actual;
    int offset;
    int paramoffset;
    std::unordered_map<std::string, std::string> places;
    std::unordered_map<std::string, std::string> paramplaces;

    MethodDef(std::string name){
        this->name = name;
        actual = 0;
        offset = 0;
        local = 1;
        ctxs.push_back(new Context());
        params_c = new Context();
    }

    int getOffset(){
        offset += 4;
        return offset;
    }

    int getParamOffset(){
        paramoffset -= 4;
        return paramoffset;
    }

    int getType(std::string name){
        //std::cout<<"buscando en local "<<name<<std::endl;
        for(int i = ctxs.size()-1; i >= 0; i--){
            int type = ctxs[i]->getType(name);
            if(type >= 1){
                //std::cout << "gettyo "<< name << std::endl;
                return type;
            }
        }
        int i = params_c->getType(name);
        if(i >= 1){
            return i;
        }
        auto symglobal = getTypeGlobal(name);
        return symglobal;
    }

    void addToParams(std::string str, int type){
        params.push_back(str);
        params_c->addToCtx(str,type);
        paramplaces.insert(std::make_pair(str, "ebp + " + std::to_string(getParamOffset())));
    }

    std::string getPlace(std::string str){
        auto place = places.find(str);
        if(place != places.end()){
            return place->second;
        }
        place = paramplaces.find(str);
        if(place != paramplaces.end()){
            return place->second;
        }
        return str;
    }

    void createNewCtx(){
        ctxs.push_back(new Context());
    }

    int getCountParam(){
        return params.size();
    }

    void addToMethodCtx(std::string str, int type){
        ctxs[0]->addToCtx(str, type);
        places.insert(std::make_pair(str, "ebp - " + std::to_string(getOffset())));
    }

    void save(std::string str){
        std::cout<<"target "<<local<<std::endl;
        if(local){
            places.insert(std::make_pair(str, "ebp - " + std::to_string(getOffset())));
        }else{
            std::cout<<"savinggg "<<str<<std::endl;
            paramplaces.insert(std::make_pair(str, "ebp + " + std::to_string(getParamOffset())));
        }
    }

    void incrementar(){
        actual++;
    }

    void decrementar(){
        actual--;
    }
};