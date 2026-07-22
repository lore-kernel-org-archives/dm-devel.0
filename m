Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A4C3446C7
	for <dm-devel@lists.linux.dev>; Wed, 22 Jul 2026 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757354; cv=none; b=gV1rGweZ47NFWscb9FaBxoFrqzMraH2RUSFOjI47xqkJhaB5NC/k4S/kpwhvXGVK6sXhV155pJstLGIfnHDuEaPGTTFsB03u9AiSaZfWrqFsFeL7K1fQUPLV5VXoGV31EiauVziGI6MF6NYiFVWf80eu3AanBFY0MlT8wEJbDeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757354; c=relaxed/simple;
	bh=vH0KEQyTLpFS/wD61R2wGRf1LdyKyQq/AVTsbcV97Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=ttGJjLSB2xWv3CQQe6bmhh05xGOqf7YzgkckXemJUo43EOSxLRxY8lvKnoX/AZPV1cZDdpPkyVNzl7m3aJDV4QgevndX38hKCgdgEXUtYUz/c36FKaBVuxYX6GqvZzr98uNa9kYDi+6fjhGV3Q+SMXjfpVo4JJ8Ki9ZCWbDvMFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zpg9iYer; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zpg9iYer"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784757350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+x/g+y3bNdi+U8FY/e4eod5WaQDzmlnFCjow6g7JruE=;
	b=Zpg9iYerecpTgLMsty7WL8Vz9EayN/pTHcNA12J4kkd3D3cGHFy/hpSjckJcBN60N/WqwT
	XDydgFlyTi3UeBihTkyZNgQ7aLWwR5UilyYm0kWSbzpY3ODduPukBcXMi9kNfqUtf3rxCz
	JRSsnyncNfJwbrnvwmAS+C6o1KxRvGw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-hTjZnOb-OpGuIwdZ8Vzv-A-1; Wed,
 22 Jul 2026 17:55:49 -0400
