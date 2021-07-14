#include "exqudens/test/Application.hpp"
#include "exqudens/evaluation/StringsTests.hpp"

namespace exqudens::test {

  class StringsTestsApplication : public Application {

    public:

      using Application::Application;

    protected:

      void initialize() override {
        addTestMethods<exqudens::evaluation::StringsTests>(
            &exqudens::evaluation::StringsTests::test1, "exqudens.evaluation.StringsTests.test1"
        );
      }

  };

}

int main(int argc, char** argv) {
  return exqudens::test::StringsTestsApplication(argc, argv).run();
}
