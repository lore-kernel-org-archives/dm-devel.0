Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5189FEB64D9
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686726439;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NO5XGOKh/y1Kos7TC6HXc0OGzmEJqtzwRTzx8sa+lTk=;
	b=bK/yEoDqqHrLMQuzUES+2iEem3E634jpwh0/IRn0wAkE2RRewo0Vy/DhSBkoovswq/hIy2
	lIycW1j82wGBU1Z44g3gBmQ24Hkqame6jMqV6fw1an2nQ97F3iwH+NC1gXX9NWfH4at0X2
	pa3xPwCUYpEBcVRotN89GlWKcr7Hjk4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-pJAb-sBRMk2XPf2RVz-4CA-1; Wed, 14 Jun 2023 03:07:16 -0400
X-MC-Unique: pJAb-sBRMk2XPf2RVz-4CA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6D3C801211;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3E462026D20;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DDF819451D6;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D58C5194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 01:04:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 96B4640C6F5D; Wed, 14 Jun 2023 01:04:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F63C40C6F5C
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 01:04:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75903185A78E
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 01:04:34 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-eN07ZP3fOim3weg6qIew6Q-1; Tue, 13 Jun 2023 21:04:31 -0400
X-MC-Unique: eN07ZP3fOim3weg6qIew6Q-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgnJ95cWxz4f3jHb;
 Wed, 14 Jun 2023 09:04:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbAYEolki8WaLg--.13805S4;
 Wed, 14 Jun 2023 09:04:26 +0800 (CST)
From: linan666@huaweicloud.com
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Wed, 14 Jun 2023 08:59:55 +0800
Message-Id: <20230614005955.939034-1-linan666@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHvbAYEolki8WaLg--.13805S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCFyDAw1ftF15WF1UKF4rZrb_yoW5GrWkpF
 WDW34SyrWrWr4jga1Uu3yxu3WFka93Kry7ArW3A3yF9a1jyr90yr1UtFyYqrykJFZ7AFyI
 qF10kFZruayYkrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
 0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
 5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
 AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lw4CEc2x0rVAK
 j4xxMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
 0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
 WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
 JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UKoGdUUU
 UU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Wed, 14 Jun 2023 07:06:43 +0000
Subject: [dm-devel] [PATCH v2] dm: Support turning off io stat accounting
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Li Nan <linan122@huawei.com>

Commit bc59ba9468d9 ("block: add sysfs file for controlling io stats
accounting") allowed user to turn off disk stat accounting completely by
queue flag QUEUE_FLAG_IO_STAT. In dm, this flag is not set for BIO_BASED
device, io stats is continuously counted and cannot be turn off.

Support turning off io stat accounting for dm. Set QUEUE_FLAG_IO_STAT for
dm request_queue. When the io starts, we account the io using DM_IO_STAT
dm_io flag to avoid io stats disable in the middle of the io. DM statistics
is independent of block io stat and remains unchanged.

Signed-off-by: Li Nan <linan122@huawei.com>
---
v2:
 - set QUEUE_FLAG_IO_STAT in dm_setup_md_queue()
 - get request_queue by md->queue
---
 drivers/md/dm-core.h |  3 ++-
 drivers/md/dm.c      | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

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
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b694ba3a106..fee27ae4129e 100644
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
+	if (blk_queue_io_stat(md->queue))
+		dm_io_set_flag(io, DM_IO_STAT);
 
 	if (static_branch_unlikely(&stats_enabled))
 		dm_stats_record_start(&md->stats, &io->stats_aux);
@@ -2341,6 +2346,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		break;
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
+		blk_queue_flag_set(QUEUE_FLAG_IO_STAT, md->queue);
 		break;
 	case DM_TYPE_NONE:
 		WARN_ON_ONCE(true);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

