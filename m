Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEE8C6FA92
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2BeTcXZyG911h0Az+5AdoinHgSVo2TQI5iHzUm6bRMY=;
	b=YAS/oX0vCyPCNGPuRVsiCbZs42cTaO9abUpBQDgvpW9kofpmw6b4HWK5x//RaYqvNsfRAa
	dC//ZPHytWUl0JPz8E06G6shaJdp7ERHUc/VZ5w+95+mgdXeXOOrsRpLsiWdfutEauXKs5
	YgamAxbvycmaFFS60MFxjKGjlQX52fs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-BIxDa0edOkqXkSfwpEP__g-1; Tue, 20 Sep 2022 05:11:43 -0400
X-MC-Unique: BIxDa0edOkqXkSfwpEP__g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E657382578B;
	Tue, 20 Sep 2022 09:11:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44B1F49BB61;
	Tue, 20 Sep 2022 09:11:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3829419465B1;
	Tue, 20 Sep 2022 09:11:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CDB3719465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B0F56140EBF6; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A82A3140EBF5
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88CFF858F17
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-etiSD-nGMiWPsa4f_RqIaA-1; Tue, 20 Sep 2022 05:11:37 -0400
X-MC-Unique: etiSD-nGMiWPsa4f_RqIaA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091136euoutp02fbe820cdd950c3202bc73b0608c5dba2~Whpc7jXJy2701927019euoutp02X
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220920091136euoutp02fbe820cdd950c3202bc73b0608c5dba2~Whpc7jXJy2701927019euoutp02X
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091134eucas1p22889d52d26e777aa61ebbb2e5ad9af26~WhpbYJLHR0517305173eucas1p2s;
 Tue, 20 Sep 2022 09:11:34 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 30.A8.19378.6C389236; Tue, 20
 Sep 2022 10:11:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d~Whpa12S-q3248232482eucas1p2J;
 Tue, 20 Sep 2022 09:11:34 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091134eusmtrp15d0f5cecabf3dcf273ccc8731df62cd8~Whpa09uTe0212802128eusmtrp1A;
 Tue, 20 Sep 2022 09:11:34 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-d8-632983c62ae3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id DE.53.10862.6C389236; Tue, 20
 Sep 2022 10:11:34 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091133eusmtip2591d1a82333699ba03c6a5b5a251224e~Whpah9jrW2175621756eusmtip2h;
 Tue, 20 Sep 2022 09:11:33 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:19 +0200
