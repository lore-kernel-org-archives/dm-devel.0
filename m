Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC997C47084
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C96B613EC
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C96B613EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-tPAPMtnwNzO4KyU_R-E6FA-1; Mon, 24 May 2021 22:26:20 -0400
X-MC-Unique: tPAPMtnwNzO4KyU_R-E6FA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E440107ACF3;
	Tue, 25 May 2021 02:26:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 658F22D07F;
	Tue, 25 May 2021 02:26:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 38B4059CCE;
	Tue, 25 May 2021 02:26:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P2PsOj027715 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 May 2021 22:25:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5BFDD217E433; Tue, 25 May 2021 02:25:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57475217E431
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 408A095F343
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:54 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-354-j-WmO94QNuSH1W1VrOTOUg-3; Mon, 24 May 2021 22:25:52 -0400
X-MC-Unique: j-WmO94QNuSH1W1VrOTOUg-3
IronPort-SDR: bRccxPXLdUqNhV/U26k9timvOgS1bqy3vXOAuSk/U3whTh+yWm2ctxXj2NgYeefRvK8FJhDuSb
	QTBDSSkAFue5bxr94aPvPOvIH8vpRp9oF5LjB7favHDzPvayVwgnZE2tijNdtpO37k+lPhiXSI
	2nKElTAUAcaSrqDBKOaCzsmJXm40wBDQ5smfAidNpi0jeqxSmwu/9hAS6jGtwcVtEL19Aynw4K
	AcuDkvg2QvMR6izZFmw48Owrq1F4VYdfgc7x96gJbfA3C+CLF4uiTSpEPWXIu1mI+thL251aME
	3e8=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="273213791"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 10:26:53 +0800
IronPort-SDR: WkKB0aW5kwJzyQeL2zDcdjZccRLiLT7T/ZXN0/l3bpyIG8FVTXPQKiAi+fcFBh1aJjHbWn5AiP
	7jyjKiP/mbf+W5cSbS7NgMF8/u705OCRVdS8sNaorZrcO4VRdrP5XdksWM3O2/HKVziyzlPddc
	R86oqm5YelsJR8mXOdVxMovCIQjRnzctXfGwWyN8fjdec1rnyjzwP60K29gK2bHwJzha+YBEPh
	N006FRMBkrRRTTWZeNKAnGXa7kywA/qPrw3GGn5FdHT/gFSKSJup15tnsCoo0NABGZIctbgYBl
	el8g+sVpyMc8n4FwKzEcylre
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	24 May 2021 19:04:05 -0700
IronPort-SDR: 08Wx98l96fX0Dh/kLwzV8cG7jGpjdyvRSFxdnjrbG6WupPAY1UcDP5ZuiaL3UAgpNXGS9wznhX
	d+X0YqJG0diXC4QqytaLBK+Z1vnF0U+L3IL5OYX5KDxna9tXfF+cBFsZAKz8tkObL8C0qMYKQp
	eK4By5iS+g67d58Wv0VDWNvWsYNBsvYmwax6JESz6IOpk+vwllcCspUxzd9YLRmGiPwC18IC/m
	fGCyRZzN1GOggP9eLz4XK8g7uVrhIL+W/1suJVufj7qNAn/XW+kj4hmOjq/D8trVSRcKX8gB8P
	ug8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 24 May 2021 19:25:50 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Tue, 25 May 2021 11:25:37 +0900
Message-Id: <20210525022539.119661-10-damien.lemoal@wdc.com>
In-Reply-To: <20210525022539.119661-1-damien.lemoal@wdc.com>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v4 09/11] dm: rearrange core declarations
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move the definitions of struct dm_target_io, struct dm_io and of the
bits of the flags field of struct mapped_device from dm.c to dm-core.h
to make them usable from dm-zone.c.
For the same reason, declare dec_pending() in dm-core.h after renaming
it to dm_io_dec_pending(). And for symmetry of the function names,
introduce the inline helper dm_io_inc_pending() instead of directly
using atomic_inc() calls.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-core.h | 52 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c      | 59 ++++++--------------------------------------
 2 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 5953ff2bd260..cfabc1c91f9f 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -116,6 +116,19 @@ struct mapped_device {
 	struct srcu_struct io_barrier;
 };
 
