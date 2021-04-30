from conans import ConanFile, tools


class ConanConfiguration(ConanFile):
    requires = "library-eval-conan-strings/1.0.0@test-user/test-channel"
    settings = "arch", "os", "compiler", "build_type"
    generators = "cmake"
    # description = "..."
    # url = "..."
    # license = "..."
    # author = "..."
    # topics = "..."

    def imports(self):
        self.copy("*.dll", "bin", "bin")
        self.copy("*.dylib", "bin", "bin")
