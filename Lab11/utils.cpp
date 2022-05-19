#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  return address >> (32 - cache_config.get_num_tag_bits());
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  return cache_config.get_num_tag_bits() == 32 ?
		0 : (address << cache_config.get_num_tag_bits()) >> (32 - cache_config.get_num_index_bits());
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t bit_mask = (1 << cache_config.get_num_block_offset_bits()) - 1;
  return address & bit_mask;
}
