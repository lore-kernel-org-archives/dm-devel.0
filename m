Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB2EC8300C
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120542;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EobbA9K+Uq1D7lijMRx4y8zMebTgQWSBIRlmNSvaPRc=;
	b=CBXKwOTbNzx1DnnbmvkG8+/VIBgdy2p1BCDXWAFeZzGkx3KqbbzdpgtN+kNK14ssbldMDU
	Yfdtig1ntnbE7sH+MweouxOXF27TUVxTFfnPCpx9xt6zNiGPQMt8ATRgt8AUjT1DisQ9Da
	1K+mQrNvfFaxqgz5dw8zmsFwdRz+u0o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-7zxF9iKDNxSYDjDIwqNS7A-1; Wed, 07 Jun 2023 02:49:00 -0400
X-MC-Unique: 7zxF9iKDNxSYDjDIwqNS7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A879B1C02D26;
	Wed,  7 Jun 2023 06:48:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95C5D40E6A43;
	Wed,  7 Jun 2023 06:48:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DAB84193F519;
	Wed,  7 Jun 2023 06:48:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4FE2E19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 03:34:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C125477F61; Wed,  7 Jun 2023 03:34:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3488F403367
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 03:34:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16D69101A52C
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 03:34:03 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr
 [80.12.242.22]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-122-ZU1t7IoUPBicatrFNOoVuA-1; Tue, 06 Jun 2023 23:34:01 -0400
X-MC-Unique: ZU1t7IoUPBicatrFNOoVuA-1
Received: from pop-os.home ([86.243.2.178]) by smtp.orange.fr with ESMTPA
 id 6joaqCNZMZvWO6joaq99Zz; Wed, 07 Jun 2023 05:26:29 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 07 Jun 2023 05:26:29 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Wed,  7 Jun 2023 05:26:27 +0200
Message-Id: <9014ccd13d83e9f78bfa86811a8012784333af56.1686108356.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:48:52 +0000
Subject: [dm-devel] [PATCH] dm/zone: Use the bitmap API to allocate bitmaps
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
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wanadoo.fr
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/md/dm-zone.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 4b82b7798ce4..16776ad3794b 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -140,9 +140,9 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
 void dm_cleanup_zoned_dev(struct mapped_device *md)
 {
 	if (md->disk) {
-		kfree(md->disk->conv_zones_bitmap);
+		bitmap_free(md->disk->conv_zones_bitmap);
 		md->disk->conv_zones_bitmap = NULL;
-		kfree(md->disk->seq_zones_wlock);
+		bitmap_free(md->disk->seq_zones_wlock);
 		md->disk->seq_zones_wlock = NULL;
 	}
 
@@ -182,9 +182,8 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
 	switch (zone->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
 		if (!disk->conv_zones_bitmap) {
-			disk->conv_zones_bitmap =
-				kcalloc(BITS_TO_LONGS(disk->nr_zones),
-					sizeof(unsigned long), GFP_NOIO);
+			disk->conv_zones_bitmap = bitmap_zalloc(disk->nr_zones,
+								GFP_NOIO);
 			if (!disk->conv_zones_bitmap)
 				return -ENOMEM;
 		}
@@ -193,9 +192,8 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:
 		if (!disk->seq_zones_wlock) {
-			disk->seq_zones_wlock =
-				kcalloc(BITS_TO_LONGS(disk->nr_zones),
-					sizeof(unsigned long), GFP_NOIO);
+			disk->seq_zones_wlock = bitmap_zalloc(disk->nr_zones,
+							      GFP_NOIO);
 			if (!disk->seq_zones_wlock)
 				return -ENOMEM;
 		}
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

