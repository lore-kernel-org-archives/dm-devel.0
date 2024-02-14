Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C32210971
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 04:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707886637; cv=none; b=Dqqe3+w+RU2LfFHsH+nksB9tPb1WHRQfsNbfPUcFAgkCzGvgch95IrNjKhooYqnnPkMO4SFifSpBDN0O4ru5bSYoT5HIBEu7lJRdVyaXtlHDuew5IUm7SKFHpy4WNypuogUWwsnNCEx1lja61zbsaG9LD885Zqkvyq6w1mx1gow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707886637; c=relaxed/simple;
	bh=jgr13aAeoVsF2vjo5h4XSgWY+xQvrX0wXeI9cFGDRnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmNOzOkuvKk7H40uN8CnsyBixa6mKL8EpNsQ/38lHUqzVe/cQZYO3sjuIaOVAhj51vJChsMGCwL3+/wOqVC2JySjtvvMNjijx3QtwIXI/uGCWwsPtPtn9MhWYewG3tzxX/n6qExbqowxf0SyWgUfXMOxI0o90RHbTseibdzLFqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TywBj35A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TywBj35A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707886634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxycnboIOD+zH4C4OsIGKL2JGDc5r+4iaXO7vJ7/cMc=;
	b=TywBj35ANlJL6iiinXvSHa8ycz4xrwQBwupF6eWGLL+BmJQB9aBGb6FXsb4HIhv05+eMn7
	8xjhB+rBNK1hGLx76kb5qJ+jZwbbkh+Rbj2lka45XDq/B6ZI8uKlz94o8um3/el18+wyco
	fmcaC8nW7XG3O0LtIKcvlsPi+13jWx8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-edAClshpOxKy_A9FzNxWTw-1; Tue,
 13 Feb 2024 23:57:12 -0500
X-MC-Unique: edAClshpOxKy_A9FzNxWTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63C481C05138;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E75D2166B5D;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5CF23576C2; Tue, 13 Feb 2024 23:57:12 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 5/5] dm vdo delta-index: fix various small nits
Date: Tue, 13 Feb 2024 23:57:12 -0500
Message-ID: <a407071d26f55268de7f6cbf36a7dc0eb3ee0b27.1707886374.git.msakai@redhat.com>
In-Reply-To: <cover.1707886374.git.msakai@redhat.com>
References: <cover.1707886374.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Fix some needless line wrapping (given surrounding context), missing
braces and some stale or incorrect references to data structure or
function name.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/delta-index.c | 23 ++++++++++-------------
 drivers/md/dm-vdo/delta-index.h |  2 +-
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-vdo/delta-index.c b/drivers/md/dm-vdo/delta-index.c
index 0322552cdbd8..6306777bb202 100644
--- a/drivers/md/dm-vdo/delta-index.c
+++ b/drivers/md/dm-vdo/delta-index.c
@@ -47,7 +47,7 @@
  *
  * The delta in each entry is encoded with a variable-length Huffman code to minimize the memory
  * used by small deltas. The Huffman code is specified by three parameters, which can be computed
- * from the desired mean delta when the index is full. (See compute_coding constants() for
+ * from the desired mean delta when the index is full. (See compute_coding_constants() for
  * details.)
  *
  * The bit field utilities used to read and write delta entries assume that it is possible to read
@@ -294,8 +294,7 @@ void uds_reset_delta_index(const struct delta_index *delta_index)
  * - The next INCR values code using MINBITS+2 bits.
  * - (and so on).
  */
-static void compute_coding_constants(u32 mean_delta, u16 *min_bits, u32 *min_keys,
-				     u32 *incr_keys)
+static void compute_coding_constants(u32 mean_delta, u16 *min_bits, u32 *min_keys, u32 *incr_keys)
 {
 	/*
 	 * We want to compute the rounded value of log(2) * mean_delta. Since we cannot always use
@@ -617,8 +616,7 @@ static inline void set_zero(u8 *memory, u64 offset, u32 size)
  * Move several bits from a higher to a lower address, moving the lower addressed bits first. The
  * size and memory offsets are measured in bits.
  */
-static void move_bits_down(const u8 *from, u64 from_offset, u8 *to, u64 to_offset,
-			   u32 size)
+static void move_bits_down(const u8 *from, u64 from_offset, u8 *to, u64 to_offset, u32 size)
 {
 	const u8 *source;
 	u8 *destination;
@@ -658,8 +656,7 @@ static void move_bits_down(const u8 *from, u64 from_offset, u8 *to, u64 to_offse
  * Move several bits from a lower to a higher address, moving the higher addressed bits first. The
  * size and memory offsets are measured in bits.
  */
-static void move_bits_up(const u8 *from, u64 from_offset, u8 *to, u64 to_offset,
-			 u32 size)
+static void move_bits_up(const u8 *from, u64 from_offset, u8 *to, u64 to_offset, u32 size)
 {
 	const u8 *source;
 	u8 *destination;
@@ -1006,8 +1003,7 @@ static int restore_delta_list_to_zone(struct delta_zone *delta_zone,
 	return UDS_SUCCESS;
 }
 
-static int restore_delta_list_data(struct delta_index *delta_index,
-				   unsigned int load_zone,
+static int restore_delta_list_data(struct delta_index *delta_index, unsigned int load_zone,
 				   struct buffered_reader *buffered_reader, u8 *data)
 {
 	int result;
@@ -1016,9 +1012,10 @@ static int restore_delta_list_data(struct delta_index *delta_index,
 	unsigned int new_zone;
 
 	result = uds_read_from_buffered_reader(buffered_reader, buffer, sizeof(buffer));
-	if (result != UDS_SUCCESS)
+	if (result != UDS_SUCCESS) {
 		return uds_log_warning_strerror(result,
 						"failed to read delta list data");
+	}
 
 	save_info = (struct delta_list_save_info) {
 		.tag = buffer[0],
@@ -1028,9 +1025,10 @@ static int restore_delta_list_data(struct delta_index *delta_index,
 	};
 
 	if ((save_info.bit_offset >= BITS_PER_BYTE) ||
-	    (save_info.byte_count > DELTA_LIST_MAX_BYTE_COUNT))
+	    (save_info.byte_count > DELTA_LIST_MAX_BYTE_COUNT)) {
 		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
 						"corrupt delta list data");
+	}
 
 	/* Make sure the data is intended for this delta index. */
 	if (save_info.tag != delta_index->tag)
@@ -1422,8 +1420,7 @@ static void set_delta(struct delta_index_entry *delta_entry, u32 delta)
 {
 	const struct delta_zone *delta_zone = delta_entry->delta_zone;
 	u32 key_bits = (delta_zone->min_bits +
-			((delta_zone->incr_keys -
-			  delta_zone->min_keys + delta) /
+			((delta_zone->incr_keys - delta_zone->min_keys + delta) /
 			 delta_zone->incr_keys));
 
 	delta_entry->delta = delta;
diff --git a/drivers/md/dm-vdo/delta-index.h b/drivers/md/dm-vdo/delta-index.h
index 046290b7ebe7..b3b38fb440bf 100644
--- a/drivers/md/dm-vdo/delta-index.h
+++ b/drivers/md/dm-vdo/delta-index.h
@@ -113,7 +113,7 @@ struct delta_index {
  */
 struct delta_index_page {
 	struct delta_index delta_index;
-	/* These values are loaded from the DeltaPageHeader */
+	/* These values are loaded from the delta_page_header */
 	u32 lowest_list_number;
 	u32 highest_list_number;
 	u64 virtual_chapter_number;
-- 
2.42.0

