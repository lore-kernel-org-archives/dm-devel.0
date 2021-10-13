Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414A6C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A3F7261163
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A3F7261163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-N5PaS0CsOouMV0frEfWjVQ-1; Wed, 13 Oct 2021 15:17:17 -0400
X-MC-Unique: N5PaS0CsOouMV0frEfWjVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ADB480363B;
	Wed, 13 Oct 2021 19:17:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A8DF60C5F;
	Wed, 13 Oct 2021 19:17:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1023B180598A;
	Wed, 13 Oct 2021 19:17:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJD0M1018673 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:13:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AB9F340CFD11; Wed, 13 Oct 2021 19:13:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6FA740CFD12
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B687811E78
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:00 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-457-P1GZpdRrPS6D6cp1pcWeIw-1;
	Wed, 13 Oct 2021 15:12:56 -0400
X-MC-Unique: P1GZpdRrPS6D6cp1pcWeIw-1
Received: from
	linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
	(linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 24F5220B9D04;
	Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 24F5220B9D04
From: deven.desai@linux.microsoft.com
To: corbet@lwn.net, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Date: Wed, 13 Oct 2021 12:06:28 -0700
Message-Id: <1634151995-16266-10-git-send-email-deven.desai@linux.microsoft.com>
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
Subject: [dm-devel] [RFC PATCH v7 09/16] ipe: introduce 'boot_verified' as a
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

IPE is designed to provide system level trust guarantees, this usually
implies that trust starts from bootup with a hardware root of trust,
which validates the bootloader. After this, the bootloader verifies the
kernel and the initramfs.

As there's no currently supported integrity method for initramfs, and
it's typically already verified by the bootloader, introduce a property
that causes the first superblock to have an execution to be "pinned",
which is typically initramfs.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Reword and refactor patch 04/12 to [09/16]

---
 security/ipe/Kconfig                 |  2 +
 security/ipe/Makefile                |  1 +
 security/ipe/eval.c                  | 71 ++++++++++++++++++++++++++++
 security/ipe/eval.h                  |  5 ++
 security/ipe/hooks.c                 | 14 ++++++
 security/ipe/hooks.h                 |  2 +
 security/ipe/ipe.c                   |  1 +
 security/ipe/modules.c               | 25 ++++++++++
 security/ipe/modules/Kconfig         | 20 ++++++++
 security/ipe/modules/Makefile        |  8 ++++
 security/ipe/modules/boot_verified.c | 24 ++++++++++
 security/ipe/modules/ipe_module.h    |  2 +
 12 files changed, 175 insertions(+)
 create mode 100644 security/ipe/modules/Kconfig
 create mode 100644 security/ipe/modules/Makefile
 create mode 100644 security/ipe/modules/boot_verified.c

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index ef556b66e674..fcf82a8152ec 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -68,4 +68,6 @@ config IPE_AUDIT_HASH_ALG
 	default "sha384" if IPE_AUDIT_HASH_SHA384
 	default "sha512" if IPE_AUDIT_HASH_SHA512
 
+source "security/ipe/modules/Kconfig"
+
 endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 6d9ac818e8c6..1e7b2d7fcd9e 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	fs.o \
 	hooks.o \
 	ipe.o \
+	modules/ \
 	modules.o \
 	parsers/ \
 	parsers.o \
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index e520ce521c05..361efccebad4 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -11,10 +11,62 @@
 #include "modules/ipe_module.h"
 #include "audit.h"
 
+#include <linux/fs.h>
+#include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+
+static struct super_block *pinned_sb;
+static DEFINE_SPINLOCK(pin_lock);
+
+#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+
+/**
+ * pin_sb: pin the underlying superblock of @f, marking it as trusted
+ * @f: Supplies a file structure to source the super_block from.
+ */
+static void pin_sb(const struct file *f)
+{
+	if (!f)
+		return;
+
+	spin_lock(&pin_lock);
+
+	if (pinned_sb)
+		goto out;
+
+	pinned_sb = FILE_SUPERBLOCK(f);
+
+out:
+	spin_unlock(&pin_lock);
+}
+
+/**
+ * from_pinned: determine whether @f is source from the pinned super_block.
+ * @f: Supplies a file structure to check against the pinned super_block.
+ *
+ * Return:
+ * true - @f is sourced from the pinned super_block
+ * false - @f is not sourced from the pinned super_block
+ */
+static bool from_pinned(const struct file *f)
+{
+	bool rv;
+
+	if (!f)
+		return false;
+
+	spin_lock(&pin_lock);
+
+	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == FILE_SUPERBLOCK(f);
+
+	spin_unlock(&pin_lock);
+
+	return rv;
+}
 
 /**
  * build_ctx: Build an evaluation context.
@@ -42,6 +94,7 @@ static struct ipe_eval_ctx *build_ctx(const struct file *file,
 	ctx->op = op;
 	ctx->hook = hook;
 	ctx->ci_ctx = ipe_current_ctx();
+	ctx->from_init_sb = from_pinned(file);
 
 	return ctx;
 }
@@ -145,6 +198,9 @@ int ipe_process_event(const struct file *file, enum ipe_operation op,
 	int rc = 0;
 	struct ipe_eval_ctx *ctx = NULL;
 
+	if (op == ipe_operation_exec)
+		pin_sb(file);
+
 	ctx = build_ctx(file, op, hook);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
@@ -154,3 +210,18 @@ int ipe_process_event(const struct file *file, enum ipe_operation op,
 	free_ctx(ctx);
 	return rc;
 }
+
+/**
+ * ipe_invalidate_pinned_sb: if @mnt_sb is the pinned superblock, ensure
+ *			     nothing can match it again.
+ * @mnt_sb: super_block to check against the pinned super_block
+ */
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
+{
+	spin_lock(&pin_lock);
+
+	if (!IS_ERR_OR_NULL(pinned_sb) && mnt_sb == pinned_sb)
+		pinned_sb = ERR_PTR(-EIO);
+
+	spin_unlock(&pin_lock);
+}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 8c08eed5af2b..42fb7fdf2599 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -7,6 +7,7 @@
 #define IPE_EVAL_H
 
 #include <linux/file.h>
+#include <linux/types.h>
 
 #include "ctx.h"
 #include "hooks.h"
@@ -18,6 +19,8 @@ struct ipe_eval_ctx {
 
 	const struct file *file;
 	struct ipe_context *ci_ctx;
+
+	bool from_init_sb;
 };
 
 enum ipe_match {
@@ -30,4 +33,6 @@ enum ipe_match {
 int ipe_process_event(const struct file *file, enum ipe_operation op,
 		      enum ipe_hook hook);
 
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
+
 #endif /* IPE_EVAL_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 216242408a80..2d4a4f0eead0 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -205,3 +205,17 @@ int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents)
 
 	return ipe_process_event(NULL, op, ipe_hook_kernel_load);
 }
+
+/**
+ * ipe_bdev_free_security: free nested structures within IPE's LSM blob
+ *			   in super_blocks
+ * @mnt_sb: Supplies a pointer to a super_block that contains the structure
+ *	    to free.
+ *
+ * IPE does not have any structures with mnt_sb, but uses this hook to
+ * invalidate a pinned super_block.
+ */
+void ipe_sb_free_security(struct super_block *mnt_sb)
+{
+	ipe_invalidate_pinned_sb(mnt_sb);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index c99a0b7f45f7..e7f107ab5620 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -38,4 +38,6 @@ int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id,
 
 int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
+void ipe_sb_free_security(struct super_block *mnt_sb);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 3f9d43783293..1382d50078ec 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -30,6 +30,7 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(file_mprotect, ipe_on_mprotect),
 	LSM_HOOK_INIT(kernel_read_file, ipe_on_kernel_read),
 	LSM_HOOK_INIT(kernel_load_data, ipe_on_kernel_load_data),
+	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 };
 
 /**
diff --git a/security/ipe/modules.c b/security/ipe/modules.c
index fb100c14cce5..3aa9a38fdc0d 100644
--- a/security/ipe/modules.c
+++ b/security/ipe/modules.c
@@ -107,3 +107,28 @@ int ipe_register_module(struct ipe_module *m)
 
 	return 0;
 }
+
+/**
+ * ipe_bool_parse: parse a boolean in IPE's policy and associate
+ *		   it as @value in IPE's policy.
+ * @valstr: Supplies the string parsed from the policy
+ * @value: Supplies a pointer to be populated with the result.
+ *
+ * Modules can use this function for simple true/false values
+ * instead of defining their own.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_bool_parse(const char *valstr, void **value)
+{
+	if (!strcmp(valstr, "TRUE"))
+		*value = (void *)true;
+	else if (!strcmp(valstr, "FALSE"))
+		*value = (void *)false;
+	else
+		return -EBADMSG;
+
+	return 0;
+}
diff --git a/security/ipe/modules/Kconfig b/security/ipe/modules/Kconfig
new file mode 100644
index 000000000000..fad96ba534e2
--- /dev/null
+++ b/security/ipe/modules/Kconfig
@@ -0,0 +1,20 @@
+
+menu "IPE Trust Providers"
+
+config IPE_PROP_BOOT_VERIFIED
+	bool "Enable trust for initramfs"
+	depends on SECURITY_IPE
+	default N
+	help
+	  This option enables the property 'boot_verified' in IPE policy.
+	  This property 'pins' the initial superblock when something
+	  is evaluated as an execution. This property will evaluate
+	  to true when the file being evaluated originates from this
+	  superblock.
+
+	  This property is useful to authorize a signed initramfs.
+
+	  If unsure, answer N.
+
+
+endmenu
diff --git a/security/ipe/modules/Makefile b/security/ipe/modules/Makefile
new file mode 100644
index 000000000000..e0045ec65434
--- /dev/null
+++ b/security/ipe/modules/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) Microsoft Corporation. All rights reserved.
+#
+# Makefile for building the IPE module as part of the kernel tree.
+#
+
+obj-$(CONFIG_IPE_PROP_BOOT_VERIFIED) += boot_verified.o
diff --git a/security/ipe/modules/boot_verified.c b/security/ipe/modules/boot_verified.c
new file mode 100644
index 000000000000..3ab944a485c6
--- /dev/null
+++ b/security/ipe/modules/boot_verified.c
@@ -0,0 +1,24 @@
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
+static bool bv_eval(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	bool expect = (bool)val;
+
+	return expect == ctx->from_init_sb;
+}
+
+IPE_MODULE(bv) = {
+	.name = "boot_verified",
+	.version = 1,
+	.parse = ipe_bool_parse,
+	.free = NULL,
+	.eval = bv_eval,
+};
diff --git a/security/ipe/modules/ipe_module.h b/security/ipe/modules/ipe_module.h
index 6855815d72da..08835627bd72 100644
--- a/security/ipe/modules/ipe_module.h
+++ b/security/ipe/modules/ipe_module.h
@@ -9,6 +9,8 @@
 #include <linux/audit.h>
 #include "../eval.h"
 
+int ipe_bool_parse(const char *valstr, void **value);
+
 /**
  * ipe_module: definition of an extensible module for IPE properties.
  *	       These structures are used to implement 'key=value' pairs
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

