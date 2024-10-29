Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3FC1DEFE2
	for <dm-devel@lists.linux.dev>; Tue, 29 Oct 2024 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730200643; cv=none; b=B2tE261sCtANpuoqqAsmvaqloK5oQ0BYRw8wUhMDXxiq29/6VJaxfFd/K9riFmnO8CxTyMorIs3O9JjiDrMG3imTMZBA8xN44B8OlsbpxyV5JwrqkRmi3aLvypFinqswQxA1PZtZ2UJYLzhjau5pelT8iiniqPQThKJ1d8A0aLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730200643; c=relaxed/simple;
	bh=dkGzGyg7pdKTMS+3YZbBUPxaK0vjC+JMzFAdFP9wlQI=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=ergOj+7eFbDNKA0luYJ2stlEx5qP6UoSUSU9RlPHUcTv9mId9vmXYr7aMfxq8RYwuXBtANxQyLODLDN6zMjaIzfG3EiK09brW4C6WGRlR3JWPvna/LQsWhJ5/x8XtdHnnIZC4OjSmY8K6fQqNdJGAegqCC3iZvp/ZW7mMfQ0F7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CxK6sYts; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxK6sYts"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730200640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=GC/YdOJ4KcSCF7T2Hs84AdUEiIyx1+HRMTLf6wuefPE=;
	b=CxK6sYtspkkhCAaPZcTdxMxMHcg21t461duVf9pIno1c8BcC+n/4KWhYMAns4KRUFpWh0I
	SAYPiTi6FJkZ94Yzj02G27dXDRfcHSm6Fjdj/8w+c0HMTCOXkho88fc4tmoZlbF2TGoLWV
	rgLcJu6HKI7swBfCUZH94AFQV506ntU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-Otcs7_m-MiKvsicdP3jNvA-1; Tue,
 29 Oct 2024 07:17:19 -0400
X-MC-Unique: Otcs7_m-MiKvsicdP3jNvA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52BD919560A5;
	Tue, 29 Oct 2024 11:17:18 +0000 (UTC)
Received: from [10.45.226.64] (unknown [10.45.226.64])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D4C5300018D;
	Tue, 29 Oct 2024 11:17:16 +0000 (UTC)
Date: Tue, 29 Oct 2024 12:17:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Sami Tolvanen <samitolvanen@google.com>, Will Drewry <wad@chromium.org>, 
    agk@redhat.com, snitzer@kernel.org, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-verity: don't crash if panic_on_corruption is not
 selected
Message-ID: <5f7c2e37-fd4f-4371-3b0d-633b5a99743a@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If the user sets panic_on_error and doesn't set panic_on_corruption,
dm-verity should not panic on data mismatch. But, currently it panics,
because it treats data mismatch as I/O error.

This commit fixes the logic so that if there is data mismatch and
panic_on_corruption or restart_on_corruption is not selected, the system
won't restart or panic.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: f811b83879fb ("dm-verity: introduce the options restart_on_error and panic_on_error")

---
 drivers/md/dm-verity-target.c |    9 ++++++---
 drivers/md/dm-verity.h        |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-10-16 16:42:46.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-10-16 17:11:13.000000000 +0200
@@ -356,9 +356,9 @@ static int verity_verify_level(struct dm
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block)) {
-			struct bio *bio =
-				dm_bio_from_per_bio_data(io,
-							 v->ti->per_io_data_size);
+			struct bio *bio;
+			io->had_mismatch = true;
+			bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 			dm_audit_log_bio(DM_MSG_PREFIX, "verify-metadata", bio,
 					 block, 0);
 			r = -EIO;
@@ -482,6 +482,7 @@ static int verity_handle_data_hash_misma
 		return -EIO; /* Error correction failed; Just return error */
 
 	if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA, blkno)) {
+		io->had_mismatch = true;
 		dm_audit_log_bio(DM_MSG_PREFIX, "verify-data", bio, blkno, 0);
 		return -EIO;
 	}
@@ -606,6 +607,7 @@ static void verity_finish_io(struct dm_v
 
 	if (unlikely(status != BLK_STS_OK) &&
 	    unlikely(!(bio->bi_opf & REQ_RAHEAD)) &&
+	    !io->had_mismatch &&
 	    !verity_is_system_shutting_down()) {
 		if (v->error_mode == DM_VERITY_MODE_PANIC) {
 			panic("dm-verity device has I/O error");
@@ -779,6 +781,7 @@ static int verity_map(struct dm_target *
 	io->orig_bi_end_io = bio->bi_end_io;
 	io->block = bio->bi_iter.bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
 	io->n_blocks = bio->bi_iter.bi_size >> v->data_dev_block_bits;
+	io->had_mismatch = false;
 
 	bio->bi_end_io = verity_end_io;
 	bio->bi_private = io;
Index: linux-2.6/drivers/md/dm-verity.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity.h	2024-10-16 16:41:30.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity.h	2024-10-16 17:06:37.000000000 +0200
@@ -92,6 +92,7 @@ struct dm_verity_io {
 	sector_t block;
 	unsigned int n_blocks;
 	bool in_bh;
+	bool had_mismatch;
 
 	struct work_struct work;
 	struct work_struct bh_work;

