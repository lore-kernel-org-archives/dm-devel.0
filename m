Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B674EC77B6D
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157988;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oZe4KPMV6MIdMneHx6pgePnseu1zWBDJVOw7QkpBRHE=;
	b=Nj5O0tLBJmNfTW4BVTV991WoMuT/aX1pf0AHuKtxRpuUa4bynfm464V1ogvL9Yw+7L9Mg0
	4nwk1sjB54jIVZ0H/86kx5ng+hL+QI0oHYCUWH8qGwCd4BoQ7pkrEzUIVl7dKKz8r/iuXC
	uHiKEHgrOW6SH8cuM3ij3qfzSvfVDvE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-DFN_RyfCMlSXLyP_54Brkw-1; Thu, 30 Mar 2023 02:33:04 -0400
X-MC-Unique: DFN_RyfCMlSXLyP_54Brkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E39F28030DF;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E77B9406AA66;
	Thu, 30 Mar 2023 06:32:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8522519465B7;
	Thu, 30 Mar 2023 06:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6121A194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:26:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 37ACC18EC6; Wed, 29 Mar 2023 08:26:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FDA3440D9
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0935385A588
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:09 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-YGC7RTflOI694k70zYi1vQ-1; Wed, 29 Mar 2023 04:26:07 -0400
X-MC-Unique: YGC7RTflOI694k70zYi1vQ-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230329081616epoutp0172f04babb3e06a32e3ad75be12dc03c2~Q1dX55TFv1284412844epoutp01J
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:16:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230329081616epoutp0172f04babb3e06a32e3ad75be12dc03c2~Q1dX55TFv1284412844epoutp01J
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230329081615epcas5p14300f1ae4f62c3d77912cb5bed32fae8~Q1dXNOwWs0780307803epcas5p1G;
 Wed, 29 Mar 2023 08:16:15 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4PmfWx0ScCz4x9QN; Wed, 29 Mar
 2023 08:16:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 86.C5.55678.CC3F3246; Wed, 29 Mar 2023 17:16:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4~QOh6-F6-N3074330743epcas5p1C;
 Mon, 27 Mar 2023 08:42:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230327084244epsmtrp1cff790198889bdcd3d04f686e0b3d729~QOh6_Nzdt3087530875epsmtrp14;
 Mon, 27 Mar 2023 08:42:44 +0000 (GMT)
X-AuditID: b6c32a4a-909fc7000000d97e-35-6423f3cced03
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 66.3C.18071.40751246; Mon, 27 Mar 2023 17:42:44 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084241epsmtip156d3b8206492a759af558e21583618b1~QOh3v8lla2834728347epsmtip1f;
 Mon, 27 Mar 2023 08:42:41 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Mon, 27 Mar 2023 14:10:52 +0530
