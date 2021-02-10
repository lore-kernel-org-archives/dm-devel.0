Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C0BC433E6
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:26:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A666D64EDC
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A666D64EDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612988800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lnlT31bzWPo7CJjdgPFrJIdd32UQGoJey3MTkV9NCPo=;
	b=NempLJ4XNxMpO4naTHTeyI/4J6mdBWT1FzCs47d7amTKoMQW3JXLXRKeu6XHfqLXpv1BWy
	PjfJ2AtmZfztF1XmIEMgqiObegCsJuJScC8ByCxU+YC/qLR2BsPDfOFv5qJix2liYRSfm6
	2qaPHt5Ti8ulNI5Gqo/gJXEcj1k63tg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-nborn5PVNTC0oXBEm6sJqA-1; Wed, 10 Feb 2021 15:26:38 -0500
X-MC-Unique: nborn5PVNTC0oXBEm6sJqA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51C9D107ACE3;
	Wed, 10 Feb 2021 20:26:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA78910013DB;
	Wed, 10 Feb 2021 20:26:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B953E18095C9;
	Wed, 10 Feb 2021 20:26:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AKQV6W011909 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 15:26:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3171D1B47C; Wed, 10 Feb 2021 20:26:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCB295C1BD;
	Wed, 10 Feb 2021 20:26:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 11AKQOp9021121; Wed, 10 Feb 2021 15:26:24 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 11AKQNqB021118; Wed, 10 Feb 2021 15:26:23 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 10 Feb 2021 15:26:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20210210192323.GC7904@redhat.com>
Message-ID: <alpine.LRH.2.02.2102101518320.18125@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2102101140420.30253@file01.intranet.prod.int.rdu2.redhat.com>
	<20210210192323.GC7904@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com,
	Milan Broz <mbroz@redhat.com>
Subject: [dm-devel] [PATCH v2] dm: fix deadlock when swapping to encrypted
	device
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The system would deadlock when swapping to a dm-crypt device. The reason
is that for each incoming write bio, dm-crypt allocates memory that holds
encrypted data. These excessive allocations exhaust all the memory and the
result is either deadlock or OOM trigger.

This patch limits the number of in-flight swap bios, so that the memory
consumed by dm-crypt is limited. The limit is enforced if the target set
the "limit_swap_bios" variable and if the bio has REQ_SWAP set.

Non-swap bios are not affected becuase taking the semaphore would cause
performance degradation.

This is similar to request-based drivers - they will also block when the
number of requests is over the limit.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-core.h          |    4 ++
 drivers/md/dm-crypt.c         |    1 
 drivers/md/dm.c               |   60 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |    5 +++
 4 files changed, 70 insertions(+)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2021-02-10 15:04:53.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2021-02-10 21:22:21.000000000 +0100
