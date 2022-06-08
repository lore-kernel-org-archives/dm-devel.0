Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875B2C43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 19:07:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-Udxysoa6Puu413xUV9Tm7g-1; Wed, 08 Jun 2022 15:07:35 -0400
X-MC-Unique: Udxysoa6Puu413xUV9Tm7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C939518A6522;
	Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B23D32026D64;
	Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59E3D194705B;
	Wed,  8 Jun 2022 19:07:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE485194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E8BC1415102; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AD5F1415100
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F30C3C0F720
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:30 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-637-XztqD4BAMzemGZb78_ePFg-1; Wed,
 08 Jun 2022 15:07:27 -0400
X-MC-Unique: XztqD4BAMzemGZb78_ePFg-1
Received: from
 linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
 (linux.microsoft.com [13.77.154.182])
 by linux.microsoft.com (Postfix) with ESMTPSA id 4E5E020BE67D;
 Wed,  8 Jun 2022 12:01:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4E5E020BE67D
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Wed,  8 Jun 2022 12:01:26 -0700
Message-Id: <1654714889-26728-15-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [RFC PATCH v8 14/17] ipe: enable support for fs-verity
 as a trust provider
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Fan Wu <wufan@linux.microsoft.com>

Enable IPE policy authors to indicate trust for a singular fsverity
file, identified by the digest information, through "fsverity_digest"
and all files using fsverity's builtin signatures via
"fsverity_signature".

This enables file-level integrity claims to be expressed in IPE,
allowing individual files to be authorized, giving some flexibility
for policy authors. Such file-level claims are important to be expressed
for enforcing the integrity of packages, as well as address some of the
scalability issues in a sole dm-verity based solution (# of loop back
devices, etc).

This solution cannot be done in userspace as the minimum threat that
IPE should mitigate is an attacker downloads malicious payload with
all required dependencies. These dependencies can lack the userspace
check, bypassing the protection entirely. A similar attack succeeds if
the userspace component is replaced with a version that does not
perform the check. As a result, this can only be done in the common
entry point - the kernel.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
v1-v6:
  + Not present

v7:
  Introduced

v8:
  * Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
  * Use common-audit function for fsverity_signature.
  + Change fsverity implementation to use fsverity_get_digest
  + prevent unnecessary copy of fs-verity signature data, instead
    just check for presence of signature data.
  + Remove free_inode_security hook, as the digest is now acquired
    at runtime instead of via LSM blob.
