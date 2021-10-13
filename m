Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F012C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1D89611C0
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B1D89611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-oBloRMFGMOGFkbn5Zd1XBw-1; Wed, 13 Oct 2021 15:17:33 -0400
X-MC-Unique: oBloRMFGMOGFkbn5Zd1XBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AE11DF8AA;
	Wed, 13 Oct 2021 19:17:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B7385F4F9;
	Wed, 13 Oct 2021 19:17:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D04724EA38;
	Wed, 13 Oct 2021 19:17:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJD3Ii018762 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:13:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F1921000DB6; Wed, 13 Oct 2021 19:13:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A4071002122
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:12:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E9461857F0E
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:12:58 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-502-MuEjK_X2O6-yIiwUOfMl1A-1;
	Wed, 13 Oct 2021 15:12:56 -0400
X-MC-Unique: MuEjK_X2O6-yIiwUOfMl1A-1
Received: from
	linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
	(linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0DF7520B9D03;
	Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0DF7520B9D03
From: deven.desai@linux.microsoft.com
To: corbet@lwn.net, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Date: Wed, 13 Oct 2021 12:06:27 -0700
Message-Id: <1634151995-16266-9-git-send-email-deven.desai@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	jannh@google.com, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-audit@redhat.com
Subject: [dm-devel] [RFC PATCH v7 08/16] ipe: add permissive toggle
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE, like SELinux, supports a permissive mode. This mode allows policy
authors to test and evaluate IPE policy without it effecting their
programs.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Refactor series to:
      1. Support a context structure, enabling easier testing
      2. Make parser code cleaner
  * Split up patch 02/12 into four parts:
      1. context creation [01/16]
      2. audit [07/16]
      3. evaluation loop [03/16]
      4. access control hooks [05/16]
      5. permissive mode [08/16]

---
 security/ipe/audit.c | 40 +++++++++++++++++++++++
 security/ipe/audit.h |  5 +++
 security/ipe/ctx.c   |  6 ++++
 security/ipe/ctx.h   |  1 +
 security/ipe/eval.c  |  6 ++++
 security/ipe/fs.c    | 78 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 136 insertions(+)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 5f6c0a52b0cb..82bf94b83fe1 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -262,3 +262,43 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
 
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
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_TRUST_STATUS);
+	if (!ab)
+		return;
+
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->enforce);
+	rcu_read_unlock();
+
+	audit_log_format(ab, "IPE enforce=%d", enforcing);
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
+	ctx = ipe_current_ctx();
+	ipe_audit_enforce(ctx);
+	ipe_put_ctx(ctx);
+	return 0;
+}
+
+late_initcall(emit_enforcement);
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
index 6b6880f6e8e7..a9d16323a3c8 100644
--- a/security/ipe/audit.h
+++ b/security/ipe/audit.h
@@ -16,6 +16,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 		     bool enforce);
 void ipe_audit_policy_load(const struct ipe_policy *const p);
 void ipe_audit_policy_activation(const struct ipe_policy *const p);
+void ipe_audit_enforce(const struct ipe_context *const ctx);
 #else
 static inline void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 				   enum ipe_match match_type,
@@ -31,6 +32,10 @@ static inline void ipe_audit_policy_load(const struct ipe_policy *const p)
 static inline void ipe_audit_policy_activation(const struct ipe_policy *const p)
 {
 }
+
+static inline void ipe_audit_enforce(const struct ipe_context *const ctx)
+{
+}
 #endif /* CONFIG_AUDIT */
 
 #endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index 77475aedbfe9..fc9b8e467bc9 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -16,6 +16,7 @@
 #include <linux/moduleparam.h>
 
 static bool success_audit;
+static bool enforce = true;
 
 /**
  * ver_to_u64: convert an internal ipe_policy_version to a u64
@@ -151,6 +152,7 @@ static struct ipe_context *create_ctx(void)
 	INIT_LIST_HEAD(&ctx->policies);
 	refcount_set(&ctx->refcount, 1);
 	spin_lock_init(&ctx->lock);
+	WRITE_ONCE(ctx->enforce, true);
 
 	return ctx;
 
@@ -337,6 +339,7 @@ int __init ipe_init_ctx(void)
 
 	spin_lock(&lns->lock);
 	WRITE_ONCE(lns->success_audit, success_audit);
+	WRITE_ONCE(lns->enforce, enforce);
 	spin_unlock(&lns->lock);
 
 	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
@@ -355,3 +358,6 @@ int __init ipe_init_ctx(void)
 
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
index dcb62179e4bf..e520ce521c05 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -86,6 +86,10 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (!pol)
 		goto out;
 
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->ci_ctx->enforce);
+	rcu_read_unlock();
+
 	rules = &pol->parsed->rules[ctx->op];
 
 	list_for_each_entry(rule, &rules->rules, next) {
@@ -114,6 +118,8 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (action == ipe_action_deny)
 		rc = -EACCES;
 
+	if (!enforcing)
+		rc = 0;
 out:
 	ipe_put_policy(pol);
 	return rc;
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index c202c0753755..e6b36291e62f 100644
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
@@ -230,6 +300,13 @@ static int __init ipe_init_securityfs(void)
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
@@ -241,6 +318,7 @@ static int __init ipe_init_securityfs(void)
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(config);
+	securityfs_remove(enforce);
 	securityfs_remove(success_audit);
 	securityfs_remove(ctx->policy_root);
 	return rc;
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