X-MC-Unique: hTjZnOb-OpGuIwdZ8Vzv-A-1
X-Mimecast-MFC-AGG-ID: hTjZnOb-OpGuIwdZ8Vzv-A_1784757348
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 473B1190C40B;
	Wed, 22 Jul 2026 21:55:48 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (ci-vm-10-0-103-170.hosted.upshift.rdu2.redhat.com [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD6151800361;
	Wed, 22 Jul 2026 21:55:47 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5249F21C2F; Wed, 22 Jul 2026 17:55:47 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: corwin <corwincoburn@google.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo indexer: embed geometry in parent structures
Date: Wed, 22 Jul 2026 17:55:47 -0400
Message-ID: <3c6a98876ed896bf62ae53b029ca465c1d5ac092.1784757174.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lJncvekSpT8LPWCmIWWtROSy6hnLMI7_FFjz93nfp9I_1784757348
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: corwin <corwincoburn@google.com>

Embed struct index_geometry in struct uds_configuration and struct
volume directly, eliminating the need to allocate (and free) the
geometry separately.

Signed-off-by: corwin <corwincoburn@google.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/config.c       | 34 ++++-----
 drivers/md/dm-vdo/indexer/config.h       |  2 +-
 drivers/md/dm-vdo/indexer/geometry.c     | 92 +++++++++---------------
 drivers/md/dm-vdo/indexer/geometry.h     | 13 +---
 drivers/md/dm-vdo/indexer/index-layout.c |  2 +-
 drivers/md/dm-vdo/indexer/index.c        | 30 ++++----
 drivers/md/dm-vdo/indexer/open-chapter.c |  2 +-
 drivers/md/dm-vdo/indexer/open-chapter.h |  2 +-
 drivers/md/dm-vdo/indexer/volume-index.c |  8 +--
 drivers/md/dm-vdo/indexer/volume.c       | 74 +++++++++----------
 drivers/md/dm-vdo/indexer/volume.h       |  2 +-
 11 files changed, 110 insertions(+), 151 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/config.c b/drivers/md/dm-vdo/indexer/config.c
index 4a2cc66cfd60..ccd26af37f7c 100644
--- a/drivers/md/dm-vdo/indexer/config.c
+++ b/drivers/md/dm-vdo/indexer/config.c
@@ -29,7 +29,7 @@ static bool are_matching_configurations(struct uds_configuration *saved_config,
 					struct index_geometry *saved_geometry,
 					struct uds_configuration *user)
 {
-	struct index_geometry *geometry = user->geometry;
+	const struct index_geometry *geometry = &user->geometry;
 	bool result = true;
 
 	if (saved_geometry->record_pages_per_chapter != geometry->record_pages_per_chapter) {
@@ -141,8 +141,8 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 		return UDS_CORRUPT_DATA;
 
 	if (is_version(INDEX_CONFIG_VERSION_6_02, version_buffer)) {
-		user_config->geometry->remapped_virtual = 0;
-		user_config->geometry->remapped_physical = 0;
+		user_config->geometry.remapped_virtual = 0;
+		user_config->geometry.remapped_physical = 0;
 	} else {
 		u8 remapping[sizeof(u64) + sizeof(u64)];
 
@@ -153,9 +153,9 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 
 		offset = 0;
 		decode_u64_le(remapping, &offset,
-			      &user_config->geometry->remapped_virtual);
+			      &user_config->geometry.remapped_virtual);
 		decode_u64_le(remapping, &offset,
-			      &user_config->geometry->remapped_physical);
+			      &user_config->geometry.remapped_physical);
 	}
 
 	if (!are_matching_configurations(&config, &geometry, user_config)) {
@@ -175,7 +175,7 @@ int uds_write_config_contents(struct buffered_writer *writer,
 			      struct uds_configuration *config, u32 version)
 {
 	int result;
-	struct index_geometry *geometry = config->geometry;
+	const struct index_geometry *geometry = &config->geometry;
 	u8 buffer[sizeof(struct uds_configuration_8_02)];
 	size_t offset = 0;
 
@@ -329,13 +329,10 @@ int uds_make_configuration(const struct uds_parameters *params,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_make_index_geometry(DEFAULT_BYTES_PER_PAGE, record_pages_per_chapter,
-					 chapters_per_volume, sparse_chapters_per_volume,
-					 0, 0, &config->geometry);
-	if (result != UDS_SUCCESS) {
-		uds_free_configuration(config);
-		return result;
-	}
+	config->geometry =
+		uds_init_index_geometry(DEFAULT_BYTES_PER_PAGE, record_pages_per_chapter,
+					chapters_per_volume, sparse_chapters_per_volume,
+					0, 0);
 
 	config->zone_count = normalize_zone_count(params->zone_count);
 	config->read_threads = normalize_read_threads(params->read_threads);
@@ -355,22 +352,21 @@ int uds_make_configuration(const struct uds_parameters *params,
 void uds_free_configuration(struct uds_configuration *config)
 {
 	if (config != NULL) {
-		uds_free_index_geometry(config->geometry);
 		vdo_free(config);
 	}
 }
 
 void uds_log_configuration(struct uds_configuration *config)
 {
-	struct index_geometry *geometry = config->geometry;
+	const struct index_geometry geometry = config->geometry;
 
 	vdo_log_debug("Configuration:");
-	vdo_log_debug("  Record pages per chapter:   %10u", geometry->record_pages_per_chapter);
-	vdo_log_debug("  Chapters per volume:        %10u", geometry->chapters_per_volume);
-	vdo_log_debug("  Sparse chapters per volume: %10u", geometry->sparse_chapters_per_volume);
+	vdo_log_debug("  Record pages per chapter:   %10u", geometry.record_pages_per_chapter);
+	vdo_log_debug("  Chapters per volume:        %10u", geometry.chapters_per_volume);
+	vdo_log_debug("  Sparse chapters per volume: %10u", geometry.sparse_chapters_per_volume);
 	vdo_log_debug("  Cache size (chapters):      %10u", config->cache_chapters);
 	vdo_log_debug("  Volume index mean delta:    %10u", config->volume_index_mean_delta);
-	vdo_log_debug("  Bytes per page:             %10zu", geometry->bytes_per_page);
+	vdo_log_debug("  Bytes per page:             %10zu", geometry.bytes_per_page);
 	vdo_log_debug("  Sparse sample rate:         %10u", config->sparse_sample_rate);
 	vdo_log_debug("  Nonce:                      %llu", (unsigned long long) config->nonce);
 }
diff --git a/drivers/md/dm-vdo/indexer/config.h b/drivers/md/dm-vdo/indexer/config.h
index 08507dc2f7a1..cffbf5364d16 100644
--- a/drivers/md/dm-vdo/indexer/config.h
+++ b/drivers/md/dm-vdo/indexer/config.h
@@ -37,7 +37,7 @@ struct uds_configuration {
 	/* Parameters for the volume */
 
 	/* The volume layout */
-	struct index_geometry *geometry;
+	struct index_geometry geometry;
 
 	/* Index owner's nonce */
 	u64 nonce;
diff --git a/drivers/md/dm-vdo/indexer/geometry.c b/drivers/md/dm-vdo/indexer/geometry.c
index 49f122a223d5..ae4864a64542 100644
--- a/drivers/md/dm-vdo/indexer/geometry.c
+++ b/drivers/md/dm-vdo/indexer/geometry.c
@@ -53,75 +53,51 @@
  * chapter it was moved to.
  */
 
-int uds_make_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
-			    u32 chapters_per_volume, u32 sparse_chapters_per_volume,
-			    u64 remapped_virtual, u64 remapped_physical,
-			    struct index_geometry **geometry_ptr)
+struct index_geometry uds_init_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
+					      u32 chapters_per_volume, u32 sparse_chapters_per_volume,
+					      u64 remapped_virtual, u64 remapped_physical)
 {
-	int result;
-	struct index_geometry *geometry;
-
-	result = vdo_allocate(1, "geometry", &geometry);
-	if (result != VDO_SUCCESS)
-		return result;
-
-	geometry->bytes_per_page = bytes_per_page;
-	geometry->record_pages_per_chapter = record_pages_per_chapter;
-	geometry->chapters_per_volume = chapters_per_volume;
-	geometry->sparse_chapters_per_volume = sparse_chapters_per_volume;
-	geometry->dense_chapters_per_volume = chapters_per_volume - sparse_chapters_per_volume;
-	geometry->remapped_virtual = remapped_virtual;
-	geometry->remapped_physical = remapped_physical;
-
-	geometry->records_per_page = bytes_per_page / BYTES_PER_RECORD;
-	geometry->records_per_chapter = geometry->records_per_page * record_pages_per_chapter;
-	geometry->records_per_volume = (u64) geometry->records_per_chapter * chapters_per_volume;
-
-	geometry->chapter_mean_delta = 1 << DEFAULT_CHAPTER_MEAN_DELTA_BITS;
-	geometry->chapter_payload_bits = bits_per(record_pages_per_chapter - 1);
+	struct index_geometry geometry = {
+		.bytes_per_page = bytes_per_page,
+		.record_pages_per_chapter = record_pages_per_chapter,
+		.chapters_per_volume = chapters_per_volume,
+		.sparse_chapters_per_volume = sparse_chapters_per_volume,
+		.dense_chapters_per_volume = chapters_per_volume - sparse_chapters_per_volume,
+		.remapped_virtual = remapped_virtual,
+		.remapped_physical = remapped_physical,
+	};
+	
+	geometry.records_per_page = bytes_per_page / BYTES_PER_RECORD;
+	geometry.records_per_chapter = geometry.records_per_page * record_pages_per_chapter;
+	geometry.records_per_volume = (u64) geometry.records_per_chapter * chapters_per_volume;
+
+	geometry.chapter_mean_delta = 1 << DEFAULT_CHAPTER_MEAN_DELTA_BITS;
+	geometry.chapter_payload_bits = bits_per(record_pages_per_chapter - 1);
 	/*
 	 * We want 1 delta list for every 64 records in the chapter.
 	 * The "| 077" ensures that the chapter_delta_list_bits computation
 	 * does not underflow.
 	 */
-	geometry->chapter_delta_list_bits =
-		bits_per((geometry->records_per_chapter - 1) | 077) - 6;
-	geometry->delta_lists_per_chapter = 1 << geometry->chapter_delta_list_bits;
+	geometry.chapter_delta_list_bits = bits_per((geometry.records_per_chapter - 1) | 077) - 6;
+	geometry.delta_lists_per_chapter = 1 << geometry.chapter_delta_list_bits;
 	/* We need enough address bits to achieve the desired mean delta. */
-	geometry->chapter_address_bits =
+	geometry.chapter_address_bits =
 		(DEFAULT_CHAPTER_MEAN_DELTA_BITS -
-		 geometry->chapter_delta_list_bits +
-		 bits_per(geometry->records_per_chapter - 1));
-	geometry->index_pages_per_chapter =
-		uds_get_delta_index_page_count(geometry->records_per_chapter,
-					       geometry->delta_lists_per_chapter,
-					       geometry->chapter_mean_delta,
-					       geometry->chapter_payload_bits,
+		 geometry.chapter_delta_list_bits +
+		 bits_per(geometry.records_per_chapter - 1));
+	geometry.index_pages_per_chapter =
+		uds_get_delta_index_page_count(geometry.records_per_chapter,
+					       geometry.delta_lists_per_chapter,
+					       geometry.chapter_mean_delta,
+					       geometry.chapter_payload_bits,
 					       bytes_per_page);
 
-	geometry->pages_per_chapter = geometry->index_pages_per_chapter + record_pages_per_chapter;
-	geometry->pages_per_volume = geometry->pages_per_chapter * chapters_per_volume;
-	geometry->bytes_per_volume =
-		bytes_per_page * (geometry->pages_per_volume + HEADER_PAGES_PER_VOLUME);
+	geometry.pages_per_chapter = geometry.index_pages_per_chapter + record_pages_per_chapter;
+	geometry.pages_per_volume = geometry.pages_per_chapter * chapters_per_volume;
+	geometry.bytes_per_volume =
+		bytes_per_page * (geometry.pages_per_volume + HEADER_PAGES_PER_VOLUME);
 
-	*geometry_ptr = geometry;
-	return UDS_SUCCESS;
-}
-
-int uds_copy_index_geometry(struct index_geometry *source,
-			    struct index_geometry **geometry_ptr)
-{
-	return uds_make_index_geometry(source->bytes_per_page,
-				       source->record_pages_per_chapter,
-				       source->chapters_per_volume,
-				       source->sparse_chapters_per_volume,
-				       source->remapped_virtual, source->remapped_physical,
-				       geometry_ptr);
-}
-
-void uds_free_index_geometry(struct index_geometry *geometry)
-{
-	vdo_free(geometry);
+	return geometry;
 }
 
 u32 __must_check uds_map_to_physical_chapter(const struct index_geometry *geometry,
diff --git a/drivers/md/dm-vdo/indexer/geometry.h b/drivers/md/dm-vdo/indexer/geometry.h
index a2ecdb238cf2..e311608d0de8 100644
--- a/drivers/md/dm-vdo/indexer/geometry.h
+++ b/drivers/md/dm-vdo/indexer/geometry.h
@@ -95,16 +95,9 @@ enum {
 	HEADER_PAGES_PER_VOLUME = 1,
 };
 
-int __must_check uds_make_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
-					 u32 chapters_per_volume,
-					 u32 sparse_chapters_per_volume, u64 remapped_virtual,
-					 u64 remapped_physical,
-					 struct index_geometry **geometry_ptr);
-
-int __must_check uds_copy_index_geometry(struct index_geometry *source,
-					 struct index_geometry **geometry_ptr);
-
-void uds_free_index_geometry(struct index_geometry *geometry);
+struct index_geometry uds_init_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
+					      u32 chapters_per_volume, u32 sparse_chapters_per_volume,
+					      u64 remapped_virtual, u64 remapped_physical);
 
 u32 __must_check uds_map_to_physical_chapter(const struct index_geometry *geometry,
 					     u64 virtual_chapter);
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 74b7774b4be4..a69af2ec952a 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -222,7 +222,7 @@ static int __must_check compute_sizes(const struct uds_configuration *config,
 				      struct save_layout_sizes *sls)
 {
 	int result;
-	struct index_geometry *geometry = config->geometry;
+	const struct index_geometry *geometry = &config->geometry;
 
 	memset(sls, 0, sizeof(*sls));
 	sls->save_count = MAX_SAVES;
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index 793bd32c1179..af1ab6cf5fcd 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -77,7 +77,7 @@ struct chapter_writer {
 
 static bool is_zone_chapter_sparse(const struct index_zone *zone, u64 virtual_chapter)
 {
-	return uds_is_chapter_sparse(zone->index->volume->geometry,
+	return uds_is_chapter_sparse(&zone->index->volume->geometry,
 				     zone->oldest_virtual_chapter,
 				     zone->newest_virtual_chapter, virtual_chapter);
 }
@@ -154,7 +154,7 @@ static int simulate_index_zone_barrier_message(struct index_zone *zone,
 	u64 sparse_virtual_chapter;
 
 	if ((zone->index->zone_count > 1) ||
-	    !uds_is_sparse_index_geometry(zone->index->volume->geometry))
+	    !uds_is_sparse_index_geometry(&zone->index->volume->geometry))
 		return UDS_SUCCESS;
 
 	sparse_virtual_chapter = triage_index_request(zone->index, request);
@@ -278,7 +278,7 @@ static int open_next_chapter(struct index_zone *zone)
 	}
 
 	expiring = zone->oldest_virtual_chapter;
-	expire_chapters = uds_chapters_to_expire(zone->index->volume->geometry,
+	expire_chapters = uds_chapters_to_expire(&zone->index->volume->geometry,
 						 zone->newest_virtual_chapter);
 	zone->oldest_virtual_chapter += expire_chapters;
 
@@ -353,7 +353,7 @@ static int search_sparse_cache_in_zone(struct index_zone *zone, struct uds_reque
 
 	request->virtual_chapter = virtual_chapter;
 	volume = zone->index->volume;
-	chapter = uds_map_to_physical_chapter(volume->geometry, virtual_chapter);
+	chapter = uds_map_to_physical_chapter(&volume->geometry, virtual_chapter);
 	return uds_search_cached_record_page(volume, request, chapter,
 					     record_page_number, found);
 }
@@ -470,7 +470,7 @@ static int search_index_zone(struct index_zone *zone, struct uds_request *reques
 			found = true;
 		} else if (request->location == UDS_LOCATION_UNAVAILABLE) {
 			found = false;
-		} else if (uds_is_sparse_index_geometry(zone->index->volume->geometry) &&
+		} else if (uds_is_sparse_index_geometry(&zone->index->volume->geometry) &&
 			   !uds_is_volume_index_sample(zone->index->volume_index,
 						       &request->record_name)) {
 			result = search_sparse_cache_in_zone(zone, request, NO_CHAPTER,
@@ -720,7 +720,7 @@ static void close_chapters(void *arg)
 		mutex_lock(&writer->mutex);
 		index->newest_virtual_chapter++;
 		index->oldest_virtual_chapter +=
-			uds_chapters_to_expire(index->volume->geometry,
+			uds_chapters_to_expire(&index->volume->geometry,
 					       index->newest_virtual_chapter);
 		writer->result = result;
 		writer->zones_to_write = 0;
@@ -762,7 +762,7 @@ static int make_chapter_writer(struct uds_index *index,
 	int result;
 	struct chapter_writer *writer;
 	size_t collated_records_size =
-		(sizeof(struct uds_volume_record) * index->volume->geometry->records_per_chapter);
+		(sizeof(struct uds_volume_record) * index->volume->geometry.records_per_chapter);
 
 	result = vdo_allocate_extended(index->zone_count, chapters, "Chapter Writer", &writer);
 	if (result != VDO_SUCCESS)
@@ -780,7 +780,7 @@ static int make_chapter_writer(struct uds_index *index,
 	}
 
 	result = uds_make_open_chapter_index(&writer->open_chapter_index,
-					     index->volume->geometry,
+					     &index->volume->geometry,
 					     index->volume->nonce);
 	if (result != UDS_SUCCESS) {
 		free_chapter_writer(writer);
@@ -824,7 +824,7 @@ static int rebuild_index_page_map(struct uds_index *index, u64 vcn)
 {
 	int result;
 	struct delta_index_page *chapter_index_page;
-	struct index_geometry *geometry = index->volume->geometry;
+	struct index_geometry *geometry = &index->volume->geometry;
 	u32 chapter = uds_map_to_physical_chapter(geometry, vcn);
 	u32 expected_list_number = 0;
 	u32 index_page_number;
@@ -980,7 +980,7 @@ static int replay_chapter(struct uds_index *index, u64 virtual, bool sparse)
 		return -EBUSY;
 	}
 
-	geometry = index->volume->geometry;
+	geometry = &index->volume->geometry;
 	physical_chapter = uds_map_to_physical_chapter(geometry, virtual);
 	uds_prefetch_volume_chapter(index->volume, physical_chapter);
 	uds_set_volume_index_open_chapter(index->volume_index, virtual);
@@ -1046,7 +1046,7 @@ static int replay_volume(struct uds_index *index)
 	 */
 	old_map_update = index->volume->index_page_map->last_update;
 	for (virtual = from_virtual; virtual < upto_virtual; virtual++) {
-		will_be_sparse = uds_is_chapter_sparse(index->volume->geometry,
+		will_be_sparse = uds_is_chapter_sparse(&index->volume->geometry,
 						       from_virtual, upto_virtual,
 						       virtual);
 		result = replay_chapter(index, virtual, will_be_sparse);
@@ -1073,7 +1073,7 @@ static int rebuild_index(struct uds_index *index)
 	u64 lowest;
 	u64 highest;
 	bool is_empty = false;
-	u32 chapters_per_volume = index->volume->geometry->chapters_per_volume;
+	u32 chapters_per_volume = index->volume->geometry.chapters_per_volume;
 
 	index->volume->lookup_mode = LOOKUP_FOR_REBUILD;
 	result = uds_find_volume_chapter_boundaries(index->volume, &lowest, &highest,
@@ -1125,14 +1125,14 @@ static int make_index_zone(struct uds_index *index, unsigned int zone_number)
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_make_open_chapter(index->volume->geometry, index->zone_count,
+	result = uds_make_open_chapter(&index->volume->geometry, index->zone_count,
 				       &zone->open_chapter);
 	if (result != UDS_SUCCESS) {
 		free_index_zone(zone);
 		return result;
 	}
 
-	result = uds_make_open_chapter(index->volume->geometry, index->zone_count,
+	result = uds_make_open_chapter(&index->volume->geometry, index->zone_count,
 				       &zone->writing_chapter);
 	if (result != UDS_SUCCESS) {
 		free_index_zone(zone);
@@ -1202,7 +1202,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 	index->load_context = load_context;
 	index->callback = callback;
 
-	result = initialize_index_queues(index, config->geometry);
+	result = initialize_index_queues(index, &config->geometry);
 	if (result != UDS_SUCCESS) {
 		uds_free_index(index);
 		return result;
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.c b/drivers/md/dm-vdo/indexer/open-chapter.c
index 89b91c600bfd..2977305a2b8f 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.c
+++ b/drivers/md/dm-vdo/indexer/open-chapter.c
@@ -343,7 +343,7 @@ int uds_save_open_chapter(struct uds_index *index, struct buffered_writer *write
 	return uds_flush_buffered_writer(writer);
 }
 
-u64 uds_compute_saved_open_chapter_size(struct index_geometry *geometry)
+u64 uds_compute_saved_open_chapter_size(const struct index_geometry *geometry)
 {
 	unsigned int records_per_chapter = geometry->records_per_chapter;
 
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.h b/drivers/md/dm-vdo/indexer/open-chapter.h
index ea6d7336aea0..72a776d46adc 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.h
+++ b/drivers/md/dm-vdo/indexer/open-chapter.h
@@ -74,6 +74,6 @@ int __must_check uds_save_open_chapter(struct uds_index *index,
 int __must_check uds_load_open_chapter(struct uds_index *index,
 				       struct buffered_reader *reader);
 
-u64 uds_compute_saved_open_chapter_size(struct index_geometry *geometry);
+u64 uds_compute_saved_open_chapter_size(const struct index_geometry *geometry);
 
 #endif /* UDS_OPEN_CHAPTER_H */
diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index 03c6b39ccdcc..2da4c492ace9 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -283,13 +283,13 @@ static int compute_sub_index_parameters(const struct uds_configuration *config,
 static int compute_volume_sub_index_parameters(const struct uds_configuration *config,
 					       struct sub_index_parameters *params)
 {
-	struct index_geometry *geometry = config->geometry;
+	const struct index_geometry *geometry = &config->geometry;
 	u64 sample_records;
 	u64 dense_chapters;
 	int result;
 	bool reduced = uds_is_reduced_index_geometry(geometry);
 
-	if (!uds_is_sparse_index_geometry(config->geometry)) {
+	if (!uds_is_sparse_index_geometry(&config->geometry)) {
 		return compute_sub_index_parameters(config,
 						    geometry->records_per_chapter,
 						    geometry->chapters_per_volume,
@@ -357,7 +357,7 @@ static int compute_volume_index_save_bytes(const struct uds_configuration *confi
 		return result;
 
 	*bytes = compute_volume_sub_index_save_bytes(&parameters[HOOK]);
-	if (uds_is_sparse_index_geometry(config->geometry)) {
+	if (uds_is_sparse_index_geometry(&config->geometry)) {
 		*bytes += compute_volume_sub_index_save_bytes(&parameters[NON_HOOK]);
 		*bytes += sizeof(struct volume_index_data);
 	}
@@ -1232,7 +1232,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 	if (result != UDS_SUCCESS)
 		return result;
 
-	if (!uds_is_sparse_index_geometry(config->geometry)) {
+	if (!uds_is_sparse_index_geometry(&config->geometry)) {
 		result = initialize_volume_sub_index(&parameters[DENSE], volume_nonce, 'm',
 						     &volume_index->vi_non_hook);
 		if (result != UDS_SUCCESS) {
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index af97c0cbeede..78c3729f1f65 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -83,17 +83,17 @@ union invalidate_counter {
 	};
 };
 
-static inline u32 map_to_page_number(struct index_geometry *geometry, u32 physical_page)
+static inline u32 map_to_page_number(const struct index_geometry *geometry, u32 physical_page)
 {
 	return (physical_page - HEADER_PAGES_PER_VOLUME) % geometry->pages_per_chapter;
 }
 
-static inline u32 map_to_chapter_number(struct index_geometry *geometry, u32 physical_page)
+static inline u32 map_to_chapter_number(const struct index_geometry *geometry, u32 physical_page)
 {
 	return (physical_page - HEADER_PAGES_PER_VOLUME) / geometry->pages_per_chapter;
 }
 
-static inline bool is_record_page(struct index_geometry *geometry, u32 physical_page)
+static inline bool is_record_page(const struct index_geometry *geometry, u32 physical_page)
 {
 	return map_to_page_number(geometry, physical_page) >= geometry->index_pages_per_chapter;
 }
@@ -422,7 +422,7 @@ static int init_chapter_index_page(const struct volume *volume, u8 *index_page,
 	u32 ci_chapter;
 	u32 lowest_list;
 	u32 highest_list;
-	struct index_geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = &volume->geometry;
 	int result;
 
 	result = uds_initialize_chapter_index_page(chapter_index_page, geometry,
@@ -459,8 +459,8 @@ static int init_chapter_index_page(const struct volume *volume, u8 *index_page,
 static int initialize_index_page(const struct volume *volume, u32 physical_page,
 				 struct cached_page *page)
 {
-	u32 chapter = map_to_chapter_number(volume->geometry, physical_page);
-	u32 index_page_number = map_to_page_number(volume->geometry, physical_page);
+	u32 chapter = map_to_chapter_number(&volume->geometry, physical_page);
+	u32 index_page_number = map_to_page_number(&volume->geometry, physical_page);
 
 	return init_chapter_index_page(volume, dm_bufio_get_block_data(page->buffer),
 				       chapter, index_page_number, &page->index_page);
@@ -510,16 +510,16 @@ static int search_page(struct cached_page *page, const struct volume *volume,
 	enum uds_index_region location;
 	u16 record_page_number;
 
-	if (is_record_page(volume->geometry, physical_page)) {
+	if (is_record_page(&volume->geometry, physical_page)) {
 		if (search_record_page(dm_bufio_get_block_data(page->buffer),
-				       &request->record_name, volume->geometry,
+				       &request->record_name, &volume->geometry,
 				       &request->old_metadata))
 			location = UDS_LOCATION_RECORD_PAGE_LOOKUP;
 		else
 			location = UDS_LOCATION_UNAVAILABLE;
 	} else {
 		result = uds_search_chapter_index_page(&page->index_page,
-						       volume->geometry,
+						       &volume->geometry,
 						       &request->record_name,
 						       &record_page_number);
 		if (result != UDS_SUCCESS)
@@ -571,7 +571,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 		return UDS_SUCCESS;
 	}
 
-	if (!is_record_page(volume->geometry, page_number)) {
+	if (!is_record_page(&volume->geometry, page_number)) {
 		result = initialize_index_page(volume, page_number, page);
 		if (result != UDS_SUCCESS) {
 			vdo_log_warning("Error initializing chapter index page");
@@ -708,7 +708,7 @@ static int read_page_locked(struct volume *volume, u32 physical_page,
 		return result;
 	}
 
-	if (!is_record_page(volume->geometry, physical_page)) {
+	if (!is_record_page(&volume->geometry, physical_page)) {
 		result = initialize_index_page(volume, physical_page, page);
 		if (result != UDS_SUCCESS) {
 			if (volume->lookup_mode != LOOKUP_FOR_REBUILD)
@@ -807,7 +807,7 @@ static int get_volume_page(struct volume *volume, u32 chapter, u32 page_number,
 			   struct cached_page **page_ptr)
 {
 	int result;
-	u32 physical_page = map_to_physical_page(volume->geometry, chapter, page_number);
+	u32 physical_page = map_to_physical_page(&volume->geometry, chapter, page_number);
 
 	mutex_lock(&volume->read_threads_mutex);
 	result = get_volume_page_locked(volume, physical_page, page_ptr);
@@ -850,7 +850,7 @@ static int search_cached_index_page(struct volume *volume, struct uds_request *r
 	int result;
 	struct cached_page *page = NULL;
 	unsigned int zone_number = request->zone_number;
-	u32 physical_page = map_to_physical_page(volume->geometry, chapter,
+	u32 physical_page = map_to_physical_page(&volume->geometry, chapter,
 						 index_page_number);
 
 	/*
@@ -867,7 +867,7 @@ static int search_cached_index_page(struct volume *volume, struct uds_request *r
 		return result;
 	}
 
-	result = uds_search_chapter_index_page(&page->index_page, volume->geometry,
+	result = uds_search_chapter_index_page(&page->index_page, &volume->geometry,
 					       &request->record_name,
 					       record_page_number);
 	end_pending_search(&volume->page_cache, zone_number);
@@ -882,7 +882,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 				  u32 chapter, u16 record_page_number, bool *found)
 {
 	struct cached_page *record_page;
-	struct index_geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = &volume->geometry;
 	unsigned int zone_number = request->zone_number;
 	int result;
 	u32 physical_page, page_number;
@@ -899,7 +899,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 
 	page_number = geometry->index_pages_per_chapter + record_page_number;
 
-	physical_page = map_to_physical_page(volume->geometry, chapter, page_number);
+	physical_page = map_to_physical_page(&volume->geometry, chapter, page_number);
 
 	/*
 	 * Make sure the invalidate counter is updated before we try and read the mapping. This
@@ -925,7 +925,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 
 void uds_prefetch_volume_chapter(const struct volume *volume, u32 chapter)
 {
-	const struct index_geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = &volume->geometry;
 	u32 physical_page = map_to_physical_page(geometry, chapter, 0);
 
 	dm_bufio_prefetch(volume->client, physical_page, geometry->pages_per_chapter);
@@ -937,7 +937,7 @@ int uds_read_chapter_index_from_volume(const struct volume *volume, u64 virtual_
 {
 	int result;
 	u32 i;
-	const struct index_geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = &volume->geometry;
 	u32 physical_chapter = uds_map_to_physical_chapter(geometry, virtual_chapter);
 	u32 physical_page = map_to_physical_page(geometry, physical_chapter, 0);
 
@@ -969,7 +969,7 @@ int uds_search_volume_page_cache(struct volume *volume, struct uds_request *requ
 {
 	int result;
 	u32 physical_chapter =
-		uds_map_to_physical_chapter(volume->geometry, request->virtual_chapter);
+		uds_map_to_physical_chapter(&volume->geometry, request->virtual_chapter);
 	u32 index_page_number;
 	u16 record_page_number;
 
@@ -996,7 +996,7 @@ int uds_search_volume_page_cache_for_rebuild(struct volume *volume,
 					     u64 virtual_chapter, bool *found)
 {
 	int result;
-	struct index_geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = &volume->geometry;
 	struct cached_page *page;
 	u32 physical_chapter = uds_map_to_physical_chapter(geometry, virtual_chapter);
 	u32 index_page_number;
@@ -1049,13 +1049,13 @@ static void invalidate_page(struct page_cache *cache, u32 physical_page)
 void uds_forget_chapter(struct volume *volume, u64 virtual_chapter)
 {
 	u32 physical_chapter =
-		uds_map_to_physical_chapter(volume->geometry, virtual_chapter);
-	u32 first_page = map_to_physical_page(volume->geometry, physical_chapter, 0);
+		uds_map_to_physical_chapter(&volume->geometry, virtual_chapter);
+	u32 first_page = map_to_physical_page(&volume->geometry, physical_chapter, 0);
 	u32 i;
 
 	vdo_log_debug("forgetting chapter %llu", (unsigned long long) virtual_chapter);
 	mutex_lock(&volume->read_threads_mutex);
-	for (i = 0; i < volume->geometry->pages_per_chapter; i++)
+	for (i = 0; i < volume->geometry.pages_per_chapter; i++)
 		invalidate_page(&volume->page_cache, first_page + i);
 	mutex_unlock(&volume->read_threads_mutex);
 }
@@ -1070,7 +1070,7 @@ static int donate_index_page_locked(struct volume *volume, u32 physical_chapter,
 	int result;
 	struct cached_page *page = NULL;
 	u32 physical_page =
-		map_to_physical_page(volume->geometry, physical_chapter,
+		map_to_physical_page(&volume->geometry, physical_chapter,
 				     index_page_number);
 
 	page = select_victim_in_cache(&volume->page_cache);
@@ -1097,7 +1097,7 @@ static int donate_index_page_locked(struct volume *volume, u32 physical_chapter,
 static int write_index_pages(struct volume *volume, u32 physical_chapter_number,
 			     struct open_chapter_index *chapter_index)
 {
-	struct index_geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = &volume->geometry;
 	struct dm_buffer *page_buffer;
 	u32 first_index_page = map_to_physical_page(geometry, physical_chapter_number, 0);
 	u32 delta_list_number = 0;
@@ -1184,7 +1184,7 @@ static int encode_record_page(const struct volume *volume,
 {
 	int result;
 	u32 i;
-	u32 records_per_page = volume->geometry->records_per_page;
+	u32 records_per_page = volume->geometry.records_per_page;
 	const struct uds_volume_record **record_pointers = volume->record_pointers;
 
 	for (i = 0; i < records_per_page; i++)
@@ -1208,7 +1208,7 @@ static int write_record_pages(struct volume *volume, u32 physical_chapter_number
 			      const struct uds_volume_record *records)
 {
 	u32 record_page_number;
-	struct index_geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = &volume->geometry;
 	struct dm_buffer *page_buffer;
 	const struct uds_volume_record *next_record = records;
 	u32 first_record_page = map_to_physical_page(geometry, physical_chapter_number,
@@ -1248,7 +1248,7 @@ int uds_write_chapter(struct volume *volume, struct open_chapter_index *chapter_
 {
 	int result;
 	u32 physical_chapter_number =
-		uds_map_to_physical_chapter(volume->geometry,
+		uds_map_to_physical_chapter(&volume->geometry,
 					    chapter_index->virtual_chapter_number);
 
 	result = write_index_pages(volume, physical_chapter_number, chapter_index);
@@ -1269,7 +1269,7 @@ int uds_write_chapter(struct volume *volume, struct open_chapter_index *chapter_
 static void probe_chapter(struct volume *volume, u32 chapter_number,
 			  u64 *virtual_chapter_number)
 {
-	const struct index_geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = &volume->geometry;
 	u32 expected_list_number = 0;
 	u32 i;
 	u64 vcn = BAD_CHAPTER;
@@ -1353,7 +1353,7 @@ static void find_real_end_of_volume(struct volume *volume, u32 limit, u32 *limit
 static int find_chapter_limits(struct volume *volume, u32 chapter_limit, u64 *lowest_vcn,
 			       u64 *highest_vcn)
 {
-	struct index_geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = &volume->geometry;
 	u64 zero_vcn;
 	u64 lowest = BAD_CHAPTER;
 	u64 highest = BAD_CHAPTER;
@@ -1451,7 +1451,7 @@ static int find_chapter_limits(struct volume *volume, u32 chapter_limit, u64 *lo
 int uds_find_volume_chapter_boundaries(struct volume *volume, u64 *lowest_vcn,
 				       u64 *highest_vcn, bool *is_empty)
 {
-	u32 chapter_limit = volume->geometry->chapters_per_volume;
+	u32 chapter_limit = volume->geometry.chapters_per_volume;
 
 	find_real_end_of_volume(volume, chapter_limit, &chapter_limit);
 	if (chapter_limit == 0) {
@@ -1486,7 +1486,7 @@ int __must_check uds_replace_volume_storage(struct volume *volume,
 	if (volume->client != NULL)
 		dm_bufio_client_destroy(vdo_forget(volume->client));
 
-	return uds_open_volume_bufio(layout, volume->geometry->bytes_per_page,
+	return uds_open_volume_bufio(layout, volume->geometry.bytes_per_page,
 				     volume->reserved_buffers, &volume->client);
 }
 
@@ -1552,13 +1552,8 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 
 	volume->nonce = uds_get_volume_nonce(layout);
 
-	result = uds_copy_index_geometry(config->geometry, &volume->geometry);
-	if (result != UDS_SUCCESS) {
-		uds_free_volume(volume);
-		return vdo_log_warning_strerror(result,
-						"failed to allocate geometry: error");
-	}
-	geometry = volume->geometry;
+	volume->geometry = config->geometry;
+	geometry = &volume->geometry;
 
 	/*
 	 * Reserve a buffer for each entry in the page cache, one for the chapter writer, and one
@@ -1685,7 +1680,6 @@ void uds_free_volume(struct volume *volume)
 
 	uds_free_index_page_map(volume->index_page_map);
 	uds_free_radix_sorter(volume->radix_sorter);
-	vdo_free(volume->geometry);
 	vdo_free(volume->record_pointers);
 	vdo_free(volume);
 }
diff --git a/drivers/md/dm-vdo/indexer/volume.h b/drivers/md/dm-vdo/indexer/volume.h
index 8679a5e55347..0cba3146688d 100644
--- a/drivers/md/dm-vdo/indexer/volume.h
+++ b/drivers/md/dm-vdo/indexer/volume.h
@@ -97,7 +97,7 @@ struct page_cache {
 };
 
 struct volume {
-	struct index_geometry *geometry;
+	struct index_geometry geometry;
 	struct dm_bufio_client *client;
 	u64 nonce;
 	size_t cache_size;
-- 
2.53.0

