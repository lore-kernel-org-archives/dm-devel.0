Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE8EE936EA
	for <dm-devel@archiver.kernel.org>; Wed,  4 Oct 2023 22:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696457745;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OjsWtbpFLAq21zikicwBIPZ0giRUurauUvgwGN1KH/w=;
	b=R3wIFKzXc7fWYwlLs3pLVTm/eu16b777ThJTDuYebWqSbNZaUGvKYf0AFxHjdkKwmf/kp/
	0HXBwYgGBMtpcapHgmQS/hmPgTcGn3jHm3Ohk+AmBSbcBBu7nFgBPsF8gTqHl41bDyPtxD
	E9j0Q/fY4fgTbwJP/jcyyOaS7DlP9CE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-7ckE03ZfPc-jLzBGRTnAoQ-1; Wed, 04 Oct 2023 18:15:36 -0400
X-MC-Unique: 7ckE03ZfPc-jLzBGRTnAoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50C36185A78E;
	Wed,  4 Oct 2023 22:15:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 395B0C15BB8;
	Wed,  4 Oct 2023 22:15:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 146CF19465B7;
	Wed,  4 Oct 2023 22:15:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 503671946597
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 Oct 2023 22:15:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B93340C6EC0; Wed,  4 Oct 2023 22:15:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32DCB40C6EA8
 for <dm-devel@redhat.com>; Wed,  4 Oct 2023 22:15:33 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11417185A78E
 for <dm-devel@redhat.com>; Wed,  4 Oct 2023 22:15:33 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-509-evIT_bBmMTGT2bYjh3vuzQ-1; Wed,
 04 Oct 2023 18:15:10 -0400
X-MC-Unique: evIT_bBmMTGT2bYjh3vuzQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 6BFDF20B74CA; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6BFDF20B74CA
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Wed,  4 Oct 2023 15:09:32 -0700
Message-Id: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [RFC PATCH v11 05/19] ipe: introduce 'boot_verified' as
 a trust provider
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
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

When the "pinned" device is unmounted, it will be "unpinned" and
`boot_verified` property will always evaluate to false afterward.

We use a pointer with a spin_lock to "pin" the device instead of rcu
because rcu synchronization may sleep, which is not allowed when
unmounting a device.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
  +No Changes

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
  + Reword and refactor patch 04/12 to [09/16], based on changes in the underlying system.
  + Add common audit function for boolean values
  + Use common audit function as implementation.

v8:
  + No changes

v9:
  + No changes

v10:
  + Replace struct file with struct super_block

v11:
  + Fix code style issues
---
 security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
 security/ipe/eval.h          |  2 +
 security/ipe/hooks.c         | 12 ++++++
 security/ipe/hooks.h         |  2 +
 security/ipe/ipe.c           |  1 +
 security/ipe/policy.h        |  2 +
 security/ipe/policy_parser.c | 35 +++++++++++++++++-
 7 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 8a8bcc5c7d7f..bdac4abc0ddb 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -9,6 +9,7 @@
 #include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock.h>
 
 #include "ipe.h"
 #include "eval.h"
@@ -16,6 +17,44 @@
 
 struct ipe_policy __rcu *ipe_active_policy;
 
