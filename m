Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27EBFC43217
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-bs7pbaSsNECKJWcoFp_W0A-1; Thu, 24 Mar 2022 11:34:53 -0400
X-MC-Unique: bs7pbaSsNECKJWcoFp_W0A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE2E33804526;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9F6E401475;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F97F194036B;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3E241947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:01:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74C744010A35; Tue, 22 Mar 2022 11:01:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70EE340C1257
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:01:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FAC53C01C17
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:01:20 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-p__SlHuJO_KUWmTzc6rWvw-1; Tue, 22 Mar 2022 07:01:18 -0400
X-MC-Unique: p__SlHuJO_KUWmTzc6rWvw-1
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7Pd2v2vz684m2;
 Tue, 22 Mar 2022 18:43:33 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:45:43 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:45:39 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:35 +0800
Message-ID: <1647945585-197349-2-git-send-email-john.garry@huawei.com>
In-Reply-To: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:41 +0000
Subject: [dm-devel] [PATCH 01/11] blk-mq: Add blk_mq_init_queue_ops()
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
Cc: linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com,
 John Garry <john.garry@huawei.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com,
 beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add an API to allocate a request queue which accepts a custom set of
blk_mq_ops for that request queue.

The reason which we may want custom ops is for queuing requests which we
don't want to go through the normal queuing path.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c         | 23 +++++++++++++++++------
 drivers/md/dm-rq.c     |  2 +-
 include/linux/blk-mq.h |  5 ++++-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f3bf3358a3bb..8ea3447339ca 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3858,7 +3858,7 @@ void blk_mq_release(struct request_queue *q)
 }
 
 static struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
-		void *queuedata)
+		void *queuedata, const struct blk_mq_ops *ops)
 {
 	struct request_queue *q;
 	int ret;
@@ -3867,27 +3867,35 @@ static struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
 	if (!q)
 		return ERR_PTR(-ENOMEM);
 	q->queuedata = queuedata;
-	ret = blk_mq_init_allocated_queue(set, q);
+	ret = blk_mq_init_allocated_queue(set, q, ops);
 	if (ret) {
 		blk_cleanup_queue(q);
 		return ERR_PTR(ret);
 	}
+
 	return q;
 }
 
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 {
-	return blk_mq_init_queue_data(set, NULL);
+	return blk_mq_init_queue_data(set, NULL, NULL);
 }
 EXPORT_SYMBOL(blk_mq_init_queue);
 
+struct request_queue *blk_mq_init_queue_ops(struct blk_mq_tag_set *set,
+					    const struct blk_mq_ops *custom_ops)
+{
+	return blk_mq_init_queue_data(set, NULL, custom_ops);
+}
+EXPORT_SYMBOL(blk_mq_init_queue_ops);
+
 struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
 		struct lock_class_key *lkclass)
 {
 	struct request_queue *q;
 	struct gendisk *disk;
 
-	q = blk_mq_init_queue_data(set, queuedata);
+	q = blk_mq_init_queue_data(set, queuedata, NULL);
 	if (IS_ERR(q))
 		return ERR_CAST(q);
 
@@ -4010,13 +4018,16 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 }
 
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
-		struct request_queue *q)
+		struct request_queue *q, const struct blk_mq_ops *custom_ops)
 {
 	WARN_ON_ONCE(blk_queue_has_srcu(q) !=
 			!!(set->flags & BLK_MQ_F_BLOCKING));
 
 	/* mark the queue as mq asap */
-	q->mq_ops = set->ops;
+	if (custom_ops)
+		q->mq_ops = custom_ops;
+	else
+		q->mq_ops = set->ops;
 
 	q->poll_cb = blk_stat_alloc_callback(blk_mq_poll_stats_fn,
 					     blk_mq_poll_stats_bkt,
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 3907950a0ddc..9d93f72a3eec 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -560,7 +560,7 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	if (err)
 		goto out_kfree_tag_set;
 
-	err = blk_mq_init_allocated_queue(md->tag_set, md->queue);
+	err = blk_mq_init_allocated_queue(md->tag_set, md->queue, NULL);
 	if (err)
 		goto out_tag_set;
 	return 0;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d319ffa59354..e12d17c86c52 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -688,8 +688,11 @@ struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
 	__blk_mq_alloc_disk(set, queuedata, &__key);			\
 })
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);
+struct request_queue *blk_mq_init_queue_ops(struct blk_mq_tag_set *,
+		const struct blk_mq_ops *custom_ops);
+
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
-		struct request_queue *q);
+		struct request_queue *q, const struct blk_mq_ops *custom_ops);
 void blk_mq_unregister_dev(struct device *, struct request_queue *);
 
 int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set);
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

