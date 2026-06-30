Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4962E11A6
	for <dm-devel@lists.linux.dev>; Tue, 30 Jun 2026 23:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860715; cv=none; b=upX9EvDYwes8Hs9Zw/eq3wNyU6wzZJLL9tpCkQpZw8VX5HpUKAquY8EdJIfiWGmqxsjdRKeyD7XskusoWWSaQ/UGbZUb4uGw6U8LFlTWQ1fRYOPO2kEy8FPrw68DEsrSdgvSLK+ZH4jRubOOJv2P4LNuflpWSe1yQ0CyjY+jjww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860715; c=relaxed/simple;
	bh=xvvrNLPCQH9zL4b+OIBfBLJggTy7xiJ+7SB0eA+nzk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=NVJOLi16Gs5YCLqVaMr/dtk8mSPphLjwsaZ80OJiMYz1itUD+PO452aEg+1IIA5rzetHOcyC+Ke28h1RRa5gzcvzV1MV6K3gYrhGJRGcmWuIbgGvmSaQNqS8EM4+4tnq/0g5z+XkuRtn4CTlZXPVjVOMVYZfAlf1QWSGQhGfmDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ai6ATXNU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ai6ATXNU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782860712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fYU0iggmTDgB3zJuL2YZutbsYuOF/WSMaUe5t97II34=;
	b=Ai6ATXNUADy5VZrJU31ZPXhvf6iQ0RreM+7FUm+rBVDWmhX2bR3enw6y/QXLOEODO9jRdv
	i7jYkyMGitbn5FNNItWL/bK0r+6gMXicnv7Bu7CqON+0JL+YqkeZW0V1M4UFmY0lwVc3vB
	fUOAtEd0KbvnA/ixk+9/hnnL3eUOrWc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-KY1DFLVSPH-AgIDWcElVTw-1; Tue,
 30 Jun 2026 19:05:09 -0400
