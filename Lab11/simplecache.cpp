#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  // set of blocks that correspond to an index
  std::vector<SimpleCacheBlock> blocks = _cache[index];

  // Iterate through, check if valid and correct size
  for (SimpleCacheBlock block : blocks) {
	if (block.valid() && block.tag() == tag) {
		return block.get_byte(block_offset);
	}
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in C++ (hint: Rule of Three)
  // set of blocks that correspond to an index
  std::vector<SimpleCacheBlock>& blocks = _cache[index];
  if (blocks.empty()) return;

  // Iterate through and find invalid block
  for (size_t i = 0; i < blocks.size(); i++) {
	if (!blocks[i].valid()) {
		blocks[i].replace(tag, data);
		return;
	}
  }

  // Else replace at index 0
  blocks[0].replace(tag, data);
}
