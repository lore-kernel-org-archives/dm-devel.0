Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13261C7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 07:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686037924;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rTOzzkgS5u82OTxvi4HybJFpSBfLmV9a6JZ8lnynC88=;
	b=VrA2+mS1aJ2rZhY4uUoXUQTIZlFWy425UkWzRs/aYyyE68V1jph/6YXmQy7lr56nisubwX
	MyEnew/6PMwinaKCXxkTCPoNzAXLOMdIQ/lpw9ZkJePVEoqU4v0QL10HVmiRdiRpzziNvf
	99GFd0laO0vbJ4Pa+15W3WTIMoxx7+4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-agRVoS10M_SmbZE-Oa8V7w-1; Tue, 06 Jun 2023 03:52:02 -0400
X-MC-Unique: agRVoS10M_SmbZE-Oa8V7w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26B6F101A53B;
	Tue,  6 Jun 2023 07:52:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12A754021AA;
	Tue,  6 Jun 2023 07:52:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CEEDC19465BA;
	Tue,  6 Jun 2023 07:51:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC02719465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 07:51:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B8EF37AE4; Tue,  6 Jun 2023 07:51:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B169B9E8B
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 07:51:58 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85D01185A795
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 07:51:58 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-4pSOjc4bOvKNRB4QTW8vOg-1; Tue, 06 Jun 2023 03:51:57 -0400
X-MC-Unique: 4pSOjc4bOvKNRB4QTW8vOg-1
Received: from
 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at
 ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q6RIZ-000Ykh-1p; Tue, 06 Jun 2023 07:40:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  6 Jun 2023 09:39:25 +0200
Message-Id: <20230606073950.225178-7-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 06/31] cdrom: remove the unused mode argument to
 cdrom_release
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/cdrom/cdrom.c | 2 +-
 drivers/cdrom/gdrom.c | 2 +-
 drivers/scsi/sr.c     | 2 +-
 include/linux/cdrom.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index adebac1bd210d9..998b03fe976e22 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1250,7 +1250,7 @@ static int check_for_audio_disc(struct cdrom_device_info *cdi,
 	return 0;
 }
 
-void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
+void cdrom_release(struct cdrom_device_info *cdi)
 {
 	const struct cdrom_device_ops *cdo = cdi->ops;
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 14922403983e9e..a401dc4218a998 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -481,7 +481,7 @@ static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
 	bdev_check_media_change(bdev);
 
 	mutex_lock(&gdrom_mutex);
-	ret = cdrom_open(gd.cd_info, mode);
+	ret = cdrom_open(gd.cd_info);
 	mutex_unlock(&gdrom_mutex);
 	return ret;
 }
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 444c7efc14cba7..6d33120ee5ba85 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -512,7 +512,7 @@ static void sr_block_release(struct gendisk *disk, fmode_t mode)
 	struct scsi_cd *cd = scsi_cd(disk);
 
 	mutex_lock(&cd->lock);
-	cdrom_release(&cd->cdi, mode);
+	cdrom_release(&cd->cdi);
 	mutex_unlock(&cd->lock);
 
 	scsi_device_put(cd->device);
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 385e94732b2cf1..3f23d5239de254 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -102,7 +102,7 @@ int cdrom_read_tocentry(struct cdrom_device_info *cdi,
 
 /* the general block_device operations structure: */
 int cdrom_open(struct cdrom_device_info *cdi, fmode_t mode);
-extern void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode);
+void cdrom_release(struct cdrom_device_info *cdi);
 int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 		unsigned int cmd, unsigned long arg);
 extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