X-MC-Unique: KY1DFLVSPH-AgIDWcElVTw-1
X-Mimecast-MFC-AGG-ID: KY1DFLVSPH-AgIDWcElVTw_1782860708
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5684E1856A7B;
	Tue, 30 Jun 2026 23:05:08 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (ci-vm-10-0-103-170.hosted.upshift.rdu2.redhat.com [10.0.103.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E8DE1800605;
	Tue, 30 Jun 2026 23:05:08 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 821411B528; Tue, 30 Jun 2026 19:05:07 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: corwin <corwincoburn@google.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo indexer: simplify sub-index parameter calculations
Date: Tue, 30 Jun 2026 19:05:07 -0400
Message-ID: <f64b90824275a59a4e85a970251ca32b45383a25.1782860429.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qQ7X8GWgw6iRNs3AC93N1v4X8-QGKEUM_zwhtbI_9Ck_1782860708
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: corwin <corwincoburn@google.com>

Pull the calculations from split_config() into
compute_volume_sub_index_parameters(). For sparse indexes, this
eliminates the duplication of both the configs and geometries
in favor of merely having 2 sub_index_parameters structures.

Also expand the sub_index_parameters structure to include the
small number of fields its users rely on from both the config
and the geometry.

Signed-off-by: corwin <corwincoburn@google.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/volume-index.c | 188 +++++++++++------------
 1 file changed, 93 insertions(+), 95 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index e78d2725ce8b..03c6b39ccdcc 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -60,6 +60,12 @@
  * the index.
  */
 
+enum sub_index_parameters_slot {
+	DENSE = 0,
+	HOOK = 0,
+	NON_HOOK = 1,
+};
+
 struct sub_index_parameters {
 	/* The number of bits in address mask */
 	u8 address_bits;
@@ -77,16 +83,10 @@ struct sub_index_parameters {
 	size_t memory_size;
 	/* The number of bytes the index should keep free at all times */
 	size_t target_free_bytes;
-};
-
-struct split_config {
-	/* The hook subindex configuration */
-	struct uds_configuration hook_config;
-	struct index_geometry hook_geometry;
-
-	/* The non-hook subindex configuration */
-	struct uds_configuration non_hook_config;
-	struct index_geometry non_hook_geometry;
+	/* The mean delta for the volume index */
+	u32 volume_index_mean_delta;
+	/* The number of threads used to process index requests */
+	unsigned int zone_count;
 };
 
 struct chapter_range {
@@ -196,8 +196,11 @@ unsigned int uds_get_volume_index_zone(const struct volume_index *volume_index,
 
 #define DELTA_LIST_SIZE 256
 
-static int compute_volume_sub_index_parameters(const struct uds_configuration *config,
-					       struct sub_index_parameters *params)
+static int compute_sub_index_parameters(const struct uds_configuration *config,
+					u64 records_per_chapter,
+					u32 chapters_per_volume,
+					bool reduced,
+					struct sub_index_parameters *params)
 {
 	u64 entries_in_volume_index, address_span;
 	u32 chapters_in_volume_index, invalid_chapters;
@@ -207,17 +210,15 @@ static int compute_volume_sub_index_parameters(const struct uds_configuration *c
 	u64 index_size_in_bits;
 	size_t expected_index_size;
 	u64 min_delta_lists = MAX_ZONES * MAX_ZONES;
-	struct index_geometry *geometry = config->geometry;
-	u64 records_per_chapter = geometry->records_per_chapter;
 
-	params->chapter_count = geometry->chapters_per_volume;
+	params->chapter_count = chapters_per_volume;
 	/*
 	 * Make sure that the number of delta list records in the volume index does not change when
 	 * the volume is reduced by one chapter. This preserves the mapping from name to volume
 	 * index delta list.
 	 */
 	rounded_chapters = params->chapter_count;
-	if (uds_is_reduced_index_geometry(geometry))
+	if (reduced)
 		rounded_chapters += 1;
 	delta_list_records = records_per_chapter * rounded_chapters;
 	address_count = config->volume_index_mean_delta * DELTA_LIST_SIZE;
@@ -274,9 +275,46 @@ static int compute_volume_sub_index_parameters(const struct uds_configuration *c
 	params->memory_size = expected_index_size * 106 / 100;
 
 	params->target_free_bytes = expected_index_size / 20;
+	params->volume_index_mean_delta = config->volume_index_mean_delta;
+	params->zone_count = config->zone_count;
 	return UDS_SUCCESS;
 }
 
+static int compute_volume_sub_index_parameters(const struct uds_configuration *config,
+					       struct sub_index_parameters *params)
+{
+	struct index_geometry *geometry = config->geometry;
+	u64 sample_records;
+	u64 dense_chapters;
+	int result;
+	bool reduced = uds_is_reduced_index_geometry(geometry);
+
+	if (!uds_is_sparse_index_geometry(config->geometry)) {
+		return compute_sub_index_parameters(config,
+						    geometry->records_per_chapter,
+						    geometry->chapters_per_volume,
+						    reduced,
+						    &params[DENSE]);
+	}
+
+	dense_chapters = geometry->chapters_per_volume - geometry->sparse_chapters_per_volume;
+	sample_records = geometry->records_per_chapter / config->sparse_sample_rate;
+
+	result = compute_sub_index_parameters(config,
+					      sample_records,
+					      geometry->chapters_per_volume,
+					      reduced,
+					      &params[HOOK]);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	return compute_sub_index_parameters(config,
+					    geometry->records_per_chapter - sample_records,
+					    dense_chapters,
+					    reduced,
+					    &params[NON_HOOK]);
+}
+
 static void uninitialize_volume_sub_index(struct volume_sub_index *sub_index)
 {
 	vdo_free(vdo_forget(sub_index->flush_chapters));
@@ -298,73 +336,32 @@ void uds_free_volume_index(struct volume_index *volume_index)
 }
 
 
-static int compute_volume_sub_index_save_bytes(const struct uds_configuration *config,
-					       size_t *bytes)
-{
-	struct sub_index_parameters params = { .address_bits = 0 };
-	int result;
-
-	result = compute_volume_sub_index_parameters(config, &params);
-	if (result != UDS_SUCCESS)
-		return result;
-
-	*bytes = (sizeof(struct sub_index_data) + params.list_count * sizeof(u64) +
-		  uds_compute_delta_index_save_bytes(params.list_count,
-						     params.memory_size));
-	return UDS_SUCCESS;
-}
-
-/* This function is only useful if the configuration includes sparse chapters. */
-static void split_configuration(const struct uds_configuration *config,
-				struct split_config *split)
+static size_t compute_volume_sub_index_save_bytes(struct sub_index_parameters *params)
 {
-	u64 sample_rate, sample_records;
-	u64 dense_chapters, sparse_chapters;
-
-	/* Start with copies of the base configuration. */
-	split->hook_config = *config;
-	split->hook_geometry = *config->geometry;
-	split->hook_config.geometry = &split->hook_geometry;
-	split->non_hook_config = *config;
-	split->non_hook_geometry = *config->geometry;
-	split->non_hook_config.geometry = &split->non_hook_geometry;
-
-	sample_rate = config->sparse_sample_rate;
-	sparse_chapters = config->geometry->sparse_chapters_per_volume;
-	dense_chapters = config->geometry->chapters_per_volume - sparse_chapters;
-	sample_records = config->geometry->records_per_chapter / sample_rate;
-
-	/* Adjust the number of records indexed for each chapter. */
-	split->hook_geometry.records_per_chapter = sample_records;
-	split->non_hook_geometry.records_per_chapter -= sample_records;
-
-	/* Adjust the number of chapters indexed. */
-	split->hook_geometry.sparse_chapters_per_volume = 0;
-	split->non_hook_geometry.sparse_chapters_per_volume = 0;
-	split->non_hook_geometry.chapters_per_volume = dense_chapters;
+	return (sizeof(struct sub_index_data) + params->list_count * sizeof(u64) +
+		uds_compute_delta_index_save_bytes(params->list_count,
+						   params->memory_size));
 }
 
 static int compute_volume_index_save_bytes(const struct uds_configuration *config,
 					   size_t *bytes)
 {
-	size_t hook_bytes, non_hook_bytes;
-	struct split_config split;
 	int result;
+	struct sub_index_parameters parameters[2] = {
+		{ .address_bits = 0 },
+		{ .address_bits = 0 },
+	};
 
-	if (!uds_is_sparse_index_geometry(config->geometry))
-		return compute_volume_sub_index_save_bytes(config, bytes);
-
-	split_configuration(config, &split);
-	result = compute_volume_sub_index_save_bytes(&split.hook_config, &hook_bytes);
+	result = compute_volume_sub_index_parameters(config, parameters);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = compute_volume_sub_index_save_bytes(&split.non_hook_config,
-						     &non_hook_bytes);
-	if (result != UDS_SUCCESS)
-		return result;
+	*bytes = compute_volume_sub_index_save_bytes(&parameters[HOOK]);
+	if (uds_is_sparse_index_geometry(config->geometry)) {
+		*bytes += compute_volume_sub_index_save_bytes(&parameters[NON_HOOK]);
+		*bytes += sizeof(struct volume_index_data);
+	}
 
-	*bytes = sizeof(struct volume_index_data) + hook_bytes + non_hook_bytes;
 	return UDS_SUCCESS;
 }
 
@@ -1170,48 +1167,43 @@ void uds_get_volume_index_stats(const struct volume_index *volume_index,
 	stats->early_flushes += sparse_stats.early_flushes;
 }
 
-static int initialize_volume_sub_index(const struct uds_configuration *config,
+static int initialize_volume_sub_index(struct sub_index_parameters *params,
 				       u64 volume_nonce, u8 tag,
 				       struct volume_sub_index *sub_index)
 {
-	struct sub_index_parameters params = { .address_bits = 0 };
-	unsigned int zone_count = config->zone_count;
+	unsigned int zone_count = params->zone_count;
 	u64 available_bytes = 0;
 	unsigned int z;
 	int result;
 
-	result = compute_volume_sub_index_parameters(config, &params);
-	if (result != UDS_SUCCESS)
-		return result;
-
-	sub_index->address_bits = params.address_bits;
-	sub_index->address_mask = (1u << params.address_bits) - 1;
-	sub_index->chapter_bits = params.chapter_bits;
-	sub_index->chapter_mask = (1u << params.chapter_bits) - 1;
-	sub_index->chapter_count = params.chapter_count;
-	sub_index->list_count = params.list_count;
+	sub_index->address_bits = params->address_bits;
+	sub_index->address_mask = (1u << params->address_bits) - 1;
+	sub_index->chapter_bits = params->chapter_bits;
+	sub_index->chapter_mask = (1u << params->chapter_bits) - 1;
+	sub_index->chapter_count = params->chapter_count;
+	sub_index->list_count = params->list_count;
 	sub_index->zone_count = zone_count;
-	sub_index->chapter_zone_bits = params.chapter_size_in_bits / zone_count;
+	sub_index->chapter_zone_bits = params->chapter_size_in_bits / zone_count;
 	sub_index->volume_nonce = volume_nonce;
 
 	result = uds_initialize_delta_index(&sub_index->delta_index, zone_count,
-					    params.list_count, params.mean_delta,
-					    params.chapter_bits, params.memory_size,
+					    params->list_count, params->mean_delta,
+					    params->chapter_bits, params->memory_size,
 					    tag);
 	if (result != UDS_SUCCESS)
 		return result;
 
 	for (z = 0; z < sub_index->delta_index.zone_count; z++)
 		available_bytes += sub_index->delta_index.delta_zones[z].size;
-	available_bytes -= params.target_free_bytes;
+	available_bytes -= params->target_free_bytes;
 	sub_index->max_zone_bits = (available_bytes * BITS_PER_BYTE) / zone_count;
 	sub_index->memory_size = (sub_index->delta_index.memory_size +
 				  sizeof(struct volume_sub_index) +
-				  (params.list_count * sizeof(u64)) +
+				  (params->list_count * sizeof(u64)) +
 				  (zone_count * sizeof(struct volume_sub_index_zone)));
 
 	/* The following arrays are initialized to all zeros. */
-	result = vdo_allocate(params.list_count, "first chapter to flush",
+	result = vdo_allocate(params->list_count, "first chapter to flush",
 			      &sub_index->flush_chapters);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -1222,10 +1214,13 @@ static int initialize_volume_sub_index(const struct uds_configuration *config,
 int uds_make_volume_index(const struct uds_configuration *config, u64 volume_nonce,
 			  struct volume_index **volume_index_ptr)
 {
-	struct split_config split;
 	unsigned int zone;
 	struct volume_index *volume_index;
 	int result;
+	struct sub_index_parameters parameters[2] = {
+		{ .address_bits = 0 },
+		{ .address_bits = 0 },
+	};
 
 	result = vdo_allocate(1, "volume index", &volume_index);
 	if (result != VDO_SUCCESS)
@@ -1233,8 +1228,12 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 
 	volume_index->zone_count = config->zone_count;
 
+	result = compute_volume_sub_index_parameters(config, parameters);
+	if (result != UDS_SUCCESS)
+		return result;
+
 	if (!uds_is_sparse_index_geometry(config->geometry)) {
-		result = initialize_volume_sub_index(config, volume_nonce, 'm',
+		result = initialize_volume_sub_index(&parameters[DENSE], volume_nonce, 'm',
 						     &volume_index->vi_non_hook);
 		if (result != UDS_SUCCESS) {
 			uds_free_volume_index(volume_index);
@@ -1257,8 +1256,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 	for (zone = 0; zone < config->zone_count; zone++)
 		mutex_init(&volume_index->zones[zone].hook_mutex);
 
-	split_configuration(config, &split);
-	result = initialize_volume_sub_index(&split.non_hook_config, volume_nonce, 'd',
+	result = initialize_volume_sub_index(&parameters[NON_HOOK], volume_nonce, 'd',
 					     &volume_index->vi_non_hook);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume_index(volume_index);
@@ -1266,7 +1264,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 					      "Error creating non hook volume index");
 	}
 
-	result = initialize_volume_sub_index(&split.hook_config, volume_nonce, 's',
+	result = initialize_volume_sub_index(&parameters[HOOK], volume_nonce, 's',
 					     &volume_index->vi_hook);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume_index(volume_index);
-- 
2.53.0

