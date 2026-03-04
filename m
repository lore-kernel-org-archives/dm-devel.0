Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3843DA5BC
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651087; cv=none; b=VOCsu4FmprdMGjGyd8tcLPnt26O2DXFjMIK4yPo8vJYKJvrhZ5o8Sr+vhFsgn9u5E5bxtXT/kVryr8300jYwiN/j4ghdAPDOPNcTNgfRKoHXpzLt76kaixfmn3z0WTx1MRrEdX3nmxsXAUF1Hy/WMPEd6nMJK0Er9Dw4Ow4o6II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651087; c=relaxed/simple;
	bh=BGwt7vwDCNf5WQi6ZmYsfu/4zMuWe7hZj2XX4UEX1oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=J8f1/lDULG5bWPTB5kM93eHTkJS3zgq82NeX95EayC+T8SAesjU3sJ7/neYM4X7kC4MbPNdCAOG4QRZuBvslLw+DD0i0dl5mkQUN7kDD+C+2nQ3i186UQDwFVsD9NL8vXL1piYOCxOI14/cXLmvrsr4UbZ8mgpTKxm1SqQLa9pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F12h+fKw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F12h+fKw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772651085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjLvbwBfqfXiZnaMfS45T56EHtgzdALqjSiM9T5ouBw=;
	b=F12h+fKw6zHhjfOlbOFQI82y6P5PlMwr8y0lu/dgkzxCXPoZYV+9aMnBYIpXj6BrQ2XX0q
	Qp0qm3enoNMjrZC61gSK5xb8gubCZcuhDeMHVYXB55MQKwrIy0Gtt0xMUZ8D+b73kNKgci
	dJaU+vmVg6zS5sFoe20vaoNEJaQYCjE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321--lemc0VmNrClkT2m_r8aQg-1; Wed,
 04 Mar 2026 14:04:42 -0500
X-MC-Unique: -lemc0VmNrClkT2m_r8aQg-1
X-Mimecast-MFC-AGG-ID: -lemc0VmNrClkT2m_r8aQg_1772651081
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3448195605C;
	Wed,  4 Mar 2026 19:04:40 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D8CD81800576;
	Wed,  4 Mar 2026 19:04:37 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] bio: use bio_io_error more often
Date: Wed,  4 Mar 2026 20:04:09 +0100
Message-ID: <20260304190424.291743-5-agruenba@redhat.com>
In-Reply-To: <20260304190424.291743-1-agruenba@redhat.com>
References: <20260304190424.291743-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 7a-f-X2PZ3uFqauaxXuSMk16UdRearENHWzrI1OxEWc_1772651081
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Instead of setting bio->bi_status to BLK_STS_IOERR and calling
bio_endio(bio), use the shorthand bio_io_error(bio).

Created with Coccinelle using the following semantic patch:

@@
struct bio *bio;
@@
- bio->bi_status = BLK_STS_IOERR;
- bio_endio(bio);
+ bio_io_error(bio);

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c                  | 3 +--
 drivers/block/drbd/drbd_int.h | 3 +--
 drivers/md/bcache/bcache.h    | 3 +--
 drivers/md/bcache/request.c   | 6 ++----
 drivers/md/dm-mpath.c         | 3 +--
 drivers/md/dm-writecache.c    | 3 +--
 fs/f2fs/segment.c             | 3 +--
 7 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..9547f656904d 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -218,8 +218,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
 		if (unlikely(ret)) {
-			bio->bi_status = BLK_STS_IOERR;
-			bio_endio(bio);
+			bio_io_error(bio);
 			break;
 		}
 		if (iocb->ki_flags & IOCB_NOWAIT) {
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f6d6276974ee..32639e8ea72a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1491,8 +1491,7 @@ static inline void drbd_submit_bio_noacct(struct drbd_device *device,
 	__release(local);
 	if (!bio->bi_bdev) {
 		drbd_err(device, "drbd_submit_bio_noacct: bio->bi_bdev == NULL\n");
-		bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
+		bio_io_error(bio);
 		return;
 	}
 
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff9715081..e0c9d9eef0a0 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -947,8 +947,7 @@ static inline void closure_bio_submit(struct cache_set *c,
 {
 	closure_get(cl);
 	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
-		bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
+		bio_io_error(bio);
 		return;
 	}
 	submit_bio_noacct(bio);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3fa3b13a410f..0f6fa0a2920b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1178,8 +1178,7 @@ void cached_dev_submit_bio(struct bio *bio)
 
 	if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags)) ||
 		     dc->io_disable)) {
-		bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
+		bio_io_error(bio);
 		return;
 	}
 
@@ -1283,8 +1282,7 @@ void flash_dev_submit_bio(struct bio *bio)
 	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
 
 	if (unlikely(d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags))) {
-		bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
+		bio_io_error(bio);
 		return;
 	}
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7cb7bb6233b6..bf4927f58d7f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -712,8 +712,7 @@ static void process_queued_bios(struct work_struct *work)
 		r = __multipath_map_bio(m, bio, mpio);
 		switch (r) {
 		case DM_MAPIO_KILL:
-			bio->bi_status = BLK_STS_IOERR;
-			bio_endio(bio);
+			bio_io_error(bio);
 			break;
 		case DM_MAPIO_REQUEUE:
 			bio->bi_status = BLK_STS_DM_REQUEUE;
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 98bd945f6da7..78a730a9b1ef 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1876,8 +1876,7 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
 		if (WC_MODE_FUA(wc))
 			bio->bi_opf |= REQ_FUA;
 		if (writecache_has_error(wc)) {
-			bio->bi_status = BLK_STS_IOERR;
-			bio_endio(bio);
+			bio_io_error(bio);
 		} else if (unlikely(!bio_sectors(bio))) {
 			bio->bi_status = BLK_STS_OK;
 			bio_endio(bio);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6a97fe76712b..2dac0cbb5540 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4101,8 +4101,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	if (fio->bio && *(fio->bio)) {
 		struct bio *bio = *(fio->bio);
 
-		bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
+		bio_io_error(bio);
 		*(fio->bio) = NULL;
 	}
 	return err;
-- 
2.52.0

