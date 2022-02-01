
namespace dm {
namespace utils {

template <typename T>
DynamicBitset<T>::DynamicBitset() : DynamicBitset(0)
{
}

template <typename T>
DynamicBitset<T>::DynamicBitset(size_t initialCount) : _counter(0)
{
	if (initialCount)
	{
		_resize(static_cast<size_t>(std::ceil(static_cast<double>(initialCount) / static_cast<double>(storageSizeBit()))));
	}
	_maxedOutIndividualStorageValue = 0;
	for (size_t b = 0; b < storageSizeBit(); ++b)
	{
		_maxedOutIndividualStorageValue |= (1 << b);
	}
}

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

	if(!has(i)) ++_counter;
	_set[index] |= _bit(_bitIndex(i));
}

template <typename T>
void DynamicBitset<T>::reset(size_t i)
{
	size_t index = _index(i);
	if(index >= _set.size()) return;

	if(has(i)) --_counter;
	_set[index] &= (~_bit(_bitIndex(i)));
}

template <typename T>
bool DynamicBitset<T>::hasSetValues() const
{
	for (size_t i = 0; i < _set.size(); ++i)
	{
		if (_set[i] != 0) return true;
	}
	return false;
}

template <typename T>
bool DynamicBitset<T>::hasUnsetValues() const
{
	for (size_t i = 0; i < _set.size(); ++i)
	{
		if (_set[i] != _maxedOutIndividualStorageValue) return true;
	}
	return false;
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

		//recount the 1s
		for (size_t i : *this)
		{
			++_counter;
		}
	}
}

template <typename T>
void DynamicBitset<T>::clear()
{
	_set.clear();
	_counter = 0;
}

template <typename T>
size_t DynamicBitset<T>::size() const
{
	return _set.size();
}

template <typename T>
size_t DynamicBitset<T>::capacity() const
{
	return size() * storageSizeBit();
}

template <typename T>
size_t DynamicBitset<T>::count() const
{
	return _counter;
}

template <typename T>
size_t DynamicBitset<T>::countUnset() const
{
	return capacity() - count();
}

template <typename T>
size_t DynamicBitset<T>::storageSizeBit() const
{
	return sizeof(T) * 8;
}

///////////////////////////////////////////////////////////////
////////////////////////// PROTECTED //////////////////////////
///////////////////////////////////////////////////////////////

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
	return _maxedOutIndividualStorageValue;
}

template <typename T>
typename DynamicBitset<T>::iterator DynamicBitset<T>::begin()
{
	return iterator(this);
}

template <typename T>
typename DynamicBitset<T>::iterator DynamicBitset<T>::end()
{
	return iterator(nullptr);
}

template <typename T>
typename DynamicBitset<T>::const_iterator DynamicBitset<T>::begin() const
{
	return const_iterator(this);
}

template <typename T>
typename DynamicBitset<T>::const_iterator DynamicBitset<T>::end() const
{
	return const_iterator(nullptr);
}

/// ///////////// private

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

//////////////////////////////////////////////////////////////////////////////
////////////////////////////////// iterator //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

template<typename T>
DynamicBitset<T>::iterator::iterator(DynamicBitset* data)
{
	_data = data;
	_index = 0;
	_bit = -1;

	_findNext();
}


template<typename T>
typename DynamicBitset<T>::iterator::reference DynamicBitset<T>::iterator::operator*() const
{
	return _bit + (_index * _data->storageSizeBit());
}

template<typename T>
typename DynamicBitset<T>::iterator::pointer DynamicBitset<T>::iterator::operator->()
{
	return *this;
}

template<typename T>
typename DynamicBitset<T>::iterator& DynamicBitset<T>::iterator::operator++()
{
	_findNext();

	return *this;
}

template<typename T>
typename DynamicBitset<T>::iterator DynamicBitset<T>::iterator::operator++(int)
{
	iterator tmp = *this;

	_findNext();

	return tmp;
}

template<typename T>
bool DynamicBitset<T>::iterator::operator==(const DynamicBitset<T>::iterator& b) const
{
	return _data == b._data && _index == b._index && _bit == b._bit;
}

template<typename T>
bool DynamicBitset<T>::iterator::operator!=(const DynamicBitset<T>::iterator& b) const
{
	return _data != b._data || _index != b._index || _bit != b._bit;
}

template<typename T>
void DynamicBitset<T>::iterator::_findNext()
{
	if (!_data || _data->size() == 0 || _data->countNotEmpty() == 0)
	{
		_index = static_cast<size_t>(-1);
		_bit = -1;
		_data = nullptr;
		return;
	}

	bool found = false;
	T t;

	while (_index < _data->size() && !found)
	{
		++_bit;
		t = (_data->_set[_index] >> _bit);
		while (t != 0 && (t & 1) == 0 && _bit < (int)_data->storageSizeBit())
		{
			++_bit;
			t = (_data->_set[_index] >> _bit);
		}

		if (_bit < (int)_data->storageSizeBit() && (t & 1))
		{
			found = true;
		}
		else
		{
			++_index;
			_bit = -1;
		}
	}

	if (!found)
	{
		//no more left
		_index = static_cast<size_t>(-1);
		_bit = -1;
		_data = nullptr;
	}
}


//////////////////////////////////////////////////////////////////////////////
////////////////////////////////// const_iterator //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

template<typename T>
DynamicBitset<T>::const_iterator::const_iterator(const DynamicBitset* data)
{
	_data = data;
	_index = 0;
	_bit = -1;

	_findNext();
}


template<typename T>
typename DynamicBitset<T>::const_iterator::reference DynamicBitset<T>::const_iterator::operator*() const
{
	return _bit + (_index * _data->storageSizeBit());
}

template<typename T>
typename DynamicBitset<T>::const_iterator::pointer DynamicBitset<T>::const_iterator::operator->()
{
	return *this;
}

template<typename T>
typename DynamicBitset<T>::const_iterator& DynamicBitset<T>::const_iterator::operator++()
{
	_findNext();

	return *this;
}

template<typename T>
typename DynamicBitset<T>::const_iterator DynamicBitset<T>::const_iterator::operator++(int)
{
	const_iterator tmp = *this;

	_findNext();

	return tmp;
}

template<typename T>
bool DynamicBitset<T>::const_iterator::operator==(const DynamicBitset<T>::const_iterator& b) const
{
	return _data == b._data && _index == b._index && _bit == b._bit;
}

template<typename T>
bool DynamicBitset<T>::const_iterator::operator!=(const DynamicBitset<T>::const_iterator& b) const
{
	return _data != b._data || _index != b._index || _bit != b._bit;
}

template<typename T>
void DynamicBitset<T>::const_iterator::_findNext()
{
	if (!_data || _data->size() == 0 || _data->countNotEmpty() == 0)
	{
		_index = static_cast<size_t>(-1);
		_bit = -1;
		_data = nullptr;
		return;
	}

	bool found = false;
	T t;

	while (_index < _data->size() && !found)
	{
		++_bit;
		t = (_data->_set[_index] >> _bit);
		while (t != 0 && (t & 1) == 0 && _bit < (int)_data->storageSizeBit())
		{
			++_bit;
			t = (_data->_set[_index] >> _bit);
		}

		if (_bit < (int)_data->storageSizeBit() && (t & 1))
		{
			found = true;
		}
		else
		{
			++_index;
			_bit = -1;
		}
	}

	if (!found)
	{
		//no more left
		_index = static_cast<size_t>(-1);
		_bit = -1;
		_data = nullptr;
	}
}


} //namespace utils
} //namespace dm
