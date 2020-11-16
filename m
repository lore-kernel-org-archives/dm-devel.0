Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0695FC56202
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 07:29:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C6482462E
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 07:29:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C6482462E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-TSO6L5bYPsydouSFwclAxA-1; Wed, 18 Nov 2020 02:29:37 -0500
X-MC-Unique: TSO6L5bYPsydouSFwclAxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3301809DE5;
	Wed, 18 Nov 2020 07:29:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6DE15C1BB;
	Wed, 18 Nov 2020 07:29:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD07C180B791;
	Wed, 18 Nov 2020 07:29:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGF2SXp016321 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 10:02:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 00D92110F725; Mon, 16 Nov 2020 15:02:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F072C110FC1E
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:02:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A62D5811E9D
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:02:25 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-441-pYmmK3iVN7eDjshgzyKgng-1; Mon, 16 Nov 2020 10:01:51 -0500
X-MC-Unique: pYmmK3iVN7eDjshgzyKgng-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefxm-0003qi-1m; Mon, 16 Nov 2020 14:58:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:11 +0100
Message-Id: <20201116145809.410558-21-hch@lst.de>
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 18 Nov 2020 02:29:13 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 20/78] md: use set_capacity_and_notify
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use set_capacity_and_notify to set the size of both the disk and block
device.  This also gets the uevent notifications for the resize for free.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <song@kernel.org>
---
 drivers/md/md-cluster.c |  6 ++----
 drivers/md/md-linear.c  |  3 +--
 drivers/md/md.c         | 24 ++++++++++--------------
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4aaf4820b6f625..87442dc59f6ca3 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -581,8 +581,7 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		process_metadata_update(mddev, msg);
 		break;
 	case CHANGE_CAPACITY:
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk_size(mddev->gendisk, true);
+		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
 		break;
 	case RESYNCING:
 		set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
@@ -1296,8 +1295,7 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 		if (ret)
 			pr_err("%s:%d: failed to send CHANGE_CAPACITY msg\n",
 			       __func__, __LINE__);
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk_size(mddev->gendisk, true);
+		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
 	} else {
 		/* revert to previous sectors */
 		ret = mddev->pers->resize(mddev, old_dev_sectors);
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 5ab22069b5be9c..98f1b4b2bdcef8 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -200,9 +200,8 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 		"copied raid_disks doesn't match mddev->raid_disks");
 	rcu_assign_pointer(mddev->private, newconf);
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
-	set_capacity(mddev->gendisk, mddev->array_sectors);
+	set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
 	mddev_resume(mddev);
-	revalidate_disk_size(mddev->gendisk, true);
 	kfree_rcu(oldconf, rcu);
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae26..32e375d50fee17 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5355,10 +5355,9 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
 
 	if (!err) {
 		mddev->array_sectors = sectors;
-		if (mddev->pers) {
-			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk_size(mddev->gendisk, true);
-		}
+		if (mddev->pers)
+			set_capacity_and_notify(mddev->gendisk,
+						mddev->array_sectors);
 	}
 	mddev_unlock(mddev);
 	return err ?: len;
@@ -6107,8 +6106,7 @@ int do_md_run(struct mddev *mddev)
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
-	set_capacity(mddev->gendisk, mddev->array_sectors);
-	revalidate_disk_size(mddev->gendisk, true);
+	set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
 	clear_bit(MD_NOT_READY, &mddev->flags);
 	mddev->changed = 1;
 	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
@@ -6423,10 +6421,9 @@ static int do_md_stop(struct mddev *mddev, int mode,
 			if (rdev->raid_disk >= 0)
 				sysfs_unlink_rdev(mddev, rdev);
 
-		set_capacity(disk, 0);
+		set_capacity_and_notify(disk, 0);
 		mutex_unlock(&mddev->open_mutex);
 		mddev->changed = 1;
-		revalidate_disk_size(disk, true);
 
 		if (mddev->ro)
 			mddev->ro = 0;
@@ -7257,8 +7254,8 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 		if (mddev_is_clustered(mddev))
 			md_cluster_ops->update_size(mddev, old_dev_sectors);
 		else if (mddev->queue) {
-			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk_size(mddev->gendisk, true);
+			set_capacity_and_notify(mddev->gendisk,
+						mddev->array_sectors);
 		}
 	}
 	return rv;
@@ -9035,10 +9032,9 @@ void md_do_sync(struct md_thread *thread)
 		mddev_lock_nointr(mddev);
 		md_set_array_sectors(mddev, mddev->pers->size(mddev, 0, 0));
 		mddev_unlock(mddev);
-		if (!mddev_is_clustered(mddev)) {
-			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk_size(mddev->gendisk, true);
-		}
+		if (!mddev_is_clustered(mddev))
+			set_capacity_and_notify(mddev->gendisk,
+						mddev->array_sectors);
 	}
 
 	spin_lock(&mddev->lock);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

