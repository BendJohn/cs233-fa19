#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
  // Find all blocks that could have the addrss
  const CacheConfig config =_cache->get_config();
  vector<Cache::Block*> blocks = _cache->get_blocks_in_set(extract_index(address, config));

  // Get tag for address
  uint32_t tag = extract_tag(address, config);

  // iterate through blocks and find correct tag and validity
  for (size_t i = 0; i < blocks.size(); i++) {
	if (blocks[i]->get_tag() == tag && blocks[i]->is_valid()) {
		_hits++;
		return blocks[i];
	}
  }
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
  // Find all blocks that could have the address
  const CacheConfig config =_cache->get_config();
  vector<Cache::Block*> blocks = _cache->get_blocks_in_set(extract_index(address, config));

  uint32_t tag = extract_tag(address, config);

  // Iterate through and: update the `block`'s tag. 
  // Read data into it from memory. Mark it as valid.
  // Mark it as clean. Return a pointer to the `block`.
  // Also find LRU!
  size_t lru_idx = 0;
  size_t lru = blocks.size() > 0 ? blocks[0]->get_last_used_time() : 4294967296;
  for (size_t i = 0; i < blocks.size(); i++) {
	if (!blocks[i]->is_valid()) {
 		blocks[i]->set_tag(tag);
		blocks[i]->read_data_from_memory(_memory);
		blocks[i]->mark_as_valid();
		blocks[i]->mark_as_clean();
		return blocks[i];
	}

	// Finding lru
	uint32_t curr_time = blocks[i]->get_last_used_time();
	if (curr_time < lru) {
		lru_idx = i;
		lru = curr_time;
	}
  }

  // Deal with lru:
  // If the block is dirty, write it back to memory.
  if (blocks[lru_idx]->is_dirty()) {
	blocks[lru_idx]->write_data_to_memory(_memory);
  }
  blocks[lru_idx]->set_tag(tag);
  blocks[lru_idx]->read_data_from_memory(_memory);
  blocks[lru_idx]->mark_as_valid();
  blocks[lru_idx]->mark_as_clean();
  return blocks[lru_idx];
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
  // 1,2: Find the block in the cache, bring it in if necessary
  Cache::Block* block = find_block(address);
  if (!block) {
	block = bring_block_into_cache(address);
  }

  // 3: Update last_used_time and clock counter
  block->set_last_used_time((++_use_clock).get_count());

  // 4: return data at address
  return block->read_word_at_offset(extract_block_offset(address, _cache->get_config()));
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
  // 1/2:
  Cache::Block* block = find_block(address);
  if (!block) {
	if (_policy.is_write_allocate()) {
		block = bring_block_into_cache(address);
	} else {
		_memory->write_word(address, word);
		return;
	}
  }

  // 3:
  block->set_last_used_time((++_use_clock).get_count());

  // 4:
  block->write_word_at_offset(word, extract_block_offset(address, _cache->get_config()));

  // 5:
  if (_policy.is_write_back()) {
	block->mark_as_dirty();
  } else {
	_memory->write_word(address, word);
  }
}
