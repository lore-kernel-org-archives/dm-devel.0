Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51820CCA47B
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 19:07:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-jGalnCwIPQqQ0P9IGJbfdQ-1; Wed, 08 Jun 2022 15:07:36 -0400
X-MC-Unique: jGalnCwIPQqQ0P9IGJbfdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B48E1C05EC0;
	Wed,  8 Jun 2022 19:07:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0715E18EAA;
	Wed,  8 Jun 2022 19:07:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C670A1947B9F;
	Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95BDB1947058
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 786AA1131A; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7477218EA7
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59EEB8027EE
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-119-oLhbVVvZN3i8b1ryEcCrKw-1; Wed,
 08 Jun 2022 15:07:28 -0400
X-MC-Unique: oLhbVVvZN3i8b1ryEcCrKw-1
Received: from
 linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
 (linux.microsoft.com [13.77.154.182])
 by linux.microsoft.com (Postfix) with ESMTPSA id B9A3F20BE675;
 Wed,  8 Jun 2022 12:01:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B9A3F20BE675
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Wed,  8 Jun 2022 12:01:21 -0700
Message-Id: <1654714889-26728-10-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [RFC PATCH v8 09/17] ipe: introduce 'boot_verified' as a
 trust provider
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-audit@redhat.com, linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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
v2:
  + No Changes

v3:
  + Remove useless caching system
  + Move ipe_load_properties to this match
  + Minor changes from checkpatch --strict warnings

v4:
  + Remove comments from headers that was missed previously.
  + Grammatical corrections.

v5:
  + No significant changes

v6:
  + No changes

v7:
  + Reword and refactor patch 04/12 to [09/16],
    based on changes in the underlying system.
  + Add common audit function for boolean values
  + Use common audit function as implementation.

v8:
  + No changes
---
 security/ipe/Kconfig                 |  2 +
 security/ipe/Makefile                |  1 +
 security/ipe/eval.c                  | 71 ++++++++++++++++++++++++++++
 security/ipe/eval.h                  |  5 ++
 security/ipe/hooks.c                 | 14 ++++++
 security/ipe/hooks.h                 |  2 +
 security/ipe/ipe.c                   |  1 +
 security/ipe/modules.c               | 30 ++++++++++++
 security/ipe/modules/Kconfig         | 20 ++++++++
 security/ipe/modules/Makefile        |  8 ++++
 security/ipe/modules/boot_verified.c | 26 ++++++++++
 security/ipe/modules/ipe_module.h    |  3 ++
 12 files changed, 183 insertions(+)
 create mode 100644 security/ipe/modules/Kconfig
 create mode 100644 security/ipe/modules/Makefile
 create mode 100644 security/ipe/modules/boot_verified.c

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index 1ad2f34b98ec..69345fa49be5 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -69,4 +69,6 @@ config IPE_AUDIT_HASH_ALG
 	default "sha384" if IPE_AUDIT_HASH_SHA384
 	default "sha512" if IPE_AUDIT_HASH_SHA512
 
+source "security/ipe/modules/Kconfig"
+
 endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 25a7d7c8f07c..0d970236efc4 100644
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
index eafa670558e3..ccf9b843040b 100644
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
@@ -40,6 +92,7 @@ static struct ipe_eval_ctx *build_ctx(const struct file *file,
 	ctx->file = file;
 	ctx->op = op;
 	ctx->ci_ctx = ipe_current_ctx();
+	ctx->from_init_sb = from_pinned(file);
 
 	return ctx;
 }
@@ -148,6 +201,9 @@ int ipe_process_event(const struct file *file, enum ipe_operation op)
 	int rc = 0;
 	struct ipe_eval_ctx *ctx = NULL;
 
+	if (op == ipe_operation_exec)
+		pin_sb(file);
+
 	ctx = build_ctx(file, op);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
@@ -157,3 +213,18 @@ int ipe_process_event(const struct file *file, enum ipe_operation op)
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
index 50bc16b0be25..f195671eaa8f 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -7,6 +7,7 @@
 #define IPE_EVAL_H
 
 #include <linux/file.h>
+#include <linux/types.h>
 
 #include "ctx.h"
 #include "hooks.h"
@@ -17,6 +18,8 @@ struct ipe_eval_ctx {
 
 	const struct file *file;
 	struct ipe_context *ci_ctx;
+
+	bool from_init_sb;
 };
 
 enum ipe_match {
@@ -28,4 +31,6 @@ enum ipe_match {
 
 int ipe_process_event(const struct file *file, enum ipe_operation op);
 
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
+
 #endif /* IPE_EVAL_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index d20de25bbd40..4dc7b0c0fd31 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -202,3 +202,17 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
 	WARN(op == ipe_operation_max, "no rule setup for enum %d", id);
 	return ipe_process_event(NULL, op);
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
index fa9e0657bd64..43d5b2fe67fd 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -29,4 +29,6 @@ int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
 
 int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
+void ipe_sb_free_security(struct super_block *mnt_sb);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index fca7019ca53c..d52ad248dfd3 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -32,6 +32,7 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
 	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
 	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
+	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 };
 
 /**
diff --git a/security/ipe/modules.c b/security/ipe/modules.c
index fb100c14cce5..30346f7ad35c 100644
--- a/security/ipe/modules.c
+++ b/security/ipe/modules.c
@@ -107,3 +107,33 @@ int ipe_register_module(struct ipe_module *m)
 
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
+
+void ipe_bool_audit(struct audit_buffer *ab, const void *val)
+{
+	audit_log_format(ab, "%s", ((bool)val) ? "TRUE" : "FALSE");
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
index 000000000000..6b12146263af
--- /dev/null
+++ b/security/ipe/modules/boot_verified.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/audit.h>
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
+	.audit = ipe_bool_audit,
+};
diff --git a/security/ipe/modules/ipe_module.h b/security/ipe/modules/ipe_module.h
index 1381ab977da5..5255a57c4784 100644
--- a/security/ipe/modules/ipe_module.h
+++ b/security/ipe/modules/ipe_module.h
@@ -9,6 +9,9 @@
 #include <linux/audit.h>
 #include "../eval.h"
 
+int ipe_bool_parse(const char *valstr, void **value);
+void ipe_bool_audit(struct audit_buffer *ab, const void *val);
+
 /**
  * ipe_module: definition of an extensible module for IPE properties.
  *	       These structures are used to implement 'key=value' pairs
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

