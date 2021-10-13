Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F3FC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 36AC16113D
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 36AC16113D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-OHmy1l5WMTiCPCcErdiLkw-1; Wed, 13 Oct 2021 15:17:11 -0400
X-MC-Unique: OHmy1l5WMTiCPCcErdiLkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 613B210199A4;
	Wed, 13 Oct 2021 19:17:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F99760FB8;
	Wed, 13 Oct 2021 19:17:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D59FF1800FE4;
	Wed, 13 Oct 2021 19:17:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJD2b0018748 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:13:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CB1592166B2D; Wed, 13 Oct 2021 19:13:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF6942166B3F
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:12:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8B12899EC4
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:12:58 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-426-P117muSpPG63IX-tBgTEIg-1;
	Wed, 13 Oct 2021 15:12:56 -0400
X-MC-Unique: P117muSpPG63IX-tBgTEIg-1
Received: from
	linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
	(linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8E62820B9CFE;
	Wed, 13 Oct 2021 12:06:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8E62820B9CFE
From: deven.desai@linux.microsoft.com
To: corbet@lwn.net, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Date: Wed, 13 Oct 2021 12:06:22 -0700
Message-Id: <1634151995-16266-4-git-send-email-deven.desai@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	jannh@google.com, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-audit@redhat.com
Subject: [dm-devel] [RFC PATCH v7 03/16] ipe: add evaluation loop
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

IPE must have a centralized function to evaluate incoming callers
against IPE's policy. This iteration of the policy for against the rules
for that specific caller is known as the evaluation loop.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Refactor patch to support a context structure,
    enabling easier testing
  * Split up patch 02/12 into four parts:
      1. context creation [01/16]
      2. audit [07/16]
      3. evaluation loop [03/16] (this patch)
      4. access control hooks [05/16]

---
 security/ipe/Makefile             |   1 +
 security/ipe/ctx.c                |  57 ++++++++++++
 security/ipe/ctx.h                |   6 ++
 security/ipe/eval.c               | 142 ++++++++++++++++++++++++++++++
 security/ipe/eval.h               |  26 ++++++
 security/ipe/hooks.h              |   4 +
 security/ipe/modules/ipe_module.h |   3 +
 security/ipe/policy.c             |  27 ++++++
 security/ipe/policy.h             |   4 +
 9 files changed, 270 insertions(+)
 create mode 100644 security/ipe/eval.c
 create mode 100644 security/ipe/eval.h

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 9a97efd8a190..0db69f13e82a 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -9,6 +9,7 @@ ccflags-y := -I$(srctree)/security/ipe/modules
 
 obj-$(CONFIG_SECURITY_IPE) += \
 	ctx.o \
+	eval.o \
 	hooks.o \
 	ipe.o \
 	modules.o \
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index c24f5d1d41bd..9274e51eff52 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -5,6 +5,7 @@
 
 #include "ipe.h"
 #include "ctx.h"
+#include "policy.h"
 
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -76,10 +77,25 @@ struct ipe_context *ipe_get_ctx_rcu(struct ipe_context __rcu *ctx)
  */
 static void free_ctx_work(struct work_struct *const work)
 {
+	struct ipe_policy *p = NULL;
 	struct ipe_context *ctx = NULL;
 
 	ctx = container_of(work, struct ipe_context, free_work);
 
+	/* Make p->ctx no longer have any references */
+	spin_lock(&ctx->lock);
+	list_for_each_entry(p, &ctx->policies, next)
+		rcu_assign_pointer(p->ctx, NULL);
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+
+	/*
+	 * locking no longer necessary - nothing can get a reference to ctx,
+	 * so list is guaranteed stable.
+	 */
+	list_for_each_entry(p, &ctx->policies, next)
+		ipe_put_policy(p);
+
 	kfree(ctx);
 }
 
@@ -104,6 +120,7 @@ static struct ipe_context *create_ctx(void)
 	}
 
 	INIT_WORK(&ctx->free_work, free_ctx_work);
+	INIT_LIST_HEAD(&ctx->policies);
 	refcount_set(&ctx->refcount, 1);
 	spin_lock_init(&ctx->lock);
 
@@ -114,6 +131,46 @@ static struct ipe_context *create_ctx(void)
 	return ERR_PTR(rc);
 }
 
