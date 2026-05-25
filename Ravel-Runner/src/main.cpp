#include <CLI/CLI.hpp>

int main(int argc, char** argv) {
    CLI::App app{"ravel-runner (scaffold)"};
    app.set_version_flag("--version", "0.0.0-scaffold");
    CLI11_PARSE(app, argc, argv);
    return 0;
}
