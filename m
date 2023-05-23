Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0FDC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832385;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=axVhMfZlIPTsnOTJ/V71tfEO7ekJhhvkXm0T7311fek=;
	b=EojTg++cvkAlGTcuAph5yCpGSiUP70B3BKsfS3kuHEYTCAeoD5vr2Z8JErdI4hit6gE1B3
	LvkSJxLFP5Jn8eUr6AlvJth+b1enH61POd8ll920hOwA/tSNb06QHA0znGkxh2Xk+qaz45
	VZRmAV01cXNZFp4LTiv8fZK5WstZO2o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-qHR7kyAJOQmdyfmPnddXFw-1; Tue, 23 May 2023 04:59:41 -0400
X-MC-Unique: qHR7kyAJOQmdyfmPnddXFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEB7685A5BF;
	Tue, 23 May 2023 08:59:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD9647AF5;
	Tue, 23 May 2023 08:59:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9404719465A0;
	Tue, 23 May 2023 08:59:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 209EB1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:59:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12B82140E961; Tue, 23 May 2023 08:59:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B06E140E95D
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:59:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4DAB8007D9
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:59:38 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-Q07hvtrmPLWVtxpE6YZp5Q-1; Tue, 23 May 2023 04:59:37 -0400
X-MC-Unique: Q07hvtrmPLWVtxpE6YZp5Q-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1Mib-009Gjq-0W; Tue, 23 May 2023 07:46:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:21 +0200
Message-Id: <20230523074535.249802-11-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 10/24] init: handle ubi/mtd root mounting like
 all other root types
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Assign a Root_Generic magic value for UBI/MTD root and handle the root
mounting in mount_root like all other root types.  Besides making the
code more clear this also means that UBI/MTD root can be used together
with an initrd (not that anyone should care).

Also factor parsing of the root name into a helper now that it can
be easily done and will get more complicated with subsequent patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/root_dev.h |  1 +
 init/do_mounts.c         | 23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/root_dev.h b/include/linux/root_dev.h
index ed3ea8da642972..847c9a06101b76 100644
--- a/include/linux/root_dev.h
+++ b/include/linux/root_dev.h
@@ -9,6 +9,7 @@
 enum {
 	Root_NFS = MKDEV(UNNAMED_MAJOR, 255),
 	Root_CIFS = MKDEV(UNNAMED_MAJOR, 254),
+	Root_Generic = MKDEV(UNNAMED_MAJOR, 253),
 	Root_RAM0 = MKDEV(RAMDISK_MAJOR, 0),
 };
 
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 74cc96bffbdd71..be6d14733ba02f 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -591,6 +591,10 @@ void __init mount_root(char *root_device_name)
 	case Root_CIFS:
 		mount_cifs_root();
 		break;
+	case Root_Generic:
+		mount_root_generic(root_device_name, root_device_name,
+				   root_mountflags);
+		break;
 	case 0:
 		if (root_device_name && root_fs_names &&
 		    mount_nodev_root(root_device_name) == 0)
@@ -602,6 +606,14 @@ void __init mount_root(char *root_device_name)
 	}
 }
 
+static dev_t __init parse_root_device(char *root_device_name)
+{
+	if (!strncmp(root_device_name, "mtd", 3) ||
+	    !strncmp(root_device_name, "ubi", 3))
+		return Root_Generic;
+	return name_to_dev_t(root_device_name);
+}
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -624,15 +636,8 @@ void __init prepare_namespace(void)
 
 	md_run_setup();
 
-	if (saved_root_name[0]) {
-		if (!strncmp(saved_root_name, "mtd", 3) ||
-		    !strncmp(saved_root_name, "ubi", 3)) {
-			mount_root_generic(saved_root_name, saved_root_name,
-					   root_mountflags);
-			goto out;
-		}
-		ROOT_DEV = name_to_dev_t(saved_root_name);
-	}
+	if (saved_root_name[0])
+		ROOT_DEV = parse_root_device(saved_root_name);
 
 	if (initrd_load(saved_root_name))
 		goto out;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

