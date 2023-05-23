Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE1FC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832140;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kV2yQQCN2Srt660k4oImw+po1Ikve0He4UP/hsrp410=;
	b=LEm30ErKIJaju7kR2qqIS8y0mD+u+TkRILHqfBJKaVTrFEm/voA0HqVEKhOZidpb6c6tDK
	c06Pw6bqUUfvLd5JSWmXcK0T33PXChOVAfuM8fD3abos6cwelvE5yBDtUuZ+bZT22eaJKg
	sr45ft/ZwD23DGuDWz6+kLGC0/ei6Qo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-k2iDSrOOPYWSWO_81y5chA-1; Tue, 23 May 2023 04:55:36 -0400
X-MC-Unique: k2iDSrOOPYWSWO_81y5chA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECD2B101AA42;
	Tue, 23 May 2023 08:55:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D89512166B25;
	Tue, 23 May 2023 08:55:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C2AC419465A0;
	Tue, 23 May 2023 08:55:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 832061946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:55:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51447140E95D; Tue, 23 May 2023 08:55:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A6BF140EBB8
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:55:33 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F2368007D9
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:55:33 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-fCEj8sibOmuSnOdtBTfZeQ-1; Tue, 23 May 2023 04:55:31 -0400
X-MC-Unique: fCEj8sibOmuSnOdtBTfZeQ-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1Mig-009Gou-1r; Tue, 23 May 2023 07:46:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:23 +0200
Message-Id: <20230523074535.249802-13-hch@lst.de>
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
Subject: [dm-devel] [PATCH 12/24] init: move the nfs/cifs/ram special cases
 out of name_to_dev_t
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The nfs/cifs/ram special cass only need to be parsed once, and only in
the boot code.  Move them out of name_to_dev_t and into
prepare_namespace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index d5c06c1546e82c..86599faf2bf8a1 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -248,7 +248,6 @@ static dev_t devt_from_devnum(const char *name)
  *
  *	1) <hex_major><hex_minor> device number in hexadecimal represents itself
  *         no leading 0x, for example b302.
- *	2) /dev/nfs represents Root_NFS (0xff)
  *	3) /dev/<disk_name> represents the device number of disk
  *	4) /dev/<disk_name><decimal> represents the device number
  *         of partition - device number of disk plus the partition number
@@ -266,7 +265,6 @@ static dev_t devt_from_devnum(const char *name)
  *	   a colon.
  *	9) PARTLABEL=<name> with name being the GPT partition label.
  *	   MSDOS partitions do not support labels!
- *	10) /dev/cifs represents Root_CIFS (0xfe)
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -275,12 +273,6 @@ static dev_t devt_from_devnum(const char *name)
  */
 dev_t name_to_dev_t(const char *name)
 {
-	if (strcmp(name, "/dev/nfs") == 0)
-		return Root_NFS;
-	if (strcmp(name, "/dev/cifs") == 0)
-		return Root_CIFS;
-	if (strcmp(name, "/dev/ram") == 0)
-		return Root_RAM0;
 #ifdef CONFIG_BLOCK
 	if (strncmp(name, "PARTUUID=", 9) == 0)
 		return devt_from_partuuid(name + 9);
@@ -631,6 +623,12 @@ static dev_t __init parse_root_device(char *root_device_name)
 	if (!strncmp(root_device_name, "mtd", 3) ||
 	    !strncmp(root_device_name, "ubi", 3))
 		return Root_Generic;
+	if (strcmp(root_device_name, "/dev/nfs") == 0)
+		return Root_NFS;
+	if (strcmp(root_device_name, "/dev/cifs") == 0)
+		return Root_CIFS;
+	if (strcmp(root_device_name, "/dev/ram") == 0)
+		return Root_RAM0;
 	return name_to_dev_t(root_device_name);
 }
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

