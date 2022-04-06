Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89434C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-vWZB-F7YNN-k-Pvmi3i_6A-1; Mon, 11 Apr 2022 02:19:27 -0400
X-MC-Unique: vWZB-F7YNN-k-Pvmi3i_6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C05A52A2AD4F;
	Mon, 11 Apr 2022 06:19:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6BF0A4050C40;
	Mon, 11 Apr 2022 06:19:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F0B01940365;
	Mon, 11 Apr 2022 06:19:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B87B194036B
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 09:17:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 568C540CF911; Wed,  6 Apr 2022 09:17:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5218F40CF905
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 09:17:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39A57101AA44
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 09:17:27 +0000 (UTC)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-ASM5hHkkMPmz3taYi8pYTA-1; Wed, 06 Apr 2022 05:17:25 -0400
X-MC-Unique: ASM5hHkkMPmz3taYi8pYTA-1
Received: by mail-wr1-f46.google.com with SMTP id c7so2302766wrd.0
 for <dm-devel@redhat.com>; Wed, 06 Apr 2022 02:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ZWBaEVUBDDNzpQMGgXvkac5bmwT4s5z5HH47ILBsXb0=;
 b=sveziE6TEE+eB8lkRrjAiTwG6YE8HUgmetmSdapwKpMTbm1J79jGxGZ4R+IkxpZg4c
 gaOnokZWp7zVChnt+vxI69oHOQt6VQW+pPTJsHgQ50RWHXzvmNNSdxTN4quvtmpXwE4m
 s860s7LgB7Svt8DL8Vl2JRvmK+Jjnh9SEEeFvabr/OLKuOqR+vnyDJjihxtc7WTagKsm
 /g6QVT1a7Z77AoM3/eScXjyfem/KYUb671Ris03lb1nX8/vsOlXmNkmJVx4rtrLBumms
 GBW6/S8YYCUpkLj9OSqTvCKD9UQ3Wobh2FyMjUXmksHkO4v1Q/EN/qgk5Zl+VpxWQf84
 5EEQ==
X-Gm-Message-State: AOAM530ufSlwWmbshUuPTOG4QnMRZ8C5ysw4KRrNLoqWyMvsLe1Faxds
 Cd4fu42F0NAFNo028d157EQtzQ==
X-Google-Smtp-Source: ABdhPJwDgH3Ersfo1tIYfKaPiwVX9/l0yqpMIld8lDNPvdNNHQkDoNONRo/USEuKs0NqlkTeN3vN7w==
X-Received: by 2002:a05:6000:243:b0:206:964:d7d1 with SMTP id
 m3-20020a056000024300b002060964d7d1mr5664875wrz.433.1649236644179; 
 Wed, 06 Apr 2022 02:17:24 -0700 (PDT)
Received: from amarula.amarulasolutions.com (77-32-12-209.dyn.eolo.it.
 [77.32.12.209]) by smtp.gmail.com with ESMTPSA id
 s12-20020a7bc38c000000b0038e708d163dsm3609569wmj.0.2022.04.06.02.17.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Apr 2022 02:17:23 -0700 (PDT)
From: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>
To: agk@redhat.com,
	snitzer@kernel.org
Date: Wed,  6 Apr 2022 11:17:22 +0200
Message-Id: <20220406091722.314590-1-fabio.aiuto@amarulasolutions.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:20 +0000
Subject: [dm-devel] [PATCH v2] md: dm-init: Wait devices if it's not find on
 first adpet
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
Cc: dm-devel@redhat.com, Michael Trimarchi <michael@amarulasolutions.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7246273911154802111=="

--===============7246273911154802111==
Content-Transfer-Encoding: 8bit
Content-Type: application/octet-stream; x-default=true

From: Michael Trimarchi <michael@amarulasolutions.com>

The device driver can be deferrable and can be a race during
the dm-init early. We need to wait all the probe are really finished
in a loop as is done in do_mounts. This is was tested on kernel 5.4
but code seems was not changed since that time

