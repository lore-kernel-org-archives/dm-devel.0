Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5ADEB64DA
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 21:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687987139;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jvk1leYqj6zXCgXNNSKXwm4kr14HNf05XwTc9Xoed1U=;
	b=FzlysvSVY8dEcWzggfuT4kSphQ+49CWqka6apT42YwJRUqA7wOfQGJhxcpzc31SUyHNCQe
	Vj2l4n8hxty68c66WivrmPJ4NIqNBsf84dHXDp1MNnVF+YDhlqb0/fjp5HoFJGYVIozIuh
	aZ8q54mJxYWdkhBxEpCWOIPZZ/U5bKA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-_705GdBqONOmpBZq8oz9yg-1; Wed, 28 Jun 2023 17:18:56 -0400
X-MC-Unique: _705GdBqONOmpBZq8oz9yg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BDB73C0FCB7;
	Wed, 28 Jun 2023 21:18:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A85C140EBB8;
	Wed, 28 Jun 2023 21:18:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F10E0194658D;
	Wed, 28 Jun 2023 21:18:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD873194658F
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Jun 2023 21:18:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C175540C206F; Wed, 28 Jun 2023 21:18:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA81A40C2063
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 21:18:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9ADAC3C0FCAA
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 21:18:43 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-463-9_ZbB6HLO_uHP5cF0KFXOQ-1; Wed,
 28 Jun 2023 17:18:41 -0400
X-MC-Unique: 9_ZbB6HLO_uHP5cF0KFXOQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 9121A20ABD78; Wed, 28 Jun 2023 14:09:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9121A20ABD78
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Wed, 28 Jun 2023 14:09:24 -0700
Message-Id: <1687986571-16823-11-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [RFC PATCH v10 10/17] block|security: add LSM blob to
 block_device
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

Some block devices have valuable security properties that is only
accessible during the creation time.

For example, when creating a dm-verity block device, the dm-verity's
roothash and roothash signature, which are extreme important security
metadata, are passed to the kernel. However, the roothash will be saved
privately in dm-verity, which prevents the seucrity subsystem to easily
access that information. Worse, the roothash signature will be discarded
after the verification, making it impossible to utilize the roothash
signature by the security subsystem.

With this patch, an LSM blob is added to the block_device structure.
This enables the security subsystem to store security-sensitive data
related to block devices within the security blob. For example, LSM can
use the new LSM blob to save the roothash signature of a dm-verity,
and LSM can make access decision based on the data inside the signature,
like the signer ceritificate.

The implementation follows the same approach used for security blobs in
other structures like struct file, struct inode, and struct superblock.
The initialization of the security blob occurs after the creation of the
struct block_device, performed by the security subsystem. Similarly, the
security blob is freed by the security subsystem before the struct
block_device is deallocated or freed.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
---
v2:
  + No Changes

v3:
  + Minor style changes from checkpatch --strict

v4:
  + No Changes

v5:
  + Allow multiple callers to call security_bdev_setsecurity

v6:
  + Simplify security_bdev_setsecurity break condition

v7:
  + Squash all dm-verity related patches to two patches,
    the additions to dm-verity/fs, and the consumption of
    the additions.

v8:
  + Split dm-verity related patches squashed in v7 to 3 commits based on
    topic:
      + New LSM hook
      + Consumption of hook outside LSM
      + Consumption of hook inside LSM.

  + change return of security_bdev_alloc / security_bdev_setsecurity
    to LSM_RET_DEFAULT instead of 0.

  + Change return code to -EOPNOTSUPP, bring inline with other
    setsecurity hooks.

v9:
  + Add Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
  + Remove unlikely when calling LSM hook
  + Make the security field dependent on CONFIG_SECURITY

v10:
  + No changes
