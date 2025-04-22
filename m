Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC8C1AE875
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 19:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745349583; cv=none; b=OnWDlpGn1emtJUPLrXNkagmfK96edcgKeNozqYfk4gGCQ7eDpLj1NrWh7uT+BD20GhB/f9bI0Abcl+k/bF74UT+llBgSEh/JJL6sCaPlzTnaK5NrSG2ACH9Q0J0HhGEX7AE+MxtC1tRz54Ek1x56cgeA83GAInL57tcB8+JbGes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745349583; c=relaxed/simple;
	bh=551XtgThhCQSkAx16BZVO7eeOfc9FxQNFviZsyBR92E=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Ft8UeuKqLFmejuaHO52MOHx6pW/yIWPxGVWBZaY5EHEV5IjkwOtsls8qyxeSjRy9Ki+kZ+/f8JvnzBO9qhM6hyjbGwrtcAZwXpkDSExMZb83LkZkn0obcnLNMpTJq5uCONvWYXTjLGCOlMAvVZYcyRLZwErI3VM9Lgu7fG8zyxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fjrnKNbo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fjrnKNbo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745349579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=R1/evFzlBZBBVuvsS34Z/FSPBlr+MR+PhCGFfEnrXHk=;
	b=fjrnKNboB0WdqLA4AK54Pe6YFs7aXsbIG2MOAxdnRFSNKDrv63qvCTXqeuaGoF9trHM2p4
	fjLQG/hJCAPZWFOqDV/f1LPbjHI2tBQH5O62treifofUhNaJFi3rN9vMhnBjAX+ZxgkTXp
	Rm60XVu6kabsn7/bkqSJMGDK8OgAGWU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-JjZi6XFYNseZuWzx6l3GNw-1; Tue,
 22 Apr 2025 15:19:36 -0400
X-MC-Unique: JjZi6XFYNseZuWzx6l3GNw-1
X-Mimecast-MFC-AGG-ID: JjZi6XFYNseZuWzx6l3GNw_1745349575
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E2171955E7A;
	Tue, 22 Apr 2025 19:19:35 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51FE719560A3;
	Tue, 22 Apr 2025 19:19:33 +0000 (UTC)
Date: Tue, 22 Apr 2025 21:19:30 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: use generic functions instead of disable_discard and
 disable_write_zeroes
Message-ID: <99f556b0-700b-9fa0-ac4a-8f10628814b5@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tNErwGQI7w75MzRBGRCMxqnDFPdDN4FAEF2PFrGdxTc_1745349575
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

A small code cleanup: use blk_queue_disable_discard and
blk_queue_disable_write_zeroes instead of disable_discard and
disable_write_zeroes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h |    3 ---
 drivers/md/dm-rq.c   |    4 ++--
 drivers/md/dm.c      |   20 ++------------------
 3 files changed, 4 insertions(+), 23 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2025-04-14 21:19:19.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2025-04-14 21:19:19.000000000 +0200
@@ -1082,22 +1082,6 @@ static inline struct queue_limits *dm_ge
 	return &md->queue->limits;
 }
 
-void disable_discard(struct mapped_device *md)
-{
-	struct queue_limits *limits = dm_get_queue_limits(md);
-
-	/* device doesn't really support DISCARD, disable it */
-	limits->max_hw_discard_sectors = 0;
-}
-
-void disable_write_zeroes(struct mapped_device *md)
-{
-	struct queue_limits *limits = dm_get_queue_limits(md);
-
-	/* device doesn't really support WRITE ZEROES, disable it */
-	limits->max_write_zeroes_sectors = 0;
-}
-
 static bool swap_bios_limit(struct dm_target *ti, struct bio *bio)
 {
 	return unlikely((bio->bi_opf & REQ_SWAP) != 0) && unlikely(ti->limit_swap_bios);
@@ -1115,10 +1099,10 @@ static void clone_endio(struct bio *bio)
 	if (unlikely(error == BLK_STS_TARGET)) {
 		if (bio_op(bio) == REQ_OP_DISCARD &&
 		    !bdev_max_discard_sectors(bio->bi_bdev))
-			disable_discard(md);
+			blk_queue_disable_discard(md->queue);
 		else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
 			 !bdev_write_zeroes_sectors(bio->bi_bdev))
-			disable_write_zeroes(md);
+			blk_queue_disable_write_zeroes(md->queue);
 	}
 
 	if (static_branch_unlikely(&zoned_enabled) &&
Index: linux-2.6/drivers/md/dm-rq.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-rq.c	2025-04-14 21:19:19.000000000 +0200
+++ linux-2.6/drivers/md/dm-rq.c	2025-04-14 21:19:19.000000000 +0200
@@ -217,10 +217,10 @@ static void dm_done(struct request *clon
 	if (unlikely(error == BLK_STS_TARGET)) {
 		if (req_op(clone) == REQ_OP_DISCARD &&
 		    !clone->q->limits.max_discard_sectors)
-			disable_discard(tio->md);
+			blk_queue_disable_discard(tio->md->queue);
 		else if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
 			 !clone->q->limits.max_write_zeroes_sectors)
-			disable_write_zeroes(tio->md);
+			blk_queue_disable_write_zeroes(tio->md->queue);
 	}
 
 	switch (r) {
Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2025-04-14 21:19:01.000000000 +0200
+++ linux-2.6/drivers/md/dm-core.h	2025-04-14 21:19:41.000000000 +0200
@@ -162,9 +162,6 @@ struct mapped_device {
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
 
-void disable_discard(struct mapped_device *md);
-void disable_write_zeroes(struct mapped_device *md);
-
 static inline sector_t dm_get_size(struct mapped_device *md)
 {
 	return get_capacity(md->disk);

