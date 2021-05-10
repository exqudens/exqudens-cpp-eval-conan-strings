from conans import ConanFile, tools
from os import path


def get_version():
    return tools.load(path.join(path.dirname(path.dirname(path.abspath(__file__))), "version.txt")).strip()


class ConanConfiguration(ConanFile):
    requires = [
        "lib-exqudens-cpp-eval-conan-strings/" + get_version() + "@test-user/test-channel"
    ]
    settings = "arch", "os", "compiler", "build_type"
    generators = "cmake_paths", "cmake_find_package"

    def imports(self):
        self.copy(pattern="*.dll", src="bin", dst="bin")
