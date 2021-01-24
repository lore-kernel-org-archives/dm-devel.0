Return-Path: <SRS0=PWLs=G3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61D8C433DB
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:13:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E915222B48
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E915222B48
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-H8ny9t9rP5y-rJ6546XcTQ-1; Sun, 24 Jan 2021 05:13:11 -0500
X-MC-Unique: H8ny9t9rP5y-rJ6546XcTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A369D80A5C1;
	Sun, 24 Jan 2021 10:13:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 883525C257;
	Sun, 24 Jan 2021 10:13:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C5504BB7B;
	Sun, 24 Jan 2021 10:13:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10OAD5a7005568 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 24 Jan 2021 05:13:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7F1CC47CD4; Sun, 24 Jan 2021 10:13:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78F6A47CE1
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:13:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 355D5101A53F
	for <dm-devel@redhat.com>; Sun, 24 Jan 2021 10:13:03 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-LiRSR0wOOLmn-v5amGLbWg-1; Sun, 24 Jan 2021 05:13:01 -0500
X-MC-Unique: LiRSR0wOOLmn-v5amGLbWg-1
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1l3cHK-002qAP-RM; Sun, 24 Jan 2021 10:05:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sun, 24 Jan 2021 11:02:40 +0100
Message-Id: <20210124100241.1167849-10-hch@lst.de>
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 09/10] block: remove DISK_PITER_REVERSE
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There is good reason to iterate backwards when deleting all partitions in
del_gendisk, just like we don't in blk_drop_partitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         | 37 +++++++------------------------------
 include/linux/genhd.h |  1 -
 2 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7094612c7510a8..1832add5c73849 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -184,24 +184,13 @@ static struct block_device *__disk_get_part(struct gendisk *disk, int partno)
 void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 			  unsigned int flags)
 {
-	struct disk_part_tbl *ptbl;
-
-	rcu_read_lock();
-	ptbl = rcu_dereference(disk->part_tbl);
-
 	piter->disk = disk;
 	piter->part = NULL;
-
-	if (flags & DISK_PITER_REVERSE)
-		piter->idx = ptbl->len - 1;
-	else if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
+	if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
 		piter->idx = 0;
 	else
 		piter->idx = 1;
-
 	piter->flags = flags;
-
-	rcu_read_unlock();
 }
 
 /**
@@ -216,7 +205,6 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 {
 	struct disk_part_tbl *ptbl;
-	int inc, end;
 
 	/* put the last partition */
 	disk_part_iter_exit(piter);
@@ -225,21 +213,8 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 	rcu_read_lock();
 	ptbl = rcu_dereference(piter->disk->part_tbl);
 
-	/* determine iteration parameters */
-	if (piter->flags & DISK_PITER_REVERSE) {
-		inc = -1;
-		if (piter->flags & (DISK_PITER_INCL_PART0 |
-				    DISK_PITER_INCL_EMPTY_PART0))
-			end = -1;
-		else
-			end = 0;
-	} else {
-		inc = 1;
-		end = ptbl->len;
-	}
-
 	/* iterate to the next partition */
-	for (; piter->idx != end; piter->idx += inc) {
+	for (; piter->idx != ptbl->len; piter->idx += 1) {
 		struct block_device *part;
 
 		part = rcu_dereference(ptbl->part[piter->idx]);
@@ -257,7 +232,10 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 			continue;
 		}
 
-		piter->idx += inc;
+		piter->part = bdgrab(part);
+		if (!piter->part)
+			continue;
+		piter->idx += 1;
 		break;
 	}
 
@@ -781,8 +759,7 @@ void del_gendisk(struct gendisk *disk)
 	down_write(&bdev_lookup_sem);
 
 	/* invalidate stuff */
-	disk_part_iter_init(&piter, disk,
-			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter))) {
 		invalidate_partition(part);
 		delete_partition(part);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 670eaef0e87622..51609133c9a347 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -218,7 +218,6 @@ void disk_uevent(struct gendisk *disk, enum kobject_action action);
 /*
  * Smarter partition iterator without context limits.
  */
-#define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
 #define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
 #define DISK_PITER_INCL_EMPTY_PART0 (1 << 3) /* include empty partition 0 */
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

