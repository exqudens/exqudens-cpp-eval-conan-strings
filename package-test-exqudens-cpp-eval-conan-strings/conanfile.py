from conans import ConanFile, tools


class ConanConfiguration(ConanFile):
    requires = [
        # "fmt/7.1.3",
        "library-exqudens-cpp-eval-conan-strings/1.0.0@test-user/test-channel"
    ]
    settings = "arch", "os", "compiler", "build_type"
    # generators = "cmake"
    # description = "..."
    # url = "..."
    # license = "..."
    # author = "..."
    # topics = "..."

    def imports(self):
        self.copy(pattern="*.dll", dst="packages", folder=True)
        self.copy(pattern="*.dylib", dst="packages", folder=True)
        self.copy(pattern="*.lib", dst="packages", folder=True)
        self.copy(pattern="*.hpp", dst="packages", folder=True)
        self.copy(pattern="*.h", dst="packages", folder=True)
