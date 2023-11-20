Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FACC30CF1
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P6/5ib8Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pa0I2xf4wcMhRrMjWbBs4cpbiCT8Um3g0uY2nNBEYqs=;
	b=P6/5ib8Z7gAXrgPBVjNa82b318pBXrOSIBNbq3oFrATBciFC3nREtc4y3VpIajr2G6emOl
	gnzcny0aNOAvemLNhvSf43ssmTAes1QlBVy3LW9YtLiYmyAecfJJIJ/3zcpjhcnjs4zDbO
	KvakBcmfHp0OHiOvr/wPBvaho1wCBBc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-3p5Bc7WSMaGvdLR2IX1v1A-1; Mon, 20 Nov 2023 17:29:57 -0500
X-MC-Unique: 3p5Bc7WSMaGvdLR2IX1v1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BAF0101A54C
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:57 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0558E1121306;
	Mon, 20 Nov 2023 22:29:57 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 02BA151CDB; Mon, 20 Nov 2023 17:29:57 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/3] dm vdo: remove pointer-map
Date: Mon, 20 Nov 2023 17:29:54 -0500
Message-ID: <5a68dbbe215ee41fa847f9ff54ed79f8b85f3917.1700517230.git.msakai@redhat.com>
In-Reply-To: <cover.1700517230.git.msakai@redhat.com>
References: <cover.1700517230.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Bruce Johnston <bjohnsto@redhat.com>

Reviewed-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c      |  50 ++-
 drivers/md/dm-vdo/dedupe.h      |   2 +-
 drivers/md/dm-vdo/pointer-map.c | 696 --------------------------------
 drivers/md/dm-vdo/pointer-map.h |  81 ----
 4 files changed, 25 insertions(+), 804 deletions(-)
 delete mode 100644 drivers/md/dm-vdo/pointer-map.c
 delete mode 100644 drivers/md/dm-vdo/pointer-map.h

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index f882d56581dc..00ad2e66872d 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -133,10 +133,10 @@
 #include "completion.h"
 #include "constants.h"
 #include "data-vio.h"
+#include "int-map.h"
 #include "io-submitter.h"
 #include "packer.h"
 #include "physical-zone.h"
-#include "pointer-map.h"
 #include "slab-depot.h"
 #include "statistics.h"
 #include "types.h"
@@ -370,6 +370,17 @@ struct pbn_lock *vdo_get_duplicate_lock(struct data_vio *data_vio)
 	return data_vio->hash_lock->duplicate_lock;
 }
 
