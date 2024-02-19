Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76C9524BC
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708374497; cv=none; b=iZhhn7JUWBd63+UEJg0+HTnIps2U2Flvx0DoFtDbcUPrjseWbNcdNLaQYD0mGKE6RJa8Kv1iptaTSEk6qm4sjNQp/5p8ISX6gHouS4mVrIiZJFh7zPdlmCZl4JJsj9FJY70lxCeQvNmFXNP4LpRnVrLqNQaukPX2y5UnuwM9oXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708374497; c=relaxed/simple;
	bh=iKOLAMrv4xQ5M41TgNeqm2wpflyVbx3KB7iUu8P5nLk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iR6pFEhXxcgBs8VTe0UHHN+eYEiMXYtFPMhoGgqh/Dbf5MBe0aGVLfMXO5Bp1v3BJAEmuMQ9AKGkDulfukS/Lv7yQUKV0z65wnL1UD6pCchraDCFo4/7zMLZHfLxOsxlE6zscg6AQY8FQ0kvFDzBFdv8Pn4XSPjJ8iEMZGu5blE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F0E5rtl3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F0E5rtl3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708374492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dI0o3P5gx0q0niKI8uaAwxD49czrphIfu7Ddu29eyh0=;
	b=F0E5rtl3ImWtk31ZpoyMqLdi+pm3J8ZbT/KePgFzqIsbIImKfHaMazpdf+En4kE71z1U3I
	mKM/LJKk53Sj6JoC8VCtD2/jHFwiPnsKb68gxktTxa4FGOkv8QhIKFSNMlWdT8vceEx1Yy
	mDGUck7EpiYdaD095EEo/FpdE5vu+SQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-a2UQwJnpNOmK4eMBrps2kQ-1; Mon, 19 Feb 2024 15:28:09 -0500
X-MC-Unique: a2UQwJnpNOmK4eMBrps2kQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2165D85A58F
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:28:09 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17C48492BC6;
	Mon, 19 Feb 2024 20:28:09 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 11E7630C1B8F; Mon, 19 Feb 2024 20:28:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 1127F3FB4E;
	Mon, 19 Feb 2024 21:28:09 +0100 (CET)
Date: Mon, 19 Feb 2024 21:28:09 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/5] dm-verity: recheck the hash after a failure
In-Reply-To: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Message-ID: <2eaf23b3-557f-89a5-48a3-4e45edd8cf2@redhat.com>
References: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If a userspace process reads (with O_DIRECT) multiple blocks into the same
buffer, dm-verity reports an error [1].