Message-Id: <20230327084103.21601-5-anuj20.g@samsung.com>
In-Reply-To: <20230327084103.21601-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHPfeWPjCwy8N4hnt0l0wGCLRYysHZsWS63MmMbHMuM3HY0Tta
 6Wt9yJhbeJRiwGARg4uFiAN0QCdsII6HJaYKyGskA0R0BebKKnSCSKZbwLCWls3/Pr9vft/f
 6+Sw8eBTrDC2TKmjNUqxnGT6M65cj4yKGVwKl/CMdQLU1N+Do/zSpziy2E1M5Lr+CKAzD//B
 0fLQMI6s8xV+aOJaO4auVpdhqN7SjaHObxcx1L36gInKbLcAmhkzY8h6JxpdtfYx0EhHJRNV
 XZxhIdtpA4baHHkAXVmuwlGja4GBbt7Zgoaf9vq9CamR0RTKPDXEpNrNdhY1PPkjgxoZ0lPN
 DUVMqqU2h+qcyGVSJYZ5d4Jxyo9a6BpjUicvNwCqZeAYtdT8EtXseIClPncwc6eUFktoDZdW
 pqskMmWGiEz5IO2ttAQhjx/DT0KJJFcpVtAicte7qTFvy+TuO5Dco2K53i2lirVaMu6NnRqV
 XkdzpSqtTkTSaolcLVDHasUKrV6ZEaukdTv4PF58gjvxcKa0ytaOqb9/7Yum3hOsXND9SjHg
 sCEhgPk9fSwPBxOdAA5OHioG/m5+BGCe/TvgDR4DeKFlEqw7rt07x/Q6rADaR+K8SQYMroyN
 rpViEhHwhtO45g4lCnG4OFPE8AQ4MY3BqvzatVIhxCG4Wlq2VopBvArHLC7cwwFEEhxoPOnW
 2e52cdA0FeSROcQOWNnW7+dNCYJ9Zx0MD+PEy9DQWoF76kPCwoFne4dY3lF3wbumVoaXQ+Bc
 72WfHgZnTYU+zoB/j8xgXlZDQ0+Xb81kaOw34Z4ZcCISNnXEeeUXYXl/I+btGwhLlh0+awBs
 O7fOJDxeX+ljCK0/5/qYgsMd55nea5UAONn9hFEKuOZn9jE/s4/5/9bnAd4AnqfVWkUGrU1Q
 xyvprP9eOV2laAZrfyNqTxv4bfphrA1gbGADkI2ToQHLt0hJcIBEnP0lrVGlafRyWmsDCe57
 n8LDNqWr3J9LqUvjC5J4AqFQKEjaLuSTmwMiRH3pwUSGWEdn0rSa1qz7MDYnLBermF36y+HY
 GHgwmW3ZH8c7UjOu2RY/uKGupODokwmOtkjxOD36vkjWAz4OL2HVJkoD5aOWlf0FDZ/U3VyI
 cn4999mF0+8nFhxvH/x194Ya26fZ9vHSshrZT/z60OKLmVyH/cbv43LRloJ901/VhHy+8RtJ
 MV+z3f+FvMnw1Zyt8XOjP9TObr7n4p9Q35b+cmTRGPS6c+LPxuigVfY7m+46hV1ThzX5ya0T
 iXvG9nVGuLauRO7tnBlQhFuc7Xppimzso8TsY5fu16rY5dIDRMWZCjor2k+1GujqSdE7RbY/
 PjzAcQYZa7K6ZKrFwmbu3pXq+b7w0Orx93K2WW5fElhNhqPlJEMrFfOjcI1W/C99hxNMpAQA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Rf0yMcRzH+36fp6en7ObpMN+E9PiVX6VlfLXE/HzU0ObnxDjd48RdtefK
 jxintKjR6bbShfJjpy5OdUp1hd05uXI7K2fTKNnRSElmRoWuZvPfZ5/X6/3eZ/vQhPgpOYmO
 T0jmhQSJnKV8yGoLO3UBuT1QuvC7aha+2/SEwGnqIQKXvcmhcLelH+C8vp8EHrA7CNzQW+iJ
 Xz2qhbj+ei7EpWVWiE3XvkJs/dND4VzzS4DfO7UQN7TNw/UNNhK31l2mcJHuvRc2a9IhrnGd
 Brh6oIjAhu4vJH7a5o8dQ42eKxDX+iKa03bYKa5W+8aLc7RXkFyrPYWr1J+jOOPNU5zplYri
 zqf3DgsZHZ7clwdOirtwTw84Y/Nx7lvlVK7S1QNjxu70iZDy8vjDvBASudfnQJG5FibdDjp6
 tzHbSwWsgVnAm0bMIvTo3VUqC/jQYsYE0OvMNM9RgFDTRx0Ynceh0t9dXqPSaYjUli7CDShm
 NnrclQHcYDyjJlBLh2qkimB6IdJ36oaraHocE4vaM0+4AyQzEznLukfCImYpajZcoNwKYkJQ
 Toeve+3NhKPLNU0jR4iHlZzMOjiq+yJbgYt0zwQTgNKrCgk1YLT/Ie1/qBhAPfDjk5QKmUIZ
 mhSawB8JVkoUypQEWXBcoqISjDx77pwacF/fF2wGkAZmgGiCHS8yRgdKxSKp5FgqLyTuEVLk
 vNIM/GmSnSh6nmXbI2ZkkmT+EM8n8cI/CmnvSSrol6z5tcy16rPT0E6HWEseyuYVpa4si5ps
 EKt7VufrGoK62f7VjpO+bdbp36Jdt9gJvQWZ36+0bJ1yv+aMbvHuAtiTPXiJyl9aVVcIBhrT
 dm1ZV5u/L97biVMXxsTJ7BXFYevzDKYxtoBtnVVb+sf4b1I83Hvk5do4AM9sKrHFc0PGr3PK
 /3wo1+RudQge0+xnoSiiZeyPMP7G/KgnawbDsy/KGU3A7Nj8XZ2ktHz584ySMGFjf3WgeXuX
 Rh5xNTJ8iR970NJXkecR+2nCjpmR8npbyvmoOwUwwmNwYkxxYkizzln6NigKr5Ueb2RnKIXN
 dtOGWx8tp5pSD5qMz/azpPKAJHQuISglfwGRSWizWwMAAA==
X-CMS-MailID: 20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: [dm-devel] [PATCH v8 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device.
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
 linux-block@vger.kernel.org, nitheshshetty@gmail.com,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 Nitesh Shetty <nj.shetty@samsung.com>
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
 block/blk-lib.c        | 22 ++++++++++++++++++++++
 block/fops.c           | 20 ++++++++++++++++++++
 fs/read_write.c        | 11 +++++++++--
 include/linux/blkdev.h |  3 +++
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index a21819e59b29..c288573c7e77 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -475,6 +475,28 @@ static inline bool blk_check_copy_offload(struct request_queue *q_in,
 	return blk_queue_copy(q_in) && blk_queue_copy(q_out);
 }
 
+int blkdev_copy_offload(struct block_device *bdev_in, loff_t pos_in,
+		      struct block_device *bdev_out, loff_t pos_out, size_t len,
+		      cio_iodone_t end_io, void *private, gfp_t gfp_mask)
+{
+	struct request_queue *in_q = bdev_get_queue(bdev_in);
+	struct request_queue *out_q = bdev_get_queue(bdev_out);
+	int ret = -EINVAL;
+	bool offload = false;
+
+	ret = blk_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len);
+	if (ret)
+		return ret;
+
+	offload = blk_check_copy_offload(in_q, out_q);
+	if (offload)
+		ret = __blk_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
+				len, end_io, private, gfp_mask);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blkdev_copy_offload);
+
 /*
  * @bdev_in:	source block device
  * @pos_in:	source offset
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
index 7a2ff6157eda..62e925e9b2f0 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -20,6 +20,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/blkdev.h>
 #include "internal.h"
 
 #include <linux/uaccess.h>
@@ -1448,7 +1449,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
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
@@ -1709,7 +1714,9 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
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

