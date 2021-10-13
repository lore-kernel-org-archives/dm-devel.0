Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B170C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:16:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27322611CA
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 27322611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-YRlPsfUJP5mbOrur9k1buw-1; Wed, 13 Oct 2021 15:16:06 -0400
X-MC-Unique: YRlPsfUJP5mbOrur9k1buw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 924411B18BEB;
	Wed, 13 Oct 2021 19:16:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D02319EF9;
	Wed, 13 Oct 2021 19:16:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 610994E58E;
	Wed, 13 Oct 2021 19:16:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJD3aR018764 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:13:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 97C8B2166B2D; Wed, 13 Oct 2021 19:13:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D9212166B25
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ACE61857F02
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:03 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-366-nVx273kAPxmHL2sinYaXKQ-1;
	Wed, 13 Oct 2021 15:12:58 -0400
X-MC-Unique: nVx273kAPxmHL2sinYaXKQ-1
Received: from
	linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
	(linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6AFE820B9D08;
	Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6AFE820B9D08
From: deven.desai@linux.microsoft.com
To: corbet@lwn.net, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Date: Wed, 13 Oct 2021 12:06:31 -0700
Message-Id: <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
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
Subject: [dm-devel] [RFC PATCH v7 12/16] fsverity|security: add security
	hooks to fsverity digest and signature
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Fan Wu <wufan@linux.microsoft.com>

Add security_inode_setsecurity to fsverity signature verification.
This can let LSMs save the signature data and digest hashes provided
by fsverity.

Also changes the implementaion inside the hook function to let
multiple LSMs can add hooks.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
 fs/verity/open.c         | 12 ++++++++++++
 fs/verity/signature.c    |  5 ++++-
 include/linux/fsverity.h |  3 +++
 security/ipe/hooks.c     |  1 +
 security/security.c      |  6 +++---
 5 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 92df87f5fa38..1f36dae01c22 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -7,6 +7,7 @@
 
 #include "fsverity_private.h"
 
+#include <linux/security.h>
 #include <linux/slab.h>
 
 static struct kmem_cache *fsverity_info_cachep;
@@ -177,6 +178,17 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 		fsverity_err(inode, "Error %d computing file digest", err);
 		goto out;
 	}
+
+	err = security_inode_setsecurity((struct inode *)inode,
+					 FS_VERITY_DIGEST_SEC_NAME,
+					 vi->file_digest,
+					 vi->tree_params.hash_alg->digest_size,
+					 0);
+	if (err) {
+		fsverity_err(inode, "Error %d inode setsecurity hook", err);
+		goto out;
+	}
+
 	pr_debug("Computed file digest: %s:%*phN\n",
 		 vi->tree_params.hash_alg->name,
 		 vi->tree_params.digest_size, vi->file_digest);
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..20e585d5fa6d 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -9,6 +9,7 @@
 
 #include <linux/cred.h>
 #include <linux/key.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/verification.h>
 
@@ -84,7 +85,9 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 
 	pr_debug("Valid signature for file digest %s:%*phN\n",
 		 hash_alg->name, hash_alg->digest_size, vi->file_digest);
-	return 0;
+	return security_inode_setsecurity((struct inode *)inode,
+					FS_VERITY_SIGNATURE_SEC_NAME,
+					signature, sig_size, 0);
 }
 
 #ifdef CONFIG_SYSCTL
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index b568b3c7d095..dfd7b5a85c67 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -233,4 +233,7 @@ static inline bool fsverity_active(const struct inode *inode)
 	return fsverity_get_info(inode) != NULL;
 }
 
+#define FS_VERITY_SIGNATURE_SEC_NAME "fsverity.verity-sig"
+#define FS_VERITY_DIGEST_SEC_NAME "fsverity.verity-digest"
+
 #endif	/* _LINUX_FSVERITY_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 470fb48e490c..d76e60a3f511 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -232,6 +232,7 @@ void ipe_bdev_free_security(struct block_device *bdev)
 	struct ipe_bdev *blob = ipe_bdev(bdev);
 
 	kfree(blob->sigdata);
+	kfree(blob->hash);
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index d7ac9f01500b..81751a91f438 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1462,7 +1462,7 @@ int security_inode_getsecurity(struct user_namespace *mnt_userns,
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
 {
 	struct security_hook_list *hp;
-	int rc;
+	int rc = LSM_RET_DEFAULT(inode_setsecurity);
 
 	if (unlikely(IS_PRIVATE(inode)))
 		return LSM_RET_DEFAULT(inode_setsecurity);
@@ -1472,10 +1472,10 @@ int security_inode_setsecurity(struct inode *inode, const char *name, const void
 	hlist_for_each_entry(hp, &security_hook_heads.inode_setsecurity, list) {
 		rc = hp->hook.inode_setsecurity(inode, name, value, size,
 								flags);
-		if (rc != LSM_RET_DEFAULT(inode_setsecurity))
+		if (rc && rc != LSM_RET_DEFAULT(inode_setsecurity))
 			return rc;
 	}
-	return LSM_RET_DEFAULT(inode_setsecurity);
+	return rc;
 }
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