This commit fixes dm-verity, so that if hash verification fails, the data
is read again into a kernel buffer (where userspace can't modify it) and
the hash is rechecked. If the recheck succeeds, the content of the kernel
buffer is copied into the user buffer; if the recheck fails, an error is
reported.

[1] https://people.redhat.com/~mpatocka/testcases/blk-auth-modify/read2.c

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-target.c |   87 ++++++++++++++++++++++++++++++++++++++----
 drivers/md/dm-verity.h        |    6 ++
 2 files changed, 86 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-02-19 17:22:37.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-02-19 17:24:04.000000000 +0100
@@ -482,6 +482,62 @@ int verity_for_bv_block(struct dm_verity
 	return 0;
 }
 
+static int verity_recheck_copy(struct dm_verity *v, struct dm_verity_io *io,
+			       u8 *data, size_t len)
+{
+	memcpy(data, io->recheck_buffer, len);
+	io->recheck_buffer += len;
+
+	return 0;
+}
+
+static int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
+			  struct bvec_iter start, sector_t cur_block)
+{
+	struct page *page;
+	void *buffer;
+	int r;
+	struct dm_io_request io_req;
+	struct dm_io_region io_loc;
+
+	page = mempool_alloc(&v->recheck_pool, GFP_NOIO);
+	buffer = page_to_virt(page);
+
+	io_req.bi_opf = REQ_OP_READ;
+	io_req.mem.type = DM_IO_KMEM;
+	io_req.mem.ptr.addr = buffer;
+	io_req.notify.fn = NULL;
+	io_req.client = v->io;
+	io_loc.bdev = v->data_dev->bdev;
+	io_loc.sector = cur_block << (v->data_dev_block_bits - SECTOR_SHIFT);
+	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
+	r = dm_io(&io_req, 1, &io_loc, NULL);
+	if (unlikely(r))
+		goto free_ret;
+
+	r = verity_hash(v, verity_io_hash_req(v, io), buffer, 1 << v->data_dev_block_bits,
+			verity_io_real_digest(v, io), true);
+
+	if (unlikely(r))
+		goto free_ret;
+
+	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io), v->digest_size)) {
+		r = -EIO;
+		goto free_ret;
+	}
+
+	io->recheck_buffer = buffer;
+	r = verity_for_bv_block(v, io, &start, verity_recheck_copy);
+	if (unlikely(r))
+		goto free_ret;
+
+	r = 0;
+free_ret:
+	mempool_free(page, &v->recheck_pool);
+
+	return r;
+}
+
 static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *data, size_t len)
 {
@@ -508,9 +564,7 @@ static int verity_verify_io(struct dm_ve
 {
 	bool is_zero;
 	struct dm_verity *v = io->v;
-#if defined(CONFIG_DM_VERITY_FEC)
 	struct bvec_iter start;
-#endif
 	struct bvec_iter iter_copy;
 	struct bvec_iter *iter;
 	struct crypto_wait wait;
@@ -561,10 +615,7 @@ static int verity_verify_io(struct dm_ve
 		if (unlikely(r < 0))
 			return r;
 
-#if defined(CONFIG_DM_VERITY_FEC)
-		if (verity_fec_is_enabled(v))
-			start = *iter;
-#endif
+		start = *iter;
 		r = verity_for_io_block(v, io, iter, &wait);
 		if (unlikely(r < 0))
 			return r;
@@ -586,6 +637,10 @@ static int verity_verify_io(struct dm_ve
 			 * tasklet since it may sleep, so fallback to work-queue.
 			 */
 			return -EAGAIN;
+		} else if (verity_recheck(v, io, start, cur_block) == 0) {
+			if (v->validated_blocks)
+				set_bit(cur_block, v->validated_blocks);
+			continue;
 #if defined(CONFIG_DM_VERITY_FEC)
 		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
 					     cur_block, NULL, &start) == 0) {
@@ -941,6 +996,10 @@ static void verity_dtr(struct dm_target
 	if (v->verify_wq)
 		destroy_workqueue(v->verify_wq);
 
+	mempool_exit(&v->recheck_pool);
+	if (v->io)
+		dm_io_client_destroy(v->io);
+
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
@@ -1379,6 +1438,20 @@ static int verity_ctr(struct dm_target *
 	}
 	v->hash_blocks = hash_position;
 
+	r = mempool_init_page_pool(&v->recheck_pool, 1, 0);
+	if (unlikely(r)) {
+		ti->error = "Cannot allocate mempool";
+		goto bad;
+	}
+
+	v->io = dm_io_client_create();
+	if (IS_ERR(v->io)) {
+		r = PTR_ERR(v->io);
+		v->io = NULL;
+		ti->error = "Cannot allocate dm io";
+		goto bad;
+	}
+
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
 		dm_bufio_alloc_callback, NULL,
@@ -1486,7 +1559,7 @@ int dm_verity_get_root_digest(struct dm_
 static struct target_type verity_target = {
 	.name		= "verity",
 	.features	= DM_TARGET_IMMUTABLE,
-	.version	= {1, 9, 0},
+	.version	= {1, 10, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
Index: linux-2.6/drivers/md/dm-verity.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity.h	2024-02-19 17:22:37.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity.h	2024-02-19 17:22:37.000000000 +0100
@@ -11,6 +11,7 @@
 #ifndef DM_VERITY_H
 #define DM_VERITY_H
 
+#include <linux/dm-io.h>
 #include <linux/dm-bufio.h>
 #include <linux/device-mapper.h>
 #include <linux/interrupt.h>
@@ -68,6 +69,9 @@ struct dm_verity {
 	unsigned long *validated_blocks; /* bitset blocks validated */
 
 	char *signature_key_desc; /* signature keyring reference */
+
+	struct dm_io_client *io;
+	mempool_t recheck_pool;
 };
 
 struct dm_verity_io {
@@ -84,6 +88,8 @@ struct dm_verity_io {
 
 	struct work_struct work;
 
+	char *recheck_buffer;
+
 	/*
 	 * Three variably-size fields follow this struct:
 	 *

