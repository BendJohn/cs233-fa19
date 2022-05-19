#include "cacheconfig.h"
#include "utils.h"

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */ 
  // Set all them number to zero, just in case?
  _num_block_offset_bits = 0, _num_index_bits = 0, _num_tag_bits = 0;

  // num of blocks = size / (block_size * associativity)
  uint32_t num_of_sets = size / (block_size * associativity);

  // log2(num_of_sets)
  while (num_of_sets >>= 1) _num_index_bits++;

  // log2(block_size)
  while (block_size >>= 1) _num_block_offset_bits++;

  // tag = 32 - index - offset
  _num_tag_bits = 32 - _num_block_offset_bits - _num_index_bits;
}
