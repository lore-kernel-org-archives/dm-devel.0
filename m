Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AB2129A7F
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 09:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713344737; cv=none; b=ZO/4qNWapGudYyMnat8xKkBsf7YEuEkwdvbuH/3DhtcCcJJDX1IWRHU9skkzlHKNUC3XX3VPFVm2N1Oav9F6bMgWWPOWX8JN9QvJW/9Zr35ry/pjDYOjYdbwiJU4DDF2/ZBlisKvEN4pTSE6zCNFzRGZNuSVvjAg0jeNXj/BbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713344737; c=relaxed/simple;
	bh=dzLuLNR+JHkFKMGMqRUn0tXcCa7nTBGisy6FkCnmdfM=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=gOc1y8FIv5hYvHQvhHlaGavR/1dMMQs6wJDIXjcMhEwUix/lkJJfgGqjg7o3y/kvt5dv4dZgjEB5M0cHZz7a6R3yNIlYZLXJpgTBrziMmx6k5sizRS7RtvBDzje2QPTSZ4L+akfjTMsJchNWfRIBF/XiiaCZtu4p+5l/lklIqUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDdczSok; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDdczSok"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713344735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=FgizP1W9wYXJTXddAvpCsKugaMlz1Qb6hK6QhZ7rS64=;
	b=hDdczSokBrhJCtYcIXUi9lR5YR7GoPbYr0+cxzrAsKK3bJ34NvSyiLTdJ2G/Lz8V/Yz0Es
	XzQRdbvT/X52rnMPoO6FAyRLcF+UGw5YT44WLGV2+JU6qsmCaPiublSIWG1jjU6OOHbMBe
	H0lRWeZ8YuhH7DlK17Me32UXuyDXA1Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-P-AHZvDuO-eELP6h9QJRxQ-1; Wed,
 17 Apr 2024 05:05:31 -0400
X-MC-Unique: P-AHZvDuO-eELP6h9QJRxQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7044628EC11A;
	Wed, 17 Apr 2024 09:05:31 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 248A3490DD;
	Wed, 17 Apr 2024 09:05:31 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id ECC8330C2BF7; Wed, 17 Apr 2024 09:05:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id E80903FD7A;
	Wed, 17 Apr 2024 11:05:30 +0200 (CEST)
Date: Wed, 17 Apr 2024 11:05:30 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>, Damien Le Moal <dlemoal@kernel.org>
cc: Guangwu Zhang <guazhang@redhat.com>, dm-devel@lists.linux.dev, 
    Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: [PATCH v3] dm-io: don't warn if flush takes too long time
Message-ID: <754d1973-31cb-d3ca-1f6f-2d35b96364db@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

There was reported hang warning when using dm-integrity on the top of loop
device on XFS on a rotational disk. The warning was triggered because
flush on the loop device was too slow.

There's no easy way to reduce the latency, so I made a patch that shuts
the warning up.

There's already a function blk_wait_io that avoids the hung task warning.
This commit moves this function from block/blk.h to
include/linux/completion.h, renames it to wait_for_completion_long_io
(because it is not dependent on the block layer at all) and uses it in
dm-io instead of wait_for_completion_io.

[ 1352.586981] INFO: task kworker/1:2:14820 blocked for more than 120 seconds.
[ 1352.593951] Not tainted 4.18.0-552.el8_10.x86_64 #1
[ 1352.599358] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1352.607202] Call Trace:
[ 1352.609670] __schedule+0x2d1/0x870
[ 1352.613173] ? update_load_avg+0x7e/0x710
[ 1352.617193] ? update_load_avg+0x7e/0x710
[ 1352.621214] schedule+0x55/0xf0
[ 1352.624371] schedule_timeout+0x281/0x320
[ 1352.628393] ? __schedule+0x2d9/0x870
[ 1352.632065] io_schedule_timeout+0x19/0x40
[ 1352.636176] wait_for_completion_io+0x96/0x100
[ 1352.640639] sync_io+0xcc/0x120 [dm_mod]
[ 1352.644592] dm_io+0x209/0x230 [dm_mod]
[ 1352.648436] ? bit_wait_timeout+0xa0/0xa0
[ 1352.652461] ? vm_next_page+0x20/0x20 [dm_mod]
[ 1352.656924] ? km_get_page+0x60/0x60 [dm_mod]
[ 1352.661298] dm_bufio_issue_flush+0xa0/0xd0 [dm_bufio]
[ 1352.666448] dm_bufio_write_dirty_buffers+0x1a0/0x1e0 [dm_bufio]
[ 1352.672462] dm_integrity_flush_buffers+0x32/0x140 [dm_integrity]
[ 1352.678567] ? lock_timer_base+0x67/0x90
[ 1352.682505] ? __timer_delete.part.36+0x5c/0x90
[ 1352.687050] integrity_commit+0x31a/0x330 [dm_integrity]
[ 1352.692368] ? __switch_to+0x10c/0x430
[ 1352.696131] process_one_work+0x1d3/0x390
[ 1352.700152] ? process_one_work+0x390/0x390
[ 1352.704348] worker_thread+0x30/0x390
[ 1352.708019] ? process_one_work+0x390/0x390
[ 1352.712214] kthread+0x134/0x150
[ 1352.715459] ? set_kthread_struct+0x50/0x50
[ 1352.719659] ret_from_fork+0x1f/0x40 

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/bio.c                |    2 +-
 block/blk-mq.c             |    2 +-
 block/blk.h                |   12 ------------
 drivers/md/dm-io.c         |    2 +-
 include/linux/completion.h |   17 +++++++++++++++++
 5 files changed, 20 insertions(+), 15 deletions(-)

