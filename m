Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FED6C7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832377;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B00AMUhQPI3JMOwjIIndMzVzWMpdGkHqvMcpmIs1UTY=;
	b=gXqJw4yTrzl69qvLCyDL5Gl1zCc8gFKcjJSUBIzykLM2p0M92YxWQt3w2sToNOT+MU8YMb
	tNtH18mj3HXLKLoUmNDesh5npO150t7NaMEwsximUSdRl12YwSOB8FyRtyz50DXteFmqF9
	YYLhkc51vHvXKQ6c7s33K7k+XM/6IH4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-bvzunFAsNPquMcsaKHrVNQ-1; Tue, 23 May 2023 04:59:33 -0400
X-MC-Unique: bvzunFAsNPquMcsaKHrVNQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44619380260B;
	Tue, 23 May 2023 08:59:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 33A19140E95D;
	Tue, 23 May 2023 08:59:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB05119465A0;
	Tue, 23 May 2023 08:59:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9214B1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:59:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 418AA200AE6F; Tue, 23 May 2023 08:59:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A317202696C
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:59:30 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E89729ABA17
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:59:30 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-dxJX7PR2NfOUcOj66_JV4Q-1; Tue, 23 May 2023 04:59:21 -0400
X-MC-Unique: dxJX7PR2NfOUcOj66_JV4Q-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1MiQ-009GZc-0j; Tue, 23 May 2023 07:45:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:17 +0200
Message-Id: <20230523074535.249802-7-hch@lst.de>
In-Reply-To: <20230523074535.249802-1-hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 06/24] init: rename mount_block_root to
 mount_root_generic
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

mount_block_root is also used to mount non-block file systems, so give
it a better name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c        | 6 +++---
 init/do_mounts.h        | 2 +-
 init/do_mounts_initrd.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 2fe7901b5bcfaf..a2c0baace0992c 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -391,7 +391,7 @@ static int __init do_mount_root(const char *name, const char *fs,
 	return ret;
 }
 
-void __init mount_block_root(char *name, int flags)
+void __init mount_root_generic(char *name, int flags)
 {
 	struct page *page = alloc_page(GFP_KERNEL);
 	char *fs_names = page_address(page);
@@ -589,7 +589,7 @@ void __init mount_root(void)
 
 		if (err < 0)
 			pr_emerg("Failed to create /dev/root: %d\n", err);
-		mount_block_root("/dev/root", root_mountflags);
+		mount_root_generic("/dev/root", root_mountflags);
 	}
 #endif
 }
@@ -620,7 +620,7 @@ void __init prepare_namespace(void)
 		root_device_name = saved_root_name;
 		if (!strncmp(root_device_name, "mtd", 3) ||
 		    !strncmp(root_device_name, "ubi", 3)) {
-			mount_block_root(root_device_name, root_mountflags);
+			mount_root_generic(root_device_name, root_mountflags);
 			goto out;
 		}
 		ROOT_DEV = name_to_dev_t(root_device_name);
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 7a29ac3e427bab..33623025f6951a 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -10,7 +10,7 @@
 #include <linux/root_dev.h>
 #include <linux/init_syscalls.h>
 
-void  mount_block_root(char *name, int flags);
+void  mount_root_generic(char *name, int flags);
 void  mount_root(void);
 extern int root_mountflags;
 
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 34731241377d30..686d1ff3af4bb1 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -95,7 +95,7 @@ static void __init handle_initrd(void)
 	real_root_dev = new_encode_dev(ROOT_DEV);
 	create_dev("/dev/root.old", Root_RAM0);
 	/* mount initrd on rootfs' /root */
-	mount_block_root("/dev/root.old", root_mountflags & ~MS_RDONLY);
+	mount_root_generic("/dev/root.old", root_mountflags & ~MS_RDONLY);
 	init_mkdir("/old", 0700);
 	init_chdir("/old");
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

