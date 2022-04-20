Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEEEC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 07:29:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-dhXUWMXFPIKOT2hv_YmZEA-1; Wed, 20 Apr 2022 03:29:14 -0400
X-MC-Unique: dhXUWMXFPIKOT2hv_YmZEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D09B0811E84;
	Wed, 20 Apr 2022 07:29:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B76582026D07;
	Wed, 20 Apr 2022 07:29:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9441B19451F2;
	Wed, 20 Apr 2022 07:29:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77BDA19451F2
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 07:29:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6902D40CFD0F; Wed, 20 Apr 2022 07:29:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 647F440CFD0E
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 07:29:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4207929AB3F2
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 07:29:10 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-F0Y0L7cUNT-aHEY8Zyv_IQ-1; Wed, 20 Apr 2022 03:29:06 -0400
X-MC-Unique: F0Y0L7cUNT-aHEY8Zyv_IQ-1
Received: from [2001:4bb8:191:364b:4299:55c7:4b14:f042] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nh480-007cZI-LV; Wed, 20 Apr 2022 06:47:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@google.com>
Date: Wed, 20 Apr 2022 08:47:44 +0200
Message-Id: <20220420064745.1119823-2-hch@lst.de>
In-Reply-To: <20220420064745.1119823-1-hch@lst.de>
References: <20220420064745.1119823-1-hch@lst.de>
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
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH 1/2] blk-crypto: merge blk-crypto-sysfs.c into
 blk-crypto-profile.c
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
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-scsi@vger.kernel.org,
 linux-mmc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Ritesh Harjani <riteshh@codeaurora.org>, linux-block@vger.kernel.org,
 Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
 Alim Akhtar <alim.akhtar@samsung.com>, Asutosh Das <asutoshd@codeaurora.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Merge blk-crypto-sysfs.c into blk-crypto-profile.c in preparation of
fixing the kobject lifetimes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Makefile             |   3 +-
 block/blk-crypto-profile.c | 164 ++++++++++++++++++++++++++++++++++-
 block/blk-crypto-sysfs.c   | 172 -------------------------------------
 3 files changed, 164 insertions(+), 175 deletions(-)
 delete mode 100644 block/blk-crypto-sysfs.c

diff --git a/block/Makefile b/block/Makefile
index 3950ecbc5c263..f38eaa6129296 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -36,7 +36,6 @@ obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
 obj-$(CONFIG_BLK_DEBUG_FS_ZONED)+= blk-mq-debugfs-zoned.o
 obj-$(CONFIG_BLK_SED_OPAL)	+= sed-opal.o
 obj-$(CONFIG_BLK_PM)		+= blk-pm.o
-obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
-					   blk-crypto-sysfs.o
+obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 96c511967386d..4f444323cb491 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright 2019 Google LLC
+ * Copyright 2019-2021 Google LLC
  */
 
 /**
@@ -32,6 +32,7 @@
 #include <linux/wait.h>
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
+#include "blk-crypto-internal.h"
 
 struct blk_crypto_keyslot {
 	atomic_t slot_refs;
@@ -41,6 +42,150 @@ struct blk_crypto_keyslot {
 	struct blk_crypto_profile *profile;
 };
 
+struct blk_crypto_kobj {
+	struct kobject kobj;
+	struct blk_crypto_profile *profile;
+};
+
+struct blk_crypto_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_crypto_profile *profile,
+			struct blk_crypto_attr *attr, char *page);
+};
+
+static struct blk_crypto_profile *kobj_to_crypto_profile(struct kobject *kobj)
+{
+	return container_of(kobj, struct blk_crypto_kobj, kobj)->profile;
+}
+
+static struct blk_crypto_attr *attr_to_crypto_attr(struct attribute *attr)
+{
+	return container_of(attr, struct blk_crypto_attr, attr);
+}
+
+static ssize_t max_dun_bits_show(struct blk_crypto_profile *profile,
+				 struct blk_crypto_attr *attr, char *page)
+{
+	return sysfs_emit(page, "%u\n", 8 * profile->max_dun_bytes_supported);
+}
+
+static ssize_t num_keyslots_show(struct blk_crypto_profile *profile,
+				 struct blk_crypto_attr *attr, char *page)
+{
+	return sysfs_emit(page, "%u\n", profile->num_slots);
+}
+
+#define BLK_CRYPTO_RO_ATTR(_name) \
+	static struct blk_crypto_attr _name##_attr = __ATTR_RO(_name)
+
+BLK_CRYPTO_RO_ATTR(max_dun_bits);
+BLK_CRYPTO_RO_ATTR(num_keyslots);
+
+static struct attribute *blk_crypto_attrs[] = {
+	&max_dun_bits_attr.attr,
+	&num_keyslots_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group blk_crypto_attr_group = {
+	.attrs = blk_crypto_attrs,
+};
+
+/*
+ * The encryption mode attributes.  To avoid hard-coding the list of encryption
+ * modes, these are initialized at boot time by blk_crypto_sysfs_init().
+ */
+static struct blk_crypto_attr __blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX];
+static struct attribute *blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX + 1];
+
+static umode_t blk_crypto_mode_is_visible(struct kobject *kobj,
+					  struct attribute *attr, int n)
+{
+	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
+	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
+	int mode_num = a - __blk_crypto_mode_attrs;
+
+	if (profile->modes_supported[mode_num])
+		return 0444;
+	return 0;
+}
+
+static ssize_t blk_crypto_mode_show(struct blk_crypto_profile *profile,
+				    struct blk_crypto_attr *attr, char *page)
+{
+	int mode_num = attr - __blk_crypto_mode_attrs;
+
+	return sysfs_emit(page, "0x%x\n", profile->modes_supported[mode_num]);
+}
+
+static const struct attribute_group blk_crypto_modes_attr_group = {
+	.name = "modes",
+	.attrs = blk_crypto_mode_attrs,
+	.is_visible = blk_crypto_mode_is_visible,
+};
+
+static const struct attribute_group *blk_crypto_attr_groups[] = {
+	&blk_crypto_attr_group,
+	&blk_crypto_modes_attr_group,
+	NULL,
+};
+
+static ssize_t blk_crypto_attr_show(struct kobject *kobj,
+				    struct attribute *attr, char *page)
+{
+	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
+	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
+
+	return a->show(profile, a, page);
+}
+
+static const struct sysfs_ops blk_crypto_attr_ops = {
+	.show = blk_crypto_attr_show,
+};
+
+static void blk_crypto_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct blk_crypto_kobj, kobj));
+}
+
+static struct kobj_type blk_crypto_ktype = {
+	.default_groups = blk_crypto_attr_groups,
+	.sysfs_ops	= &blk_crypto_attr_ops,
+	.release	= blk_crypto_release,
+};
+
+/*
+ * If the request_queue has a blk_crypto_profile, create the "crypto"
+ * subdirectory in sysfs (/sys/block/$disk/queue/crypto/).
+ */
+int blk_crypto_sysfs_register(struct request_queue *q)
+{
+	struct blk_crypto_kobj *obj;
+	int err;
+
+	if (!q->crypto_profile)
+		return 0;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+	obj->profile = q->crypto_profile;
+
+	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
+				   "crypto");
+	if (err) {
+		kobject_put(&obj->kobj);
+		return err;
+	}
+	q->crypto_kobject = &obj->kobj;
+	return 0;
+}
+
+void blk_crypto_sysfs_unregister(struct request_queue *q)
+{
+	kobject_put(q->crypto_kobject);
+}
+
 static inline void blk_crypto_hw_enter(struct blk_crypto_profile *profile)
 {
 	/*
@@ -558,3 +703,20 @@ void blk_crypto_update_capabilities(struct blk_crypto_profile *dst,
 	dst->max_dun_bytes_supported = src->max_dun_bytes_supported;
 }
 EXPORT_SYMBOL_GPL(blk_crypto_update_capabilities);
+
+static int __init blk_crypto_sysfs_init(void)
+{
+	int i;
+
+	BUILD_BUG_ON(BLK_ENCRYPTION_MODE_INVALID != 0);
+	for (i = 1; i < BLK_ENCRYPTION_MODE_MAX; i++) {
+		struct blk_crypto_attr *attr = &__blk_crypto_mode_attrs[i];
+
+		attr->attr.name = blk_crypto_modes[i].name;
+		attr->attr.mode = 0444;
+		attr->show = blk_crypto_mode_show;
+		blk_crypto_mode_attrs[i - 1] = &attr->attr;
+	}
+	return 0;
+}
+subsys_initcall(blk_crypto_sysfs_init);
diff --git a/block/blk-crypto-sysfs.c b/block/blk-crypto-sysfs.c
deleted file mode 100644
index fd93bd2f33b75..0000000000000
--- a/block/blk-crypto-sysfs.c
+++ /dev/null
@@ -1,172 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright 2021 Google LLC
- *
- * sysfs support for blk-crypto.  This file contains the code which exports the
- * crypto capabilities of devices via /sys/block/$disk/queue/crypto/.
- */
-
-#include <linux/blk-crypto-profile.h>
-
-#include "blk-crypto-internal.h"
-
-struct blk_crypto_kobj {
-	struct kobject kobj;
-	struct blk_crypto_profile *profile;
-};
-
-struct blk_crypto_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct blk_crypto_profile *profile,
-			struct blk_crypto_attr *attr, char *page);
-};
-
-static struct blk_crypto_profile *kobj_to_crypto_profile(struct kobject *kobj)
-{
-	return container_of(kobj, struct blk_crypto_kobj, kobj)->profile;
-}
-
-static struct blk_crypto_attr *attr_to_crypto_attr(struct attribute *attr)
-{
-	return container_of(attr, struct blk_crypto_attr, attr);
-}
-
-static ssize_t max_dun_bits_show(struct blk_crypto_profile *profile,
-				 struct blk_crypto_attr *attr, char *page)
-{
-	return sysfs_emit(page, "%u\n", 8 * profile->max_dun_bytes_supported);
-}
-
-static ssize_t num_keyslots_show(struct blk_crypto_profile *profile,
-				 struct blk_crypto_attr *attr, char *page)
-{
-	return sysfs_emit(page, "%u\n", profile->num_slots);
-}
-
-#define BLK_CRYPTO_RO_ATTR(_name) \
-	static struct blk_crypto_attr _name##_attr = __ATTR_RO(_name)
-
-BLK_CRYPTO_RO_ATTR(max_dun_bits);
-BLK_CRYPTO_RO_ATTR(num_keyslots);
-
-static struct attribute *blk_crypto_attrs[] = {
-	&max_dun_bits_attr.attr,
-	&num_keyslots_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group blk_crypto_attr_group = {
-	.attrs = blk_crypto_attrs,
-};
-
-/*
- * The encryption mode attributes.  To avoid hard-coding the list of encryption
- * modes, these are initialized at boot time by blk_crypto_sysfs_init().
- */
-static struct blk_crypto_attr __blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX];
-static struct attribute *blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX + 1];
-
-static umode_t blk_crypto_mode_is_visible(struct kobject *kobj,
-					  struct attribute *attr, int n)
-{
-	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
-	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
-	int mode_num = a - __blk_crypto_mode_attrs;
-
-	if (profile->modes_supported[mode_num])
-		return 0444;
-	return 0;
-}
-
-static ssize_t blk_crypto_mode_show(struct blk_crypto_profile *profile,
-				    struct blk_crypto_attr *attr, char *page)
-{
-	int mode_num = attr - __blk_crypto_mode_attrs;
-
-	return sysfs_emit(page, "0x%x\n", profile->modes_supported[mode_num]);
-}
-
-static const struct attribute_group blk_crypto_modes_attr_group = {
-	.name = "modes",
-	.attrs = blk_crypto_mode_attrs,
-	.is_visible = blk_crypto_mode_is_visible,
-};
-
-static const struct attribute_group *blk_crypto_attr_groups[] = {
-	&blk_crypto_attr_group,
-	&blk_crypto_modes_attr_group,
-	NULL,
-};
-
-static ssize_t blk_crypto_attr_show(struct kobject *kobj,
-				    struct attribute *attr, char *page)
-{
-	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
-	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
-
-	return a->show(profile, a, page);
-}
-
-static const struct sysfs_ops blk_crypto_attr_ops = {
-	.show = blk_crypto_attr_show,
-};
-
-static void blk_crypto_release(struct kobject *kobj)
-{
-	kfree(container_of(kobj, struct blk_crypto_kobj, kobj));
-}
-
-static struct kobj_type blk_crypto_ktype = {
-	.default_groups = blk_crypto_attr_groups,
-	.sysfs_ops	= &blk_crypto_attr_ops,
-	.release	= blk_crypto_release,
-};
-
-/*
- * If the request_queue has a blk_crypto_profile, create the "crypto"
- * subdirectory in sysfs (/sys/block/$disk/queue/crypto/).
- */
-int blk_crypto_sysfs_register(struct request_queue *q)
-{
-	struct blk_crypto_kobj *obj;
-	int err;
-
-	if (!q->crypto_profile)
-		return 0;
-
-	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-	obj->profile = q->crypto_profile;
-
-	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
-				   "crypto");
-	if (err) {
-		kobject_put(&obj->kobj);
-		return err;
-	}
-	q->crypto_kobject = &obj->kobj;
-	return 0;
-}
-
-void blk_crypto_sysfs_unregister(struct request_queue *q)
-{
-	kobject_put(q->crypto_kobject);
-}
-
-static int __init blk_crypto_sysfs_init(void)
-{
-	int i;
-
-	BUILD_BUG_ON(BLK_ENCRYPTION_MODE_INVALID != 0);
-	for (i = 1; i < BLK_ENCRYPTION_MODE_MAX; i++) {
-		struct blk_crypto_attr *attr = &__blk_crypto_mode_attrs[i];
-
-		attr->attr.name = blk_crypto_modes[i].name;
-		attr->attr.mode = 0444;
-		attr->show = blk_crypto_mode_show;
-		blk_crypto_mode_attrs[i - 1] = &attr->attr;
-	}
-	return 0;
-}
-subsys_initcall(blk_crypto_sysfs_init);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

