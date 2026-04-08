Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A7D1DB54C
	for <dm-devel@lists.linux.dev>; Wed,  8 Apr 2026 04:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775622958; cv=none; b=ZsUcSEnaoI7n3ibqBDKQgejrGg1fQ487XBOszcHA8U1WGCrOO1uvJMaW3eqcJGGaSA6XlJEPKem00XS/rV9SWASvSQXeGdc4cA1V46piq42VgVKg/22s1B9p8HeKIMH+Ii/DBh6l2mMr91PexdW/P8lQd7nBc0DsQ+h3sk6BJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775622958; c=relaxed/simple;
	bh=5Oe+UsEMNx3bxKzTGa6YqLAediC0OFWpsfWjM4hNFds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=m+xY452Mb0JU00AiqyAa2pghxXoILewutAsa3chHIdXfc8ic8yLdCTBgpeUt4xsOhI4ebzNM9CMTqIZClqh24NInejbXHLAA6QZtHtXZ7QcZW1ZOgUF2yPdjUkJoqXGKhjonHmOTDmJxgote89rC84L4GIpry1CVNCy3N58ZrkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OnyGumGv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OnyGumGv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775622956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HEz85F+/jvcM4SArY890q1eeVx6NNjXktLYu31uOHRQ=;
	b=OnyGumGvKemK+Cbt8TH/a4kCRzkkyadqUQaUp1Q5mQku5+mNBD5OTgJ0sqkgDjCRF1ufCT
	C6y+DXXTBEjtcqQdPklE2cf25Ka2AWjT/mohxVoNrpoPX7w83J1pZZKv1oDEIG02KPX4a5
	Q8Rfdp6QLdZqfWdtqQlbSzJLxqk6SXw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-8dvQ7d3pOLCDmjJK7qihNg-1; Wed,
 08 Apr 2026 00:35:52 -0400
X-MC-Unique: 8dvQ7d3pOLCDmjJK7qihNg-1
X-Mimecast-MFC-AGG-ID: 8dvQ7d3pOLCDmjJK7qihNg_1775622951
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 182F9180034E;
	Wed,  8 Apr 2026 04:35:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38FD01955D84;
	Wed,  8 Apr 2026 04:35:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6384ZnMV1695166
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Apr 2026 00:35:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6384Zm1K1695165;
	Wed, 8 Apr 2026 00:35:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>,
        Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
        Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH v2] md/raid5: Fix UAF on IO across the reshape position
Date: Wed,  8 Apr 2026 00:35:48 -0400
Message-ID: <20260408043548.1695157-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: YLRCLo8c71vtJqX1Z-tmxuJn9nY6DbfMUsY1q1hUGHo_1775622951
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
raid5_make_request() will free the cloned bio. But raid5_make_request()
can call make_stripe_request() multiple times, writing to the various
stripes. If that bio got added to the toread or towrite lists of a
stripe disk in an earlier call to make_stripe_request(), then it's not
safe to just free the bio if a later part of it is found to cross the
reshape position. Doing so can lead to a UAF error, when bio_endio()
is called on the bio for the earlier stripes.

Instead, raid5_make_request() needs to wait until all parts of the bio
have called bio_endio(). To do this, bios that cross the reshape
position while the reshape can't make progress are flagged as needing to
wait for all parts to complete. When raid5_make_request() has a bio that
failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
bi->bi_private to a completion struct and waits for completion after
ending the bio.  When the bio_endio() is called for the last time on a
clone bio with bi->bi_private set, it wakes up the waiter. This
guarantees that raid5_make_request() doesn't return until the cloned bio
needing a retry for io across the reshape boundary is safely cleaned up.

There is a simple reproducer available at [1]. Compile the kernel with
KASAN for more useful reporting when the error is triggered (this is not
necessary to see the bug).

[1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Changes from v1:
- Removed mddev->pending_retry_bios, mddev->retry_bios_wait, and
  md_io_clone->must_retry. Instead, use a completion struct
  pointed to by bi->bi_private, as suggested by Xiao Ni and Yu Kuai.

 drivers/md/md.c    | 31 ++++++++-----------------------
 drivers/md/md.h    |  1 -
 drivers/md/raid5.c |  7 ++++++-
 3 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e..4318d875a5f6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9215,9 +9215,11 @@ static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 
 static void md_end_clone_io(struct bio *bio)
 {
-	struct md_io_clone *md_io_clone = bio->bi_private;
+	struct md_io_clone *md_io_clone = container_of(bio, struct md_io_clone,
+						       bio_clone);
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
+	struct completion *reshape_completion = bio->bi_private;
 
 	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
@@ -9229,7 +9231,10 @@ static void md_end_clone_io(struct bio *bio)
 		bio_end_io_acct(orig_bio, md_io_clone->start_time);
 
 	bio_put(bio);
-	bio_endio(orig_bio);
+	if (unlikely(reshape_completion))
+		complete(reshape_completion);
+	else
+		bio_endio(orig_bio);
 	percpu_ref_put(&mddev->active_io);
 }
 
@@ -9254,7 +9259,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	}
 
 	clone->bi_end_io = md_end_clone_io;
-	clone->bi_private = md_io_clone;
+	clone->bi_private = NULL;
 	*bio = clone;
 }
 
@@ -9265,26 +9270,6 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
 }
 EXPORT_SYMBOL_GPL(md_account_bio);
 
-void md_free_cloned_bio(struct bio *bio)
-{
-	struct md_io_clone *md_io_clone = bio->bi_private;
-	struct bio *orig_bio = md_io_clone->orig_bio;
-	struct mddev *mddev = md_io_clone->mddev;
-
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
-		md_bitmap_end(mddev, md_io_clone);
-
-	if (bio->bi_status && !orig_bio->bi_status)
-		orig_bio->bi_status = bio->bi_status;
-
-	if (md_io_clone->start_time)
-		bio_end_io_acct(orig_bio, md_io_clone->start_time);
-
-	bio_put(bio);
-	percpu_ref_put(&mddev->active_io);
-}
-EXPORT_SYMBOL_GPL(md_free_cloned_bio);
-
 /* md_allow_write(mddev)
  * Calling this ensures that the array is marked 'active' so that writes
  * may proceed without blocking.  It is important to call this before
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..5d57fee22901 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -917,7 +917,6 @@ extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
-void md_free_cloned_bio(struct bio *bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8e8d431071b..dc0c680ca199 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6217,7 +6217,12 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 
 	mempool_free(ctx, conf->ctx_pool);
 	if (res == STRIPE_WAIT_RESHAPE) {
-		md_free_cloned_bio(bi);
+		DECLARE_COMPLETION_ONSTACK(done);
+		WRITE_ONCE(bi->bi_private, &done);
+
+		bio_endio(bi);
+
+		wait_for_completion(&done);
 		return false;
 	}
 
-- 
2.53.0

