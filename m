Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF1CC7EE2E
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686658679;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=w7fWXs/3oT1HMRZzb29jtmdJMGOi71yXuFnDLSTITgs=;
	b=OhDGoqpCUEfCL7j4OJ9o7o+q9iJEWYDRfDTRclwNNkH6CnWaUdrULLqayZkbA6Hf6ZQ79/
	TLfZLIof2riL+QoMlboAe23tzOcw7iexnvKZdlnWot50H5pX9Ze//uNzoigExNYBLLAzZ7
	rwSUSd6yhJZvE3dU4rrsvpugLvaqAgw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-deptJHqgMgeXTEscyMKn4g-1; Tue, 13 Jun 2023 08:17:58 -0400
X-MC-Unique: deptJHqgMgeXTEscyMKn4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B415803DC2;
	Tue, 13 Jun 2023 12:17:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38025141511A;
	Tue, 13 Jun 2023 12:17:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 587ED19452C4;
	Tue, 13 Jun 2023 12:17:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B5A72194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 01:54:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A562E140E952; Tue, 13 Jun 2023 01:54:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D5E2140EBB8
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 01:54:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D046185A78F
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 01:54:28 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-YZzuLxsQPUe5Ex2R_Ws6dA-1; Mon, 12 Jun 2023 21:54:25 -0400
X-MC-Unique: YZzuLxsQPUe5Ex2R_Ws6dA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgB5M3Ktlz4f3mW0;
 Tue, 13 Jun 2023 09:37:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgD3mp52yIdkGIRNLg--.33211S4;
 Tue, 13 Jun 2023 09:38:00 +0800 (CST)
From: linan666@huaweicloud.com
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Tue, 13 Jun 2023 09:33:32 +0800
Message-Id: <20230613013332.4078896-1-linan666@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgD3mp52yIdkGIRNLg--.33211S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJF45KFyfZr4kZrWkuw4xXrb_yoW5XryDpF
 WDW34Syr4rWa12ga1UW3y7ua4Fga93KryUCrW3C39a9a1UKryDAr4UtFW3Xr1kJFyxCFy2
 qF10kFyDCayrArUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
 Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
 AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4kE6xkIj40E
 w7xC0wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
 v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
 c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
 0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
 Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwc_TUU
 UUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 13 Jun 2023 12:17:46 +0000
Subject: [dm-devel] [PATCH] dm: Support turning off io stat accounting
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 houtao1@huawei.com, yukuai3@huawei.com, linan122@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Li Nan <linan122@huawei.com>

Commit bc58ba9468d9 ("block: add sysfs file for controlling io stats
accounting") allowed user to turn off disk stat accounting completely by
queue flag QUEUE_FLAG_IO_STAT. In dm, this flag is not set. io stats
is continuously counted and cannot be turn off.

Support turning off io stat accounting for dm. Set QUEUE_FLAG_IO_STAT for
dm request_queue. When the io starts, we account the io using DM_IO_STAT
dm_io flag to avoid io stats disable in the middle of the io. DM statistics
is independent of block io stat and remains unchanged.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/dm-core.h  |  3 ++-
 drivers/md/dm-table.c |  1 +
 drivers/md/dm.c       | 15 ++++++++++-----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index aecab0c0720f..8b0af3e1331a 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -307,7 +307,8 @@ struct dm_io {
  */
 enum {
 	DM_IO_ACCOUNTED,
-	DM_IO_WAS_SPLIT
+	DM_IO_WAS_SPLIT,
+	DM_IO_STAT
 };
 
 static inline bool dm_io_flagged(struct dm_io *io, unsigned int bit)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1398f1d6e83e..bd5e16a3f2b1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1936,6 +1936,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 */
 	q->limits = *limits;
 
+	blk_queue_flag_set(QUEUE_FLAG_IO_STAT, q);
 	if (dm_table_supports_nowait(t))
 		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
 	else
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b694ba3a106..82b73536bd93 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -511,11 +511,14 @@ static void dm_io_acct(struct dm_io *io, bool end)
 	else
 		sectors = io->sectors;
 
-	if (!end)
-		bdev_start_io_acct(bio->bi_bdev, bio_op(bio), start_time);
-	else
-		bdev_end_io_acct(bio->bi_bdev, bio_op(bio), sectors,
-				 start_time);
+	if (dm_io_flagged(io, DM_IO_STAT)) {
+		if (!end)
+			bdev_start_io_acct(bio->bi_bdev, bio_op(bio),
+					   start_time);
+		else
+			bdev_end_io_acct(bio->bi_bdev, bio_op(bio),
+					 sectors, start_time);
+	}
 
 	if (static_branch_unlikely(&stats_enabled) &&
 	    unlikely(dm_stats_used(&md->stats))) {
@@ -592,6 +595,8 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	spin_lock_init(&io->lock);
 	io->start_time = jiffies;
 	io->flags = 0;
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		dm_io_set_flag(io, DM_IO_STAT);
 
 	if (static_branch_unlikely(&stats_enabled))
 		dm_stats_record_start(&md->stats, &io->stats_aux);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

