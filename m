Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0481C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 21 Dec 2021 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640096208;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dhrorwmHKg1/tYbJN/6Xg1gq2i52kaYR+vOd4N25PCg=;
	b=MSm4zXTC4U2kH4sErq/Pm3zHvHz1VcRO9vJaU+RPpdzGiKjGKh/81lEWg28oKqXQjcpFJ6
	mq2NRnH/AaSr994zkp9Qqv2wp+JQgPkXYs8yYETsR4gUr6tlg+SD0515kNq/V/FSrtE238
	QPWJLjnEc1/jxttZLbpXW4uzqnjJRbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-5yrNcJUiMDqdyHHzIa5SsA-1; Tue, 21 Dec 2021 09:16:42 -0500
X-MC-Unique: 5yrNcJUiMDqdyHHzIa5SsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94A9B1B18BC2;
	Tue, 21 Dec 2021 14:16:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B9245BE37;
	Tue, 21 Dec 2021 14:16:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46B4A4CA93;
	Tue, 21 Dec 2021 14:16:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BLEGasM006253 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 21 Dec 2021 09:16:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8C854519BB; Tue, 21 Dec 2021 14:16:36 +0000 (UTC)
Received: from localhost (ovpn-8-30.pek2.redhat.com [10.72.8.30])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C56AF519BA;
	Tue, 21 Dec 2021 14:16:05 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 21 Dec 2021 22:14:58 +0800
Message-Id: <20211221141459.1368176-3-ming.lei@redhat.com>
In-Reply-To: <20211221141459.1368176-1-ming.lei@redhat.com>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [dm-devel] [PATCH 2/3] block: add blk_alloc_disk_srcu
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

Add blk_alloc_disk_srcu() so that we can allocate srcu inside request queue
for supporting blocking ->queue_rq().

dm-rq needs this API.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/genhd.c         |  5 +++--
 include/linux/genhd.h | 12 ++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3c139a1b6f04..d21786fbb7bb 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1333,12 +1333,13 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 }
 EXPORT_SYMBOL(__alloc_disk_node);
 
-struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass)
+struct gendisk *__blk_alloc_disk(int node, bool alloc_srcu,
+		struct lock_class_key *lkclass)
 {
 	struct request_queue *q;
 	struct gendisk *disk;
 
-	q = blk_alloc_queue(node, false);
+	q = blk_alloc_queue(node, alloc_srcu);
 	if (!q)
 		return NULL;
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6906a45bc761..20259340b962 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -227,23 +227,27 @@ void blk_drop_partitions(struct gendisk *disk);
 struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 		struct lock_class_key *lkclass);
 extern void put_disk(struct gendisk *disk);
-struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass);
+struct gendisk *__blk_alloc_disk(int node, bool alloc_srcu,
+		struct lock_class_key *lkclass);
 
 /**
- * blk_alloc_disk - allocate a gendisk structure
+ * __alloc_disk - allocate a gendisk structure
  * @node_id: numa node to allocate on
+ * @alloc_srcu: allocate srcu instance for supporting blocking ->queue_rq
  *
  * Allocate and pre-initialize a gendisk structure for use with BIO based
  * drivers.
  *
  * Context: can sleep
  */
-#define blk_alloc_disk(node_id)						\
+#define __alloc_disk(node_id, alloc_srcu)				\
 ({									\
 	static struct lock_class_key __key;				\
 									\
-	__blk_alloc_disk(node_id, &__key);				\
+	__blk_alloc_disk(node_id, alloc_srcu, &__key);			\
 })
+#define blk_alloc_disk(node_id) __alloc_disk(node_id, false)
+#define blk_alloc_disk_srcu(node_id) __alloc_disk(node_id, true)
 void blk_cleanup_disk(struct gendisk *disk);
 
 int __register_blkdev(unsigned int major, const char *name,
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

