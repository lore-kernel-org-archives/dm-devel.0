Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05F350260
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267938; cv=none; b=WlgbiMzKBeQ98ntWEhxYry2ss6FmI5DIutC87/MCax4DvXnfFGGEJUfc8kdlgXSRvXu4OmJs6a0J8CqRlmWoKuXeCVAjQUvEKibWEZK+MBYbuOnvCSKQs1tb7iANFWkrmoarC38kQLzEuNNLrVdmRKR2bdLHCn300KEf4jnuDmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267938; c=relaxed/simple;
	bh=7EdYRRXBE03TVCwgedkMWG1BI6rL01/GyhRFfCcFJf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLvpuRUDKjnR/bYhXklZV6hdVNFkpQ+g8lgPtS9PP7d8HeJkeOOX/TkiEG2K4H2lmiAVvsd4aGzxMUyKVyrXfuVj4btRu7aTDC96k+ebJWOeqgViaVbEZjimZMORZmsjNjSQwR0PEHDPI7YdICQBvLAkJs9/Z8Dl2BTXEB4Og6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IrL8UHE8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IrL8UHE8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ov6o7AUSW12QWTZVgcRRmQYlwzeQCxNNd52t1u+BwzU=;
	b=IrL8UHE8jIyoWL03qxVs8rCieWcUWBTbeX09NjCcYxlsOqCC/4s/G7yzgDBLL285Zmc14W
	Die9TtHaFrTb8xan2jDzOxoffMgpfegMRlSbBEqhv206KnJqbnzK90f5x2gwgbx79v/PYY
	2sJURXfsQS42HsDuoWtfuq5sDKbb748=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-aAaX_mHYPdiHZ2B9zAp9Vw-1; Thu, 29 Feb 2024 23:38:54 -0500
