Return-Path: <SRS0=Qr9I=M3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DADC4338F
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:44:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B02A460F58
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 09:44:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B02A460F58
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-qwmR1MnFPaqQICj2lFSfrg-1; Wed, 04 Aug 2021 05:44:04 -0400
X-MC-Unique: qwmR1MnFPaqQICj2lFSfrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6200A107ACF5;
	Wed,  4 Aug 2021 09:43:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14828226E9;
	Wed,  4 Aug 2021 09:43:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1D3274BB7C;
	Wed,  4 Aug 2021 09:43:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1749hp85006059 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Aug 2021 05:43:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A0113EAFA3; Wed,  4 Aug 2021 09:43:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 995A3EAFA2
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:43:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEB978CA944
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:43:47 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-286-xjxY6c5KMy6iNUYAh7WYWQ-1; Wed, 04 Aug 2021 05:43:44 -0400
X-MC-Unique: xjxY6c5KMy6iNUYAh7WYWQ-1
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mBDQV-005e1O-HS; Wed, 04 Aug 2021 09:43:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Wed,  4 Aug 2021 11:41:41 +0200
Message-Id: <20210804094147.459763-3-hch@lst.de>
In-Reply-To: <20210804094147.459763-1-hch@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 2/8] block: remove the extra kobject reference in
	bd_link_disk_holder
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since commit 0d02129e76ed ("block: merge struct block_device and struct
hd_struct") there is no way for the bdev to go away as long as there is
a holder, so remove the extra references.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 block/holder.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/block/holder.c b/block/holder.c
index 904a1dcd5c12..960654a71342 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -92,11 +92,6 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
 	if (ret)
 		goto out_del;
-	/*
-	 * bdev could be deleted beneath us which would implicitly destroy
-	 * the holder directory.  Hold on to it.
-	 */
-	kobject_get(bdev->bd_holder_dir);
 
 	list_add(&holder->list, &bdev->bd_holder_disks);
 	goto out_unlock;
@@ -130,7 +125,6 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
 		del_symlink(disk->slave_dir, bdev_kobj(bdev));
 		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
-		kobject_put(bdev->bd_holder_dir);
 		list_del_init(&holder->list);
 		kfree(holder);
 	}
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

