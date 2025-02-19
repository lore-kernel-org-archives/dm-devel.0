Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF532417C3
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 23:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740006026; cv=none; b=KG2Wb1LN51lBQvuw3X7fpMozNxwVeLqQSGuoukGNz8K3wpDdmJ/uZMmJZBCXKZJLkluCPxEOvZpw9a+ZI8AxrgWSrw1d65YK/2ElOAi6LYZfc7ccTk+u2E5/nadY3Wp5IDxT8uzrifZv9s4s2R9NvCJaFz3KI52eg7e6tt6N6iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740006026; c=relaxed/simple;
	bh=I4BOVcu9FTPlGmqZrrb/NIpAF9sYeWlhGLNMxkJpyyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Th+Lb/81r6+TFIyTMrQq2ZrlcDLlaYNUOD1B1FeYHI5BVgOm0T3d24gXR9BefwfKYHAsdTHY1R7+Kc/T+1KEgcyEsbTBYYu2BZ6wFzNTTqEUEDTyhcSUHHuIRsv3E277wTVqW2nup7oms6aSa+0+woQuwIAF8xUXOeEqeddBnK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CyyVwMqw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CyyVwMqw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740006023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+Bka6GDg/6SeeBokMjcG82v5gKp/2BPMvelUuTE3Y+s=;
	b=CyyVwMqwHey+RiEroi7KYla5dVgxqwffa1Qh+w552txisAqYmVKFWQFiw8/Aq5C8ByzE7t
	8cAzAsRLvcOwSzaneAe71L0SyDmQ3kiDidisy8VanpPlcGufIjZ3qXk7BGPQ+xYwb9ydnL
	fKLTmkjTzDRLxSllycYjo+4STaE2pC4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-4HtTWz5gMtWiWr0l9-fv6A-1; Wed,
 19 Feb 2025 18:00:21 -0500
X-MC-Unique: 4HtTWz5gMtWiWr0l9-fv6A-1
X-Mimecast-MFC-AGG-ID: 4HtTWz5gMtWiWr0l9-fv6A_1740006021
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9A311801A3B
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 23:00:20 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C60931800940;
	Wed, 19 Feb 2025 23:00:20 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id EB24460398; Wed, 19 Feb 2025 18:00:19 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: rework processing of loaded refcount byte arrays
Date: Wed, 19 Feb 2025 18:00:19 -0500
Message-ID: <20250219230019.1336007-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qn7YBV7gENyeUq-_JDywKDSU9YoP7NLZwrh4XYq8UqQ_1740006021
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Clear provisional refcount values and count free/allocated blocks in
one integrated loop. Process 8 aligned bytes at a time instead of
every byte individually.

On an Intel i7-11850H this reduces the CPU time needed to process a
loaded refcount block by a factor of about 5-6. On a large system the
refcount loading may be the largest factor in device startup time.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/slab-depot.c | 105 ++++++++++++++++++++++++++-------
 1 file changed, 83 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 823b78b9f5b5..ea54914e8788 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -2164,28 +2164,95 @@ static void dirty_all_reference_blocks(struct vdo_slab *slab)
 		dirty_block(&slab->reference_blocks[i]);
 }
 
+static inline bool journal_points_equal(struct journal_point first,
+					struct journal_point second)
+{
+	return ((first.sequence_number == second.sequence_number) &&
+		(first.entry_count == second.entry_count));
+}
+
 /**
- * clear_provisional_references() - Clear the provisional reference counts from a reference block.
- * @block: The block to clear.
+ * match_bytes() - Check an 8-byte word for bytes matching the value specified
+ * @input: A word to examine the bytes of
+ * @match: The byte value sought
+ *
+ * Return: 1 in each byte when the corresponding input byte matched, 0 otherwise
  */
