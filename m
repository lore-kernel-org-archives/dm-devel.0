Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B623CC77B77
	for <dm-devel@archiver.kernel.org>; Wed, 12 Apr 2023 06:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681281568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zMy/BGtsUw7FW0QIdAUS4FUPKPqni+ghgP9EX5fVAnc=;
	b=ezfK3Rr+QRijyzpe+yLN6r0SyQSru5/K7s+rV0mcTGp4Ww/9mY8+5xrQugNslhkoF0cFzZ
	LqPruDK254QO7lKpJ1Y3wi1zZC+akAYqMXE6s+0zjxwa3vhwpsjfFXgW0iL/hEDPc+Np22
	exNmcqsUxzyh16cSOcXHbjbUcMWy2vI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-_03BDukFOWmrhMeC2WApCw-1; Wed, 12 Apr 2023 02:39:25 -0400
X-MC-Unique: _03BDukFOWmrhMeC2WApCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E2543C0F684;
	Wed, 12 Apr 2023 06:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 467F640C83A9;
	Wed, 12 Apr 2023 06:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B699C19472D4;
	Wed, 12 Apr 2023 06:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1FB0A1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 08:19:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 02ED6C15BBA; Tue, 11 Apr 2023 08:19:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EE654C15BB8
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B99B1800B23
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:32 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-XDo5TrptNKW8gynRzryhtQ-1; Tue, 11 Apr 2023 04:19:31 -0400
X-MC-Unique: XDo5TrptNKW8gynRzryhtQ-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230411081927epoutp02f2d3f78851468d182b9d6c03f6749692~U044NMvIt0479104791epoutp02D
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230411081927epoutp02f2d3f78851468d182b9d6c03f6749692~U044NMvIt0479104791epoutp02D
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230411081927epcas5p1713b44eac41715d509f27fc66575b7be~U043rdlaf0857608576epcas5p1S;
 Tue, 11 Apr 2023 08:19:27 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4PwdzX62G3z4x9QJ; Tue, 11 Apr
 2023 08:19:20 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 24.6B.09961.80815346; Tue, 11 Apr 2023 17:19:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230411081313epcas5p1ce798f50564cefde203c730980b7d557~U0zb5qb6z0300903009epcas5p15;
 Tue, 11 Apr 2023 08:13:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230411081313epsmtrp13c39e473fafb0aee76348d6b1013b46a~U0zb2-1Jp1886118861epsmtrp1a;
 Tue, 11 Apr 2023 08:13:13 +0000 (GMT)
X-AuditID: b6c32a49-2c1ff700000026e9-46-64351808a27a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 B0.1F.08279.99615346; Tue, 11 Apr 2023 17:13:13 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081308epsmtip29cdda8c4b5592a8bf683a23dae46fb91~U0zXIqfFz2397423974epsmtip2S;
 Tue, 11 Apr 2023 08:13:08 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Apr 2023 13:40:31 +0530
