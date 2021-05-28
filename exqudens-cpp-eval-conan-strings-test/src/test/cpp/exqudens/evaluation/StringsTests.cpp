#include <string>
#include <iostream>
#include <stdexcept>
#include <vector>

#include "exqudens/evaluation/Strings.hpp"
#include "exqudens/evaluation/StringsTests.hpp"

namespace exqudens::evaluation {

  void StringsTests::test1() {
    Strings strings;
    std::string expectedString = "777";
    std::string actualString = strings.toString(777);
    std::cout << "expectedString: '" << expectedString << "'" << std::endl;
    std::cout << "actualString: '" << actualString << "'" << std::endl;
    if (expectedString != actualString) {
      throw std::runtime_error("");
    }
  }

  int StringsTests::run(int argc, char** argv) {
    using test = void(*)();
    std::vector<test> tests = {
        &test1
    };
    int result = 0;
    std::string info = std::string("Run: '").append(std::string(argv[0])).append("'");
    std::cout << std::string(info.size(), '=') << std::endl;
    std::cout << info << std::endl;
    std::cout << std::string(info.size(), '=') << std::endl;
    for (int i = 0; i < tests.size(); i++) {
      if (result != 0) {
        break;
      }
      try {
        std::cout << std::string(info.size(), '-') << std::endl;
        std::cout << "test: '" << (i + 1) << "'" << std::endl;
        std::cout << std::string(info.size(), '-') << std::endl;
        test t = tests[i];
        t();
        result = 0;
        std::cout << "PASSED" << std::endl;
        std::cout << std::string(info.size(), '-') << std::endl;
      } catch (std::exception& e) {
        std::cerr << std::string("ERROR: ").append(e.what()) << std::endl;
        std::cout << std::string(info.size(), '-') << std::endl;
        result = 1;
      }
    }
    std::cout << std::string(info.size(), '=') << std::endl;
    return result;
  }

}
