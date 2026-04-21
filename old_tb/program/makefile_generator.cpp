#include <iostream>
#include <fstream>
#include <string>
#include <vector>

std::string format_template(const std::string& tmpl,
                            const std::vector<std::string>& args) {
    std::string result = tmpl;
    for (size_t i = 0; i < args.size(); ++i) {
        std::string placeholder = "{" + std::to_string(i + 1) + "}";
        size_t pos = 0;
        while ((pos = result.find(placeholder, pos)) != std::string::npos) {
            result.replace(pos, placeholder.length(), args[i]);
            pos += args[i].length();
        }
    }
    return result;
}

int main(int argc, char* argv[]) {
    if (argc < 9) {
        std::cerr << "Usage: " << argv[0]
                  << " <rtl_path> <topology> <pl> <cs> <ren> <x> <y> <routers_num>"
                  << std::endl;
        return 1;
    }

    std::ifstream infile("Makefile.template");
    if (!infile.is_open()) {
        std::cerr << "Error: Could not open Makefile.template" << std::endl;
        return 1;
    }

    std::string template_content((std::istreambuf_iterator<char>(infile)),
                                  std::istreambuf_iterator<char>());
    infile.close();

    std::vector<std::string> args;
    for (int i = 1; i <= 8; ++i) {
        args.push_back(argv[i]);
    }

    std::string makefile_content = format_template(template_content, args);

    std::ofstream outfile("Makefile");
    if (!outfile.is_open()) {
        std::cerr << "Error: Could not create Makefile" << std::endl;
        return 1;
    }

    outfile << makefile_content;
    outfile.close();

    std::cout << "Makefile generated successfully!" << std::endl;
    return 0;
}