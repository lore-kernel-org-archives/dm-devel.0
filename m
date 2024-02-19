Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA0E3E470
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708374677; cv=none; b=M4w7YHn8lnY3+MayKsYw0Jy3wPUa1uz7FqD6s1Dr0wGqXUQuUInJI/Xtr18vB+jrggpl8Ce94O1Thp8Bl/71N5xDLsLeOcJsgxwr4xnZtuauAYSkn8qJ0e27sG0jsgWz2zab91CvJtU66+y5/1kPt0AHZBhWFF6NFIHKg4Y7xv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708374677; c=relaxed/simple;
	bh=k9ibS4MjBKAt5EA77xj37GOB1GY+HKxuix8vHE4ecsY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sovSwARkKX5OB97zUpcC57X3VO+VdWZPJe2+Uzdr+g499ZI8/zw8Cct5oJ+N42+HtWMFTgKr+sMqMTXOK+X9phL2AkBX7+uH2/nUbwXcz3Mt8I9LtMl7nGAI2ky0yWc4h4MQ6RM047eI9v9LIpxkVraeD4bAOTXLApyrrdw/jgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=imxBBDkZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="imxBBDkZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708374674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAjtG3DynyKh4HULEJu2aSkVl6pZfRAdugHK9xWpBe0=;
	b=imxBBDkZpdv7uFR5V2BUJN0roQ1iqQS+JcDmQQabIDDx/HvuBFzlOQzJoA+Xv1tJo9eZSf
	BPOK1LfDXgUzDDQ43KG4cmdd3R+/cDDuNxaAcBn/iRAXWZkxr4lBp0d6QGFxUzxumyYWIt
	YafYg76bRT2Lhbub4BN7pbnlu1Tpjj8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-xqWIv7B-POqvxk9EDklnMg-1; Mon,
 19 Feb 2024 15:31:12 -0500
X-MC-Unique: xqWIv7B-POqvxk9EDklnMg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D71341C04182
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:31:11 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1DF0AD76;
	Mon, 19 Feb 2024 20:31:11 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id CA88730C1B8F; Mon, 19 Feb 2024 20:31:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id C97823FB4E;
	Mon, 19 Feb 2024 21:31:11 +0100 (CET)
Date: Mon, 19 Feb 2024 21:31:11 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 5/5] dm-crypt: recheck the integrity tag after a failure
In-Reply-To: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Message-ID: <7641d5f-ebe-f7db-35b7-d64e6d65476@redhat.com>
References: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If a userspace process reads (with O_DIRECT) multiple blocks into the same
buffer, dm-crypt reports an authentication error [1]. The error is
reported in a log and it may cause RAID leg being kicked out of the
array.

This commit fixes dm-crypt, so that if integrity verification fails, the
data is read again into a kernel buffer (where userspace can't modify it)
and the integrity tag is rechecked. If the recheck succeeds, the content
of the kernel buffer is copied into the user buffer; if the recheck fails,
an integrity error is reported.

[1] https://people.redhat.com/~mpatocka/testcases/blk-auth-modify/read2.c

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-crypt.c |   91 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 74 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2024-02-19 17:23:43.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2024-02-19 17:23:48.000000000 +0100
@@ -62,6 +62,8 @@ struct convert_context {
 		struct skcipher_request *req;
 		struct aead_request *req_aead;
 	} r;
+	bool aead_recheck;
+	bool aead_failed;
 
 };
 
@@ -82,6 +84,8 @@ struct dm_crypt_io {
 	blk_status_t error;
 	sector_t sector;
 
+	struct bvec_iter saved_bi_iter;
+
 	struct rb_node rb_node;
 } CRYPTO_MINALIGN_ATTR;
 
