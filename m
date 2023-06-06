Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B284C7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 07:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686037910;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ljwHkQ6KRAedhHAre7a6iRIcwVwH8lqMzOPwr19iyZo=;
	b=GVf9oCs+9nozk8yOhuMpKa5JKsqRIV/+5hCkLbH2kPaxzCEDHX/5v3N3yIj34ix0Jl2YKs
	0HOY2SdbUX+8brrTuEN24Fwo2ckg0TQJB7/HnhIftsFCoypool9fP7mXagRv7PyASFoAhN
	35xWyRVrDkNFpp+yftvejGZvbzzWHJA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-Csj20IjXMjKlnDF8Qd8sbQ-1; Tue, 06 Jun 2023 03:51:46 -0400
X-MC-Unique: Csj20IjXMjKlnDF8Qd8sbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9270B3802124;
	Tue,  6 Jun 2023 07:51:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8C07C1603B;
	Tue,  6 Jun 2023 07:51:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF10519465B9;
	Tue,  6 Jun 2023 07:51:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1FF61946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 07:51:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 681DE40D1B66; Tue,  6 Jun 2023 07:51:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6037F40D1B69
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 07:51:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 370438027F5
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 07:51:39 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-J8RZCL_BO8601GkInQTEtQ-1; Tue, 06 Jun 2023 03:51:37 -0400
X-MC-Unique: J8RZCL_BO8601GkInQTEtQ-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q6RIN-000Yal-0r; Tue, 06 Jun 2023 07:39:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  6 Jun 2023 09:39:21 +0200
Message-Id: <20230606073950.225178-3-hch@lst.de>
In-Reply-To: <20230606073950.225178-1-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 02/31] cdrom: remove the unused bdev argument to
 cdrom_open
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
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/cdrom/cdrom.c | 3 +--
 drivers/cdrom/gdrom.c | 2 +-
 drivers/scsi/sr.c     | 2 +-
 include/linux/cdrom.h | 3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 416f723a2dbb33..e3eab319cb0474 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1155,8 +1155,7 @@ int open_for_data(struct cdrom_device_info *cdi)
  * is in their own interest: device control becomes a lot easier
  * this way.
  */
-int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
-	       fmode_t mode)
+int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode)
 {
 	int ret;
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index ceded5772aac6d..eaa2d5a90bc82f 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -481,7 +481,7 @@ static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
 	bdev_check_media_change(bdev);
 
 	mutex_lock(&gdrom_mutex);
-	ret = cdrom_open(gd.cd_info, bdev, mode);
+	ret = cdrom_open(gd.cd_info, mode);
 	mutex_unlock(&gdrom_mutex);
 	return ret;
 }
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 12869e6d4ebda8..61b83880e395a4 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -498,7 +498,7 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 		sr_revalidate_disk(cd);
 
 	mutex_lock(&cd->lock);
-	ret = cdrom_open(&cd->cdi, bdev, mode);
+	ret = cdrom_open(&cd->cdi, mode);
 	mutex_unlock(&cd->lock);
 
 	scsi_autopm_put_device(sdev);
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 67caa909e3e615..cc5717cb0fa8a8 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -101,8 +101,7 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
 		struct cdrom_tocentry *entry);
 
 /* the general block_device operations structure: */
-extern int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
-			fmode_t mode);
+int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
 extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
 extern int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 		       fmode_t mode, unsigned int cmd, unsigned long arg);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

