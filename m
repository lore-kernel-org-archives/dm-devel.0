Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55786C4742C
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:04:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BAF5D206B7
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:04:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAF5D206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-2rarAFEuNR2_0h82HdYVuA-1; Mon, 16 Nov 2020 10:04:43 -0500
X-MC-Unique: 2rarAFEuNR2_0h82HdYVuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8C8C18BE167;
	Mon, 16 Nov 2020 15:04:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B93B76EF6B;
	Mon, 16 Nov 2020 15:04:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8061958123;
	Mon, 16 Nov 2020 15:04:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGF4PDf017072 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 10:04:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D2F952011553; Mon, 16 Nov 2020 15:04:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCF532023598
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:04:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8421E1823612
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:04:23 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-502-B6jeRzsuN1uL8nf9VFAVNA-1; Mon, 16 Nov 2020 10:03:09 -0500
X-MC-Unique: B6jeRzsuN1uL8nf9VFAVNA-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefxx-0003tO-1m; Mon, 16 Nov 2020 14:58:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:19 +0100
Message-Id: <20201116145809.410558-29-hch@lst.de>
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
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
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
Subject: [dm-devel] [PATCH 28/78] md: implement ->set_read_only to hook into
	BLKROSET processing
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Implement the ->set_read_only method instead of parsing the actual
ioctl command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 62 ++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 32e375d50fee17..fa31b71a72a35d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7477,7 +7477,6 @@ static inline bool md_ioctl_valid(unsigned int cmd)
 {
 	switch (cmd) {
 	case ADD_NEW_DISK:
-	case BLKROSET:
 	case GET_ARRAY_INFO:
 	case GET_BITMAP_FILE:
 	case GET_DISK_INFO:
@@ -7504,7 +7503,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	int err = 0;
 	void __user *argp = (void __user *)arg;
 	struct mddev *mddev = NULL;
-	int ro;
 	bool did_set_md_closing = false;
 
 	if (!md_ioctl_valid(cmd))
@@ -7684,35 +7682,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			goto unlock;
 		}
 		break;
-
-	case BLKROSET:
-		if (get_user(ro, (int __user *)(arg))) {
-			err = -EFAULT;
-			goto unlock;
-		}
-		err = -EINVAL;
-
-		/* if the bdev is going readonly the value of mddev->ro
-		 * does not matter, no writes are coming
-		 */
-		if (ro)
-			goto unlock;
-
-		/* are we are already prepared for writes? */
-		if (mddev->ro != 1)
-			goto unlock;
-
-		/* transitioning to readauto need only happen for
-		 * arrays that call md_write_start
-		 */
-		if (mddev->pers) {
-			err = restart_array(mddev);
-			if (err == 0) {
-				mddev->ro = 2;
-				set_disk_ro(mddev->gendisk, 0);
-			}
-		}
-		goto unlock;
 	}
 
 	/*
@@ -7806,6 +7775,36 @@ static int md_compat_ioctl(struct block_device *bdev, fmode_t mode,
 }
 #endif /* CONFIG_COMPAT */
 
+static int md_set_read_only(struct block_device *bdev, bool ro)
+{
+	struct mddev *mddev = bdev->bd_disk->private_data;
+	int err;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+
+	if (!mddev->raid_disks && !mddev->external) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
+	/*
+	 * Transitioning to read-auto need only happen for arrays that call
+	 * md_write_start and which are not ready for writes yet.
+	 */
+	if (!ro && mddev->ro == 1 && mddev->pers) {
+		err = restart_array(mddev);
+		if (err)
+			goto out_unlock;
+		mddev->ro = 2;
+	}
+
+out_unlock:
+	mddev_unlock(mddev);
+	return err;
+}
+
 static int md_open(struct block_device *bdev, fmode_t mode)
 {
 	/*
@@ -7883,6 +7882,7 @@ const struct block_device_operations md_fops =
 #endif
 	.getgeo		= md_getgeo,
 	.check_events	= md_check_events,
+	.set_read_only	= md_set_read_only,
 };
 
 static int md_thread(void *arg)
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

