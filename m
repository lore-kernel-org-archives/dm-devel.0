Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBCBC433E6
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:11:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C0CA64E2E
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 05:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C0CA64E2E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-2h4bPPbnMkieDKyG78k1KA-1; Mon, 01 Feb 2021 00:11:07 -0500
X-MC-Unique: 2h4bPPbnMkieDKyG78k1KA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57EB8107B46E;
	Mon,  1 Feb 2021 05:11:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A53F2C169;
	Mon,  1 Feb 2021 05:11:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C3A25003C;
	Mon,  1 Feb 2021 05:11:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1115Aa9d015681 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 00:10:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 227D92026D14; Mon,  1 Feb 2021 05:10:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D3D42026D12
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0542D88CC47
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 05:10:36 +0000 (UTC)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
	[209.85.222.201]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-402-Pa2bxgpsOFSli13PPa2sXA-1; Mon, 01 Feb 2021 00:10:33 -0500
X-MC-Unique: Pa2bxgpsOFSli13PPa2sXA-1
Received: by mail-qk1-f201.google.com with SMTP id v130so12356264qkb.14
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 21:10:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
	:references:subject:from:to:cc;
	bh=eH/IQ4cPAiChDSG9DalEpGZrhp9HxbyK3uyuxX2viTI=;
	b=gqVzaZerhgoEZlHS77NCnCcCikELtcK2PkX++rhzJFbTIc3P3W/Rg1lgX8S8zraIM6
	3X6RSNFU9bZuK3LMDGadZec8OjfSs7SknmNZ4qetbJurwfPo8s2SwYcBZK7IOTuzwAh7
	luS7knZV4R5ZF/wF4wQ69J5gBft2vchNmvYpUXomG5mSu/honfR1qPyMFVIoGUQuD+wm
	EJquStGZtMGxa6n7vOLswIBmXVGwPsH5ooP3sbbs5uxXp1ut2T2B9v3DIlxqeRT1ahxX
	KJ4/GBeHCt3ndQi7G1X4cdaMKMoV6bBfz9KoDDVHFz5bstf8H0jwXQLLcxS5xtQlDS49
	OopQ==
X-Gm-Message-State: AOAM532bfyzvfb9mwZs9EdCJKLddYafYrC895unDFkmcHfxa7JqFe3no
	oYvaYHURaMMGKFQMvPr5g6B0OR4khxE=
X-Google-Smtp-Source: ABdhPJzYuQHdeXxCnHtchUSmKgN0KQ33zn+u4o9ipVSr6qrh0mx0YiTLsaGMSTcP5EvXTLKTVwJYtE0um2k=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:ad4:4348:: with SMTP id
	q8mr13995118qvs.36.1612156233428; 
	Sun, 31 Jan 2021 21:10:33 -0800 (PST)
Date: Mon,  1 Feb 2021 05:10:17 +0000
In-Reply-To: <20210201051019.1174983-1-satyat@google.com>
Message-Id: <20210201051019.1174983-4-satyat@google.com>
Mime-Version: 1.0
References: <20210201051019.1174983-1-satyat@google.com>
From: Satya Tangirala <satyat@google.com>
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v4 3/5] dm: add support for passing through
	inline crypto support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Update the device-mapper core to support exposing the inline crypto
support of the underlying device(s) through the device-mapper device.

This works by creating a "passthrough keyslot manager" for the dm
device, which declares support for encryption settings which all
underlying devices support.  When a supported setting is used, the bio
cloning code handles cloning the crypto context to the bios for all the
underlying devices.  When an unsupported setting is used, the blk-crypto
fallback is used as usual.

Crypto support on each underlying device is ignored unless the
corresponding dm target opts into exposing it.  This is needed because
for inline crypto to semantically operate on the original bio, the data
must not be transformed by the dm target.  Thus, targets like dm-linear
can expose crypto support of the underlying device, but targets like
dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)

A DM device's table can only be changed if the "new" inline encryption
capabilities are a (*not* necessarily strict) superset of the "old" inline
encryption capabilities.  Attempts to make changes to the table that result
in some inline encryption capability becoming no longer supported will be
rejected.

For the sake of clarity, key eviction from underlying devices will be
handled in a future patch.

Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 drivers/md/dm-core.h          |   5 ++
 drivers/md/dm-table.c         | 157 ++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  18 +++-
 include/linux/device-mapper.h |  11 +++
 4 files changed, 190 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 086d293c2b03..bf3e66f39a4a 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -13,6 +13,7 @@
 #include <linux/ktime.h>
 #include <linux/genhd.h>
 #include <linux/blk-mq.h>
