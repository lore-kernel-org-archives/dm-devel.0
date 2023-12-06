Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C360510978
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 06:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YYXiM2/s"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3b8b463c7c6so2594463b6e.3
        for <dm-devel@lists.linux.dev>; Tue, 05 Dec 2023 22:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701842796; x=1702447596; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I06elknjTKgnu51XMDSSIqaWSXzJw01Bc0WUn6qADWU=;
        b=YYXiM2/sR6ixMPk6o1aizXkSYizFqrfhbEeYdbTwewe/90tVtZEO4hiIhv5Gi6Fhow
         S8Jt5r1moyg/Ye5V/WLX9PrYuEhtTF0rcH8pEL9WYJLwYgTZ/7ZjIhc7LfYPErffyi0O
         59kXRnz8l3VPB0DNlo48SGNGlbMF2Xb92qIaq7rofQRL/BiQr2sm8XMdLszFqJLRugb3
         jBaVAJdBU1wFNvmDzFb7VCRiVr+IjoFA2dx7TJO2IqwsliLlSaw+55hUSiaQqFo7sZcY
         ba8szODD7A7CjY7Y0kDBv8tv5xXaej7cUrK7IWJh/hjo74iYCHTc5Z0HaLJLq3tPvI0Y
         TizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701842796; x=1702447596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I06elknjTKgnu51XMDSSIqaWSXzJw01Bc0WUn6qADWU=;
        b=xCERW4q5KXEkYdogmIYiWd1KcoxW4qz34G32Zvs5epgeVb/cDT92/31FwNvVUVpAb5
         +wj59pa5TcL1GDfbuJ3yC2hy3hp4pBPviClDlz8IKpEwtUGvbZuW0HHYO+iBYnhD9vLw
         +jEWeiKFlZO0/APGe81UKArdgyN1otrp9Go1Ci04bEZPZu130TiNJ6ChEmhzjHREnBh2
         R5r68Z8/IDqSif17EHz3fBkKUPMd1pSd5QyZb5OZKQS+oUle3XAS8VKfFzjZn3+h9U5A
         lH4LDsVGRITRP1OCIp27+ehhx1YRPoHh5iXfiAXL9hVwg5spQNrMMRYw16fafLQR+gi8
         P70w==
X-Gm-Message-State: AOJu0YzSz7YGMO+Qa7lK8LlVpD0R1+H1llUW+4GAK2Sc5FYH7SaGVYFO
	U4QO+thv7Ar+oPF0PFAsx4hfFg==
X-Google-Smtp-Source: AGHT+IHg46YrWrDsKyEzgLgbWMIe2JdBMh/jkxRdtDbsgeZCFkTPl/hq1LWU5hHHTCSeMwm3TFAgdw==
X-Received: by 2002:a05:6808:6507:b0:3b8:b063:5d82 with SMTP id fm7-20020a056808650700b003b8b0635d82mr684790oib.105.1701842795753;
        Tue, 05 Dec 2023 22:06:35 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id m18-20020a056a00081200b006ce64ebd2a0sm2297147pfk.99.2023.12.05.22.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 22:06:34 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rAl3I-004VOr-0C;
	Wed, 06 Dec 2023 17:06:31 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rAl3H-0000000BrVL-2XOR;
	Wed, 06 Dec 2023 17:06:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-cachefs@redhat.com,
	dhowells@redhat.com,
	gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] selinux: use dlist for isec inode list
Date: Wed,  6 Dec 2023 17:05:34 +1100
Message-ID: <20231206060629.2827226-6-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231206060629.2827226-1-david@fromorbit.com>
References: <20231206060629.2827226-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Because it's a horrible point of lock contention under heavily
concurrent directory traversals...

  - 12.14% d_instantiate
     - 12.06% security_d_instantiate
	- 12.13% selinux_d_instantiate
	   - 12.16% inode_doinit_with_dentry
	      - 15.45% _raw_spin_lock
		 - do_raw_spin_lock
		      14.68% __pv_queued_spin_lock_slowpath


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/dlock-list.h        |  9 ++++
 security/selinux/hooks.c          | 72 +++++++++++++++----------------
 security/selinux/include/objsec.h |  6 +--
 3 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/include/linux/dlock-list.h b/include/linux/dlock-list.h
