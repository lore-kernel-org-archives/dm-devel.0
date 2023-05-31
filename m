Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03728C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685543332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9Dwqyu0AllYzmdlwWH1ktWJJzePExTO1IjBpI71mtiA=;
	b=d8Dqw44B1bkYcS7c62ljkP49Qt9gLQ4UfJD12JaW5TQ/yISr2YRgVmIDI+QD5xOQjTM9t8
	8oiHeTp6nIAUxT1o3t0ppsZ3j0NAq3+zdBkG5vAtDyj7BAJH7GMqayXThd1eux5hq4fNPV
	jkUoeU+njbZcU5Y8Zj+skEsw8FQaj38=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-eybC7dXFOEW-GcH6tnIEGQ-1; Wed, 31 May 2023 10:28:48 -0400
X-MC-Unique: eybC7dXFOEW-GcH6tnIEGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81D1B1C01E94;
	Wed, 31 May 2023 14:28:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C47D2166B26;
	Wed, 31 May 2023 14:28:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D68B19465B5;
	Wed, 31 May 2023 14:28:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 166421946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:54:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A521CC154D8; Wed, 31 May 2023 13:54:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D8E6C154D7
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:54:34 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81D7280331C
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:54:34 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-DvT1DxRPO666z1mJWMR7Ug-1; Wed, 31 May 2023 09:54:33 -0400
X-MC-Unique: DvT1DxRPO666z1mJWMR7Ug-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LN0-00HR49-2P; Wed, 31 May 2023 12:56:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:16 +0200
Message-Id: <20230531125535.676098-6-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 05/24] init: remove pointless Root_* values
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

Remove all unused defines, and just use the expanded versions for
the SCSI disk majors.

I've decided to keep Root_RAM0 even if it could be expanded as there
is a lot of special casing for it in the init code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/alpha/kernel/setup.c               | 2 +-
 arch/ia64/kernel/setup.c                | 2 +-
 arch/powerpc/platforms/powermac/setup.c | 3 ++-
 include/linux/root_dev.h                | 8 --------
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index 33bf3a62700270..b650ff1cb022ee 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -658,7 +658,7 @@ setup_arch(char **cmdline_p)
 #endif
 
 	/* Default root filesystem to sda2.  */
-	ROOT_DEV = Root_SDA2;
+	ROOT_DEV = MKDEV(SCSI_DISK0_MAJOR, 2);
 
 #ifdef CONFIG_EISA
 	/* FIXME:  only set this when we actually have EISA in this box? */
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index c0572804427275..becdb4f33c2195 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -627,7 +627,7 @@ setup_arch (char **cmdline_p)
 	 * is physical disk 1 partition 1 and the Linux root disk is
 	 * physical disk 1 partition 2.
 	 */
-	ROOT_DEV = Root_SDA2;		/* default to second partition on first drive */
+	ROOT_DEV = MKDEV(SCSI_DISK0_MAJOR, 2);
 
 	if (is_uv_system())
 		uv_setup(cmdline_p);
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 193cc9c394221b..0c41f4b005bcf3 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -76,7 +76,8 @@ int pmac_newworld;
 
 static int current_root_goodness = -1;
 
-#define DEFAULT_ROOT_DEVICE Root_SDA1	/* sda1 - slightly silly choice */
+/* sda1 - slightly silly choice */
+#define DEFAULT_ROOT_DEVICE	MKDEV(SCSI_DISK0_MAJOR, 1)
 
 sys_ctrler_t sys_ctrler = SYS_CTRLER_UNKNOWN;
 EXPORT_SYMBOL(sys_ctrler);
diff --git a/include/linux/root_dev.h b/include/linux/root_dev.h
index 4e78651371ba92..ed3ea8da642972 100644
--- a/include/linux/root_dev.h
+++ b/include/linux/root_dev.h
@@ -10,14 +10,6 @@ enum {
 	Root_NFS = MKDEV(UNNAMED_MAJOR, 255),
 	Root_CIFS = MKDEV(UNNAMED_MAJOR, 254),
 	Root_RAM0 = MKDEV(RAMDISK_MAJOR, 0),
-	Root_RAM1 = MKDEV(RAMDISK_MAJOR, 1),
-	Root_FD0 = MKDEV(FLOPPY_MAJOR, 0),
-	Root_HDA1 = MKDEV(IDE0_MAJOR, 1),
-	Root_HDA2 = MKDEV(IDE0_MAJOR, 2),
-	Root_SDA1 = MKDEV(SCSI_DISK0_MAJOR, 1),
-	Root_SDA2 = MKDEV(SCSI_DISK0_MAJOR, 2),
-	Root_HDC1 = MKDEV(IDE1_MAJOR, 1),
-	Root_SR0 = MKDEV(SCSI_CDROM_MAJOR, 0),
 };
 
 extern dev_t ROOT_DEV;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

