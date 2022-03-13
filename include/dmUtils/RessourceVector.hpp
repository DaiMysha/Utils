/**
BSD 2-Clause License

Copyright (c) 2017, DaiMysha
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

#ifndef HEADER_RESSOURCEVECTOR
#define HEADER_RESSOURCEVECTOR

#include <vector>
#include <list>

/*
* A RessourceVector represents a collection of objects where
* - Position doesn't matter
* - Order doesn't matter
* - Spaces can be freed at any location and any moment
* - It is more interesting to reuse freed locations rather than just append new data 
* */

namespace dm
{
namespace utils
{

typedef size_t RessourceIndex;

template<typename T>
class RessourceVector
{
    public:
        RessourceVector();
        ~RessourceVector();

        RessourceVector(const RessourceVector& other) = delete;
        RessourceVector(const RessourceVector&& other) = delete;

        void cleanup(); //called every loop after the cleanup clock resets
        void clear();

        T& get(RessourceIndex i);
        const T& get(RessourceIndex i) const;

        T& operator[](RessourceIndex i);
        const T& operator[](RessourceIndex i) const;

        const RessourceIndex create();
        void remove(RessourceIndex i);

        RessourceIndex add(const T& t);

        bool isLoaded(RessourceIndex index) const;

        /** Size functions:
        * count returns the amount of elements that are already set
        * size returns the max amount of elements that can be stored
        * FreeCount returns the amount of elements that have NOT been set
        * size = capacity - freecount
        * */
        size_t count() const;
        size_t size() const;
        size_t freeCount() const;

    protected:
        std::vector<T> _data;
        std::list<RessourceIndex> _freeSpaces;
        std::vector<bool> _isLoaded;
};

}
}

#include "RessourceVector.tpl"

#endif // HEADER_RESSOURCEVECTOR
