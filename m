Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F0EC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 23:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668555320;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RyuN6HFybu2QKoKXoZptXgoTiqapA+6052QVIkEZnbI=;
	b=EHkEs/zI0XqRGiF/Fv4wDsRLB48JBm1iWXAdPpGpQikyx1PxVsAR8oxq9XFFO3rHUnDQn6
	p92pnn9X44luwLURXWhwxmaKMAzf3to88FHV/oAGqRu808u6WktrLtoKsqKkMosEdidJ9E
	VurXAVf56Ie7D62H95Xi+F49Uoyl3fs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-rsR6oabUO2SSAn3uyeZpBQ-1; Tue, 15 Nov 2022 18:35:19 -0500
X-MC-Unique: rsR6oabUO2SSAn3uyeZpBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 356C61C0519E;
	Tue, 15 Nov 2022 23:35:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CB3740C835A;
	Tue, 15 Nov 2022 23:35:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA87819465A0;
	Tue, 15 Nov 2022 23:35:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 429FF1946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 23:35:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9903B1415102; Tue, 15 Nov 2022 23:35:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91CDE140EBF3
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 23:35:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42DBC3804508
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 23:35:09 +0000 (UTC)
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net
 [217.70.178.240]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-oOYBHRGZNS21RI7gTRTmWA-1; Tue, 15 Nov 2022 18:35:07 -0500
X-MC-Unique: oOYBHRGZNS21RI7gTRTmWA-1
Received: from relay5-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::225])
 by mslow1.mail.gandi.net (Postfix) with ESMTP id 815BCCA635
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 21:52:14 +0000 (UTC)
Received: (Authenticated sender: peter@korsgaard.com)
 by mail.gandi.net (Postfix) with ESMTPSA id 964EF1C0002;
 Tue, 15 Nov 2022 21:52:08 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.94.2)
 (envelope-from <peko@dell.be.48ers.dk>)
 id 1ov3qh-009Mpi-9d; Tue, 15 Nov 2022 22:52:07 +0100
From: Peter Korsgaard <peter@korsgaard.com>
To: Mike Snitzer <snitzer@kernel.org>, Helen Koike <helen.koike@collabora.com>,
 dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>
Date: Tue, 15 Nov 2022 22:51:46 +0100
Message-Id: <20221115215146.2232584-1-peter@korsgaard.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH] dm init: add dm-mod.waitfor to wait for
 asynchronously probed block devices
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
Cc: Peter Korsgaard <peter@korsgaard.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Just calling wait_for_device_probe() is not enough to ensure that
asynchronously probed block devices are available (E.G.  mmc, usb, ..), so
add a "dm-mod.waitfor=<device1>[,..,<deviceN>]" parameter to get dm-init to
explicitly wait for specific block devices before initializing the tables
with logic similar to the rootwait logic in init/do_mounts.c.

E.G. with dm-verity on mmc with
dm-mod.waitfor="PARTLABEL=hash-a,PARTLABEL=root-a"

[    0.671671] device-mapper: init: waiting for all devices to be available before creating mapped devices
[    0.671679] device-mapper: init: waiting for PARTLABEL=hash-a
[    0.710695] mmc0: new HS200 MMC card at address 0001
[    0.711158] mmcblk0: mmc0:0001 004GA0 3.69 GiB
[    0.715954] mmcblk0boot0: mmc0:0001 004GA0 partition 1 2.00 MiB
[    0.722085] mmcblk0boot1: mmc0:0001 004GA0 partition 2 2.00 MiB
[    0.728093] mmcblk0rpmb: mmc0:0001 004GA0 partition 3 512 KiB, chardev (249:0)
[    0.738274]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
[    0.751282] device-mapper: init: waiting for PARTLABEL=root-a
[    0.751306] device-mapper: init: all devices available
[    0.751683] device-mapper: verity: sha256 using implementation "sha256-generic"
[    0.759344] device-mapper: ioctl: dm-0 (vroot) is ready
[    0.766540] VFS: Mounted root (squashfs filesystem) readonly on device 254:0.

Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
---
 .../admin-guide/device-mapper/dm-init.rst     |  9 ++++++++
 drivers/md/dm-init.c                          | 23 ++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-init.rst b/Documentation/admin-guide/device-mapper/dm-init.rst
index e5242ff17e9b..83efd8fe19d5 100644
--- a/Documentation/admin-guide/device-mapper/dm-init.rst
+++ b/Documentation/admin-guide/device-mapper/dm-init.rst
@@ -123,3 +123,12 @@ Other examples (per target):
     0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
     fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
     51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
+
+For setups using device-mapper on top of asynchronously probed block
+devices (MMC, USB, ..), it may be necessary to tell dm-init to
+explicitly wait for them to become available before setting up the
+device-mapper tables. This can be done with the "dm-init.waitfor="
+module parameter, which takes a list of devices to wait for::
+
+  dm-init.waitfor=<device1>[,..,<deviceN>]
+
diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b0c45c6ebe0b..fc70b568e072 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/device-mapper.h>
 #include <linux/init.h>
@@ -18,12 +19,17 @@
 #define DM_MAX_DEVICES 256
 #define DM_MAX_TARGETS 256
 #define DM_MAX_STR_SIZE 4096
+#define DM_MAX_WAITFOR 256
 
 static char *create;
 
+static char *waitfor[DM_MAX_WAITFOR];
+
 /*
  * Format: dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
  * Table format: <start_sector> <num_sectors> <target_type> <target_args>
+ * Block devices to wait for to become available before setting up tables:
+ * dm-mod.waitfor=<device1>[,..,<deviceN>]
  *
  * See Documentation/admin-guide/device-mapper/dm-init.rst for dm-mod.create="..." format
  * details.
@@ -266,7 +272,7 @@ static int __init dm_init_init(void)
 	struct dm_device *dev;
 	LIST_HEAD(devices);
 	char *str;
-	int r;
+	int i, r;
 
 	if (!create)
 		return 0;
@@ -286,6 +292,18 @@ static int __init dm_init_init(void)
 	DMINFO("waiting for all devices to be available before creating mapped devices");
 	wait_for_device_probe();
 
+	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
+		if (waitfor[i]) {
+			DMINFO("waiting for %s", waitfor[i]);
+
+			while (!dm_get_dev_t(waitfor[i]))
+				msleep(20);
+		}
+	}
+
+	if (waitfor[0])
+		DMINFO("all devices available");
+
 	list_for_each_entry(dev, &devices, list) {
 		if (dm_early_create(&dev->dmi, dev->table,
 				    dev->target_args_array))
@@ -301,3 +319,6 @@ late_initcall(dm_init_init);
 
 module_param(create, charp, 0);
 MODULE_PARM_DESC(create, "Create a mapped device in early boot");
+
+module_param_array(waitfor, charp, NULL, 0);
+MODULE_PARM_DESC(waitfor, "Devices to wait for before setting up tables");
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