Index: linux-2.6/block/blk.h
===================================================================
--- linux-2.6.orig/block/blk.h	2024-04-15 15:54:22.000000000 +0200
+++ linux-2.6/block/blk.h	2024-04-15 15:54:21.000000000 +0200
@@ -72,18 +72,6 @@ static inline int bio_queue_enter(struct
 	return __bio_queue_enter(q, bio);
 }
 
-static inline void blk_wait_io(struct completion *done)
-{
-	/* Prevent hang_check timer from firing at us during very long I/O */
-	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;
-
-	if (timeout)
-		while (!wait_for_completion_io_timeout(done, timeout))
-			;
-	else
-		wait_for_completion_io(done);
-}
-
 #define BIO_INLINE_VECS 4
 struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
 		gfp_t gfp_mask);
Index: linux-2.6/drivers/md/dm-io.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-io.c	2024-04-15 15:54:22.000000000 +0200
+++ linux-2.6/drivers/md/dm-io.c	2024-04-15 15:54:21.000000000 +0200
@@ -450,7 +450,7 @@ static int sync_io(struct dm_io_client *
 
 	dispatch_io(opf, num_regions, where, dp, io, 1, ioprio);
 
-	wait_for_completion_io(&sio.wait);
+	wait_for_completion_long_io(&sio.wait);
 
 	if (error_bits)
 		*error_bits = sio.error_bits;
Index: linux-2.6/include/linux/completion.h
===================================================================
--- linux-2.6.orig/include/linux/completion.h	2024-04-15 15:54:22.000000000 +0200
+++ linux-2.6/include/linux/completion.h	2024-04-15 15:57:14.000000000 +0200
@@ -10,6 +10,7 @@
  */
 
 #include <linux/swait.h>
+#include <linux/sched/sysctl.h>
 
 /*
  * struct completion - structure used to maintain state for a "completion"
@@ -119,4 +120,20 @@ extern void complete(struct completion *
 extern void complete_on_current_cpu(struct completion *x);
 extern void complete_all(struct completion *);
 
+/**
+ * wait_for_completion_long_io - this is like wait_for_completion_io,
+ * but it doesn't warn if the wait takes too long.
+ */
+static inline void wait_for_completion_long_io(struct completion *done)
+{
+	/* Prevent hang_check timer from firing at us during very long I/O */
+	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;
+
+	if (timeout)
+		while (!wait_for_completion_io_timeout(done, timeout))
+			;
+	else
+		wait_for_completion_io(done);
+}
+
 #endif
Index: linux-2.6/block/bio.c
===================================================================
--- linux-2.6.orig/block/bio.c	2024-03-30 20:07:03.000000000 +0100
+++ linux-2.6/block/bio.c	2024-04-15 15:55:13.000000000 +0200
@@ -1378,7 +1378,7 @@ int submit_bio_wait(struct bio *bio)
 	bio->bi_end_io = submit_bio_wait_endio;
 	bio->bi_opf |= REQ_SYNC;
 	submit_bio(bio);
-	blk_wait_io(&done);
+	wait_for_completion_long_io(&done);
 
 	return blk_status_to_errno(bio->bi_status);
 }
Index: linux-2.6/block/blk-mq.c
===================================================================
--- linux-2.6.orig/block/blk-mq.c	2024-03-30 20:07:03.000000000 +0100
+++ linux-2.6/block/blk-mq.c	2024-04-15 15:55:05.000000000 +0200
@@ -1407,7 +1407,7 @@ blk_status_t blk_execute_rq(struct reque
 	if (blk_rq_is_poll(rq))
 		blk_rq_poll_completion(rq, &wait.done);
 	else
-		blk_wait_io(&wait.done);
+		wait_for_completion_long_io(&wait.done);
 
 	return wait.ret;
 }

