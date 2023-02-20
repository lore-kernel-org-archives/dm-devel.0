Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590A2C678D5
	for <dm-devel@archiver.kernel.org>; Tue, 21 Feb 2023 07:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676965226;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gTPI3P+LfgncV8t6bQSS71liK17ycBNityc5vlBONBg=;
	b=Z7SQsmhWuHF//Az8VrSpVN7uvmCKap8GpYAIxipSm/8hHlnFr9bay3lLQNjyzHAnYKBR0x
	fDYqa2v+MH+Ti8I321AJS1rOZQhAZQiuMOWpEQeJIWbTOBjpwsM6BdV5a5Iwddd5XeWBEE
	f25fQVtk027pmdLlDb47qjkMifALtqU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-mqoC9X9bNLS9yVZpgoSHyQ-1; Tue, 21 Feb 2023 02:40:22 -0500
X-MC-Unique: mqoC9X9bNLS9yVZpgoSHyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1554E857AA1;
	Tue, 21 Feb 2023 07:40:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0270B40168BA;
	Tue, 21 Feb 2023 07:40:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C5C80194658C;
	Tue, 21 Feb 2023 07:40:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 19EAD1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Feb 2023 12:56:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB13540C83B6; Mon, 20 Feb 2023 12:56:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E319840CF8E7
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 12:56:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C04B22A5955E
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 12:56:09 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-nr1IIDzoNr6YOTnlKKYoIg-1; Mon, 20 Feb 2023 07:56:07 -0500
X-MC-Unique: nr1IIDzoNr6YOTnlKKYoIg-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230220124834epoutp010d222e86d58bdff124c7ac3b847c385a~FiTj8iOWe1638516385epoutp01D
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 12:48:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230220124834epoutp010d222e86d58bdff124c7ac3b847c385a~FiTj8iOWe1638516385epoutp01D
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230220124833epcas5p2cc50788c454811886b7df2a4aafacecd~FiTjaW5Oh1601516015epcas5p2X;
 Mon, 20 Feb 2023 12:48:33 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4PL2KC5KBjz4x9Pt; Mon, 20 Feb
 2023 12:48:31 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 70.59.06765.F1C63F36; Mon, 20 Feb 2023 21:48:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230220105503epcas5p2cb05eb671de6954b7604e49ebd23ce41~Fgwc5-wb01660316603epcas5p2D;
 Mon, 20 Feb 2023 10:55:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230220105503epsmtrp23bda6ee826dd76ec1000659f955cf78d~Fgwc4wiAU1664116641epsmtrp2V;
 Mon, 20 Feb 2023 10:55:03 +0000 (GMT)
X-AuditID: b6c32a4b-20fff70000011a6d-b6-63f36c1f3f33
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D8.8C.05839.78153F36; Mon, 20 Feb 2023 19:55:03 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230220105458epsmtip2562bae17173ca10a9ba68190220eb74b~FgwY0Ift80747307473epsmtip2s;
 Mon, 20 Feb 2023 10:54:58 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Feb 2023 16:23:27 +0530