+/*
+ * Bits for the flags field of struct mapped_device.
+ */
+#define DMF_BLOCK_IO_FOR_SUSPEND 0
+#define DMF_SUSPENDED 1
+#define DMF_FROZEN 2
+#define DMF_FREEING 3
+#define DMF_DELETING 4
+#define DMF_NOFLUSH_SUSPENDING 5
+#define DMF_DEFERRED_REMOVE 6
+#define DMF_SUSPENDED_INTERNALLY 7
+#define DMF_POST_SUSPENDING 8
+
 void disable_discard(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
@@ -173,6 +186,45 @@ struct dm_table {
 #endif
 };
 
+/*
+ * One of these is allocated per clone bio.
+ */
+#define DM_TIO_MAGIC 7282014
+struct dm_target_io {
+	unsigned int magic;
+	struct dm_io *io;
+	struct dm_target *ti;
+	unsigned int target_bio_nr;
+	unsigned int *len_ptr;
+	bool inside_dm_io;
+	struct bio clone;
+};
+
+/*
+ * One of these is allocated per original bio.
+ * It contains the first clone used for that original.
+ */
+#define DM_IO_MAGIC 5191977
+struct dm_io {
+	unsigned int magic;
+	struct mapped_device *md;
+	blk_status_t status;
+	atomic_t io_count;
+	struct bio *orig_bio;
+	unsigned long start_time;
+	spinlock_t endio_lock;
+	struct dm_stats_aux stats_aux;
+	/* last member of dm_target_io is 'struct bio' */
+	struct dm_target_io tio;
+};
+
+static inline void dm_io_inc_pending(struct dm_io *io)
+{
+	atomic_inc(&io->io_count);
+}
+
+void dm_io_dec_pending(struct dm_io *io, blk_status_t error);
+
 static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
 {
 	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4426019a89cc..563504163b74 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -74,38 +74,6 @@ struct clone_info {
 	unsigned sector_count;
 };
 
-/*
- * One of these is allocated per clone bio.
- */
-#define DM_TIO_MAGIC 7282014
-struct dm_target_io {
-	unsigned magic;
-	struct dm_io *io;
-	struct dm_target *ti;
-	unsigned target_bio_nr;
-	unsigned *len_ptr;
-	bool inside_dm_io;
-	struct bio clone;
-};
-
-/*
- * One of these is allocated per original bio.
- * It contains the first clone used for that original.
- */
-#define DM_IO_MAGIC 5191977
-struct dm_io {
-	unsigned magic;
-	struct mapped_device *md;
-	blk_status_t status;
-	atomic_t io_count;
-	struct bio *orig_bio;
-	unsigned long start_time;
-	spinlock_t endio_lock;
-	struct dm_stats_aux stats_aux;
-	/* last member of dm_target_io is 'struct bio' */
-	struct dm_target_io tio;
-};
-
 #define DM_TARGET_IO_BIO_OFFSET (offsetof(struct dm_target_io, clone))
 #define DM_IO_BIO_OFFSET \
 	(offsetof(struct dm_target_io, clone) + offsetof(struct dm_io, tio))
@@ -137,19 +105,6 @@ EXPORT_SYMBOL_GPL(dm_bio_get_target_bio_nr);
 
 #define MINOR_ALLOCED ((void *)-1)
 
-/*
- * Bits for the md->flags field.
- */
-#define DMF_BLOCK_IO_FOR_SUSPEND 0
-#define DMF_SUSPENDED 1
-#define DMF_FROZEN 2
-#define DMF_FREEING 3
-#define DMF_DELETING 4
-#define DMF_NOFLUSH_SUSPENDING 5
-#define DMF_DEFERRED_REMOVE 6
-#define DMF_SUSPENDED_INTERNALLY 7
-#define DMF_POST_SUSPENDING 8
-
 #define DM_NUMA_NODE NUMA_NO_NODE
 static int dm_numa_node = DM_NUMA_NODE;
 
@@ -825,7 +780,7 @@ static int __noflush_suspending(struct mapped_device *md)
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
  */
-static void dec_pending(struct dm_io *io, blk_status_t error)
+void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 {
 	unsigned long flags;
 	blk_status_t io_error;
@@ -978,7 +933,7 @@ static void clone_endio(struct bio *bio)
 	}
 
 	free_tio(tio);
-	dec_pending(io, error);
+	dm_io_dec_pending(io, error);
 }
 
 /*
@@ -1247,7 +1202,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 	 * anything, the target has assumed ownership of
 	 * this io.
 	 */
-	atomic_inc(&io->io_count);
+	dm_io_inc_pending(io);
 	sector = clone->bi_iter.bi_sector;
 
 	if (unlikely(swap_bios_limit(ti, clone))) {
@@ -1273,7 +1228,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 			up(&md->swap_bios_semaphore);
 		}
 		free_tio(tio);
-		dec_pending(io, BLK_STS_IOERR);
+		dm_io_dec_pending(io, BLK_STS_IOERR);
 		break;
 	case DM_MAPIO_REQUEUE:
 		if (unlikely(swap_bios_limit(ti, clone))) {
@@ -1281,7 +1236,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 			up(&md->swap_bios_semaphore);
 		}
 		free_tio(tio);
-		dec_pending(io, BLK_STS_DM_REQUEUE);
+		dm_io_dec_pending(io, BLK_STS_DM_REQUEUE);
 		break;
 	default:
 		DMWARN("unimplemented target map return value: %d", r);
@@ -1570,7 +1525,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 
 	if (bio->bi_opf & REQ_PREFLUSH) {
 		error = __send_empty_flush(&ci);
-		/* dec_pending submits any data associated with flush */
+		/* dm_io_dec_pending submits any data associated with flush */
 	} else if (op_is_zone_mgmt(bio_op(bio))) {
 		ci.bio = bio;
 		ci.sector_count = 0;
@@ -1611,7 +1566,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 	}
 
 	/* drop the extra reference count */
-	dec_pending(ci.io, errno_to_blk_status(error));
+	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
 	return ret;
 }
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