Message-Id: <20220920091119.115879-14-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7djP87rHmjWTDVaeV7NYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWtw8sJPJYs+iSUwWK1cfZbJ4sn4Ws8XfrntA2VvaFpd3
 zWGzmL/sKbvFhLavzBafl7awW6y5+ZTF4sQtaQchj8tXvD12zrrL7nH5bKnHplWdbB6bl9R7
 7L7ZwOaxs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ3ddb
 2Aum1Vec+nuBvYHxZ0oXIyeHhICJxM6/DUxdjFwcQgIrGCUutU5mgXC+MEp8m72GFcL5zCjR
 824tG0zLr1n3GCESyxklWh+tYIdwXjJK/JnzAqifg4NNQEuisZMdpEFEIF3i69cNYA3MApOZ
 JV68msQCkhAGSqz+eQXMZhFQlWhcNIkRxOYVsJb49WQGI8Q2eYmZl76DDeIEis/Z3cIGUSMo
 cXLmE7BeZqCa5q2zmUEWSAhs5pS4+GkNO0Szi0T7nqtQtrDEq+NboGwZidOTe1gg7GqJpzd+
 QzW3MEr071zPBvKBBNC2vjM5ICazgKbE+l36EOWOEueubmKHqOCTuPFWEOIEPolJ26YzQ4R5
 JTrahCCqlSR2/nwCtVRC4nLTHKilHhI93ecZJzAqzkLyzCwkz8xC2LuAkXkVo3hqaXFuemqx
 cV5quV5xYm5xaV66XnJ+7iZGYEo8/e/41x2MK1591DvEyMTBeIhRgoNZSYS3xV8zWYg3JbGy
 KrUoP76oNCe1+BCjNAeLkjhvcuaGRCGB9MSS1OzU1ILUIpgsEwenVAOT4r4Nv/c+nXHymmsX
 v4COrd/OH9mvmpp+bXB5o/LF9+Rcz8U/99wWauJhC0sP+hq1QqHrnoSuUoVK2vwbeiy8lTZL
 1Rm/7J2/VzCw6nm3rQHHqcN7GS/talTaPd88ftv8RTXPS9WjG+a8PpakfX9VTN+Pp1dOtcus
 6r09v3zXyVx2bsGTTamm9obXj5olWD6plvipvqVzyZp55jo3c6LW6H540ilr5/fk6UFhG9bM
 5SclVk7wWctzwuCgRZUZX2bijXUHqhZLbJObEeZmd/5W+qubuXW33Zhes9781vZMje94l0Gy
 mylvZ8gykfKWlrZ5PCEKqeu60pdEzDha7Wf1Mybeq++ti/7HT3tVX/1QYinOSDTUYi4qTgQA
 GZ0zW/gDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xe7rHmjWTDdY+YLVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWtw8sJPJYs+iSUwWK1cfZbJ4sn4Ws8XfrntA2VvaFpd3
 zWGzmL/sKbvFhLavzBafl7awW6y5+ZTF4sQtaQchj8tXvD12zrrL7nH5bKnHplWdbB6bl9R7
 7L7ZwOaxs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAE8UXo2RfmlJakKGfnFJbZK0YYW
 RnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZ3ddb2Aum1Vec+nuBvYHxZ0oXIyeH
 hICJxK9Z9xi7GLk4hASWMkosXLWJCSIhIXF7YRMjhC0s8edaFxtE0XNGiWlz1rF2MXJwsAlo
 STR2soPUiAjkShzePAGsl1lgIbPEzR+sILawQKrEj+0rwWpYBFQlGhdNApvJK2At8evJDKj5
 8hIzL30Hq+EEis/Z3cIGYgsJWEl0zNrMBlEvKHFy5hMWiPnyEs1bZzNPYBSYhSQ1C0lqASPT
 KkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMDY3Xbs55YdjCtffdQ7xMjEwXiIUYKDWUmEt8Vf
 M1mINyWxsiq1KD++qDQntfgQoynQ3ROZpUST84HJI68k3tDMwNTQxMzSwNTSzFhJnNezoCNR
 SCA9sSQ1OzW1ILUIpo+Jg1OqgamcxX7f5YkTm6eVKHtmcfOul7m+8/qk8k/T7dWrpjQvXCn6
 d9pVHsuvW1WfBxTZrYtVrF0yV+DushnKJ8SzZs5dfJs74W6wNl+TuMSPHTe6LfwEHv9KS673
 2dgfEch4Uq9o+Yr1DW4OR943GS4ofxtofmDGkzcRcyZMydjw1aTobkdPSK30zyvpYp2fCibu
 3q0m+VCxfifvjzs6ym5pVvmbWl+9vfo44YRQkZ202Etv9de6Ma+fSnU7rI7Zt0ZHbfvfQ/NX
 qN/jENzxv/Foz6KbKnlP99ULX9tatuSxsZfOuQ8eD5ziZrhOv1DbaHPx7vwrqnzmDx+tyTdZ
 xn3306y++1xRfNwKp9TYF5ziXTNfiaU4I9FQi7moOBEAE8XxdmYDAAA=
X-CMS-MailID: 20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d
X-Msg-Generator: CA
X-RootMTR: 20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091134eucas1p275585b70fab48ba1f19eb5d2cc515b6d@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v14 13/13] dm: add power-of-2 target for zoned
 devices with non power-of-2 zone sizes
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
Cc: Pankaj Raghav <p.raghav@samsung.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Only zoned devices with power-of-2(po2) number of sectors per zone(zone
size) were supported in linux but now non power-of-2(npo2) zone sizes
support has been added to the block layer.

