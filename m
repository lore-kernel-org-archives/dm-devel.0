Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7013AC7EE2E
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685542354;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aKcaIznEB30V4XvoFcTHeCvbSKRjis6a/PP+7B/9IQM=;
	b=ccLWgxpz/0HKb0tDI1g5AewNcz/R8D3az5hzaHc9og7xfU++LS0bhZgtcaZIBR9OqnhnNn
	fBxmmIs7A+O0PWYAJ84EgRuMt4pgR4Q/igcoRdvl4U48VNNd+NKuTD4S0jBVOHPRHk9On1
	dTFavervaf6eAAL4C99sEBNwd/K+dU8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-y609IRjEPcuQ7bted7mkhg-1; Wed, 31 May 2023 10:12:33 -0400
X-MC-Unique: y609IRjEPcuQ7bted7mkhg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80AB1801182;
	Wed, 31 May 2023 14:12:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 67FA42166B26;
	Wed, 31 May 2023 14:12:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9AB9819465A8;
	Wed, 31 May 2023 14:12:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C04BA1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:53:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61EB9421D3; Wed, 31 May 2023 13:53:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A77A421C5
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:53:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DE9C1C08782
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:53:26 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-ADrFfNgnOw6m-xz7VVIyOQ-1; Wed, 31 May 2023 09:53:24 -0400
X-MC-Unique: ADrFfNgnOw6m-xz7VVIyOQ-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LN9-00HR86-2n; Wed, 31 May 2023 12:56:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:18 +0200
Message-Id: <20230531125535.676098-8-hch@lst.de>
In-Reply-To: <20230531125535.676098-1-hch@lst.de>
References: <20230531125535.676098-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 07/24] init: refactor mount_root
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
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Provide stubs for all the lower level mount helpers, and just switch
on ROOT_DEV in the main function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c | 104 +++++++++++++++++++++++++----------------------
 1 file changed, 56 insertions(+), 48 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index a2c0baace0992c..e708b02d9d6566 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -453,15 +453,14 @@ void __init mount_root_generic(char *name, int flags)
 #define NFSROOT_TIMEOUT_MAX	30
 #define NFSROOT_RETRY_MAX	5
 
-static int __init mount_nfs_root(void)
+static void __init mount_nfs_root(void)
 {
 	char *root_dev, *root_data;
 	unsigned int timeout;
-	int try, err;
+	int try;
 
-	err = nfs_root_data(&root_dev, &root_data);
-	if (err != 0)
-		return 0;
+	if (nfs_root_data(&root_dev, &root_data))
+		goto fail;
 
 	/*
 	 * The server or network may not be ready, so try several
@@ -470,10 +469,8 @@ static int __init mount_nfs_root(void)
 	 */
 	timeout = NFSROOT_TIMEOUT_MIN;
 	for (try = 1; ; try++) {
-		err = do_mount_root(root_dev, "nfs",
-					root_mountflags, root_data);
-		if (err == 0)
-			return 1;
+		if (!do_mount_root(root_dev, "nfs", root_mountflags, root_data))
+			return;
 		if (try > NFSROOT_RETRY_MAX)
 			break;
 
@@ -483,9 +480,14 @@ static int __init mount_nfs_root(void)
 		if (timeout > NFSROOT_TIMEOUT_MAX)
 			timeout = NFSROOT_TIMEOUT_MAX;
 	}
-	return 0;
+fail:
+	pr_err("VFS: Unable to mount root fs via NFS.\n");
 }
-#endif
+#else
+static inline void mount_nfs_root(void)
+{
+}
+#endif /* CONFIG_ROOT_NFS */
 
 #ifdef CONFIG_CIFS_ROOT
 
@@ -495,22 +497,20 @@ extern int cifs_root_data(char **dev, char **opts);
 #define CIFSROOT_TIMEOUT_MAX	30
 #define CIFSROOT_RETRY_MAX	5
 
-static int __init mount_cifs_root(void)
+static void __init mount_cifs_root(void)
 {
 	char *root_dev, *root_data;
 	unsigned int timeout;
-	int try, err;
+	int try;
 
-	err = cifs_root_data(&root_dev, &root_data);
-	if (err != 0)
-		return 0;
+	if (cifs_root_data(&root_dev, &root_data))
+		goto fail;
 
 	timeout = CIFSROOT_TIMEOUT_MIN;
 	for (try = 1; ; try++) {
-		err = do_mount_root(root_dev, "cifs", root_mountflags,
-				    root_data);
-		if (err == 0)
-			return 1;
+		if (!do_mount_root(root_dev, "cifs", root_mountflags,
+				   root_data))
+			return;
 		if (try > CIFSROOT_RETRY_MAX)
 			break;
 
@@ -519,9 +519,14 @@ static int __init mount_cifs_root(void)
 		if (timeout > CIFSROOT_TIMEOUT_MAX)
 			timeout = CIFSROOT_TIMEOUT_MAX;
 	}
-	return 0;
+fail:
+	pr_err("VFS: Unable to mount root fs via SMB.\n");
 }
-#endif
+#else
+static inline void mount_cifs_root(void)
+{
+}
+#endif /* CONFIG_CIFS_ROOT */
 
 static bool __init fs_is_nodev(char *fstype)
 {
@@ -563,35 +568,38 @@ static int __init mount_nodev_root(void)
 	return err;
 }
 
-void __init mount_root(void)
-{
-#ifdef CONFIG_ROOT_NFS
-	if (ROOT_DEV == Root_NFS) {
-		if (!mount_nfs_root())
-			printk(KERN_ERR "VFS: Unable to mount root fs via NFS.\n");
-		return;
-	}
-#endif
-#ifdef CONFIG_CIFS_ROOT
-	if (ROOT_DEV == Root_CIFS) {
-		if (!mount_cifs_root())
-			printk(KERN_ERR "VFS: Unable to mount root fs via SMB.\n");
-		return;
-	}
-#endif
-	if (ROOT_DEV == 0 && root_device_name && root_fs_names) {
-		if (mount_nodev_root() == 0)
-			return;
-	}
 #ifdef CONFIG_BLOCK
-	{
-		int err = create_dev("/dev/root", ROOT_DEV);
+static void __init mount_block_root(void)
+{
+	int err = create_dev("/dev/root", ROOT_DEV);
+
+	if (err < 0)
+		pr_emerg("Failed to create /dev/root: %d\n", err);
+	mount_root_generic("/dev/root", root_mountflags);
+}
+#else
+static inline void mount_block_root(void)
+{
+}
+#endif /* CONFIG_BLOCK */
 
-		if (err < 0)
-			pr_emerg("Failed to create /dev/root: %d\n", err);
-		mount_root_generic("/dev/root", root_mountflags);
+void __init mount_root(void)
+{
+	switch (ROOT_DEV) {
+	case Root_NFS:
+		mount_nfs_root();
+		break;
+	case Root_CIFS:
+		mount_cifs_root();
+		break;
+	case 0:
+		if (root_device_name && root_fs_names && mount_nodev_root() == 0)
+			break;
+		fallthrough;
+	default:
+		mount_block_root();
+		break;
 	}
-#endif
 }
 
 /*
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

