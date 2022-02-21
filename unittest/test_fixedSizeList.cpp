
#include "test_utils.hpp"
#include "dmUtilsUnitTests.hpp"

void test_empty_list()
{
    dm::utils::FixedSizeList<int> data;
    data.resize(1);

    std::cout << "*** " << __FUNCTION__ << " ***" << std::endl;
    std::cout << "--- set size" << std::endl;
    test("Size = 0", data.size() == 0);
    test("Capacity = 1", data.capacity() == 1);
    test("IsEmpty = true", data.isEmpty() == true);
    test("IsFull = false", data.isFull() == false);

    data.push_back(0);

    std::cout << "--- add 0" << std::endl;
    test("Size = 1", data.size() == 1);
    test("Capacity = 1", data.capacity() == 1);
    test("IsEmpty = false", data.isEmpty() == false);
    test("IsFull = true", data.isFull() == true);
    test("Value = 0", data.get(0), 0);
    test("Value = 0", data[0], 0);

    data.clear();
    std::cout << "--- clear" << std::endl;
    test("Size = 0", data.size() == 0);
    test("Capacity = 1", data.capacity() == 1);
    test("IsEmpty = true", data.isEmpty() == true);
    test("IsFull = false", data.isFull() == false);

    std::cout << std::endl;
}

void test_one_element()
{
    dm::utils::FixedSizeList<int> data;

    std::cout << "*** " << __FUNCTION__ << " ***" << std::endl;
    test("Size = 0", data.size() == 0);
    test("Capacity = 0", data.capacity() == 0);
    test("IsEmpty = true", data.isEmpty() == true);
    test("IsFull = false", data.isFull() == false);

    std::cout << std::endl;
}

void fixedSizeListUnitTest()
{
    std::cout << "/////// Test FixedSizeList \\\\\\\\\\\\\\" << std::endl;

    test_empty_list();
    test_one_element();
}
