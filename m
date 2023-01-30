Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FA6C38142
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151398;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FYCriEkHzd/nRYIVMxFvgF8wmXZqiNaOKAwIf8eWVGk=;
	b=Ad4zLjvhU+yvlIa9XkglPhPvuZrGww6WVfhFLOHstUQC7qmMdnjtbCkP1eb9B0Elugr6+4
	k58VuzUVVrtFmtXZaTjefgtpI+uIEt+G3Z44HQK7XRq5FQX20D60jUZak7zLEMhPRHHCMj
	GnzxMnOWXM84oOjKxnN2yxXQkIx0Fg0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-EFeKMeD5MCWZfD1NDk7JyQ-1; Tue, 31 Jan 2023 02:49:54 -0500
X-MC-Unique: EFeKMeD5MCWZfD1NDk7JyQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C44B487B2A0;
	Tue, 31 Jan 2023 07:49:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF2FC492C3E;
	Tue, 31 Jan 2023 07:49:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D6671946589;
	Tue, 31 Jan 2023 07:49:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 085AC1946589
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 23:06:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DFE82175AD; Mon, 30 Jan 2023 23:06:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7853422AE
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3EF81871D9D
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:39 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-532-G1Y6yvT8MHq2nWLP6LKZpQ-1; Mon,
 30 Jan 2023 18:06:38 -0500
X-MC-Unique: G1Y6yvT8MHq2nWLP6LKZpQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 83E8520EA205; Mon, 30 Jan 2023 14:58:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 83E8520EA205
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Mon, 30 Jan 2023 14:57:26 -0800
Message-Id: <1675119451-23180-12-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:16 +0000
Subject: [dm-devel] [RFC PATCH v9 11/16] ipe: add support for dm-verity as a
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
Cc: Fan Wu <wufan@linux.microsoft.com>, dm-devel@redhat.com,
 linux-doc@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>,
 roberto.sassu@huawei.com, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
 linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

Allows author of IPE policy to indicate trust for a singular dm-verity
volume, identified by roothash, through "dmverity_roothash" and all
signed dm-verity volumes, through "dmverity_signature".

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
---
v2:
  + No Changes

v3:
  + No changes

v4:
  + No changes

v5:
  + No changes

v6:
  + Fix an improper cleanup that can result in
    a leak

v7:
  + Squash patch 08/12, 10/12 to [11/16]

v8:
  + Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
    & block/
  + Use common-audit function for dmverity_signature.
  + Change implementation for storing the dm-verity digest to use the
    newly introduced dm_verity_digest structure introduced in patch
    14/20.

v9:
  + Adapt to the new parser
---
 security/ipe/Kconfig         |  20 +++++
 security/ipe/Makefile        |   2 +
 security/ipe/audit.c         |  24 ++++++
 security/ipe/digest.c        | 144 +++++++++++++++++++++++++++++++++++
 security/ipe/digest.h        |  26 +++++++
 security/ipe/eval.c          | 103 +++++++++++++++++++++++++
 security/ipe/eval.h          |  13 ++++
 security/ipe/hooks.c         |  51 +++++++++++++
 security/ipe/hooks.h         |   8 ++
 security/ipe/ipe.c           |  15 ++++
 security/ipe/ipe.h           |   4 +
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |  16 ++++
 13 files changed, 429 insertions(+)
 create mode 100644 security/ipe/digest.c
 create mode 100644 security/ipe/digest.h

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index ac4d558e69d5..16e835ce61b0 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -15,3 +15,23 @@ menuconfig SECURITY_IPE
 	  admins to reconfigure trust requirements on the fly.
 
 	  If unsure, answer N.
+
+if SECURITY_IPE
+menu "IPE Trust Providers"
+
+config IPE_PROP_DM_VERITY
+	bool "Enable support for dm-verity volumes"
+	depends on DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
+	default Y
+	help
+	  This option enables the properties 'dmverity_signature' and
+	  'dmverity_roothash' in IPE policy. These properties evaluates
+	  to TRUE when a file is evaluated against a dm-verity volume
+	  that was mounted with a signed root-hash or the volume's
+	  root hash matches the supplied value in the policy.
+
+	  If unsure, answer Y.
+
+endmenu
+
+endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 89a76ad72301..90203daf0dbb 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -6,6 +6,7 @@
 #
 
 obj-$(CONFIG_SECURITY_IPE) += \
+	digest.o \
 	eval.o \
 	fs.o \
 	hooks.o \
@@ -13,4 +14,5 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	policy.o \
 	policy_fs.o \
 	policy_parser.o \
