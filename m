Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4052BC636CC
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151298;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6DBEJvUQvEFqCrTKAdRxCvYz/u7KqowpeCD3GccPb0M=;
	b=C4EwOCdbei/L+IvFlMAXX+iXOAW8aaiTOnCW82y8/k26ZZDiD6YfIpHiR7K1P5izCxNuAr
	v2fhUDMFHzzGblt4a7ONhXdjNMP7EU48Tma8gW7tGS2nsQoc9+dpKb7TrBOX+XAF4VH54y
	v/vZ5jqqSYOe0MxuajYtQ3+scJnCDTQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-ATXOTuZiOKe_77DDPIXDUg-1; Tue, 31 Jan 2023 02:48:14 -0500
X-MC-Unique: ATXOTuZiOKe_77DDPIXDUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22FDF800B30;
	Tue, 31 Jan 2023 07:48:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0E7212166B36;
	Tue, 31 Jan 2023 07:48:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E42E91946589;
	Tue, 31 Jan 2023 07:48:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB4A719465A3
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1DE52026D76; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99D712026D68
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63E8E87B2A0
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-338-4D8hyDwbNF2tRJLSWb8etg-1; Mon,
 30 Jan 2023 18:06:37 -0500
X-MC-Unique: 4D8hyDwbNF2tRJLSWb8etg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 1685920EA1E6; Mon, 30 Jan 2023 14:58:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1685920EA1E6
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Mon, 30 Jan 2023 14:57:18 -0800
Message-Id: <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:17 +0000
Subject: [dm-devel] [RFC PATCH v9 03/16] ipe: add evaluation loop and
 introduce 'boot_verified' as a trust provider
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE must have a centralized function to evaluate incoming callers
against IPE's policy. This iteration of the policy against the rules
for that specific caller is known as the evaluation loop.

In addition, IPE is designed to provide system level trust guarantees,
this usually implies that trust starts from bootup with a hardware root
of trust, which validates the bootloader. After this, the bootloader
verifies the kernel and the initramfs.

As there's no currently supported integrity method for initramfs, and
it's typically already verified by the bootloader, introduce a property
that causes the first superblock to have an execution to be "pinned",
which is typically initramfs.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
  + Split evaluation loop, access control hooks,
    and evaluation loop from policy parser and userspace
    interface to pass mailing list character limit

v3:
  + Move ipe_load_properties to patch 04.
  + Remove useless 0-initializations
  + Prefix extern variables with ipe_
  + Remove kernel module parameters, as these are
    exposed through sysctls.
  + Add more prose to the IPE base config option
    help text.
  + Use GFP_KERNEL for audit_log_start.
  + Remove unnecessary caching system.
  + Remove comments from headers
  + Use rcu_access_pointer for rcu-pointer null check
  + Remove usage of reqprot; use prot only.
  + Move policy load and activation audit event to 03/12

v4:
  + Remove sysctls in favor of securityfs nodes
  + Re-add kernel module parameters, as these are now
    exposed through securityfs.
  + Refactor property audit loop to a separate function.

v5:
  + fix minor grammatical errors
  + do not group rule by curly-brace in audit record,
    reconstruct the exact rule.

v6:
  + No changes

v7:
  + Further split lsm creation into a separate commit from the
    evaluation loop and audit system, for easier review.

  + Propogating changes to support the new ipe_context structure in the
    evaluation loop.

v8:
  + Remove ipe_hook enumeration; hooks can be correlated via syscall
    record.

v9:
  + Remove ipe_context related code and simplify the evaluation loop.
  + Merge the evaluation loop commit with the boot_verified commit.
---
 security/ipe/Makefile        |   1 +
 security/ipe/eval.c          | 180 +++++++++++++++++++++++++++++++++++
 security/ipe/eval.h          |  28 ++++++
 security/ipe/hooks.c         |  25 +++++
 security/ipe/hooks.h         |  14 +++
 security/ipe/ipe.c           |   1 +
 security/ipe/policy.c        |  20 ++++
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |   8 +-
 9 files changed, 279 insertions(+), 1 deletion(-)
 create mode 100644 security/ipe/eval.c
 create mode 100644 security/ipe/eval.h
 create mode 100644 security/ipe/hooks.c
 create mode 100644 security/ipe/hooks.h

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 16bbe80991f1..d7f2870d7c09 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -6,6 +6,7 @@
 #
 
 obj-$(CONFIG_SECURITY_IPE) += \
