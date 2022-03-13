
#include <iostream>

namespace dm
{
namespace utils
{

template<typename T>
RessourceVector<T>::RessourceVector()
{
}

template<typename T>
RessourceVector<T>::~RessourceVector()
{
}

template<typename T>
void RessourceVector<T>::cleanup()
{
    //Cleanup would ideally remove the empty spots around
    //However due to indexes being directly linked to the internal array
    //We don't cleanup anything
    //This function is for the list one, for very dynamic content
}

template<typename T>
void RessourceVector<T>::clear()
{
    _data.clear();
    _freeSpaces.clear();
    _isLoaded.clear();
}

template<typename T>
T& RessourceVector<T>::get(dm::utils::RessourceIndex i)
{
    if(i >= size())
    {
        throw std::out_of_range(__FUNCTION__);
    }
    return _data[i];
}

template<typename T>
const T& RessourceVector<T>::get(dm::utils::RessourceIndex i) const
{
    if(i >= size())
    {
        throw std::out_of_range(__FUNCTION__);
    }
    return _data[i];
}

template<typename T>
T& RessourceVector<T>::operator[](dm::utils::RessourceIndex i)
{
    return get(i);
}

template<typename T>
const T& RessourceVector<T>::operator[](dm::utils::RessourceIndex i) const
{
    return get(i);
}

template<typename T>
const dm::utils::RessourceIndex RessourceVector<T>::create()
{
    size_t id = static_cast<size_t>(-1);

    if(freeCount() == 0)
    {
        id = size();
        _data.push_back(T());
        _isLoaded.push_back(true);
    }
    else
    {
        id = _freeSpaces.front();
        _freeSpaces.erase(_freeSpaces.begin());
        _isLoaded[id] = true;
    }

    return id;
}

template<typename T>
void RessourceVector<T>::remove(dm::utils::RessourceIndex i)
{
    if(i >= size()) return;

    _freeSpaces.emplace_back(i);
    _isLoaded[i] = false;
}

template<typename T>
dm::utils::RessourceIndex RessourceVector<T>::add(const T& t)
{
    RessourceIndex i = create();
    get(i) = t;
    return i;
}

template<typename T>
bool RessourceVector<T>::isLoaded(dm::utils::RessourceIndex index) const
{
    if (index >= size()) return false;
    return _isLoaded[index];
}

template<typename T>
size_t RessourceVector<T>::count() const
{
    return size() - freeCount();
}

template<typename T>
size_t RessourceVector<T>::size() const
{
    return _data.size();
}

template<typename T>
size_t RessourceVector<T>::freeCount() const
{
    return _freeSpaces.size();
}

template<typename T>
void RessourceVector<T>::resize(size_t newsize)
{
    if (newsize < size()) return;

    for (size_t i = size(); i < newsize; ++i)
    {
        _freeSpaces.push_back(i);
    }
    _data.resize(newsize);
}

template<typename T>
void RessourceVector<T>::reserve(size_t newsize)
{
    if (newsize < size()) return;

    _data.reserve(newsize);
}

}
}