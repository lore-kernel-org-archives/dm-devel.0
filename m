Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D024BC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DB782226A
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DB782226A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-7d__e3hoMUuRt6b1w3iv8w-1; Mon, 04 Jan 2021 14:04:22 -0500
X-MC-Unique: 7d__e3hoMUuRt6b1w3iv8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADBED802E7E;
	Mon,  4 Jan 2021 19:04:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F61F5D9DD;
	Mon,  4 Jan 2021 19:04:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 64AF25002F;
	Mon,  4 Jan 2021 19:04:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BT8tdDr010777 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 03:55:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CEFFC2166B28; Tue, 29 Dec 2020 08:55:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8C292166B2A
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 08:55:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2095C101A562
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 08:55:38 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
	[209.85.219.202]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-182-KOa6zGrPM5CxmZ5Qkp9UHQ-1; Tue, 29 Dec 2020 03:55:35 -0500
X-MC-Unique: KOa6zGrPM5CxmZ5Qkp9UHQ-1
Received: by mail-yb1-f202.google.com with SMTP id x17so22466978ybs.12
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 00:55:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
	:references:subject:from:to:cc;
	bh=AHsPHV5g9RiEHoBH6SgrbuZwM40nn1MQir4HViM7xto=;
	b=FR+a1AQrVLT/2EyHtD7EHZNyRXjh4MRd3R2moWc3lzLN5FoN2T0v4sw+sEGsfl9EK4
	zHLSkHUxrW3TTY/3gU0Sis11M1RUfIoJkgi1lXHCH63veaoR0Dw70MiwB3kleXcWbraJ
	U18D/81vJHJAMt6U2Kmuo1IFtW9j+nnA4q6EzoRDxF+AWWTbDtUMt51b06Z9hAzQXqM1
	0P9Ehsmp+WK6XD7cUniWTqY2iVPBDYouio8MR5+AWIi8WTGqCGDKQAP3AfPPTbGw2bv4
	2/x00+cd4uXpUZNkMAAJ1cIq5Qy7geVpT5/4jEBb2oQ9vQopJ54qS30FYeCjNJ0Bs4Rw
	nJbw==
X-Gm-Message-State: AOAM532aGj/RzvXZ9uzNhePcZgMoGiRNGMauPJjURVlLjwQI/sW6XFyC
	DdhDDv9gOY6SA5aN3AwxHv+61d5sr7M=
X-Google-Smtp-Source: ABdhPJwIU2/+76JfZ0atQI7PL99ZSXBC19tXBqc2dV0+l4PnayNyqylFZ8JBldRK5exI+pBQZrNvkQdIREA=
X-Received: from satyaprateek.c.googlers.com
	([fda3:e722:ac3:10:24:72f4:c0a8:1092])
	(user=satyat job=sendgmr) by 2002:a25:aea8:: with SMTP id
	b40mr71477368ybj.347.1609232134987; 
	Tue, 29 Dec 2020 00:55:34 -0800 (PST)
Date: Tue, 29 Dec 2020 08:55:21 +0000
In-Reply-To: <20201229085524.2795331-1-satyat@google.com>
Message-Id: <20201229085524.2795331-4-satyat@google.com>
Mime-Version: 1.0
References: <20201229085524.2795331-1-satyat@google.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Satya Tangirala <satyat@google.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [dm-devel] [PATCH v3 3/6] dm: add support for passing through
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 drivers/md/dm.c                 | 164 +++++++++++++++++++++++++++++++-
 include/linux/device-mapper.h   |   6 ++
 include/linux/keyslot-manager.h |   8 ++
 3 files changed, 177 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b3c3c8b4cb42..13b9c8e2e21b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -28,6 +28,7 @@
 #include <linux/refcount.h>
 #include <linux/part_stat.h>
 #include <linux/blk-crypto.h>
+#include <linux/keyslot-manager.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -1718,6 +1719,8 @@ static const struct dax_operations dm_dax_ops;
 
 static void dm_wq_work(struct work_struct *work);
 
+static void dm_destroy_inline_encryption(struct request_queue *q);
+
 static void cleanup_mapped_device(struct mapped_device *md)
 {
 	if (md->wq)
@@ -1739,8 +1742,10 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		put_disk(md->disk);
 	}
 
-	if (md->queue)
+	if (md->queue) {
+		dm_destroy_inline_encryption(md->queue);
 		blk_cleanup_queue(md->queue);
+	}
 
 	cleanup_srcu_struct(&md->io_barrier);
 