+/**
+ * remove_policy: Remove a policy from its context
+ * @p: Supplies a pointer to a policy that will be removed from its context
+ *
+ * Decrements @p's reference by 1.
+ */
+void ipe_remove_policy(struct ipe_policy *p)
+{
+	struct ipe_context *ctx;
+
+	ctx = ipe_get_ctx_rcu(p->ctx);
+	if (!ctx)
+		return;
+
+	spin_lock(&ctx->lock);
+	list_del_init(&p->next);
+	rcu_assign_pointer(p->ctx, NULL);
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+
+	ipe_put_ctx(ctx);
+	/* drop the reference representing the list */
+	ipe_put_policy(p);
+}
+
+/**
+ * ipe_add_policy: Associate @p with @ctx
+ * @ctx: Supplies a pointer to the ipe_context structure to associate @p with.
+ * @p: Supplies a pointer to the ipe_policy structure to associate.
+ */
+void ipe_add_policy(struct ipe_context *ctx, struct ipe_policy *p)
+{
+	spin_lock(&ctx->lock);
+	rcu_assign_pointer(p->ctx, ctx);
+	list_add_tail(&p->next, &ctx->policies);
+	refcount_inc(&p->refcount);
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+}
+
 /**
  * ipe_put_ns: Decrement the reference of an ipe_context structure,
  *	       scheduling a free as necessary.s
diff --git a/security/ipe/ctx.h b/security/ipe/ctx.h
index 69a2c92c0a8c..a0da92da818c 100644
--- a/security/ipe/ctx.h
+++ b/security/ipe/ctx.h
@@ -12,10 +12,14 @@
 #include <linux/workqueue.h>
 
 struct ipe_context {
+	struct ipe_policy __rcu *active_policy;
+
 	refcount_t refcount;
 	/* Protects concurrent writers */
 	spinlock_t lock;
 
+	struct list_head policies; /* type: ipe_policy */
+
 	struct work_struct free_work;
 };
 
@@ -24,5 +28,7 @@ struct ipe_context __rcu **ipe_tsk_ctx(struct task_struct *tsk);
 struct ipe_context *ipe_current_ctx(void);
 struct ipe_context *ipe_get_ctx_rcu(struct ipe_context __rcu *ctx);
 void ipe_put_ctx(struct ipe_context *ctx);
+void ipe_add_policy(struct ipe_context *ctx, struct ipe_policy *p);
+void ipe_remove_policy(struct ipe_policy *p);
 
 #endif /* IPE_CONTEXT_H */
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
new file mode 100644
index 000000000000..b732f76cfd05
--- /dev/null
+++ b/security/ipe/eval.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ctx.h"
+#include "eval.h"
+#include "hooks.h"
+#include "policy.h"
+#include "modules/ipe_module.h"
+
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
+
+/**
+ * build_ctx: Build an evaluation context.
+ * @file: Supplies a pointer to the file to associated with the evaluation
+ * @op: Supplies the IPE policy operation associated with the evaluation
+ * @hook: Supplies the LSM hook associated with the evaluation.
+ *
+ * The current IPE Context will have a reference count increased by one until
+ * this is deallocated.
+ *
+ * Return:
+ * !IS_ERR - OK
+ */
+static struct ipe_eval_ctx *build_ctx(const struct file *file,
+				      enum ipe_operation op,
+				      enum ipe_hook hook)
+{
+	struct ipe_eval_ctx *ctx = NULL;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->file = file;
+	ctx->op = op;
+	ctx->hook = hook;
+	ctx->ci_ctx = ipe_current_ctx();
+
+	return ctx;
+}
+
+/**
+ * free_ctx: Deallocate a previously-allocated ipe_eval_ctx
+ * @ctx: Supplies a pointer to the evaluation context to free.
+ */
+static void free_ctx(struct ipe_eval_ctx *ctx)
+{
+	if (IS_ERR_OR_NULL(ctx))
+		return;
+
+	ipe_put_ctx(ctx->ci_ctx);
+	kfree(ctx);
+}
+
+/**
+ * evaluate: Analyze @ctx against the active policy and return the result.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ *
+ * This is the loop where all policy evaluation happens against IPE policy.
+ *
+ * Return:
+ * 0 - OK
+ * -EACCES - @ctx did not pass evaluation.
+ * !0 - Error
+ */
+static int evaluate(const struct ipe_eval_ctx *const ctx)
+{
+	int rc = 0;
+	bool match = false;
+	enum ipe_action action;
+	struct ipe_policy *pol = NULL;
+	const struct ipe_rule *rule = NULL;
+	const struct ipe_policy_mod *module = NULL;
+	const struct ipe_operation_table *rules = NULL;
+
+	pol = ipe_get_policy_rcu(ctx->ci_ctx->active_policy);
+	if (!pol)
+		goto out;
+
+	rules = &pol->parsed->rules[ctx->op];
+
+	list_for_each_entry(rule, &rules->rules, next) {
+		match = true;
+
+		list_for_each_entry(module, &rule->modules, next)
+			match = match && module->mod->eval(ctx, module->mod_value);
+
+		if (match)
+			break;
+	}
+
+	if (match) {
+		action = rule->action;
+	} else if (rules->default_action != ipe_action_max) {
+		action = rules->default_action;
+	} else {
+		action = pol->parsed->global_default;
+	}
+
+	if (action == ipe_action_deny)
+		rc = -EACCES;
+
+out:
+	ipe_put_policy(pol);
+	return rc;
+}
+
+/**
+ * ipe_process_event: Submit @file for verification against IPE's policy
+ * @file: Supplies an optional pointer to the file being submitted.
+ * @op: IPE Policy Operation to associate with @file
+ * @hook: LSM Hook to associate with @file
+ *
+ * @file can be NULL and will be submitted for evaluation like a non-NULL
+ * file.
+ *
+ * Return:
+ * 0 - OK
+ * -EACCES - @file did not pass verification
+ * !0 - Error
+ */
+int ipe_process_event(const struct file *file, enum ipe_operation op,
+		      enum ipe_hook hook)
+{
+	int rc = 0;
+	struct ipe_eval_ctx *ctx = NULL;
+
+	ctx = build_ctx(file, op, hook);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	rc = evaluate(ctx);
+
+	free_ctx(ctx);
+	return rc;
+}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
new file mode 100644
index 000000000000..db6da2998a20
--- /dev/null
+++ b/security/ipe/eval.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_EVAL_H
+#define IPE_EVAL_H
+
+#include <linux/file.h>
+
+#include "ctx.h"
+#include "hooks.h"
+#include "policy.h"
+
+struct ipe_eval_ctx {
+	enum ipe_hook hook;
+	enum ipe_operation op;
+
+	const struct file *file;
+	struct ipe_context *ci_ctx;
+};
+
+int ipe_process_event(const struct file *file, enum ipe_operation op,
+		      enum ipe_hook hook);
+
+#endif /* IPE_EVAL_H */
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index e0ae3c7dfb5b..58ed4a612e26 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -8,6 +8,10 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 
+enum ipe_hook {
+	ipe_hook_max = 0
+};
+
 int ipe_task_alloc(struct task_struct *task,
 		   unsigned long clone_flags);
 