Filesystems such as F2FS and btrfs have support for zoned devices with
po2 zone size assumption. Before adding native support for npo2 zone
sizes, it was suggested to create a dm target for npo2 zone size device to
appear as a po2 zone size target so that file systems can initially
work without any explicit changes.

The design of this target is very simple: remap the device zone size to
the zone capacity and change the zone size to be the nearest power of 2
value.

For e.g., a device with a zone size/capacity of 3M will have an equivalent
target layout as follows:

Device layout :-
zone capacity = 3M
zone size = 3M

|--------------|-------------|
0             3M            6M

Target layout :-
zone capacity=3M
zone size = 4M

|--------------|---|--------------|---|
0             3M  4M             7M  8M

The area between target's zone capacity and zone size will be emulated
in the target.
The read IOs that fall in the emulated gap area will return 0 filled
bio and all the other IOs in that area will result in an error.
If a read IO span across the emulated area boundary, then the IOs are
split across them. All other IO operations that span across the emulated
area boundary will result in an error.

The target can be easily created as follows:
dmsetup create <label> --table '0 <size_sects> po2zoned /dev/nvme<id>'

The target does not support partial mapping of the underlying
device as there is no use-case for it.

Note:
This target is not related to dm-zoned target, which exposes a zoned block
device as a regular block device without any write constraint.

This target only exposes a different zone size than the underlying device.
The underlying device's other constraints will be directly exposed to the
target.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
Suggested-by: Hannes Reinecke <hare@suse.de>
---
 .../admin-guide/device-mapper/dm-po2zoned.rst |  79 +++++
 .../admin-guide/device-mapper/index.rst       |   1 +
 drivers/md/Kconfig                            |  10 +
 drivers/md/Makefile                           |   2 +
 drivers/md/dm-po2zoned-target.c               | 291 ++++++++++++++++++
 5 files changed, 383 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-po2zoned.rst
 create mode 100644 drivers/md/dm-po2zoned-target.c

diff --git a/Documentation/admin-guide/device-mapper/dm-po2zoned.rst b/Documentation/admin-guide/device-mapper/dm-po2zoned.rst
new file mode 100644
index 000000000000..8a35eab0b714
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/dm-po2zoned.rst
@@ -0,0 +1,79 @@
+===========
+dm-po2zoned
+===========
+The dm-po2zoned device mapper target exposes a zoned block device with a
+non-power-of-2(npo2) number of sectors per zone as a power-of-2(po2)
+number of sectors per zone(zone size).
+The filesystems that support zoned block devices such as F2FS and BTRFS
+assume po2 zone size as the kernel has traditionally only supported
+those devices. However, as the kernel now supports zoned block devices with
+npo2 zone sizes, the filesystems can run on top of the dm-po2zoned target before
+adding native support.
+
+Partial mapping of the underlying device is not supported by this target as
+there is no use-case for it.
+
+.. note::
+   This target is **not related** to **dm-zoned target**, which exposes a
+   zoned block device as a regular block device without any write constraint.
+
+   This target only exposes a different **zone size** than the underlying device.
+   The underlying device's other **constraints** will be exposed to the target.
+
+Algorithm
+=========
+The device mapper target maps the underlying device's zone size to the
+zone capacity and changes the zone size to the nearest po2 zone size.
+The gap between the zone capacity and the zone size is emulated in the target.
+E.g., a zoned block device with a zone size (and capacity) of 3M will have an
+equivalent target layout with mapping as follows:
+
+::
+
+  0M           3M  4M        6M 8M
+  |             |  |          |  |
+  +x------------+--+x---------+--+x-------  Target
+  |x            |  |x         |  |x
+   x               x             x
+   x               x             x
+   x              x             x
+   x             x             x
+  |x            |x            |x
+  +x------------+x------------+x----------  Device
+  |             |             |
+  0M           3M            6M
+
+A simple remap is performed for all the BIOs that do not cross the
+emulation gap area, i.e., the area between the zone capacity and size.
+
+If a BIO lies in the emulation gap area, the following operations are performed:
+
+	Read:
+		- If the BIO lies entirely in the emulation gap area, then zero out the BIO and complete it.
+		- If the BIO spans the emulation gap area, split the BIO across the zone capacity boundary
+                  and remap only the BIO within the zone capacity boundary. The other part of the split BIO
+                  will be zeroed out.
+
+	Other operations:
+                - Return an error
+
+Table parameters
+================
+
+::
+
+  <dev path>
+
+Mandatory parameters:
+
+    <dev path>:
+        Full pathname to the underlying block-device, or a
+        "major:minor" device-number.
+
+Examples
+========
+
+::
+
+  #!/bin/sh
+  echo "0 `blockdev --getsz $1` po2zoned $1" | dmsetup create po2z
diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index cde52cc09645..5df93711cef5 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -23,6 +23,7 @@ Device Mapper
     dm-service-time
     dm-uevent
     dm-zoned
