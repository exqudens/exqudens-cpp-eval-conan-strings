from conans import ConanFile, tools


class ConanConfiguration(ConanFile):
    # requires = "fmt/7.1.3"
    name = "library-eval-conan-strings"
    version = "1.0.0"
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}
    generators = "cmake"
    default_options = {"shared": True}
    # description = "..."
    # url = "..."
    # license = "..."
    # author = "..."
    # topics = "..."

    def package(self):
        self.copy("*")

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