diff --git a/security/ipe/modules/ipe_module.h b/security/ipe/modules/ipe_module.h
index 397a54cbc4db..b4f975e9218a 100644
--- a/security/ipe/modules/ipe_module.h
+++ b/security/ipe/modules/ipe_module.h
@@ -6,6 +6,7 @@
 #define IPE_MODULE_H
 
 #include <linux/types.h>
+#include "../eval.h"
 
 /**
  * ipe_module: definition of an extensible module for IPE properties.
@@ -23,6 +24,8 @@ struct ipe_module {
 	u16				version;	/* required */
 	int (*parse)(const char *valstr, void **value);	/* required */
 	int (*free)(void **value);			/* optional */
+	bool (*eval)(const struct ipe_eval_ctx *ctx,	/* required */
+		     const void *val);
 };
 
 #define IPE_MODULE(parser)				\
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index 9dd60dd34477..8970f96453d6 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -874,6 +874,32 @@ void ipe_put_policy(struct ipe_policy *p)
 	kfree(p);
 }
 
+/**
+ * ipe_get_policy_rcu: Dereference rcu-protected @p and increase the reference
+ *		       count.
+ * @p: rcu-protected pointer to dereference
+ *
+ * Not safe to call on IS_ERR.
+ *
+ * Return:
+ * !NULL - reference count of @p was valid, and increased by one.
+ * NULL - reference count of @p is not valid.
+ */
+struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
+{
+	struct ipe_policy *rv = NULL;
+
+	rcu_read_lock();
+
+	rv = rcu_dereference(p);
+	if (!rv || !refcount_inc_not_zero(&rv->refcount))
+		rv = NULL;
+
+	rcu_read_unlock();
+
+	return rv;
+}
+
 static int set_pkcs7_data(void *ctx, const void *data, size_t len,
 			  size_t asn1hdrlen)
 {
@@ -912,6 +938,7 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 		return ERR_PTR(-ENOMEM);
 
 	refcount_set(&new->refcount, 1);
+	INIT_LIST_HEAD(&new->next);
 
 	if (!text) {
 		new->pkcs7len = pkcs7len;
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index d78788db238c..2b5041c5a75a 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -87,11 +87,15 @@ struct ipe_policy {
 	struct ipe_parsed_policy *parsed;
 
 	refcount_t	refcount;
+
+	struct list_head next;		/* type: ipe_policy */
+	struct ipe_context __rcu *ctx;
 };
 
 struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 				  const char *pkcs7, size_t pkcs7len);
 void ipe_put_policy(struct ipe_policy *pol);
 bool ipe_is_op_alias(int op, const enum ipe_operation **map, size_t *size);
+struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
 
 #endif /* IPE_POLICY_H */
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