+static const struct super_block *pinned_sb;
+static DEFINE_SPINLOCK(pin_lock);
+#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+
+/**
+ * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
+ * @sb: Supplies a super_block structure to be pinned.
+ */
+static void pin_sb(const struct super_block *sb)
+{
+	if (!sb)
+		return;
+	spin_lock(&pin_lock);
+	if (!pinned_sb)
+		pinned_sb = sb;
+	spin_unlock(&pin_lock);
+}
+
+/**
+ * from_pinned - Determine whether @sb is the pinned super_block.
+ * @sb: Supplies a super_block to check against the pinned super_block.
+ *
+ * Return:
+ * * true	- @sb is the pinned super_block
+ * * false	- @sb is not the pinned super_block
+ */
+static bool from_pinned(const struct super_block *sb)
+{
+	bool rv;
+
+	if (!sb)
+		return false;
+	spin_lock(&pin_lock);
+	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == sb;
+	spin_unlock(&pin_lock);
+	return rv;
+}
+
 /**
  * build_eval_ctx - Build an evaluation context.
  * @ctx: Supplies a pointer to the context to be populdated.
@@ -26,8 +65,14 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 		    const struct file *file,
 		    enum ipe_op_type op)
 {
+	if (op == IPE_OP_EXEC && file)
+		pin_sb(FILE_SUPERBLOCK(file));
+
 	ctx->file = file;
 	ctx->op = op;
+
+	if (file)
+		ctx->from_init_sb = from_pinned(FILE_SUPERBLOCK(file));
 }
 
 /**
@@ -42,7 +87,14 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 			      struct ipe_prop *p)
 {
-	return false;
+	switch (p->type) {
+	case IPE_PROP_BOOT_VERIFIED_FALSE:
+		return !ctx->from_init_sb;
+	case IPE_PROP_BOOT_VERIFIED_TRUE:
+		return ctx->from_init_sb;
+	default:
+		return false;
+	}
 }
 
 /**
@@ -108,3 +160,21 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 
 	return 0;
 }
+
+/**
+ * ipe_invalidate_pinned_sb - invalidate the ipe pinned super_block.
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
+	if (mnt_sb == pinned_sb)
+		pinned_sb = ERR_PTR(-EIO);
+
+	spin_unlock(&pin_lock);
+}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index cfdf3c8dfe8a..9769da42c65f 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -19,9 +19,11 @@ struct ipe_eval_ctx {
 	enum ipe_op_type op;
 
 	const struct file *file;
+	bool from_init_sb;
 };
 
 void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
 int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
 
 #endif /* _IPE_EVAL_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 6164a9b53361..e9386762a597 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -181,3 +181,15 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
 	build_eval_ctx(&ctx, NULL, op);
 	return ipe_evaluate_event(&ctx);
 }
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
index 23205452f758..ac0cdfd9877f 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -22,4 +22,6 @@ int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
 
 int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
+void ipe_sb_free_security(struct super_block *mnt_sb);
+
 #endif /* _IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 77c950459810..06da94a58aba 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -15,6 +15,7 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
 	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
 	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
+	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 };
 
 /**
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 77aa91f2b953..45704465dc01 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -30,6 +30,8 @@ enum ipe_action_type {
 #define IPE_ACTION_INVALID __IPE_ACTION_MAX
 
 enum ipe_prop_type {
+	IPE_PROP_BOOT_VERIFIED_FALSE,
+	IPE_PROP_BOOT_VERIFIED_TRUE,
 	__IPE_PROP_MAX
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index c09458bd348d..ee7646de72ed 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -265,6 +265,12 @@ static enum ipe_action_type parse_action(char *t)
 	return match_token(t, action_tokens, args);
 }
 
+static const match_table_t property_tokens = {
+	{IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
+	{IPE_PROP_BOOT_VERIFIED_TRUE,	"boot_verified=TRUE"},
+	{IPE_PROP_INVALID,		NULL}
+};
+
 /**
  * parse_property - Parse the property type given a token string.
  * @t: Supplies the token string to be parsed.
@@ -277,7 +283,34 @@ static enum ipe_action_type parse_action(char *t)
  */
 static int parse_property(char *t, struct ipe_rule *r)
 {
-	return -EBADMSG;
+	substring_t args[MAX_OPT_ARGS];
+	struct ipe_prop *p = NULL;
+	int rc = 0;
+	int token;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	token = match_token(t, property_tokens, args);
+
+	switch (token) {
+	case IPE_PROP_BOOT_VERIFIED_FALSE:
+	case IPE_PROP_BOOT_VERIFIED_TRUE:
+		p->type = token;
+		break;
+	default:
+		rc = -EBADMSG;
+		break;
+	}
+	if (rc)
+		goto err;
+	list_add_tail(&p->next, &r->props);
+
+	return rc;
+err:
+	kfree(p);
+	return rc;
 }
 
 /**
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

