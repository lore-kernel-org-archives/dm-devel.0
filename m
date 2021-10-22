Return-Path: <SRS0=M5Wt=PN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E646C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:40:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 985F161002
	for <dm-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 985F161002
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mediatek.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-M-q0JXumMG2-WtYlqCkSRg-1; Mon, 25 Oct 2021 03:40:24 -0400
X-MC-Unique: M-q0JXumMG2-WtYlqCkSRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A30F8066F4;
	Mon, 25 Oct 2021 07:40:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53D3078B4C;
	Mon, 25 Oct 2021 07:40:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6AF364E58E;
	Mon, 25 Oct 2021 07:40:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19M6r2R1016200 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Oct 2021 02:53:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8D83440CFD11; Fri, 22 Oct 2021 06:53:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88DC140CFD07
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 06:53:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FAF4185A7A4
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 06:53:02 +0000 (UTC)
Received: from mailgw01.mediatek.com (mailgw01.mediatek.com
	[60.244.123.138]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-470-bU9qL7I8ONSaswsO7LEyFA-1; Fri, 22 Oct 2021 02:53:00 -0400
X-MC-Unique: bU9qL7I8ONSaswsO7LEyFA-1
X-UUID: 20354e85a0004b9fb8d70903f573a057-20211022
X-UUID: 20354e85a0004b9fb8d70903f573a057-20211022
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
	(envelope-from <mark-pk.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
	with ESMTP id 1306938713; Fri, 22 Oct 2021 14:47:52 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
	mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server
	(TLS) id 15.0.1497.2; Fri, 22 Oct 2021 14:47:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
	(172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via
	Frontend Transport; Fri, 22 Oct 2021 14:47:50 +0800
From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>
Date: Fri, 22 Oct 2021 14:47:47 +0800
Message-ID: <20211022064748.30136-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
X-MTK: N
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 25 Oct 2021 03:40:10 -0400
Cc: tequila.yuang@mediatek.com, yj.chiang@mediatek.com,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	mark-pk.tsai@mediatek.com, matthias.bgg@gmail.com,
	linux-arm-kernel@lists.infradead.org
Subject: [dm-devel] [PATCH] dm: add module parameter bdev_wait
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

dm_early_create() fail if the target block device not found in
the late init stage.
The block device is created in mmc_rescan() which kernel do
it async by queue it into system_freezable_wq.
Add module param bdev_wait to support waiting the block device
ready before dm_early_create() like prepare_namespace() does.

Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 drivers/md/dm-init.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b0c45c6ebe0b..a3d24cafa4f4 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -8,11 +8,13 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/device-mapper.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/moduleparam.h>
+#include <linux/mount.h>
 
 #define DM_MSG_PREFIX "init"
 #define DM_MAX_DEVICES 256
@@ -20,6 +22,7 @@
 #define DM_MAX_STR_SIZE 4096
 
 static char *create;
+static char *bdev_wait;
 
 /*
  * Format: dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
@@ -286,6 +289,12 @@ static int __init dm_init_init(void)
 	DMINFO("waiting for all devices to be available before creating mapped devices");
 	wait_for_device_probe();
 
+	if (bdev_wait) {
+		DMINFO("Waiting for block device %s...", bdev_wait);
+		while (!name_to_dev_t(bdev_wait))
+			msleep(5);
+	}
+
 	list_for_each_entry(dev, &devices, list) {
 		if (dm_early_create(&dev->dmi, dev->table,
 				    dev->target_args_array))
@@ -301,3 +310,5 @@ late_initcall(dm_init_init);
 
 module_param(create, charp, 0);
 MODULE_PARM_DESC(create, "Create a mapped device in early boot");
+module_param(bdev_wait, charp, 0);
+MODULE_PARM_DESC(bdev_wait, "Wait until the block device ready before dm_early_create");
-- 
2.18.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

