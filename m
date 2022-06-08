Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E90C3F2D4
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 19:07:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-nb8NLK3FPcaeFjN3KIJ_PQ-1; Wed, 08 Jun 2022 15:07:46 -0400
X-MC-Unique: nb8NLK3FPcaeFjN3KIJ_PQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63E1F2999B5F;
	Wed,  8 Jun 2022 19:07:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5313F456CD9;
	Wed,  8 Jun 2022 19:07:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05E90194705F;
	Wed,  8 Jun 2022 19:07:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA5691947B9F
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 19:07:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5BA51131A; Wed,  8 Jun 2022 19:07:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B11C29D7F
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E37F80159B
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:07:31 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-365-dtXnwaZfOqqp0IyE2LYK6A-1; Wed,
 08 Jun 2022 15:07:27 -0400
X-MC-Unique: dtXnwaZfOqqp0IyE2LYK6A-1
Received: from
 linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
 (linux.microsoft.com [13.77.154.182])
 by linux.microsoft.com (Postfix) with ESMTPSA id 9FA0820BE672;
 Wed,  8 Jun 2022 12:01:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9FA0820BE672
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Wed,  8 Jun 2022 12:01:20 -0700
Message-Id: <1654714889-26728-9-git-send-email-deven.desai@linux.microsoft.com>
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
Subject: [dm-devel] [RFC PATCH v8 08/17] ipe: add permissive toggle
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

IPE, like SELinux, supports a permissive mode. This mode allows policy
authors to test and evaluate IPE policy without it effecting their
programs. When the mode is changed, a 1423 AUDIT_TRUST_STATUS will
be reported.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

---

This patch adds the following audit records:

  type=1404 audit(1653425689.008:55): permissive=1
  type=1404 audit(1653425689.008:55): permissive=0

These records are emitted within the following events:

  type=1404 audit(1653425689.008:55): permissive=1
  type=1300 audit(1653425689.008:55): arch=c000003e syscall=1
    success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405
    pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
  type=1327 audit(1653425689.008:55): proctitle="-bash"

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
  + Split out permissive functionality into a separate patch for easier
    review.
  + Remove permissive switch compile-time configuration option - this
    is trivial to add later.

v8:
  + Remove "IPE" prefix from permissive audit record
  + align fields to the linux-audit field dictionary. This causes the
    following fields to change:
      enforce -> permissive

  + Remove duplicated information correlated with syscall record, that
    will always be present in the audit event.
  + Change audit types:
    + AUDIT_TRUST_STATUS -> AUDIT_MAC_STATUS
      + There is no significant difference in meaning between
        these types.
---
 security/ipe/audit.c | 43 ++++++++++++++++++++++++
 security/ipe/audit.h |  5 +++
 security/ipe/ctx.c   |  6 ++++
 security/ipe/ctx.h   |  1 +
 security/ipe/eval.c  |  6 ++++
 security/ipe/fs.c    | 78 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 139 insertions(+)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 0442cc51a4bd..cf0ccea32c90 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -182,3 +182,46 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
 
 	audit_log_end(ab);
 }
+
+/**
+ * ipe_audit_enforce: Audit a change in IPE's enforcement state
+ * @ctx: Supplies a pointer to the contexts whose state changed.
+ */
+void ipe_audit_enforce(const struct ipe_context *const ctx)
+{
+	struct audit_buffer *ab;
+	bool enforcing = false;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS);
+	if (!ab)
+		return;
+
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->enforce);
+	rcu_read_unlock();
+
+	audit_log_format(ab, "permissive=%d", !enforcing);
+
+	audit_log_end(ab);
+}
+
+/**
+ * emit_enforcement: Emit the enforcement state of IPE started with.
+ *
+ * Return:
+ * 0 - Always
+ */
+static int emit_enforcement(void)
+{
+	struct ipe_context *ctx = NULL;
+
+	if (!ipe_enabled)
+		return -EOPNOTSUPP;
+
+	ctx = ipe_current_ctx();
+	ipe_audit_enforce(ctx);
+	ipe_put_ctx(ctx);
+	return 0;
+}
+
+late_initcall(emit_enforcement);
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
index bec03208042d..daff9c801a8e 100644
--- a/security/ipe/audit.h
+++ b/security/ipe/audit.h
@@ -15,6 +15,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 		     enum ipe_action act, const struct ipe_rule *const r);
 void ipe_audit_policy_load(const struct ipe_policy *const p);
 void ipe_audit_policy_activation(const struct ipe_policy *const p);
+void ipe_audit_enforce(const struct ipe_context *const ctx);
 #else
 static inline void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 				   enum ipe_match match_type,
@@ -29,6 +30,10 @@ static inline void ipe_audit_policy_load(const struct ipe_policy *const p)
 static inline void ipe_audit_policy_activation(const struct ipe_policy *const p)
 {
 }
