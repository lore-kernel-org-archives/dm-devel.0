Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A46C38142
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151246;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Owuj+AwrSXtVRadsXQ+cdtfOKXnKSCIGNcHNpsubZao=;
	b=VMpHSsaqWQ7IqIht3uCqBwLUlGkm3PcJf0F8Rj2emEA0LJwCIJIGLrJ/kMk4cpyr6uXPxq
	NYGw7adUQCbAismokuiniFhF+fkqObah3ri2Vd5xc6vIFslc/F6NeMAA6tu2/TSId0+Eo2
	RREWUoDrsm7h5qg4ArbBpL7h35EGHDo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-UXe07KNMPBaxEybl43d5Zw-1; Tue, 31 Jan 2023 02:47:24 -0500
X-MC-Unique: UXe07KNMPBaxEybl43d5Zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D507838149A9;
	Tue, 31 Jan 2023 07:47:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C3EC4175A2;
	Tue, 31 Jan 2023 07:47:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BB4F1946594;
	Tue, 31 Jan 2023 07:47:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 301DB1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 23:06:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10F4E400EAD6; Mon, 30 Jan 2023 23:06:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08D9D40C1255
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE013811E9C
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:37 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-176-Uz1T6kC8OSGnogUB3JYOGg-1; Mon,
 30 Jan 2023 18:06:36 -0500
X-MC-Unique: Uz1T6kC8OSGnogUB3JYOGg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 9F39520EA20F; Mon, 30 Jan 2023 14:58:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9F39520EA20F
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Mon, 30 Jan 2023 14:57:28 -0800
Message-Id: <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:16 +0000
Subject: [dm-devel] [RFC PATCH v9 13/16] ipe: enable support for fs-verity
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
Cc: Fan Wu <wufan@linux.microsoft.com>, dm-devel@redhat.com,
 linux-doc@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>,
 roberto.sassu@huawei.com, linux-security-module@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
 linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
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

v9:
  + Adapt to the new parser
---
 security/ipe/Kconfig         |  11 ++++
 security/ipe/audit.c         |  23 +++++++
 security/ipe/eval.c          | 112 +++++++++++++++++++++++++++++++++++
 security/ipe/eval.h          |  10 ++++
 security/ipe/hooks.c         |  30 ++++++++++
 security/ipe/hooks.h         |   7 +++
 security/ipe/ipe.c           |  13 ++++
 security/ipe/ipe.h           |   3 +
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |   8 +++
 10 files changed, 220 insertions(+)

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index 16e835ce61b0..dd9a066dd35a 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -32,6 +32,17 @@ config IPE_PROP_DM_VERITY
 
 	  If unsure, answer Y.
 
+config IPE_PROP_FS_VERITY
+	bool "Enable property for fs-verity files"
+	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
+	help
+	  This option enables the usage of properties "fsverity_signature"
+	  and "fsverity_digest". These properties evaluates to TRUE when
+	  a file is fsverity enabled and with a signed digest or its
+	  diegst matches the supplied value in the policy.
+
+	  if unsure, answer Y.
+
 endmenu
 
 endif
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 769ba95d9b0d..16d81645e53c 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -46,6 +46,11 @@ static const char *const audit_prop_names[ipe_prop_max] = {
 	"dmverity_signature=FALSE",
 	"dmverity_signature=TRUE",
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	"fsverity_digest=",
+	"fsverity_signature=FALSE",
+	"fsverity_signature=TRUE"
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 #ifdef CONFIG_IPE_PROP_DM_VERITY
@@ -64,6 +69,22 @@ static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * audit_fsv_digest - audit a digest of a fsverity file.
+ * @ab: Supplies a poniter to the audit_buffer to append to.
+ * @d: Supplies a pointer to the digest structure.
+ */
+static void audit_fsv_digest(struct audit_buffer *ab, const void *d)
+{
+	ipe_digest_audit(ab, d);
+}
+#else
+static void audit_fsv_digest(struct audit_buffer *ab, const void *d)
+{
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /**
  * audit_rule - audit an IPE policy rule approximation.
  * @ab: Supplies a poniter to the audit_buffer to append to.
@@ -79,6 +100,8 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
 		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
 		if (ptr->type == ipe_prop_dmv_roothash)
 			audit_dmv_roothash(ab, ptr->value);
+		if (ptr->type == ipe_prop_fsv_digest)
+			audit_fsv_digest(ab, ptr->value);
 
 		audit_log_format(ab, " ");
 	}
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 538af4195ba7..210d3926c0a8 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -81,6 +81,23 @@ static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *con
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * build_ipe_inode_ctx - Build inode fields of an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populdated.
+ * @ino: Supplies the inode struct of the file triggered IPE event.
+ */
+static void build_ipe_inode_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+	ctx->ino = ino;
+	ctx->ipe_inode = ipe_inode(ctx->ino);
+}
+#else
+static void build_ipe_inode_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 /**
  * build_eval_ctx - Build an evaluation context.
  * @ctx: Supplies a pointer to the context to be populdated.
@@ -99,6 +116,7 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 	if (file) {
 		ino = d_real_inode(file->f_path.dentry);
 		build_ipe_bdev_ctx(ctx, ino);
+		build_ipe_inode_ctx(ctx, ino);
 	}
 }
 
@@ -171,6 +189,91 @@ static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * evaluate_fsv_digest - Analyze @ctx against a fsv digest property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
+				struct ipe_prop *p)
+{
+	enum hash_algo alg;
+	u8 digest[FS_VERITY_MAX_DIGEST_SIZE];
+
+	if (!ctx->ino)
+		return false;
+	if (fsverity_get_digest((struct inode *)ctx->ino,
+				digest,
+				&alg)) {
+		return false;
+	}
+
+	return ipe_digest_eval(p->value,
+			       digest,
+			       hash_digest_size[alg],
+			       hash_algo_name[alg]);
+}
+
+/**
+ * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
+{
+	return !ctx->ino ||
+	       !IS_VERITY(ctx->ino) ||
+	       !ctx->ipe_inode ||
+	       !ctx->ipe_inode->fs_verity_signed;
+}
+
+/**
+ * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true - The current @ctx match the @p
+ * * false - The current @ctx doesn't match the @p
+ */
+static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return ctx->ino &&
+	       IS_VERITY(ctx->ino) &&
+	       ctx->ipe_inode &&
+	       ctx->ipe_inode->fs_verity_signed;
+}
+#else
+static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
+				struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return false;
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 /**
  * evaluate_property - Analyze @ctx against a property.
  * @ctx: Supplies a pointer to the context to be evaluated.
@@ -201,6 +304,15 @@ static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 	case ipe_prop_dmv_sig_true:
 		eval = evaluate_dmv_sig_true(ctx, p);
 		break;
+	case ipe_prop_fsv_digest:
+		eval = evaluate_fsv_digest(ctx, p);
+		break;
+	case ipe_prop_fsv_sig_false:
+		eval = evaluate_fsv_sig_false(ctx, p);
+		break;
+	case ipe_prop_fsv_sig_true:
+		eval = evaluate_fsv_sig_true(ctx, p);
+		break;
 	default:
 		eval = false;
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 4fd832c6893e..d3dce4f04cb4 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -26,6 +26,12 @@ struct ipe_bdev {
 };
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+struct ipe_inode {
+	bool fs_verity_signed;
+};
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
 
@@ -34,6 +40,10 @@ struct ipe_eval_ctx {
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 	const struct ipe_bdev *ipe_bdev;
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	const struct inode *ino;
+	const struct ipe_inode *ipe_inode;
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 enum ipe_match {
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 735375d2f858..836f08240372 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -243,3 +243,33 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 	return -EOPNOTSUPP;
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * ipe_inode_setsecurity - Sets fields of a inode security blob from @key.
+ * @inode: The inode to source the security blob from.
+ * @name: The name representing the information to be stored.
+ * @value: The value to be stored.
+ * @size: The size of @value.
+ * @flags: unused
+ *
+ * Saves fsverity signature & digest into inode security blob
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
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
+#endif /* CONFIG_CONFIG_IPE_PROP_FS_VERITY */
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 16611a149158..654aba584a44 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/fsverity.h>
 #include <linux/device-mapper.h>
 
 void ipe_sb_free_security(struct super_block *mnt_sb);
