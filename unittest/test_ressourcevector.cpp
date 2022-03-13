
#include "test_utils.hpp"
#include "dmUtilsUnitTests.hpp"

void ressourcevectorTest()
{
    std::cout << "/////// Test RessourceVector \\\\\\\\\\\\\\" << std::endl;

    dm::utils::RessourceVector<int> data;

    //empty vector
    std::cout << "*** " << __FUNCTION__ << " ***" << std::endl;

    std::cout << "--- Empty ---" << std::endl;
    test("Size = 0", data.size() == 0);
    test("count = 0", data.count() == 0);
    test("FreeCount = 0", data.freeCount() == 0);
    std::cout << std::endl;

    std::cout << "--- Create ---" << std::endl;
    data.create();
    test("Size = 1", data.size() == 1);
    test("count = 1", data.count() == 1);
    test("FreeCount = 0", data.freeCount() == 0);
    test("Loaded(0) = true", data.isLoaded(0) == true);
    std::cout << std::endl;

    std::cout << "--- Clear ---" << std::endl;
    data.clear();
    test("Size = 0", data.size() == 0);
    test("count = 0", data.count() == 0);
    test("FreeCount = 0", data.freeCount() == 0);
    std::cout << std::endl;

    std::cout << "--- Remove ---" << std::endl;
    data.clear();
    data.add(1);
    data.remove(0);
    test("Size = 1", data.size() == 1);
    test("count = 0", data.count() == 0);
    test("FreeCount = 1", data.freeCount() == 1);
    std::cout << std::endl;

    std::cout << "--- Add ---" << std::endl;
    data.clear();
    data.add(1);
    test("Size = 1", data.size() == 1);
    test("count = 1", data.count() == 1);
    test("FreeCount = 0", data.freeCount() == 0);
    test("get(0) = 1", data.get(0) == 1);
    test("[0] = 1", data[0] == 1);
    test("Loaded(0) = true", data.isLoaded(0) == true);
    std::cout << std::endl;

    std::cout << "--- Add, remove ---" << std::endl;
    data.clear();
    data.add(1);
    data.add(2);
    data.remove(0);
    test("Size = 1", data.size() == 2);
    test("count = 1", data.count() == 1);
    test("FreeCount = 0", data.freeCount() == 1);
    test("get(1) = 2", data[1] == 2);
    test("Loaded(0) = false", data.isLoaded(0) == false);
    test("Loaded(1) = true", data.isLoaded(1) == true);
    std::cout << std::endl;

    std::cout << "--- Add, remove, readd ---" << std::endl;
    data.clear();
    data.add(1);
    data.remove(0);
    data.add(2);
    test("Size = 1", data.size() == 1);
    test("count = 1", data.count() == 1);
    test("FreeCount = 0", data.freeCount() == 0);
    test("get(0) = 2", data[0] == 2);
    test("Loaded(0) = true", data.isLoaded(0) == true);
    std::cout << std::endl;



}