-static void clear_provisional_references(struct reference_block *block)
+static inline u64 match_bytes(u64 input, u8 match)
 {
-	vdo_refcount_t *counters = get_reference_counters_for_block(block);
-	block_count_t j;
+	u64 temp = input ^ (match * 0x0101010101010101ULL);
+	/* top bit of each byte is set iff top bit of temp byte is clear; rest are 0 */
+	u64 test_top_bits = ~temp & 0x8080808080808080ULL;
+	/* top bit of each byte is set iff low 7 bits of temp byte are clear; rest are useless */
+	u64 test_low_bits = 0x8080808080808080ULL - (temp & 0x7f7f7f7f7f7f7f7fULL);
+	/* return 1 when both tests indicate temp byte is 0 */
+	return (test_top_bits & test_low_bits) >> 7;
+}
+
+/**
+ * count_valid_references() - Process a newly loaded refcount array
+ * @counters: the array of counters from a metadata block
+ *
+ * Scan a 8-byte-aligned array of counters, fixing up any "provisional" values that weren't
+ * cleaned up at shutdown, changing them internally to "empty".
+ *
+ * Return: the number of blocks that are referenced (counters not "empty")
+ */
+static unsigned int count_valid_references(vdo_refcount_t *counters)
+{
+	u64 *words = (u64 *)counters;
+	/* It's easier to count occurrences of a specific byte than its absences. */
+	unsigned int empty_count = 0;
+	/* For speed, we process 8 bytes at once. */
+	unsigned int words_left = COUNTS_PER_BLOCK / sizeof(u64);
+
+	/*
+	 * Sanity check assumptions used for optimizing this code: Counters are bytes. The counter
+	 * array is a multiple of the word size.
+	 */
+	BUILD_BUG_ON(sizeof(vdo_refcount_t) != 1);
+	BUILD_BUG_ON((COUNTS_PER_BLOCK % sizeof(u64)) != 0);
 
-	for (j = 0; j < COUNTS_PER_BLOCK; j++) {
-		if (counters[j] == PROVISIONAL_REFERENCE_COUNT) {
-			counters[j] = EMPTY_REFERENCE_COUNT;
-			block->allocated_count--;
+	while (words_left > 0) {
+		/*
+		 * This is used effectively as 8 byte-size counters. Byte 0 counts how many words
+		 * had the target value found in byte 0, etc. We just have to avoid overflow.
+		 */
+		u64 split_count = 0;
+		/*
+		 * The counter "% 255" trick used below to fold split_count into empty_count
+		 * imposes a limit of 254 bytes examined each iteration of the outer loop. We
+		 * process a word at a time, so that limit gets rounded down to 31 u64 words.
+		 */
+		const unsigned int max_words_per_iteration = 254 / sizeof(u64);
+		unsigned int iter_words_left = min_t(unsigned int, words_left,
+						     max_words_per_iteration);
+
+		words_left -= iter_words_left;
+
+		while (iter_words_left--) {
+			u64 word = *words;
+			u64 temp;
+
+			/* First, if we have any provisional refcount values, clear them. */
+			temp = match_bytes(word, PROVISIONAL_REFERENCE_COUNT);
+			if (temp) {
+				/*
+				 * 'temp' has 0x01 bytes where 'word' has PROVISIONAL; this xor
+				 * will alter just those bytes, changing PROVISIONAL to EMPTY.
+				 */
+				word ^= temp * (PROVISIONAL_REFERENCE_COUNT ^ EMPTY_REFERENCE_COUNT);
+				*words = word;
+			}
+
+			/* Now count the EMPTY_REFERENCE_COUNT bytes, updating the 8 counters. */
+			split_count += match_bytes(word, EMPTY_REFERENCE_COUNT);
+			words++;
 		}
+		empty_count += split_count % 255;
 	}
-}
 
-static inline bool journal_points_equal(struct journal_point first,
-					struct journal_point second)
-{
-	return ((first.sequence_number == second.sequence_number) &&
-		(first.entry_count == second.entry_count));
+	return COUNTS_PER_BLOCK - empty_count;
 }
 
 /**
@@ -2196,7 +2263,6 @@ static inline bool journal_points_equal(struct journal_point first,
 static void unpack_reference_block(struct packed_reference_block *packed,
 				   struct reference_block *block)
 {
-	block_count_t index;
 	sector_count_t i;
 	struct vdo_slab *slab = block->slab;
 	vdo_refcount_t *counters = get_reference_counters_for_block(block);
@@ -2222,11 +2288,7 @@ static void unpack_reference_block(struct packed_reference_block *packed,
 		}
 	}
 
-	block->allocated_count = 0;
-	for (index = 0; index < COUNTS_PER_BLOCK; index++) {
-		if (counters[index] != EMPTY_REFERENCE_COUNT)
-			block->allocated_count++;
-	}
+	block->allocated_count = count_valid_references(counters);
 }
 
 /**
@@ -2247,7 +2309,6 @@ static void finish_reference_block_load(struct vdo_completion *completion)
 		struct packed_reference_block *packed = (struct packed_reference_block *) data;
 
 		unpack_reference_block(packed, block);
-		clear_provisional_references(block);
 		slab->free_blocks -= block->allocated_count;
 	}
 	return_vio_to_pool(pooled);
-- 
2.45.2

