from conans import ConanFile


class ConanConfiguration(ConanFile):
    requires = [
        "exqudens-cpp-test-lib/1.0.0"
    ]
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}
    generators = "cmake_paths", "cmake_find_package"

    def imports(self):
        self.copy(pattern="*.dll", dst="bin", src="bin")
        self.copy(pattern="*.dylib", dst="lib", src="lib")


if __name__ == "__main__":
    pass
