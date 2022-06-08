Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FD2C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 07:18:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-Drre0UV_NGi0Tbx4Vb6mzQ-1; Wed, 08 Jun 2022 03:18:26 -0400
X-MC-Unique: Drre0UV_NGi0Tbx4Vb6mzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91018101A54E;
	Wed,  8 Jun 2022 07:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D9C240CFD0B;
	Wed,  8 Jun 2022 07:18:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 41262194704C;
	Wed,  8 Jun 2022 07:18:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22F61194704C
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 07:18:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 15404492CA4; Wed,  8 Jun 2022 07:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 106BB492C3B
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:18:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED9CC3C1E32E
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 07:18:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-dDVX3q8MP_-J1eZgvRz45A-1; Wed, 08 Jun 2022 03:18:13 -0400
X-MC-Unique: dDVX3q8MP_-J1eZgvRz45A-1
Received: from [2001:4bb8:190:726c:66c4:f635:4b37:bdda] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nypGo-00BJUc-RV; Wed, 08 Jun 2022 06:34:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Date: Wed,  8 Jun 2022 08:34:09 +0200
Message-Id: <20220608063409.1280968-5-hch@lst.de>
In-Reply-To: <20220608063409.1280968-1-hch@lst.de>
References: <20220608063409.1280968-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 4/4] dm: refactor dm_md_mempool allocation
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The current split between dm_table_alloc_md_mempools and
dm_alloc_md_mempools is rather arbitrary, so merge the two
into one easy to follow function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-core.h  |  3 +++
 drivers/md/dm-table.c | 57 +++++++++++++++++++++++++++++++------------
 drivers/md/dm.c       | 52 ---------------------------------------
 drivers/md/dm.h       |  3 ---
 4 files changed, 44 insertions(+), 71 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 54c0473a51dde..eea3922f1abc6 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -230,6 +230,9 @@ struct dm_target_io {
 	sector_t old_sector;
 	struct bio clone;
 };
+#define DM_TARGET_IO_BIO_OFFSET (offsetof(struct dm_target_io, clone))
+#define DM_IO_BIO_OFFSET \
+	(offsetof(struct dm_target_io, clone) + offsetof(struct dm_io, tio))
 
 /*
  * dm_target_io flags
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd539afbfe88f..3f29b1113294e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -6,6 +6,7 @@
  */
 
 #include "dm-core.h"
+#include "dm-rq.h"
 
 #include <linux/module.h>
 #include <linux/vmalloc.h>
