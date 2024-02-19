Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F4954BFA
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708374464; cv=none; b=urZKzgc4RLSa1oKIk8+mXh0jGMWBttddhCgikFi9UmC217x399hJRIfeuR/arz9yrijNEe5YabOYy+AClz83T5kYWQ6ur8BC96KFTwwfARum1Yqeby3kpNzigvj4/k92zTziyapjzEnRjRIX5q+PGF0A0hhfsTXbJqTqSyM48W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708374464; c=relaxed/simple;
	bh=1SY5s5odwrmeKC3lqMnA42I0IQF+B+XBjmN94TubDzg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=q/eV/aMKsozsiJP12Vz2vRtWen3HTfthgfFzATwx9IdL1hBjBEg3AzukLcLbxwr9CLxdInxWFSENvJ/3sTJKqUBOHw8H/yb5ZRgKC1CRuFje4adyTM0JdLsGjtEaTe2qfsOUg3woBbu+Gux23cRZI3p3Lb2QB7sX83gNYEINjtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hwV4RPEc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hwV4RPEc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708374460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CZ9nzIp6AU6eCjQhGqjijvyhMpPA9H4GRA2l8LFyClA=;
	b=hwV4RPEcevHWnFwU6XeyLJIZ5Hz4Kz/IdJUsiwc8SfgLD7Hgkc63sPt7eZ7V4hhkGTSVHv
	2yzQHteK4wM9We494ri1wqnukb87Q5fvSnO5jpMc3czJHRCConIa7LFA3hBDiUSUmnT/nD
	8szmNpBkqj9c1M09qhBBejmLm38kZco=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-w7mGHixTMzeoW-kVYsc4vQ-1; Mon,
 19 Feb 2024 15:27:39 -0500
X-MC-Unique: w7mGHixTMzeoW-kVYsc4vQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D3623C0008C
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:27:39 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 480A31121312;
	Mon, 19 Feb 2024 20:27:39 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 4086630C1B8F; Mon, 19 Feb 2024 20:27:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 3FB983FB4E;
	Mon, 19 Feb 2024 21:27:39 +0100 (CET)
Date: Mon, 19 Feb 2024 21:27:39 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/5] dm-integrity: recheck the integrity tag after a
 failure
In-Reply-To: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Message-ID: <19a8fd4a-8ac6-51d-87ed-ed8f10825aac@redhat.com>
References: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If a userspace process reads (with O_DIRECT) multiple blocks into the same
buffer, dm-integrity reports an error [1]. The error is reported in a log
and it may cause RAID leg being kicked out of the array.

This commit fixes dm-integrity, so that if integrity verification fails,
the data is read again into a kernel buffer (where userspace can't modify
it) and the integrity tag is rechecked. If the recheck succeeds, the
content of the kernel buffer is copied into the user buffer; if the
recheck fails, an integrity error is reported.

[1] https://people.redhat.com/~mpatocka/testcases/blk-auth-modify/read2.c

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |   92 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2024-02-18 18:04:00.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2024-02-19 17:22:29.000000000 +0100
@@ -278,6 +278,8 @@ struct dm_integrity_c {
 
 	atomic64_t number_of_mismatches;
 
+	mempool_t recheck_pool;
+
 	struct notifier_block reboot_notifier;
 };
 
@@ -1689,6 +1691,76 @@ failed:
 	get_random_bytes(result, ic->tag_size);
 }
 
+static void integrity_recheck(struct dm_integrity_io *dio)
+{
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct dm_integrity_c *ic = dio->ic;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	sector_t sector, logical_sector, area, offset;
+	char checksum_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+	struct page *page;
+	void *buffer;
+
+	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
+	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset, &dio->metadata_offset);
+	sector = get_data_sector(ic, area, offset);
+	logical_sector = dio->range.logical_sector;
+
+	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
+	buffer = page_to_virt(page);
+
+	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
+		unsigned pos = 0;
+
+		do {
+			char *mem;
+			int r;
+			struct dm_io_request io_req;
+			struct dm_io_region io_loc;
+			io_req.bi_opf = REQ_OP_READ;
+			io_req.mem.type = DM_IO_KMEM;
+			io_req.mem.ptr.addr = buffer;
+			io_req.notify.fn = NULL;
+			io_req.client = ic->io;
+			io_loc.bdev = ic->dev->bdev;
+			io_loc.sector = sector;
+			io_loc.count = ic->sectors_per_block;
+
+			r = dm_io(&io_req, 1, &io_loc, NULL);
+			if (unlikely(r)) {
+				dio->bi_status = errno_to_blk_status(r);
+				goto free_ret;
+			}
+
+			integrity_sector_checksum(ic, logical_sector, buffer, checksum_onstack);
+			r = dm_integrity_rw_tag(ic, checksum_onstack, &dio->metadata_block, &dio->metadata_offset,
+						ic->tag_size, TAG_CMP);
+			if (r) {
+				if (r > 0) {
+					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx", bio->bi_bdev, logical_sector);
+					atomic64_inc(&ic->number_of_mismatches);
+					dm_audit_log_bio(DM_MSG_PREFIX, "integrity-checksum", bio, logical_sector, 0);
+					r = -EILSEQ;
+				}
+				dio->bi_status = errno_to_blk_status(r);
+				goto free_ret;
+			}
+
+			mem = bvec_kmap_local(&bv);
+			memcpy(mem + pos, buffer, ic->sectors_per_block << SECTOR_SHIFT);
+			kunmap_local(mem);
+
+			pos += ic->sectors_per_block << SECTOR_SHIFT;
+			sector += ic->sectors_per_block;
+			logical_sector += ic->sectors_per_block;
+		} while (pos < bv.bv_len);
+	}
+
+free_ret:
+	mempool_free(page, &ic->recheck_pool);
+}
+
 static void integrity_metadata(struct work_struct *w)
 {
 	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
@@ -1776,15 +1848,8 @@ again:
 						checksums_ptr - checksums, dio->op == REQ_OP_READ ? TAG_CMP : TAG_WRITE);
 			if (unlikely(r)) {
 				if (r > 0) {
-					sector_t s;
-
-					s = sector - ((r + ic->tag_size - 1) / ic->tag_size);
-					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
-						    bio->bi_bdev, s);
-					r = -EILSEQ;
-					atomic64_inc(&ic->number_of_mismatches);
-					dm_audit_log_bio(DM_MSG_PREFIX, "integrity-checksum",
-							 bio, s, 0);
+					integrity_recheck(dio);
+					goto skip_io;
 				}
 				if (likely(checksums != checksums_onstack))
 					kfree(checksums);
@@ -4261,6 +4326,12 @@ static int dm_integrity_ctr(struct dm_ta
 		goto bad;
 	}
 
+	r = mempool_init_page_pool(&ic->recheck_pool, 1, 0);
+	if (r) {
+		ti->error = "Cannot allocate mempool";
+		goto bad;
+	}
+
 	ic->metadata_wq = alloc_workqueue("dm-integrity-metadata",
 					  WQ_MEM_RECLAIM, METADATA_WORKQUEUE_MAX_ACTIVE);
 	if (!ic->metadata_wq) {
@@ -4609,6 +4680,7 @@ static void dm_integrity_dtr(struct dm_t
 	kvfree(ic->bbs);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
+	mempool_exit(&ic->recheck_pool);
 	mempool_exit(&ic->journal_io_mempool);
 	if (ic->io)
 		dm_io_client_destroy(ic->io);
@@ -4661,7 +4733,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 10, 0},
+	.version		= {1, 11, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,

