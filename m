Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8E5CE79AB
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695201018;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D1tXvAQrxICsZGRrkWNNg9vZqyMOBHn/ms5VQJgM/fQ=;
	b=be+FiGDrG2e+uD5IqbajDC3zRXm4jF3t4Tph0P4RSsUwaDEfvEqQv3xbDulXDJdqVhuba7
	YZMHC3mB6+BR+Fm7GXflGNJmY1eZz5edhSNKnr58gOIH8/rwH5Jlb36HfwXVEKTZhw/HXy
	FLklHhIPWjXQyaGOd4ytCLVz+v+ktJM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-Bd6gIodrOa6VSG_brxSguw-1; Wed, 20 Sep 2023 05:10:12 -0400
X-MC-Unique: Bd6gIodrOa6VSG_brxSguw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14E0D185A790;
	Wed, 20 Sep 2023 09:10:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED59E2156701;
	Wed, 20 Sep 2023 09:10:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 993AB1946594;
	Wed, 20 Sep 2023 09:10:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C44D194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 08:58:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1A98B40C6EC1; Wed, 20 Sep 2023 08:58:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 12A0F40C6EC0
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF0B038008A9
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:17 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-a6dv_lE0OGKPilmKaRZeSQ-1; Wed, 20 Sep 2023 04:58:15 -0400
X-MC-Unique: a6dv_lE0OGKPilmKaRZeSQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230920085812epoutp04c637cdf604d607612ea39ad623244ab0~Gj68nNq051265712657epoutp04D
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230920085812epoutp04c637cdf604d607612ea39ad623244ab0~Gj68nNq051265712657epoutp04D
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230920085811epcas5p282b9d9c0b16a7c30dff7c6d563b1b7dd~Gj68DxkQu2273322733epcas5p2G;
 Wed, 20 Sep 2023 08:58:11 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RrC9Y6VxCz4x9Q1; Wed, 20 Sep
 2023 08:58:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 CD.74.09949.124BA056; Wed, 20 Sep 2023 17:58:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230920081425epcas5p407a3b1ee776082798adb92e8025699f1~GjUuhAu0T2321223212epcas5p40;
 Wed, 20 Sep 2023 08:14:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230920081425epsmtrp226bf5e4a93a025c4257d97c0743b3497~GjUuf60FK0164101641epsmtrp2a;
 Wed, 20 Sep 2023 08:14:25 +0000 (GMT)
X-AuditID: b6c32a49-98bff700000026dd-5e-650ab4212680
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 32.FE.08742.1E9AA056; Wed, 20 Sep 2023 17:14:25 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230920081422epsmtip135b046fe83b44edbfd4fed015cd575c5~GjUrI0Vcg2886728867epsmtip1k;
 Wed, 20 Sep 2023 08:14:21 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 20 Sep 2023 13:37:38 +0530