Message-Id: <20230220105336.3810-5-nj.shetty@samsung.com>
In-Reply-To: <20230220105336.3810-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTVxjGc+4tty2z2xVRDpiNWuIcGKAV6E4NOBbQ3QQXWdyWbHFiV+6A
 UNraliGwjO8FQVagbsy6AQoYoAsdFR1fnayICEiIImwICBgwAwOInYBD1rW7sPnf7zzv85z3
 nPfkcHC302wvToJCS6sVUrmAcGVd7fT19feW22TCgjt7kKn3Bo6yi9dxZBzXEejbx89wtNY/
 gCPLwnkXNNLRgqH2i6UYqjN2YajtwhKGuuzzBCq1DgM0M2TAkOXeXtRu6WGhwdbvCVRxaYaN
 rPocDDVPZwF0da0CRw2PFlno5r2daGC92yXcgxq8G0UZJvoJqsUwzqYG7jeyqMH+ZMpcf5qg
 LldnUG0jmQRVlLPgMORNuFCLvwwR1NdN9YC63JdO2cyvUebpeSz6lY8TQ+NpaSyt5tMKmTI2
 QREXJog6GhMREyIWivxFEvSmgK+QJtFhgsjD0f6HEuSOEQj4n0vlyQ4pWqrRCAIPhKqVyVqa
 H6/UaMMEtCpWrgpWBWikSZpkRVyAgtbuFwmF+0IcxhOJ8aO5c5jK/vqpunIjngnM/ALA5UAy
 GD7M/wlzshvZBqDVuKUAuDr4CYB/j+sAs1gGcGZ0Cd9MlFyrwZiCxZEoXMGZeA4GO1d3FwAO
 hyD3wj47xym7k2MYbOnzcfpxchKDFdnVwFnYRn4CTbVjbKefRe6GX3WmOWUeKYGL3YWYU4Zk
 INRNbHUil9wPV3JTGcdW2HNumuVknPSGOVfO487dIVnFhc9tHYA5ZiS8PjjlwvA2ONfdxGbY
 C9oWLATDKbDubC3BhHMBNPxm2Ai/BfN6dbizMU76QlNrICO/Cr/pbcCYxi/DorVpjNF5sLl8
 k33gj6bKjf094fBK1gZTsHGohmDGVgSg/WEHuxjwDS9cyPDChQz/t64EeD3wpFWapDhaE6IK
 UtAp/z2xTJlkBv/+Cb+oZvBg8nGAFWAcYAWQgwvceXaeTebGi5WmptFqZYw6WU5rrCDEMe4S
 3Gu7TOn4VAptjChYIgwWi8XBkiCxSODB2xPWI3Mj46RaOpGmVbR6M4dxuF6Z2KM/j/l4V3Tf
 Uhhrf3Bt6tWnPxe2RCg7j1Zlt+2z/PXpFPF7xq4DSSPveJS8tMqblLybpqi8tqPmqf7M4OzK
 wV8/GIAjw0+K9RdbD3amB7nFJk5kf1GjW5aL2LcX8pt4n93Fl2p4J0+421q5w7vGjtusxlHD
 7bddD0viClPeSCuWmWasnlOpJYl+o1H6xiuHjt04eX3nbEQperbMCw+VpNeXRU5xzgTFmD7q
 vfTdh3Pm41Pvp9SBmez52e3z+XeiJQ/aqyfUR5IapNHvZXQO+5zTjaStinPS87xPPV382WaX
 7AhPzfpDb90SXhyyzr2Q2XUro4NbVlte9eU862ZZX0TBkftdApYmXiryw9Ua6T8u6XEBnAQA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWy7bCSvG574Odkg/5mPov1p44xWzRN+Mts
 sfpuP5vFtA8/mS1+nz3PbLH33WxWi5sHdjJZ7Fk0icli5eqjTBa7F35ksjj6/y2bxaRD1xgt
 nl6dxWSx95a2xZ69J1ksLu+aw2Yxf9lTdotDk5uZLHY8aWS02PZ7PrPFutfvWSxO3JK2OP/3
 OKuDuMflK94es+6fZfPYOesuu8f5extZPC6fLfXYtKqTzWPzknqP3Tcb2Dx6m98BFbTeZ/V4
 v+8qm0ffllWMHptPV3t83iTnsenJW6YA/igum5TUnMyy1CJ9uwSujNstr5gK/qtVrJy3mrmB
 cZNCFyMnh4SAicTE/UuZQGwhgd2MEstXsELEJSWW/T3CDGELS6z895y9i5ELqKaRSeLEr89A
 DgcHm4C2xOn/HCBxEYFnTBJn7z1iBnGYBd4xSax6uAxskrBAtMT/uR9ZQRpYBFQl2g5XgYR5
 BSwl3h/vZgIJSwjoS/TfFwQxOQWsJL63VEKcYylxYtJmRohqQYmTM5+wgNjMAvISzVtnM09g
 FJiFJDULSWoBI9MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgSNbS3MG4fdUHvUOM
 TByMhxglOJiVRHj/835OFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFq
 EUyWiYNTqoEp0PxteVATo43V1uAVK7QtD1Rq8KisTilWu5edovdNsf1E+molh122Zw7V1FgH
 Xr/M9fhZJnPrI7nbwqujnkT1vDrK6HPP99/txYqXd0qraL2p1TUtdrm9IL966QopWWueQ91T
 Bfddlpp/k6Xu1tK3SZta9jaqdfXukij569kj8C6Xcb3/v7O+CzwqLs44+VDbx9Hz6qUz75bd
 mLv0/d4bIhLHu/+8XGKX039Ff5PD4j1xbj/7Deeu+6ixwEbTY7+GwcIlr6518p87sNz4hFlM
 I98REcPtDc1OrPn69eFT10Z9c+Q5vs5bcZoi+8pvTDabM3+5l3dd6pnWOefG/et2bJPlzmi+
 V1s8e+/kPDV3JZbijERDLeai4kQAGpeiJVMDAAA=
X-CMS-MailID: 20230220105503epcas5p2cb05eb671de6954b7604e49ebd23ce41
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230220105503epcas5p2cb05eb671de6954b7604e49ebd23ce41
References: <20230220105336.3810-1-nj.shetty@samsung.com>
 <CGME20230220105503epcas5p2cb05eb671de6954b7604e49ebd23ce41@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 21 Feb 2023 07:40:17 +0000
Subject: [dm-devel] [PATCH v7 4/8] fs,
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For direct block device, use copy_file_range to issue device copy offload,
and fallback to generic_copy_file_range incase device copy offload
capability is absent. Modify checks to allow bdevs to use copy_file_range.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/blk-lib.c        | 22 ++++++++++++++++++++++
 block/fops.c           | 18 ++++++++++++++++++
 fs/read_write.c        | 11 +++++++++--
 include/linux/blkdev.h |  3 +++
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 74f58faf82d8..6593de525a26 100644
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
index 50d245e8c913..bcb9ee6565ea 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -596,6 +596,23 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out,
+				size_t len, unsigned int flags)
+{
+	struct block_device *in_bdev = I_BDEV(bdev_file_inode(file_in));
+	struct block_device *out_bdev = I_BDEV(bdev_file_inode(file_out));
+	int comp_len;
+
+	comp_len = blkdev_copy_offload(in_bdev, pos_in, out_bdev, pos_out, len,
+			    NULL, NULL, GFP_KERNEL);
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
@@ -679,6 +696,7 @@ const struct file_operations def_blk_fops = {
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
index 766761911190..ca7828b25d90 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1066,6 +1066,9 @@ int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
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

