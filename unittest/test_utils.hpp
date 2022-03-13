#ifndef HEADER_TESTUTILS
#define HEADER_TESTUTILS

#include <iostream>
#include <string>

template <typename T>
void test(const std::string& msg, T value, T expected)
{
    std::cout << msg << " : ";
    if (value == expected)
    {
        std::cout << "PASS";
    }
    else
    {
        std::cout << "/!\\ FAIL /!\\";
    }
    std::cout << std::endl;
}

void test(const std::string& msg, bool value);

#endif //HEADER_TESTUTILS