Message-Id: <20230920080756.11919-2-nj.shetty@samsung.com>
In-Reply-To: <20230920080756.11919-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1CUZRTu/b7l2wsufoLiyzrJtk3EJS6bsLyIVBZDH+QPZoia0RxY2W+A
 2Bt7AaOyVSFAWyDRkoVAFEvAuIOLuMUl3AQNaQcIZgARqBkYQWQ1GkRiWSj/Pec55zzPOeed
 l4U7f8vksZLlGlolF0sFBIfR0uXl6ftSE4cOyFvwRbU9N3G08HiZgU4UrOCoejSfQLNdjwCa
 as8GyDRX7ICG21sxdOPiGQxVVndjqHv1AYHOdA4CND1gwJBpxAeVf1nBQDdMtxjIcr2EQGXf
 TzPR6SEjgX4wP8PQHwXTABmnjgPUslyGo5rZeQb6dWQX6lsxO7zFo1oNo0yqb6yeQVnuaKmG
 qlyCaqz4gmob1hHUpbxCB0p/co6gFqZHGNT8TwMElddUBajG3k+pxYbdVMPUAyza6WDKviRa
 LKFVfFqeoJAkyxPDBO/FxL0TFyQKEPoKQ1CwgC8Xy+gwQfiBaN+IZOnaNQT8NLFUu0ZFi9Vq
 gf8b+1QKrYbmJynUmjABrZRIlYFKP7VYptbKE/3ktGavMCDg9aC1wviUJGve58rssKOWQiOm
 A017TgE2C5KB8PeZx+AU4LCcyTYA6zqGGfbgEYCTq5aNzBMAB8/nOWy2PCmadrAnTAA2l7QT
 9iALg/UXf8ROARaLIH1g7yrLxm8ndTisa7u0LoWTXTjsLr9P2KRcyMPwztJfmA0zyFfgUr1l
 3YJL7oUT/RWETQiS/jB/fJuNZpOhcLFiiGkv2QZvFU0xbBgn3eHJ5mLcpg/Ja2y4YJ3A7KOG
 w4HhmY2xXeCMuYlpxzy4OGci7DgdVp69QtibMwE0DBmAPfEmzOrJx21D4KQXrL3ub6dfhOd6
 ajC7sRPUL09teHGhsXQTvwyv1l7Y0HeDg38f39iFgh16jv1YeQBWG78CBYBveG4fw3P7GP53
 vgDwKuBGK9WyRFodpBTK6fT/XjlBIWsA6z/EO9IIRu899OsEGAt0AsjCBdu5Mg8O7cyViD/J
 oFWKOJVWSqs7QdDavb/GeTsSFGtfTK6JEwaGBASKRKLAkD0ioWAndzbrO4kzmSjW0Ck0raRV
 m30Yi83TYVsdTGWLd397NbJS4Xa+QzPG3WKNcaozn20+nDK5oyZV8PTIsdxD2pgrL7QXZbL/
 CWkfKU7sL2G4p2abjWUSLj7RveID1O69HzoOeI7Tjt+wbqfqdOzY9ys5XaLxgoctCUuvwWuW
 n11je/bn9rR4B98uP+Qu+1O/ag5a9jiSeG5rbYYfs2S3PiLn7RJT5GW+9ZfPovCrnBxltrfX
 0fvvcvodo7ZIL0d9wAtodR/fv7Nw/t4uVZvVwzoa+FGaa5rE7+7BsczgeEV0qOSpy+rNTI5e
 Vq/1dj1RxystHZmv/rhPj0yNIRmmiKK6Z7GTnTlQVHjAEH4sNLsiKx00d3hmxzsKGOoksdAb
 V6nF/wJYbdxeqgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSnO7DlVypBovaFSzWnzrGbPHx628W
 i6YJf5ktVt/tZ7N4ffgTo8WTA+2MFnvfzWa1uHlgJ5PFnkWTmCxWrj7KZHH0/1s2i0mHrjFa
 PL06i8li7y1ti4VtS1gs9uw9yWJxedccNov5y56yW3Rf38Fmsfz4PyaLGxOeMlrseNLIaLHt
 93xmi3Wv37NYnLglbXH+73FWBymPnbPusnucv7eRxePy2VKPTas62Tw2L6n32H2zgc1jcd9k
 Vo/e5ndsHh+f3mLxeL/vKptH35ZVjB6bT1d7fN4k57HpyVumAL4oLpuU1JzMstQifbsErowv
 fbUF7bYVlyfvYGpg3GLcxcjJISFgIvFt5lPWLkYuDiGB3YwSK16sZIVISEos+3uEGcIWllj5
 7zk7RFEzk8T9BZOAEhwcbALaEqf/c4DERQS6mCU6d75jAXGYBS4zS0xbeIQRpFtYIFpiRlsH
 mM0ioCrxY+NlsA28AlYSDy8uYQMZJCGgL9F/XxAkzClgLfF5yXV2EFsIqOT0hfnsEOWCEidn
 PmEBsZkF5CWat85mnsAoMAtJahaS1AJGplWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmb
 GMExrqW5g3H7qg96hxiZOBgPMUpwMCuJ8OaqcaUK8aYkVlalFuXHF5XmpBYfYpTmYFES5xV/
 0ZsiJJCeWJKanZpakFoEk2Xi4JRqYOLjU7zw7/eeOwa75SvSzibN35V+SeFcZd6rvW4hHYEJ
 01uM669PmSqzMky8qUklSk8w2qq0vif3VP+LrzWRsR57Xr3dsS124kKXhUozJ8TGh9+YuenR
 ycwv/F61decVJ9pMnrki801f9f9Ax6lHZ/cfk/584ggHS/upaSFmSnvjN/yrnfnw2J0wcZ4c
 7TeXJ/0/2pAV27FD9qbcXf/s7l2/vO30r/DP5A8PfJAdVu1Q+ary5++nzMduTFt83ayB18Nn
 yU5BWY/+Mw/X2JqYlbHsOZc79YlFTonwpvDFFSvzbpzTtY4/W2G8f164/UsRrdTQxftv/fQV
 6ZY8e8d5QvqcmKxfJ/pLFtWdu5N9+4kSS3FGoqEWc1FxIgBsDchvYAMAAA==
