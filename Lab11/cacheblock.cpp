#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t addr = (get_tag() << _cache_config.get_num_index_bits()) | _index;
  return addr << _cache_config.get_num_block_offset_bits();
}