---
 security/ipe/eval.c                       |  1 +
 security/ipe/eval.h                       |  5 +++
 security/ipe/hooks.c                      | 29 +++++++++++++++++
 security/ipe/hooks.h                      |  5 +++
 security/ipe/ipe.c                        |  7 ++++
 security/ipe/ipe.h                        |  1 +
 security/ipe/modules/Kconfig              | 23 +++++++++++++
 security/ipe/modules/Makefile             |  2 ++
 security/ipe/modules/fsverity_digest.c    | 39 +++++++++++++++++++++++
 security/ipe/modules/fsverity_signature.c | 34 ++++++++++++++++++++
 10 files changed, 146 insertions(+)
 create mode 100644 security/ipe/modules/fsverity_digest.c
 create mode 100644 security/ipe/modules/fsverity_signature.c

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 9b29d83cd466..e8205a6fce44 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -95,6 +95,7 @@ static struct ipe_eval_ctx *build_ctx(const struct file *file,
 	ctx->ci_ctx = ipe_current_ctx();
 	ctx->from_init_sb = from_pinned(file);
 	if (file) {
+		ctx->ipe_inode = ipe_inode(file->f_inode);
 		if (FILE_BLOCK_DEV(file))
 			ctx->ipe_bdev = ipe_bdev(FILE_BLOCK_DEV(file));
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 57b7b2b424f8..541251125e8e 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -22,6 +22,10 @@ struct ipe_bdev {
 	const char     *digest_algo;
 };
 
+struct ipe_inode {
+	bool fs_verity_signed;
+};
+
 struct ipe_eval_ctx {
 	enum ipe_operation op;
 
@@ -29,6 +33,7 @@ struct ipe_eval_ctx {
 	struct ipe_context *ci_ctx;
 
 	const struct ipe_bdev *ipe_bdev;
+	const struct ipe_inode *ipe_inode;
 
 	bool from_init_sb;
 };
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 1072ee5bb8f6..7c99afad4924 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -267,3 +267,32 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 
 	return -EOPNOTSUPP;
 }
+
+/**
+ * ipe_inode_setsecurity: Sets the a certain field of a inode security
+ *			 blob, based on @key.
+ * @inode: The inode to source the security blob from.
+ * @name: The name representing the information to be stored.
+ * @value: The value to be stored.
+ * @size: The size of @value.
+ * @flags: unused
+ *
+ * Saves fsverity signature & digest into inode security blob
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_inode_setsecurity(struct inode *inode, const char *name,
+			  const void *value, size_t size,
+			  int flags)
+{
+	struct ipe_inode *inode_sec = ipe_inode(inode);
+
+	if (!strcmp(name, FS_VERITY_INODE_SEC_NAME)) {
+		inode_sec->fs_verity_signed = size > 0 && value;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 0d1589e47f8f..1edcc91d6d33 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/fsverity.h>
 #include <linux/device-mapper.h>
 
 int ipe_task_alloc(struct task_struct *task,
@@ -37,4 +38,8 @@ void ipe_bdev_free_security(struct block_device *bdev);
 int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 			 const void *value, size_t len);
 
+int ipe_inode_setsecurity(struct inode *inode, const char *name,
+			  const void *value, size_t size,
+			  int flags);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 398014ac6004..caf0ebf8381a 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -24,6 +24,7 @@ bool ipe_enabled;
 static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 	.lbs_task = sizeof(struct ipe_context __rcu *),
 	.lbs_bdev = sizeof(struct ipe_bdev),
+	.lbs_inode = sizeof(struct ipe_inode),
 };
 
 struct ipe_bdev *ipe_bdev(struct block_device *b)
@@ -31,6 +32,11 @@ struct ipe_bdev *ipe_bdev(struct block_device *b)
 	return b->security + ipe_blobs.lbs_bdev;
 }
 
+struct ipe_inode *ipe_inode(const struct inode *inode)
+{
+	return inode->i_security + ipe_blobs.lbs_inode;
+}
+
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
 	LSM_HOOK_INIT(task_free, ipe_task_free),
@@ -42,6 +48,7 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
 	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
+	LSM_HOOK_INIT(inode_setsecurity, ipe_inode_setsecurity),
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index df2b56d8b5e9..cd7e5c1bb343 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -23,5 +23,6 @@ extern struct ipe_parser __start_ipe_parsers[], __end_ipe_parsers[];
 extern struct ipe_module __start_ipe_modules[], __end_ipe_modules[];
 
 struct ipe_bdev *ipe_bdev(struct block_device *b);
+struct ipe_inode *ipe_inode(const struct inode *inode);
 
 #endif /* IPE_H */
diff --git a/security/ipe/modules/Kconfig b/security/ipe/modules/Kconfig
index a6ea06cf0737..8f823a1edf96 100644
--- a/security/ipe/modules/Kconfig
+++ b/security/ipe/modules/Kconfig
@@ -40,4 +40,27 @@ config IPE_PROP_DM_VERITY_ROOTHASH
 
 	  If unsure, answer Y.
 
+config IPE_PROP_FS_VERITY_SIGNATURE
+	bool "Enable property for signed fs-verity files"
+	depends on FS_VERITY_BUILTIN_SIGNATURES
+	help
+	  This option enables IPE's integration with FSVerity's
+	  signed hashes. This enables the usage of the property,
+	  "fsverity_signature" in IPE's policy.
+
+	  if unsure, answer Y.
+
+config IPE_PROP_FS_VERITY_DIGEST
+	bool "Enable property for authorizing fs-verity files via digest"
+	depends on FS_VERITY
+	help
+	  This option enables IPE's integration with FSVerity.
+	  This enables the usage of the property "fsverity_digest" in IPE's
+	  policy. This property allows authorization or revocation via a
+	  a hex-string representing the digest of a fsverity file.
+
+	  if unsure, answer Y.
+
+
+
 endmenu
diff --git a/security/ipe/modules/Makefile b/security/ipe/modules/Makefile
index 84fadce85193..890440b9050f 100644
--- a/security/ipe/modules/Makefile
+++ b/security/ipe/modules/Makefile
@@ -8,3 +8,5 @@
 obj-$(CONFIG_IPE_PROP_BOOT_VERIFIED) += boot_verified.o
 obj-$(CONFIG_IPE_PROP_DM_VERITY_SIGNATURE) += dmverity_signature.o
 obj-$(CONFIG_IPE_PROP_DM_VERITY_ROOTHASH) += dmverity_roothash.o
+obj-$(CONFIG_IPE_PROP_FS_VERITY_SIGNATURE) += fsverity_signature.o
+obj-$(CONFIG_IPE_PROP_FS_VERITY_DIGEST) += fsverity_digest.o
diff --git a/security/ipe/modules/fsverity_digest.c b/security/ipe/modules/fsverity_digest.c
new file mode 100644
index 000000000000..c3e7998393f5
--- /dev/null
+++ b/security/ipe/modules/fsverity_digest.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/fsverity.h>
+#include <crypto/hash_info.h>
+
+static bool evaluate(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	enum hash_algo alg;
+	u8 digest[FS_VERITY_MAX_DIGEST_SIZE];
+	struct inode *ino;
+
+	if (!ctx->file)
+		return false;
+
+	ino = file_inode(ctx->file);
+	if (!ino)
+		return false;
+
+	if (fsverity_get_digest(ino, digest, &alg))
+		return false;
+
+	return ipe_digest_eval(val, digest, hash_digest_size[alg], hash_algo_name[alg]);
+}
+
+IPE_MODULE(fsv_digest) = {
+	.name = "fsverity_digest",
+	.version = 1,
+	.parse = ipe_digest_parse,
+	.free = ipe_digest_free,
+	.eval = evaluate,
+	.audit = ipe_digest_audit,
+};
diff --git a/security/ipe/modules/fsverity_signature.c b/security/ipe/modules/fsverity_signature.c
new file mode 100644
index 000000000000..26442af0a2ba
--- /dev/null
+++ b/security/ipe/modules/fsverity_signature.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/audit.h>
+#include <linux/mount.h>
+
+static bool evaluate(const struct ipe_eval_ctx *ctx, const void *value)
+{
+	bool expect = (bool)value;
+
+	if (!ctx->file || !IS_VERITY(ctx->file->f_inode))
+		return false;
+
+	if (!ctx->ipe_inode)
+		return false;
+
+	return (!!ctx->ipe_inode->fs_verity_signed) == expect;
+}
+
+IPE_MODULE(fsvs) = {
+	.name = "fsverity_signature",
+	.version = 1,
+	.parse = ipe_bool_parse,
+	.free = NULL,
+	.eval = evaluate,
+	.audit = ipe_bool_audit,
+};
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

