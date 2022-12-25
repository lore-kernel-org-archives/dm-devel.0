Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1559C4332F
	for <dm-devel@archiver.kernel.org>; Sun, 25 Dec 2022 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671977477;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WwOK6kN54YtdjBQdkLrCDiOodv5uz7H1Vnb25BUcRj0=;
	b=B/DI9h3xLvNYxnLB7laq/ismTj2kDXsVSjImFt9uAThuHOmx5f/r48lxltcGQSx/80qRHY
	eKpGPCLX7cSrlQH+VPzF0oEisZfMr1H6n5D5WXTjBlVBc1MV08zz/JBWbMVgXoquMb/opV
	MqYcfBHi/VIV5ce0z2I4RBCewehM854=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-xb-lLqXpMV-57bQ8Qw-Gnw-1; Sun, 25 Dec 2022 09:11:13 -0500
X-MC-Unique: xb-lLqXpMV-57bQ8Qw-Gnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0BCD3C02530;
	Sun, 25 Dec 2022 14:11:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD8D840C945A;
	Sun, 25 Dec 2022 14:11:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CD0B1946588;
	Sun, 25 Dec 2022 14:11:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 296921946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Dec 2022 14:11:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C4ED40C945A; Sun, 25 Dec 2022 14:11:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14A8040C124A
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 14:11:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED325857F82
 for <dm-devel@redhat.com>; Sun, 25 Dec 2022 14:11:09 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-aeChB0w7O2SZAB-7vTJ9xA-1; Sun, 25 Dec 2022 09:11:08 -0500
X-MC-Unique: aeChB0w7O2SZAB-7vTJ9xA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 792FA60C17;
 Sun, 25 Dec 2022 14:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDAAC433D2;
 Sun, 25 Dec 2022 14:11:06 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Date: Sun, 25 Dec 2022 09:11:04 -0500
Message-Id: <20221225141104.644092-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] Patch "dm: track per-add_disk holder relations in DM"
 has been added to the 6.0-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: track per-add_disk holder relations in DM

to the 6.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-track-per-add_disk-holder-relations-in-dm.patch
and it can be found in the queue-6.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a55bcb965cbb8704e1aa6c6ddd7ebca9373a966a
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 15 22:10:50 2022 +0800

    dm: track per-add_disk holder relations in DM
    
    [ Upstream commit 1a581b72169968f4154b5793828f3bc28b258b35 ]
    
    dm is a bit special in that it opens the underlying devices.  Commit
    89f871af1b26 ("dm: delay registering the gendisk") tried to accommodate
    that by allowing to add the holder to the list before add_gendisk and
    then just add them to sysfs once add_disk is called.  But that leads to
    really odd lifetime problems and error handling problems as we can't
    know the state of the kobjects and don't unwind properly.  To fix this
    switch to just registering all existing table_devices with the holder
    code right after add_disk, and remove them before calling del_gendisk.
    
    Fixes: 89f871af1b26 ("dm: delay registering the gendisk")
    Reported-by: Yu Kuai <yukuai3@huawei.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Reviewed-by: Mike Snitzer <snitzer@kernel.org>
    Link: https://lore.kernel.org/r/20221115141054.1051801-7-yukuai1@huaweicloud.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e7fc2a69633c..bbde744f7dba 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -751,9 +751,16 @@ static struct table_device *open_table_device(struct mapped_device *md,
 		goto out_free_td;
 	}
 
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r)
-		goto out_blkdev_put;
+	/*
+	 * We can be called before the dm disk is added.  In that case we can't
+	 * register the holder relation here.  It will be done once add_disk was
+	 * called.
+	 */
+	if (md->disk->slave_dir) {
+		r = bd_link_disk_holder(bdev, md->disk);
+		if (r)
+			goto out_blkdev_put;
+	}
 
 	td->dm_dev.mode = mode;
 	td->dm_dev.bdev = bdev;
@@ -774,7 +781,8 @@ static struct table_device *open_table_device(struct mapped_device *md,
  */
 static void close_table_device(struct table_device *td, struct mapped_device *md)
 {
-	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
+	if (md->disk->slave_dir)
+		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
 	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
 	put_dax(td->dm_dev.dax_dev);
 	list_del(&td->list);
@@ -1964,7 +1972,13 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		md->disk->private_data = NULL;
 		spin_unlock(&_minor_lock);
 		if (dm_get_md_type(md) != DM_TYPE_NONE) {
+			struct table_device *td;
+
 			dm_sysfs_exit(md);
+			list_for_each_entry(td, &md->table_devices, list) {
+				bd_unlink_disk_holder(td->dm_dev.bdev,
+						      md->disk);
+			}
 
 			/*
 			 * Hold lock to make sure del_gendisk() won't concurrent
@@ -2304,6 +2318,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	enum dm_queue_mode type = dm_table_get_type(t);
 	struct queue_limits limits;
+	struct table_device *td;
 	int r;
 
 	switch (type) {
@@ -2342,16 +2357,30 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	if (r)
 		return r;
 
-	r = dm_sysfs_init(md);
-	if (r) {
-		mutex_lock(&md->table_devices_lock);
-		del_gendisk(md->disk);
-		mutex_unlock(&md->table_devices_lock);
-		return r;
+	/*
+	 * Register the holder relationship for devices added before the disk
+	 * was live.
+	 */
+	list_for_each_entry(td, &md->table_devices, list) {
+		r = bd_link_disk_holder(td->dm_dev.bdev, md->disk);
+		if (r)
+			goto out_undo_holders;
 	}
 
+	r = dm_sysfs_init(md);
+	if (r)
+		goto out_undo_holders;
+
 	md->type = type;
 	return 0;
+
+out_undo_holders:
+	list_for_each_entry_continue_reverse(td, &md->table_devices, list)
+		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
+	mutex_lock(&md->table_devices_lock);
+	del_gendisk(md->disk);
+	mutex_unlock(&md->table_devices_lock);
+	return r;
 }
 
 struct mapped_device *dm_get_md(dev_t dev)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

