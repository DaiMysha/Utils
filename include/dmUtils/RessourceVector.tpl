
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
}

template<typename T>
T& RessourceVector<T>::get(dm::utils::RessourceIndex i)
{
    if(i >= capacity())
    {
        throw std::out_of_range(__FUNCTION__);
    }
    return _data[i];
}

template<typename T>
const T& RessourceVector<T>::get(dm::utils::RessourceIndex i) const
{
    if(i >= capacity())
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
        id = capacity();
        _data.push_back(T());
    }
    else
    {
        id = _freeSpaces.front();
        _freeSpaces.erase(_freeSpaces.begin());;
    }

    return id;
}

template<typename T>
void RessourceVector<T>::remove(dm::utils::RessourceIndex i)
{
    if(i >= capacity()) return;

    _freeSpaces.emplace_back(i);
}

template<typename T>
void RessourceVector<T>::add(const T& t)
{
    RessourceIndex i = create();
    get(i) = t;
}

template<typename T>
size_t RessourceVector<T>::size() const
{
    return capacity() - freeCount();
}

template<typename T>
size_t RessourceVector<T>::capacity() const
{
    return _data.size();
}

template<typename T>
size_t RessourceVector<T>::freeCount() const
{
    return _freeSpaces.size();
}

template<typename T>
void RessourceVector<T>::shrinkToFit()
{
    _data.shrink_to_fit();
    //remove the free spaces that are above new size
    if (_freeSpaces.size())
    {
        std::list<RessourceIndex>::iterator it = _freeSpaces.begin();
        while (it != _freeSpaces.end())
        {
            if (*it >= capacity())
            {
                _freeSpaces.erase(it);
            }
            else
            {
                ++it;
            }
        }
    }
}


}
}