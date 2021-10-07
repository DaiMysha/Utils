
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
	if(index >= _set.size()) _resize(index + 1);

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
size_t DynamicBitset<T>::countNotEmpty() const
{
	size_t c = 0;
	for(size_t i = 0; i < _set.size(); ++i)
	{
		if(_set[i] != 0) ++c;
	}
	return c;
}

template <typename T>
void DynamicBitset<T>::shrink_to_fit()
{
	if (size() == 0) return;
	size_t s = size() - 1;

	while (s > 0 && _set[s] == 0)
	{
		--s;
	}

	if (s == 0 && _set[s] == 0) _set.clear();
	else
	{
		++s;
		_set.resize(s);
	}
}

template <typename T>
size_t DynamicBitset<T>::size() const
{
	return _set.size();
}

template <typename T>
size_t DynamicBitset<T>::storageSizeBit() const
{
	return sizeof(T) * 8;
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
T DynamicBitset<T>::maxValue() const
{
	return size() * storageSizeBit();
}

template <typename T>
size_t DynamicBitset<T>::_index(size_t i) const
{
	return i / (storageSizeBit());
}

template <typename T>
size_t DynamicBitset<T>::_bitIndex(size_t i) const
{
	return i % (storageSizeBit());
}

template<typename T>
T DynamicBitset<T>::_bit(size_t bitIndex) const
{
	return static_cast<T>(1 << bitIndex);
}

}
}