+#include <linux/keyslot-manager.h>
 
 #include <trace/events/block.h>
 
@@ -162,6 +163,10 @@ struct dm_table {
 	void *event_context;
 
 	struct dm_md_mempools *mempools;
+
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct blk_keyslot_manager *ksm;
+#endif
 };
 
 static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4acf2342f7ad..b37f69343923 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -187,6 +187,8 @@ static void free_devices(struct list_head *devices, struct mapped_device *md)
 	}
 }
 
+static void dm_table_destroy_keyslot_manager(struct dm_table *t);
+
 void dm_table_destroy(struct dm_table *t)
 {
 	unsigned int i;
@@ -215,6 +217,8 @@ void dm_table_destroy(struct dm_table *t)
 
 	dm_free_md_mempools(t->mempools);
 
+	dm_table_destroy_keyslot_manager(t);
+
 	kfree(t);
 }
 
@@ -1203,6 +1207,152 @@ static int dm_table_register_integrity(struct dm_table *t)
 	return 0;
 }
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+
+struct dm_keyslot_manager {
+	struct blk_keyslot_manager ksm;
+	struct mapped_device *md;
+};
+
+static int device_intersect_crypto_modes(struct dm_target *ti,
+					 struct dm_dev *dev, sector_t start,
+					 sector_t len, void *data)
+{
+	struct blk_keyslot_manager *parent = data;
+	struct blk_keyslot_manager *child = bdev_get_queue(dev->bdev)->ksm;
+
+	blk_ksm_intersect_modes(parent, child);
+	return 0;
+}
+
+void dm_destroy_keyslot_manager(struct blk_keyslot_manager *ksm)
+{
+	struct dm_keyslot_manager *dksm = container_of(ksm,
+						       struct dm_keyslot_manager,
+						       ksm);
+
+	if (!ksm)
+		return;
+
+	blk_ksm_destroy(ksm);
+	kfree(dksm);
+}
+
+static void dm_table_destroy_keyslot_manager(struct dm_table *t)
+{
+	dm_destroy_keyslot_manager(t->ksm);
+	t->ksm = NULL;
+}
+
+/*
+ * Constructs and returns a keyslot manager that represents the crypto
+ * capabilities of the devices described by the dm_table. However, if the
+ * constructed keyslot manager does not support a superset of the crypto
+ * capabilities supported by the current keyslot manager of the mapped_device,
+ * it returns an error instead, since we don't support restricting crypto
+ * capabilities on table changes. Finally, if the constructed keyslot manager
+ * doesn't actually support any crypto modes at all, it just returns NULL.
+ */
+static int
+dm_table_construct_keyslot_manager(struct dm_table *t)
+{
+	struct dm_keyslot_manager *dksm;
+	struct blk_keyslot_manager *ksm;
+	struct dm_target *ti;
+	unsigned int i;
+	bool ksm_is_empty = true;
+
+	dksm = kmalloc(sizeof(*dksm), GFP_KERNEL);
+	if (!dksm)
+		return -ENOMEM;
+	dksm->md = t->md;
+
+	ksm = &dksm->ksm;
+	blk_ksm_init_passthrough(ksm);
+	ksm->max_dun_bytes_supported = UINT_MAX;
+	memset(ksm->crypto_modes_supported, 0xFF,
+	       sizeof(ksm->crypto_modes_supported));
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!dm_target_passes_crypto(ti->type)) {
+			blk_ksm_intersect_modes(ksm, NULL);
+			break;
+		}
+		if (!ti->type->iterate_devices)
+			continue;
+		ti->type->iterate_devices(ti, device_intersect_crypto_modes,
+					  ksm);
+	}
+
+	if (t->md->queue && !blk_ksm_is_superset(ksm, t->md->queue->ksm)) {
+		DMWARN("Inline encryption capabilities of new DM table were more restrictive than the old table's. This is not supported!");
+		dm_destroy_keyslot_manager(ksm);
+		return -EINVAL;
+	}
+
+	/*
+	 * If the new KSM doesn't actually support any crypto modes, we may as
+	 * well represent it with a NULL ksm.
+	 */
+	ksm_is_empty = true;
+	for (i = 0; i < ARRAY_SIZE(ksm->crypto_modes_supported); i++) {
+		if (ksm->crypto_modes_supported[i]) {
+			ksm_is_empty = false;
+			break;
+		}
+	}
+
+	if (ksm_is_empty) {
+		dm_destroy_keyslot_manager(ksm);
+		ksm = NULL;
+	}
+
+	t->ksm = ksm;
+
+	return 0;
+}
+
+static void dm_update_keyslot_manager(struct request_queue *q,
+				      struct dm_table *t)
+{
+	if (!t->ksm)
+		return;
+
+	/* Make the ksm less restrictive */
+	if (!q->ksm) {
+		blk_ksm_register(t->ksm, q);
+	} else {
+		blk_ksm_update_capabilities(q->ksm, t->ksm);
+		dm_destroy_keyslot_manager(t->ksm);
+	}
+	t->ksm = NULL;
+}
+
+#else /* CONFIG_BLK_INLINE_ENCRYPTION */
+
+static int
+dm_table_construct_keyslot_manager(struct dm_table *t)
+{
+	return 0;
+}
+
+void dm_destroy_keyslot_manager(struct blk_keyslot_manager *ksm)
+{
+}
+
+static void dm_table_destroy_keyslot_manager(struct dm_table *t)
+{
+}
+
+static void dm_update_keyslot_manager(struct request_queue *q,
+				      struct dm_table *t)
+{
+}
+
+#endif /* !CONFIG_BLK_INLINE_ENCRYPTION */
+
 /*
  * Prepares the table for use by building the indices,
  * setting the type, and allocating mempools.
@@ -1229,6 +1379,12 @@ int dm_table_complete(struct dm_table *t)
 		return r;
 	}
 
+	r = dm_table_construct_keyslot_manager(t);
+	if (r) {
+		DMERR("could not construct keyslot manager.");
+		return r;
+	}
+
 	r = dm_table_alloc_md_mempools(t, t->md);
 	if (r)
 		DMERR("unable to allocate mempools");
@@ -1891,6 +2047,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 #endif
 
+	dm_update_keyslot_manager(q, t);
 	blk_queue_update_readahead(q);
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7bac564f3faa..ee0434764941 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -28,6 +28,7 @@
 #include <linux/refcount.h>
 #include <linux/part_stat.h>
 #include <linux/blk-crypto.h>
+#include <linux/keyslot-manager.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -1718,6 +1719,19 @@ static const struct dax_operations dm_dax_ops;
 
 static void dm_wq_work(struct work_struct *work);
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+static void dm_queue_destroy_keyslot_manager(struct request_queue *q)
+{
+	dm_destroy_keyslot_manager(q->ksm);
+}
+
+#else /* CONFIG_BLK_INLINE_ENCRYPTION */
+
+static inline void dm_queue_destroy_keyslot_manager(struct request_queue *q)
+{
+}
+#endif /* !CONFIG_BLK_INLINE_ENCRYPTION */
+
 static void cleanup_mapped_device(struct mapped_device *md)
 {
 	if (md->wq)
@@ -1739,8 +1753,10 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		put_disk(md->disk);
 	}
 
-	if (md->queue)
+	if (md->queue) {
+		dm_queue_destroy_keyslot_manager(md->queue);
 		blk_cleanup_queue(md->queue);
+	}
 
 	cleanup_srcu_struct(&md->io_barrier);
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 61a66fb8ebb3..d2142f5a82a7 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -257,6 +257,12 @@ struct target_type {
 #define DM_TARGET_NOWAIT		0x00000080
 #define dm_target_supports_nowait(type) ((type)->features & DM_TARGET_NOWAIT)
 
+/*
+ *
+ */
+#define DM_TARGET_PASSES_CRYPTO		0x00000100
+#define dm_target_passes_crypto(type) ((type)->features & DM_TARGET_PASSES_CRYPTO)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
@@ -533,6 +539,11 @@ void dm_table_run_md_queue_async(struct dm_table *t);
 struct dm_table *dm_swap_table(struct mapped_device *md,
 			       struct dm_table *t);
 
+/*
+ * Table keyslot manager functions
+ */
+void dm_destroy_keyslot_manager(struct blk_keyslot_manager *ksm);
+
 /*
  * A wrapper around vmalloc.
  */
-- 
2.30.0.365.g02bc693789-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