---
 block/bdev.c                  |  7 +++
 include/linux/blk_types.h     |  3 ++
 include/linux/lsm_hook_defs.h |  5 ++
 include/linux/lsm_hooks.h     |  1 +
 include/linux/security.h      | 22 ++++++++
 security/security.c           | 99 +++++++++++++++++++++++++++++++++++
 6 files changed, 137 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index 979e28a46b98..c9b0fb228023 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -24,6 +24,7 @@
 #include <linux/pseudo_fs.h>
 #include <linux/uio.h>
 #include <linux/namei.h>
+#include <linux/security.h>
 #include <linux/part_stat.h>
 #include <linux/uaccess.h>
 #include <linux/stat.h>
@@ -318,6 +319,11 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 	memset(&ei->bdev, 0, sizeof(ei->bdev));
+
+	if (security_bdev_alloc(&ei->bdev)) {
+		kmem_cache_free(bdev_cachep, ei);
+		return NULL;
+	}
 	return &ei->vfs_inode;
 }
 
@@ -327,6 +333,7 @@ static void bdev_free_inode(struct inode *inode)
 
 	free_percpu(bdev->bd_stats);
 	kfree(bdev->bd_meta_info);
+	security_bdev_free(bdev);
 
 	if (!bdev_is_partition(bdev)) {
 		if (bdev->bd_disk && bdev->bd_disk->bdi)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 752a54e3284b..0baf5ef06a36 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -69,6 +69,9 @@ struct block_device {
 	struct partition_meta_info *bd_meta_info;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	bool			bd_make_it_fail;
+#endif
+#ifdef CONFIG_SECURITY
+	void			*security;
 #endif
 	/*
 	 * keep this out-of-line as it's both big and not needed in the fast
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 6bb55e61e8e8..c662e100c666 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -417,3 +417,8 @@ LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
 LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
 #endif /* CONFIG_IO_URING */
+
+LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
+LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
+LSM_HOOK(int, 0, bdev_setsecurity, struct block_device *bdev, const char *name,
+	 const void *value, size_t size)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index ab2b2fafa4a4..7dcf8ece024b 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -63,6 +63,7 @@ struct lsm_blob_sizes {
 	int	lbs_ipc;
 	int	lbs_msg_msg;
 	int	lbs_task;
+	int	lbs_bdev;
 };
 
 /*
diff --git a/include/linux/security.h b/include/linux/security.h
index a88076ebc7b1..f3279180766c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -482,6 +482,11 @@ int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
 int security_locked_down(enum lockdown_reason what);
+int security_bdev_alloc(struct block_device *bdev);
+void security_bdev_free(struct block_device *bdev);
+int security_bdev_setsecurity(struct block_device *bdev,
+			      const char *name, const void *value,
+			      size_t size);
 #else /* CONFIG_SECURITY */
 
 static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
@@ -1388,6 +1393,23 @@ static inline int security_locked_down(enum lockdown_reason what)
 {
 	return 0;
 }
+
+static inline int security_bdev_alloc(struct block_device *bdev)
+{
+	return 0;
+}
+
+static inline void security_bdev_free(struct block_device *bdev)
+{
+}
+
+static inline int security_bdev_setsecurity(struct block_device *bdev,
+					    const char *name,
+					    const void *value, size_t size)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_SECURITY */
 
 #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)
diff --git a/security/security.c b/security/security.c
index d5ff7ff45b77..b211c430c5ab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -30,6 +30,7 @@
 #include <linux/string.h>
 #include <linux/msg.h>
 #include <net/flow.h>
+#include <linux/fs.h>
 
 #define MAX_LSM_EVM_XATTR	2
 
@@ -212,6 +213,7 @@ static void __init lsm_set_blob_sizes(struct lsm_blob_sizes *needed)
 	lsm_set_blob_size(&needed->lbs_msg_msg, &blob_sizes.lbs_msg_msg);
 	lsm_set_blob_size(&needed->lbs_superblock, &blob_sizes.lbs_superblock);
 	lsm_set_blob_size(&needed->lbs_task, &blob_sizes.lbs_task);
+	lsm_set_blob_size(&needed->lbs_bdev, &blob_sizes.lbs_bdev);
 }
 
 /* Prepare LSM for initialization. */
@@ -378,6 +380,7 @@ static void __init ordered_lsm_init(void)
 	init_debug("msg_msg blob size    = %d\n", blob_sizes.lbs_msg_msg);
 	init_debug("superblock blob size = %d\n", blob_sizes.lbs_superblock);
 	init_debug("task blob size       = %d\n", blob_sizes.lbs_task);
+	init_debug("bdev blob size       = %d\n", blob_sizes.lbs_bdev);
 
 	/*
 	 * Create any kmem_caches needed for blobs
@@ -698,6 +701,28 @@ static int lsm_msg_msg_alloc(struct msg_msg *mp)
 	return 0;
 }
 
+/**
+ * lsm_bdev_alloc - allocate a composite block_device blob
+ * @bdev: the block_device that needs a blob
+ *
+ * Allocate the block_device blob for all the modules
+ *
+ * Returns 0, or -ENOMEM if memory can't be allocated.
+ */
+static int lsm_bdev_alloc(struct block_device *bdev)
+{
+	if (blob_sizes.lbs_bdev == 0) {
+		bdev->security = NULL;
+		return 0;
+	}
+
+	bdev->security = kzalloc(blob_sizes.lbs_bdev, GFP_KERNEL);
+	if (!bdev->security)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /**
  * lsm_early_task - during initialization allocate a composite task blob
  * @task: the task that needs a blob
@@ -5167,6 +5192,80 @@ int security_locked_down(enum lockdown_reason what)
 }
 EXPORT_SYMBOL(security_locked_down);
 
+/**
+ * security_bdev_alloc() - Allocate a block device LSM blob
+ * @bdev: block device
+ *
+ * Allocate and attach a security structure to @bdev->security.  The
+ * security field is initialized to NULL when the bdev structure is
+ * allocated.
+ *
+ * Return: Return 0 if operation was successful.
+ */
+int security_bdev_alloc(struct block_device *bdev)
+{
+	int rc = 0;
+
+	rc = lsm_bdev_alloc(bdev);
+	if (unlikely(rc))
+		return rc;
+
+	rc = call_int_hook(bdev_alloc_security, 0, bdev);
+	if (unlikely(rc))
+		security_bdev_free(bdev);
+
+	return LSM_RET_DEFAULT(bdev_alloc_security);
+}
+EXPORT_SYMBOL(security_bdev_alloc);
+
+/**
+ * security_bdev_free() - Free a block device's LSM blob
+ * @bdev: block device
+ *
+ * Deallocate the bdev security structure and set @bdev->security to NULL.
+ */
+void security_bdev_free(struct block_device *bdev)
+{
+	if (!bdev->security)
+		return;
+
+	call_void_hook(bdev_free_security, bdev);
+
+	kfree(bdev->security);
+	bdev->security = NULL;
+}
+EXPORT_SYMBOL(security_bdev_free);
+
+/**
+ * security_bdev_setsecurity() - Set a security property of a block device
+ * @bdev: block device
+ * @name: security property name
+ * @value: security property value
+ * @size: length of the property value
+ *
+ * Set the security property associated with @name for @bdev from the security
+ * property value @value. @size indicates the size of the @value in bytes.
+ * If a @name is not implemented for a hook, it should return -EOPNOTSUPP.
+ *
+ * Return: Returns 0 on success.
+ */
+int security_bdev_setsecurity(struct block_device *bdev,
+			      const char *name, const void *value,
+			      size_t size)
+{
+	int rc = 0;
+	struct security_hook_list *p;
+
+	hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, list) {
+		rc = p->hook.bdev_setsecurity(bdev, name, value, size);
+		if (rc && rc != -EOPNOTSUPP)
+			return rc;
+	}
+
+	return LSM_RET_DEFAULT(bdev_setsecurity);
+}
+EXPORT_SYMBOL(security_bdev_setsecurity);
+
 #ifdef CONFIG_PERF_EVENTS
 /**
  * security_perf_event_open() - Check if a perf event open is allowed
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

