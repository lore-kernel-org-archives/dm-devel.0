Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A44CC7EE2F
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480085;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CI8UCKup+jlcfHUyvRUMws9R13M5C3hUnTw1atyxqZo=;
	b=W2W/TSypTbRmuvEYH5WhERlI9BlsoK7oGi2ZbQ2SIpvBjllMo/u93T2dWuUK5c2zcW8hkh
	3Q9ekXKyqCk2tHveYTw3lOFbPSeA67/R8/EVugCG9fre4tFtNh219WhRjA5Wc3ImpDVWqd
	FrTKNkiBceMRkjAK4jt83EGmUqYjFak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-SW1gNvfPOLmF2noS2PzCqw-1; Tue, 30 May 2023 16:54:43 -0400
X-MC-Unique: SW1gNvfPOLmF2noS2PzCqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8EFA101B04B;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 99769421D8;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14D0C19451F6;
	Tue, 30 May 2023 20:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3409F19465B7
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 140FE112132D; Tue, 30 May 2023 20:40:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CBE5112132C
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E51A438117E3
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:58 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-rwqQMkW_OhKeRDDHLyRbwA-1; Tue, 30 May 2023 16:40:52 -0400
X-MC-Unique: rwqQMkW_OhKeRDDHLyRbwA-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id 6EF803200934;
 Tue, 30 May 2023 16:32:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute1.internal (MEProxy); Tue, 30 May 2023 16:32:13 -0400
X-ME-Sender: <xms:S112ZFgm3IeHFi6lKr5FpH5jvpfxwO-emQ2czS7Pq9uDlsy9Fog8-Q>
 <xme:S112ZKB_RZTgfN8gOc3Qt1yLL0BLazY40yQ4kW6JyaHmpwYd6le27kfuoY0HNPe8q
 Bg1QVfpKaNzuu4>
X-ME-Received: <xmr:S112ZFFvIfFBGsSNVsyzjW3e8trWKGolRY9j-x5oH_a7oB_rpZIly3L0KUdHGO_X5tEjIbl3Z-4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedvne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:S112ZKSXztYWhNh1MQVCl3fCY8DiKab0iHLF3aayTdVK2LoubaYlsA>
 <xmx:S112ZCytp1E3O_qW43L1mXgjApcSM6g_XRGwrav4Xg9SVmX7n86Qkw>
 <xmx:S112ZA7gcLfxJIeXwgaFf_QMQGleyKUVRN_r2UoxT_a0-RDhxoexxg>
 <xmx:TF12ZNwxjvc_-0yaKFm8hnvtR3BECga_Ld9X_kRH4r-5lLJDCs-ZAw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:32:11 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:13 -0400
Message-Id: <20230530203116.2008-14-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-1-demi@invisiblethingslab.com>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 13/16] xen-blkback: Implement diskseq checks
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This allows specifying a disk sequence number in XenStore.  If it does
not match the disk sequence number of the underlying device, the device
will not be exported and a warning will be logged.  Userspace can use
this to eliminate race conditions due to major/minor number reuse.
Old kernels do not support the new syntax, but a later patch will allow
userspace to discover that the new syntax is supported.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/block/xen-blkback/xenbus.c | 112 +++++++++++++++++++++++------
 1 file changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 4807af1d58059394d7a992335dabaf2bc3901721..9c3eb148fbd802c74e626c3d7bcd69dcb09bd921 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -24,6 +24,7 @@ struct backend_info {
 	struct xenbus_watch	backend_watch;
 	unsigned		major;
 	unsigned		minor;
+	unsigned long long	diskseq;
 	char			*mode;
 };
 
@@ -479,7 +480,7 @@ static void xen_vbd_free(struct xen_vbd *vbd)
 
 static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 			  unsigned major, unsigned minor, int readonly,
-			  int cdrom)
+			  bool cdrom, u64 diskseq)
 {
 	struct xen_vbd *vbd;
 	struct block_device *bdev;
@@ -507,6 +508,26 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 		xen_vbd_free(vbd);
 		return -ENOENT;
 	}
+
+	if (diskseq) {
+		struct gendisk *disk = bdev->bd_disk;
+
+		if (unlikely(disk == NULL)) {
+			pr_err("%s: device %08x has no gendisk\n",
+			       __func__, vbd->pdevice);
+			xen_vbd_free(vbd);
+			return -EFAULT;
+		}
+
+		if (unlikely(disk->diskseq != diskseq)) {
+			pr_warn("%s: device %08x has incorrect sequence "
+				"number 0x%llx (expected 0x%llx)\n",
+				__func__, vbd->pdevice, disk->diskseq, diskseq);
+			xen_vbd_free(vbd);
+			return -ENODEV;
+		}
+	}
+
 	vbd->size = vbd_sz(vbd);
 
 	if (cdrom || disk_to_cdi(vbd->bdev->bd_disk))
