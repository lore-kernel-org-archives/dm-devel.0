Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE94C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  8 Apr 2022 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649438026;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2HKDjwskRqr1edUIssGxgpmXcET72uYvst04jiuIAYg=;
	b=B7bB2UOiZcI2/JGRwyPPVMg1kI1Ci0WuE19uD9HzkZkBE8ic1Rmf0TcZzMYlEIC6JlcrL9
	XYpsApjqeLBqXZROapi9e5JJcm6pHWXzwlK36zNubZPAd/7o5u5dORsfeLNc4NYCo1UW6S
	rc3DnWX0ydMBKw9ShsEuIM/V75EJUN8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-M3f6JbUgO9W5c12BU3qLGA-1; Fri, 08 Apr 2022 13:13:44 -0400
X-MC-Unique: M3f6JbUgO9W5c12BU3qLGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 432193800E9F;
	Fri,  8 Apr 2022 17:13:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3321D1121314;
	Fri,  8 Apr 2022 17:13:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E33C01940344;
	Fri,  8 Apr 2022 17:13:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A891E1940341
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Apr 2022 17:13:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98B7C403175; Fri,  8 Apr 2022 17:13:40 +0000 (UTC)
Received: from localhost (ovpn-8-29.pek2.redhat.com [10.72.8.29])
 by smtp.corp.redhat.com (Postfix) with ESMTP id BA102401E6C;
 Fri,  8 Apr 2022 17:13:39 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Date: Sat,  9 Apr 2022 01:12:53 +0800
Message-Id: <20220408171254.935171-3-ming.lei@redhat.com>
In-Reply-To: <20220408171254.935171-1-ming.lei@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 2/3] dm: improve target io referencing
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently target io's reference counter is grabbed before calling
__map_bio(), this way isn't efficient since we can move this grabbing
into alloc_io().

Meantime it becomes typical async io reference counter model: one is
for submission side, the other is for completion side, and the io won't
be completed until both two sides are done.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b8424a4b4725..528559ca2f91 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -579,7 +579,9 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io = container_of(tio, struct dm_io, tio);
 	io->magic = DM_IO_MAGIC;
 	io->status = 0;
-	atomic_set(&io->io_count, 1);
+
+	/* one is for submission, the other is for completion */
+	atomic_set(&io->io_count, 2);
 	this_cpu_inc(*md->pending_io);
 	io->orig_bio = NULL;
 	io->md = md;
@@ -929,11 +931,6 @@ static inline bool dm_tio_is_normal(struct dm_target_io *tio)
 		!dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
 }
 
-static void dm_io_inc_pending(struct dm_io *io)
-{
-	atomic_inc(&io->io_count);
-}
-
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
@@ -1275,7 +1272,6 @@ static void __map_bio(struct bio *clone)
 	/*
 	 * Map the clone.
 	 */
-	dm_io_inc_pending(io);
 	tio->old_sector = clone->bi_iter.bi_sector;
 
 	if (unlikely(swap_bios_limit(ti, clone))) {
@@ -1357,11 +1353,12 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 	}
 }
 
-static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
+static int __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 				  unsigned num_bios, unsigned *len)
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
 	struct bio *clone;
+	int ret = 0;
 
 	switch (num_bios) {
 	case 0:
@@ -1370,15 +1367,19 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 		dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
 		__map_bio(clone);
+		ret = 1;
 		break;
 	default:
 		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 		while ((clone = bio_list_pop(&blist))) {
 			dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
 			__map_bio(clone);
+			ret += 1;
 		}
 		break;
 	}
+
+	return ret;
 }
 
 static void __send_empty_flush(struct clone_info *ci)
@@ -1398,8 +1399,16 @@ static void __send_empty_flush(struct clone_info *ci)
 	ci->bio = &flush_bio;
 	ci->sector_count = 0;
 
-	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
+	while ((ti = dm_table_get_target(ci->map, target_nr++))) {
+		int bios;
+
+		atomic_add(ti->num_flush_bios, &ci->io->io_count);
+		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
+		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+	}
+
+	/* alloc_io() takes one extra reference for submission */
+	atomic_sub(1, &ci->io->io_count);
 
 	bio_uninit(ci->bio);
 }
@@ -1408,6 +1417,7 @@ static void __send_changing_extent_only(struct clone_info *ci, struct dm_target
 					unsigned num_bios)
 {
 	unsigned len;
+	int bios;
 
 	len = min_t(sector_t, ci->sector_count,
 		    max_io_len_target_boundary(ti, dm_target_offset(ti, ci->sector)));
@@ -1419,7 +1429,11 @@ static void __send_changing_extent_only(struct clone_info *ci, struct dm_target
 	ci->sector += len;
 	ci->sector_count -= len;
 
-	__send_duplicate_bios(ci, ti, num_bios, &len);
+
+	atomic_add(num_bios, &ci->io->io_count);
+	bios = __send_duplicate_bios(ci, ti, num_bios, &len);
+	/* alloc_io() takes one extra reference for submission */
+	atomic_sub(num_bios - bios + 1, &ci->io->io_count);
 }
 
 static bool is_abnormal_io(struct bio *bio)
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

