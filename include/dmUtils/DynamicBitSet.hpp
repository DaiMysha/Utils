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

            bool has(size_t i) const;
            void set(size_t i);
            void reset(size_t i);

            size_t countNotEmpty() const;

            void shrink_to_fit();
            size_t size() const;

            size_t storageSizeBit() const;

            T maxValue() const;

        private:
            void _resize(size_t newSize);

            size_t _index(size_t i) const;
            size_t _bitIndex(size_t i) const;
            T _bit(size_t bitIndex) const;
            std::vector<T> _set;
    };

    typedef DynamicBitset<std::uint32_t> DynamicBitset32;
}
}

#include "DynamicBitset.tpl"

#endif // HEADER_DYNAMICBITSET