index 327cb9edc7e3..7ad933b8875d 100644
--- a/include/linux/dlock-list.h
+++ b/include/linux/dlock-list.h
@@ -132,6 +132,15 @@ extern void dlock_lists_add(struct dlock_list_node *node,
 			    struct dlock_list_heads *dlist);
 extern void dlock_lists_del(struct dlock_list_node *node);
 
+static inline void
+dlock_list_del_iter(struct dlock_list_iter *iter,
+		struct dlock_list_node *node)
+{
+	WARN_ON_ONCE((iter->entry != READ_ONCE(node->head)));
+	list_del_init(&node->list);
+	WRITE_ONCE(node->head, NULL);
+}
+
 /*
  * Find the first entry of the next available list.
  */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index feda711c6b7b..0358d7c66949 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -340,26 +340,11 @@ static struct inode_security_struct *backing_inode_security(struct dentry *dentr
 static void inode_free_security(struct inode *inode)
 {
 	struct inode_security_struct *isec = selinux_inode(inode);
-	struct superblock_security_struct *sbsec;
 
 	if (!isec)
 		return;
-	sbsec = selinux_superblock(inode->i_sb);
-	/*
-	 * As not all inode security structures are in a list, we check for
-	 * empty list outside of the lock to make sure that we won't waste
-	 * time taking a lock doing nothing.
-	 *
-	 * The list_del_init() function can be safely called more than once.
-	 * It should not be possible for this function to be called with
-	 * concurrent list_add(), but for better safety against future changes
-	 * in the code, we use list_empty_careful() here.
-	 */
-	if (!list_empty_careful(&isec->list)) {
-		spin_lock(&sbsec->isec_lock);
-		list_del_init(&isec->list);
-		spin_unlock(&sbsec->isec_lock);
-	}
+	if (!list_empty(&isec->list.list))
+		dlock_lists_del(&isec->list);
 }
 
 struct selinux_mnt_opts {
@@ -547,6 +532,8 @@ static int sb_finish_set_opts(struct super_block *sb)
 	struct superblock_security_struct *sbsec = selinux_superblock(sb);
 	struct dentry *root = sb->s_root;
 	struct inode *root_inode = d_backing_inode(root);
+	struct dlock_list_iter iter;
+	struct inode_security_struct *isec, *n;
 	int rc = 0;
 
 	if (sbsec->behavior == SECURITY_FS_USE_XATTR) {
@@ -570,27 +557,28 @@ static int sb_finish_set_opts(struct super_block *sb)
 	/* Initialize the root inode. */
 	rc = inode_doinit_with_dentry(root_inode, root);
 
-	/* Initialize any other inodes associated with the superblock, e.g.
-	   inodes created prior to initial policy load or inodes created
-	   during get_sb by a pseudo filesystem that directly
-	   populates itself. */
-	spin_lock(&sbsec->isec_lock);
-	while (!list_empty(&sbsec->isec_head)) {
-		struct inode_security_struct *isec =
-				list_first_entry(&sbsec->isec_head,
-					   struct inode_security_struct, list);
+	/*
+	 * Initialize any other inodes associated with the superblock, e.g.
+	 * inodes created prior to initial policy load or inodes created during
+	 * get_sb by a pseudo filesystem that directly populates itself.
+	 */
+	init_dlock_list_iter(&iter, &sbsec->isec_head);
+	dlist_for_each_entry_safe(isec, n, &iter, list) {
 		struct inode *inode = isec->inode;
-		list_del_init(&isec->list);
-		spin_unlock(&sbsec->isec_lock);
+
+		dlock_list_del_iter(&iter, &isec->list);
+		dlock_list_unlock(&iter);
+
 		inode = igrab(inode);
 		if (inode) {
 			if (!IS_PRIVATE(inode))
 				inode_doinit_with_dentry(inode, NULL);
 			iput(inode);
 		}
-		spin_lock(&sbsec->isec_lock);
+
+		dlock_list_relock(&iter);
 	}
-	spin_unlock(&sbsec->isec_lock);
+	WARN_ON_ONCE(!dlock_lists_empty(&sbsec->isec_head));
 	return rc;
 }
 
@@ -1428,10 +1416,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		/* Defer initialization until selinux_complete_init,
 		   after the initial policy is loaded and the security
 		   server is ready to handle calls. */
-		spin_lock(&sbsec->isec_lock);
-		if (list_empty(&isec->list))
-			list_add(&isec->list, &sbsec->isec_head);
-		spin_unlock(&sbsec->isec_lock);
+		if (list_empty(&isec->list.list))
+			dlock_lists_add(&isec->list, &sbsec->isec_head);
 		goto out_unlock;
 	}
 
@@ -2548,9 +2534,10 @@ static int selinux_sb_alloc_security(struct super_block *sb)
 {
 	struct superblock_security_struct *sbsec = selinux_superblock(sb);
 
+	if (alloc_dlock_list_heads(&sbsec->isec_head))
+		return -ENOMEM;
+
 	mutex_init(&sbsec->lock);
-	INIT_LIST_HEAD(&sbsec->isec_head);
-	spin_lock_init(&sbsec->isec_lock);
 	sbsec->sid = SECINITSID_UNLABELED;
 	sbsec->def_sid = SECINITSID_FILE;
 	sbsec->mntpoint_sid = SECINITSID_UNLABELED;
@@ -2558,6 +2545,15 @@ static int selinux_sb_alloc_security(struct super_block *sb)
 	return 0;
 }
 
+static void selinux_sb_free_security(struct super_block *sb)
+{
+	struct superblock_security_struct *sbsec = selinux_superblock(sb);
+
+	if (!sbsec)
+		return;
+	free_dlock_list_heads(&sbsec->isec_head);
+}
+
 static inline int opt_len(const char *s)
 {
 	bool open_quote = false;
@@ -2841,7 +2837,7 @@ static int selinux_inode_alloc_security(struct inode *inode)
 	u32 sid = current_sid();
 
 	spin_lock_init(&isec->lock);
-	INIT_LIST_HEAD(&isec->list);
+	init_dlock_list_node(&isec->list);
 	isec->inode = inode;
 	isec->sid = SECINITSID_UNLABELED;
 	isec->sclass = SECCLASS_FILE;
@@ -2920,6 +2916,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	if (rc)
 		return rc;
 
+
 	/* Possibly defer initialization to selinux_complete_init. */
 	if (sbsec->flags & SE_SBINITIALIZED) {
 		struct inode_security_struct *isec = selinux_inode(inode);
@@ -7215,6 +7212,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 		      selinux_msg_queue_alloc_security),
 	LSM_HOOK_INIT(shm_alloc_security, selinux_shm_alloc_security),
 	LSM_HOOK_INIT(sb_alloc_security, selinux_sb_alloc_security),
+	LSM_HOOK_INIT(sb_free_security, selinux_sb_free_security),
 	LSM_HOOK_INIT(inode_alloc_security, selinux_inode_alloc_security),
 	LSM_HOOK_INIT(sem_alloc_security, selinux_sem_alloc_security),
 	LSM_HOOK_INIT(secid_to_secctx, selinux_secid_to_secctx),
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 8159fd53c3de..e0709f429c56 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -24,6 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/lsm_hooks.h>
 #include <linux/msg.h>
+#include <linux/dlock-list.h>
 #include <net/net_namespace.h>
 #include "flask.h"
 #include "avc.h"
@@ -45,7 +46,7 @@ enum label_initialized {
 
 struct inode_security_struct {
 	struct inode *inode;	/* back pointer to inode object */
-	struct list_head list;	/* list of inode_security_struct */
+	struct dlock_list_node list;	/* list of inode_security_struct */
 	u32 task_sid;		/* SID of creating task */
 	u32 sid;		/* SID of this object */
 	u16 sclass;		/* security class of this object */
@@ -67,8 +68,7 @@ struct superblock_security_struct {
 	unsigned short behavior;	/* labeling behavior */
 	unsigned short flags;		/* which mount options were specified */
 	struct mutex lock;
-	struct list_head isec_head;
-	spinlock_t isec_lock;
+	struct dlock_list_heads isec_head;
 };
 
 struct msg_security_struct {
-- 
2.42.0

