from conans import ConanFile, tools


class ConanConfiguration(ConanFile):
    requires = [
        # "fmt/7.1.3"
    ]
    name = "library-exqudens-cpp-eval-conan-strings"
    version = "1.0.0"
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}
    default_options = {"shared": True}

    def imports(self):
        self.copy(pattern="*.dll", dst="packages", folder=True)
        self.copy(pattern="*.dylib", dst="packages", folder=True)
        self.copy(pattern="*.lib", dst="packages", folder=True)
        self.copy(pattern="*.hpp", dst="packages", folder=True)
        self.copy(pattern="*.h", dst="packages", folder=True)

    def package(self):
        self.copy("*")

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
