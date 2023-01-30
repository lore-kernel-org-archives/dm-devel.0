Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFAFC636CC
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151585;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Vp2Ml6RClQSLRJ/vEb7UdsQZLfjS+vPudC/7AFsS92Y=;
	b=eXoBCOOSGZlL1adv1p3IsZeqylLbobDbZOyQAsVxJEGQmswkehKrToKfRR8+tmWe7mu5su
	XDicJwuM3lSVDFr2izVW0rFitd9pfU0phul9KZc36S4EdlelBN6XUOx7un9uZ7N5iyG3G9
	u8+c0GgjR4HTfSJrqM8A2WrmRaW2aUc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-v9Ho-pPYP42HtvRy8-Kmqg-1; Tue, 31 Jan 2023 02:53:02 -0500
X-MC-Unique: v9Ho-pPYP42HtvRy8-Kmqg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E31763C0D1B3;
	Tue, 31 Jan 2023 07:52:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE0772166B41;
	Tue, 31 Jan 2023 07:52:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9C3A819465B1;
	Tue, 31 Jan 2023 07:52:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A4CC1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 23:06:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 70E36492B05; Mon, 30 Jan 2023 23:06:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69DEA492B06
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E3FB85A588
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:42 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-547-6K5gYtbTM662hjhIj0o5Ug-1; Mon,
 30 Jan 2023 18:06:36 -0500
X-MC-Unique: 6K5gYtbTM662hjhIj0o5Ug-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 91C1820EA209; Mon, 30 Jan 2023 14:58:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 91C1820EA209
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Mon, 30 Jan 2023 14:57:27 -0800
Message-Id: <1675119451-23180-13-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:17 +0000
Subject: [dm-devel] [RFC PATCH v9 12/16] fsverity: consume builtin signature
 via LSM hook
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

fsverity represents a mechanism to support both integrity and
authenticity protection of a file, supporting both signed and unsigned
digests.

An LSM which controls access to a resource based on authenticity and
integrity of said resource, can then use this data to make an informed
decision on the authorization (provided by the LSM's policy) of said
claim.

This effectively allows the extension of a policy enforcement layer in
LSM for fsverity, allowing for more granular control of how a
particular authenticity claim can be used. For example, "all (built-in)
signed fsverity files should be allowed to execute, but only these
hashes are allowed to be loaded as kernel modules".

This enforcement must be done in kernel space, as a userspace only
solution would fail a simple litmus test: Download a self-contained
malicious binary that never touches the userspace stack. This
binary would still be able to execute.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
v1-v6:
  + Not present

v7:
  Introduced

v8:
  + Split fs/verity/ changes and security/ changes into separate patches
  + Change signature of fsverity_create_info to accept non-const inode
  + Change signature of fsverity_verify_signature to accept non-const inode
  + Don't cast-away const from inode.
  + Digest functionality dropped in favor of:
    ("fs-verity: define a function to return the integrity protected
      file digest")
  + Reworded commit description and title to match changes.
  + Fix a bug wherein no LSM implements the particular fsverity @name
    (or LSM is disabled), and returns -EOPNOTSUPP, causing errors.

v9:
  + No changes
---
 fs/verity/fsverity_private.h |  2 +-
 fs/verity/open.c             | 13 ++++++++++++-
 fs/verity/signature.c        |  1 +
 include/linux/fsverity.h     |  2 ++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index c7fcb855e068..3194a1f4a705 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -117,7 +117,7 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 				     unsigned int log_blocksize,
 				     const u8 *salt, size_t salt_size);
 
-struct fsverity_info *fsverity_create_info(const struct inode *inode,
+struct fsverity_info *fsverity_create_info(struct inode *inode,
 					   struct fsverity_descriptor *desc);
 
 void fsverity_set_info(struct inode *inode, struct fsverity_info *vi);
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 81ff94442f7b..7e6fa52c0e9c 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -7,7 +7,9 @@
 
 #include "fsverity_private.h"
 
+#include <linux/security.h>
 #include <linux/slab.h>
+#include <crypto/public_key.h>
 
 static struct kmem_cache *fsverity_info_cachep;
 
@@ -146,7 +148,7 @@ static int compute_file_digest(struct fsverity_hash_alg *hash_alg,
  * appended signature), and check the signature if present.  The
  * fsverity_descriptor must have already undergone basic validation.
  */
-struct fsverity_info *fsverity_create_info(const struct inode *inode,
+struct fsverity_info *fsverity_create_info(struct inode *inode,
 					   struct fsverity_descriptor *desc)
 {
 	struct fsverity_info *vi;
@@ -182,6 +184,15 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 
 	err = fsverity_verify_signature(vi, desc->signature,
 					le32_to_cpu(desc->sig_size));
+	if (err) {
+		fsverity_err(inode, "Error %d verifying signature", err);
+		goto out;
+	}
+
+	err = security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME, desc->signature,
+					 le32_to_cpu(desc->sig_size), 0);
+	if (err == -EOPNOTSUPP)
+		err = 0;
 out:
 	if (err) {
 		fsverity_free_info(vi);
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..5d7b9496f9c4 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -9,6 +9,7 @@
 
 #include <linux/cred.h>
 #include <linux/key.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/verification.h>
 
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 40f14e5fed9d..29e9888287ba 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -254,4 +254,6 @@ static inline bool fsverity_active(const struct inode *inode)
 	return fsverity_get_info(inode) != NULL;
 }
 
+#define FS_VERITY_INODE_SEC_NAME "fsverity.inode-info"
+
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

