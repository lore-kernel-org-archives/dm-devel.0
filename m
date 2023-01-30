Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90299C636CD
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151585;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gXtEbLwuCSbzD2Yy5mWQJB4Wwm1Lbytk/PTN8hsqXdI=;
	b=GwyVquZAYf58PogwxqKKRSzG4oLZd5D+HE++Z1G9LhEOOpoAryYNA6MFfR0Kyndidtgvds
	Ilw7CAg7EC4Pmx6V60aknZjglWVuXaMVL5U1D8kmGGXnXuhCYss/Y4eTFIrchXplvizBJS
	SagmLHTmjmJar2XQfXCOZN0ayO2AUt0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-f3CwaeRYNaS0ugE-2xTeqg-1; Tue, 31 Jan 2023 02:53:02 -0500
X-MC-Unique: f3CwaeRYNaS0ugE-2xTeqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C6DA8027ED;
	Tue, 31 Jan 2023 07:52:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 48B2B2026D4B;
	Tue, 31 Jan 2023 07:52:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E2BD1946589;
	Tue, 31 Jan 2023 07:52:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E388D19465B2
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CA9F4422AE; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C30F0175AD
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A30F6101A521
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-361-1ipI1XseMbqehrmPbpOW2A-1; Mon,
 30 Jan 2023 18:06:38 -0500
X-MC-Unique: 1ipI1XseMbqehrmPbpOW2A-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 5ADFD20EA1F6; Mon, 30 Jan 2023 14:58:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5ADFD20EA1F6
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Mon, 30 Jan 2023 14:57:23 -0800
Message-Id: <1675119451-23180-9-git-send-email-wufan@linux.microsoft.com>
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
Subject: [dm-devel] [RFC PATCH v9 08/16] ipe: add permissive toggle
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE, like SELinux, supports a permissive mode. This mode allows policy
authors to test and evaluate IPE policy without it effecting their
programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
be reported.

This patch adds the following audit records:

  audit: MAC_STATUS permissive=1 auid=4294967295 ses=4294967295 lsm=ipe
    res=1
  audit: MAC_STATUS permissive=0 auid=4294967295 ses=4294967295 lsm=ipe
    res=1

These records are emitted within the following events:

  audit: MAC_STATUS permissive=1 auid=4294967295 ses=4294967295 lsm=ipe
    res=1
  audit[185]: SYSCALL arch=c000003e syscall=1 success=yes exit=2 a0=1
    a1=56308bb3ecc0 a2=2 a3=7f290fdc53e0 items=0 ppid=183 pid=185
    auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
    tty=pts0 ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)
  audit: PROCTITLE proctitle="-bash"
  audit: MAC_STATUS permissive=0 auid=4294967295 ses=4294967295 lsm=ipe
    res=1
  audit[185]: SYSCALL arch=c000003e syscall=1 success=yes exit=2 a0=1
    a1=56308bb3ecc0 a2=2 a3=7f290fdc53e0 items=0 ppid=183 pid=185
    auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
    tty=pts0 ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)
  audit: PROCTITLE proctitle="-bash"

  Implying user used bash to toggle the switch.

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

v9:
  + Clean up ipe_context related code
---
 security/ipe/audit.c | 36 +++++++++++++++++++++++
 security/ipe/audit.h |  1 +
 security/ipe/eval.c  |  9 ++++++
 security/ipe/eval.h  |  1 +
 security/ipe/fs.c    | 69 ++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 295e9f9f5146..ff74026a595f 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -194,3 +194,39 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
 
 	audit_log_end(ab);
 }
+
+/**
+ * ipe_audit_enforce - Audit a change in IPE's enforcement state.
+ */
+void ipe_audit_enforce(void)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "permissive=%d", !READ_ONCE(enforce));
+	audit_log_format(ab, " auid=%u ses=%u lsm=ipe res=1",
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 audit_get_sessionid(current));
+
+	audit_log_end(ab);
+}
+
+/**
+ * emit_enforcement - Emit the enforcement state of IPE started with.
+ *
+ * Return:
+ * 0 - Always
+ */
+static int emit_enforcement(void)
+{
+	if (!ipe_enabled)
+		return -EOPNOTSUPP;
+
+	ipe_audit_enforce();
+	return 0;
+}
+
+late_initcall(emit_enforcement);
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
index 2e9b99737f97..4c676ed32846 100644
--- a/security/ipe/audit.h
+++ b/security/ipe/audit.h
@@ -14,5 +14,6 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 void ipe_audit_policy_load(const struct ipe_policy *const p);
 void ipe_audit_policy_activation(const struct ipe_policy *const op,
 				 const struct ipe_policy *const np);