003: imx8mq-usb-phy 381f0040.usb-phy: 381f0040.usb-phy supply vbus not found, using dummy regulator
003: imx8mq-usb-phy 382f0040.usb-phy: 382f0040.usb-phy supply vbus not found, using dummy regulator
003: imx-cpufreq-dt imx-cpufreq-dt: cpu speed grade 5 mkt segment 0 supported-hw 0x20 0x1
003: caam-dma caam-dma: caam dma support with 2 job rings
000: hctosys: unable to open rtc device (rtc0)
000: device-mapper: init: waiting for all devices to be available before creating mapped devices
002: device-mapper: table: 254:0: verity: Data device lookup failed
002: device-mapper: ioctl: error adding target to table
002: crng init done
003: of_cfs_init
003: of_cfs_init: OK
003: Waiting for root device /dev/dm-0...
001: mmc2: new HS400 Enhanced strobe MMC card at address 0001
001: mmcblk2: mmc2:0001 IB2916 14.6 GiB
001: mmcblk2boot0: mmc2:0001 IB2916 partition 1 4.00 MiB
001: mmcblk2boot1: mmc2:0001 IB2916 partition 2 4.00 MiB
001: mmcblk2rpmb: mmc2:0001 IB2916 partition 3 4.00 MiB, chardev (249:0)
001:  mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
001: VSD_3V3: disabling

with the patch

003: device-mapper: init: waiting for all devices to be available before creating mapped devices

000: device-mapper: table: 254:0: verity: Data device lookup failed
000: device-mapper: ioctl: error adding target to table
002: crng init done
003: device-mapper: init: waiting for all devices to be available before creating mapped devices
003: device-mapper: table: 254:0: verity: Data device lookup failed
003: device-mapper: ioctl: error adding target to table
003: device-mapper: init: waiting for all devices to be available before creating mapped devices
000: device-mapper: table: 254:0: verity: Data device lookup failed
000: device-mapper: ioctl: error adding target to table
002: device-mapper: init: waiting for all devices to be available before creating mapped devices
002: device-mapper: table: 254:0: verity: Data device lookup failed
002: device-mapper: ioctl: error adding target to table
000: device-mapper: init: waiting for all devices to be available before creating mapped devices
000: device-mapper: table: 254:0: verity: Data device lookup failed
000: device-mapper: ioctl: error adding target to table
003: mmc2: new HS400 Enhanced strobe MMC card at address 0001
003: mmcblk2: mmc2:0001 DG4016 14.7 GiB
003: mmcblk2boot0: mmc2:0001 DG4016 partition 1 4.00 MiB
003: mmcblk2boot1: mmc2:0001 DG4016 partition 2 4.00 MiB
003: mmcblk2rpmb: mmc2:0001 DG4016 partition 3 4.00 MiB, chardev (249:0)
003:  mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
002: device-mapper: init: waiting for all devices to be available before creating mapped devices
003: device-mapper: verity: sha256 using implementation "sha256-caam"
000: device-mapper: ioctl: dm-0 (rootfs) is ready

Wait loop is limited to 10 at the moment for our use case showed no
more than 4 loops before succesfully find data device.

Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>
---

Changes from v1:
	- limit the loop to 10 iterations
	- change variable names
	- check only for -ENODEV failures

 drivers/md/dm-init.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b0c45c6ebe0b..406a9f92723d 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -7,7 +7,9 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/async.h>
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/device-mapper.h>
 #include <linux/init.h>
@@ -18,6 +20,7 @@
 #define DM_MAX_DEVICES 256
 #define DM_MAX_TARGETS 256
 #define DM_MAX_STR_SIZE 4096
+#define DM_MAX_PROBE_WAIT_RETRY 10
 
 static char *create;
 
@@ -267,6 +270,8 @@ static int __init dm_init_init(void)
 	LIST_HEAD(devices);
 	char *str;
 	int r;
+	int loopcnt = DM_MAX_PROBE_WAIT_RETRY;
+	bool devnotfound = false;
 
 	if (!create)
 		return 0;
@@ -275,6 +280,7 @@ static int __init dm_init_init(void)
 		DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
 		return -EINVAL;
 	}
+retry:
 	str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
 	if (!str)
 		return -ENOMEM;
@@ -287,13 +293,23 @@ static int __init dm_init_init(void)
 	wait_for_device_probe();
 
 	list_for_each_entry(dev, &devices, list) {
-		if (dm_early_create(&dev->dmi, dev->table,
-				    dev->target_args_array))
+		r = dm_early_create(&dev->dmi, dev->table, dev->target_args_array);
+		if (r == -ENODEV) {
+			devnotfound = true;
 			break;
+		}
 	}
+
 out:
 	kfree(str);
 	dm_setup_cleanup(&devices);
+	if (devnotfound && loopcnt) {
+		msleep(5);
+		devnotfound = false;
+		loopcnt--;
+		goto retry;
+	}
+
 	return r;
 }
 
-- 
2.30.2


--===============7246273911154802111==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7246273911154802111==--

