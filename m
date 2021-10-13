Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A347CC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D59461181
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D59461181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-v1DimTJ5NK2Z6xFCw4itTA-1; Wed, 13 Oct 2021 15:17:22 -0400
X-MC-Unique: v1DimTJ5NK2Z6xFCw4itTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFE2010144FA;
	Wed, 13 Oct 2021 19:17:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE11660CA1;
	Wed, 13 Oct 2021 19:17:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 75FB54EA39;
	Wed, 13 Oct 2021 19:17:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJD1cX018713 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:13:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 642D540CFD11; Wed, 13 Oct 2021 19:13:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F29140CFD10
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41CF4899EC5
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:01 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-457-4MOKIi9oMDCO1RBUepq6gg-1;
	Wed, 13 Oct 2021 15:12:56 -0400
X-MC-Unique: 4MOKIi9oMDCO1RBUepq6gg-1
Received: from
	linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
	(linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 53A0520B9D07;
	Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 53A0520B9D07
From: deven.desai@linux.microsoft.com
To: corbet@lwn.net, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Date: Wed, 13 Oct 2021 12:06:30 -0700
Message-Id: <1634151995-16266-12-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	jannh@google.com, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-audit@redhat.com
Subject: [dm-devel] [RFC PATCH v7 11/16] ipe: add support for dm-verity as a
	trust provider
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

Allows author of IPE policy to indicate trust for a singular dm-verity
volume, identified by roothash, through "dmverity_roothash" and all
signed dm-verity volumes, through "dmverity_signature".

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Squash patch 08/12, 10/12 to [11/16]

---
 security/ipe/eval.c                       |  5 ++
 security/ipe/eval.h                       | 10 +++
 security/ipe/hooks.c                      | 48 ++++++++++++++
 security/ipe/hooks.h                      |  6 ++
 security/ipe/ipe.c                        |  9 +++
 security/ipe/ipe.h                        |  3 +
 security/ipe/modules/Kconfig              | 23 +++++++
 security/ipe/modules/Makefile             |  2 +
 security/ipe/modules/dmverity_roothash.c  | 80 +++++++++++++++++++++++
 security/ipe/modules/dmverity_signature.c | 25 +++++++
 10 files changed, 211 insertions(+)
 create mode 100644 security/ipe/modules/dmverity_roothash.c
 create mode 100644 security/ipe/modules/dmverity_signature.c

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 361efccebad4..facc05c753f4 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -23,6 +23,7 @@ static struct super_block *pinned_sb;
 static DEFINE_SPINLOCK(pin_lock);
 
 #define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+#define FILE_BLOCK_DEV(f) (FILE_SUPERBLOCK(f)->s_bdev)
 
 /**
  * pin_sb: pin the underlying superblock of @f, marking it as trusted
@@ -95,6 +96,10 @@ static struct ipe_eval_ctx *build_ctx(const struct file *file,
 	ctx->hook = hook;
 	ctx->ci_ctx = ipe_current_ctx();
 	ctx->from_init_sb = from_pinned(file);
+	if (file) {
+		if (FILE_BLOCK_DEV(file))
+			ctx->ipe_bdev = ipe_bdev(FILE_BLOCK_DEV(file));
+	}
 
 	return ctx;
 }
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 42fb7fdf2599..25d2d8d55702 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -13,6 +13,14 @@
 #include "hooks.h"
 #include "policy.h"
 
+struct ipe_bdev {
+	const u8       *sigdata;
+	size_t		siglen;
+
+	const u8       *hash;
+	size_t		hashlen;
+};
+
 struct ipe_eval_ctx {
 	enum ipe_hook hook;
 	enum ipe_operation op;
@@ -20,6 +28,8 @@ struct ipe_eval_ctx {
 	const struct file *file;
 	struct ipe_context *ci_ctx;
 
+	const struct ipe_bdev *ipe_bdev;
+
 	bool from_init_sb;
 };
 
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 2d4a4f0eead0..470fb48e490c 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/refcount.h>
 #include <linux/rcupdate.h>
+#include <linux/blk_types.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
 
@@ -219,3 +220,50 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
 {
 	ipe_invalidate_pinned_sb(mnt_sb);
 }
+
+/**
+ * ipe_bdev_free_security: free nested structures within IPE's LSM blob
+ *			   in block_devices
+ * @bdev: Supplies a pointer to a block_device that contains the structure
+ *	  to free.
+ */
+void ipe_bdev_free_security(struct block_device *bdev)
+{
+	struct ipe_bdev *blob = ipe_bdev(bdev);
+
+	kfree(blob->sigdata);
+}
+
+/**
+ * ipe_bdev_setsecurity: associate some data from the block device layer
+ *			 with IPE's LSM blob.
+ * @bdev: Supplies a pointer to a block_device that contains the LSM blob.
+ * @key: Supplies the string key that uniquely identifies the value.
+ * @value: Supplies the value to store.
+ * @len: The length of @value.
+ */
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len)
+{
+	struct ipe_bdev *blob = ipe_bdev(bdev);
+
+	if (!strcmp(key, DM_VERITY_SIGNATURE_SEC_NAME)) {
+		blob->siglen = len;
+		blob->sigdata = kmemdup(value, len, GFP_KERNEL);
+		if (!blob->sigdata)
+			return -ENOMEM;
+
+		return 0;
+	}
+
+	if (!strcmp(key, DM_VERITY_ROOTHASH_SEC_NAME)) {
+		blob->hashlen = len;
+		blob->hash = kmemdup(value, len, GFP_KERNEL);
+		if (!blob->hash)
+			return -ENOMEM;
+
+		return 0;
+	}
+
+	return -ENOSYS;
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index e7f107ab5620..285f35187188 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/device-mapper.h>
 
 enum ipe_hook {
 	ipe_hook_exec = 0,
@@ -40,4 +41,9 @@ int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
 void ipe_sb_free_security(struct super_block *mnt_sb);
 
+void ipe_bdev_free_security(struct block_device *bdev);
+
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 1382d50078ec..215936cb4574 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -9,6 +9,7 @@
 #include "ipe_parser.h"
 #include "modules/ipe_module.h"
 #include "modules.h"
+#include "eval.h"
 
 #include <linux/fs.h>
 #include <linux/sched.h>
@@ -20,8 +21,14 @@
 
 struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 	.lbs_task = sizeof(struct ipe_context __rcu *),
+	.lbs_bdev = sizeof(struct ipe_bdev),
 };
 
+struct ipe_bdev *ipe_bdev(struct block_device *b)
+{
+	return b->security + ipe_blobs.lbs_bdev;
+}
+
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
 	LSM_HOOK_INIT(task_free, ipe_task_free),
@@ -31,6 +38,8 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(kernel_read_file, ipe_on_kernel_read),
 	LSM_HOOK_INIT(kernel_load_data, ipe_on_kernel_load_data),
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
+	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
+	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index ad16d2bebfec..6b4c7e07f204 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -14,10 +14,13 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/blk_types.h>
 #include <linux/lsm_hooks.h>
 
 extern struct lsm_blob_sizes ipe_blobs;
 extern struct ipe_parser __start_ipe_parsers[], __end_ipe_parsers[];
 extern struct ipe_module __start_ipe_modules[], __end_ipe_modules[];
 
+struct ipe_bdev *ipe_bdev(struct block_device *b);
+
 #endif /* IPE_H */
diff --git a/security/ipe/modules/Kconfig b/security/ipe/modules/Kconfig
index fad96ba534e2..a6ea06cf0737 100644
--- a/security/ipe/modules/Kconfig
+++ b/security/ipe/modules/Kconfig
@@ -16,5 +16,28 @@ config IPE_PROP_BOOT_VERIFIED
 
 	  If unsure, answer N.
 
+config IPE_PROP_DM_VERITY_SIGNATURE
+	bool "Enable support for signed dm-verity volumes"
+	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
+	default Y
+	help
+	  This option enables the property 'dmverity_signature' in
+	  IPE policy. This property evaluates to TRUE when a file
+	  is evaluated against a dm-verity volume that was mounted
+	  with a signed root-hash.
+
+	  If unsure, answer Y.
+
+config IPE_PROP_DM_VERITY_ROOTHASH
+	bool "Enable support for dm-verity volumes"
+	depends on DM_VERITY
+	default Y
+	help
+	  This option enables the property 'dmverity_roothash' in
+	  IPE policy. This property evaluates to TRUE when a file
+	  is evaluated against a dm-verity volume whose root hash
+	  matches the supplied value.
+
+	  If unsure, answer Y.
 
 endmenu
diff --git a/security/ipe/modules/Makefile b/security/ipe/modules/Makefile
index e0045ec65434..84fadce85193 100644
--- a/security/ipe/modules/Makefile
+++ b/security/ipe/modules/Makefile
@@ -6,3 +6,5 @@
 #
 
 obj-$(CONFIG_IPE_PROP_BOOT_VERIFIED) += boot_verified.o
+obj-$(CONFIG_IPE_PROP_DM_VERITY_SIGNATURE) += dmverity_signature.o
+obj-$(CONFIG_IPE_PROP_DM_VERITY_ROOTHASH) += dmverity_roothash.o
diff --git a/security/ipe/modules/dmverity_roothash.c b/security/ipe/modules/dmverity_roothash.c
new file mode 100644
index 000000000000..0f82bec3b842
--- /dev/null
+++ b/security/ipe/modules/dmverity_roothash.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+
+struct counted_array {
+	size_t	len;
+	u8     *data;
+};
+
+static int dvrh_parse(const char *valstr, void **value)
+{
+	int rv = 0;
+	struct counted_array *arr;
+
+	arr = kzalloc(sizeof(*arr), GFP_KERNEL);
+	if (!arr) {
+		rv = -ENOMEM;
+		goto err;
+	}
+
+	arr->len = (strlen(valstr) / 2);
+
+	arr->data = kzalloc(arr->len, GFP_KERNEL);
+	if (!arr->data) {
+		rv = -ENOMEM;
+		goto err;
+	}
+
+	rv = hex2bin(arr->data, valstr, arr->len);
+	if (rv != 0)
+		goto err2;
+
+	*value = arr;
+	return rv;
+err2:
+	kfree(arr->data);
+err:
+	kfree(arr);
+	return rv;
+}
+
+static bool dvrh_eval(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	const u8 *src;
+	struct counted_array *expect = (struct counted_array *)val;
+
+	if (!ctx->ipe_bdev)
+		return false;
+
+	if (ctx->ipe_bdev->hashlen != expect->len)
+		return false;
+
+	src = ctx->ipe_bdev->hash;
+
+	return !memcmp(expect->data, src, expect->len);
+}
+
+static int dvrh_free(void **val)
+{
+	struct counted_array *expect = (struct counted_array *)val;
+
+	kfree(expect->data);
+	kfree(expect);
+
+	return 0;
+}
+
+IPE_MODULE(dvrh) = {
+	.name = "dmverity_roothash",
+	.version = 1,
+	.parse = dvrh_parse,
+	.free = dvrh_free,
+	.eval = dvrh_eval,
+};
diff --git a/security/ipe/modules/dmverity_signature.c b/security/ipe/modules/dmverity_signature.c
new file mode 100644
index 000000000000..08746fcbcb3e
--- /dev/null
+++ b/security/ipe/modules/dmverity_signature.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+
+static bool dvv_eval(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	bool expect = (bool)val;
+	bool eval = ctx->ipe_bdev && (!!ctx->ipe_bdev->sigdata);
+
+	return expect == eval;
+}
+
+IPE_MODULE(dvv) = {
+	.name = "dmverity_signature",
+	.version = 1,
+	.parse = ipe_bool_parse,
+	.free = NULL,
+	.eval = dvv_eval,
+};
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