@@ -1370,10 +1374,13 @@ static int crypt_convert_block_aead(stru
 	if (r == -EBADMSG) {
 		sector_t s = le64_to_cpu(*sector);
 
-		DMERR_LIMIT("%pg: INTEGRITY AEAD ERROR, sector %llu",
-			    ctx->bio_in->bi_bdev, s);
-		dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
-				 ctx->bio_in, s, 0);
+		ctx->aead_failed = true;
+		if (ctx->aead_recheck) {
+			DMERR_LIMIT("%pg: INTEGRITY AEAD ERROR, sector %llu",
+				    ctx->bio_in->bi_bdev, s);
+			dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
+					 ctx->bio_in, s, 0);
+		}
 	}
 
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
@@ -1757,6 +1764,8 @@ static void crypt_io_init(struct dm_cryp
 	io->base_bio = bio;
 	io->sector = sector;
 	io->error = 0;
+	io->ctx.aead_recheck = false;
+	io->ctx.aead_failed = false;
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
@@ -1768,6 +1777,8 @@ static void crypt_inc_pending(struct dm_
 	atomic_inc(&io->io_pending);
 }
 
+static void kcryptd_queue_read(struct dm_crypt_io *io);
+
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
@@ -1781,6 +1792,15 @@ static void crypt_dec_pending(struct dm_
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
+	if (likely(!io->ctx.aead_recheck) && unlikely(io->ctx.aead_failed) &&
+	    cc->on_disk_tag_size && bio_data_dir(base_bio) == READ) {
+		io->ctx.aead_recheck = true;
+		io->ctx.aead_failed = false;
+		io->error = 0;
+		kcryptd_queue_read(io);
+		return;
+	}
+
 	if (io->ctx.r.req)
 		crypt_free_req(cc, io->ctx.r.req, base_bio);
 
@@ -1816,15 +1836,19 @@ static void crypt_endio(struct bio *clon
 	struct dm_crypt_io *io = clone->bi_private;
 	struct crypt_config *cc = io->cc;
 	unsigned int rw = bio_data_dir(clone);
-	blk_status_t error;
+	blk_status_t error = clone->bi_status;
+
+	if (io->ctx.aead_recheck && !error) {
+		kcryptd_queue_crypt(io);
+		return;
+	}
 
 	/*
 	 * free the processed pages
 	 */
-	if (rw == WRITE)
+	if (rw == WRITE || io->ctx.aead_recheck)
 		crypt_free_buffer_pages(cc, clone);
 
-	error = clone->bi_status;
 	bio_put(clone);
 
 	if (rw == READ && !error) {
@@ -1845,6 +1869,22 @@ static int kcryptd_io_read(struct dm_cry
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
 
+	if (io->ctx.aead_recheck) {
+		if (!(gfp & __GFP_DIRECT_RECLAIM))
+			return 1;
+		crypt_inc_pending(io);
+		clone = crypt_alloc_buffer(io, io->base_bio->bi_iter.bi_size);
+		if (unlikely(!clone)) {
+			crypt_dec_pending(io);
+			return 1;
+		}
+		clone->bi_iter.bi_sector = cc->start + io->sector;
+		crypt_convert_init(cc, &io->ctx, clone, clone, io->sector);
+		io->saved_bi_iter = clone->bi_iter;
+		dm_submit_bio_remap(io->base_bio, clone);
+		return 0;
+	}
+
 	/*
 	 * We need the original biovec array in order to decrypt the whole bio
 	 * data *afterwards* -- thanks to immutable biovecs we don't need to
@@ -2113,6 +2153,14 @@ dec:
 
 static void kcryptd_crypt_read_done(struct dm_crypt_io *io)
 {
+	if (io->ctx.aead_recheck) {
+		if (!io->error) {
+			io->ctx.bio_in->bi_iter = io->saved_bi_iter;
+			bio_copy_data(io->base_bio, io->ctx.bio_in);
+		}
+		crypt_free_buffer_pages(io->cc, io->ctx.bio_in);
+		bio_put(io->ctx.bio_in);
+	}
 	crypt_dec_pending(io);
 }
 
@@ -2142,11 +2190,17 @@ static void kcryptd_crypt_read_convert(s
 
 	crypt_inc_pending(io);
 
-	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
-			   io->sector);
+	if (io->ctx.aead_recheck) {
+		io->ctx.cc_sector = io->sector + cc->iv_offset;
+		r = crypt_convert(cc, &io->ctx,
+				  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags), true);
+	} else {
+		crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
+				   io->sector);
 
-	r = crypt_convert(cc, &io->ctx,
-			  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags), true);
+		r = crypt_convert(cc, &io->ctx,
+				  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags), true);
+	}
 	/*
 	 * Crypto API backlogged the request, because its queue was full
 	 * and we're in softirq context, so continue from a workqueue
@@ -2188,10 +2242,13 @@ static void kcryptd_async_done(void *dat
 	if (error == -EBADMSG) {
 		sector_t s = le64_to_cpu(*org_sector_of_dmreq(cc, dmreq));
 
-		DMERR_LIMIT("%pg: INTEGRITY AEAD ERROR, sector %llu",
-			    ctx->bio_in->bi_bdev, s);
-		dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
-				 ctx->bio_in, s, 0);
+		ctx->aead_failed = true;
+		if (ctx->aead_recheck) {
+			DMERR_LIMIT("%pg: INTEGRITY AEAD ERROR, sector %llu",
+				    ctx->bio_in->bi_bdev, s);
+			dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
+					 ctx->bio_in, s, 0);
+		}
 		io->error = BLK_STS_PROTECTION;
 	} else if (error < 0)
 		io->error = BLK_STS_IOERR;
@@ -3116,7 +3173,7 @@ static int crypt_ctr_optional(struct dm_
 			sval = strchr(opt_string + strlen("integrity:"), ':') + 1;
 			if (!strcasecmp(sval, "aead")) {
 				set_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags);
-			} else  if (strcasecmp(sval, "none")) {
+			} else if (strcasecmp(sval, "none")) {
 				ti->error = "Unknown integrity profile";
 				return -EINVAL;
 			}
@@ -3645,7 +3702,7 @@ static void crypt_io_hints(struct dm_tar
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 24, 0},
+	.version = {1, 25, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,