X-MC-Unique: aAaX_mHYPdiHZ2B9zAp9Vw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E31CC859B80
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDE93200F82A;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id DB657A162C; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 09/10] dm vdo indexer: update ASSERT and ASSERT_LOG_ONLY usage
Date: Thu, 29 Feb 2024 23:38:52 -0500
Message-ID: <8ffbd67687fc963507c2c14ec3e0409785ee4e9c.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Update indexer uses of ASSERT and ASSERT_LOG_ONLY to
VDO_ASSERT and VDO_ASSERT_LOG_ONLY, respectively. Remove
ASSERT and ASSERT_LOG_ONLY. Also rename uds_assertion_failed
to vdo_assertion_failed.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/chapter-index.c | 16 ++--
 drivers/md/dm-vdo/indexer/config.c        | 16 ++--
 drivers/md/dm-vdo/indexer/delta-index.c   | 90 +++++++++++------------
 drivers/md/dm-vdo/indexer/index-layout.c  |  5 +-
 drivers/md/dm-vdo/indexer/index-session.c | 12 +--
 drivers/md/dm-vdo/indexer/index.c         |  4 +-
 drivers/md/dm-vdo/indexer/volume-index.c  | 32 ++++----
 drivers/md/dm-vdo/indexer/volume.c        | 32 ++++----
 drivers/md/dm-vdo/permassert.c            |  2 +-
 drivers/md/dm-vdo/permassert.h            |  8 +-
 10 files changed, 107 insertions(+), 110 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index 68d86028dbb7..47e4ed234242 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -83,10 +83,10 @@ int uds_put_open_chapter_index_record(struct open_chapter_index *chapter_index,
 	u64 chapter_number = chapter_index->virtual_chapter_number;
 	u32 record_pages = geometry->record_pages_per_chapter;
 
-	result = ASSERT(page_number < record_pages,
-			"Page number within chapter (%u) exceeds the maximum value %u",
-			page_number, record_pages);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(page_number < record_pages,
+			    "Page number within chapter (%u) exceeds the maximum value %u",
+			    page_number, record_pages);
+	if (result != VDO_SUCCESS)
 		return UDS_INVALID_ARGUMENT;
 
 	address = uds_hash_to_chapter_delta_address(name, geometry);
@@ -97,10 +97,10 @@ int uds_put_open_chapter_index_record(struct open_chapter_index *chapter_index,
 		return result;
 
 	found = was_entry_found(&entry, address);
-	result = ASSERT(!(found && entry.is_collision),
-			"Chunk appears more than once in chapter %llu",
-			(unsigned long long) chapter_number);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(!(found && entry.is_collision),
+			    "Chunk appears more than once in chapter %llu",
+			    (unsigned long long) chapter_number);
+	if (result != VDO_SUCCESS)
 		return UDS_BAD_STATE;
 
 	found_name = (found ? name->name : NULL);
diff --git a/drivers/md/dm-vdo/indexer/config.c b/drivers/md/dm-vdo/indexer/config.c
index 5da39043b9ae..69bf27a9d61b 100644
--- a/drivers/md/dm-vdo/indexer/config.c
+++ b/drivers/md/dm-vdo/indexer/config.c
@@ -134,10 +134,10 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 	decode_u32_le(buffer, &offset, &config.sparse_sample_rate);
 	decode_u64_le(buffer, &offset, &config.nonce);
 
-	result = ASSERT(offset == sizeof(struct uds_configuration_6_02),
-			"%zu bytes read but not decoded",
-			sizeof(struct uds_configuration_6_02) - offset);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(offset == sizeof(struct uds_configuration_6_02),
+			    "%zu bytes read but not decoded",
+			    sizeof(struct uds_configuration_6_02) - offset);
+	if (result != VDO_SUCCESS)
 		return UDS_CORRUPT_DATA;
 
 	if (is_version(INDEX_CONFIG_VERSION_6_02, version_buffer)) {
@@ -210,10 +210,10 @@ int uds_write_config_contents(struct buffered_writer *writer,
 	encode_u32_le(buffer, &offset, config->sparse_sample_rate);
 	encode_u64_le(buffer, &offset, config->nonce);
 
-	result = ASSERT(offset == sizeof(struct uds_configuration_6_02),
-			"%zu bytes encoded, of %zu expected", offset,
-			sizeof(struct uds_configuration_6_02));
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(offset == sizeof(struct uds_configuration_6_02),
+			    "%zu bytes encoded, of %zu expected", offset,
+			    sizeof(struct uds_configuration_6_02));
+	if (result != VDO_SUCCESS)
 		return result;
 
 	if (version >= 4) {
diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index 5bba9a48c5a0..b49066554248 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -856,10 +856,10 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 		decode_u64_le(buffer, &offset, &header.record_count);
 		decode_u64_le(buffer, &offset, &header.collision_count);
 
-		result = ASSERT(offset == sizeof(struct delta_index_header),
-				"%zu bytes decoded of %zu expected", offset,
-				sizeof(struct delta_index_header));
-		if (result != UDS_SUCCESS) {
+		result = VDO_ASSERT(offset == sizeof(struct delta_index_header),
+				    "%zu bytes decoded of %zu expected", offset,
+				    sizeof(struct delta_index_header));
+		if (result != VDO_SUCCESS) {
 			return uds_log_warning_strerror(result,
 							"failed to read delta index header");
 		}
@@ -1136,10 +1136,10 @@ int uds_start_saving_delta_index(const struct delta_index *delta_index,
 	encode_u64_le(buffer, &offset, delta_zone->record_count);
 	encode_u64_le(buffer, &offset, delta_zone->collision_count);
 
-	result = ASSERT(offset == sizeof(struct delta_index_header),
-			"%zu bytes encoded of %zu expected", offset,
-			sizeof(struct delta_index_header));
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(offset == sizeof(struct delta_index_header),
+			    "%zu bytes encoded of %zu expected", offset,
+			    sizeof(struct delta_index_header));
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = uds_write_to_buffered_writer(buffered_writer, buffer, offset);
@@ -1212,9 +1212,9 @@ size_t uds_compute_delta_index_save_bytes(u32 list_count, size_t memory_size)
 
 static int assert_not_at_end(const struct delta_index_entry *delta_entry)
 {
-	int result = ASSERT(!delta_entry->at_end,
-			    "operation is invalid because the list entry is at the end of the delta list");
-	if (result != UDS_SUCCESS)
+	int result = VDO_ASSERT(!delta_entry->at_end,
+				"operation is invalid because the list entry is at the end of the delta list");
+	if (result != VDO_SUCCESS)
 		result = UDS_BAD_STATE;
 
 	return result;
@@ -1236,19 +1236,19 @@ int uds_start_delta_index_search(const struct delta_index *delta_index, u32 list
 	struct delta_zone *delta_zone;
 	struct delta_list *delta_list;
 
-	result = ASSERT((list_number < delta_index->list_count),
-			"Delta list number (%u) is out of range (%u)", list_number,
-			delta_index->list_count);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT((list_number < delta_index->list_count),
+			    "Delta list number (%u) is out of range (%u)", list_number,
+			    delta_index->list_count);
+	if (result != VDO_SUCCESS)
 		return UDS_CORRUPT_DATA;
 
 	zone_number = list_number / delta_index->lists_per_zone;
 	delta_zone = &delta_index->delta_zones[zone_number];
 	list_number -= delta_zone->first_list;
-	result = ASSERT((list_number < delta_zone->list_count),
-			"Delta list number (%u) is out of range (%u) for zone (%u)",
-			list_number, delta_zone->list_count, zone_number);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT((list_number < delta_zone->list_count),
+			    "Delta list number (%u) is out of range (%u) for zone (%u)",
+			    list_number, delta_zone->list_count, zone_number);
+	if (result != VDO_SUCCESS)
 		return UDS_CORRUPT_DATA;
 
 	if (delta_index->mutable) {
@@ -1362,9 +1362,9 @@ noinline int uds_next_delta_index_entry(struct delta_index_entry *delta_entry)
 		delta_entry->at_end = true;
 		delta_entry->delta = 0;
 		delta_entry->is_collision = false;
-		result = ASSERT((delta_entry->offset == size),
-				"next offset past end of delta list");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT((delta_entry->offset == size),
+				    "next offset past end of delta list");
+		if (result != VDO_SUCCESS)
 			result = UDS_CORRUPT_DATA;
 
 		return result;
@@ -1390,8 +1390,8 @@ int uds_remember_delta_index_offset(const struct delta_index_entry *delta_entry)
 	int result;
 	struct delta_list *delta_list = delta_entry->delta_list;
 
-	result = ASSERT(!delta_entry->is_collision, "entry is not a collision");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(!delta_entry->is_collision, "entry is not a collision");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	delta_list->save_key = delta_entry->key - delta_entry->delta;
@@ -1489,9 +1489,9 @@ int uds_get_delta_entry_collision(const struct delta_index_entry *delta_entry, u
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = ASSERT(delta_entry->is_collision,
-			"Cannot get full block name from a non-collision delta index entry");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(delta_entry->is_collision,
+			    "Cannot get full block name from a non-collision delta index entry");
+	if (result != VDO_SUCCESS)
 		return UDS_BAD_STATE;
 
 	get_collision_name(delta_entry, name);
@@ -1506,9 +1506,9 @@ u32 uds_get_delta_entry_value(const struct delta_index_entry *delta_entry)
 
 static int assert_mutable_entry(const struct delta_index_entry *delta_entry)
 {
-	int result = ASSERT((delta_entry->delta_list != &delta_entry->temp_delta_list),
-			    "delta index is mutable");
-	if (result != UDS_SUCCESS)
+	int result = VDO_ASSERT((delta_entry->delta_list != &delta_entry->temp_delta_list),
+			        "delta index is mutable");
+	if (result != VDO_SUCCESS)
 		result = UDS_BAD_STATE;
 
 	return result;
@@ -1527,10 +1527,10 @@ int uds_set_delta_entry_value(const struct delta_index_entry *delta_entry, u32 v
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = ASSERT((value & value_mask) == value,
-			"Value (%u) being set in a delta index is too large (must fit in %u bits)",
-			value, delta_entry->value_bits);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT((value & value_mask) == value,
+			    "Value (%u) being set in a delta index is too large (must fit in %u bits)",
+			    value, delta_entry->value_bits);
+	if (result != VDO_SUCCESS)
 		return UDS_INVALID_ARGUMENT;
 
 	set_field(value, delta_entry->delta_zone->memory,
@@ -1730,9 +1730,9 @@ int uds_put_delta_index_entry(struct delta_index_entry *delta_entry, u32 key, u3
 		if (result != UDS_SUCCESS)
 			return result;
 
-		result = ASSERT((key == delta_entry->key),
-				"incorrect key for collision entry");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT((key == delta_entry->key),
+				    "incorrect key for collision entry");
+		if (result != VDO_SUCCESS)
 			return result;
 
 		delta_entry->offset += delta_entry->entry_bits;
@@ -1742,8 +1742,8 @@ int uds_put_delta_index_entry(struct delta_index_entry *delta_entry, u32 key, u3
 		result = insert_bits(delta_entry, delta_entry->entry_bits);
 	} else if (delta_entry->at_end) {
 		/* Insert a new entry at the end of the delta list. */
-		result = ASSERT((key >= delta_entry->key), "key past end of list");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT((key >= delta_entry->key), "key past end of list");
+		if (result != VDO_SUCCESS)
 			return result;
 
 		set_delta(delta_entry, key - delta_entry->key);
@@ -1760,14 +1760,14 @@ int uds_put_delta_index_entry(struct delta_index_entry *delta_entry, u32 key, u3
 		 * Insert a new entry which requires the delta in the following entry to be
 		 * updated.
 		 */
-		result = ASSERT((key < delta_entry->key),
-				"key precedes following entry");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT((key < delta_entry->key),
+				    "key precedes following entry");
+		if (result != VDO_SUCCESS)
 			return result;
 
-		result = ASSERT((key >= delta_entry->key - delta_entry->delta),
-				"key effects following entry's delta");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT((key >= delta_entry->key - delta_entry->delta),
+				    "key effects following entry's delta");
+		if (result != VDO_SUCCESS)
 			return result;
 
 		old_entry_size = delta_entry->entry_bits;
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 01e0db4184aa..349b3022f1e1 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -837,8 +837,9 @@ static u64 generate_index_save_nonce(u64 volume_nonce, struct index_save_layout
 	encode_u32_le(buffer, &offset, isl->save_data.version);
 	encode_u32_le(buffer, &offset, 0U);
 	encode_u64_le(buffer, &offset, isl->index_save.start_block);
-	ASSERT_LOG_ONLY(offset == sizeof(nonce_data),
-			"%zu bytes encoded of %zu expected", offset, sizeof(nonce_data));
+	VDO_ASSERT_LOG_ONLY(offset == sizeof(nonce_data),
+			    "%zu bytes encoded of %zu expected",
+			    offset, sizeof(nonce_data));
 	return generate_secondary_nonce(volume_nonce, buffer, sizeof(buffer));
 }
 
diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
index 22445dcb3fe0..9eae00548095 100644
--- a/drivers/md/dm-vdo/indexer/index-session.c
+++ b/drivers/md/dm-vdo/indexer/index-session.c
@@ -199,8 +199,8 @@ static void update_session_stats(struct uds_request *request)
 		break;
 
 	default:
-		request->status = ASSERT(false, "unknown request type: %d",
-					 request->type);
+		request->status = VDO_ASSERT(false, "unknown request type: %d",
+					     request->type);
 	}
 }
 
@@ -402,8 +402,8 @@ static void suspend_rebuild(struct uds_index_session *session)
 	case INDEX_FREEING:
 	default:
 		/* These cases should not happen. */
-		ASSERT_LOG_ONLY(false, "Bad load context state %u",
-				session->load_context.status);
+		VDO_ASSERT_LOG_ONLY(false, "Bad load context state %u",
+				    session->load_context.status);
 		break;
 	}
 	mutex_unlock(&session->load_context.mutex);
@@ -531,8 +531,8 @@ int uds_resume_index_session(struct uds_index_session *session,
 		case INDEX_FREEING:
 		default:
 			/* These cases should not happen; do nothing. */
-			ASSERT_LOG_ONLY(false, "Bad load context state %u",
-					session->load_context.status);
+			VDO_ASSERT_LOG_ONLY(false, "Bad load context state %u",
+					    session->load_context.status);
 			break;
 		}
 		mutex_unlock(&session->load_context.mutex);
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index 226713221105..221af95ca2a4 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -112,7 +112,7 @@ static void enqueue_barrier_messages(struct uds_index *index, u64 virtual_chapte
 	for (zone = 0; zone < index->zone_count; zone++) {
 		int result = launch_zone_message(message, zone, index);
 
-		ASSERT_LOG_ONLY((result == UDS_SUCCESS), "barrier message allocation");
+		VDO_ASSERT_LOG_ONLY((result == UDS_SUCCESS), "barrier message allocation");
 	}
 }
 
@@ -1380,7 +1380,7 @@ void uds_enqueue_request(struct uds_request *request, enum request_stage stage)
 		break;
 
 	default:
-		ASSERT_LOG_ONLY(false, "invalid index stage: %d", stage);
+		VDO_ASSERT_LOG_ONLY(false, "invalid index stage: %d", stage);
 		return;
 	}
 
diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index 1cc9ac4fe510..e2b0600d82b9 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -832,10 +832,10 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 		decode_u32_le(buffer, &offset, &header.first_list);
 		decode_u32_le(buffer, &offset, &header.list_count);
 
-		result = ASSERT(offset == sizeof(buffer),
-				"%zu bytes decoded of %zu expected", offset,
-				sizeof(buffer));
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT(offset == sizeof(buffer),
+				    "%zu bytes decoded of %zu expected", offset,
+				    sizeof(buffer));
+		if (result != VDO_SUCCESS)
 			result = UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
@@ -924,10 +924,10 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
 		offset += MAGIC_SIZE;
 		decode_u32_le(buffer, &offset, &header.sparse_sample_rate);
 
-		result = ASSERT(offset == sizeof(buffer),
-				"%zu bytes decoded of %zu expected", offset,
-				sizeof(buffer));
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT(offset == sizeof(buffer),
+				    "%zu bytes decoded of %zu expected", offset,
+				    sizeof(buffer));
+		if (result != VDO_SUCCESS)
 			result = UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
@@ -1023,10 +1023,10 @@ static int start_saving_volume_sub_index(const struct volume_sub_index *sub_inde
 	encode_u32_le(buffer, &offset, first_list);
 	encode_u32_le(buffer, &offset, list_count);
 
-	result =  ASSERT(offset == sizeof(struct sub_index_data),
-			 "%zu bytes of config written, of %zu expected", offset,
-			 sizeof(struct sub_index_data));
-	if (result != UDS_SUCCESS)
+	result =  VDO_ASSERT(offset == sizeof(struct sub_index_data),
+			     "%zu bytes of config written, of %zu expected", offset,
+			     sizeof(struct sub_index_data));
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = uds_write_to_buffered_writer(buffered_writer, buffer, offset);
@@ -1066,10 +1066,10 @@ static int start_saving_volume_index(const struct volume_index *volume_index,
 	memcpy(buffer, MAGIC_START_6, MAGIC_SIZE);
 	offset += MAGIC_SIZE;
 	encode_u32_le(buffer, &offset, volume_index->sparse_sample_rate);
-	result = ASSERT(offset == sizeof(struct volume_index_data),
-			"%zu bytes of header written, of %zu expected", offset,
-			sizeof(struct volume_index_data));
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(offset == sizeof(struct volume_index_data),
+			    "%zu bytes of header written, of %zu expected", offset,
+			    sizeof(struct volume_index_data));
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 0a4beef8ac8d..701f2220d803 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -135,8 +135,8 @@ static void begin_pending_search(struct page_cache *cache, u32 physical_page,
 	invalidate_counter.page = physical_page;
 	invalidate_counter.counter++;
 	set_invalidate_counter(cache, zone_number, invalidate_counter);
-	ASSERT_LOG_ONLY(search_pending(invalidate_counter),
-			"Search is pending for zone %u", zone_number);
+	VDO_ASSERT_LOG_ONLY(search_pending(invalidate_counter),
+			    "Search is pending for zone %u", zone_number);
 	/*
 	 * This memory barrier ensures that the write to the invalidate counter is seen by other
 	 * threads before this thread accesses the cached page. The corresponding read memory
@@ -158,8 +158,8 @@ static void end_pending_search(struct page_cache *cache, unsigned int zone_numbe
 	smp_mb();
 
 	invalidate_counter = get_invalidate_counter(cache, zone_number);
-	ASSERT_LOG_ONLY(search_pending(invalidate_counter),
-			"Search is pending for zone %u", zone_number);
+	VDO_ASSERT_LOG_ONLY(search_pending(invalidate_counter),
+			    "Search is pending for zone %u", zone_number);
 	invalidate_counter.counter++;
 	set_invalidate_counter(cache, zone_number, invalidate_counter);
 }
@@ -259,8 +259,8 @@ static int put_page_in_cache(struct page_cache *cache, u32 physical_page,
 	int result;
 
 	/* We hold the read_threads_mutex. */
-	result = ASSERT((page->read_pending), "page to install has a pending read");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT((page->read_pending), "page to install has a pending read");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	page->physical_page = physical_page;
@@ -285,8 +285,8 @@ static void cancel_page_in_cache(struct page_cache *cache, u32 physical_page,
 	int result;
 
 	/* We hold the read_threads_mutex. */
-	result = ASSERT((page->read_pending), "page to install has a pending read");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT((page->read_pending), "page to install has a pending read");
+	if (result != VDO_SUCCESS)
 		return;
 
 	clear_cache_page(cache, page);
@@ -889,10 +889,10 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 	if (record_page_number == NO_CHAPTER_INDEX_ENTRY)
 		return UDS_SUCCESS;
 
-	result = ASSERT(record_page_number < geometry->record_pages_per_chapter,
-			"0 <= %d < %u", record_page_number,
-			geometry->record_pages_per_chapter);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(record_page_number < geometry->record_pages_per_chapter,
+			    "0 <= %d < %u", record_page_number,
+			    geometry->record_pages_per_chapter);
+	if (result != VDO_SUCCESS)
 		return result;
 
 	page_number = geometry->index_pages_per_chapter + record_page_number;
@@ -1501,10 +1501,10 @@ static int __must_check initialize_page_cache(struct page_cache *cache,
 	cache->zone_count = zone_count;
 	atomic64_set(&cache->clock, 1);
 
-	result = ASSERT((cache->cache_slots <= VOLUME_CACHE_MAX_ENTRIES),
-			"requested cache size, %u, within limit %u",
-			cache->cache_slots, VOLUME_CACHE_MAX_ENTRIES);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT((cache->cache_slots <= VOLUME_CACHE_MAX_ENTRIES),
+			    "requested cache size, %u, within limit %u",
+			    cache->cache_slots, VOLUME_CACHE_MAX_ENTRIES);
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate(VOLUME_CACHE_MAX_QUEUED_READS, struct queued_read,
diff --git a/drivers/md/dm-vdo/permassert.c b/drivers/md/dm-vdo/permassert.c
index 3fa752ba0061..6fe49c4b7e51 100644
--- a/drivers/md/dm-vdo/permassert.c
+++ b/drivers/md/dm-vdo/permassert.c
@@ -8,7 +8,7 @@
 #include "errors.h"
 #include "logger.h"
 
-int uds_assertion_failed(const char *expression_string, const char *file_name,
+int vdo_assertion_failed(const char *expression_string, const char *file_name,
 			 int line_number, const char *format, ...)
 {
 	va_list args;
diff --git a/drivers/md/dm-vdo/permassert.h b/drivers/md/dm-vdo/permassert.h
index 8774dde7927a..c34f2ba650e1 100644
--- a/drivers/md/dm-vdo/permassert.h
+++ b/drivers/md/dm-vdo/permassert.h
@@ -33,16 +33,12 @@ static inline int __must_check vdo_must_use(int value)
 /* Log a message if the expression is not true. */
 #define VDO_ASSERT_LOG_ONLY(expr, ...) __VDO_ASSERT(expr, __VA_ARGS__)
 
-/* For use by UDS */
-#define ASSERT(expr, ...) VDO_ASSERT(expr, __VA_ARGS__)
-#define ASSERT_LOG_ONLY(expr, ...) __VDO_ASSERT(expr, __VA_ARGS__)
-
 #define __VDO_ASSERT(expr, ...)				      \
 	(likely(expr) ? VDO_SUCCESS			      \
-		      : uds_assertion_failed(STRINGIFY(expr), __FILE__, __LINE__, __VA_ARGS__))
+		      : vdo_assertion_failed(STRINGIFY(expr), __FILE__, __LINE__, __VA_ARGS__))
 
 /* Log an assertion failure message. */
-int uds_assertion_failed(const char *expression_string, const char *file_name,
+int vdo_assertion_failed(const char *expression_string, const char *file_name,
 			 int line_number, const char *format, ...)
 	__printf(4, 5);
 
-- 
2.42.0

