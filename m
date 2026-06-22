Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9000F340A6F
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782149614; cv=none; b=K1LWANej6/rE4xXweTFYsy3szqB/ikMkxbHBhB2L8v2G0/9zUeQO53n0dXBp1kB0J6eoI9rLrMZ29Q81gcvXG6k57M47K64SeTIzimpuwN6EktrEpFs/MhHrXMKN49CQZOHT9Zzq1A5wlm7k9mj+nxuyfPU8ODO2YOQs57y0cwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782149614; c=relaxed/simple;
	bh=Ws0iHepMqF6ylgK8NxSF3jEzhbusVrPXWYQPjXeBPik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=b4YV0aISgZHHsXeBUBdZbdNZ1ZES7MUuLaT+kPbzZJCwdfkdvtvzrcd1X+P5/PHHHj+Xfc2ZS+nO4kww1VYfoOg8PEdFDYfbix8pXgNw9oBpvdKlhM9p98GxRJN9D1OiImEaXgi8sxpPF//Xg7ppwR4fRUlgEXVxYV6mtOAfQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BAiPzAQ7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BAiPzAQ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782149611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FDmb/TPfo1EUoppTFiiBDYuTjLlpYjNXev792oN7gbM=;
	b=BAiPzAQ7vYJNbM1OL8eEHxxSV0eNs/zl0mEDTT/aMqteCJtbDzqHjfyRka5vWPBOm9BH++
	rKx/CGCFc07KpziwLEsNykVD0YkL2VA6Icczus/c3uxJzWBr8X4m7fFic+LrZxeZ3ZjWFz
	Y7fsNNlxaCMidH3QRhZWiZywbv7OJ7c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-ktxmmdXQM-S4eGllAGXjLw-1; Mon,
 22 Jun 2026 13:33:28 -0400
X-MC-Unique: ktxmmdXQM-S4eGllAGXjLw-1
X-Mimecast-MFC-AGG-ID: ktxmmdXQM-S4eGllAGXjLw_1782149607
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30905195609D;
	Mon, 22 Jun 2026 17:33:27 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.13])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A7D1195419D;
	Mon, 22 Jun 2026 17:33:23 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH] dm thin metadata: fix metadata snapshot consistency on commit failure
Date: Tue, 23 Jun 2026 01:32:59 +0800
Message-ID: <20260622173259.127853-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pdult_uiOIPlEyT6T3YzWMG0CYenHTTPe4_ZsuJGTpY_1782149607
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

__reserve_metadata_snap() and __release_metadata_snap() modify the
superblock's held_root directly in the block_manager's buffer. If the
subsequent metadata commit fails, the held_root gets flushed to disk
through the abort_transaction path, resulting in inconsistent metadata.

Reproducer 1: __reserve_metadata_snap()

1. Create a 2 MiB metadata device and make the region after the 14th
   block inaccessible, to trigger metadata commit failure in the
   subsequent reserve_metadata_snap operation. The 14th block will be
   the shadow destination for the index block.

dmsetup create tmeta --table "0 112 linear /dev/sdc 0
112 3984 error"

2. Create a 16 MiB thin-pool

dmsetup create tdata --table "0 32768 zero"
dd if=/dev/zero of=/dev/mapper/tmeta bs=4k count=1
dmsetup create tpool --table "0 32768 thin-pool /dev/mapper/tmeta \
/dev/mapper/tdata 128 0 1 skip_block_zeroing"

3. Take a metadata snapshot to trigger metadata commit failure and
   transaction abort. However, the held_root is written to disk,
   breaking metadata consistency.

dmsetup message tpool 0 "reserve_metadata_snap"

thin_check v1.2.2 result:

Bad reference count for metadata block 6.  Expected 2, but space map contains 1.
Bad reference count for metadata block 7.  Expected 2, but space map contains 1.
Bad reference count for metadata block 13.  Expected 1, but space map contains 0.

Reproducer 2: __release_metadata_snap()

1. Create a 2 MiB metadata device and make the region after the 16th
   block inaccessible, to trigger metadata commit failure in the
   subsequent release_metadata_snap operation. The 16th block will be
   the shadow destination for the index block.

dmsetup create tmeta --table "0 128 linear /dev/sdc 0
128 3968 error"

2. Create a 16 MiB thin-pool

dmsetup create tdata --table "0 32768 zero"
dd if=/dev/zero of=/dev/mapper/tmeta bs=4k count=1
dmsetup create tpool --table "0 32768 thin-pool /dev/mapper/tmeta \
/dev/mapper/tdata 128 0 1 skip_block_zeroing"

3. Reserve then release the metadata snapshot, to trigger metadata
   commit failure and transaction abort. The held_root gets removed
   from the on-disk superblock, causing inconsistent metadata.

dmsetup message tpool 0 "reserve_metadata_snap"
dmsetup message tpool 0 "release_metadata_snap"

thin_check v1.2.2 result:

Bad reference count for metadata block 6.  Expected 1, but space map contains 2.
Bad reference count for metadata block 7.  Expected 1, but space map contains 2.
1 metadata blocks have leaked.

Fix by deferring the held_root update to commit time.