+void ipe_audit_enforce(void);
 
 #endif /* IPE_AUDIT_H */
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index d713808cad9c..499314554b1d 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -20,6 +20,7 @@
 
 struct ipe_policy __rcu *ipe_active_policy;
 bool success_audit;
+bool enforce = true;
 
 static struct super_block *pinned_sb;
 static DEFINE_SPINLOCK(pin_lock);
@@ -119,6 +120,7 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 {
 	int rc = 0;
 	bool match = false;
+	bool enforcing = true;
 	enum ipe_action_type action;
 	enum ipe_match match_type;
 	struct ipe_policy *pol = NULL;
@@ -133,6 +135,8 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 	if (!pol)
 		goto out;
 
+	enforcing = READ_ONCE(enforce);
+
 	if (ctx->op == ipe_op_max) {
 		action = pol->parsed->global_default_action;
 		match_type = ipe_match_global;
@@ -168,6 +172,9 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 	if (action == ipe_action_deny)
 		rc = -EACCES;
 
+	if (!enforcing)
+		rc = 0;
+
 out:
 	return rc;
 }
@@ -198,3 +205,5 @@ void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
 
 module_param(success_audit, bool, 0400);
 MODULE_PARM_DESC(success_audit, "Start IPE with success auditing enabled");
+module_param(enforce, bool, 0400);
+MODULE_PARM_DESC(enforce, "Start IPE in enforce or permissive mode");
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index b83730d0b5ae..64369c3b8cf9 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -14,6 +14,7 @@
 
 extern struct ipe_policy __rcu *ipe_active_policy;
 extern bool success_audit;
+extern bool enforce;
 
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index c99616f36f32..bbee17b59b1b 100644
--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -15,6 +15,7 @@ static struct dentry *np __ro_after_init;
 static struct dentry *root __ro_after_init;
 struct dentry *policy_root __ro_after_init;
 static struct dentry *audit_node __ro_after_init;
+static struct dentry *enforce_node __ro_after_init;
 
 /**
  * setaudit - Write handler for the securityfs node, "ipe/success_audit"
@@ -48,8 +49,8 @@ static ssize_t setaudit(struct file *f, const char __user *data,
 /**
  * getaudit - Read handler for the securityfs node, "ipe/success_audit"
  * @f: Supplies a file structure representing the securityfs node.
- * @data: Supplies a buffer passed to the read syscall
- * @len: Supplies the length of @data
+ * @data: Supplies a buffer passed to the read syscall.
+ * @len: Supplies the length of @data.
  * @offset: unused.
  *
  * Return:
@@ -66,6 +67,57 @@ static ssize_t getaudit(struct file *f, char __user *data,
 	return simple_read_from_buffer(data, len, offset, result, 1);
 }
 
+/**
+ * setenforce - Write handler for the securityfs node, "ipe/enforce"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t setenforce(struct file *f, const char __user *data,
+			  size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		return rc;
+
+	WRITE_ONCE(enforce, value);
+	ipe_audit_enforce();
+
+	return len;
+}
+
+/**
+ * getenforce - Read handler for the securityfs node, "ipe/enforce"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the read syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t getenforce(struct file *f, char __user *data,
+			  size_t len, loff_t *offset)
+{
+	const char *result;
+
+	result = ((READ_ONCE(enforce)) ? "1" : "0");
+
+	return simple_read_from_buffer(data, len, offset, result, 1);
+}
+
 /**
  * new_policy - Write handler for the securityfs node, "ipe/new_policy".
  * @f: Supplies a file structure representing the securityfs node.
@@ -118,6 +170,11 @@ static const struct file_operations audit_fops = {
 	.read = getaudit,
 };
 
+static const struct file_operations enforce_fops = {
+	.write = setenforce,
+	.read = getenforce,
+};
+
 /**
  * ipe_init_securityfs - Initialize IPE's securityfs tree at fsinit.
  *
@@ -151,6 +208,13 @@ static int __init ipe_init_securityfs(void)
 		goto err;
 	}
 
+	enforce_node = securityfs_create_file("enforce", 0600, root, NULL,
+					      &enforce_fops);
+	if (IS_ERR(enforce_node)) {
+		rc = PTR_ERR(enforce_node);
+		goto err;
+	}
+
 	policy_root = securityfs_create_dir("policies", root);
 	if (IS_ERR(policy_root)) {
 		rc = PTR_ERR(policy_root);
@@ -162,6 +226,7 @@ static int __init ipe_init_securityfs(void)
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(audit_node);
+	securityfs_remove(enforce_node);
 	securityfs_remove(policy_root);
 	return rc;
 }
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