X-CMS-MailID: 20230920081425epcas5p407a3b1ee776082798adb92e8025699f1
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081425epcas5p407a3b1ee776082798adb92e8025699f1
References: <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081425epcas5p407a3b1ee776082798adb92e8025699f1@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v16 01/12] block: Introduce queue limits and
 sysfs for copy-offload support
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
Cc: Anuj Gupta <anuj20.g@samsung.com>, anuj1072538@gmail.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-doc@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, mcgrof@kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add device limits as sysfs entries,
	- copy_max_bytes (RW)
	- copy_max_hw_bytes (RO)

Above limits help to split the copy payload in block layer.
copy_max_bytes: maximum total length of copy in single payload.
copy_max_hw_bytes: Reflects the device supported maximum limit.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 Documentation/ABI/stable/sysfs-block | 23 ++++++++++++++++++
 block/blk-settings.c                 | 24 +++++++++++++++++++
 block/blk-sysfs.c                    | 36 ++++++++++++++++++++++++++++
 include/linux/blkdev.h               | 13 ++++++++++
 4 files changed, 96 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 1fe9a553c37b..96ba701e57da 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -155,6 +155,29 @@ Description:
 		last zone of the device which may be smaller.
 
 
+What:		/sys/block/<disk>/queue/copy_max_bytes
+Date:		August 2023
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RW] This is the maximum number of bytes that the block layer
+		will allow for a copy request. This is always smaller or
+		equal to the maximum size allowed by the hardware, indicated by
+		'copy_max_hw_bytes'. An attempt to set a value higher than
+		'copy_max_hw_bytes' will truncate this to 'copy_max_hw_bytes'.
+		Writing '0' to this file will disable offloading copies for this
+		device, instead copy is done via emulation.
+
+
+What:		/sys/block/<disk>/queue/copy_max_hw_bytes
+Date:		August 2023
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] This is the maximum number of bytes that the hardware
+		will allow for single data copy request.
+		A value of 0 means that the device does not support
+		copy offload.
+
+
 What:		/sys/block/<disk>/queue/crypto/
 Date:		February 2022
 Contact:	linux-block@vger.kernel.org
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0046b447268f..4441711ac364 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,6 +59,8 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
+	lim->max_copy_hw_sectors = 0;
+	lim->max_copy_sectors = 0;
 }
 
 /**
@@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
 	lim->max_zone_append_sectors = UINT_MAX;
+	lim->max_copy_hw_sectors = UINT_MAX;
+	lim->max_copy_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -183,6 +187,22 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
+/*
+ * blk_queue_max_copy_hw_sectors - set max sectors for a single copy payload
+ * @q:	the request queue for the device
+ * @max_copy_sectors: maximum number of sectors to copy
+ */
+void blk_queue_max_copy_hw_sectors(struct request_queue *q,
+				   unsigned int max_copy_sectors)
+{
+	if (max_copy_sectors > (BLK_COPY_MAX_BYTES >> SECTOR_SHIFT))
+		max_copy_sectors = BLK_COPY_MAX_BYTES >> SECTOR_SHIFT;
+
+	q->limits.max_copy_hw_sectors = max_copy_sectors;
+	q->limits.max_copy_sectors = max_copy_sectors;
+}
+EXPORT_SYMBOL_GPL(blk_queue_max_copy_hw_sectors);
+
 /**
  * blk_queue_max_secure_erase_sectors - set max sectors for a secure erase
  * @q:  the request queue for the device
@@ -578,6 +598,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
+	t->max_copy_sectors = min(t->max_copy_sectors, b->max_copy_sectors);
+	t->max_copy_hw_sectors = min(t->max_copy_hw_sectors,
+				     b->max_copy_hw_sectors);
+
 	t->misaligned |= b->misaligned;
 
 	alignment = queue_limit_alignment_offset(b, start);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 63e481262336..4840e21adefa 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -199,6 +199,37 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
 	return queue_var_show(0, page);
 }
 
+static ssize_t queue_copy_hw_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)
+		       q->limits.max_copy_hw_sectors << SECTOR_SHIFT);
+}
+
+static ssize_t queue_copy_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)
+		       q->limits.max_copy_sectors << SECTOR_SHIFT);
+}
+
+static ssize_t queue_copy_max_store(struct request_queue *q, const char *page,
+				    size_t count)
+{
+	unsigned long max_copy;
+	ssize_t ret = queue_var_store(&max_copy, page, count);
+
+	if (ret < 0)
+		return ret;
+
+	if (max_copy & (queue_logical_block_size(q) - 1))
+		return -EINVAL;
+
+	max_copy >>= SECTOR_SHIFT;
+	q->limits.max_copy_sectors = min_t(unsigned int, max_copy,
+					   q->limits.max_copy_hw_sectors);
+
+	return count;
+}
+
 static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(0, page);
@@ -517,6 +548,9 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
 QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
 QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
 
+QUEUE_RO_ENTRY(queue_copy_hw_max, "copy_max_hw_bytes");
+QUEUE_RW_ENTRY(queue_copy_max, "copy_max_bytes");
+
 QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
 QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
 QUEUE_RW_ENTRY(queue_poll, "io_poll");
@@ -633,6 +667,8 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_copy_hw_max_entry.attr,
+	&queue_copy_max_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index eef450f25982..7548f1685ee9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -309,6 +309,9 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
+	unsigned int		max_copy_hw_sectors;
+	unsigned int		max_copy_sectors;
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -893,6 +896,8 @@ extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_discard_segments(struct request_queue *,
 		unsigned short);
+extern void blk_queue_max_copy_hw_sectors(struct request_queue *q,
+					  unsigned int max_copy_sectors);
 void blk_queue_max_secure_erase_sectors(struct request_queue *q,
 		unsigned int max_sectors);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
@@ -1211,6 +1216,14 @@ static inline unsigned int bdev_discard_granularity(struct block_device *bdev)
 	return bdev_get_queue(bdev)->limits.discard_granularity;
 }
 
+/* maximum copy offload length, this is set to 128MB based on current testing */
+#define BLK_COPY_MAX_BYTES		(1 << 27)
+
+static inline unsigned int bdev_max_copy_sectors(struct block_device *bdev)
+{
+	return bdev_get_queue(bdev)->limits.max_copy_sectors;
+}
+
 static inline unsigned int
 bdev_max_secure_erase_sectors(struct block_device *bdev)
 {
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

