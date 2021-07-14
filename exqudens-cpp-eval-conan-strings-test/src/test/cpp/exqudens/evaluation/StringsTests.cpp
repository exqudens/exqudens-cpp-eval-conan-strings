#include <iostream>
#include <stdexcept>

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

}