+
+static inline void ipe_audit_enforce(const struct ipe_context *const ctx)
+{
+}
 #endif /* CONFIG_IPE_AUDIT */
 
 #endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index 391c7102e08d..ee3cb2bd6028 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -16,6 +16,7 @@
 #include <linux/moduleparam.h>
 
 static bool success_audit;
+static bool enforce = true;
 
 /**
  * ver_to_u64: convert an internal ipe_policy_version to a u64
@@ -135,6 +136,7 @@ static struct ipe_context *create_ctx(void)
 	INIT_LIST_HEAD(&ctx->policies);
 	refcount_set(&ctx->refcount, 1);
 	spin_lock_init(&ctx->lock);
+	WRITE_ONCE(ctx->enforce, true);
 
 	return ctx;
 
@@ -324,6 +326,7 @@ int __init ipe_init_ctx(void)
 
 	spin_lock(&lns->lock);
 	WRITE_ONCE(lns->success_audit, success_audit);
+	WRITE_ONCE(lns->enforce, enforce);
 	spin_unlock(&lns->lock);
 
 	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
@@ -342,3 +345,6 @@ int __init ipe_init_ctx(void)
 
 module_param(success_audit, bool, 0400);
 MODULE_PARM_DESC(success_audit, "Start IPE with success auditing enabled");
+
+module_param(enforce, bool, 0400);
+MODULE_PARM_DESC(enforce, "Start IPE in enforce or permissive mode");
diff --git a/security/ipe/ctx.h b/security/ipe/ctx.h
index 31aea2fb9e49..d7bf9fc6426a 100644
--- a/security/ipe/ctx.h
+++ b/security/ipe/ctx.h
@@ -14,6 +14,7 @@
 
 struct ipe_context {
 	struct ipe_policy __rcu *active_policy;
+	bool __rcu enforce;
 
 	bool __rcu success_audit;
 
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index fcfa3a37b0ed..eafa670558e3 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -84,6 +84,10 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (!pol)
 		goto out;
 
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->ci_ctx->enforce);
+	rcu_read_unlock();
+
 	if (ctx->op == ipe_operation_max) {
 		action = pol->parsed->global_default;
 		match_type = ipe_match_global;
@@ -119,6 +123,8 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (action == ipe_action_deny)
 		rc = -EACCES;
 
+	if (!enforcing)
+		rc = 0;
 out:
 	ipe_put_policy(pol);
 	return rc;
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index 6e28807780c0..f4d32f84c945 100644
--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -13,8 +13,73 @@
 static struct dentry *np __ro_after_init;
 static struct dentry *root __ro_after_init;
 static struct dentry *config __ro_after_init;
+static struct dentry *enforce __ro_after_init;
 static struct dentry *success_audit __ro_after_init;
 
+/**
+ * setenforce: Write handler for the securityfs node, "ipe/enforce"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t setenforce(struct file *f, const char __user *data,
+			  size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value;
+	struct ipe_context *ctx;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		return rc;
+
+	ctx = ipe_current_ctx();
+
+	spin_lock(&ctx->lock);
+	WRITE_ONCE(ctx->enforce, value);
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+
+	ipe_audit_enforce(ctx);
+	ipe_put_ctx(ctx);
+	return len;
+}
+
+/**
+ * getenforce: Read handler for the securityfs node, "ipe/enforce"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the read syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t getenforce(struct file *f, char __user *data,
+			  size_t len, loff_t *offset)
+{
+	const char *result;
+	struct ipe_context *ctx;
+
+	ctx = ipe_current_ctx();
+
+	rcu_read_lock();
+	result = ((READ_ONCE(ctx->enforce)) ? "1" : "0");
+	rcu_read_unlock();
+
+	ipe_put_ctx(ctx);
+	return simple_read_from_buffer(data, len, offset, result, 2);
+}
+
 /**
  * setaudit: Write handler for the securityfs node, "ipe/success_audit"
  * @f: Supplies a file structure representing the securityfs node.
@@ -185,6 +250,11 @@ static const struct file_operations np_fops = {
 	.write = new_policy,
 };
 
+static const struct file_operations enforce_fops = {
+	.write = setenforce,
+	.read = getenforce,
+};
+
 static const struct file_operations audit_fops = {
 	.write = setaudit,
 	.read = getaudit,
@@ -233,6 +303,13 @@ static int __init ipe_init_securityfs(void)
 		goto err;
 	}
 
+	enforce = securityfs_create_file("enforce", 0600, root, NULL,
+					 &enforce_fops);
+	if (IS_ERR(enforce)) {
+		rc = PTR_ERR(enforce);
+		goto err;
+	}
+
 	ctx->policy_root = securityfs_create_dir("policies", root);
 	if (IS_ERR(ctx->policy_root)) {
 		rc = PTR_ERR(ctx->policy_root);
@@ -244,6 +321,7 @@ static int __init ipe_init_securityfs(void)
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(config);
+	securityfs_remove(enforce);
 	securityfs_remove(success_audit);
 	securityfs_remove(ctx->policy_root);
 	return rc;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

