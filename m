Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910E7C433FE
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:48:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-PBVJ4fg_OeKWoKc8IPonuQ-1; Mon, 04 Apr 2022 02:48:44 -0400
X-MC-Unique: PBVJ4fg_OeKWoKc8IPonuQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EFAF811E7A;
	Mon,  4 Apr 2022 06:48:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EAC8401E59;
	Mon,  4 Apr 2022 06:48:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4AE1019451EC;
	Mon,  4 Apr 2022 06:48:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69D211947BBE
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Apr 2022 22:07:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0AA654118F08; Fri,  1 Apr 2022 22:07:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0657C4118F01
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 22:07:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCA1A3C02182
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 22:07:11 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
 [209.85.218.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-Fr62V962NtKnGaN1NPzwMQ-1; Fri, 01 Apr 2022 18:07:10 -0400
X-MC-Unique: Fr62V962NtKnGaN1NPzwMQ-1
Received: by mail-ej1-f54.google.com with SMTP id o10so8654308ejd.1
 for <dm-devel@redhat.com>; Fri, 01 Apr 2022 15:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Nm4/IXTEhukbK1qhvdT6cx0MGt+4gXe0siNI2njLEvE=;
 b=I4kdW7av/rWHn2O/huhkmTe5TN+Y72SO56ywxPI1/b1HC7r4GTIQYm7AwtPx1elqY6
 k+g0muvkzvY4ts4Vq4H/Kwei6IHKrLwVlvvI4WYK1j1M5Y5CNcrGPi3BRLD1dPeHSHMd
 +Vk3vw/Xi3kHhy0mMmKCy5LXE9QwUMzgZ0zZMEbVJd1Ed6PIqGfg5cU+84wIhpFZM8cD
 /N4VGTYREA5HnMeMf0NYREoaah/GC+OvTebqF3tnggI6SGw8iMWVZfv9zvfgAgBsGi1n
 Zip2IyLBIHiQj5uG7R7IWwVRgGJlm/jcekN3KVy6bN7a9WL6DTbUD/+/9AyuMrnUUPt/
 GTWA==
X-Gm-Message-State: AOAM533u0GPaUKUPRVYOrx7IAe+H0P3yOM7GJvpB7Boy4llVBF+nWNil
 YTeLU45c6y0kxapQ3C76v1EpnA==
X-Google-Smtp-Source: ABdhPJy089jCiaKOTUXZv8xWaU8CK2ptzqILHk1BadP6mEIgFQaD+8+rQ2r/GQizJBqCQLFCzxcXuQ==
X-Received: by 2002:a17:907:3ea9:b0:6df:f197:81ae with SMTP id
 hs41-20020a1709073ea900b006dff19781aemr1659511ejc.402.1648850828864; 
 Fri, 01 Apr 2022 15:07:08 -0700 (PDT)
Received: from localhost.localdomain ([78.44.231.212])
 by smtp.gmail.com with ESMTPSA id
 by4-20020a0564021b0400b00418fc410299sm1642324edb.62.2022.04.01.15.07.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Apr 2022 15:07:07 -0700 (PDT)
From: Michael Trimarchi <michael@amarulasolutions.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Date: Sat,  2 Apr 2022 00:07:05 +0200
Message-Id: <20220401220705.82077-1-michael@amarulasolutions.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 04 Apr 2022 06:48:34 +0000
Subject: [dm-devel] [RFC PATCH] md: dm-init: Wait devices if it's not find
 on first adpet
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
Cc: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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

Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
---
 drivers/md/dm-init.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b0c45c6ebe0b..d3b754036484 100644
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
@@ -267,6 +269,7 @@ static int __init dm_init_init(void)
 	LIST_HEAD(devices);
 	char *str;
 	int r;
+	bool fail = false;
 
 	if (!create)
 		return 0;
@@ -275,6 +278,7 @@ static int __init dm_init_init(void)
 		DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
 		return -EINVAL;
 	}
+retry:
 	str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
 	if (!str)
 		return -ENOMEM;
@@ -288,12 +292,21 @@ static int __init dm_init_init(void)
 
 	list_for_each_entry(dev, &devices, list) {
 		if (dm_early_create(&dev->dmi, dev->table,
-				    dev->target_args_array))
+				    dev->target_args_array)) {
+			fail = true;
 			break;
+		}
 	}
+
 out:
 	kfree(str);
 	dm_setup_cleanup(&devices);
+	if (fail) {
+		msleep(5);
+		fail = false;
+		goto retry;
+	}
+
 	return r;
 }
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

