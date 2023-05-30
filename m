Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9E3C7EE24
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kAEReTeSIrC0RC5AmmpKIka/L+Rz5i1ma797N0w6/l4=;
	b=HzkgiLxGU2VS0s8yQFalGZRO+VrRH2BkEyynSCUPmQxiDFhh5dQZzze8eWViTVXFeJBWGU
	Yqtcs2NaM3VCVywNubkQ+TB0p1AqQ2RAFB4Gg/zqne0OHWxxKwnuUHS97Zj1UWEFpLuhNA
	QvZWNH4XoKFY5tdLDUHUh5AXE90HPJI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-tSu-6nY0PLul6ZxX8QkFpQ-1; Tue, 30 May 2023 16:54:49 -0400
X-MC-Unique: tSu-6nY0PLul6ZxX8QkFpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 525E91C01EB4;
	Tue, 30 May 2023 20:54:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4068440D1B63;
	Tue, 30 May 2023 20:54:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4DCE419465A0;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7ECB1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 87D23202696C; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80D5D2029F6E
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63384806014
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:56 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-Q6LBgvx3M9K7n6-p_Y8fCA-1; Tue, 30 May 2023 16:40:53 -0400
X-MC-Unique: Q6LBgvx3M9K7n6-p_Y8fCA-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.west.internal (Postfix) with ESMTP id 0D022320096E;
 Tue, 30 May 2023 16:32:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute4.internal (MEProxy); Tue, 30 May 2023 16:32:21 -0400
X-ME-Sender: <xms:VF12ZCx6LBtGDgihYZ-NBi1TQbMnT10K4M83ELm3G3ATfM8R279sSA>
 <xme:VF12ZOSoOZisX8Dh7PgaI1Br2VXmS17_-QQHdNrd8ODedLEjRJsiupF-ePxfF5-CL
 VIu0ou0rSk2fvk>
X-ME-Received: <xmr:VF12ZEUZ2v-22K9HABN8joZIwupVm2l2OuN_SbATb71V0ubBkGLMjmuY97GOgzqwv3poc01Y0NU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:VF12ZIgsEEnwHKmC43Kv9GxV7bH-i7tiH_PkAz1p_2nBYwSEAf6YrA>
 <xmx:VF12ZEDqiN37KhUgZoqxnScnVqOaHAYoy7GmY53oxQjsejR59koZOQ>
 <xmx:VF12ZJLZp0lEBhXhDlI94ziBRaLfrp4UJrXDlteRIEm9FlDD8PS34w>
 <xmx:VF12ZCA0rxPCrK0M9295LprgFjyNUobhbd0Xa629Rogk5JO32xfXOA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:32:19 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:16 -0400
Message-Id: <20230530203116.2008-17-demi@invisiblethingslab.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 16/16] xen-blkback: Inform userspace that
 device has been opened
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Set "opened" to "0" before the hotplug script is called.  Once the
device node has been opened, set "opened" to "1".

"opened" is used exclusively by userspace.  It serves two purposes:

1. It tells userspace that the diskseq Xenstore entry is supported.

2. It tells userspace that it can wait for "opened" to be set to 1.
   Once "opened" is 1, blkback has a reference to the device, so
   userspace doesn't need to keep one.

Together, these changes allow userspace to use block devices with
delete-on-close behavior, such as loop devices with the autoclear flag
set or device-mapper devices with the deferred-remove flag set.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/block/xen-blkback/xenbus.c | 35 ++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 9c3eb148fbd802c74e626c3d7bcd69dcb09bd921..519a78aa9073d1faa1dce5c1b36e95ae58da534b 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -3,6 +3,20 @@
     Copyright (C) 2005 Rusty Russell <rusty@rustcorp.com.au>
     Copyright (C) 2005 XenSource Ltd
 
+In addition to the Xenstore nodes required by the Xen block device
+specification, this implementation of blkback uses a new Xenstore
+node: "opened".  blkback sets "opened" to "0" before the hotplug script
+is called.  Once the device node has been opened, blkback sets "opened"
+to "1".
+
+"opened" is read exclusively by userspace.  It serves two purposes:
+
+1. It tells userspace that diskseq@major:minor syntax for "physical-device" is
+   supported.
+
+2. It tells userspace that it can wait for "opened" to be set to 1 after writing
+   "physical-device".  Once "opened" is 1, blkback has a reference to the
+   device, so userspace doesn't need to keep one.
 
 */
 
@@ -699,6 +713,14 @@ static int xen_blkbk_probe(struct xenbus_device *dev,
 	if (err)
 		pr_warn("%s write out 'max-ring-page-order' failed\n", __func__);
 
+	/*
+	 * This informs userspace that the "opened" node will be set to "1" when
+	 * the device has been opened successfully.
+	 */
+	err = xenbus_write(XBT_NIL, dev->nodename, "opened", "0");
+	if (err)
+		goto fail;
+
 	err = xenbus_switch_state(dev, XenbusStateInitWait);
 	if (err)
 		goto fail;
@@ -826,6 +848,19 @@ static void backend_changed(struct xenbus_watch *watch,
 		goto fail;
 	}
 
+	/*
+	 * Tell userspace that the device has been opened and that blkback has a
+	 * reference to it.  Userspace can then close the device or mark it as
+	 * delete-on-close, knowing that blkback will keep the device open as
+	 * long as necessary.
+	 */
+	err = xenbus_write(XBT_NIL, dev->nodename, "opened", "1");
+	if (err) {
+		xenbus_dev_fatal(dev, err, "%s: notifying userspace device has been opened",
+				 dev->nodename);
+		goto free_vbd;
+	}
+
 	err = xenvbd_sysfs_addif(dev);
 	if (err) {
 		xenbus_dev_fatal(dev, err, "creating sysfs entries");
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

