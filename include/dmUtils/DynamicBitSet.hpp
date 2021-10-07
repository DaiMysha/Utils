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

#ifndef HEADER_DYNAMICBITSET
#define HEADER_DYNAMICBITSET

#include <vector>

namespace dm {
namespace utils {

    template <typename T>
    class DynamicBitset
	{
        public:
            class iterator
            {
                public:
                    using iterator_category = std::forward_iterator_tag;
                    using difference_type = std::ptrdiff_t;
                    using value_type = T;
                    using pointer = T;  // or also value_type*
                    using reference = T;  // or also value_type&

                    iterator(DynamicBitset* data);

                    reference operator*() const;
                    pointer operator->();

                    iterator& operator++();
                    iterator operator++(int);

                    bool operator==(const iterator& b) const;
                    bool operator!=(const iterator& b) const;

                private:
                    void _findNext();

                    DynamicBitset* _data;
                    size_t _index;
                    char _bit;
            };

            class const_iterator
            {
                public:
                    using iterator_category = std::forward_iterator_tag;
                    using difference_type = std::ptrdiff_t;
                    using value_type = T;
                    using pointer = T;  // or also value_type*
                    using reference = T;  // or also value_type&

                    const_iterator(const DynamicBitset* data);

                    reference operator*() const;
                    pointer operator->();

                    const_iterator& operator++();
                    const_iterator operator++(int);

                    bool operator==(const const_iterator& b) const;
                    bool operator!=(const const_iterator& b) const;

                private:
                    void _findNext();

                    const DynamicBitset* _data;
                    size_t _index;
                    char _bit;
            };

            DynamicBitset();

            bool has(size_t i) const;
            void set(size_t i);
            void reset(size_t i);

            size_t countNotEmpty() const;

            void shrink_to_fit();
            void clear();

            //size returns the amount of T needed to store everything
            size_t size() const;

            //count returns the number of 1s stored
            size_t count() const;

            size_t storageSizeBit() const;

            T maxValue() const;

            iterator begin();
            iterator end();

            const_iterator begin() const;
            const_iterator end() const;

        private:
            void _resize(size_t newSize);

            size_t _index(size_t i) const;
            size_t _bitIndex(size_t i) const;
            T _bit(size_t bitIndex) const;
            std::vector<T> _set;
            size_t _counter; //counts the number of 1s
    };

    typedef DynamicBitset<std::uint32_t> DynamicBitset32;
}
}

#include "DynamicBitset.tpl"

#endif // HEADER_DYNAMICBITSET