+	eval.o \
 	hooks.o \
 	ipe.o \
 	policy.o \
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
new file mode 100644
index 000000000000..48b5104a3463
--- /dev/null
+++ b/security/ipe/eval.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "eval.h"
+#include "hooks.h"
+#include "policy.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+
+struct ipe_policy __rcu *ipe_active_policy;
+
+static struct super_block *pinned_sb;
+static DEFINE_SPINLOCK(pin_lock);
+#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+
+/**
+ * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
+ * @f: Supplies a file structure to source the super_block from.
+ */
+static void pin_sb(const struct file *f)
+{
+	if (!f)
+		return;
+	spin_lock(&pin_lock);
+	if (pinned_sb)
+		goto out;
+	pinned_sb = FILE_SUPERBLOCK(f);
+out:
+	spin_unlock(&pin_lock);
+}
+
+/**
+ * from_pinned - Determine whether @f is source from the pinned super_block.
+ * @f: Supplies a file structure to check against the pinned super_block.
+ *
+ * Return:
+ * * true	- @f is sourced from the pinned super_block
+ * * false	- @f is not sourced from the pinned super_block
+ */
+static bool from_pinned(const struct file *f)
+{
+	bool rv;
+
+	if (!f)
+		return false;
+	spin_lock(&pin_lock);
+	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == FILE_SUPERBLOCK(f);
+	spin_unlock(&pin_lock);
+	return rv;
+}
+
+/**
+ * build_eval_ctx - Build an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populdated.
+ * @file: Supplies a pointer to the file to associated with the evaluation.
+ * @op: Supplies the IPE policy operation associated with the evaluation.
+ */
+void build_eval_ctx(struct ipe_eval_ctx *ctx,
+		    const struct file *file,
+		    enum ipe_op_type op)
+{
+	ctx->file = file;
+	ctx->op = op;
+	ctx->from_init_sb = from_pinned(file);
+}
+
+/**
+ * evaluate_property - Analyze @ctx against a property.
+ * @ctx: Supplies a pointer to the context to be evaluated.
+ * @p: Supplies a pointer to the property to be evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
+			      struct ipe_prop *p)
+{
+	bool eval = false;
+
+	switch (p->type) {
+	case ipe_prop_boot_verified_false:
+		eval = !ctx->from_init_sb;
+		break;
+	case ipe_prop_boot_verified_true:
+		eval = ctx->from_init_sb;
+		break;
+	default:
+		eval = false;
+	}
+
+	return eval;
+}
+
+/**
+ * ipe_evaluate_event - Analyze @ctx against the current active policy.
+ * @ctx: Supplies a pointer to the context to be evaluated.
+ *
+ * This is the loop where all policy evaluation happens against IPE policy.
+ *
+ * Return:
+ * * 0		- OK
+ * * -EACCES	- @ctx did not pass evaluation.
+ * * !0		- Error
+ */
+int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
+{
+	int rc = 0;
+	bool match = false;
+	enum ipe_action_type action;
+	struct ipe_policy *pol = NULL;
+	const struct ipe_rule *rule = NULL;
+	const struct ipe_op_table *rules = NULL;
+	struct ipe_prop *prop = NULL;
+
+	if (ctx->op == ipe_op_exec)
+		pin_sb(ctx->file);
+
+	pol = ipe_get_policy_rcu(ipe_active_policy);
+	if (!pol)
+		goto out;
+
+	if (ctx->op == ipe_op_max) {
+		action = pol->parsed->global_default_action;
+		goto eval;
+	}
+
+	rules = &pol->parsed->rules[ctx->op];
+
+	list_for_each_entry(rule, &rules->rules, next) {
+		match = true;
+
+		list_for_each_entry(prop, &rule->props, next)
+			match = match && evaluate_property(ctx, prop);
+
+		if (match)
+			break;
+	}
+
+	if (match)
+		action = rule->action;
+	else if (rules->default_action != ipe_action_max)
+		action = rules->default_action;
+	else
+		action = pol->parsed->global_default_action;
+
+eval:
+	if (action == ipe_action_deny)
+		rc = -EACCES;
+
+out:
+	return rc;
+}
+
+/**
+ * ipe_invalidate_pinned_sb - invalidte the ipe pinned super_block.
+ * @mnt_sb: super_block to check against the pinned super_block.
+ *
+ * This function is called a super_block like the initramfs's is freed,
+ * if the super_block is currently pinned by ipe it will be invalided,
+ * so ipe won't consider the block device is boot verified afterward.
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
new file mode 100644
index 000000000000..887797438b9b
--- /dev/null
+++ b/security/ipe/eval.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_EVAL_H
+#define IPE_EVAL_H
+
+#include <linux/file.h>
+#include <linux/types.h>
+
+#include "hooks.h"
+#include "policy.h"
+
+extern struct ipe_policy __rcu *ipe_active_policy;
+
+struct ipe_eval_ctx {
+	enum ipe_op_type op;
+
+	const struct file *file;
+	bool from_init_sb;
+};
+
+void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
+int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
+
+#endif /* IPE_EVAL_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
new file mode 100644
index 000000000000..335b773c7ae1
--- /dev/null
+++ b/security/ipe/hooks.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "hooks.h"
+#include "eval.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/binfmts.h>
+#include <linux/mman.h>
+
+/**
+ * ipe_sb_free_security - ipe security hook function for super_block.
+ * @mnt_sb: Supplies a pointer to a super_block is about to be freed.
+ *
+ * IPE does not have any structures with mnt_sb, but uses this hook to
+ * invalidate a pinned super_block.
+ */
+void ipe_sb_free_security(struct super_block *mnt_sb)
+{
+	ipe_invalidate_pinned_sb(mnt_sb);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
new file mode 100644
index 000000000000..30fe455389bf
--- /dev/null
+++ b/security/ipe/hooks.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_HOOKS_H
+#define IPE_HOOKS_H
+
+#include <linux/fs.h>
+#include <linux/binfmts.h>
+#include <linux/security.h>
+
+void ipe_sb_free_security(struct super_block *mnt_sb);
+
+#endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 9ed3bf4dcc04..551c6d90ac11 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -9,6 +9,7 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 };
 
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 };
 
 /**
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index e446f4b84152..772d876b1087 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -97,3 +97,23 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 err:
 	return ERR_PTR(rc);
 }
+
+/**
+ * ipe_get_policy_rcu - Dereference a rcu-protected policy pointer.
+ *
+ * @p: rcu-protected pointer to a policy.
+ *
+ * Not safe to call on IS_ERR.
+ *
+ * Return: the value of @p
+ */
+struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
+{
+	struct ipe_policy *rv = NULL;
+
+	rcu_read_lock();
+	rv = rcu_dereference(p);
+	rcu_read_unlock();
+
+	return rv;
+}
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 6af2d9a811ec..967d816cd5cd 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -26,6 +26,8 @@ enum ipe_action_type {
 };
 
 enum ipe_prop_type {
+	ipe_prop_boot_verified_false,
+	ipe_prop_boot_verified_true,
 	ipe_prop_max
 };
 
@@ -73,5 +75,6 @@ struct ipe_policy {
 struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 				  const char *pkcs7, size_t pkcs7len);
 void ipe_free_policy(struct ipe_policy *pol);
+struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
 
 #endif /* IPE_POLICY_H */
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index c7ba0e865366..7efafc482e46 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -265,7 +265,9 @@ static enum ipe_action_type parse_action(char *t)
 }
 
 static const match_table_t property_tokens = {
-	{ipe_prop_max,					NULL}
+	{ipe_prop_boot_verified_false,	"boot_verified=FALSE"},
+	{ipe_prop_boot_verified_true,	"boot_verified=TRUE"},
+	{ipe_prop_max,			NULL}
 };
 
 /**
@@ -295,6 +297,10 @@ int parse_property(char *t, struct ipe_rule *r)
 	token = match_token(t, property_tokens, args);
 
 	switch (token) {
+	case ipe_prop_boot_verified_false:
+	case ipe_prop_boot_verified_true:
+		p->type = token;
+		break;
 	case ipe_prop_max:
 	default:
 		rc = -EBADMSG;
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