Additionally, move the existing-snapshot check before the shadow
operation in __reserve_metadata_snap to avoid unnecessary shadowing, and
move the pmd->held_root clearing to the end of __release_metadata_snap
to preserve the snapshot on teardown failure.

Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 59 ++++++++++-------------------------
 1 file changed, 16 insertions(+), 43 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index b6a2d2081a24..4fe65647f274 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -186,6 +186,7 @@ struct dm_pool_metadata {
 	uint32_t time;
 	dm_block_t root;
 	dm_block_t details_root;
+	dm_block_t held_root;
 	struct list_head thin_devices;
 	uint64_t trans_id;
 	unsigned long flags;
@@ -748,6 +749,7 @@ static int __open_metadata(struct dm_pool_metadata *pmd)
 	 */
 	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
 	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+	pmd->held_root = le64_to_cpu(disk_super->held_root);
 
 	__setup_btree_details(pmd);
 	dm_bm_unlock(sblock);
@@ -838,6 +840,7 @@ static int __begin_transaction(struct dm_pool_metadata *pmd)
 	pmd->time = le32_to_cpu(disk_super->time);
 	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
 	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+	pmd->held_root = le64_to_cpu(disk_super->held_root);
 	pmd->trans_id = le64_to_cpu(disk_super->trans_id);
 	pmd->flags = le32_to_cpu(disk_super->flags);
 	pmd->data_block_size = le32_to_cpu(disk_super->data_block_size);
@@ -928,6 +931,7 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	disk_super->time = cpu_to_le32(pmd->time);
 	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
 	disk_super->device_details_root = cpu_to_le64(pmd->details_root);
+	disk_super->held_root = cpu_to_le64(pmd->held_root);
 	disk_super->trans_id = cpu_to_le64(pmd->trans_id);
 	disk_super->flags = cpu_to_le32(pmd->flags);
 
@@ -1333,9 +1337,14 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 {
 	int r, inc;
 	struct thin_disk_superblock *disk_super;
-	struct dm_block *copy, *sblock;
+	struct dm_block *copy;
 	dm_block_t held_root;
 
+	if (pmd->held_root) {
+		DMWARN("Pool metadata snapshot already exists: release this before taking another.");
+		return -EBUSY;
+	}
+
 	/*
 	 * We commit to ensure the btree roots which we increment in a
 	 * moment are up to date.
@@ -1361,14 +1370,6 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 	held_root = dm_block_location(copy);
 	disk_super = dm_block_data(copy);
 
-	if (le64_to_cpu(disk_super->held_root)) {
-		DMWARN("Pool metadata snapshot already exists: release this before taking another.");
-
-		dm_tm_dec(pmd->tm, held_root);
-		dm_tm_unlock(pmd->tm, copy);
-		return -EBUSY;
-	}
-
 	/*
 	 * Wipe the spacemap since we're not publishing this.
 	 */
@@ -1384,18 +1385,8 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 	dm_tm_inc(pmd->tm, le64_to_cpu(disk_super->device_details_root));
 	dm_tm_unlock(pmd->tm, copy);
 
-	/*
-	 * Write the held root into the superblock.
-	 */
-	r = superblock_lock(pmd, &sblock);
-	if (r) {
-		dm_tm_dec(pmd->tm, held_root);
-		return r;
-	}
+	pmd->held_root = held_root;
 
-	disk_super = dm_block_data(sblock);
-	disk_super->held_root = cpu_to_le64(held_root);
-	dm_bm_unlock(sblock);
 	return 0;
 }
 
@@ -1415,18 +1406,10 @@ static int __release_metadata_snap(struct dm_pool_metadata *pmd)
 {
 	int r;
 	struct thin_disk_superblock *disk_super;
-	struct dm_block *sblock, *copy;
+	struct dm_block *copy;
 	dm_block_t held_root;
 
-	r = superblock_lock(pmd, &sblock);
-	if (r)
-		return r;
-
-	disk_super = dm_block_data(sblock);
-	held_root = le64_to_cpu(disk_super->held_root);
-	disk_super->held_root = cpu_to_le64(0);
-
-	dm_bm_unlock(sblock);
+	held_root = pmd->held_root;
 
 	if (!held_root) {
 		DMWARN("No pool metadata snapshot found: nothing to release.");
@@ -1444,6 +1427,8 @@ static int __release_metadata_snap(struct dm_pool_metadata *pmd)
 
 	dm_tm_unlock(pmd->tm, copy);
 
+	pmd->held_root = 0;
+
 	return 0;
 }
 
@@ -1462,19 +1447,7 @@ int dm_pool_release_metadata_snap(struct dm_pool_metadata *pmd)
 static int __get_metadata_snap(struct dm_pool_metadata *pmd,
 			       dm_block_t *result)
 {
-	int r;
-	struct thin_disk_superblock *disk_super;
-	struct dm_block *sblock;
-
-	r = dm_bm_read_lock(pmd->bm, THIN_SUPERBLOCK_LOCATION,
-			    &sb_validator, &sblock);
-	if (r)
-		return r;
-
-	disk_super = dm_block_data(sblock);
-	*result = le64_to_cpu(disk_super->held_root);
-
-	dm_bm_unlock(sblock);
+	*result = pmd->held_root;
 
 	return 0;
 }
-- 
2.49.0