@@ -1937,6 +1942,150 @@ static void event_callback(void *context)
 	dm_issue_global_event();
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
+static void dm_destroy_keyslot_manager(struct blk_keyslot_manager *ksm)
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
+/*
+ * Constructs and returns a keyslot manager that represents the crypto
+ * capabilities of the devices described by the dm_table. However, if the
+ * constructed keyslot manager does not support a superset of the crypto
+ * capabilities supported by the current keyslot manager of the mapped_device,
+ * it returns an error instead, since we don't support restricting crypto
+ * capabilities on table changes. Finally, if the constructed keyslot manager
+ * doesn't actually support any crypto modes at all, it just returns NULL.
+ */
+static struct blk_keyslot_manager *
+dm_construct_keyslot_manager(struct mapped_device *md, struct dm_table *t)
+{
+	struct dm_keyslot_manager *dksm;
+	struct blk_keyslot_manager *ksm;
+	struct dm_target *ti;
+	unsigned int i;
+	bool ksm_is_empty = true;
+
+	dksm = kmalloc(sizeof(*dksm), GFP_KERNEL);
+	if (!dksm)
+		return ERR_PTR(-ENOMEM);
+	dksm->md = md;
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
+	if (!blk_ksm_is_superset(ksm, md->queue->ksm)) {
+		DMWARN("Inline encryption capabilities of new DM table were more restrictive than the old table's. This is not supported!");
+		dm_destroy_keyslot_manager(ksm);
+		return ERR_PTR(-EINVAL);
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
+	return ksm;
+}
+
+static void dm_update_keyslot_manager(struct request_queue *q,
+				      struct blk_keyslot_manager *ksm)
+{
+	if (!ksm)
+		return;
+
+	/* Make the ksm less restrictive */
+	if (!q->ksm) {
+		blk_ksm_register(ksm, q);
+	} else {
+		blk_ksm_update_capabilities(q->ksm, ksm);
+		dm_destroy_keyslot_manager(ksm);
+	}
+}
+
+static void dm_destroy_inline_encryption(struct request_queue *q)
+{
+	if (!q->ksm)
+		return;
+	dm_destroy_keyslot_manager(q->ksm);
+}
+
+#else /* CONFIG_BLK_INLINE_ENCRYPTION */
+
+static inline struct blk_keyslot_manager *
+dm_construct_keyslot_manager(struct mapped_device *md, struct dm_table *t)
+{
+	return NULL;
+}
+
+static void dm_update_keyslot_manager(struct request_queue *q,
+				      struct blk_keyslot_manager *ksm)
+{
+}
+
+static void dm_destroy_keyslot_manager(struct blk_keyslot_manager *ksm)
+{
+}
+
+static inline void dm_destroy_inline_encryption(struct request_queue *q)
+{
+}
+
+#endif /* !CONFIG_BLK_INLINE_ENCRYPTION */
+
 /*
  * Returns old map, which caller must destroy.
  */
@@ -2332,6 +2481,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
 	struct dm_table *live_map = NULL, *map = ERR_PTR(-EINVAL);
 	struct queue_limits limits;
+	struct blk_keyslot_manager *ksm;
 	int r;
 
 	mutex_lock(&md->suspend_lock);
@@ -2361,7 +2511,19 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		}
 	}
 
+	ksm = dm_construct_keyslot_manager(md, table);
+	if (IS_ERR(ksm)) {
+		map = ERR_CAST(ksm);
+		goto out;
+	}
+
 	map = __bind(md, table, &limits);
+
+	if (IS_ERR(map))
+		dm_destroy_keyslot_manager(ksm);
+	else
+		dm_update_keyslot_manager(md->queue, ksm);
+
 	dm_issue_global_event();
 
 out:
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 61a66fb8ebb3..0d5794a0a89a 100644
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
diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
index 164568f52be7..9164c1c72288 100644
--- a/include/linux/keyslot-manager.h
+++ b/include/linux/keyslot-manager.h
@@ -11,6 +11,8 @@
 
 struct blk_keyslot_manager;
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+
 /**
  * struct blk_ksm_ll_ops - functions to manage keyslots in hardware
  * @keyslot_program:	Program the specified key into the specified slot in the
@@ -114,4 +116,10 @@ bool blk_ksm_is_superset(struct blk_keyslot_manager *ksm_superset,
 void blk_ksm_update_capabilities(struct blk_keyslot_manager *target_ksm,
 				 struct blk_keyslot_manager *reference_ksm);
 
+#else /* CONFIG_BLK_INLINE_ENCRYPTION */
+
+static inline void blk_ksm_destroy(struct blk_keyslot_manager *ksm) { }
+
+#endif /* CONFIG_BLK_INLINE_ENCRYPTION */
+
 #endif /* __LINUX_KEYSLOT_MANAGER_H */
-- 
2.29.2.729.g45daf8777d-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

