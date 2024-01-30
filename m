Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A256F2C85F
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706575912; cv=none; b=BuT08jsucqM4oHDWHIqyYohRW4bNuqSggFBYGDHhnRYLSn+6tI9AiEd56e67RZsKCY4ail8Dpq3HZSeE/cONkWZUldP31X5qZML1zTDwQHds3zUDmgggzSxYBqpzZECMJju2Co7NQCrLgHlUVesED7odLyjlnFNP32KH5Txu+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706575912; c=relaxed/simple;
	bh=Soj71Sr0G2kAx/8jcvzvbwiD744cPdJ+o3RTqdqmxvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ti83TxMtPprTLu3g4kH3BJblrsadvWZ6owgNjBZK6YEqzNZn8xAPKpmApH/pX50+K90jNI+tHZHPUYiqnLejmgRvoNRvQlk3Z0iROk1otKEPYbBKeE/CreXhNqkwJvi0ZqiIiXc7NuXZQYMX4KQuceccsuTBe9QL1/gUCRAA3uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QUOMjlc9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QUOMjlc9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706575908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/0uJWdjSV9ErrYWMgfOIZPTYWE3VlNoH2L2PaybgbBg=;
	b=QUOMjlc9aCyuvK+Tq89+Pprg/kFoSm5Iv6pmmyTfiDMBuitMaU2WEQ9yVL2kCzIS0oLA8e
	Jse3ggDEq8dYffPgr3rKqRAMTl3CS7OMS25hXLnYD8MQAgpAg0oW7kOgesx1S9FX8en83o
	zG/SINi0vJ9v+l/kvMnmxI6ULtvgMMw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-lpB1X4w9MtqqOR9FkM0YPw-1; Mon, 29 Jan 2024 19:51:47 -0500
X-MC-Unique: lpB1X4w9MtqqOR9FkM0YPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D978185A782;
	Tue, 30 Jan 2024 00:51:47 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16D051121313;
	Tue, 30 Jan 2024 00:51:47 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 1056A56372; Mon, 29 Jan 2024 19:51:47 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo: rename struct geometry to index_geometry
Date: Mon, 29 Jan 2024 19:51:45 -0500
Message-ID: <961f6261a6ba42deb747d2a96af398ce1dbc49ea.1706575731.git.msakai@redhat.com>
In-Reply-To: <cover.1706575731.git.msakai@redhat.com>
References: <cover.1706575731.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/chapter-index.c  | 14 ++++----
 drivers/md/dm-vdo/chapter-index.h  | 10 +++---
 drivers/md/dm-vdo/config.c         | 18 +++++-----
 drivers/md/dm-vdo/config.h         |  2 +-
 drivers/md/dm-vdo/geometry.c       | 57 +++++++++++++++---------------
 drivers/md/dm-vdo/geometry.h       | 40 +++++++++++----------
 drivers/md/dm-vdo/hash-utils.h     |  4 +--
 drivers/md/dm-vdo/index-layout.c   |  2 +-
 drivers/md/dm-vdo/index-page-map.c |  6 ++--
 drivers/md/dm-vdo/index-page-map.h |  6 ++--
 drivers/md/dm-vdo/index.c          | 12 +++----
 drivers/md/dm-vdo/open-chapter.c   |  4 +--
 drivers/md/dm-vdo/open-chapter.h   |  4 +--
 drivers/md/dm-vdo/sparse-cache.c   |  8 ++---
 drivers/md/dm-vdo/sparse-cache.h   |  2 +-
 drivers/md/dm-vdo/volume-index.c   | 12 +++----
 drivers/md/dm-vdo/volume.c         | 38 ++++++++++----------
 drivers/md/dm-vdo/volume.h         |  2 +-
 18 files changed, 121 insertions(+), 120 deletions(-)

diff --git a/drivers/md/dm-vdo/chapter-index.c b/drivers/md/dm-vdo/chapter-index.c
index 27a2d95a2bef..7285a842e888 100644
--- a/drivers/md/dm-vdo/chapter-index.c
+++ b/drivers/md/dm-vdo/chapter-index.c
@@ -13,7 +13,7 @@
 #include "uds.h"
 
 int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