Message-Id: <20230411081041.5328-5-anuj20.g@samsung.com>
In-Reply-To: <20230411081041.5328-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1CTdRzH7/s842Fw4T0C5rdZiLs8EOXHgOEXk0hDfYyyReeV5h0+xx42
 ZL9uG2JJ55Ik9YAhFXdtxDDMFC6xMX4IDGooP2Y0dJChArMbdbnjl/YDRaCNjfK/1+f9eX/u
 8+N7XzYeXOzPYefI1IxSRku4RCCrqWtDVDQb8oVxro4AVG/txtHxsnkc1Y1oCeTqegBQxfQj
 HDk6U5F5Uu+Hhr+/gqH2r8oxdLHuGobazs5g6NriBIHKLT8DND6kw5D59kbUbu5jIXtrJYEM
 58f9keXTQgy1OD8CqGnOgKNLrikW6r29Btnme/xegZR9MJ3SjfUT1BXdiD9lG/2ORdn78yhj
 7SmCajh3jGob1hBUSeEkQU11DBFUqakWUA3Xj1IPjWGU0TmBCVbsz90qZmghowxnZFlyYY5M
 lMJNfzvz1Ux+UhwvmpeMNnPDZbSUSeGmvS6I3pkjcV+AG36YluS5JQGtUnFjX96qlOepmXCx
 XKVO4TIKoUSRqIhR0VJVnkwUI2PUW3hxcfF8t/Fgrrh5oJGlMEcemW66ztKAe+tOgwA2JBPh
 yW/+YZ0Ggexgsg1AU9MFzBs8ALCxVO/vDf4G0PbI4b9cYrwxgHsTZgBL+yYwTyKYLMRg58Ie
 DxNkBLz6+wngMYWSRTicGT+11AQnb2LwiWkK97hCyANweLKO8DCLXA8d395a0oNIBMe6PB62
 u10s1I6t9MgBZDJ88uVJwmtZCfu+cLI8jJNrYWGjfmkiSNYEwM6OO75R06Dx8aifl0Pg/R6T
 T+fAP7RFPhbBWfs45mUFLOzuAF5OhSes2qUZcHIDrG+N9covwM+tlzBv3xWwZM7pKw2CLVXL
 zIWfXKz0MYTmnzQ+pqCj8q7vvsUAnq224mUgXPfUPrqn9tH937oa4LXgOUahkooYFV/BkzH5
 /z1zllxqBEvfImp3CxhxTMdYAMYGFgDZODc06K/FBGFwkJB+/wNGKc9U5kkYlQXw3fc+g3NW
 Zcnd/0qmzuQlJsclJiUlJSYnJPG4q4MiUvqygkkRrWZyGUbBKJfrMHYAR4MRmyrC7nXkdxU0
 RN3NzrSaY4Ra5y8i28Bq/f6121+aM2QM1QfGM8KD2c3KdTSnsq77xcCPhX39ijc32WbWHNn2
 WFZbtTujuBe+eznk16ODeMjzN8MqLux4LX1wb4vcaM6QzUi1HJWgyH5s431RjUS/paxeYhd0
 5g+lDYw9bK3KyE4Xv1G/w9ZzKGFeLdp2CDdk74kB3akHjEWDmq/PzTrYkTWCH3ZG7Ns1sj2+
 JMXFIeL7z7v2ts+i4xZnb2TdO6yFD/naGwu7bq0qslXvC3zWdNXVcjmnuYC3/hmp3pb+lmnz
 j38WRCzayqtR7FDob/MnNe+FfGZtvzNqEA/k9BimD3NZKjHNi8KVKvpfXh6PFZ8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Rf0yMcRzHfZ/n6ekpTk9Xy5em5tSIXD/IviYhP/YIYzbLCnXcs6t1d7W7
 ToTuqmXJUsuWdbGU3LqIdalz1ZEnItWKyI/JZaL87C6OoaSr2fz3+rxf7+39x4fC+beJeVSi
 PJVVyEVSAelKNLQKfJeVeIWJg01jQnTtQRuOsgrHcXS5v4BEH1tHASq2/sTRwK21yPyl1Ak9
 bzFhqLmiCEP6y3cx1FRuw9Ddic8kKuL6AHr7RIsh84ulqNncTqDexnMkKtO9dUbcmWwM3RjM
 BKjhdxmOrn4cIdD9F96oe/ye0zrI9D7eymgtXSRj0vY7M92vagmmt0vFGKpPkkxdpZppeq4h
 mfzsLyQzcvMJyZy+Xg2Yuo6jzFeDD2MY/IztnB3jGi5mpYmHWEVQRLxrgrGnnkgxLz5sbegg
 NOD1gjzgQkF6BTQ87MEdzKebAOzpjJ3OIXzwXgem2QPq/ww55wHXyU4mBu2Gr4RDkPQieGco
 BziEJ12Iw0cWDek4cHoAg91D35wcLQ86BlYMXSQdTND+cKDm6dQcj0bQ0joyydTkRBAssLg7
 Yhd6FRw7n0s6Yv5kpbKZmG67w/aSwSnGaV+YXV+KFwJa+5/S/qcuAKwazGVTlDKJTBmSEiJn
 04RKkUypkkuEB5NlBjD15SUBN4Cx2irkAEYBDkAKF3jy7BPLxXyeWHQknVUkxylUUlbJAW+K
 EMzh9eS1x/FpiSiVTWLZFFbxz2KUyzwNVhPWmGMdu7lv2MbNYH2yohK3bbpe07Zs7/YATYws
 /mRRFld2bmzYu8QYMGC8doqcMypfE9vQ7rV6YmNSllNz9K/wE5Gm0R9ViVigWu3XFxN8wHip
 fs/p+Ee5z/QbhtuqvLaEznoXJayJCOesobWa2HQ3CdhhD9b6JekWtKiucNmekYzJQtqWZ5pm
 f6+dqbIFNI6/rJDkzkjz0m2Q6swRb0Lz2eRLgatyPtmP709LJ4LOrm/N2JWm3CK2rZRGdx6z
 R2121xMFt0M6jhs/VPXBfvVrl2TZ/F1uJeqrNnUkxSveL4jy317RRbhnuA2OdGWUa/csjLX5
 HKtq0u8u2H1FQCgTRCFLcIVS9Be63jIhVAMAAA==
