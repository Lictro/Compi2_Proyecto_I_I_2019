//#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#define DOCTEST_CONFIG_IMPLEMENT

#include <fstream>
#include <string>
#include "doctest.h"

std::string decafBin = "./decaf";
std::string decafSrcDir = "/home/ideras/classes/Compilers/source_code/decaf_p12019_samples/";

#include "output.cpp"

std::string runCmd(const std::string& cmd) {
    FILE *stream = popen( cmd.c_str(), "r" );
    REQUIRE (stream != nullptr);

    std::ostringstream ssdata;
    char buffer[256] = {0};

    while(fgets(buffer, sizeof(buffer)-1, stream) != nullptr) {
        ssdata << buffer;
    }
    return ssdata.str();
}

void runTest(const char *filename, const char *asmFilename, const std::string& expectedOutput) {
    std::string filepath = std::string(decafSrcDir) + "/" + filename;

    std::string cmd = decafBin + " " + filepath + " > " + asmFilename + " 2>&1";
    std::string decafOutput = runCmd(cmd.c_str());
    if (!decafOutput.empty()) {
        std::cout << "\x1b[0;31mDecaf Output:\x1b[0m" << decafOutput;
    }
    REQUIRE( decafOutput.empty() );

    cmd = std::string("nasm -felf32 -otest.o ") + asmFilename + " 2>&1";
    std::string nasmOutput = runCmd(cmd.c_str());
    if (!nasmOutput.empty()) {
        std::cout << "\x1b[0;31mNASM Output:\x1b[0m" <<nasmOutput;
    }
    REQUIRE( nasmOutput.empty() );

    std::string gccOutput = runCmd("gcc -m32 -otest test.o 2>&1");
    if (!gccOutput.empty()) {
        std::cout << "\x1b[0;35mGCC Output:\x1b[0m" << gccOutput;
    }
    int gccError = gccOutput.find("error:");
    REQUIRE(gccError == static_cast<int>(std::string::npos));

    std::string output = runCmd("./test");
    REQUIRE(!output.empty());
    
    CHECK(output == expectedOutput);
}

#include "test_cases.cpp"

int main(int argc, char** argv) {
    doctest::Context context;

    context.applyCommandLine(argc, argv);

    char *s = std::getenv("DECAF");
    if (s != nullptr) {
        decafBin = s;
    }
    s = std::getenv("DECAF_SRC_DIR");
    if (s != nullptr) {
        decafSrcDir = s;
    }
    std::cout << "Using decaf binary '" << decafBin << "'\n"
              << "Using decaf source from '" << decafSrcDir << '\n';

    return context.run();
}