-				const struct geometry *geometry, u64 volume_nonce)
+				const struct index_geometry *geometry, u64 volume_nonce)
 {
 	int result;
 	size_t memory_size;
@@ -79,7 +79,7 @@ int uds_put_open_chapter_index_record(struct open_chapter_index *chapter_index,
 	u32 list_number;
 	const u8 *found_name;
 	bool found;
-	const struct geometry *geometry = chapter_index->geometry;
+	const struct index_geometry *geometry = chapter_index->geometry;
 	u64 chapter_number = chapter_index->virtual_chapter_number;
 	u32 record_pages = geometry->record_pages_per_chapter;
 
@@ -128,7 +128,7 @@ int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
 	struct delta_index_stats stats;
 	u64 nonce = chapter_index->volume_nonce;
 	u64 chapter_number = chapter_index->virtual_chapter_number;
-	const struct geometry *geometry = chapter_index->geometry;
+	const struct index_geometry *geometry = chapter_index->geometry;
 	u32 list_count = geometry->delta_lists_per_chapter;
 	unsigned int removals = 0;
 	struct delta_index_entry entry;
@@ -206,8 +206,8 @@ int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
 
 /* Make a new chapter index page, initializing it with the data from a given index_page buffer. */
 int uds_initialize_chapter_index_page(struct delta_index_page *index_page,
-				      const struct geometry *geometry, u8 *page_buffer,
-				      u64 volume_nonce)
+				      const struct index_geometry *geometry,
+				      u8 *page_buffer, u64 volume_nonce)
 {
 	return uds_initialize_delta_index_page(index_page, volume_nonce,
 					       geometry->chapter_mean_delta,
@@ -217,7 +217,7 @@ int uds_initialize_chapter_index_page(struct delta_index_page *index_page,
 
 /* Validate a chapter index page read during rebuild. */
 int uds_validate_chapter_index_page(const struct delta_index_page *index_page,
-				    const struct geometry *geometry)
+				    const struct index_geometry *geometry)
 {
 	int result;
 	const struct delta_index *delta_index = &index_page->delta_index;
@@ -266,7 +266,7 @@ int uds_validate_chapter_index_page(const struct delta_index_page *index_page,
  * the name.
  */
 int uds_search_chapter_index_page(struct delta_index_page *index_page,
-				  const struct geometry *geometry,
+				  const struct index_geometry *geometry,
 				  const struct uds_record_name *name,
 				  u16 *record_page_ptr)
 {
diff --git a/drivers/md/dm-vdo/chapter-index.h b/drivers/md/dm-vdo/chapter-index.h
index ad1f61b6ab9a..e1bc7e31a2a5 100644
--- a/drivers/md/dm-vdo/chapter-index.h
+++ b/drivers/md/dm-vdo/chapter-index.h
@@ -24,7 +24,7 @@ enum {
 };
 
 struct open_chapter_index {
-	const struct geometry *geometry;
+	const struct index_geometry *geometry;
 	struct delta_index delta_index;
 	u64 virtual_chapter_number;
 	u64 volume_nonce;
@@ -32,7 +32,7 @@ struct open_chapter_index {
 };
 
 int __must_check uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
-					     const struct geometry *geometry,
+					     const struct index_geometry *geometry,
 					     u64 volume_nonce);
 
 void uds_free_open_chapter_index(struct open_chapter_index *chapter_index);
@@ -49,14 +49,14 @@ int __must_check uds_pack_open_chapter_index_page(struct open_chapter_index *cha
 						  bool last_page, u32 *lists_packed);
 
 int __must_check uds_initialize_chapter_index_page(struct delta_index_page *index_page,
-						   const struct geometry *geometry,
+						   const struct index_geometry *geometry,
 						   u8 *page_buffer, u64 volume_nonce);
 
 int __must_check uds_validate_chapter_index_page(const struct delta_index_page *index_page,
-						 const struct geometry *geometry);
+						 const struct index_geometry *geometry);
 
 int __must_check uds_search_chapter_index_page(struct delta_index_page *index_page,
-					       const struct geometry *geometry,
+					       const struct index_geometry *geometry,
 					       const struct uds_record_name *name,
 					       u16 *record_page_ptr);
 
diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/config.c
index 96e27aeecc25..cd5c36de6e2b 100644
--- a/drivers/md/dm-vdo/config.c
+++ b/drivers/md/dm-vdo/config.c
@@ -28,10 +28,10 @@ static bool is_version(const u8 *version, u8 *buffer)
 }
 
 static bool are_matching_configurations(struct configuration *saved_config,
-					struct geometry *saved_geometry,
+					struct index_geometry *saved_geometry,
 					struct configuration *user)
 {
-	struct geometry *geometry = user->geometry;
+	struct index_geometry *geometry = user->geometry;
 	bool result = true;
 
 	if (saved_geometry->record_pages_per_chapter != geometry->record_pages_per_chapter) {
@@ -97,7 +97,7 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 {
 	int result;
 	struct configuration config;
-	struct geometry geometry;
+	struct index_geometry geometry;
 	u8 version_buffer[INDEX_CONFIG_VERSION_LENGTH];
 	u32 bytes_per_page;
 	u8 buffer[sizeof(struct uds_configuration_6_02)];
@@ -177,7 +177,7 @@ int uds_write_config_contents(struct buffered_writer *writer,
 			      struct configuration *config, u32 version)
 {
 	int result;
-	struct geometry *geometry = config->geometry;
+	struct index_geometry *geometry = config->geometry;
 	u8 buffer[sizeof(struct uds_configuration_8_02)];
 	size_t offset = 0;
 
@@ -331,9 +331,9 @@ int uds_make_configuration(const struct uds_parameters *params,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_make_geometry(DEFAULT_BYTES_PER_PAGE, record_pages_per_chapter,
-				   chapters_per_volume, sparse_chapters_per_volume, 0, 0,
-				   &config->geometry);
+	result = uds_make_index_geometry(DEFAULT_BYTES_PER_PAGE, record_pages_per_chapter,
+					 chapters_per_volume, sparse_chapters_per_volume,
+					 0, 0, &config->geometry);
 	if (result != UDS_SUCCESS) {
 		uds_free_configuration(config);
 		return result;
@@ -357,14 +357,14 @@ int uds_make_configuration(const struct uds_parameters *params,
 void uds_free_configuration(struct configuration *config)
 {
 	if (config != NULL) {
-		uds_free_geometry(config->geometry);
+		uds_free_index_geometry(config->geometry);
 		uds_free(config);
 	}
 }
 
 void uds_log_configuration(struct configuration *config)
 {
-	struct geometry *geometry = config->geometry;
+	struct index_geometry *geometry = config->geometry;
 
 	uds_log_debug("Configuration:");
 	uds_log_debug("  Record pages per chapter:   %10u", geometry->record_pages_per_chapter);
diff --git a/drivers/md/dm-vdo/config.h b/drivers/md/dm-vdo/config.h
index 72430d47f983..b79fe833d825 100644
--- a/drivers/md/dm-vdo/config.h
+++ b/drivers/md/dm-vdo/config.h
@@ -37,7 +37,7 @@ struct configuration {
 	/* Parameters for the volume */
 
 	/* The volume layout */
-	struct geometry *geometry;
+	struct index_geometry *geometry;
 
 	/* Index owner's nonce */
 	u64 nonce;
diff --git a/drivers/md/dm-vdo/geometry.c b/drivers/md/dm-vdo/geometry.c
index 1ebbef75f842..0e83bba4184a 100644
--- a/drivers/md/dm-vdo/geometry.c
+++ b/drivers/md/dm-vdo/geometry.c
@@ -52,18 +52,15 @@
  * chapter it was moved to.
  */
 
-int uds_make_geometry(size_t bytes_per_page,
-		      u32 record_pages_per_chapter,
-		      u32 chapters_per_volume,
-		      u32 sparse_chapters_per_volume,
-		      u64 remapped_virtual,
-		      u64 remapped_physical,
-		      struct geometry **geometry_ptr)
+int uds_make_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
+			    u32 chapters_per_volume, u32 sparse_chapters_per_volume,
+			    u64 remapped_virtual, u64 remapped_physical,
+			    struct index_geometry **geometry_ptr)
 {
 	int result;
-	struct geometry *geometry;
+	struct index_geometry *geometry;
 
-	result = uds_allocate(1, struct geometry, "geometry", &geometry);
+	result = uds_allocate(1, struct index_geometry, "geometry", &geometry);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -110,27 +107,28 @@ int uds_make_geometry(size_t bytes_per_page,
 	return UDS_SUCCESS;
 }
 
-int uds_copy_geometry(struct geometry *source, struct geometry **geometry_ptr)
+int uds_copy_index_geometry(struct index_geometry *source,
+			    struct index_geometry **geometry_ptr)
 {
-	return uds_make_geometry(source->bytes_per_page,
-				 source->record_pages_per_chapter,
-				 source->chapters_per_volume,
-				 source->sparse_chapters_per_volume,
-				 source->remapped_virtual, source->remapped_physical,
-				 geometry_ptr);
+	return uds_make_index_geometry(source->bytes_per_page,
+				       source->record_pages_per_chapter,
+				       source->chapters_per_volume,
+				       source->sparse_chapters_per_volume,
+				       source->remapped_virtual, source->remapped_physical,
+				       geometry_ptr);
 }
 
-void uds_free_geometry(struct geometry *geometry)
+void uds_free_index_geometry(struct index_geometry *geometry)
 {
 	uds_free(geometry);
 }
 
-u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry,
+u32 __must_check uds_map_to_physical_chapter(const struct index_geometry *geometry,
 					     u64 virtual_chapter)
 {
 	u64 delta;
 
-	if (!uds_is_reduced_geometry(geometry))
+	if (!uds_is_reduced_index_geometry(geometry))
 		return virtual_chapter % geometry->chapters_per_volume;
 
 	if (likely(virtual_chapter > geometry->remapped_virtual)) {
@@ -153,25 +151,26 @@ u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry,
 }
 
 /* Check whether any sparse chapters are in use. */
-bool uds_has_sparse_chapters(const struct geometry *geometry, u64 oldest_virtual_chapter,
-			     u64 newest_virtual_chapter)
+bool uds_has_sparse_chapters(const struct index_geometry *geometry,
+			     u64 oldest_virtual_chapter, u64 newest_virtual_chapter)
 {
-	return uds_is_sparse_geometry(geometry) &&
-	       ((newest_virtual_chapter - oldest_virtual_chapter + 1) >
-		geometry->dense_chapters_per_volume);
+	return uds_is_sparse_index_geometry(geometry) &&
+		((newest_virtual_chapter - oldest_virtual_chapter + 1) >
+		 geometry->dense_chapters_per_volume);
 }
 
-bool uds_is_chapter_sparse(const struct geometry *geometry, u64 oldest_virtual_chapter,
-			   u64 newest_virtual_chapter, u64 virtual_chapter_number)
+bool uds_is_chapter_sparse(const struct index_geometry *geometry,
+			   u64 oldest_virtual_chapter, u64 newest_virtual_chapter,
+			   u64 virtual_chapter_number)
 {
 	return uds_has_sparse_chapters(geometry, oldest_virtual_chapter,
 				       newest_virtual_chapter) &&
-	       ((virtual_chapter_number + geometry->dense_chapters_per_volume) <=
-		newest_virtual_chapter);
+		((virtual_chapter_number + geometry->dense_chapters_per_volume) <=
+		 newest_virtual_chapter);
 }
 
 /* Calculate how many chapters to expire after opening the newest chapter. */
-u32 uds_chapters_to_expire(const struct geometry *geometry, u64 newest_chapter)
+u32 uds_chapters_to_expire(const struct index_geometry *geometry, u64 newest_chapter)
 {
 	/* If the index isn't full yet, don't expire anything. */
 	if (newest_chapter < geometry->chapters_per_volume)
diff --git a/drivers/md/dm-vdo/geometry.h b/drivers/md/dm-vdo/geometry.h
index cff69087cd79..9a4a66ac2e46 100644
--- a/drivers/md/dm-vdo/geometry.h
+++ b/drivers/md/dm-vdo/geometry.h
@@ -3,18 +3,18 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_GEOMETRY_H
-#define UDS_GEOMETRY_H
+#ifndef UDS_INDEX_GEOMETRY_H
+#define UDS_INDEX_GEOMETRY_H
 
 #include "uds.h"
 
 /*
- * The geometry records parameters that define the layout of a UDS index volume, and the size and
+ * The index_geometry records parameters that define the layout of a UDS index volume, and the size and
  * shape of various index structures. It is created when the index is created, and is referenced by
  * many index sub-components.
  */
 
-struct geometry {
+struct index_geometry {
 	/* Size of a chapter page, in bytes */
 	size_t bytes_per_page;
 	/* Number of record pages in a chapter */
@@ -95,44 +95,46 @@ enum {
 	HEADER_PAGES_PER_VOLUME = 1,
 };
 
-int __must_check uds_make_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
-				   u32 chapters_per_volume,
-				   u32 sparse_chapters_per_volume, u64 remapped_virtual,
-				   u64 remapped_physical,
-				   struct geometry **geometry_ptr);
+int __must_check uds_make_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
+					 u32 chapters_per_volume,
+					 u32 sparse_chapters_per_volume, u64 remapped_virtual,
+					 u64 remapped_physical,
+					 struct index_geometry **geometry_ptr);
 
-int __must_check uds_copy_geometry(struct geometry *source,
-				   struct geometry **geometry_ptr);
+int __must_check uds_copy_index_geometry(struct index_geometry *source,
+					 struct index_geometry **geometry_ptr);
 
-void uds_free_geometry(struct geometry *geometry);
+void uds_free_index_geometry(struct index_geometry *geometry);
 
-u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry,
+u32 __must_check uds_map_to_physical_chapter(const struct index_geometry *geometry,
 					     u64 virtual_chapter);
 
 /*
  * Check whether this geometry is reduced by a chapter. This will only be true if the volume was
  * converted from a non-lvm volume to an lvm volume.
  */
-static inline bool __must_check uds_is_reduced_geometry(const struct geometry *geometry)
+static inline bool __must_check
+uds_is_reduced_index_geometry(const struct index_geometry *geometry)
 {
 	return !!(geometry->chapters_per_volume & 1);
 }
 
-static inline bool __must_check uds_is_sparse_geometry(const struct geometry *geometry)
+static inline bool __must_check
+uds_is_sparse_index_geometry(const struct index_geometry *geometry)
 {
 	return geometry->sparse_chapters_per_volume > 0;
 }
 
-bool __must_check uds_has_sparse_chapters(const struct geometry *geometry,
+bool __must_check uds_has_sparse_chapters(const struct index_geometry *geometry,
 					  u64 oldest_virtual_chapter,
 					  u64 newest_virtual_chapter);
 
-bool __must_check uds_is_chapter_sparse(const struct geometry *geometry,
+bool __must_check uds_is_chapter_sparse(const struct index_geometry *geometry,
 					u64 oldest_virtual_chapter,
 					u64 newest_virtual_chapter,
 					u64 virtual_chapter_number);
 
-u32 __must_check uds_chapters_to_expire(const struct geometry *geometry,
+u32 __must_check uds_chapters_to_expire(const struct index_geometry *geometry,
 					u64 newest_chapter);
 
-#endif /* UDS_GEOMETRY_H */
+#endif /* UDS_INDEX_GEOMETRY_H */
diff --git a/drivers/md/dm-vdo/hash-utils.h b/drivers/md/dm-vdo/hash-utils.h
index 9ee729c14f2e..e22be69695be 100644
--- a/drivers/md/dm-vdo/hash-utils.h
+++ b/drivers/md/dm-vdo/hash-utils.h
@@ -43,7 +43,7 @@ static inline u32 uds_extract_sampling_bytes(const struct uds_record_name *name)
 
 /* Compute the chapter delta list for a given name. */
 static inline u32 uds_hash_to_chapter_delta_list(const struct uds_record_name *name,
-						 const struct geometry *geometry)
+						 const struct index_geometry *geometry)
 {
 	return ((uds_extract_chapter_index_bytes(name) >> geometry->chapter_address_bits) &
 		((1 << geometry->chapter_delta_list_bits) - 1));
@@ -51,7 +51,7 @@ static inline u32 uds_hash_to_chapter_delta_list(const struct uds_record_name *n
 
 /* Compute the chapter delta address for a given name. */
 static inline u32 uds_hash_to_chapter_delta_address(const struct uds_record_name *name,
-						    const struct geometry *geometry)
+						    const struct index_geometry *geometry)
 {
 	return uds_extract_chapter_index_bytes(name) & ((1 << geometry->chapter_address_bits) - 1);
 }
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
index f0511988ea07..bc67720659e7 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -226,7 +226,7 @@ static int __must_check compute_sizes(const struct configuration *config,
 				      struct save_layout_sizes *sls)
 {
 	int result;
-	struct geometry *geometry = config->geometry;
+	struct index_geometry *geometry = config->geometry;
 
 	memset(sls, 0, sizeof(*sls));
 	sls->save_count = MAX_SAVES;
diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/index-page-map.c
index acfff74f37bc..f3748a915c03 100644
--- a/drivers/md/dm-vdo/index-page-map.c
+++ b/drivers/md/dm-vdo/index-page-map.c
@@ -28,12 +28,12 @@ enum {
 	PAGE_MAP_MAGIC_LENGTH = sizeof(PAGE_MAP_MAGIC) - 1,
 };
 
-static inline u32 get_entry_count(const struct geometry *geometry)
+static inline u32 get_entry_count(const struct index_geometry *geometry)
 {
 	return geometry->chapters_per_volume * (geometry->index_pages_per_chapter - 1);
 }
 
-int uds_make_index_page_map(const struct geometry *geometry,
+int uds_make_index_page_map(const struct index_geometry *geometry,
 			    struct index_page_map **map_ptr)
 {
 	int result;
@@ -106,7 +106,7 @@ void uds_get_list_number_bounds(const struct index_page_map *map, u32 chapter_nu
 			 map->geometry->delta_lists_per_chapter - 1);
 }
 
-u64 uds_compute_index_page_map_save_size(const struct geometry *geometry)
+u64 uds_compute_index_page_map_save_size(const struct index_geometry *geometry)
 {
 	return PAGE_MAP_MAGIC_LENGTH + sizeof(u64) + sizeof(u16) * get_entry_count(geometry);
 }
diff --git a/drivers/md/dm-vdo/index-page-map.h b/drivers/md/dm-vdo/index-page-map.h
index 51ac9b81362f..b327c0bb9656 100644
--- a/drivers/md/dm-vdo/index-page-map.h
+++ b/drivers/md/dm-vdo/index-page-map.h
@@ -16,13 +16,13 @@
  */
 
 struct index_page_map {
-	const struct geometry *geometry;
+	const struct index_geometry *geometry;
 	u64 last_update;
 	u32 entries_per_chapter;
 	u16 *entries;
 };
 
-int __must_check uds_make_index_page_map(const struct geometry *geometry,
+int __must_check uds_make_index_page_map(const struct index_geometry *geometry,
 					 struct index_page_map **map_ptr);
 
 void uds_free_index_page_map(struct index_page_map *map);
@@ -45,6 +45,6 @@ void uds_get_list_number_bounds(const struct index_page_map *map, u32 chapter_nu
 				u32 index_page_number, u32 *lowest_list,
 				u32 *highest_list);
 
-u64 uds_compute_index_page_map_save_size(const struct geometry *geometry);
+u64 uds_compute_index_page_map_save_size(const struct index_geometry *geometry);
 
 #endif /* UDS_INDEX_PAGE_MAP_H */
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index 3d2a673b3f52..cf7cdc909a31 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -153,7 +153,7 @@ static int simulate_index_zone_barrier_message(struct index_zone *zone,
 	u64 sparse_virtual_chapter;
 
 	if ((zone->index->zone_count > 1) ||
-	    !uds_is_sparse_geometry(zone->index->volume->geometry))
+	    !uds_is_sparse_index_geometry(zone->index->volume->geometry))
 		return UDS_SUCCESS;
 
 	sparse_virtual_chapter = triage_index_request(zone->index, request);
@@ -472,7 +472,7 @@ static int search_index_zone(struct index_zone *zone, struct uds_request *reques
 			found = true;
 		} else if (request->location == UDS_LOCATION_UNAVAILABLE) {
 			found = false;
-		} else if (uds_is_sparse_geometry(zone->index->volume->geometry) &&
+		} else if (uds_is_sparse_index_geometry(zone->index->volume->geometry) &&
 			   !uds_is_volume_index_sample(zone->index->volume_index,
 						       &request->record_name)) {
 			result = search_sparse_cache_in_zone(zone, request, NO_CHAPTER,
@@ -647,7 +647,7 @@ static void execute_zone_request(struct uds_request *request)
 }
 
 static int initialize_index_queues(struct uds_index *index,
-				   const struct geometry *geometry)
+				   const struct index_geometry *geometry)
 {
 	int result;
 	unsigned int i;
@@ -660,7 +660,7 @@ static int initialize_index_queues(struct uds_index *index,
 	}
 
 	/* The triage queue is only needed for sparse multi-zone indexes. */
-	if ((index->zone_count > 1) && uds_is_sparse_geometry(geometry)) {
+	if ((index->zone_count > 1) && uds_is_sparse_index_geometry(geometry)) {
 		result = uds_make_request_queue("triageW", &triage_request,
 						&index->triage_queue);
 		if (result != UDS_SUCCESS)
@@ -840,7 +840,7 @@ static int rebuild_index_page_map(struct uds_index *index, u64 vcn)
 {
 	int result;
 	struct delta_index_page *chapter_index_page;
-	struct geometry *geometry = index->volume->geometry;
+	struct index_geometry *geometry = index->volume->geometry;
 	u32 chapter = uds_map_to_physical_chapter(geometry, vcn);
 	u32 expected_list_number = 0;
 	u32 index_page_number;
@@ -987,7 +987,7 @@ static int replay_chapter(struct uds_index *index, u64 virtual, bool sparse)
 	int result;
 	u32 i;
 	u32 j;
-	const struct geometry *geometry;
+	const struct index_geometry *geometry;
 	u32 physical_chapter;
 
 	if (check_for_suspend(index)) {
diff --git a/drivers/md/dm-vdo/open-chapter.c b/drivers/md/dm-vdo/open-chapter.c
index 45cec2c3edb2..d9d6e5d45bfb 100644
--- a/drivers/md/dm-vdo/open-chapter.c
+++ b/drivers/md/dm-vdo/open-chapter.c
@@ -61,7 +61,7 @@ static inline size_t slots_size(size_t slot_count)
 	return sizeof(struct open_chapter_zone_slot) * slot_count;
 }
 
-int uds_make_open_chapter(const struct geometry *geometry, unsigned int zone_count,
+int uds_make_open_chapter(const struct index_geometry *geometry, unsigned int zone_count,
 			  struct open_chapter_zone **open_chapter_ptr)
 {
 	int result;
@@ -346,7 +346,7 @@ int uds_save_open_chapter(struct uds_index *index, struct buffered_writer *write
 	return uds_flush_buffered_writer(writer);
 }
 
-u64 uds_compute_saved_open_chapter_size(struct geometry *geometry)
+u64 uds_compute_saved_open_chapter_size(struct index_geometry *geometry)
 {
 	unsigned int records_per_chapter = geometry->records_per_chapter;
 
diff --git a/drivers/md/dm-vdo/open-chapter.h b/drivers/md/dm-vdo/open-chapter.h
index eb11d897f20a..a4250bb19525 100644
--- a/drivers/md/dm-vdo/open-chapter.h
+++ b/drivers/md/dm-vdo/open-chapter.h
@@ -43,7 +43,7 @@ struct open_chapter_zone {
 	struct open_chapter_zone_slot slots[];
 };
 
-int __must_check uds_make_open_chapter(const struct geometry *geometry,
+int __must_check uds_make_open_chapter(const struct index_geometry *geometry,
 				       unsigned int zone_count,
 				       struct open_chapter_zone **open_chapter_ptr);
 
@@ -74,6 +74,6 @@ int __must_check uds_save_open_chapter(struct uds_index *index,
 int __must_check uds_load_open_chapter(struct uds_index *index,
 				       struct buffered_reader *reader);
 
-u64 uds_compute_saved_open_chapter_size(struct geometry *geometry);
+u64 uds_compute_saved_open_chapter_size(struct index_geometry *geometry);
 
 #endif /* UDS_OPEN_CHAPTER_H */
diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
index f80cde3f93ee..5b41c94f53fa 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -142,7 +142,7 @@ struct search_list {
 };
 
 struct sparse_cache {
-	const struct geometry *geometry;
+	const struct index_geometry *geometry;
 	unsigned int capacity;
 	unsigned int zone_count;
 
@@ -157,7 +157,7 @@ struct sparse_cache {
 };
 
 static int __must_check initialize_cached_chapter_index(struct cached_chapter_index *chapter,
-							const struct geometry *geometry)
+							const struct index_geometry *geometry)
 {
 	int result;
 
@@ -197,7 +197,7 @@ static int __must_check make_search_list(struct sparse_cache *cache,
 	return UDS_SUCCESS;
 }
 
-int uds_make_sparse_cache(const struct geometry *geometry, unsigned int capacity,
+int uds_make_sparse_cache(const struct index_geometry *geometry, unsigned int capacity,
 			  unsigned int zone_count, struct sparse_cache **cache_ptr)
 {
 	int result;
@@ -512,7 +512,7 @@ static inline bool should_skip_chapter(struct cached_chapter_index *chapter,
 }
 
 static int __must_check search_cached_chapter_index(struct cached_chapter_index *chapter,
-						    const struct geometry *geometry,
+						    const struct index_geometry *geometry,
 						    const struct index_page_map *index_page_map,
 						    const struct uds_record_name *name,
 						    u16 *record_page_ptr)
diff --git a/drivers/md/dm-vdo/sparse-cache.h b/drivers/md/dm-vdo/sparse-cache.h
index 522027395cba..90b0be155453 100644
--- a/drivers/md/dm-vdo/sparse-cache.h
+++ b/drivers/md/dm-vdo/sparse-cache.h
@@ -26,7 +26,7 @@
 struct index_zone;
 struct sparse_cache;
 
-int __must_check uds_make_sparse_cache(const struct geometry *geometry,
+int __must_check uds_make_sparse_cache(const struct index_geometry *geometry,
 				       unsigned int capacity, unsigned int zone_count,
 				       struct sparse_cache **cache_ptr);
 
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index 11dceef0ab60..0f4b9510e7ea 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -81,11 +81,11 @@ struct sub_index_parameters {
 struct split_config {
 	/* The hook subindex configuration */
 	struct configuration hook_config;
-	struct geometry hook_geometry;
+	struct index_geometry hook_geometry;
 
 	/* The non-hook subindex configuration */
 	struct configuration non_hook_config;
-	struct geometry non_hook_geometry;
+	struct index_geometry non_hook_geometry;
 };
 
 struct chapter_range {
@@ -204,7 +204,7 @@ static int compute_volume_sub_index_parameters(const struct configuration *confi
 	u64 index_size_in_bits;
 	size_t expected_index_size;
 	u64 min_delta_lists = MAX_ZONES * MAX_ZONES;
-	struct geometry *geometry = config->geometry;
+	struct index_geometry *geometry = config->geometry;
 	u64 records_per_chapter = geometry->records_per_chapter;
 
 	params->chapter_count = geometry->chapters_per_volume;
@@ -214,7 +214,7 @@ static int compute_volume_sub_index_parameters(const struct configuration *confi
 	 * index delta list.
 	 */
 	rounded_chapters = params->chapter_count;
-	if (uds_is_reduced_geometry(geometry))
+	if (uds_is_reduced_index_geometry(geometry))
 		rounded_chapters += 1;
 	delta_list_records = records_per_chapter * rounded_chapters;
 	address_count = config->volume_index_mean_delta * DELTA_LIST_SIZE;
@@ -353,7 +353,7 @@ static int compute_volume_index_save_bytes(const struct configuration *config,
 	struct split_config split;
 	int result;
 
-	if (!uds_is_sparse_geometry(config->geometry))
+	if (!uds_is_sparse_index_geometry(config->geometry))
 		return compute_volume_sub_index_save_bytes(config, bytes);
 
 	split_configuration(config, &split);
@@ -1236,7 +1236,7 @@ int uds_make_volume_index(const struct configuration *config, u64 volume_nonce,
 
 	volume_index->zone_count = config->zone_count;
 
-	if (!uds_is_sparse_geometry(config->geometry)) {
+	if (!uds_is_sparse_index_geometry(config->geometry)) {
 		result = initialize_volume_sub_index(config, volume_nonce, 'm',
 						     &volume_index->vi_non_hook);
 		if (result != UDS_SUCCESS) {
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 65bf6d32e5d0..0cfeae0c5d5d 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -84,22 +84,22 @@ union invalidate_counter {
 	};
 };
 
-static inline u32 map_to_page_number(struct geometry *geometry, u32 physical_page)
+static inline u32 map_to_page_number(struct index_geometry *geometry, u32 physical_page)
 {
 	return (physical_page - HEADER_PAGES_PER_VOLUME) % geometry->pages_per_chapter;
 }
 
-static inline u32 map_to_chapter_number(struct geometry *geometry, u32 physical_page)
+static inline u32 map_to_chapter_number(struct index_geometry *geometry, u32 physical_page)
 {
 	return (physical_page - HEADER_PAGES_PER_VOLUME) / geometry->pages_per_chapter;
 }
 
-static inline bool is_record_page(struct geometry *geometry, u32 physical_page)
+static inline bool is_record_page(struct index_geometry *geometry, u32 physical_page)
 {
 	return map_to_page_number(geometry, physical_page) >= geometry->index_pages_per_chapter;
 }
 
-static u32 map_to_physical_page(const struct geometry *geometry, u32 chapter, u32 page)
+static u32 map_to_physical_page(const struct index_geometry *geometry, u32 chapter, u32 page)
 {
 	/* Page zero is the header page, so the first chapter index page is page one. */
 	return HEADER_PAGES_PER_VOLUME + (geometry->pages_per_chapter * chapter) + page;
@@ -423,7 +423,7 @@ static int init_chapter_index_page(const struct volume *volume, u8 *index_page,
 	u32 ci_chapter;
 	u32 lowest_list;
 	u32 highest_list;
-	struct geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = volume->geometry;
 	int result;
 
 	result = uds_initialize_chapter_index_page(chapter_index_page, geometry,
@@ -469,7 +469,7 @@ static int initialize_index_page(const struct volume *volume, u32 physical_page,
 
 static bool search_record_page(const u8 record_page[],
 			       const struct uds_record_name *name,
-			       const struct geometry *geometry,
+			       const struct index_geometry *geometry,
 			       struct uds_record_data *metadata)
 {
 	/*
@@ -882,7 +882,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 				  u32 chapter, u16 record_page_number, bool *found)
 {
 	struct cached_page *record_page;
-	struct geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = volume->geometry;
 	int result;
 	u32 physical_page, page_number;
 
@@ -924,7 +924,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 
 void uds_prefetch_volume_chapter(const struct volume *volume, u32 chapter)
 {
-	const struct geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = volume->geometry;
 	u32 physical_page = map_to_physical_page(geometry, chapter, 0);
 
 	dm_bufio_prefetch(volume->client, physical_page, geometry->pages_per_chapter);
@@ -936,7 +936,7 @@ int uds_read_chapter_index_from_volume(const struct volume *volume, u64 virtual_
 {
 	int result;
 	u32 i;
-	const struct geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = volume->geometry;
 	u32 physical_chapter = uds_map_to_physical_chapter(geometry, virtual_chapter);
 	u32 physical_page = map_to_physical_page(geometry, physical_chapter, 0);
 
@@ -995,7 +995,7 @@ int uds_search_volume_page_cache_for_rebuild(struct volume *volume,
 					     u64 virtual_chapter, bool *found)
 {
 	int result;
-	struct geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = volume->geometry;
 	struct cached_page *page;
 	u32 physical_chapter = uds_map_to_physical_chapter(geometry, virtual_chapter);
 	u32 index_page_number;
@@ -1096,7 +1096,7 @@ static int donate_index_page_locked(struct volume *volume, u32 physical_chapter,
 static int write_index_pages(struct volume *volume, u32 physical_chapter_number,
 			     struct open_chapter_index *chapter_index)
 {
-	struct geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = volume->geometry;
 	struct dm_buffer *page_buffer;
 	u32 first_index_page = map_to_physical_page(geometry, physical_chapter_number, 0);
 	u32 delta_list_number = 0;
@@ -1207,7 +1207,7 @@ static int write_record_pages(struct volume *volume, u32 physical_chapter_number
 			      const struct uds_volume_record *records)
 {
 	u32 record_page_number;
-	struct geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = volume->geometry;
 	struct dm_buffer *page_buffer;
 	const struct uds_volume_record *next_record = records;
 	u32 first_record_page = map_to_physical_page(geometry, physical_chapter_number,
@@ -1268,7 +1268,7 @@ int uds_write_chapter(struct volume *volume, struct open_chapter_index *chapter_
 static void probe_chapter(struct volume *volume, u32 chapter_number,
 			  u64 *virtual_chapter_number)
 {
-	const struct geometry *geometry = volume->geometry;
+	const struct index_geometry *geometry = volume->geometry;
 	u32 expected_list_number = 0;
 	u32 i;
 	u64 vcn = BAD_CHAPTER;
@@ -1352,7 +1352,7 @@ static void find_real_end_of_volume(struct volume *volume, u32 limit, u32 *limit
 static int find_chapter_limits(struct volume *volume, u32 chapter_limit, u64 *lowest_vcn,
 			       u64 *highest_vcn)
 {
-	struct geometry *geometry = volume->geometry;
+	struct index_geometry *geometry = volume->geometry;
 	u64 zero_vcn;
 	u64 lowest = BAD_CHAPTER;
 	u64 highest = BAD_CHAPTER;
@@ -1490,7 +1490,7 @@ int __must_check uds_replace_volume_storage(struct volume *volume,
 }
 
 static int __must_check initialize_page_cache(struct page_cache *cache,
-					      const struct geometry *geometry,
+					      const struct index_geometry *geometry,
 					      u32 chapters_in_cache,
 					      unsigned int zone_count)
 {
@@ -1543,7 +1543,7 @@ int uds_make_volume(const struct configuration *config, struct index_layout *lay
 {
 	unsigned int i;
 	struct volume *volume = NULL;
-	struct geometry *geometry;
+	struct index_geometry *geometry;
 	unsigned int reserved_buffers;
 	int result;
 
@@ -1553,7 +1553,7 @@ int uds_make_volume(const struct configuration *config, struct index_layout *lay
 
 	volume->nonce = uds_get_volume_nonce(layout);
 
-	result = uds_copy_geometry(config->geometry, &volume->geometry);
+	result = uds_copy_index_geometry(config->geometry, &volume->geometry);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume(volume);
 		return uds_log_warning_strerror(result,
@@ -1567,7 +1567,7 @@ int uds_make_volume(const struct configuration *config, struct index_layout *lay
 	 */
 	reserved_buffers = config->cache_chapters * geometry->record_pages_per_chapter;
 	reserved_buffers += 1;
-	if (uds_is_sparse_geometry(geometry))
+	if (uds_is_sparse_index_geometry(geometry))
 		reserved_buffers += (config->cache_chapters * geometry->index_pages_per_chapter);
 	volume->reserved_buffers = reserved_buffers;
 	result = uds_open_volume_bufio(layout, geometry->bytes_per_page,
@@ -1592,7 +1592,7 @@ int uds_make_volume(const struct configuration *config, struct index_layout *lay
 		return result;
 	}
 
-	if (uds_is_sparse_geometry(geometry)) {
+	if (uds_is_sparse_index_geometry(geometry)) {
 		size_t page_size = sizeof(struct delta_index_page) + geometry->bytes_per_page;
 
 		result = uds_make_sparse_cache(geometry, config->cache_chapters,
diff --git a/drivers/md/dm-vdo/volume.h b/drivers/md/dm-vdo/volume.h
index 0a96af964887..e938dd31934f 100644
--- a/drivers/md/dm-vdo/volume.h
+++ b/drivers/md/dm-vdo/volume.h
@@ -96,7 +96,7 @@ struct page_cache {
 };
 
 struct volume {
-	struct geometry *geometry;
+	struct index_geometry *geometry;
 	struct dm_bufio_client *client;
 	u64 nonce;
 	size_t cache_size;
-- 
2.42.0