+/**
+ * get_hash_lock_key() - Get the hash lock key to use in int-map.
+ * @lock: The hash lock.
+ *
+ * Return: The key to use for the int map.
+ */
+static u64 get_hash_lock_key(struct hash_lock *lock)
+{
+	return get_unaligned_le64(&lock->hash.name);
+}
+
 /**
  * get_hash_lock_state_name() - Get the string representation of a hash lock state.
  * @state: The hash lock state.
@@ -865,7 +876,7 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 	int result;
 
 	/*
-	 * Borrow and prepare a lock from the pool so we don't have to do two pointer_map accesses
+	 * Borrow and prepare a lock from the pool so we don't have to do two int_map accesses
 	 * in the common case of no lock contention.
 	 */
 	result = ASSERT(!list_empty(&zone->lock_pool),
@@ -882,8 +893,9 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 	 */
 	new_lock->hash = *hash;
 
-	result = vdo_pointer_map_put(zone->hash_lock_map, &new_lock->hash, new_lock,
-				     (replace_lock != NULL), (void **) &lock);
+	result = vdo_int_map_put(zone->hash_lock_map, get_hash_lock_key(new_lock),
+				 new_lock, (replace_lock != NULL),
+				 (void **) &lock);
 	if (result != VDO_SUCCESS) {
 		return_hash_lock_to_pool(zone, uds_forget(new_lock));
 		return result;
@@ -1904,6 +1916,7 @@ void vdo_acquire_hash_lock(struct vdo_completion *completion)
  */
 void vdo_release_hash_lock(struct data_vio *data_vio)
 {
+	u64 lock_key;
 	struct hash_lock *lock = data_vio->hash_lock;
 	struct hash_zone *zone = data_vio->hash_zone;
 
@@ -1917,14 +1930,15 @@ void vdo_release_hash_lock(struct data_vio *data_vio)
 		return;
 	}
 
+	lock_key = get_hash_lock_key(lock);
 	if (lock->registered) {
 		struct hash_lock *removed;
 
-		removed = vdo_pointer_map_remove(zone->hash_lock_map, &lock->hash);
+		removed = vdo_int_map_remove(zone->hash_lock_map, lock_key);
 		ASSERT_LOG_ONLY(lock == removed,
 				"hash lock being released must have been mapped");
 	} else {
-		ASSERT_LOG_ONLY(lock != vdo_pointer_map_get(zone->hash_lock_map, &lock->hash),
+		ASSERT_LOG_ONLY(lock != vdo_int_map_get(zone->hash_lock_map, lock_key),
 				"unregistered hash lock must not be in the lock map");
 	}
 
@@ -2011,22 +2025,6 @@ void vdo_share_compressed_write_lock(struct data_vio *data_vio,
 	ASSERT_LOG_ONLY(claimed, "impossible to fail to claim an initial increment");
 }
 
-/** compare_keys() - Implements pointer_key_comparator_fn. */
-static bool compare_keys(const void *this_key, const void *that_key)
-{
-	/* Null keys are not supported. */
-	return (memcmp(this_key, that_key, sizeof(struct uds_record_name)) == 0);
-}
-
-/** hash_key() - Implements pointer_key_comparator_fn. */
-static u32 hash_key(const void *key)
-{
-	const struct uds_record_name *name = key;
-
-	/* Use a fragment of the record name as a hash code. */
-	return get_unaligned_le32(&name->name[4]);
-}
-
 static void dedupe_kobj_release(struct kobject *directory)
 {
 	uds_free(container_of(directory, struct hash_zones, dedupe_directory));
@@ -2407,8 +2405,8 @@ static int __must_check initialize_zone(struct vdo *vdo, struct hash_zones *zone
 	data_vio_count_t i;
 	struct hash_zone *zone = &zones->zones[zone_number];
 
-	result = vdo_make_pointer_map(VDO_LOCK_MAP_CAPACITY, 0, compare_keys,
-				      hash_key, &zone->hash_lock_map);
+	result = vdo_make_int_map(VDO_LOCK_MAP_CAPACITY, 0,
+				  &zone->hash_lock_map);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2532,7 +2530,7 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 		struct hash_zone *zone = &zones->zones[i];
 
 		uds_free_funnel_queue(uds_forget(zone->timed_out_complete));
-		vdo_free_pointer_map(uds_forget(zone->hash_lock_map));
+		vdo_free_int_map(uds_forget(zone->hash_lock_map));
 		uds_free(uds_forget(zone->lock_array));
 	}
 
@@ -2847,7 +2845,7 @@ static void dump_hash_zone(const struct hash_zone *zone)
 	}
 
 	uds_log_info("struct hash_zone %u: mapSize=%zu",
-		     zone->zone_number, vdo_pointer_map_size(zone->hash_lock_map));
+		     zone->zone_number, vdo_int_map_size(zone->hash_lock_map));
 	for (i = 0; i < LOCK_POOL_CAPACITY; i++)
 		dump_hash_lock(&zone->lock_array[i]);
 }
diff --git a/drivers/md/dm-vdo/dedupe.h b/drivers/md/dm-vdo/dedupe.h
index 90c5779bfe70..773dde5f9365 100644
--- a/drivers/md/dm-vdo/dedupe.h
+++ b/drivers/md/dm-vdo/dedupe.h
@@ -40,7 +40,7 @@ struct hash_zone {
 	thread_id_t thread_id;
 
 	/* Mapping from record name fields to hash_locks */
-	struct pointer_map *hash_lock_map;
+	struct int_map *hash_lock_map;
 
 	/* List containing all unused hash_locks */
 	struct list_head lock_pool;
diff --git a/drivers/md/dm-vdo/pointer-map.c b/drivers/md/dm-vdo/pointer-map.c
deleted file mode 100644
index 61eb2d3cd8e5..000000000000
--- a/drivers/md/dm-vdo/pointer-map.c
+++ /dev/null
@@ -1,696 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2023 Red Hat
- */
-
-/**
- * DOC:
- *
- * Hash table implementation of a map from integers to pointers, implemented using the Hopscotch
- * Hashing algorithm by Herlihy, Shavit, and Tzafrir (see
- * http://en.wikipedia.org/wiki/Hopscotch_hashing). This implementation does not contain any of the
- * locking/concurrency features of the algorithm, just the collision resolution scheme.
- *
- * Hopscotch Hashing is based on hashing with open addressing and linear probing. All the entries
- * are stored in a fixed array of buckets, with no dynamic allocation for collisions. Unlike linear
- * probing, all the entries that hash to a given bucket are stored within a fixed neighborhood
- * starting at that bucket. Chaining is effectively represented as a bit vector relative to each
- * bucket instead of as pointers or explicit offsets.
- *
- * When an empty bucket cannot be found within a given neighborhood, subsequent neighborhoods are
- * searched, and one or more entries will "hop" into those neighborhoods. When this process works,
- * an empty bucket will move into the desired neighborhood, allowing the entry to be added. When
- * that process fails (typically when the buckets are around 90% full), the table must be resized
- * and the all entries rehashed and added to the expanded table.
- *
- * Unlike linear probing, the number of buckets that must be searched in the worst case has a fixed
- * upper bound (the size of the neighborhood). Those entries occupy a small number of memory cache
- * lines, leading to improved use of the cache (fewer misses on both successful and unsuccessful
- * searches). Hopscotch hashing outperforms linear probing at much higher load factors, so even
- * with the increased memory burden for maintaining the hop vectors, less memory is needed to
- * achieve that performance. Hopscotch is also immune to "contamination" from deleting entries
- * since entries are genuinely removed instead of being replaced by a placeholder.
- *
- * The published description of the algorithm used a bit vector, but the paper alludes to an offset
- * scheme which is used by this implementation. Since the entries in the neighborhood are within N
- * entries of the hash bucket at the start of the neighborhood, a pair of small offset fields each
- * log2(N) bits wide is all that's needed to maintain the hops as a linked list. In order to encode
- * "no next hop" (i.e. NULL) as the natural initial value of zero, the offsets are biased by one
- * (i.e. 0 => NULL, 1 => offset=0, 2 => offset=1, etc.) We can represent neighborhoods of up to 255
- * entries with just 8+8=16 bits per entry. The hop list is sorted by hop offset so the first entry
- * in the list is always the bucket closest to the start of the neighborhood.
- *
- * While individual accesses tend to be very fast, the table resize operations are very, very
- * expensive. If an upper bound on the latency of adding an entry to the table is needed, we either
- * need to ensure the table is pre-sized to be large enough so no resize is ever needed, or we'll
- * need to develop an approach to incrementally resize the table.
- */
-
-#include "pointer-map.h"
-
-#include <linux/minmax.h>
-
-#include "errors.h"
-#include "logger.h"
-#include "memory-alloc.h"
-#include "numeric.h"
-#include "permassert.h"
-
-enum {
-	DEFAULT_CAPACITY = 16, /* the number of neighborhoods in a new table */
-	NEIGHBORHOOD = 255, /* the number of buckets in each neighborhood */
-	MAX_PROBES = 1024, /* limit on the number of probes for a free bucket */
-	NULL_HOP_OFFSET = 0, /* the hop offset value terminating the hop list */
-	DEFAULT_LOAD = 75 /* a compromise between memory use and performance */
-};
-
-/**
- * struct bucket - Hash buckets.
- *
- * Buckets are packed together to reduce memory usage and improve cache efficiency. It would be
- * tempting to encode the hop offsets separately and maintain alignment of key/value pairs, but
- * it's crucial to keep the hop fields near the buckets that they use them so they'll tend to share
- * cache lines.
- */
-struct __packed bucket {
-	/**
-	 * @first_hop: The biased offset of the first entry in the hop list of the neighborhood
-	 * that hashes to this bucket.
-	 */
-	u8 first_hop;
-	/** @next_hop: the biased offset of the next bucket in the hop list. */
-	u8 next_hop;
-	/** @key: The key stored in this bucket. */
-	const void *key;
-	/** @value: The value stored in this bucket (NULL if empty). */
-	void *value;
-};
-
-/**
- * struct pointer_map - The concrete definition of the opaque pointer_map type.
- *
- * To avoid having to wrap the neighborhoods of the last entries back around to the start of the
- * bucket array, we allocate a few more buckets at the end of the array instead, which is why
- * capacity and bucket_count are different.
- */
-struct pointer_map {
-	/** @size: The number of entries stored in the map. */
-	size_t size;
-	/** @capacity: The number of neighborhoods in the map. */
-	size_t capacity;
-	/** @bucket_count: The number of buckets in the bucket array. */
-	size_t bucket_count;
-	/** @buckets: The array of hash buckets. */
-	struct bucket *buckets;
-	/** @comparator: The function for comparing keys for equality. */
-	pointer_key_comparator *comparator;
-	/** @hasher: The function for getting a hash code from a key. */
-	pointer_key_hasher *hasher;
-};
-
-/**
- * allocate_buckets() - Initialize a pointer_map.
- * @map: The map to initialize.
- * @capacity: The initial capacity of the map.
- *
- * Return: UDS_SUCCESS or an error code.
- */
-static int allocate_buckets(struct pointer_map *map, size_t capacity)
-{
-	map->size = 0;
-	map->capacity = capacity;
-
-	/*
-	 * Allocate NEIGHBORHOOD - 1 extra buckets so the last bucket can have a full neighborhood
-	 * without have to wrap back around to element zero.
-	 */
-	map->bucket_count = capacity + (NEIGHBORHOOD - 1);
-	return uds_allocate(map->bucket_count,
-			    struct bucket,
-			    "pointer_map buckets",
-			    &map->buckets);
-}
-
-/**
- * vdo_make_pointer_map() - Allocate and initialize a pointer_map.
- * @initial_capacity: The number of entries the map should initially be capable of holding (zero
- *                    tells the map to use its own small default).
- * @initial_load: The load factor of the map, expressed as an integer percentage (typically in the
- * range 50 to 90, with zero telling the map to use its own default).
- * @comparator: The function to use to compare the referents of two pointer keys for equality.
- * @hasher: The function to use obtain the hash code associated with each pointer key
- * @map_ptr: A pointer to hold the new pointer_map.
- *
- * Return: UDS_SUCCESS or an error code.
- */
-int vdo_make_pointer_map(size_t initial_capacity,
-			 unsigned int initial_load,
-			 pointer_key_comparator comparator,
-			 pointer_key_hasher hasher,
-			 struct pointer_map **map_ptr)
-{
-	int result;
-	struct pointer_map *map;
-	size_t capacity;
-
-	/* Use the default initial load if the caller did not specify one. */
-	if (initial_load == 0)
-		initial_load = DEFAULT_LOAD;
-	if (initial_load > 100)
-		return UDS_INVALID_ARGUMENT;
-
-	result = uds_allocate(1, struct pointer_map, "pointer_map", &map);
-	if (result != UDS_SUCCESS)
-		return result;
-
-	map->hasher = hasher;
-	map->comparator = comparator;
-
-	/* Use the default capacity if the caller did not specify one. */
-	capacity = (initial_capacity > 0) ? initial_capacity : DEFAULT_CAPACITY;
-
-	/*
-	 * Scale up the capacity by the specified initial load factor. (i.e to hold 1000 entries at
-	 * 80% load we need a capacity of 1250)
-	 */
-	capacity = capacity * 100 / initial_load;
-
-	result = allocate_buckets(map, capacity);
-	if (result != UDS_SUCCESS) {
-		vdo_free_pointer_map(uds_forget(map));
-		return result;
-	}
-
-	*map_ptr = map;
-	return UDS_SUCCESS;
-}
-
-/**
- * vdo_free_pointer_map() - Free a pointer_map.
- * @map: The pointer_map to free.
- *
- * The map does not own the pointer keys and values stored in the map and they are not freed by
- * this call.
- */
-void vdo_free_pointer_map(struct pointer_map *map)
-{
-	if (map == NULL)
-		return;
-
-	uds_free(uds_forget(map->buckets));
-	uds_free(uds_forget(map));
-}
-
-/**
- * vdo_pointer_map_size() - Get the number of entries stored in a pointer_map.
- * @map: The pointer_map to query.
- *
- * Return: The number of entries in the map.
- */
-size_t vdo_pointer_map_size(const struct pointer_map *map)
-{
-	return map->size;
-}
-
-/**
- * dereference_hop() - Convert a biased hop offset within a neighborhood to a pointer to the bucket
- *                     it references.
- * @neighborhood: The first bucket in the neighborhood.
- * @hop_offset: The biased hop offset to the desired bucket.
- *
- * Return: NULL if hop_offset is zero, otherwise a pointer to the bucket in the neighborhood at
- *         hop_offset - 1.
- */
-static struct bucket *dereference_hop(struct bucket *neighborhood, unsigned int hop_offset)
-{
-	BUILD_BUG_ON(NULL_HOP_OFFSET != 0);
-	if (hop_offset == NULL_HOP_OFFSET)
-		return NULL;
-
-	return &neighborhood[hop_offset - 1];
-}
-
-/**
- * insert_in_hop_list() - Add a bucket into the hop list for the neighborhood, inserting it into
- *                        the list so the hop list remains sorted by hop offset.
- * @neighborhood: The first bucket in the neighborhood.
- * @new_bucket: The bucket to add to the hop list.
- */
-static void insert_in_hop_list(struct bucket *neighborhood, struct bucket *new_bucket)
-{
-	/* Zero indicates a NULL hop offset, so bias the hop offset by one. */
-	int hop_offset = 1 + (new_bucket - neighborhood);
-
-	/* Handle the special case of adding a bucket at the start of the list. */
-	int next_hop = neighborhood->first_hop;
-
-	if ((next_hop == NULL_HOP_OFFSET) || (next_hop > hop_offset)) {
-		new_bucket->next_hop = next_hop;
-		neighborhood->first_hop = hop_offset;
-		return;
-	}
-
-	/* Search the hop list for the insertion point that maintains the sort order. */
-	for (;;) {
-		struct bucket *bucket = dereference_hop(neighborhood, next_hop);
-
-		next_hop = bucket->next_hop;
-
-		if ((next_hop == NULL_HOP_OFFSET) || (next_hop > hop_offset)) {
-			new_bucket->next_hop = next_hop;
-			bucket->next_hop = hop_offset;
-			return;
-		}
-	}
-}
-
-/**
- * select_bucket() - Select and return the hash bucket for a given search key.
- * @map: The map to search.
- * @key: The mapping key.
- */
-static struct bucket *select_bucket(const struct pointer_map *map, const void *key)
-{
-	/*
-	 * Scale the 32-bit hash to a bucket index by treating it as a binary fraction and
-	 * multiplying that by the capacity. If the hash is uniformly distributed over [0 ..
-	 * 2^32-1], then (hash * capacity / 2^32) should be uniformly distributed over [0 ..
-	 * capacity-1]. The multiply and shift is much faster than a divide (modulus) on X86 CPUs.
-	 */
-	u64 hash = map->hasher(key);
-
-	return &map->buckets[(hash * map->capacity) >> 32];
-}
-
-/**
- * search_hop_list() - Search the hop list.
- * @map: The map being searched.
- * @bucket: The map bucket to search for the key.
- * @key: The mapping key.
- * @previous_ptr: if not NULL, a pointer in which to store the bucket in the list preceding the one
- *                that had the matching key.
- *
- * Searches the hop list associated with given hash bucket for a given search key. If the key is
- * found, returns a pointer to the entry (bucket or collision), otherwise returns NULL.
- *
- * Return: an entry that matches the key, or NULL if not found.
- */
-static struct bucket *search_hop_list(struct pointer_map *map,
-				      struct bucket *bucket,
-				      const void *key,
-				      struct bucket **previous_ptr)
-{
-	struct bucket *previous = NULL;
-	unsigned int next_hop = bucket->first_hop;
-
-	while (next_hop != NULL_HOP_OFFSET) {
-		/* Check the neighboring bucket indexed by the offset for the desired key. */
-		struct bucket *entry = dereference_hop(bucket, next_hop);
-
-		if ((entry->value != NULL) && map->comparator(key, entry->key)) {
-			if (previous_ptr != NULL)
-				*previous_ptr = previous;
-			return entry;
-		}
-		next_hop = entry->next_hop;
-		previous = entry;
-	}
-	return NULL;
-}
-
-/**
- * vdo_pointer_map_get() - Retrieve the value associated with a given key from the pointer_map.
- * @map: The pointer_map to query.
- * @key: The key to look up (may be NULL if the comparator and hasher functions support it).
- *
- * Return: the value associated with the given key, or NULL if the key is not mapped to any value.
- */
-void *vdo_pointer_map_get(struct pointer_map *map, const void *key)
-{
-	struct bucket *match = search_hop_list(map, select_bucket(map, key), key, NULL);
-
-	return ((match != NULL) ? match->value : NULL);
-}
-
-/**
- * resize_buckets() - Increase the number of hash buckets and rehash all the existing entries,
- *                    storing them in the new buckets.
- * @map: The map to resize.
- */
-static int resize_buckets(struct pointer_map *map)
-{
-	int result;
-	size_t i;
-
-	/* Copy the top-level map data to the stack. */
-	struct pointer_map old_map = *map;
-
-	/* Re-initialize the map to be empty and 50% larger. */
-	size_t new_capacity = map->capacity / 2 * 3;
-
-	uds_log_info("%s: attempting resize from %zu to %zu, current size=%zu",
-		     __func__,
-		     map->capacity,
-		     new_capacity,
-		     map->size);
-	result = allocate_buckets(map, new_capacity);
-	if (result != UDS_SUCCESS) {
-		*map = old_map;
-		return result;
-	}
-
-	/* Populate the new hash table from the entries in the old bucket array. */
-	for (i = 0; i < old_map.bucket_count; i++) {
-		struct bucket *entry = &old_map.buckets[i];
-
-		if (entry->value == NULL)
-			continue;
-
-		result = vdo_pointer_map_put(map, entry->key, entry->value, true, NULL);
-		if (result != UDS_SUCCESS) {
-			/* Destroy the new partial map and restore the map from the stack. */
-			uds_free(uds_forget(map->buckets));
-			*map = old_map;
-			return result;
-		}
-	}
-
-	/* Destroy the old bucket array. */
-	uds_free(uds_forget(old_map.buckets));
-	return UDS_SUCCESS;
-}
-
-/**
- * find_empty_bucket() - Probe the bucket array starting at the given bucket for the next empty
- *                       bucket, returning a pointer to it.
- * @map: The map containing the buckets to search.
- * @bucket: The bucket at which to start probing.
- * @max_probes: The maximum number of buckets to search.
- *
- * NULL will be returned if the search reaches the end of the bucket array or if the number of
- * linear probes exceeds a specified limit.
- *
- * Return: The next empty bucket, or NULL if the search failed.
- */
-static struct bucket *
-find_empty_bucket(struct pointer_map *map, struct bucket *bucket, unsigned int max_probes)
-{
-	/*
-	 * Limit the search to either the nearer of the end of the bucket array or a fixed distance
-	 * beyond the initial bucket.
-	 */
-	ptrdiff_t remaining = &map->buckets[map->bucket_count] - bucket;
-	struct bucket *sentinel = &bucket[min_t(ptrdiff_t, remaining, max_probes)];
-	struct bucket *entry;
-
-	for (entry = bucket; entry < sentinel; entry++)
-		if (entry->value == NULL)
-			return entry;
-	return NULL;
-}
-
-/**
- * move_empty_bucket() - Move an empty bucket closer to the start of the bucket array.
- * @map: The map containing the bucket.
-
- * @hole: The empty bucket to fill with an entry that precedes it in one of its enclosing
- *        neighborhoods.
- *
- * This searches the neighborhoods that contain the empty bucket for a non-empty bucket closer to
- * the start of the array. If such a bucket is found, this swaps the two buckets by moving the
- * entry to the empty bucket.
- *
- * Return: The bucket that was vacated by moving its entry to the provided hole, or NULL if no
- *         entry could be moved.
- */
-static struct bucket *
-move_empty_bucket(struct pointer_map *map __always_unused, struct bucket *hole)
-{
-	/*
-	 * Examine every neighborhood that the empty bucket is part of, starting with the one in
-	 * which it is the last bucket. No boundary check is needed for the negative array
-	 * arithmetic since this function is only called when hole is at least NEIGHBORHOOD cells
-	 * deeper into the array than a valid bucket.
-	 */
-	struct bucket *bucket;
-
-	for (bucket = &hole[1 - NEIGHBORHOOD]; bucket < hole; bucket++) {
-		/*
-		 * Find the entry that is nearest to the bucket, which means it will be nearest to
-		 * the hash bucket whose neighborhood is full.
-		 */
-		struct bucket *new_hole = dereference_hop(bucket, bucket->first_hop);
-
-		if (new_hole == NULL) {
-			/*
-			 * There are no buckets in this neighborhood that are in use by this one
-			 * (they must all be owned by overlapping neighborhoods).
-			 */
-			continue;
-		}
-
-		/*
-		 * Skip this bucket if its first entry is actually further away than the hole that
-		 * we're already trying to fill.
-		 */
-		if (hole < new_hole)
-			continue;
-
-		/*
-		 * We've found an entry in this neighborhood that we can "hop" further away, moving
-		 * the hole closer to the hash bucket, if not all the way into its neighborhood.
-		 */
-
-		/*
-		 * The entry that will be the new hole is the first bucket in the list, so setting
-		 * first_hop is all that's needed remove it from the list.
-		 */
-		bucket->first_hop = new_hole->next_hop;
-		new_hole->next_hop = NULL_HOP_OFFSET;
-
-		/* Move the entry into the original hole. */
-		hole->key = new_hole->key;
-		hole->value = new_hole->value;
-		new_hole->value = NULL;
-
-		/* Insert the filled hole into the hop list for the neighborhood. */
-		insert_in_hop_list(bucket, hole);
-		return new_hole;
-	}
-
-	/* We couldn't find an entry to relocate to the hole. */
-	return NULL;
-}
-
-/**
- * update_mapping() - Find and update any existing mapping for a given key, returning the value
- *                    associated with the key in the provided pointer.
- * @map: The pointer_map to attempt to modify.
- * @neighborhood: The first bucket in the neighborhood that would contain the search key.
- * @key: The key with which to associate the new value.
- * @new_value: The value to be associated with the key.
- * @update: Whether to overwrite an existing value.
- * @old_value_ptr: A pointer in which to store the old value (unmodified if no mapping was found).
- *
- * Return: true if the map contains a mapping for the key, false if it does not.
- */
-static bool update_mapping(struct pointer_map *map,
-			   struct bucket *neighborhood,
-			   const void *key,
-			   void *new_value,
-			   bool update,
-			   void **old_value_ptr)
-{
-	struct bucket *bucket = search_hop_list(map, neighborhood, key, NULL);
-
-	if (bucket == NULL) {
-		/* There is no bucket containing the key in the neighborhood. */
-		return false;
-	}
-
-	/*
-	 * Return the value of the current mapping (if desired) and update the mapping with the new
-	 * value (if desired).
-	 */
-	if (old_value_ptr != NULL)
-		*old_value_ptr = bucket->value;
-	if (update) {
-		/*
-		 * We're dropping the old key pointer on the floor here, assuming it's a property
-		 * of the value or that it's otherwise safe to just forget.
-		 */
-		bucket->key = key;
-		bucket->value = new_value;
-	}
-	return true;
-}
-
-/**
- * find_or_make_vacancy() - Find an empty bucket in a specified neighborhood for a new mapping or
- *                          attempt to re-arrange mappings so there is such a bucket.
- * @map: The pointer_map to search or modify.
- * @neighborhood: The first bucket in the neighborhood in which an empty bucket is needed for a new
- *                mapping.
- *
- * This operation may fail (returning NULL) if an empty bucket is not available or could not be
- * relocated to the neighborhood.
- *
- * Return: A pointer to an empty bucket in the desired neighborhood, or NULL if a vacancy could not
- *         be found or arranged.
- */
-static struct bucket *find_or_make_vacancy(struct pointer_map *map, struct bucket *neighborhood)
-{
-	/* Probe within and beyond the neighborhood for the first empty bucket. */
-	struct bucket *hole = find_empty_bucket(map, neighborhood, MAX_PROBES);
-
-	/*
-	 * Keep trying until the empty bucket is in the bucket's neighborhood or we are unable to
-	 * move it any closer by swapping it with a filled bucket.
-	 */
-	while (hole != NULL) {
-		int distance = hole - neighborhood;
-
-		if (distance < NEIGHBORHOOD) {
-			/*
-			 * We've found or relocated an empty bucket close enough to the initial
-			 * hash bucket to be referenced by its hop vector.
-			 */
-			return hole;
-		}
-
-		/*
-		 * The nearest empty bucket isn't within the neighborhood that must contain the new
-		 * entry, so try to swap it with bucket that is closer.
-		 */
-		hole = move_empty_bucket(map, hole);
-	}
-
-	return NULL;
-}
-
-/**
- * vdo_pointer_map_put() - Try to associate a value (a pointer) with an integer in a pointer_map.
- * @map: The pointer_map to attempt to modify.
- * @key: The key with which to associate the new value (may be NULL if the comparator and hasher
- *       functions support it).
- * @new_value: The value to be associated with the key.
- * @update: Whether to overwrite an existing value.
- * @old_value_ptr: A pointer in which to store either the old value (if the key was already mapped)
- *                 or NULL if the map did not contain the key; NULL may be provided if the caller
- *                 does not need to know the old value.
- *
- * If the map already contains a mapping for the provided key, the old value is only replaced with
- * the specified value if update is true. In either case the old value is returned. If the map does
- * not already contain a value for the specified key, the new value is added regardless of the
- * value of update.
- *
- * If the value stored in the map is updated, then the key stored in the map will also be updated
- * with the key provided by this call. The old key will not be returned due to the memory
- * management assumptions described in the interface header comment.
- *
- * Return: UDS_SUCCESS or an error code.
- */
-int vdo_pointer_map_put(struct pointer_map *map,
-			const void *key,
-			void *new_value,
-			bool update,
-			void **old_value_ptr)
-{
-	struct bucket *neighborhood, *bucket;
-
-	if (new_value == NULL)
-		return UDS_INVALID_ARGUMENT;
-
-	/*
-	 * Select the bucket at the start of the neighborhood that must contain any entry for the
-	 * provided key.
-	 */
-	neighborhood = select_bucket(map, key);
-
-	/*
-	 * Check whether the neighborhood already contains an entry for the key, in which case we
-	 * optionally update it, returning the old value.
-	 */
-	if (update_mapping(map, neighborhood, key, new_value, update, old_value_ptr))
-		return UDS_SUCCESS;
-
-	/*
-	 * Find an empty bucket in the desired neighborhood for the new entry or re-arrange entries
-	 * in the map so there is such a bucket. This operation will usually succeed; the loop body
-	 * will only be executed on the rare occasions that we have to resize the map.
-	 */
-	while ((bucket = find_or_make_vacancy(map, neighborhood)) == NULL) {
-		/*
-		 * There is no empty bucket in which to put the new entry in the current map, so
-		 * we're forced to allocate a new bucket array with a larger capacity, re-hash all
-		 * the entries into those buckets, and try again (a very expensive operation for
-		 * large maps).
-		 */
-		int result = resize_buckets(map);
-
-		if (result != UDS_SUCCESS)
-			return result;
-
-		/*
-		 * Resizing the map invalidates all pointers to buckets, so
-		 * recalculate the neighborhood pointer.
-		 */
-		neighborhood = select_bucket(map, key);
-	}
-
-	/* Put the new entry in the empty bucket, adding it to the neighborhood. */
-	bucket->key = key;
-	bucket->value = new_value;
-	insert_in_hop_list(neighborhood, bucket);
-	map->size += 1;
-
-	/*
-	 * There was no existing entry, so there was no old value to be
-	 * returned.
-	 */
-	if (old_value_ptr != NULL)
-		*old_value_ptr = NULL;
-	return UDS_SUCCESS;
-}
-
-/**
- * vdo_pointer_map_remove() - Remove the mapping for a given key from the pointer_map.
- * @map: The pointer_map from which to remove the mapping.
- * @key: The key whose mapping is to be removed (may be NULL if the comparator and hasher functions
- *       support it).
- *
- * Return: the value that was associated with the key, or NULL if it was not mapped.
- */
-void *vdo_pointer_map_remove(struct pointer_map *map, const void *key)
-{
-	void *value;
-
-	/* Select the bucket to search and search it for an existing entry. */
-	struct bucket *bucket = select_bucket(map, key);
-	struct bucket *previous;
-	struct bucket *victim = search_hop_list(map, bucket, key, &previous);
-
-	if (victim == NULL) {
-		/* There is no matching entry to remove. */
-		return NULL;
-	}
-
-	/*
-	 * We found an entry to remove. Save the mapped value to return later and empty the bucket.
-	 */
-	map->size -= 1;
-	value = victim->value;
-	victim->value = NULL;
-	victim->key = 0;
-
-	/* The victim bucket is now empty, but it still needs to be spliced out of the hop list. */
-	if (previous == NULL) {
-		/* The victim is the head of the list, so swing first_hop. */
-		bucket->first_hop = victim->next_hop;
-	} else {
-		previous->next_hop = victim->next_hop;
-	}
-
-	victim->next_hop = NULL_HOP_OFFSET;
-	return value;
-}
diff --git a/drivers/md/dm-vdo/pointer-map.h b/drivers/md/dm-vdo/pointer-map.h
deleted file mode 100644
index 83465d01bfa7..000000000000
--- a/drivers/md/dm-vdo/pointer-map.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright 2023 Red Hat
- */
-
-#ifndef VDO_POINTER_MAP_H
-#define VDO_POINTER_MAP_H
-
-#include <linux/compiler.h>
-#include <linux/types.h>
-
-/*
- * A pointer_map associates pointer values (<code>void *</code>) with the data referenced by
- * pointer keys (<code>void *</code>). <code>NULL</code> pointer values are not supported. A
- * <code>NULL</code> key value is supported when the instance's key comparator and hasher functions
- * support it.
- *
- * The map is implemented as hash table, which should provide constant-time insert, query, and
- * remove operations, although the insert may occasionally grow the table, which is linear in the
- * number of entries in the map. The table will grow as needed to hold new entries, but will not
- * shrink as entries are removed.
- *
- * The key and value pointers passed to the map are retained and used by the map, but are not owned
- * by the map. Freeing the map does not attempt to free the pointers. The client is entirely
- * responsible for the memory management of the keys and values. The current interface and
- * implementation assume that keys will be properties of the values, or that keys will not be
- * memory managed, or that keys will not need to be freed as a result of being replaced when a key
- * is re-mapped.
- */
-
-struct pointer_map;
-
-/**
- * typedef pointer_key_comparator - The prototype of functions that compare the referents of two
- *                                  pointer keys for equality.
- * @this_key: The first element to compare.
- * @that_key: The second element to compare.
- *
- * If two keys are equal, then both keys must have the same the hash code associated with them by
- * the hasher function defined below.
- *
- * Return: true if and only if the referents of the two key pointers are to be treated as the same
- *         key by the map.
- */
-typedef bool pointer_key_comparator(const void *this_key, const void *that_key);
-
-/**
- * typedef pointer_key_hasher - The prototype of functions that get or calculate a hash code
- *                              associated with the referent of pointer key.
- * @key: The pointer key to hash.
- *
- * The hash code must be uniformly distributed over all u32 values. The hash code associated
- * with a given key must not change while the key is in the map. If the comparator function says
- * two keys are equal, then this function must return the same hash code for both keys. This
- * function may be called many times for a key while an entry is stored for it in the map.
- *
- * Return: The hash code for the key.
- */
-typedef u32 pointer_key_hasher(const void *key);
-
-int __must_check vdo_make_pointer_map(size_t initial_capacity,
-				      unsigned int initial_load,
-				      pointer_key_comparator comparator,
-				      pointer_key_hasher hasher,
-				      struct pointer_map **map_ptr);
-
-void vdo_free_pointer_map(struct pointer_map *map);
-
-size_t vdo_pointer_map_size(const struct pointer_map *map);
-
-void *vdo_pointer_map_get(struct pointer_map *map, const void *key);
-
-int __must_check vdo_pointer_map_put(struct pointer_map *map,
-				     const void *key,
-				     void *new_value,
-				     bool update,
-				     void **old_value_ptr);
-
-void *vdo_pointer_map_remove(struct pointer_map *map, const void *key);
-
-#endif /* VDO_POINTER_MAP_H */
-- 
2.42.0

