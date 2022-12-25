Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9035C46467
	for <dm-devel@archiver.kernel.org>; Sun, 25 Dec 2022 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671977473;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MslpZ0LRyQEQJsHyuA0lbiJjPWnX3mXSJKJa7CPuVtg=;
	b=g3EwvUOgLDT7gmyAbXRnuIPT1h3eNHWADhh5a5xntpChMzor8D2gxgxYiONSgSEQmCop2H
	PTdPD0UCJR4o9Zr+Ri9z9x7LG17IK/0XEb72bgL6/gxl/IIiTXPrXxnGig4A2Q7oTQT1bP
	psFCpYrUbs/sigNgHaTKOgMuurmAk74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-nLYZfDKxMYGoOcxjnu7aGw-1; Sun, 25 Dec 2022 09:11:10 -0500
X-MC-Unique: nLYZfDKxMYGoOcxjnu7aGw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE0CE80D0E7;
	Sun, 25 Dec 2022 14:11:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCCA753A0;
	Sun, 25 Dec 2022 14:11:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 869701946588;
	Sun, 25 Dec 2022 14:11:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D42AA1946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Dec 2022 14:11:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BAC6CC15BAD; Sun, 25 Dec 2022 14:11:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3738C15BA0
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 14:11:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E222999B37
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 14:11:06 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-pO-DWJO6PZe-DzC9qOIsVg-1; Sun, 25 Dec 2022 09:11:02 -0500
X-MC-Unique: pO-DWJO6PZe-DzC9qOIsVg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DF3B860B5E;
 Sun, 25 Dec 2022 14:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9296C433D2;
 Sun, 25 Dec 2022 14:11:00 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Date: Sun, 25 Dec 2022 09:10:58 -0500
Message-Id: <20221225141059.644014-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] Patch "dm: cleanup close_table_device" has been added to
 the 6.0-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: cleanup close_table_device

to the 6.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-cleanup-close_table_device.patch
and it can be found in the queue-6.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit c2e030d1f11b79659e1f2f8b3766888fd85642b2
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 15 22:10:48 2022 +0800

    dm: cleanup close_table_device
    
    [ Upstream commit 7b5865831c1003122f737df5e16adaa583f1a595 ]
    
    Take the list unlink and free into close_table_device so that no half
    torn down table_devices exist.  Also remove the check for a NULL bdev
    as that can't happen - open_table_device never adds a table_device to
    the list that does not have a valid block_device.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Reviewed-by: Mike Snitzer <snitzer@kernel.org>
    Link: https://lore.kernel.org/r/20221115141054.1051801-5-yukuai1@huaweicloud.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Stable-dep-of: 1a581b721699 ("dm: track per-add_disk holder relations in DM")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1903afa4618a..620abcef2df5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -774,14 +774,11 @@ static struct table_device *open_table_device(struct mapped_device *md,
  */
 static void close_table_device(struct table_device *td, struct mapped_device *md)
 {
-	if (!td->dm_dev.bdev)
-		return;
-
 	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	put_dax(td->dm_dev.dax_dev);
-	td->dm_dev.bdev = NULL;
-	td->dm_dev.dax_dev = NULL;
+	list_del(&td->list);
+	kfree(td);
 }
 
 static struct table_device *find_table_device(struct list_head *l, dev_t dev,
@@ -823,11 +820,8 @@ void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
 	struct table_device *td = container_of(d, struct table_device, dm_dev);
 
 	mutex_lock(&md->table_devices_lock);
-	if (refcount_dec_and_test(&td->count)) {
+	if (refcount_dec_and_test(&td->count))
 		close_table_device(td, md);
-		list_del(&td->list);
-		kfree(td);
-	}
 	mutex_unlock(&md->table_devices_lock);
 }
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

