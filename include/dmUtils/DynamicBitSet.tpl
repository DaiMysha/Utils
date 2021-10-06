
#include "DynamicBitset.hpp"
#include <iostream>
namespace dm {
namespace utils {

template <typename T>
bool DynamicBitset<T>::has(size_t i) const
{
	size_t index = _index(i);
	if(index >= _set.size()) return false;
	return _set[index] & (_bit(_bitIndex(i)));
}

template <typename T>
void DynamicBitset<T>::set(size_t i)
{
	size_t index = _index(i);
	if(index >= _set.size()) _resize(index);

	_set[index] |= _bit(_bitIndex(i));
}

template <typename T>
void DynamicBitset<T>::reset(size_t i)
{
	size_t index = _index(i);
	if(index >= _set.size()) return;

	_set[index] &= (~_bit(_bitIndex(i)));
}

template <typename T>
size_t DynamicBitset<T>::countOnes() const
{
	size_t c = 0;
	for(size_t i = 0; i < _set.size(); ++i)
	{
		if(_set[i] != 0) ++c;
	}
	return c;
}

template <typename T>
void DynamicBitset<T>::_resize(size_t newSize)
{
	if(newSize == 0)
	{
		if(_set.size() == 0)
		{
			_set.resize(1);
			_set[0] = 0;
		}
	}
	else
	{
		if(newSize <= _set.size()) return;

		size_t oldSize = _set.size();
		_set.resize(newSize);
		for(size_t i = oldSize; i < newSize; ++i)
		{
			_set[i] = 0;
		} 
	}
}

template <typename T>
size_t DynamicBitset<T>::_index(size_t i) const
{
	return i / (sizeof(T) * 8);
}

template <typename T>
size_t DynamicBitset<T>::_bitIndex(size_t i) const
{
	return i % (sizeof(T) * 8);
}

template<typename T>
T DynamicBitset<T>::_bit(size_t bitIndex) const
{
	return static_cast<T>(1 << bitIndex);
}

}
}