@@ -707,6 +728,9 @@ static void backend_changed(struct xenbus_watch *watch,
 	int cdrom = 0;
 	unsigned long handle;
 	char *device_type;
+	char *diskseq_str = NULL;
+	int diskseq_len;
+	unsigned long long diskseq;
 
 	pr_debug("%s %p %d\n", __func__, dev, dev->otherend_id);
 
@@ -725,10 +749,46 @@ static void backend_changed(struct xenbus_watch *watch,
 		return;
 	}
 
-	if (be->major | be->minor) {
-		if (be->major != major || be->minor != minor)
-			pr_warn("changing physical device (from %x:%x to %x:%x) not supported.\n",
-				be->major, be->minor, major, minor);
+	diskseq_str = xenbus_read(XBT_NIL, dev->nodename, "diskseq", &diskseq_len);
+	if (IS_ERR(diskseq_str)) {
+		int err = PTR_ERR(diskseq_str);
+		diskseq_str = NULL;
+
+		/*
+		 * If this does not exist, it means legacy userspace that does not
+		 * support diskseq.
+		 */
+		if (unlikely(!XENBUS_EXIST_ERR(err))) {
+			xenbus_dev_fatal(dev, err, "reading diskseq");
+			return;
+		}
+		diskseq = 0;
+	} else if (diskseq_len <= 0) {
+		xenbus_dev_fatal(dev, -EFAULT, "diskseq must not be empty");
+		goto fail;
+	} else if (diskseq_len > 16) {
+		xenbus_dev_fatal(dev, -ERANGE, "diskseq too long: got %d but limit is 16",
+				 diskseq_len);
+		goto fail;
+	} else if (diskseq_str[0] == '0') {
+		xenbus_dev_fatal(dev, -ERANGE, "diskseq must not start with '0'");
+		goto fail;
+	} else {
+		char *diskseq_end;
+		diskseq = simple_strtoull(diskseq_str, &diskseq_end, 16);
+		if (diskseq_end != diskseq_str + diskseq_len) {
+			xenbus_dev_fatal(dev, -EINVAL, "invalid diskseq");
+			goto fail;
+		}
+		kfree(diskseq_str);
+		diskseq_str = NULL;
+	}
+
+	if (be->major | be->minor | be->diskseq) {
+		if (be->major != major || be->minor != minor || be->diskseq != diskseq)
+			pr_warn("changing physical device (from %x:%x:%llx to %x:%x:%llx)"
+				" not supported.\n",
+				be->major, be->minor, be->diskseq, major, minor, diskseq);
 		return;
 	}
 
@@ -756,29 +816,35 @@ static void backend_changed(struct xenbus_watch *watch,
 
 	be->major = major;
 	be->minor = minor;
+	be->diskseq = diskseq;
 
 	err = xen_vbd_create(be->blkif, handle, major, minor,
-			     !strchr(be->mode, 'w'), cdrom);
-
-	if (err)
-		xenbus_dev_fatal(dev, err, "creating vbd structure");
-	else {
-		err = xenvbd_sysfs_addif(dev);
-		if (err) {
-			xen_vbd_free(&be->blkif->vbd);
-			xenbus_dev_fatal(dev, err, "creating sysfs entries");
-		}
-	}
+			     !strchr(be->mode, 'w'), cdrom, diskseq);
 
 	if (err) {
-		kfree(be->mode);
-		be->mode = NULL;
-		be->major = 0;
-		be->minor = 0;
-	} else {
-		/* We're potentially connected now */
-		xen_update_blkif_status(be->blkif);
+		xenbus_dev_fatal(dev, err, "creating vbd structure");
+		goto fail;
 	}
+
+	err = xenvbd_sysfs_addif(dev);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "creating sysfs entries");
+		goto free_vbd;
+	}
+
+	/* We're potentially connected now */
+	xen_update_blkif_status(be->blkif);
+	return;
+
+free_vbd:
+	xen_vbd_free(&be->blkif->vbd);
+fail:
+	kfree(diskseq_str);
+	kfree(be->mode);
+	be->mode = NULL;
+	be->major = 0;
+	be->minor = 0;
+	be->diskseq = 0;
 }
 
 /*
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