@@ -148,6 +148,16 @@ EXPORT_SYMBOL_GPL(dm_bio_get_target_bio_
 #define DM_NUMA_NODE NUMA_NO_NODE
 static int dm_numa_node = DM_NUMA_NODE;
 
+#define DEFAULT_SWAP_BIOS	(8 * 1048576 / PAGE_SIZE)
+static int swap_bios = DEFAULT_SWAP_BIOS;
+static int get_swap_bios(void)
+{
+	int latch = READ_ONCE(swap_bios);
+	if (unlikely(latch <= 0))
+		latch = DEFAULT_SWAP_BIOS;
+	return latch;
+}
+
 /*
  * For mempools pre-allocation at the table loading time.
  */
@@ -969,6 +979,11 @@ void disable_write_zeroes(struct mapped_
 	limits->max_write_zeroes_sectors = 0;
 }
 
+static bool swap_bios_limit(struct dm_target *ti, struct bio *bio)
+{
+	return unlikely((bio->bi_opf & REQ_SWAP) != 0) && unlikely(ti->limit_swap_bios);
+}
+
 static void clone_endio(struct bio *bio)
 {
 	blk_status_t error = bio->bi_status;
@@ -1019,6 +1034,11 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
+	if (unlikely(swap_bios_limit(tio->ti, bio))) {
+		struct mapped_device *md = io->md;
+		up(&md->swap_bios_semaphore);
+	}
+
 	free_tio(tio);
 	dec_pending(io, error);
 }
@@ -1252,6 +1272,22 @@ void dm_accept_partial_bio(struct bio *b
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
+static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
+{
+	mutex_lock(&md->swap_bios_lock);
+	while (latch < md->swap_bios) {
+		cond_resched();
+		down(&md->swap_bios_semaphore);
+		md->swap_bios--;
+	}
+	while (latch > md->swap_bios) {
+		cond_resched();
+		up(&md->swap_bios_semaphore);
+		md->swap_bios++;
+	}
+	mutex_unlock(&md->swap_bios_lock);
+}
+
 static blk_qc_t __map_bio(struct dm_target_io *tio)
 {
 	int r;
@@ -1271,6 +1307,14 @@ static blk_qc_t __map_bio(struct dm_targ
 	atomic_inc(&io->io_count);
 	sector = clone->bi_iter.bi_sector;
 
+	if (unlikely(swap_bios_limit(ti, clone))) {
+		struct mapped_device *md = io->md;
+		int latch = get_swap_bios();
+		if (unlikely(latch != md->swap_bios))
+			__set_swap_bios_limit(md, latch);
+		down(&md->swap_bios_semaphore);
+	}
+
 	r = ti->type->map(ti, clone);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
@@ -1281,10 +1325,18 @@ static blk_qc_t __map_bio(struct dm_targ
 		ret = submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
+		if (unlikely(swap_bios_limit(ti, clone))) {
+			struct mapped_device *md = io->md;
+			up(&md->swap_bios_semaphore);
+		}
 		free_tio(tio);
 		dec_pending(io, BLK_STS_IOERR);
 		break;
 	case DM_MAPIO_REQUEUE:
+		if (unlikely(swap_bios_limit(ti, clone))) {
+			struct mapped_device *md = io->md;
+			up(&md->swap_bios_semaphore);
+		}
 		free_tio(tio);
 		dec_pending(io, BLK_STS_DM_REQUEUE);
 		break;
@@ -1747,6 +1799,7 @@ static void cleanup_mapped_device(struct
 	mutex_destroy(&md->suspend_lock);
 	mutex_destroy(&md->type_lock);
 	mutex_destroy(&md->table_devices_lock);
+	mutex_destroy(&md->swap_bios_lock);
 
 	dm_mq_cleanup_mapped_device(md);
 }
@@ -1814,6 +1867,10 @@ static struct mapped_device *alloc_dev(i
 	init_waitqueue_head(&md->eventq);
 	init_completion(&md->kobj_holder.completion);
 
+	md->swap_bios = get_swap_bios();
+	sema_init(&md->swap_bios_semaphore, md->swap_bios);
+	mutex_init(&md->swap_bios_lock);
+
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
 	md->disk->fops = &dm_blk_dops;
@@ -3097,6 +3154,9 @@ MODULE_PARM_DESC(reserved_bio_based_ios,
 module_param(dm_numa_node, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(dm_numa_node, "NUMA node for DM device memory allocations");
 
+module_param(swap_bios, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(swap_bios, "The number of swap I/Os in flight");
+
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2021-02-10 15:04:53.000000000 +0100
+++ linux-2.6/drivers/md/dm-core.h	2021-02-10 21:07:08.000000000 +0100
@@ -102,6 +102,10 @@ struct mapped_device {
 	/* kobject and completion */
 	struct dm_kobject_holder kobj_holder;
 
+	int swap_bios;
+	struct semaphore swap_bios_semaphore;
+	struct mutex swap_bios_lock;
+
 	struct dm_stats stats;
 
 	/* for blk-mq request-based DM support */
Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2021-01-28 17:33:30.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2021-02-10 21:06:33.000000000 +0100
@@ -3324,6 +3324,7 @@ static int crypt_ctr(struct dm_target *t
 	wake_up_process(cc->write_thread);
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	return 0;
 
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2020-11-25 13:40:44.000000000 +0100
+++ linux-2.6/include/linux/device-mapper.h	2021-02-10 21:06:24.000000000 +0100
@@ -325,6 +325,11 @@ struct dm_target {
 	 * whether or not its underlying devices have support.
 	 */
 	bool discards_supported:1;
+
+	/*
+	 * Set if we need to limit the number of in-flight bios when swapping.
+	 */
+	bool limit_swap_bios:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

