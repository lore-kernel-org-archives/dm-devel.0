Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C60EEAA65
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719048;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lv86tPF2PpcJvdEEMbvG0Us8ut0+NRqkoeu+tbTV9Hg=;
	b=fF2+TQ7I58FNKB5PFERnZDSO4fUv+g1n3lIqG72lqfQGyVJQChhhn6Y3BMPl74IlMY09Bp
	6ftQ1GBz26dUe++8rWrHnVccfwBMg0Y23K8FH45SKTAHiay8A8c5KZiSRLpJTMwwjWM5Ch
	ZuX8cBuJaNADDbnB+AFx/bceMsfE+tk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-zJe3Thw3M8iVB_LaK30O5A-1; Thu, 14 Sep 2023 15:17:26 -0400
X-MC-Unique: zJe3Thw3M8iVB_LaK30O5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3ED488B7A2;
	Thu, 14 Sep 2023 19:17:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD31540C6EA8;
	Thu, 14 Sep 2023 19:17:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 738C21946A52;
	Thu, 14 Sep 2023 19:16:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BCCAF1946A50
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:16:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA04140C6EBF; Thu, 14 Sep 2023 19:16:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1BFF40C6EA8
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:57 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76778823DED
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:57 +0000 (UTC)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com
 [209.85.222.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251--cV23o2QOPOqa65JoAa8yQ-1; Thu, 14 Sep 2023 15:16:55 -0400
X-MC-Unique: -cV23o2QOPOqa65JoAa8yQ-1
Received: by mail-qk1-f173.google.com with SMTP id
 af79cd13be357-76f2843260bso88481485a.3
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:16:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719014; x=1695323814;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=W1QfySsfOJGHVGI1m0KS1QZmWTUT6n2T16CG0P6TmKY=;
 b=EyCNZ+pEW1qJxeOL8BFl7jeUAsQefsCp9g8wsU0urJJtNfGjLOt+EZFDdsbLQo5krk
 sT1DoR5KN0kG5kDrTh4EBRbxLmoIXhuQCPUnWyFP3exy+bgVV7ysqN0RPlkyD5JWBANl
 GNjwBadT06ygGkzejBrjmqk+MersbwVHSDbcENF5uANaOvv+S2C2MPhKB1W7xACVFAlH
 c5e5rkQRtL6Ytjgyi0qIIMYO/KTIJ4j66cyXXLyy8zX56IqSZILwU4hHrGajalsDtlvh
 c8/XMNQPZbU7UVJpsw5JtKW1SgmsSgnllkLIqAkevqelElvsjYClQumHYhuPe5drFdwH
 ouJA==
X-Gm-Message-State: AOJu0YxRgyX4tZUKWJYthZ3DMip94eESr0iOeBxH00biMTEN+6109hAe
 oqunCxAXRI5MDqSA6Kt1k3HmwrufCfJnVysfUUkodyOmTJzuSpOqY5/NYuUvLzc+nx/fKl3oy0D
 A1vsQXncejp/TzI10KYKn1FhzsvUg+YzVvDn09HII8bsJxLdHG87ZnbnjSbT+NAsHRLQhAxJB
X-Google-Smtp-Source: AGHT+IE+gJ2+aYkS3L1S5CJAbx+k7Fo5K/PAuM1hdBMg62+G5aseq8blvq6efrZysxEUXwkLXqGDuQ==
X-Received: by 2002:a05:620a:4403:b0:76c:ea3f:9010 with SMTP id
 v3-20020a05620a440300b0076cea3f9010mr7420879qkp.16.1694719012860; 
 Thu, 14 Sep 2023 12:16:52 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 w10-20020a05620a148a00b0076ef7810f27sm669789qkj.58.2023.09.14.12.16.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:16:52 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:04 -0400
Message-Id: <20230914191635.39805-9-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v3 08/39] dm vdo: add basic hash map data
 structures
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Matthew Sakai <msakai@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

Add two hash maps, one keyed by integers, the other by pointers, and
also a priority heap. The integer map is used for locking of logical
and physical addresses. The pointer map is used for managing
concurrent writes of the same data, ensuring that those writes are
deduplicated. The priority heap is used to minimize the search time
for free blocks.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/int-map.c        | 710 +++++++++++++++++++++++++++++
 drivers/md/dm-vdo/int-map.h        |  40 ++
 drivers/md/dm-vdo/pointer-map.c    | 691 ++++++++++++++++++++++++++++
 drivers/md/dm-vdo/pointer-map.h    |  81 ++++
 drivers/md/dm-vdo/priority-table.c | 226 +++++++++
 drivers/md/dm-vdo/priority-table.h |  48 ++
 6 files changed, 1796 insertions(+)
 create mode 100644 drivers/md/dm-vdo/int-map.c
 create mode 100644 drivers/md/dm-vdo/int-map.h
 create mode 100644 drivers/md/dm-vdo/pointer-map.c
 create mode 100644 drivers/md/dm-vdo/pointer-map.h
 create mode 100644 drivers/md/dm-vdo/priority-table.c
 create mode 100644 drivers/md/dm-vdo/priority-table.h

diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
new file mode 100644
index 000000000000..76431ea64f63
--- /dev/null
+++ b/drivers/md/dm-vdo/int-map.c
@@ -0,0 +1,710 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+/**
+ * DOC:
+ *
+ * Hash table implementation of a map from integers to pointers, implemented using the Hopscotch
+ * Hashing algorithm by Herlihy, Shavit, and Tzafrir (see
+ * http://en.wikipedia.org/wiki/Hopscotch_hashing). This implementation does not contain any of the
+ * locking/concurrency features of the algorithm, just the collision resolution scheme.
+ *
+ * Hopscotch Hashing is based on hashing with open addressing and linear probing. All the entries
+ * are stored in a fixed array of buckets, with no dynamic allocation for collisions. Unlike linear
+ * probing, all the entries that hash to a given bucket are stored within a fixed neighborhood
+ * starting at that bucket. Chaining is effectively represented as a bit vector relative to each
+ * bucket instead of as pointers or explicit offsets.
+ *
+ * When an empty bucket cannot be found within a given neighborhood, subsequent neighborhoods are
+ * searched, and one or more entries will "hop" into those neighborhoods. When this process works,
+ * an empty bucket will move into the desired neighborhood, allowing the entry to be added. When
+ * that process fails (typically when the buckets are around 90% full), the table must be resized
+ * and the all entries rehashed and added to the expanded table.
+ *
+ * Unlike linear probing, the number of buckets that must be searched in the worst case has a fixed
+ * upper bound (the size of the neighborhood). Those entries occupy a small number of memory cache
+ * lines, leading to improved use of the cache (fewer misses on both successful and unsuccessful
+ * searches). Hopscotch hashing outperforms linear probing at much higher load factors, so even
+ * with the increased memory burden for maintaining the hop vectors, less memory is needed to
+ * achieve that performance. Hopscotch is also immune to "contamination" from deleting entries
+ * since entries are genuinely removed instead of being replaced by a placeholder.
+ *
+ * The published description of the algorithm used a bit vector, but the paper alludes to an offset
+ * scheme which is used by this implementation. Since the entries in the neighborhood are within N
+ * entries of the hash bucket at the start of the neighborhood, a pair of small offset fields each
+ * log2(N) bits wide is all that's needed to maintain the hops as a linked list. In order to encode
+ * "no next hop" (i.e. NULL) as the natural initial value of zero, the offsets are biased by one
+ * (i.e. 0 => NULL, 1 => offset=0, 2 => offset=1, etc.) We can represent neighborhoods of up to 255
+ * entries with just 8+8=16 bits per entry. The hop list is sorted by hop offset so the first entry
+ * in the list is always the bucket closest to the start of the neighborhood.
+ *
+ * While individual accesses tend to be very fast, the table resize operations are very, very
+ * expensive. If an upper bound on the latency of adding an entry to the table is needed, we either
+ * need to ensure the table is pre-sized to be large enough so no resize is ever needed, or we'll
+ * need to develop an approach to incrementally resize the table.
+ */
+
+#include "int-map.h"
+
+#include <linux/minmax.h>
+
+#include "errors.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "permassert.h"
+
+enum {
+	DEFAULT_CAPACITY = 16, /* the number of neighborhoods in a new table */
+	NEIGHBORHOOD = 255,    /* the number of buckets in each neighborhood */
+	MAX_PROBES = 1024,     /* limit on the number of probes for a free bucket */
+	NULL_HOP_OFFSET = 0,   /* the hop offset value terminating the hop list */
+	DEFAULT_LOAD = 75      /* a compromise between memory use and performance */
+};
+
+/**
+ * struct bucket - hash bucket
+ *
+ * Buckets are packed together to reduce memory usage and improve cache efficiency. It would be
+ * tempting to encode the hop offsets separately and maintain alignment of key/value pairs, but
+ * it's crucial to keep the hop fields near the buckets that they use them so they'll tend to share
+ * cache lines.
+ */
+struct __packed bucket {
+	/**
+	 * @first_hop: The biased offset of the first entry in the hop list of the neighborhood
+	 *             that hashes to this bucket.
+	 */
+	u8 first_hop;
+	/** @next_hop: The biased offset of the next bucket in the hop list. */
+	u8 next_hop;
+	/** @key: The key stored in this bucket. */
+	u64 key;
+	/** @value: The value stored in this bucket (NULL if empty). */
+	void *value;
+};
+
+/**
+ * struct int_map - The concrete definition of the opaque int_map type.
+ *
+ * To avoid having to wrap the neighborhoods of the last entries back around to the start of the
+ * bucket array, we allocate a few more buckets at the end of the array instead, which is why
+ * capacity and bucket_count are different.
+ */
+struct int_map {
+	/** @size: The number of entries stored in the map. */
+	size_t size;
+	/** @capacity: The number of neighborhoods in the map. */
+	size_t capacity;
+	/* @bucket_count: The number of buckets in the bucket array. */
+	size_t bucket_count;
+	/** @buckets: The array of hash buckets. */
+	struct bucket *buckets;
+};
+
+/**
+ * mix() - The Google CityHash 16-byte hash mixing function.
+ * @input1: The first input value.
+ * @input2: The second input value.
+ *
+ * Return: A hash of the two inputs.
+ */
+static u64 mix(u64 input1, u64 input2)
+{
+	static const u64 CITY_MULTIPLIER = 0x9ddfea08eb382d69ULL;
+	u64 hash = (input1 ^ input2);
+
+	hash *= CITY_MULTIPLIER;
+	hash ^= (hash >> 47);
+	hash ^= input2;
+	hash *= CITY_MULTIPLIER;
+	hash ^= (hash >> 47);
+	hash *= CITY_MULTIPLIER;
+	return hash;
+}
+
+/**
+ * hash_key() - Calculate a 64-bit non-cryptographic hash value for the provided 64-bit integer
+ *              key.
+ * @key: The mapping key.
+ *
+ * The implementation is based on Google's CityHash, only handling the specific case of an 8-byte
+ * input.
+ *
+ * Return: The hash of the mapping key.
+ */
+static u64 hash_key(u64 key)
+{
+	/*
+	 * Aliasing restrictions forbid us from casting pointer types, so use a union to convert a
+	 * single u64 to two u32 values.
+	 */
+	union {
+		u64 u64;
+		u32 u32[2];
+	} pun = {.u64 = key};
+
+	return mix(sizeof(key) + (((u64) pun.u32[0]) << 3), pun.u32[1]);
+}
+
+/**
+ * allocate_buckets() - Initialize an int_map.
+ * @map: The map to initialize.
+ * @capacity: The initial capacity of the map.
+ *
+ * Return: UDS_SUCCESS or an error code.
+ */
+static int allocate_buckets(struct int_map *map, size_t capacity)
+{
+	map->size = 0;
+	map->capacity = capacity;
+
+	/*
+	 * Allocate NEIGHBORHOOD - 1 extra buckets so the last bucket can have a full neighborhood
+	 * without have to wrap back around to element zero.
+	 */
+	map->bucket_count = capacity + (NEIGHBORHOOD - 1);
+	return UDS_ALLOCATE(map->bucket_count, struct bucket,
+			    "struct int_map buckets", &map->buckets);
+}
+
+/**
+ * vdo_make_int_map() - Allocate and initialize an int_map.
+ * @initial_capacity: The number of entries the map should initially be capable of holding (zero
+ *                    tells the map to use its own small default).
+ * @initial_load: The load factor of the map, expressed as an integer percentage (typically in the
+ *                range 50 to 90, with zero telling the map to use its own default).
+ * @map_ptr: Output, a pointer to hold the new int_map.
+ *
+ * Return: UDS_SUCCESS or an error code.
+ */
+int vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct int_map **map_ptr)
+{
+	struct int_map *map;
+	int result;
+	size_t capacity;
+
+	/* Use the default initial load if the caller did not specify one. */
+	if (initial_load == 0)
+		initial_load = DEFAULT_LOAD;
+	if (initial_load > 100)
+		return UDS_INVALID_ARGUMENT;
+
+	result = UDS_ALLOCATE(1, struct int_map, "struct int_map", &map);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/* Use the default capacity if the caller did not specify one. */
+	capacity = (initial_capacity > 0) ? initial_capacity : DEFAULT_CAPACITY;
+
+	/*
+	 * Scale up the capacity by the specified initial load factor. (i.e to hold 1000 entries at
+	 * 80% load we need a capacity of 1250)
+	 */
+	capacity = capacity * 100 / initial_load;
+
+	result = allocate_buckets(map, capacity);
+	if (result != UDS_SUCCESS) {
+		vdo_free_int_map(UDS_FORGET(map));
+		return result;
+	}
+
+	*map_ptr = map;
+	return UDS_SUCCESS;
+}
+
+/**
+ * vdo_free_int_map() - Free an int_map.
+ * @map: The int_map to free.
+ *
+ * NOTE: The map does not own the pointer values stored in the map and they are not freed by this
+ * call.
+ */
+void vdo_free_int_map(struct int_map *map)
+{
+	if (map == NULL)
+		return;
+
+	UDS_FREE(UDS_FORGET(map->buckets));
+	UDS_FREE(UDS_FORGET(map));
+}
+
+/**
+ * vdo_int_map_size() - Get the number of entries stored in an int_map.
+ * @map: The int_map to query.
+ *
+ * Return: The number of entries in the map.
+ */
+size_t vdo_int_map_size(const struct int_map *map)
+{
+	return map->size;
+}
+
+/**
+ * dereference_hop() - Convert a biased hop offset within a neighborhood to a pointer to the bucket
+ *                     it references.
+ * @neighborhood: The first bucket in the neighborhood.
+ * @hop_offset: The biased hop offset to the desired bucket.
+ *
+ * Return: NULL if hop_offset is zero, otherwise a pointer to the bucket in the neighborhood at
+ *         hop_offset - 1.
+ */
+static struct bucket *dereference_hop(struct bucket *neighborhood, unsigned int hop_offset)
+{
+	if (hop_offset == NULL_HOP_OFFSET)
+		return NULL;
+
+	STATIC_ASSERT(NULL_HOP_OFFSET == 0);
+	return &neighborhood[hop_offset - 1];
+}
+
+/**
+ * insert_in_hop_list() - Add a bucket into the hop list for the neighborhood.
+ * @neighborhood: The first bucket in the neighborhood.
+ * @new_bucket: The bucket to add to the hop list.
+ *
+ * The bucket is inserted it into the list so the hop list remains sorted by hop offset.
+ */
+static void insert_in_hop_list(struct bucket *neighborhood, struct bucket *new_bucket)
+{
+	/* Zero indicates a NULL hop offset, so bias the hop offset by one. */
+	int hop_offset = 1 + (new_bucket - neighborhood);
+
+	/* Handle the special case of adding a bucket at the start of the list. */
+	int next_hop = neighborhood->first_hop;
+
+	if ((next_hop == NULL_HOP_OFFSET) || (next_hop > hop_offset)) {
+		new_bucket->next_hop = next_hop;
+		neighborhood->first_hop = hop_offset;
+		return;
+	}
+
+	/* Search the hop list for the insertion point that maintains the sort order. */
+	for (;;) {
+		struct bucket *bucket = dereference_hop(neighborhood, next_hop);
+
+		next_hop = bucket->next_hop;
+
+		if ((next_hop == NULL_HOP_OFFSET) || (next_hop > hop_offset)) {
+			new_bucket->next_hop = next_hop;
+			bucket->next_hop = hop_offset;
+			return;
+		}
+	}
+}
+
+/**
+ * select_bucket() - Select and return the hash bucket for a given search key.
+ * @map: The map to search.
+ * @key: The mapping key.
+ */
+static struct bucket *select_bucket(const struct int_map *map, u64 key)
+{
+	/*
+	 * Calculate a good hash value for the provided key. We want exactly 32 bits, so mask the
+	 * result.
+	 */
+	u64 hash = hash_key(key) & 0xFFFFFFFF;
+
+	/*
+	 * Scale the 32-bit hash to a bucket index by treating it as a binary fraction and
+	 * multiplying that by the capacity. If the hash is uniformly distributed over [0 ..
+	 * 2^32-1], then (hash * capacity / 2^32) should be uniformly distributed over [0 ..
+	 * capacity-1]. The multiply and shift is much faster than a divide (modulus) on X86 CPUs.
+	 */
+	return &map->buckets[(hash * map->capacity) >> 32];
+}
+
+/**
+ * search_hop_list() - Search the hop list associated with given hash bucket for a given search
+ *                     key.
+ * @map: The map being searched.
+ * @bucket: The map bucket to search for the key.
+ * @key: The mapping key.
+ * @previous_ptr: Output. if not NULL, a pointer in which to store the bucket in the list preceding
+ *                the one that had the matching key
+ *
+ * If the key is found, returns a pointer to the entry (bucket or collision), otherwise returns
+ * NULL.
+ *
+ * Return: An entry that matches the key, or NULL if not found.
+ */
+static struct bucket *search_hop_list(struct int_map *map __always_unused,
+				      struct bucket *bucket,
+				      u64 key,
+				      struct bucket **previous_ptr)
+{
+	struct bucket *previous = NULL;
+	unsigned int next_hop = bucket->first_hop;
+
+	while (next_hop != NULL_HOP_OFFSET) {
+		/*
+		 * Check the neighboring bucket indexed by the offset for the
+		 * desired key.
+		 */
+		struct bucket *entry = dereference_hop(bucket, next_hop);
+
+		if ((key == entry->key) && (entry->value != NULL)) {
+			if (previous_ptr != NULL)
+				*previous_ptr = previous;
+			return entry;
+		}
+		next_hop = entry->next_hop;
+		previous = entry;
+	}
+	return NULL;
+}
+
+/**
+ * vdo_int_map_get() - Retrieve the value associated with a given key from the int_map.
+ * @map: The int_map to query.
+ * @key: The key to look up.
+ *
+ * Return: The value associated with the given key, or NULL if the key is not mapped to any value.
+ */
+void *vdo_int_map_get(struct int_map *map, u64 key)
+{
+	struct bucket *match = search_hop_list(map, select_bucket(map, key), key, NULL);
+
+	return ((match != NULL) ? match->value : NULL);
+}
+
+/**
+ * resize_buckets() - Increase the number of hash buckets.
+ * @map: The map to resize.
+ *
+ * Resizes and rehashes all the existing entries, storing them in the new buckets.
+ *
+ * Return: UDS_SUCCESS or an error code.
+ */
+static int resize_buckets(struct int_map *map)
+{
+	int result;
+	size_t i;
+
+	/* Copy the top-level map data to the stack. */
+	struct int_map old_map = *map;
+
+	/* Re-initialize the map to be empty and 50% larger. */
+	size_t new_capacity = map->capacity / 2 * 3;
+
+	uds_log_info("%s: attempting resize from %zu to %zu, current size=%zu",
+		     __func__, map->capacity, new_capacity, map->size);
+	result = allocate_buckets(map, new_capacity);
+	if (result != UDS_SUCCESS) {
+		*map = old_map;
+		return result;
+	}
+
+	/* Populate the new hash table from the entries in the old bucket array. */
+	for (i = 0; i < old_map.bucket_count; i++) {
+		struct bucket *entry = &old_map.buckets[i];
+
+		if (entry->value == NULL)
+			continue;
+
+		result = vdo_int_map_put(map, entry->key, entry->value, true, NULL);
+		if (result != UDS_SUCCESS) {
+			/* Destroy the new partial map and restore the map from the stack. */
+			UDS_FREE(UDS_FORGET(map->buckets));
+			*map = old_map;
+			return result;
+		}
+	}
+
+	/* Destroy the old bucket array. */
+	UDS_FREE(UDS_FORGET(old_map.buckets));
+	return UDS_SUCCESS;
+}
+
+/**
+ * find_empty_bucket() - Probe the bucket array starting at the given bucket for the next empty
+ *                       bucket, returning a pointer to it.
+ * @map: The map containing the buckets to search.
+ * @bucket: The bucket at which to start probing.
+ * @max_probes: The maximum number of buckets to search.
+ *
+ * NULL will be returned if the search reaches the end of the bucket array or if the number of
+ * linear probes exceeds a specified limit.
+ *
+ * Return: The next empty bucket, or NULL if the search failed.
+ */
+static struct bucket *
+find_empty_bucket(struct int_map *map, struct bucket *bucket, unsigned int max_probes)
+{
+	/*
+	 * Limit the search to either the nearer of the end of the bucket array or a fixed distance
+	 * beyond the initial bucket.
+	 */
+	ptrdiff_t remaining = &map->buckets[map->bucket_count] - bucket;
+	struct bucket *sentinel = &bucket[min_t(ptrdiff_t, remaining, max_probes)];
+	struct bucket *entry;
+
+	for (entry = bucket; entry < sentinel; entry++)
+		if (entry->value == NULL)
+			return entry;
+	return NULL;
+}
+
+/**
+ * move_empty_bucket() - Move an empty bucket closer to the start of the bucket array.
+ * @map: The map containing the bucket.
+ * @hole: The empty bucket to fill with an entry that precedes it in one of its enclosing
+ *        neighborhoods.
+ *
+ * This searches the neighborhoods that contain the empty bucket for a non-empty bucket closer to
+ * the start of the array. If such a bucket is found, this swaps the two buckets by moving the
+ * entry to the empty bucket.
+ *
+ * Return: The bucket that was vacated by moving its entry to the provided hole, or NULL if no
+ *         entry could be moved.
+ */
+static struct bucket *move_empty_bucket(struct int_map *map __always_unused, struct bucket *hole)
+{
+	/*
+	 * Examine every neighborhood that the empty bucket is part of, starting with the one in
+	 * which it is the last bucket. No boundary check is needed for the negative array
+	 * arithmetic since this function is only called when hole is at least NEIGHBORHOOD cells
+	 * deeper into the array than a valid bucket.
+	 */
+	struct bucket *bucket;
+
+	for (bucket = &hole[1 - NEIGHBORHOOD]; bucket < hole; bucket++) {
+		/*
+		 * Find the entry that is nearest to the bucket, which means it will be nearest to
+		 * the hash bucket whose neighborhood is full.
+		 */
+		struct bucket *new_hole = dereference_hop(bucket, bucket->first_hop);
+
+		if (new_hole == NULL)
+			/*
+			 * There are no buckets in this neighborhood that are in use by this one
+			 * (they must all be owned by overlapping neighborhoods).
+			 */
+			continue;
+
+		/*
+		 * Skip this bucket if its first entry is actually further away than the hole that
+		 * we're already trying to fill.
+		 */
+		if (hole < new_hole)
+			continue;
+
+		/*
+		 * We've found an entry in this neighborhood that we can "hop" further away, moving
+		 * the hole closer to the hash bucket, if not all the way into its neighborhood.
+		 */
+
+		/*
+		 * The entry that will be the new hole is the first bucket in the list, so setting
+		 * first_hop is all that's needed remove it from the list.
+		 */
+		bucket->first_hop = new_hole->next_hop;
+		new_hole->next_hop = NULL_HOP_OFFSET;
+
+		/* Move the entry into the original hole. */
+		hole->key = new_hole->key;
+		hole->value = new_hole->value;
+		new_hole->value = NULL;
+
+		/* Insert the filled hole into the hop list for the neighborhood. */
+		insert_in_hop_list(bucket, hole);
+		return new_hole;
+	}
+
+	/* We couldn't find an entry to relocate to the hole. */
+	return NULL;
+}
+
+/**
+ * update_mapping() - Find and update any existing mapping for a given key, returning the value
+ *                    associated with the key in the provided pointer.
+ * @map: The int_map to attempt to modify.
+ * @neighborhood: The first bucket in the neighborhood that would contain the search key
+ * @key: The key with which to associate the new value.
+ * @new_value: The value to be associated with the key.
+ * @update: Whether to overwrite an existing value.
+ * @old_value_ptr: a pointer in which to store the old value (unmodified if no mapping was found)
+ *
+ * Return: true if the map contains a mapping for the key, false if it does not.
+ */
+static bool update_mapping(struct int_map *map,
+			   struct bucket *neighborhood,
+			   u64 key,
+			   void *new_value,
+			   bool update,
+			   void **old_value_ptr)
+{
+	struct bucket *bucket = search_hop_list(map, neighborhood, key, NULL);
+
+	if (bucket == NULL)
+		/* There is no bucket containing the key in the neighborhood. */
+		return false;
+
+	/*
+	 * Return the value of the current mapping (if desired) and update the mapping with the new
+	 * value (if desired).
+	 */
+	if (old_value_ptr != NULL)
+		*old_value_ptr = bucket->value;
+	if (update)
+		bucket->value = new_value;
+	return true;
+}
+
+/**
+ * find_or_make_vacancy() - Find an empty bucket.
+ * @map: The int_map to search or modify.
+ * @neighborhood: The first bucket in the neighborhood in which an empty bucket is needed for a new
+ *                mapping.
+ *
+ * Find an empty bucket in a specified neighborhood for a new mapping or attempt to re-arrange
+ * mappings so there is such a bucket. This operation may fail (returning NULL) if an empty bucket
+ * is not available or could not be relocated to the neighborhood.
+ *
+ * Return: a pointer to an empty bucket in the desired neighborhood, or NULL if a vacancy could not
+ *         be found or arranged.
+ */
+static struct bucket *find_or_make_vacancy(struct int_map *map, struct bucket *neighborhood)
+{
+	/* Probe within and beyond the neighborhood for the first empty bucket. */
+	struct bucket *hole = find_empty_bucket(map, neighborhood, MAX_PROBES);
+
+	/*
+	 * Keep trying until the empty bucket is in the bucket's neighborhood or we are unable to
+	 * move it any closer by swapping it with a filled bucket.
+	 */
+	while (hole != NULL) {
+		int distance = hole - neighborhood;
+
+		if (distance < NEIGHBORHOOD)
+			/*
+			 * We've found or relocated an empty bucket close enough to the initial
+			 * hash bucket to be referenced by its hop vector.
+			 */
+			return hole;
+
+		/*
+		 * The nearest empty bucket isn't within the neighborhood that must contain the new
+		 * entry, so try to swap it with bucket that is closer.
+		 */
+		hole = move_empty_bucket(map, hole);
+	}
+
+	return NULL;
+}
+
+/**
+ * vdo_int_map_put() - Try to associate a value with an integer.
+ * @map: The int_map to attempt to modify.
+ * @key: The key with which to associate the new value.
+ * @new_value: The value to be associated with the key.
+ * @update: Whether to overwrite an existing value.
+ * @old_value_ptr: A pointer in which to store either the old value (if the key was already mapped)
+ *                 or NULL if the map did not contain the key; NULL may be provided if the caller
+ *                 does not need to know the old value
+ *
+ * Try to associate a value (a pointer) with an integer in an int_map. If the map already contains
+ * a mapping for the provided key, the old value is only replaced with the specified value if
+ * update is true. In either case the old value is returned. If the map does not already contain a
+ * value for the specified key, the new value is added regardless of the value of update.
+ *
+ * Return: UDS_SUCCESS or an error code.
+ */
+int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update, void **old_value_ptr)
+{
+	struct bucket *neighborhood, *bucket;
+
+	if (new_value == NULL)
+		return UDS_INVALID_ARGUMENT;
+
+	/*
+	 * Select the bucket at the start of the neighborhood that must contain any entry for the
+	 * provided key.
+	 */
+	neighborhood = select_bucket(map, key);
+
+	/*
+	 * Check whether the neighborhood already contains an entry for the key, in which case we
+	 * optionally update it, returning the old value.
+	 */
+	if (update_mapping(map, neighborhood, key, new_value, update, old_value_ptr))
+		return UDS_SUCCESS;
+
+	/*
+	 * Find an empty bucket in the desired neighborhood for the new entry or re-arrange entries
+	 * in the map so there is such a bucket. This operation will usually succeed; the loop body
+	 * will only be executed on the rare occasions that we have to resize the map.
+	 */
+	while ((bucket = find_or_make_vacancy(map, neighborhood)) == NULL) {
+		int result;
+
+		/*
+		 * There is no empty bucket in which to put the new entry in the current map, so
+		 * we're forced to allocate a new bucket array with a larger capacity, re-hash all
+		 * the entries into those buckets, and try again (a very expensive operation for
+		 * large maps).
+		 */
+		result = resize_buckets(map);
+		if (result != UDS_SUCCESS)
+			return result;
+
+		/*
+		 * Resizing the map invalidates all pointers to buckets, so recalculate the
+		 * neighborhood pointer.
+		 */
+		neighborhood = select_bucket(map, key);
+	}
+
+	/* Put the new entry in the empty bucket, adding it to the neighborhood. */
+	bucket->key = key;
+	bucket->value = new_value;
+	insert_in_hop_list(neighborhood, bucket);
+	map->size += 1;
+
+	/* There was no existing entry, so there was no old value to be returned. */
+	if (old_value_ptr != NULL)
+		*old_value_ptr = NULL;
+	return UDS_SUCCESS;
+}
+
+/**
+ * vdo_int_map_remove() - Remove the mapping for a given key from the int_map.
+ * @map: The int_map from which to remove the mapping.
+ * @key: The key whose mapping is to be removed.
+ *
+ * Return: the value that was associated with the key, or NULL if it was not mapped.
+ */
+void *vdo_int_map_remove(struct int_map *map, u64 key)
+{
+	void *value;
+
+	/* Select the bucket to search and search it for an existing entry. */
+	struct bucket *bucket = select_bucket(map, key);
+	struct bucket *previous;
+	struct bucket *victim = search_hop_list(map, bucket, key, &previous);
+
+	if (victim == NULL)
+		/* There is no matching entry to remove. */
+		return NULL;
+
+	/*
+	 * We found an entry to remove. Save the mapped value to return later and empty the bucket.
+	 */
+	map->size -= 1;
+	value = victim->value;
+	victim->value = NULL;
+	victim->key = 0;
+
+	/* The victim bucket is now empty, but it still needs to be spliced out of the hop list. */
+	if (previous == NULL)
+		/* The victim is the head of the list, so swing first_hop. */
+		bucket->first_hop = victim->next_hop;
+	else
+		previous->next_hop = victim->next_hop;
+	victim->next_hop = NULL_HOP_OFFSET;
+
+	return value;
+}
diff --git a/drivers/md/dm-vdo/int-map.h b/drivers/md/dm-vdo/int-map.h
new file mode 100644
index 000000000000..e85f12b30edc
--- /dev/null
+++ b/drivers/md/dm-vdo/int-map.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_INT_MAP_H
+#define VDO_INT_MAP_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/**
+ * DOC: int_map
+ *
+ * An int_map associates pointers (void *) with integer keys (u64). NULL pointer values are
+ * not supported.
+ *
+ * The map is implemented as hash table, which should provide constant-time insert, query, and
+ * remove operations, although the insert may occasionally grow the table, which is linear in the
+ * number of entries in the map. The table will grow as needed to hold new entries, but will not
+ * shrink as entries are removed.
+ */
+
+struct int_map;
+
+int __must_check
+vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct int_map **map_ptr);
+
+void vdo_free_int_map(struct int_map *map);
+
+size_t vdo_int_map_size(const struct int_map *map);
+
+void *vdo_int_map_get(struct int_map *map, u64 key);
+
+int __must_check
+vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update, void **old_value_ptr);
+
+void *vdo_int_map_remove(struct int_map *map, u64 key);
+
+#endif /* VDO_INT_MAP_H */
diff --git a/drivers/md/dm-vdo/pointer-map.c b/drivers/md/dm-vdo/pointer-map.c
new file mode 100644
index 000000000000..21ccb40c73d2
--- /dev/null
+++ b/drivers/md/dm-vdo/pointer-map.c
@@ -0,0 +1,691 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+/**
+ * DOC:
+ *
+ * Hash table implementation of a map from integers to pointers, implemented using the Hopscotch
+ * Hashing algorithm by Herlihy, Shavit, and Tzafrir (see
+ * http://en.wikipedia.org/wiki/Hopscotch_hashing). This implementation does not contain any of the
+ * locking/concurrency features of the algorithm, just the collision resolution scheme.
+ *
+ * Hopscotch Hashing is based on hashing with open addressing and linear probing. All the entries
+ * are stored in a fixed array of buckets, with no dynamic allocation for collisions. Unlike linear
+ * probing, all the entries that hash to a given bucket are stored within a fixed neighborhood
+ * starting at that bucket. Chaining is effectively represented as a bit vector relative to each
+ * bucket instead of as pointers or explicit offsets.
+ *
+ * When an empty bucket cannot be found within a given neighborhood, subsequent neighborhoods are
+ * searched, and one or more entries will "hop" into those neighborhoods. When this process works,
+ * an empty bucket will move into the desired neighborhood, allowing the entry to be added. When
+ * that process fails (typically when the buckets are around 90% full), the table must be resized
+ * and the all entries rehashed and added to the expanded table.
+ *
+ * Unlike linear probing, the number of buckets that must be searched in the worst case has a fixed
+ * upper bound (the size of the neighborhood). Those entries occupy a small number of memory cache
+ * lines, leading to improved use of the cache (fewer misses on both successful and unsuccessful
+ * searches). Hopscotch hashing outperforms linear probing at much higher load factors, so even
+ * with the increased memory burden for maintaining the hop vectors, less memory is needed to
+ * achieve that performance. Hopscotch is also immune to "contamination" from deleting entries
+ * since entries are genuinely removed instead of being replaced by a placeholder.
+ *
+ * The published description of the algorithm used a bit vector, but the paper alludes to an offset
+ * scheme which is used by this implementation. Since the entries in the neighborhood are within N
+ * entries of the hash bucket at the start of the neighborhood, a pair of small offset fields each
+ * log2(N) bits wide is all that's needed to maintain the hops as a linked list. In order to encode
+ * "no next hop" (i.e. NULL) as the natural initial value of zero, the offsets are biased by one
+ * (i.e. 0 => NULL, 1 => offset=0, 2 => offset=1, etc.) We can represent neighborhoods of up to 255
+ * entries with just 8+8=16 bits per entry. The hop list is sorted by hop offset so the first entry
+ * in the list is always the bucket closest to the start of the neighborhood.
+ *
+ * While individual accesses tend to be very fast, the table resize operations are very, very
+ * expensive. If an upper bound on the latency of adding an entry to the table is needed, we either
+ * need to ensure the table is pre-sized to be large enough so no resize is ever needed, or we'll
+ * need to develop an approach to incrementally resize the table.
+ */
+
+#include "pointer-map.h"
+
+#include <linux/minmax.h>
+
+#include "errors.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "permassert.h"
+
+enum {
+	DEFAULT_CAPACITY = 16, /* the number of neighborhoods in a new table */
+	NEIGHBORHOOD = 255, /* the number of buckets in each neighborhood */
+	MAX_PROBES = 1024, /* limit on the number of probes for a free bucket */
+	NULL_HOP_OFFSET = 0, /* the hop offset value terminating the hop list */
+	DEFAULT_LOAD = 75 /* a compromise between memory use and performance */
+};
+
+/**
+ * struct bucket - Hash buckets.
+ *
+ * Buckets are packed together to reduce memory usage and improve cache efficiency. It would be
+ * tempting to encode the hop offsets separately and maintain alignment of key/value pairs, but
+ * it's crucial to keep the hop fields near the buckets that they use them so they'll tend to share
+ * cache lines.
+ */
+struct __packed bucket {
+	/**
+	 * @first_hop: The biased offset of the first entry in the hop list of the neighborhood
+	 * that hashes to this bucket.
+	 */
+	u8 first_hop;
+	/** @next_hop: the biased offset of the next bucket in the hop list. */
+	u8 next_hop;
+	/** @key: The key stored in this bucket. */
+	const void *key;
+	/** @value: The value stored in this bucket (NULL if empty). */
+	void *value;
+};
+
+/**
+ * struct pointer_map - The concrete definition of the opaque pointer_map type.
+ *
+ * To avoid having to wrap the neighborhoods of the last entries back around to the start of the
+ * bucket array, we allocate a few more buckets at the end of the array instead, which is why
+ * capacity and bucket_count are different.
+ */
+struct pointer_map {
+	/** @size: The number of entries stored in the map. */
+	size_t size;
+	/** @capacity: The number of neighborhoods in the map. */
+	size_t capacity;
+	/** @bucket_count: The number of buckets in the bucket array. */
+	size_t bucket_count;
+	/** @buckets: The array of hash buckets. */
+	struct bucket *buckets;
+	/** @comparator: The function for comparing keys for equality. */
+	pointer_key_comparator *comparator;
+	/** @hasher: The function for getting a hash code from a key. */
+	pointer_key_hasher *hasher;
+};
+
+/**
+ * allocate_buckets() - Initialize a pointer_map.
+ * @map: The map to initialize.
+ * @capacity: The initial capacity of the map.
+ *
+ * Return: UDS_SUCCESS or an error code.
+ */
+static int allocate_buckets(struct pointer_map *map, size_t capacity)
+{
+	map->size = 0;
+	map->capacity = capacity;
+
+	/*
+	 * Allocate NEIGHBORHOOD - 1 extra buckets so the last bucket can have a full neighborhood
+	 * without have to wrap back around to element zero.
+	 */
+	map->bucket_count = capacity + (NEIGHBORHOOD - 1);
+	return UDS_ALLOCATE(map->bucket_count,
+			    struct bucket,
+			    "pointer_map buckets",
+			    &map->buckets);
+}
+
+/**
+ * vdo_make_pointer_map() - Allocate and initialize a pointer_map.
+ * @initial_capacity: The number of entries the map should initially be capable of holding (zero
+ *                    tells the map to use its own small default).
+ * @initial_load: The load factor of the map, expressed as an integer percentage (typically in the
+ * range 50 to 90, with zero telling the map to use its own default).
+ * @comparator: The function to use to compare the referents of two pointer keys for equality.
+ * @hasher: The function to use obtain the hash code associated with each pointer key
+ * @map_ptr: A pointer to hold the new pointer_map.
+ *
+ * Return: UDS_SUCCESS or an error code.
+ */
+int vdo_make_pointer_map(size_t initial_capacity,
+			 unsigned int initial_load,
+			 pointer_key_comparator comparator,
+			 pointer_key_hasher hasher,
+			 struct pointer_map **map_ptr)
+{
+	int result;
+	struct pointer_map *map;
+	size_t capacity;
+
+	/* Use the default initial load if the caller did not specify one. */
+	if (initial_load == 0)
+		initial_load = DEFAULT_LOAD;
+	if (initial_load > 100)
+		return UDS_INVALID_ARGUMENT;
+
+	result = UDS_ALLOCATE(1, struct pointer_map, "pointer_map", &map);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	map->hasher = hasher;
+	map->comparator = comparator;
+
+	/* Use the default capacity if the caller did not specify one. */
+	capacity = (initial_capacity > 0) ? initial_capacity : DEFAULT_CAPACITY;
+
+	/*
+	 * Scale up the capacity by the specified initial load factor. (i.e to hold 1000 entries at
+	 * 80% load we need a capacity of 1250)
+	 */
+	capacity = capacity * 100 / initial_load;
+
+	result = allocate_buckets(map, capacity);
+	if (result != UDS_SUCCESS) {
+		vdo_free_pointer_map(UDS_FORGET(map));
+		return result;
+	}
+
+	*map_ptr = map;
+	return UDS_SUCCESS;
+}
+
+/**
+ * vdo_free_pointer_map() - Free a pointer_map.
+ * @map: The pointer_map to free.
+ *
+ * The map does not own the pointer keys and values stored in the map and they are not freed by
+ * this call.
+ */
+void vdo_free_pointer_map(struct pointer_map *map)
+{
+	if (map == NULL)
+		return;
+
+	UDS_FREE(UDS_FORGET(map->buckets));
+	UDS_FREE(UDS_FORGET(map));
+}
+
+/**
+ * vdo_pointer_map_size() - Get the number of entries stored in a pointer_map.
+ * @map: The pointer_map to query.
+ *
+ * Return: The number of entries in the map.
+ */
+size_t vdo_pointer_map_size(const struct pointer_map *map)
+{
+	return map->size;
+}
+
+/**
+ * dereference_hop() - Convert a biased hop offset within a neighborhood to a pointer to the bucket
+ *                     it references.
+ * @neighborhood: The first bucket in the neighborhood.
+ * @hop_offset: The biased hop offset to the desired bucket.
+ *
+ * Return: NULL if hop_offset is zero, otherwise a pointer to the bucket in the neighborhood at
+ *         hop_offset - 1.
+ */
+static struct bucket *dereference_hop(struct bucket *neighborhood, unsigned int hop_offset)
+{
+	if (hop_offset == NULL_HOP_OFFSET)
+		return NULL;
+
+	STATIC_ASSERT(NULL_HOP_OFFSET == 0);
+	return &neighborhood[hop_offset - 1];
+}
+
+/**
+ * insert_in_hop_list() - Add a bucket into the hop list for the neighborhood, inserting it into
+ *                        the list so the hop list remains sorted by hop offset.
+ * @neighborhood: The first bucket in the neighborhood.
+ * @new_bucket: The bucket to add to the hop list.
+ */
+static void insert_in_hop_list(struct bucket *neighborhood, struct bucket *new_bucket)
+{
+	/* Zero indicates a NULL hop offset, so bias the hop offset by one. */
+	int hop_offset = 1 + (new_bucket - neighborhood);
+
+	/* Handle the special case of adding a bucket at the start of the list. */
+	int next_hop = neighborhood->first_hop;
+
+	if ((next_hop == NULL_HOP_OFFSET) || (next_hop > hop_offset)) {
+		new_bucket->next_hop = next_hop;
+		neighborhood->first_hop = hop_offset;
+		return;
+	}
+
+	/* Search the hop list for the insertion point that maintains the sort order. */
+	for (;;) {
+		struct bucket *bucket = dereference_hop(neighborhood, next_hop);
+
+		next_hop = bucket->next_hop;
+
+		if ((next_hop == NULL_HOP_OFFSET) || (next_hop > hop_offset)) {
+			new_bucket->next_hop = next_hop;
+			bucket->next_hop = hop_offset;
+			return;
+		}
+	}
+}
+
+/**
+ * select_bucket() - Select and return the hash bucket for a given search key.
+ * @map: The map to search.
+ * @key: The mapping key.
+ */
+static struct bucket *select_bucket(const struct pointer_map *map, const void *key)
+{
+	/*
+	 * Scale the 32-bit hash to a bucket index by treating it as a binary fraction and
+	 * multiplying that by the capacity. If the hash is uniformly distributed over [0 ..
+	 * 2^32-1], then (hash * capacity / 2^32) should be uniformly distributed over [0 ..
+	 * capacity-1]. The multiply and shift is much faster than a divide (modulus) on X86 CPUs.
+	 */
+	u64 hash = map->hasher(key);
+
+	return &map->buckets[(hash * map->capacity) >> 32];
+}
+
+/**
+ * search_hop_list() - Search the hop list.
+ * @map: The map being searched.
+ * @bucket: The map bucket to search for the key.
+ * @key: The mapping key.
+ * @previous_ptr: if not NULL, a pointer in which to store the bucket in the list preceding the one
+ *                that had the matching key.
+ *
+ * Searches the hop list associated with given hash bucket for a given search key. If the key is
+ * found, returns a pointer to the entry (bucket or collision), otherwise returns NULL.
+ *
+ * Return: an entry that matches the key, or NULL if not found.
+ */
+static struct bucket *search_hop_list(struct pointer_map *map,
+				      struct bucket *bucket,
+				      const void *key,
+				      struct bucket **previous_ptr)
+{
+	struct bucket *previous = NULL;
+	unsigned int next_hop = bucket->first_hop;
+
+	while (next_hop != NULL_HOP_OFFSET) {
+		/* Check the neighboring bucket indexed by the offset for the desired key. */
+		struct bucket *entry = dereference_hop(bucket, next_hop);
+
+		if ((entry->value != NULL) && map->comparator(key, entry->key)) {
+			if (previous_ptr != NULL)
+				*previous_ptr = previous;
+			return entry;
+		}
+		next_hop = entry->next_hop;
+		previous = entry;
+	}
+	return NULL;
+}
+
+/**
+ * vdo_pointer_map_get() - Retrieve the value associated with a given key from the pointer_map.
+ * @map: The pointer_map to query.
+ * @key: The key to look up (may be NULL if the comparator and hasher functions support it).
+ *
+ * Return: the value associated with the given key, or NULL if the key is not mapped to any value.
+ */
+void *vdo_pointer_map_get(struct pointer_map *map, const void *key)
+{
+	struct bucket *match = search_hop_list(map, select_bucket(map, key), key, NULL);
+
+	return ((match != NULL) ? match->value : NULL);
+}
+
+/**
+ * resize_buckets() - Increase the number of hash buckets and rehash all the existing entries,
+ *                    storing them in the new buckets.
+ * @map: The map to resize.
+ */
+static int resize_buckets(struct pointer_map *map)
+{
+	int result;
+	size_t i;
+
+	/* Copy the top-level map data to the stack. */
+	struct pointer_map old_map = *map;
+
+	/* Re-initialize the map to be empty and 50% larger. */
+	size_t new_capacity = map->capacity / 2 * 3;
+
+	uds_log_info("%s: attempting resize from %zu to %zu, current size=%zu",
+		     __func__,
+		     map->capacity,
+		     new_capacity,
+		     map->size);
+	result = allocate_buckets(map, new_capacity);
+	if (result != UDS_SUCCESS) {
+		*map = old_map;
+		return result;
+	}
+
+	/* Populate the new hash table from the entries in the old bucket array. */
+	for (i = 0; i < old_map.bucket_count; i++) {
+		struct bucket *entry = &old_map.buckets[i];
+
+		if (entry->value == NULL)
+			continue;
+
+		result = vdo_pointer_map_put(map, entry->key, entry->value, true, NULL);
+		if (result != UDS_SUCCESS) {
+			/* Destroy the new partial map and restore the map from the stack. */
+			UDS_FREE(UDS_FORGET(map->buckets));
+			*map = old_map;
+			return result;
+		}
+	}
+
+	/* Destroy the old bucket array. */
+	UDS_FREE(UDS_FORGET(old_map.buckets));
+	return UDS_SUCCESS;
+}
+
+/**
+ * find_empty_bucket() - Probe the bucket array starting at the given bucket for the next empty
+ *                       bucket, returning a pointer to it.
+ * @map: The map containing the buckets to search.
+ * @bucket: The bucket at which to start probing.
+ * @max_probes: The maximum number of buckets to search.
+ *
+ * NULL will be returned if the search reaches the end of the bucket array or if the number of
+ * linear probes exceeds a specified limit.
+ *
+ * Return: The next empty bucket, or NULL if the search failed.
+ */
+static struct bucket *
+find_empty_bucket(struct pointer_map *map, struct bucket *bucket, unsigned int max_probes)
+{
+	/*
+	 * Limit the search to either the nearer of the end of the bucket array or a fixed distance
+	 * beyond the initial bucket.
+	 */
+	ptrdiff_t remaining = &map->buckets[map->bucket_count] - bucket;
+	struct bucket *sentinel = &bucket[min_t(ptrdiff_t, remaining, max_probes)];
+	struct bucket *entry;
+
+	for (entry = bucket; entry < sentinel; entry++)
+		if (entry->value == NULL)
+			return entry;
+	return NULL;
+}
+
+/**
+ * move_empty_bucket() - Move an empty bucket closer to the start of the bucket array.
+ * @map: The map containing the bucket.
+
+ * @hole: The empty bucket to fill with an entry that precedes it in one of its enclosing
+ *        neighborhoods.
+ *
+ * This searches the neighborhoods that contain the empty bucket for a non-empty bucket closer to
+ * the start of the array. If such a bucket is found, this swaps the two buckets by moving the
+ * entry to the empty bucket.
+ *
+ * Return: The bucket that was vacated by moving its entry to the provided hole, or NULL if no
+ *         entry could be moved.
+ */
+static struct bucket *
+move_empty_bucket(struct pointer_map *map __always_unused, struct bucket *hole)
+{
+	/*
+	 * Examine every neighborhood that the empty bucket is part of, starting with the one in
+	 * which it is the last bucket. No boundary check is needed for the negative array
+	 * arithmetic since this function is only called when hole is at least NEIGHBORHOOD cells
+	 * deeper into the array than a valid bucket.
+	 */
+	struct bucket *bucket;
+
+	for (bucket = &hole[1 - NEIGHBORHOOD]; bucket < hole; bucket++) {
+		/*
+		 * Find the entry that is nearest to the bucket, which means it will be nearest to
+		 * the hash bucket whose neighborhood is full.
+		 */
+		struct bucket *new_hole = dereference_hop(bucket, bucket->first_hop);
+
+		if (new_hole == NULL)
+			/*
+			 * There are no buckets in this neighborhood that are in use by this one
+			 * (they must all be owned by overlapping neighborhoods).
+			 */
+			continue;
+
+		/*
+		 * Skip this bucket if its first entry is actually further away than the hole that
+		 * we're already trying to fill.
+		 */
+		if (hole < new_hole)
+			continue;
+
+		/*
+		 * We've found an entry in this neighborhood that we can "hop" further away, moving
+		 * the hole closer to the hash bucket, if not all the way into its neighborhood.
+		 */
+
+		/*
+		 * The entry that will be the new hole is the first bucket in the list, so setting
+		 * first_hop is all that's needed remove it from the list.
+		 */
+		bucket->first_hop = new_hole->next_hop;
+		new_hole->next_hop = NULL_HOP_OFFSET;
+
+		/* Move the entry into the original hole. */
+		hole->key = new_hole->key;
+		hole->value = new_hole->value;
+		new_hole->value = NULL;
+
+		/* Insert the filled hole into the hop list for the neighborhood. */
+		insert_in_hop_list(bucket, hole);
+		return new_hole;
+	}
+
+	/* We couldn't find an entry to relocate to the hole. */
+	return NULL;
+}
+
+/**
+ * update_mapping() - Find and update any existing mapping for a given key, returning the value
+ *                    associated with the key in the provided pointer.
+ * @map: The pointer_map to attempt to modify.
+ * @neighborhood: The first bucket in the neighborhood that would contain the search key.
+ * @key: The key with which to associate the new value.
+ * @new_value: The value to be associated with the key.
+ * @update: Whether to overwrite an existing value.
+ * @old_value_ptr: A pointer in which to store the old value (unmodified if no mapping was found).
+ *
+ * Return: true if the map contains a mapping for the key, false if it does not.
+ */
+static bool update_mapping(struct pointer_map *map,
+			   struct bucket *neighborhood,
+			   const void *key,
+			   void *new_value,
+			   bool update,
+			   void **old_value_ptr)
+{
+	struct bucket *bucket = search_hop_list(map, neighborhood, key, NULL);
+
+	if (bucket == NULL)
+		/* There is no bucket containing the key in the neighborhood. */
+		return false;
+
+	/*
+	 * Return the value of the current mapping (if desired) and update the mapping with the new
+	 * value (if desired).
+	 */
+	if (old_value_ptr != NULL)
+		*old_value_ptr = bucket->value;
+	if (update) {
+		/*
+		 * We're dropping the old key pointer on the floor here, assuming it's a property
+		 * of the value or that it's otherwise safe to just forget.
+		 */
+		bucket->key = key;
+		bucket->value = new_value;
+	}
+	return true;
+}
+
+/**
+ * find_or_make_vacancy() - Find an empty bucket in a specified neighborhood for a new mapping or
+ *                          attempt to re-arrange mappings so there is such a bucket.
+ * @map: The pointer_map to search or modify.
+ * @neighborhood: The first bucket in the neighborhood in which an empty bucket is needed for a new
+ *                mapping.
+ *
+ * This operation may fail (returning NULL) if an empty bucket is not available or could not be
+ * relocated to the neighborhood.
+ *
+ * Return: A pointer to an empty bucket in the desired neighborhood, or NULL if a vacancy could not
+ *         be found or arranged.
+ */
+static struct bucket *find_or_make_vacancy(struct pointer_map *map, struct bucket *neighborhood)
+{
+	/* Probe within and beyond the neighborhood for the first empty bucket. */
+	struct bucket *hole = find_empty_bucket(map, neighborhood, MAX_PROBES);
+
+	/*
+	 * Keep trying until the empty bucket is in the bucket's neighborhood or we are unable to
+	 * move it any closer by swapping it with a filled bucket.
+	 */
+	while (hole != NULL) {
+		int distance = hole - neighborhood;
+
+		if (distance < NEIGHBORHOOD)
+			/*
+			 * We've found or relocated an empty bucket close enough to the initial
+			 * hash bucket to be referenced by its hop vector.
+			 */
+			return hole;
+
+		/*
+		 * The nearest empty bucket isn't within the neighborhood that must contain the new
+		 * entry, so try to swap it with bucket that is closer.
+		 */
+		hole = move_empty_bucket(map, hole);
+	}
+
+	return NULL;
+}
+
+/**
+ * vdo_pointer_map_put() - Try to associate a value (a pointer) with an integer in a pointer_map.
+ * @map: The pointer_map to attempt to modify.
+ * @key: The key with which to associate the new value (may be NULL if the comparator and hasher
+ *       functions support it).
+ * @new_value: The value to be associated with the key.
+ * @update: Whether to overwrite an existing value.
+ * @old_value_ptr: A pointer in which to store either the old value (if the key was already mapped)
+ *                 or NULL if the map did not contain the key; NULL may be provided if the caller
+ *                 does not need to know the old value.
+ *
+ * If the map already contains a mapping for the provided key, the old value is only replaced with
+ * the specified value if update is true. In either case the old value is returned. If the map does
+ * not already contain a value for the specified key, the new value is added regardless of the
+ * value of update.
+ *
+ * If the value stored in the map is updated, then the key stored in the map will also be updated
+ * with the key provided by this call. The old key will not be returned due to the memory
+ * management assumptions described in the interface header comment.
+ *
+ * Return: UDS_SUCCESS or an error code.
+ */
+int vdo_pointer_map_put(struct pointer_map *map,
+			const void *key,
+			void *new_value,
+			bool update,
+			void **old_value_ptr)
+{
+	struct bucket *neighborhood, *bucket;
+
+	if (new_value == NULL)
+		return UDS_INVALID_ARGUMENT;
+
+	/*
+	 * Select the bucket at the start of the neighborhood that must contain any entry for the
+	 * provided key.
+	 */
+	neighborhood = select_bucket(map, key);
+
+	/*
+	 * Check whether the neighborhood already contains an entry for the key, in which case we
+	 * optionally update it, returning the old value.
+	 */
+	if (update_mapping(map, neighborhood, key, new_value, update, old_value_ptr))
+		return UDS_SUCCESS;
+
+	/*
+	 * Find an empty bucket in the desired neighborhood for the new entry or re-arrange entries
+	 * in the map so there is such a bucket. This operation will usually succeed; the loop body
+	 * will only be executed on the rare occasions that we have to resize the map.
+	 */
+	while ((bucket = find_or_make_vacancy(map, neighborhood)) == NULL) {
+		/*
+		 * There is no empty bucket in which to put the new entry in the current map, so
+		 * we're forced to allocate a new bucket array with a larger capacity, re-hash all
+		 * the entries into those buckets, and try again (a very expensive operation for
+		 * large maps).
+		 */
+		int result = resize_buckets(map);
+
+		if (result != UDS_SUCCESS)
+			return result;
+
+		/*
+		 * Resizing the map invalidates all pointers to buckets, so
+		 * recalculate the neighborhood pointer.
+		 */
+		neighborhood = select_bucket(map, key);
+	}
+
+	/* Put the new entry in the empty bucket, adding it to the neighborhood. */
+	bucket->key = key;
+	bucket->value = new_value;
+	insert_in_hop_list(neighborhood, bucket);
+	map->size += 1;
+
+	/*
+	 * There was no existing entry, so there was no old value to be
+	 * returned.
+	 */
+	if (old_value_ptr != NULL)
+		*old_value_ptr = NULL;
+	return UDS_SUCCESS;
+}
+
+/**
+ * vdo_pointer_map_remove() - Remove the mapping for a given key from the pointer_map.
+ * @map: The pointer_map from which to remove the mapping.
+ * @key: The key whose mapping is to be removed (may be NULL if the comparator and hasher functions
+ *       support it).
+ *
+ * Return: the value that was associated with the key, or NULL if it was not mapped.
+ */
+void *vdo_pointer_map_remove(struct pointer_map *map, const void *key)
+{
+	void *value;
+
+	/* Select the bucket to search and search it for an existing entry. */
+	struct bucket *bucket = select_bucket(map, key);
+	struct bucket *previous;
+	struct bucket *victim = search_hop_list(map, bucket, key, &previous);
+
+	if (victim == NULL)
+		/* There is no matching entry to remove. */
+		return NULL;
+
+	/*
+	 * We found an entry to remove. Save the mapped value to return later and empty the bucket.
+	 */
+	map->size -= 1;
+	value = victim->value;
+	victim->value = NULL;
+	victim->key = 0;
+
+	/* The victim bucket is now empty, but it still needs to be spliced out of the hop list. */
+	if (previous == NULL)
+		/* The victim is the head of the list, so swing first_hop. */
+		bucket->first_hop = victim->next_hop;
+	else
+		previous->next_hop = victim->next_hop;
+	victim->next_hop = NULL_HOP_OFFSET;
+
+	return value;
+}
diff --git a/drivers/md/dm-vdo/pointer-map.h b/drivers/md/dm-vdo/pointer-map.h
new file mode 100644
index 000000000000..83465d01bfa7
--- /dev/null
+++ b/drivers/md/dm-vdo/pointer-map.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_POINTER_MAP_H
+#define VDO_POINTER_MAP_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/*
+ * A pointer_map associates pointer values (<code>void *</code>) with the data referenced by
+ * pointer keys (<code>void *</code>). <code>NULL</code> pointer values are not supported. A
+ * <code>NULL</code> key value is supported when the instance's key comparator and hasher functions
+ * support it.
+ *
+ * The map is implemented as hash table, which should provide constant-time insert, query, and
+ * remove operations, although the insert may occasionally grow the table, which is linear in the
+ * number of entries in the map. The table will grow as needed to hold new entries, but will not
+ * shrink as entries are removed.
+ *
+ * The key and value pointers passed to the map are retained and used by the map, but are not owned
+ * by the map. Freeing the map does not attempt to free the pointers. The client is entirely
+ * responsible for the memory management of the keys and values. The current interface and
+ * implementation assume that keys will be properties of the values, or that keys will not be
+ * memory managed, or that keys will not need to be freed as a result of being replaced when a key
+ * is re-mapped.
+ */
+
+struct pointer_map;
+
+/**
+ * typedef pointer_key_comparator - The prototype of functions that compare the referents of two
+ *                                  pointer keys for equality.
+ * @this_key: The first element to compare.
+ * @that_key: The second element to compare.
+ *
+ * If two keys are equal, then both keys must have the same the hash code associated with them by
+ * the hasher function defined below.
+ *
+ * Return: true if and only if the referents of the two key pointers are to be treated as the same
+ *         key by the map.
+ */
+typedef bool pointer_key_comparator(const void *this_key, const void *that_key);
+
+/**
+ * typedef pointer_key_hasher - The prototype of functions that get or calculate a hash code
+ *                              associated with the referent of pointer key.
+ * @key: The pointer key to hash.
+ *
+ * The hash code must be uniformly distributed over all u32 values. The hash code associated
+ * with a given key must not change while the key is in the map. If the comparator function says
+ * two keys are equal, then this function must return the same hash code for both keys. This
+ * function may be called many times for a key while an entry is stored for it in the map.
+ *
+ * Return: The hash code for the key.
+ */
+typedef u32 pointer_key_hasher(const void *key);
+
+int __must_check vdo_make_pointer_map(size_t initial_capacity,
+				      unsigned int initial_load,
+				      pointer_key_comparator comparator,
+				      pointer_key_hasher hasher,
+				      struct pointer_map **map_ptr);
+
+void vdo_free_pointer_map(struct pointer_map *map);
+
+size_t vdo_pointer_map_size(const struct pointer_map *map);
+
+void *vdo_pointer_map_get(struct pointer_map *map, const void *key);
+
+int __must_check vdo_pointer_map_put(struct pointer_map *map,
+				     const void *key,
+				     void *new_value,
+				     bool update,
+				     void **old_value_ptr);
+
+void *vdo_pointer_map_remove(struct pointer_map *map, const void *key);
+
+#endif /* VDO_POINTER_MAP_H */
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
new file mode 100644
index 000000000000..f8b81d6410c7
--- /dev/null
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "priority-table.h"
+
+#include <linux/log2.h>
+
+#include "errors.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+
+#include "status-codes.h"
+
+/* We use a single 64-bit search vector, so the maximum priority is 63 */
+enum {
+	MAX_PRIORITY = 63
+};
+
+/*
+ * All the entries with the same priority are queued in a circular list in a bucket for that
+ * priority. The table is essentially an array of buckets.
+ */
+struct bucket {
+	/*
+	 * The head of a queue of table entries, all having the same priority
+	 */
+	struct list_head queue;
+	/* The priority of all the entries in this bucket */
+	unsigned int priority;
+};
+
+/*
+ * A priority table is an array of buckets, indexed by priority. New entries are added to the end
+ * of the queue in the appropriate bucket. The dequeue operation finds the highest-priority
+ * non-empty bucket by searching a bit vector represented as a single 8-byte word, which is very
+ * fast with compiler and CPU support.
+ */
+struct priority_table {
+	/* The maximum priority of entries that may be stored in this table */
+	unsigned int max_priority;
+	/* A bit vector flagging all buckets that are currently non-empty */
+	u64 search_vector;
+	/* The array of all buckets, indexed by priority */
+	struct bucket buckets[];
+};
+
+/**
+ * vdo_make_priority_table() - Allocate and initialize a new priority_table.
+ * @max_priority: The maximum priority value for table entries.
+ * @table_ptr: A pointer to hold the new table.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+int vdo_make_priority_table(unsigned int max_priority, struct priority_table **table_ptr)
+{
+	struct priority_table *table;
+	int result;
+	unsigned int priority;
+
+	if (max_priority > MAX_PRIORITY)
+		return UDS_INVALID_ARGUMENT;
+
+	result = UDS_ALLOCATE_EXTENDED(struct priority_table, max_priority + 1,
+				       struct bucket, __func__, &table);
+	if (result != VDO_SUCCESS)
+		return result;
+
+	for (priority = 0; priority <= max_priority; priority++) {
+		struct bucket *bucket = &table->buckets[priority];
+
+		bucket->priority = priority;
+		INIT_LIST_HEAD(&bucket->queue);
+	}
+
+	table->max_priority = max_priority;
+	table->search_vector = 0;
+
+	*table_ptr = table;
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_free_priority_table() - Free a priority_table.
+ * @table: The table to free.
+ *
+ * The table does not own the entries stored in it and they are not freed by this call.
+ */
+void vdo_free_priority_table(struct priority_table *table)
+{
+	if (table == NULL)
+		return;
+
+	/*
+	 * Unlink the buckets from any entries still in the table so the entries won't be left with
+	 * dangling pointers to freed memory.
+	 */
+	vdo_reset_priority_table(table);
+
+	UDS_FREE(table);
+}
+
+/**
+ * vdo_reset_priority_table() - Reset a priority table, leaving it in the same empty state as when
+ *                          newly constructed.
+ * @table: The table to reset.
+ *
+ * The table does not own the entries stored in it and they are not freed (or even unlinked from
+ * each other) by this call.
+ */
+void vdo_reset_priority_table(struct priority_table *table)
+{
+	unsigned int priority;
+
+	table->search_vector = 0;
+	for (priority = 0; priority <= table->max_priority; priority++)
+		list_del_init(&table->buckets[priority].queue);
+}
+
+/**
+ * vdo_priority_table_enqueue() - Add a new entry to the priority table, appending it to the queue
+ *                                for entries with the specified priority.
+ * @table: The table in which to store the entry.
+ * @priority: The priority of the entry.
+ * @entry: The list_head embedded in the entry to store in the table (the caller must have
+ *         initialized it).
+ */
+void vdo_priority_table_enqueue(struct priority_table *table,
+				unsigned int priority,
+				struct list_head *entry)
+{
+	ASSERT_LOG_ONLY((priority <= table->max_priority),
+			"entry priority must be valid for the table");
+
+	/* Append the entry to the queue in the specified bucket. */
+	list_move_tail(entry, &table->buckets[priority].queue);
+
+	/* Flag the bucket in the search vector since it must be non-empty. */
+	table->search_vector |= (1ULL << priority);
+}
+
+static inline void mark_bucket_empty(struct priority_table *table, struct bucket *bucket)
+{
+	table->search_vector &= ~(1ULL << bucket->priority);
+}
+
+/**
+ * vdo_priority_table_dequeue() - Find the highest-priority entry in the table, remove it from the
+ *                                table, and return it.
+ * @table: The priority table from which to remove an entry.
+ *
+ * If there are multiple entries with the same priority, the one that has been in the table with
+ * that priority the longest will be returned.
+ *
+ * Return: The dequeued entry, or NULL if the table is currently empty.
+ */
+struct list_head *vdo_priority_table_dequeue(struct priority_table *table)
+{
+	struct bucket *bucket;
+	struct list_head *entry;
+	int top_priority;
+
+	if (table->search_vector == 0)
+		/* All buckets are empty. */
+		return NULL;
+
+	/*
+	 * Find the highest priority non-empty bucket by finding the highest-order non-zero bit in
+	 * the search vector.
+	 */
+	top_priority = ilog2(table->search_vector);
+
+	/* Dequeue the first entry in the bucket. */
+	bucket = &table->buckets[top_priority];
+	entry = bucket->queue.next;
+	list_del_init(entry);
+
+	/* Clear the bit in the search vector if the bucket has been emptied. */
+	if (list_empty(&bucket->queue))
+		mark_bucket_empty(table, bucket);
+
+	return entry;
+}
+
+/**
+ * vdo_priority_table_remove() - Remove a specified entry from its priority table.
+ * @table: The table from which to remove the entry.
+ * @entry: The entry to remove from the table.
+ */
+void vdo_priority_table_remove(struct priority_table *table, struct list_head *entry)
+{
+	struct list_head *next_entry;
+
+	/*
+	 * We can't guard against calls where the entry is on a list for a different table, but
+	 * it's easy to deal with an entry not in any table or list.
+	 */
+	if (list_empty(entry))
+		return;
+
+	/*
+	 * Remove the entry from the bucket list, remembering a pointer to another entry in the
+	 * ring.
+	 */
+	next_entry = entry->next;
+	list_del_init(entry);
+
+	/*
+	 * If the rest of the list is now empty, the next node must be the list head in the bucket
+	 * and we can use it to update the search vector.
+	 */
+	if (list_empty(next_entry))
+		mark_bucket_empty(table, list_entry(next_entry, struct bucket, queue));
+}
+
+/**
+ * vdo_is_priority_table_empty() - Return whether the priority table is empty.
+ * @table: The table to check.
+ *
+ * Return: true if the table is empty.
+ */
+bool vdo_is_priority_table_empty(struct priority_table *table)
+{
+	return (table->search_vector == 0);
+}
diff --git a/drivers/md/dm-vdo/priority-table.h b/drivers/md/dm-vdo/priority-table.h
new file mode 100644
index 000000000000..f56460ba0f09
--- /dev/null
+++ b/drivers/md/dm-vdo/priority-table.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_PRIORITY_TABLE_H
+#define VDO_PRIORITY_TABLE_H
+
+#include <linux/list.h>
+
+/*
+ * A priority_table is a simple implementation of a priority queue for entries with priorities that
+ * are small non-negative integer values. It implements the obvious priority queue operations of
+ * enqueuing an entry and dequeuing an entry with the maximum priority. It also supports removing
+ * an arbitrary entry. The priority of an entry already in the table can be changed by removing it
+ * and re-enqueuing it with a different priority. All operations have O(1) complexity.
+ *
+ * The links for the table entries must be embedded in the entries themselves. Lists are used to
+ * link entries in the table and no wrapper type is declared, so an existing list entry in an
+ * object can also be used to queue it in a priority_table, assuming the field is not used for
+ * anything else while so queued.
+ *
+ * The table is implemented as an array of queues (circular lists) indexed by priority, along with
+ * a hint for which queues are non-empty. Steven Skiena calls a very similar structure a "bounded
+ * height priority queue", but given the resemblance to a hash table, "priority table" seems both
+ * shorter and more apt, if somewhat novel.
+ */
+
+struct priority_table;
+
+int __must_check
+vdo_make_priority_table(unsigned int max_priority, struct priority_table **table_ptr);
+
+void vdo_free_priority_table(struct priority_table *table);
+
+void vdo_priority_table_enqueue(struct priority_table *table,
+				unsigned int priority,
+				struct list_head *entry);
+
+void vdo_reset_priority_table(struct priority_table *table);
+
+struct list_head * __must_check vdo_priority_table_dequeue(struct priority_table *table);
+
+void vdo_priority_table_remove(struct priority_table *table, struct list_head *entry);
+
+bool __must_check vdo_is_priority_table_empty(struct priority_table *table);
+
+#endif /* VDO_PRIORITY_TABLE_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