+    dm-po2zoned
     era
     kcopyd
     linear
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 998a5cfdbc4e..74fdfd02ab5f 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -518,6 +518,16 @@ config DM_FLAKEY
 	help
 	 A target that intermittently fails I/O for debugging purposes.
 
+config DM_PO2ZONED
+	tristate "Zoned block devices target emulating a power-of-2 number of sectors per zone"
+	depends on BLK_DEV_DM
+	depends on BLK_DEV_ZONED
+	help
+	  A target that converts a zoned block device with non-power-of-2(npo2)
+	  number of sectors per zone to be power-of-2(po2). Use this target for
+	  zoned block devices with npo2 number of sectors per zone until native
+	  support is added to the filesystems and applications.
+
 config DM_VERITY
 	tristate "Verity target support"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 84291e38dca8..ee05722bc637 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -26,6 +26,7 @@ dm-era-y	+= dm-era-target.o
 dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
+dm-po2zoned-y	+= dm-po2zoned-target.o
 
 md-mod-y	+= md.o md-bitmap.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
@@ -60,6 +61,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_DUST)		+= dm-dust.o
 obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
+obj-$(CONFIG_DM_PO2ZONED)	+= dm-po2zoned.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
 obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
diff --git a/drivers/md/dm-po2zoned-target.c b/drivers/md/dm-po2zoned-target.c
new file mode 100644
index 000000000000..1d2f46a594f8
--- /dev/null
+++ b/drivers/md/dm-po2zoned-target.c
@@ -0,0 +1,291 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Samsung Electronics Co., Ltd.
+ */
+
+#include <linux/device-mapper.h>
+
+#define DM_MSG_PREFIX "po2zoned"
+
+struct dm_po2z_target {
+	struct dm_dev *dev;
+	sector_t zone_size; /* Actual zone size of the underlying dev*/
+	sector_t zone_size_po2; /* zone_size rounded to the nearest po2 value */
+	unsigned int zone_size_po2_shift;
+	sector_t zone_size_diff; /* diff between zone_size_po2 and zone_size */
+	unsigned int nr_zones;
+};
+
+static inline unsigned int npo2_zone_no(struct dm_po2z_target *dmh,
+					sector_t sect)
+{
+	return div64_u64(sect, dmh->zone_size);
+}
+
+static inline unsigned int po2_zone_no(struct dm_po2z_target *dmh,
+				       sector_t sect)
+{
+	return sect >> dmh->zone_size_po2_shift;
+}
+
+static inline sector_t device_to_target_sect(struct dm_target *ti,
+					     sector_t sect)
+{
+	struct dm_po2z_target *dmh = ti->private;
+
+	return sect + (npo2_zone_no(dmh, sect) * dmh->zone_size_diff) +
+	       ti->begin;
+}
+
+/*
+ * This target works on the complete zoned device. Partial mapping is not
+ * supported.
+ * Construct a zoned po2 logical device: <dev-path>
+ */
+static int dm_po2z_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct dm_po2z_target *dmh = NULL;
+	int ret;
+	sector_t zone_size;
+	sector_t dev_capacity;
+
+	if (argc != 1)
+		return -EINVAL;
+
+	dmh = kmalloc(sizeof(*dmh), GFP_KERNEL);
+	if (!dmh)
+		return -ENOMEM;
+
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &dmh->dev);
+	if (ret) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	if (!bdev_is_zoned(dmh->dev->bdev)) {
+		DMERR("%pg is not a zoned device", dmh->dev->bdev);
+		ret = -EINVAL;
+		goto bad;
+	}
+
+	zone_size = bdev_zone_sectors(dmh->dev->bdev);
+	dev_capacity = get_capacity(dmh->dev->bdev->bd_disk);
+	if (ti->len != dev_capacity) {
+		DMERR("%pg Partial mapping of the target is not supported",
+		      dmh->dev->bdev);
+		ret = -EINVAL;
+		goto bad;
+	}
+
+	if (is_power_of_2(zone_size))
+		DMWARN("%pg: underlying device has a power-of-2 number of sectors per zone",
+		       dmh->dev->bdev);
+
+	dmh->zone_size = zone_size;
+	dmh->zone_size_po2 = 1 << get_count_order_long(zone_size);
+	dmh->zone_size_po2_shift = ilog2(dmh->zone_size_po2);
+	dmh->zone_size_diff = dmh->zone_size_po2 - dmh->zone_size;
+	ti->private = dmh;
+	ti->max_io_len = dmh->zone_size_po2;
+	dmh->nr_zones = npo2_zone_no(dmh, ti->len);
+	ti->len = dmh->zone_size_po2 * dmh->nr_zones;
+	return 0;
+
+bad:
+	kfree(dmh);
+	return ret;
+}
+
+static void dm_po2z_dtr(struct dm_target *ti)
+{
+	struct dm_po2z_target *dmh = ti->private;
+
+	dm_put_device(ti, dmh->dev);
+	kfree(dmh);
+}
+
+static int dm_po2z_report_zones_cb(struct blk_zone *zone, unsigned int idx,
+				   void *data)
+{
+	struct dm_report_zones_args *args = data;
+	struct dm_target *ti = args->tgt;
+	struct dm_po2z_target *dmh = ti->private;
+
+	zone->start = device_to_target_sect(ti, zone->start);
+	zone->wp = device_to_target_sect(ti, zone->wp);
+	zone->len = dmh->zone_size_po2;
+	args->next_sector = zone->start + zone->len;
+
+	return args->orig_cb(zone, args->zone_idx++, args->orig_data);
+}
+
+static int dm_po2z_report_zones(struct dm_target *ti,
+				struct dm_report_zones_args *args,
+				unsigned int nr_zones)
+{
+	struct dm_po2z_target *dmh = ti->private;
+	sector_t sect =
+		po2_zone_no(dmh, dm_target_offset(ti, args->next_sector)) *
+		dmh->zone_size;
+
+	return blkdev_report_zones(dmh->dev->bdev, sect, nr_zones,
+				   dm_po2z_report_zones_cb, args);
+}
+
+static int dm_po2z_end_io(struct dm_target *ti, struct bio *bio,
+			  blk_status_t *error)
+{
+	if (bio->bi_status == BLK_STS_OK && bio_op(bio) == REQ_OP_ZONE_APPEND)
+		bio->bi_iter.bi_sector =
+			device_to_target_sect(ti, bio->bi_iter.bi_sector);
+
+	return DM_ENDIO_DONE;
+}
+
+static void dm_po2z_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct dm_po2z_target *dmh = ti->private;
+
+	limits->chunk_sectors = dmh->zone_size_po2;
+}
+
+static void dm_po2z_status(struct dm_target *ti, status_type_t type,
+			   unsigned int status_flags, char *result,
+			   unsigned int maxlen)
+{
+	struct dm_po2z_target *dmh = ti->private;
+	size_t sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%s %lld", dmh->dev->name,
+		       (unsigned long long)dmh->zone_size);
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s", dmh->dev->name);
+		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
+	}
+}
+
+/**
+ * dm_po2z_bio_in_emulated_zone_area - check if bio is in the emulated zone area
+ * @dmh:	target data
+ * @bio:	bio
+ * @offset:	bio offset to emulated zone boundary
+ *
+ * Check if a @bio is partly or completely in the emulated zone area. If the
+ * @bio is partly in the emulated zone area, @offset can be used to split
+ * the @bio across the emulated zone boundary. @offset
+ * will be negative if the @bio completely lies in the emulated area.
+ *
+ */
+static bool dm_po2z_bio_in_emulated_zone_area(struct dm_po2z_target *dmh,
+					      struct bio *bio, int *offset)
+{
+	unsigned int zone_idx = po2_zone_no(dmh, bio->bi_iter.bi_sector);
+	sector_t nr_sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+	sector_t sector_offset =
+		bio->bi_iter.bi_sector - (zone_idx << dmh->zone_size_po2_shift);
+
+	*offset = dmh->zone_size - sector_offset;
+
+	return sector_offset + nr_sectors > dmh->zone_size;
+}
+
+static inline void dm_po2z_read_zeroes(struct bio *bio)
+{
+	zero_fill_bio(bio);
+	bio_endio(bio);
+}
+
+static int dm_po2z_map(struct dm_target *ti, struct bio *bio)
+{
+	struct dm_po2z_target *dmh = ti->private;
+	int split_io_pos;
+
+	bio_set_dev(bio, dmh->dev->bdev);
+	bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
+
+	if (op_is_zone_mgmt(bio_op(bio)) || !bio_sectors(bio))
+		goto remap_sector;
+
+	if (!dm_po2z_bio_in_emulated_zone_area(dmh, bio, &split_io_pos))
+		goto remap_sector;
+
+	/*
+	 * Read operation on the emulated zone area (between zone capacity
+	 * and zone size) will fill the bio with zeroes. Any other operation
+	 * in the emulated area should return an error.
+	 */
+	if (bio_op(bio) == REQ_OP_READ) {
+		/*
+		 * If the bio is across emulated zone boundary, split the bio at
+		 * the boundary.
+		 */
+		if (split_io_pos > 0) {
+			dm_accept_partial_bio(bio, split_io_pos);
+			goto remap_sector;
+		}
+
+		dm_po2z_read_zeroes(bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+	/* Other IOs in emulated zone area should result in an error */
+	return DM_MAPIO_KILL;
+
+remap_sector:
+	/* convert from target sector to device sector */
+	bio->bi_iter.bi_sector -= (po2_zone_no(dmh, bio->bi_iter.bi_sector) *
+				   dmh->zone_size_diff);
+	return DM_MAPIO_REMAPPED;
+}
+
+static int dm_po2z_iterate_devices(struct dm_target *ti,
+				   iterate_devices_callout_fn fn, void *data)
+{
+	struct dm_po2z_target *dmh = ti->private;
+	sector_t len = dmh->nr_zones * dmh->zone_size;
+
+	return fn(ti, dmh->dev, 0, len, data);
+}
+
+static struct target_type dm_po2z_target = {
+	.name = "po2zoned",
+	.version = { 1, 0, 0 },
+	.features = DM_TARGET_ZONED_HM | DM_TARGET_EMULATED_ZONES |
+		    DM_TARGET_NOWAIT,
+	.map = dm_po2z_map,
+	.end_io = dm_po2z_end_io,
+	.report_zones = dm_po2z_report_zones,
+	.iterate_devices = dm_po2z_iterate_devices,
+	.module = THIS_MODULE,
+	.io_hints = dm_po2z_io_hints,
+	.status = dm_po2z_status,
+	.ctr = dm_po2z_ctr,
+	.dtr = dm_po2z_dtr,
+};
+
+static int __init dm_po2z_init(void)
+{
+	return dm_register_target(&dm_po2z_target);
+}
+
+static void __exit dm_po2z_exit(void)
+{
+	dm_unregister_target(&dm_po2z_target);
+}
+
+/* Module hooks */
+module_init(dm_po2z_init);
+module_exit(dm_po2z_exit);
+
+MODULE_DESCRIPTION(DM_NAME "power-of-2 zoned target");
+MODULE_AUTHOR("Pankaj Raghav <p.raghav@samsung.com>");
+MODULE_LICENSE("GPL");
+
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

