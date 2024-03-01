Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C6447796
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265536; cv=none; b=QsJ7mdj0DKpg+vSdjHvk4PjEU/I7ckosEJPHqHgVUmgOu1t/PENX8rfH5a+k7ygwJWxp5N0lxGMEL0J1cW0P9YYZu17tYwF2LvXDA/WC/fo/BGX7cwIQWEFt8VQQPOGmHF5dEj8eizDsUUThTkdmnAnyoC62vcgOP2VNH/Asjoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265536; c=relaxed/simple;
	bh=SYc2frQxY9omxV4fVwQKXaG5PTWdYfmxYvZOZWSyQeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVPxoC8fqG9+vq7tPKXTV91c4AKXm15BgxAsn60Zv887/hVn8pAwAtJWkn0qEV/r5oJ5r9g3OlXvuzTdnhtZ/ZP3e/Uar4m+Scj9YWhut5UvUIMit0dt87Hc2o3FrZVAyXMP+jZ9hiRjiuPHdBIF1HA1hR2gdAFqyV+TMl78J9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/xgY6ng; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/xgY6ng"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zq8rmFa7oCA+IT2pSaOywp/u3l325NRDrGl56IpIyK0=;
	b=Z/xgY6ngN8HHDxUIS+14lOA0TAPO+6yyVI73ZVrvOwS64wTDz0J0u1PTsmH/aqHvvRTfj7
	+HMJrE4pCTJMQzRGYCop4JK6T3Le9zURbqk84rzMnYCu2hRdrOOh/Qx/mahzLdb1T8fjgV
	vjIujC/SSdsLHTJCen8nJH853Ds9JpI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-XNTclf4AOrWTdM2cmSXkSg-1; Thu, 29 Feb 2024 22:58:51 -0500
X-MC-Unique: XNTclf4AOrWTdM2cmSXkSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D0BB89F9E2
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:58:51 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56E164D903;
	Fri,  1 Mar 2024 03:58:51 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 51FC59F80E; Thu, 29 Feb 2024 22:58:51 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo: remove internal ticket references from vdo
