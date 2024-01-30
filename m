Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A42C868
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706575911; cv=none; b=l/JWWVFYYB1kw0ZGbs8ZBRU8Pi/UTohk8ojL0WCApd0/czqRH7jslQoCkDNrb4vimlfl00a0yKJ0ct41wLmGxIzo9IxgVREB2n3U//QiY6K769qlyJIvo9lXQma0gIEs3T9o67bnwu9K5gtEKvQy2a3rRP1yi6ezHCjVVDmV2/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706575911; c=relaxed/simple;
	bh=H21smrYyHdXezE8XyE7JDiYIIY9YlDILyYx8E9etMIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M6vdh0shyOCcq3vshV2lPKhsiOF2OZhNjYmrSB5ayt7mhHoj3OYGkCPFZCFp2Mp8PVOfY/jSqmblRlOAiEO/Jvw64jbXqF78Xdk9zS2mOdsGXxI1Y3IEiOVqRnTlAii3MSfwnbRtnfzSOletii36Dm50Wk67qrPhvglnbdITldE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QpQpjEdb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QpQpjEdb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706575908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wKaONnU7VE6fcFXCVWtQPCvM1xzalxTk4bZwNELXr4Q=;
	b=QpQpjEdbPuldYMXrPs2eiHmCYFzCEUc0IXfFQGa5n8KDQPkcubY2ddt67VpTb8fK3hT8ZI
	lqEcg8sEzmFC30tHjIuNmdyx3j1+t2XwD0ejXhhWWyO3T0weua3+AIFnorLOR9bfyfBqsD
	/kLsJ4wZU6cZTjDrnsQ3LHzGTRNYkhc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-GDdrwhAlOtm4vQNVQlkR8g-1; Mon, 29 Jan 2024 19:51:47 -0500
X-MC-Unique: GDdrwhAlOtm4vQNVQlkR8g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 247B785A58B;
	Tue, 30 Jan 2024 00:51:47 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E7E5111E9;
	Tue, 30 Jan 2024 00:51:47 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 1673C56374; Mon, 29 Jan 2024 19:51:47 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo: rename struct configuration to uds_configuration
Date: Mon, 29 Jan 2024 19:51:46 -0500
Message-ID: <53bc155386510ea17a2d7e281f301ea36a050e2b.1706575731.git.msakai@redhat.com>
In-Reply-To: <cover.1706575731.git.msakai@redhat.com>
References: <cover.1706575731.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/config.c        | 20 ++++++++++----------
 drivers/md/dm-vdo/config.h        | 14 +++++++-------
 drivers/md/dm-vdo/index-layout.c  | 16 ++++++++--------
 drivers/md/dm-vdo/index-layout.h  |  2 +-
 drivers/md/dm-vdo/index-session.c |  2 +-
 drivers/md/dm-vdo/index.c         |  2 +-
 drivers/md/dm-vdo/index.h         |  2 +-
 drivers/md/dm-vdo/volume-index.c  | 18 +++++++++---------
 drivers/md/dm-vdo/volume-index.h  |  4 ++--
 drivers/md/dm-vdo/volume.c        |  2 +-
 drivers/md/dm-vdo/volume.h        |  2 +-
 11 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/config.c
index cd5c36de6e2b..e9c7e9bdbce0 100644
--- a/drivers/md/dm-vdo/config.c
+++ b/drivers/md/dm-vdo/config.c
@@ -27,9 +27,9 @@ static bool is_version(const u8 *version, u8 *buffer)
 	return memcmp(version, buffer, INDEX_CONFIG_VERSION_LENGTH) == 0;
 }
 
