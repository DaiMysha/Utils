/**
BSD 2-Clause License

Copyright (c) 2017, Christophe Gire
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <dmUtils/FixedSizeList.hpp>

#include <cassert>

namespace dm {
namespace utils {

	template <typename T>
    FixedSizeList<T>::FixedSizeList() : _data(nullptr), _first(0), _last(0), _capacity(0), _stored(0)
	{
    }

    template <typename T>
    FixedSizeList<T>::FixedSizeList(size_t size)
	{
        init(size);
    }

    template <typename T>
    FixedSizeList<T>::~FixedSizeList()
	{
        delete[] _data;
    }

    template <typename T>
    void FixedSizeList<T>::resize(size_t size)
	{
        if (_data)
        {
            delete[] _data;
            _data = nullptr;
        }

        if (size)
        {
            _data = new T[size];
        }
        else
        {
            _data = nullptr;
        }

        _first = _last = 0;
        _capacity = size;
        _stored = 0;
    }

    template <typename T>
    size_t FixedSizeList<T>::size() const
	{
        return _stored;
    }

    template <typename T>
    size_t FixedSizeList<T>::capacity() const
	{
        return _capacity;
    }

    template <typename T>
    bool FixedSizeList<T>::isEmpty() const
	{
        return _stored == 0;
    }

    template <typename T>
    bool FixedSizeList<T>::isFull() const
	{
        return _capacity != 0 && _stored == _capacity;
    }

	template <typename T>
	void FixedSizeList<T>::clear()
	{
		if(!isEmpty())
		{
			_stored = 0;
			_first = _last = 0;
		}
	}

    template <typename T>
    T FixedSizeList<T>::pop_back()
	{
        if (isEmpty()) throw std::logic_error(__FUNCTION__);

        T tmp = get(_last);

        if (_last == 0)
        {
            _last = _capacity - 1;
        }
        else
        {
            --_last;
        }

        if (_stored > 0)
        {
            --_stored;
        }
        return tmp;
    }

    template <typename T>
    T FixedSizeList<T>::pop_front()
	{
        if (isEmpty()) throw std::logic_error(__FUNCTION__);

        T tmp = get(_first++);

        if (_first == _capacity)
        {
            _first = 0;
        }

        if (_stored > 0)
        {
            --_stored;
        }

        return tmp;
    }

    template <typename T>
    void FixedSizeList<T>::push_back(T t)
	{
        if(isEmpty())
		{
            _first = _last = 0;
            _data[_first] = t;
            _stored = 1;
            return;
        }
		else if(isFull())
		{
            if (++_first == _capacity)
            {
                _first = 0;
            }
        }
        if (++_last == _capacity)
        {
            _last = 0;
        }
        _data[_last] = t;
        if (_stored < _capacity)
        {
            ++_stored;
        }
    }

    template <typename T>
    void FixedSizeList<T>::push_front(T t)
	{
        if(isEmpty())
		{
            _first = _last = 0;
            _data[_first] = t;
            _stored = 1;
            return;
        }
		else if(isFull())
		{
            if (_last == 0)
            {
                _last = _capacity - 1;
            }
        }
        if (_first == 0)
        {
            _first = _capacity - 1;
        }
        else
        {
            --_first;
        }
        _data[_first]=t;

        if (_stored < _capacity)
        {
            ++_stored;
        }
    }

    template <typename T>
    T FixedSizeList<T>::begin() const
	{
        if (isEmpty()) throw std::logic_error(__FUNCTION__);
        return _data[_first];
    }

    template <typename T>
    T FixedSizeList<T>::end() const
	{
        if (isEmpty()) throw std::logic_error(__FUNCTION__);
        return _data[_last];
    }

    template <typename T>
    T& FixedSizeList<T>::get(size_t i)
	{
        if (i < 0 || i >= size())
        {
            throw std::out_of_range(__FUNCTION__);
        }

        if (isEmpty())
        {
            throw std::logic_error(__FUNCTION__);
        }

        size_t pos = _first+i;
        while (pos >= _capacity)
        {
            pos -= _capacity;
        }
        return _data[pos];
    }

    template <typename T>
    const T& FixedSizeList<T>::get(size_t i) const
	{
        if (i < 0 || i >= size())
        {
            throw std::out_of_range(__FUNCTION__);
        }

        if (isEmpty())
        {
            throw std::logic_error(__FUNCTION__);
        }

        size_t pos = _first + i;
        while (pos >= _capacity)
        {
            pos -= _capacity;
        }
        return _data[pos];
    }

	template <typename T>
	T& FixedSizeList<T>::operator[](size_t i)
	{
		return get(i);
	}

	template <typename T>
	const T& FixedSizeList<T>::operator[](size_t i) const
	{
		return get(i);
	}
}
}