X-CMS-MailID: 20230411081313epcas5p1ce798f50564cefde203c730980b7d557
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230411081313epcas5p1ce798f50564cefde203c730980b7d557
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081313epcas5p1ce798f50564cefde203c730980b7d557@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 12 Apr 2023 06:39:18 +0000
Subject: [dm-devel] [PATCH v9 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

For direct block device opened with O_DIRECT, use copy_file_range to
issue device copy offload, and fallback to generic_copy_file_range incase
device copy offload capability is absent.
Modify checks to allow bdevs to use copy_file_range.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/blk-lib.c        | 19 +++++++++++++++++++
 block/fops.c           | 20 ++++++++++++++++++++
 fs/read_write.c        | 11 +++++++++--
 include/linux/blkdev.h |  3 +++
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b6e0f5b1f31..b6e193603789 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -512,6 +512,25 @@ int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
 }
 EXPORT_SYMBOL_GPL(blkdev_issue_copy);
 
+int blkdev_copy_offload(struct block_device *bdev_in, loff_t pos_in,
+		      struct block_device *bdev_out, loff_t pos_out, size_t len,
+		      cio_iodone_t endio, void *private, gfp_t gfp_mask)
+{
+	struct request_queue *in_q = bdev_get_queue(bdev_in);
+	struct request_queue *out_q = bdev_get_queue(bdev_out);
+	int ret = 0;
+
+	if (blkdev_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len))
+		return 0;
+
+	if (blk_queue_copy(in_q) && blk_queue_copy(out_q))
+		ret = __blkdev_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
+				len, endio, private, gfp_mask);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blkdev_copy_offload);
+
 static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned flags)
diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..3b7c05831d5c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -611,6 +611,25 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+static ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out,
+				size_t len, unsigned int flags)
+{
+	struct block_device *in_bdev = I_BDEV(bdev_file_inode(file_in));
+	struct block_device *out_bdev = I_BDEV(bdev_file_inode(file_out));
+	int comp_len = 0;
+
+	if ((file_in->f_iocb_flags & IOCB_DIRECT) &&
+		(file_out->f_iocb_flags & IOCB_DIRECT))
+		comp_len = blkdev_copy_offload(in_bdev, pos_in, out_bdev,
+				 pos_out, len, NULL, NULL, GFP_KERNEL);
+	if (comp_len != len)
+		comp_len = generic_copy_file_range(file_in, pos_in + comp_len,
+			file_out, pos_out + comp_len, len - comp_len, flags);
+
+	return comp_len;
+}
+
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
@@ -694,6 +713,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.copy_file_range = blkdev_copy_file_range,
 };
 
 static __init int blkdev_init(void)
diff --git a/fs/read_write.c b/fs/read_write.c
index a21ba3be7dbe..47e848fcfd42 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -20,6 +20,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/blkdev.h>
 #include "internal.h"
 
 #include <linux/uaccess.h>
@@ -1447,7 +1448,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 		return -EOVERFLOW;
 
 	/* Shorten the copy to EOF */
-	size_in = i_size_read(inode_in);
+	if (S_ISBLK(inode_in->i_mode))
+		size_in = bdev_nr_bytes(I_BDEV(file_in->f_mapping->host));
+	else
+		size_in = i_size_read(inode_in);
+
 	if (pos_in >= size_in)
 		count = 0;
 	else
@@ -1708,7 +1713,9 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 	/* Don't copy dirs, pipes, sockets... */
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
-	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+
+	if ((!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode)) &&
+		(!S_ISBLK(inode_in->i_mode) || !S_ISBLK(inode_out->i_mode)))
 		return -EINVAL;
 
 	if (!(file_in->f_mode & FMODE_READ) ||
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a54153610800..468d5f3378e2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1057,6 +1057,9 @@ int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
 		      struct block_device *bdev_out, loff_t pos_out, size_t len,
 		      cio_iodone_t end_io, void *private, gfp_t gfp_mask);
+int blkdev_copy_offload(struct block_device *bdev_in, loff_t pos_in,
+		      struct block_device *bdev_out, loff_t pos_out, size_t len,
+		      cio_iodone_t end_io, void *private, gfp_t gfp_mask);
 struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 		gfp_t gfp_mask);
 void bio_map_kern_endio(struct bio *bio);
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