-static bool are_matching_configurations(struct configuration *saved_config,
+static bool are_matching_configurations(struct uds_configuration *saved_config,
 					struct index_geometry *saved_geometry,
-					struct configuration *user)
+					struct uds_configuration *user)
 {
 	struct index_geometry *geometry = user->geometry;
 	bool result = true;
@@ -93,10 +93,10 @@ static bool are_matching_configurations(struct configuration *saved_config,
 
 /* Read the configuration and validate it against the provided one. */
 int uds_validate_config_contents(struct buffered_reader *reader,
-				 struct configuration *user_config)
+				 struct uds_configuration *user_config)
 {
 	int result;
-	struct configuration config;
+	struct uds_configuration config;
 	struct index_geometry geometry;
 	u8 version_buffer[INDEX_CONFIG_VERSION_LENGTH];
 	u32 bytes_per_page;
@@ -174,7 +174,7 @@ int uds_validate_config_contents(struct buffered_reader *reader,
  * been reduced by one chapter.
  */
 int uds_write_config_contents(struct buffered_writer *writer,
-			      struct configuration *config, u32 version)
+			      struct uds_configuration *config, u32 version)
 {
 	int result;
 	struct index_geometry *geometry = config->geometry;
@@ -313,9 +313,9 @@ static unsigned int __must_check normalize_read_threads(unsigned int requested)
 }
 
 int uds_make_configuration(const struct uds_parameters *params,
-			   struct configuration **config_ptr)
+			   struct uds_configuration **config_ptr)
 {
-	struct configuration *config;
+	struct uds_configuration *config;
 	u32 chapters_per_volume = 0;
 	u32 record_pages_per_chapter = 0;
 	u32 sparse_chapters_per_volume = 0;
@@ -327,7 +327,7 @@ int uds_make_configuration(const struct uds_parameters *params,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(1, struct configuration, __func__, &config);
+	result = uds_allocate(1, struct uds_configuration, __func__, &config);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -354,7 +354,7 @@ int uds_make_configuration(const struct uds_parameters *params,
 	return UDS_SUCCESS;
 }
 
-void uds_free_configuration(struct configuration *config)
+void uds_free_configuration(struct uds_configuration *config)
 {
 	if (config != NULL) {
 		uds_free_index_geometry(config->geometry);
@@ -362,7 +362,7 @@ void uds_free_configuration(struct configuration *config)
 	}
 }
 
-void uds_log_configuration(struct configuration *config)
+void uds_log_configuration(struct uds_configuration *config)
 {
 	struct index_geometry *geometry = config->geometry;
 
diff --git a/drivers/md/dm-vdo/config.h b/drivers/md/dm-vdo/config.h
index b79fe833d825..7d19863800d6 100644
--- a/drivers/md/dm-vdo/config.h
+++ b/drivers/md/dm-vdo/config.h
@@ -11,7 +11,7 @@
 #include "uds.h"
 
 /*
- * The configuration records a variety of parameters used to configure a new UDS index. Some
+ * The uds_configuration records a variety of parameters used to configure a new UDS index. Some
  * parameters are provided by the client, while others are fixed or derived from user-supplied
  * values. It is created when an index is created, and it is recorded in the index metadata.
  */
@@ -24,7 +24,7 @@ enum {
 };
 
 /* A set of configuration parameters for the indexer. */
-struct configuration {
+struct uds_configuration {
 	/* Storage device for the index */
 	struct block_device *bdev;
 
@@ -109,16 +109,16 @@ struct uds_configuration_6_02 {
 } __packed;
 
 int __must_check uds_make_configuration(const struct uds_parameters *params,
-					struct configuration **config_ptr);
+					struct uds_configuration **config_ptr);
 
-void uds_free_configuration(struct configuration *config);
+void uds_free_configuration(struct uds_configuration *config);
 
 int __must_check uds_validate_config_contents(struct buffered_reader *reader,
-					      struct configuration *config);
+					      struct uds_configuration *config);
 
 int __must_check uds_write_config_contents(struct buffered_writer *writer,
-					   struct configuration *config, u32 version);
+					   struct uds_configuration *config, u32 version);
 
-void uds_log_configuration(struct configuration *config);
+void uds_log_configuration(struct uds_configuration *config);
 
 #endif /* UDS_CONFIG_H */
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
index bc67720659e7..2da507b26fd5 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -222,7 +222,7 @@ static inline bool is_converted_super_block(struct super_block_data *super)
 	return super->version == 7;
 }
 
-static int __must_check compute_sizes(const struct configuration *config,
+static int __must_check compute_sizes(const struct uds_configuration *config,
 				      struct save_layout_sizes *sls)
 {
 	int result;
@@ -256,7 +256,7 @@ static int __must_check compute_sizes(const struct configuration *config,
 int uds_compute_index_size(const struct uds_parameters *parameters, u64 *index_size)
 {
 	int result;
-	struct configuration *index_config;
+	struct uds_configuration *index_config;
 	struct save_layout_sizes sizes;
 
 	if (index_size == NULL) {
@@ -752,7 +752,7 @@ static int __must_check write_layout_header(struct index_layout *layout,
 }
 
 static int __must_check write_uds_index_config(struct index_layout *layout,
-					       struct configuration *config,
+					       struct uds_configuration *config,
 					       off_t offset)
 {
 	int result;
@@ -801,7 +801,7 @@ static int __must_check save_layout(struct index_layout *layout, off_t offset)
 	return result;
 }
 
-static int create_index_layout(struct index_layout *layout, struct configuration *config)
+static int create_index_layout(struct index_layout *layout, struct uds_configuration *config)
 {
 	int result;
 	struct save_layout_sizes sizes;
@@ -1620,7 +1620,7 @@ static int __must_check load_sub_index_regions(struct index_layout *layout)
 }
 
 static int __must_check verify_uds_index_config(struct index_layout *layout,
-						struct configuration *config)
+						struct uds_configuration *config)
 {
 	int result;
 	struct buffered_reader *reader = NULL;
@@ -1641,7 +1641,7 @@ static int __must_check verify_uds_index_config(struct index_layout *layout,
 	return UDS_SUCCESS;
 }
 
-static int load_index_layout(struct index_layout *layout, struct configuration *config)
+static int load_index_layout(struct index_layout *layout, struct uds_configuration *config)
 {
 	int result;
 	struct buffered_reader *reader;
@@ -1665,7 +1665,7 @@ static int load_index_layout(struct index_layout *layout, struct configuration *
 }
 
 static int create_layout_factory(struct index_layout *layout,
-				 const struct configuration *config)
+				 const struct uds_configuration *config)
 {
 	int result;
 	size_t writable_size;
@@ -1689,7 +1689,7 @@ static int create_layout_factory(struct index_layout *layout,
 	return UDS_SUCCESS;
 }
 
-int uds_make_index_layout(struct configuration *config, bool new_layout,
+int uds_make_index_layout(struct uds_configuration *config, bool new_layout,
 			  struct index_layout **layout_ptr)
 {
 	int result;
diff --git a/drivers/md/dm-vdo/index-layout.h b/drivers/md/dm-vdo/index-layout.h
index ba5d8b004ebe..84a9eb43a49d 100644
--- a/drivers/md/dm-vdo/index-layout.h
+++ b/drivers/md/dm-vdo/index-layout.h
@@ -18,7 +18,7 @@
 
 struct index_layout;
 
-int __must_check uds_make_index_layout(struct configuration *config, bool new_layout,
+int __must_check uds_make_index_layout(struct uds_configuration *config, bool new_layout,
 				       struct index_layout **layout_ptr);
 
 void uds_free_index_layout(struct index_layout *layout);
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index c261453b9871..9b5d2cacfffd 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -314,7 +314,7 @@ static int initialize_index_session(struct uds_index_session *index_session,
 				    enum uds_open_index_type open_type)
 {
 	int result;
-	struct configuration *config;
+	struct uds_configuration *config;
 
 	result = uds_make_configuration(&index_session->parameters, &config);
 	if (result != UDS_SUCCESS) {
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index cf7cdc909a31..e343a973881d 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -1162,7 +1162,7 @@ static int make_index_zone(struct uds_index *index, unsigned int zone_number)
 	return UDS_SUCCESS;
 }
 
-int uds_make_index(struct configuration *config, enum uds_open_index_type open_type,
+int uds_make_index(struct uds_configuration *config, enum uds_open_index_type open_type,
 		   struct index_load_context *load_context, index_callback_fn callback,
 		   struct uds_index **new_index)
 {
diff --git a/drivers/md/dm-vdo/index.h b/drivers/md/dm-vdo/index.h
index ace1835aecd5..edabb239548e 100644
--- a/drivers/md/dm-vdo/index.h
+++ b/drivers/md/dm-vdo/index.h
@@ -62,7 +62,7 @@ enum request_stage {
 	STAGE_MESSAGE,
 };
 
-int __must_check uds_make_index(struct configuration *config,
+int __must_check uds_make_index(struct uds_configuration *config,
 				enum uds_open_index_type open_type,
 				struct index_load_context *load_context,
 				index_callback_fn callback, struct uds_index **new_index);
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index 0f4b9510e7ea..8731ea1662b1 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -80,11 +80,11 @@ struct sub_index_parameters {
 
 struct split_config {
 	/* The hook subindex configuration */
-	struct configuration hook_config;
+	struct uds_configuration hook_config;
 	struct index_geometry hook_geometry;
 
 	/* The non-hook subindex configuration */
-	struct configuration non_hook_config;
+	struct uds_configuration non_hook_config;
 	struct index_geometry non_hook_geometry;
 };
 
@@ -192,7 +192,7 @@ unsigned int uds_get_volume_index_zone(const struct volume_index *volume_index,
 	return get_volume_sub_index_zone(get_volume_sub_index(volume_index, name), name);
 }
 
-static int compute_volume_sub_index_parameters(const struct configuration *config,
+static int compute_volume_sub_index_parameters(const struct uds_configuration *config,
 					       struct sub_index_parameters *params)
 {
 	enum { DELTA_LIST_SIZE = 256 };
@@ -300,7 +300,7 @@ void uds_free_volume_index(struct volume_index *volume_index)
 }
 
 
-static int compute_volume_sub_index_save_bytes(const struct configuration *config,
+static int compute_volume_sub_index_save_bytes(const struct uds_configuration *config,
 					       size_t *bytes)
 {
 	struct sub_index_parameters params = { .address_bits = 0 };
@@ -317,7 +317,7 @@ static int compute_volume_sub_index_save_bytes(const struct configuration *confi
 }
 
 /* This function is only useful if the configuration includes sparse chapters. */
-static void split_configuration(const struct configuration *config,
+static void split_configuration(const struct uds_configuration *config,
 				struct split_config *split)
 {
 	u64 sample_rate, sample_records;
@@ -346,7 +346,7 @@ static void split_configuration(const struct configuration *config,
 	split->non_hook_geometry.chapters_per_volume = dense_chapters;
 }
 
-static int compute_volume_index_save_bytes(const struct configuration *config,
+static int compute_volume_index_save_bytes(const struct uds_configuration *config,
 					   size_t *bytes)
 {
 	size_t hook_bytes, non_hook_bytes;
@@ -370,7 +370,7 @@ static int compute_volume_index_save_bytes(const struct configuration *config,
 	return UDS_SUCCESS;
 }
 
-int uds_compute_volume_index_save_blocks(const struct configuration *config,
+int uds_compute_volume_index_save_blocks(const struct uds_configuration *config,
 					 size_t block_size, u64 *block_count)
 {
 	size_t bytes;
@@ -1172,7 +1172,7 @@ void uds_get_volume_index_stats(const struct volume_index *volume_index,
 	stats->early_flushes += sparse_stats.early_flushes;
 }
 
-static int initialize_volume_sub_index(const struct configuration *config,
+static int initialize_volume_sub_index(const struct uds_configuration *config,
 				       u64 volume_nonce, u8 tag,
 				       struct volume_sub_index *sub_index)
 {
@@ -1222,7 +1222,7 @@ static int initialize_volume_sub_index(const struct configuration *config,
 			    "volume index zones", &sub_index->zones);
 }
 
-int uds_make_volume_index(const struct configuration *config, u64 volume_nonce,
+int uds_make_volume_index(const struct uds_configuration *config, u64 volume_nonce,
 			  struct volume_index **volume_index_ptr)
 {
 	struct split_config split;
diff --git a/drivers/md/dm-vdo/volume-index.h b/drivers/md/dm-vdo/volume-index.h
index 7fbe11fe3284..0f08acf29435 100644
--- a/drivers/md/dm-vdo/volume-index.h
+++ b/drivers/md/dm-vdo/volume-index.h
@@ -136,13 +136,13 @@ struct volume_index_record {
 	struct delta_index_entry delta_entry;
 };
 
-int __must_check uds_make_volume_index(const struct configuration *config,
+int __must_check uds_make_volume_index(const struct uds_configuration *config,
 				       u64 volume_nonce,
 				       struct volume_index **volume_index);
 
 void uds_free_volume_index(struct volume_index *volume_index);
 
-int __must_check uds_compute_volume_index_save_blocks(const struct configuration *config,
+int __must_check uds_compute_volume_index_save_blocks(const struct uds_configuration *config,
 						      size_t block_size,
 						      u64 *block_count);
 
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 0cfeae0c5d5d..8bd64057c2ca 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -1538,7 +1538,7 @@ static int __must_check initialize_page_cache(struct page_cache *cache,
 	return UDS_SUCCESS;
 }
 
-int uds_make_volume(const struct configuration *config, struct index_layout *layout,
+int uds_make_volume(const struct uds_configuration *config, struct index_layout *layout,
 		    struct volume **new_volume)
 {
 	unsigned int i;
diff --git a/drivers/md/dm-vdo/volume.h b/drivers/md/dm-vdo/volume.h
index e938dd31934f..066680282340 100644
--- a/drivers/md/dm-vdo/volume.h
+++ b/drivers/md/dm-vdo/volume.h
@@ -121,7 +121,7 @@ struct volume {
 	unsigned int reserved_buffers;
 };
 
-int __must_check uds_make_volume(const struct configuration *config,
+int __must_check uds_make_volume(const struct uds_configuration *config,
 				 struct index_layout *layout,
 				 struct volume **new_volume);
 
-- 
2.42.0