+	digest.o \
 	audit.o \
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index ff74026a595f..769ba95d9b0d 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -41,8 +41,29 @@ static const char *const audit_op_names[ipe_op_max] = {
 static const char *const audit_prop_names[ipe_prop_max] = {
 	"boot_verified=FALSE",
 	"boot_verified=TRUE",
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	"dmverity_roothash=",
+	"dmverity_signature=FALSE",
+	"dmverity_signature=TRUE",
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * audit_dmv_roothash - audit a roothash of a dmverity volume.
+ * @ab: Supplies a poniter to the audit_buffer to append to.
+ * @r: Supplies a pointer to the digest structure.
+ */
+static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
+{
+	ipe_digest_audit(ab, rh);
+}
+#else
+static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
+{
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /**
  * audit_rule - audit an IPE policy rule approximation.
  * @ab: Supplies a poniter to the audit_buffer to append to.
@@ -56,6 +77,9 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
 
 	list_for_each_entry(ptr, &r->props, next) {
 		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
+		if (ptr->type == ipe_prop_dmv_roothash)
+			audit_dmv_roothash(ab, ptr->value);
+
 		audit_log_format(ab, " ");
 	}
 
diff --git a/security/ipe/digest.c b/security/ipe/digest.c
new file mode 100644
index 000000000000..9fdb091f329b
--- /dev/null
+++ b/security/ipe/digest.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "digest.h"
+
+/**
+ * ipe_digest_parse - parse a digest in IPE's policy.
+ * @valstr: Supplies the string parsed from the policy.
+ * @value: Supplies a pointer to be populated with the result.
+ *
+ * Digests in IPE are defined in a standard way:
+ *	<alg_name>:<hex>
+ *
+ * Use this function to create a property to parse the digest
+ * consistently. The parsed digest will be saved in @value in IPE's
+ * policy.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
+ */
+int ipe_digest_parse(const char *valstr, void **value)
+{
+	char *sep, *raw_digest;
+	size_t raw_digest_len;
+	int rc = 0;
+	u8 *digest = NULL;
+	struct digest_info *info = NULL;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	sep = strchr(valstr, ':');
+	if (!sep) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	info->alg = kstrndup(valstr, sep - valstr, GFP_KERNEL);
+	if (!info->alg) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	raw_digest = sep + 1;
+	raw_digest_len = strlen(raw_digest);
+	info->raw_digest = kstrndup(raw_digest, raw_digest_len, GFP_KERNEL);
+	if (!info->raw_digest) {
+		rc = -ENOMEM;
+		goto err_free_alg;
+	}
+
+	info->digest_len = (raw_digest_len + 1) / 2;
+	digest = kzalloc(info->digest_len, GFP_KERNEL);
+	if (!digest) {
+		rc = -ENOMEM;
+		goto err_free_raw;
+	}
+
+	rc = hex2bin(digest, raw_digest, info->digest_len);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_free_raw;
+	}
+
+	info->digest = digest;
+	*value = info;
+	return 0;
+
+err_free_raw:
+	kfree(info->raw_digest);
+err_free_alg:
+	kfree(info->alg);
+err:
+	kfree(digest);
+	kfree(info);
+	return rc;
+}
+
+/**
+ * ipe_digest_eval - evaluate an IPE digest against another digest.
+ * @expect: Supplies the policy-provided digest value.
+ * @digest: Supplies the digest to compare against the policy digest value.
+ * @digest_len: The length of @digest.
+ * @alg: Supplies the name of the algorithm used to calculated @digest.
+ *
+ * Return:
+ * * true	- digests match
+ * * false	- digests do not match
+ */
+bool ipe_digest_eval(const void *expect, const u8 *digest, size_t digest_len,
+		     const char *alg)
+{
+	const struct digest_info *info = (struct digest_info *)expect;
+
+	return (digest_len == info->digest_len) && !strcmp(alg, info->alg) &&
+	       (!memcmp(info->digest, digest, info->digest_len));
+}
+
+/**
+ * ipe_digest_free - free an IPE digest.
+ * @value: Supplies a pointer the policy-provided digest value to free.
+ */
+void ipe_digest_free(void **value)
+{
+	struct digest_info *info = (struct digest_info *)(*value);
+
+	if (IS_ERR_OR_NULL(info))
+		return;
+
+	kfree(info->alg);
+	kfree(info->raw_digest);
+	kfree(info->digest);
+	kfree(info);
+}
+
+/**
+ * ipe_digest_audit - audit a digest that was sourced from IPE's policy.
+ * @ab: Supplies the audit_buffer to append the formatted result.
+ * @val: Supplies a pointer to source the audit record from.
+ *
+ * Digests in IPE are defined in a standard way:
+ *	<alg_name>:<hex>
+ *
+ * Use this function to create a property to audit the digest
+ * consistently.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+void ipe_digest_audit(struct audit_buffer *ab, const void *val)
+{
+	const struct digest_info *info = (struct digest_info *)val;
+
+	audit_log_untrustedstring(ab, info->alg);
+	audit_log_format(ab, ":");
+	audit_log_untrustedstring(ab, info->raw_digest);
+}
diff --git a/security/ipe/digest.h b/security/ipe/digest.h
new file mode 100644
index 000000000000..42f7a0f28e45
--- /dev/null
+++ b/security/ipe/digest.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef DIGEST_H
+#define DIGEST_H
+
+#include "policy.h"
+#include <linux/types.h>
+#include <linux/audit.h>
+
+struct digest_info {
+	const char	*alg;
+	const char	*raw_digest;
+	const u8	*digest;
+	size_t		digest_len;
+};
+
+int ipe_digest_parse(const char *valstr, void **value);
+void ipe_digest_free(void **value);
+void ipe_digest_audit(struct audit_buffer *ab, const void *val);
+bool ipe_digest_eval(const void *expect, const u8 *digest, size_t digest_len,
+		     const char *alg);
+
+#endif /* DIGEST_H */
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 499314554b1d..538af4195ba7 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -8,6 +8,7 @@
 #include "hooks.h"
 #include "policy.h"
 #include "audit.h"
+#include "digest.h"
 
 #include <linux/fs.h>
 #include <linux/types.h>
@@ -21,6 +22,7 @@
 struct ipe_policy __rcu *ipe_active_policy;
 bool success_audit;
 bool enforce = true;
+#define INO_BLOCK_DEV(ino) ((ino)->i_sb->s_bdev)
 
 static struct super_block *pinned_sb;
 static DEFINE_SPINLOCK(pin_lock);
@@ -62,6 +64,23 @@ static bool from_pinned(const struct file *f)
 	return rv;
 }
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * build_ipe_bdev_ctx - Build ipe_bdev field of an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populdated.
+ * @ino: Supplies the inode struct of the file triggered IPE event.
+ */
+static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+	if (INO_BLOCK_DEV(ino))
+		ctx->ipe_bdev = ipe_bdev(INO_BLOCK_DEV(ino));
+}
+#else
+static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /**
  * build_eval_ctx - Build an evaluation context.
  * @ctx: Supplies a pointer to the context to be populdated.
@@ -72,11 +91,86 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 		    const struct file *file,
 		    enum ipe_op_type op)
 {
+	struct inode *ino = NULL;
+
 	ctx->file = file;
 	ctx->op = op;
 	ctx->from_init_sb = from_pinned(file);
+	if (file) {
+		ino = d_real_inode(file->f_path.dentry);
+		build_ipe_bdev_ctx(ctx, ino);
+	}
+}
+
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * evaluate_dmv_roothash - Evaluate @ctx against a dmv roothash property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return !!ctx->ipe_bdev &&
+	       ipe_digest_eval(p->value,
+			       ctx->ipe_bdev->digest,
+			       ctx->ipe_bdev->digest_len,
+			       ctx->ipe_bdev->digest_algo);
+}
+
+/**
+ * evaluate_dmv_sig_false: Analyze @ctx against a dmv sig false property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_dmv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
+{
+	return !ctx->ipe_bdev || (!ctx->ipe_bdev->dm_verity_signed);
+}
+
+/**
+ * evaluate_dmv_sig_true: Analyze @ctx against a dmv sig true property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return ctx->ipe_bdev && (!!ctx->ipe_bdev->dm_verity_signed);
+}
+#else
+static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_dmv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
+{
+	return false;
 }
 
+static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return false;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /**
  * evaluate_property - Analyze @ctx against a property.
  * @ctx: Supplies a pointer to the context to be evaluated.
@@ -98,6 +192,15 @@ static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 	case ipe_prop_boot_verified_true:
 		eval = ctx->from_init_sb;
 		break;
+	case ipe_prop_dmv_roothash:
+		eval = evaluate_dmv_roothash(ctx, p);
+		break;
+	case ipe_prop_dmv_sig_false:
+		eval = evaluate_dmv_sig_false(ctx, p);
+		break;
+	case ipe_prop_dmv_sig_true:
+		eval = evaluate_dmv_sig_true(ctx, p);
+		break;
 	default:
 		eval = false;
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 64369c3b8cf9..4fd832c6893e 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -16,11 +16,24 @@ extern struct ipe_policy __rcu *ipe_active_policy;
 extern bool success_audit;
 extern bool enforce;
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev {
+	bool dm_verity_signed;
+
+	const u8       *digest;
+	size_t		digest_len;
+	const char     *digest_algo;
+};
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
 
 	const struct file *file;
 	bool from_init_sb;
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	const struct ipe_bdev *ipe_bdev;
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
 enum ipe_match {
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index fd5109e29c76..735375d2f858 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -11,6 +11,9 @@
 #include <linux/types.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
+#include <linux/blk_types.h>
+#include <linux/dm-verity.h>
+#include <crypto/hash_info.h>
 
 /**
  * ipe_sb_free_security - ipe security hook function for super_block.
@@ -192,3 +195,51 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
 	build_eval_ctx(&ctx, NULL, op);
 	return ipe_evaluate_event(&ctx);
 }
+
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * ipe_bdev_free_security - free IPE's LSM blob of block_devices.
+ * @bdev: Supplies a pointer to a block_device that contains the structure
+ *	  to free.
+ */
+void ipe_bdev_free_security(struct block_device *bdev)
+{
+	struct ipe_bdev *blob = ipe_bdev(bdev);
+
+	kfree(blob->digest);
+	kfree(blob->digest_algo);
+}
+
+/**
+ * ipe_bdev_setsecurity - save data from a bdev to IPE's LSM blob.
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
+	if (!strcmp(key, DM_VERITY_ROOTHASH_SEC_NAME)) {
+		const struct dm_verity_digest *digest = value;
+
+		blob->digest = kmemdup(digest->digest, digest->digest_len, GFP_KERNEL);
+		if (!blob->digest)
+			return -ENOMEM;
+
+		blob->digest_algo = kstrdup_const(digest->algo, GFP_KERNEL);
+		if (!blob->digest_algo)
+			return -ENOMEM;
+
+		blob->digest_len = digest->digest_len;
+		return 0;
+	} else if (!strcmp(key, DM_VERITY_SIGNATURE_SEC_NAME)) {
+		blob->dm_verity_signed = true;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 857cae69678c..16611a149158 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/device-mapper.h>
 
 void ipe_sb_free_security(struct super_block *mnt_sb);
 
@@ -24,4 +25,11 @@ int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
 
 int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+void ipe_bdev_free_security(struct block_device *bdev);
+
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len);
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 7af2f942decd..5612cb3cf1e5 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -5,12 +5,23 @@
 
 #include "ipe.h"
 #include "hooks.h"
+#include "eval.h"
 
 bool ipe_enabled;
 
 static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+		.lbs_bdev = sizeof(struct ipe_bdev),
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev *ipe_bdev(struct block_device *b)
+{
+	return b->security + ipe_blobs.lbs_bdev;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
@@ -18,6 +29,10 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
 	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
 	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
+	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
+#endif
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index 43cc132ed048..c2594a45b8f2 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -12,4 +12,8 @@
 
 extern bool ipe_enabled;
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev *ipe_bdev(struct block_device *b);
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 #endif /* IPE_H */
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 0cb42b6f246e..324eb76c6067 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -28,6 +28,9 @@ enum ipe_action_type {
 enum ipe_prop_type {
 	ipe_prop_boot_verified_false,
 	ipe_prop_boot_verified_true,
+	ipe_prop_dmv_roothash,
+	ipe_prop_dmv_sig_false,
+	ipe_prop_dmv_sig_true,
 	ipe_prop_max
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index 7efafc482e46..50a6a763e842 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -215,6 +215,7 @@ static void free_rule(struct ipe_rule *r)
 		return;
 
 	list_for_each_entry_safe(p, t, &r->props, next) {
+		ipe_digest_free(&p->value);
 		kfree(p);
 	}
 
@@ -267,6 +268,11 @@ static enum ipe_action_type parse_action(char *t)
 static const match_table_t property_tokens = {
 	{ipe_prop_boot_verified_false,	"boot_verified=FALSE"},
 	{ipe_prop_boot_verified_true,	"boot_verified=TRUE"},
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	{ipe_prop_dmv_roothash,		"dmverity_roothash=%s"},
+	{ipe_prop_dmv_sig_false,	"dmverity_signature=FALSE"},
+	{ipe_prop_dmv_sig_true,		"dmverity_signature=TRUE"},
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 	{ipe_prop_max,			NULL}
 };
 
@@ -297,8 +303,18 @@ int parse_property(char *t, struct ipe_rule *r)
 	token = match_token(t, property_tokens, args);
 
 	switch (token) {
+	case ipe_prop_dmv_roothash:
+		dup = match_strdup(&args[0]);
+		if (!dup) {
+			rc = -ENOMEM;
+			goto err;
+		}
+		rc = ipe_digest_parse(dup, &p->value);
+		fallthrough;
 	case ipe_prop_boot_verified_false:
 	case ipe_prop_boot_verified_true:
+	case ipe_prop_dmv_sig_false:
+	case ipe_prop_dmv_sig_true:
 		p->type = token;
 		break;
 	case ipe_prop_max:
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