@@ -32,4 +33,10 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 			 const void *value, size_t len);
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+int ipe_inode_setsecurity(struct inode *inode, const char *name,
+			  const void *value, size_t size,
+			  int flags);
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 5612cb3cf1e5..705ce9a003de 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -13,6 +13,9 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 		.lbs_bdev = sizeof(struct ipe_bdev),
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+		.lbs_inode = sizeof(struct ipe_inode),
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 #ifdef CONFIG_IPE_PROP_DM_VERITY
@@ -22,6 +25,13 @@ struct ipe_bdev *ipe_bdev(struct block_device *b)
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+struct ipe_inode *ipe_inode(const struct inode *inode)
+{
+	return inode->i_security + ipe_blobs.lbs_inode;
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
@@ -33,6 +43,9 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
 	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
 #endif
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	LSM_HOOK_INIT(inode_setsecurity, ipe_inode_setsecurity),
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index c2594a45b8f2..138fda645ecf 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -15,5 +15,8 @@ extern bool ipe_enabled;
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 struct ipe_bdev *ipe_bdev(struct block_device *b);
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+struct ipe_inode *ipe_inode(const struct inode *inode);
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 
 #endif /* IPE_H */
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 324eb76c6067..50b8f4c49bc7 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -31,6 +31,9 @@ enum ipe_prop_type {
 	ipe_prop_dmv_roothash,
 	ipe_prop_dmv_sig_false,
 	ipe_prop_dmv_sig_true,
+	ipe_prop_fsv_digest,
+	ipe_prop_fsv_sig_false,
+	ipe_prop_fsv_sig_true,
 	ipe_prop_max
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index 50a6a763e842..799ee7fda974 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -273,6 +273,11 @@ static const match_table_t property_tokens = {
 	{ipe_prop_dmv_sig_false,	"dmverity_signature=FALSE"},
 	{ipe_prop_dmv_sig_true,		"dmverity_signature=TRUE"},
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	{ipe_prop_fsv_digest,		"fsverity_digest=%s"},
+	{ipe_prop_fsv_sig_false,	"fsverity_signature=FALSE"},
+	{ipe_prop_fsv_sig_true,		"fsverity_signature=TRUE"},
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 	{ipe_prop_max,			NULL}
 };
 
@@ -304,6 +309,7 @@ int parse_property(char *t, struct ipe_rule *r)
 
 	switch (token) {
 	case ipe_prop_dmv_roothash:
+	case ipe_prop_fsv_digest:
 		dup = match_strdup(&args[0]);
 		if (!dup) {
 			rc = -ENOMEM;
@@ -315,6 +321,8 @@ int parse_property(char *t, struct ipe_rule *r)
 	case ipe_prop_boot_verified_true:
 	case ipe_prop_dmv_sig_false:
 	case ipe_prop_dmv_sig_true:
+	case ipe_prop_fsv_sig_false:
+	case ipe_prop_fsv_sig_true:
 		p->type = token;
 		break;
 	case ipe_prop_max:
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