@@ -1010,32 +1011,56 @@ static bool dm_table_supports_poll(struct dm_table *t);
 static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *md)
 {
 	enum dm_queue_mode type = dm_table_get_type(t);
-	unsigned per_io_data_size = 0;
-	unsigned min_pool_size = 0;
-	struct dm_target *ti;
-	unsigned i;
-	bool poll_supported = false;
+	unsigned int per_io_data_size = 0, front_pad, io_front_pad;
+	unsigned int min_pool_size = 0, pool_size;
+	struct dm_md_mempools *pools;
 
 	if (unlikely(type == DM_TYPE_NONE)) {
 		DMWARN("no table type is set, can't allocate mempools");
 		return -EINVAL;
 	}
 
-	if (__table_type_bio_based(type)) {
-		for (i = 0; i < t->num_targets; i++) {
-			ti = t->targets + i;
-			per_io_data_size = max(per_io_data_size, ti->per_io_data_size);
-			min_pool_size = max(min_pool_size, ti->num_flush_bios);
-		}
-		poll_supported = dm_table_supports_poll(t);
+	pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
+	if (!pools)
+		return -ENOMEM;
+
+	if (type == DM_TYPE_REQUEST_BASED) {
+		pool_size = dm_get_reserved_rq_based_ios();
+		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
+		goto init_bs;
 	}
 
-	t->mempools = dm_alloc_md_mempools(md, type, per_io_data_size, min_pool_size,
-					   t->integrity_supported, poll_supported);
-	if (!t->mempools)
-		return -ENOMEM;
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = t->targets + i;
 
+		per_io_data_size = max(per_io_data_size, ti->per_io_data_size);
+		min_pool_size = max(min_pool_size, ti->num_flush_bios);
+	}
+	pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
+	front_pad = roundup(per_io_data_size,
+		__alignof__(struct dm_target_io)) + DM_TARGET_IO_BIO_OFFSET;
+
+	io_front_pad = roundup(per_io_data_size,
+		__alignof__(struct dm_io)) + DM_IO_BIO_OFFSET;
+	if (bioset_init(&pools->io_bs, pool_size, io_front_pad,
+			dm_table_supports_poll(t) ? BIOSET_PERCPU_CACHE : 0))
+		goto out_free_pools;
+	if (t->integrity_supported &&
+	    bioset_integrity_create(&pools->io_bs, pool_size))
+		goto out_free_pools;
+init_bs:
+	if (bioset_init(&pools->bs, pool_size, front_pad, 0))
+		goto out_free_pools;
+	if (t->integrity_supported &&
+	    bioset_integrity_create(&pools->bs, pool_size))
+		goto out_free_pools;
+
+	t->mempools = pools;
 	return 0;
+
+out_free_pools:
+	dm_free_md_mempools(pools);
+	return -ENOMEM;
 }
 
 static int setup_indexes(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8b21155d3c4f5..ca390a8c9ae6f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -88,10 +88,6 @@ struct clone_info {
 	bool submit_as_polled:1;
 };
 
-#define DM_TARGET_IO_BIO_OFFSET (offsetof(struct dm_target_io, clone))
-#define DM_IO_BIO_OFFSET \
-	(offsetof(struct dm_target_io, clone) + offsetof(struct dm_io, tio))
-
 static inline struct dm_target_io *clone_to_tio(struct bio *clone)
 {
 	return container_of(clone, struct dm_target_io, clone);
@@ -2972,54 +2968,6 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
-					    unsigned per_io_data_size, unsigned min_pool_size,
-					    bool integrity, bool poll)
-{
-	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
-	unsigned int pool_size = 0;
-	unsigned int front_pad, io_front_pad;
-	int ret;
-
-	if (!pools)
-		return NULL;
-
-	switch (type) {
-	case DM_TYPE_BIO_BASED:
-	case DM_TYPE_DAX_BIO_BASED:
-		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
-		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + DM_TARGET_IO_BIO_OFFSET;
-		io_front_pad = roundup(per_io_data_size,  __alignof__(struct dm_io)) + DM_IO_BIO_OFFSET;
-		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, poll ? BIOSET_PERCPU_CACHE : 0);
-		if (ret)
-			goto out;
-		if (integrity && bioset_integrity_create(&pools->io_bs, pool_size))
-			goto out;
-		break;
-	case DM_TYPE_REQUEST_BASED:
-		pool_size = max(dm_get_reserved_rq_based_ios(), min_pool_size);
-		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
-		/* per_io_data_size is used for blk-mq pdu at queue allocation */
-		break;
-	default:
-		BUG();
-	}
-
-	ret = bioset_init(&pools->bs, pool_size, front_pad, 0);
-	if (ret)
-		goto out;
-
-	if (integrity && bioset_integrity_create(&pools->bs, pool_size))
-		goto out;
-
-	return pools;
-
-out:
-	dm_free_md_mempools(pools);
-
-	return NULL;
-}
-
 void dm_free_md_mempools(struct dm_md_mempools *pools)
 {
 	if (!pools)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index a8405ce305a96..62816b647f827 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -218,9 +218,6 @@ void dm_kcopyd_exit(void);
 /*
  * Mempool operations
  */
-struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
-					    unsigned per_io_data_size, unsigned min_pool_size,
-					    bool integrity, bool poll);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 /*
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