Date: Thu, 29 Feb 2024 22:58:51 -0500
Message-ID: <8636c7d2e6ce85c217f29fcbbdf044d0bee42ce5.1709265262.git.msakai@redhat.com>
In-Reply-To: <cover.1709265262.git.msakai@redhat.com>
References: <cover.1709265262.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Susan LeGendre-McGhee <slegendr@redhat.com>

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c     |  8 ++++----
 drivers/md/dm-vdo/data-vio.c      |  9 +++++----
 drivers/md/dm-vdo/dm-vdo-target.c | 12 +++++-------
 drivers/md/dm-vdo/packer.c        | 16 +++++++---------
 drivers/md/dm-vdo/packer.h        |  2 +-
 drivers/md/dm-vdo/repair.c        |  4 ++--
 drivers/md/dm-vdo/slab-depot.c    | 16 +++++++++++-----
 drivers/md/dm-vdo/vdo.c           |  2 +-
 drivers/md/dm-vdo/vio.c           |  1 -
 9 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index e3fadb5f2c2d..5be400743c03 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -542,7 +542,7 @@ static unsigned int distribute_page_over_waitq(struct page_info *info,
 
 	/*
 	 * Increment the busy count once for each pending completion so that this page does not
-	 * stop being busy until all completions have been processed (VDO-83).
+	 * stop being busy until all completions have been processed.
 	 */
 	info->busy += num_pages;
 
@@ -1097,9 +1097,9 @@ static void write_pages(struct vdo_completion *flush_completion)
 	struct vdo_page_cache *cache = ((struct page_info *) flush_completion->parent)->cache;
 
 	/*
-	 * We need to cache these two values on the stack since in the error case below, it is
-	 * possible for the last page info to cause the page cache to get freed. Hence once we
-	 * launch the last page, it may be unsafe to dereference the cache [VDO-4724].
+	 * We need to cache these two values on the stack since it is possible for the last
+	 * page info to cause the page cache to get freed. Hence once we launch the last page,
+	 * it may be unsafe to dereference the cache.
 	 */
 	bool has_unflushed_pages = (cache->pages_to_flush > 0);
 	page_count_t pages_in_flush = cache->pages_in_flush;
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index d77adeb5006e..f6c32dc9a822 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -453,10 +453,11 @@ static void attempt_logical_block_lock(struct vdo_completion *completion)
 
 	/*
 	 * If the new request is a pure read request (not read-modify-write) and the lock_holder is
-	 * writing and has received an allocation (VDO-2683), service the read request immediately
-	 * by copying data from the lock_holder to avoid having to flush the write out of the
-	 * packer just to prevent the read from waiting indefinitely. If the lock_holder does not
-	 * yet have an allocation, prevent it from blocking in the packer and wait on it.
+	 * writing and has received an allocation, service the read request immediately by copying
+	 * data from the lock_holder to avoid having to flush the write out of the packer just to
+	 * prevent the read from waiting indefinitely. If the lock_holder does not yet have an
+	 * allocation, prevent it from blocking in the packer and wait on it. This is necessary in
+	 * order to prevent returning data that may not have actually been written.
 	 */
 	if (!data_vio->write && READ_ONCE(lock_holder->allocation_succeeded)) {
 		copy_to_bio(data_vio->user_bio, lock_holder->vio.data + data_vio->offset);
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 7afd1dfec649..0114fa4d48a2 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -945,13 +945,11 @@ static void vdo_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * Sets the maximum discard size that will be passed into VDO. This value comes from a
 	 * table line value passed in during dmsetup create.
 	 *
-	 * The value 1024 is the largest usable value on HD systems.  A 2048 sector discard on a
-	 * busy HD system takes 31 seconds.  We should use a value no higher than 1024, which takes
-	 * 15 to 16 seconds on a busy HD system.
-	 *
-	 * But using large values results in 120 second blocked task warnings in /var/log/kern.log.
-	 * In order to avoid these warnings, we choose to use the smallest reasonable value.  See
-	 * VDO-3062 and VDO-3087.
+	 * The value 1024 is the largest usable value on HD systems. A 2048 sector discard on a
+	 * busy HD system takes 31 seconds. We should use a value no higher than 1024, which takes
+	 * 15 to 16 seconds on a busy HD system. However, using large values results in 120 second
+	 * blocked task warnings in kernel logs. In order to avoid these warnings, we choose to
+	 * use the smallest reasonable value.
 	 *
 	 * The value is displayed in sysfs, and also used by dm-thin to determine whether to pass
 	 * down discards. The block layer splits large discards on this boundary when this is set.
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index e391cac6c92d..b0ffb21ec436 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -595,15 +595,13 @@ void vdo_attempt_packing(struct data_vio *data_vio)
 	}
 
 	/*
-	 * The check of may_vio_block_in_packer() here will set the data_vio's compression state to
-	 * VIO_PACKING if the data_vio is allowed to be compressed (if it has already been
-	 * canceled, we'll fall out here). Once the data_vio is in the VIO_PACKING state, it must
-	 * be guaranteed to be put in a bin before any more requests can be processed by the packer
-	 * thread. Otherwise, a canceling data_vio could attempt to remove the canceled data_vio
-	 * from the packer and fail to rendezvous with it (VDO-2809). We must also make sure that
-	 * we will actually bin the data_vio and not give up on it as being larger than the space
-	 * used in the fullest bin. Hence we must call select_bin() before calling
-	 * may_vio_block_in_packer() (VDO-2826).
+	 * The advance_data_vio_compression_stage() check here verifies that the data_vio is
+	 * allowed to be compressed (if it has already been canceled, we'll fall out here). Once
+	 * the data_vio is in the DATA_VIO_PACKING state, it must be guaranteed to be put in a bin
+	 * before any more requests can be processed by the packer thread. Otherwise, a canceling
+	 * data_vio could attempt to remove the canceled data_vio from the packer and fail to
+	 * rendezvous with it. Thus, we must call select_bin() first to ensure that we will
+	 * actually add the data_vio to a bin before advancing to the DATA_VIO_PACKING stage.
 	 */
 	bin = select_bin(packer, data_vio);
 	if ((bin == NULL) ||
diff --git a/drivers/md/dm-vdo/packer.h b/drivers/md/dm-vdo/packer.h
index 2dcc40bd4417..0f3be44710b5 100644
--- a/drivers/md/dm-vdo/packer.h
+++ b/drivers/md/dm-vdo/packer.h
@@ -58,7 +58,7 @@ struct compressed_block {
  *
  * There is one special bin which is used to hold data_vios which have been canceled and removed
  * from their bin by the packer. These data_vios need to wait for the canceller to rendezvous with
- * them (VDO-2809) and so they sit in this special bin.
+ * them and so they sit in this special bin.
  */
 struct packer_bin {
 	/* List links for packer.packer_bins */
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index a75278eb8aa4..847aca9fbe47 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1504,8 +1504,8 @@ static int extract_new_mappings(struct repair_completion *repair)
 static noinline int compute_usages(struct repair_completion *repair)
 {
 	/*
-	 * VDO-5182: function is declared noinline to avoid what is likely a spurious valgrind
-	 * error about this structure being uninitialized.
+	 * This function is declared noinline to avoid a spurious valgrind error regarding the
+	 * following structure being uninitialized.
 	 */
 	struct recovery_point recovery_point = {
 		.sequence_number = repair->tail,
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 42126bd60242..5fa7e0838b32 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -334,7 +334,11 @@ static void launch_write(struct slab_summary_block *block)
 
 	/*
 	 * Flush before writing to ensure that the slab journal tail blocks and reference updates
-	 * covered by this summary update are stable (VDO-2332).
+	 * covered by this summary update are stable. Otherwise, a subsequent recovery could
+	 * encounter a slab summary update that refers to a slab journal tail block that has not
+	 * actually been written. In such cases, the slab journal referenced will be treated as
+	 * empty, causing any data within the slab which predates the existing recovery journal
+	 * entries to be lost.
 	 */
 	pbn = (depot->summary_origin +
 	       (VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE * allocator->zone_number) +
@@ -499,7 +503,7 @@ static void reap_slab_journal(struct slab_journal *journal)
 	 * journal block writes can be issued while previous slab summary updates have not yet been
 	 * made. Even though those slab journal block writes will be ignored if the slab summary
 	 * update is not persisted, they may still overwrite the to-be-reaped slab journal block
-	 * resulting in a loss of reference count updates (VDO-2912).
+	 * resulting in a loss of reference count updates.
 	 */
 	journal->flush_waiter.callback = flush_for_reaping;
 	acquire_vio_from_pool(journal->slab->allocator->vio_pool,
@@ -770,7 +774,8 @@ static void write_slab_journal_block(struct vdo_waiter *waiter, void *context)
 
 	/*
 	 * This block won't be read in recovery until the slab summary is updated to refer to it.
-	 * The slab summary update does a flush which is sufficient to protect us from VDO-2331.
+	 * The slab summary update does a flush which is sufficient to protect us from corruption
+	 * due to out of order slab journal, reference block, or block map writes.
 	 */
 	vdo_submit_metadata_vio(uds_forget(vio), block_number, write_slab_journal_endio,
 				complete_write, REQ_OP_WRITE);
@@ -1201,7 +1206,8 @@ static void write_reference_block(struct vdo_waiter *waiter, void *context)
 
 	/*
 	 * Flush before writing to ensure that the recovery journal and slab journal entries which
-	 * cover this reference update are stable (VDO-2331).
+	 * cover this reference update are stable. This prevents data corruption that can be caused
+	 * by out of order writes.
 	 */
 	WRITE_ONCE(block->slab->allocator->ref_counts_statistics.blocks_written,
 		   block->slab->allocator->ref_counts_statistics.blocks_written + 1);
@@ -1775,7 +1781,7 @@ static void add_entries(struct slab_journal *journal)
 		    (journal->slab->status == VDO_SLAB_REBUILDING)) {
 			/*
 			 * Don't add entries while rebuilding or while a partial write is
-			 * outstanding (VDO-2399).
+			 * outstanding, as it could result in reference count corruption.
 			 */
 			break;
 		}
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index e0eddd4007b8..a40f059d39b3 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -544,7 +544,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	int result;
 	struct vdo *vdo;
 
-	/* VDO-3769 - Set a generic reason so we don't ever return garbage. */
+	/* Initialize with a generic failure reason to prevent returning garbage. */
 	*reason = "Unspecified error";
 
 	result = uds_allocate(1, struct vdo, __func__, &vdo);
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index eb6838ddabbb..4832ea46551f 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -123,7 +123,6 @@ int create_multi_block_metadata_vio(struct vdo *vdo, enum vio_type vio_type,
 	struct vio *vio;
 	int result;
 
-	/* If struct vio grows past 256 bytes, we'll lose benefits of VDOSTORY-176. */
 	BUILD_BUG_ON(sizeof(struct vio) > 256);
 
 	/*
-- 
2.42.0

