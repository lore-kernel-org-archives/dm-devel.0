Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA80C77B61
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157985;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0uXPqZBhQs8HUl+W32c2fBaO9jQezHWWKtt55x6CGy0=;
	b=a84TWrUquqjJ6Yv+c/ZoUshje0OFegaGDhGjLD649i3IYoJoe6qH4xZh0pxkND6Eo/aLXO
	LneZcV+3tieKKQ9y8OT+atEq7pNaZizQCWNjkD0brnnZ41QQ3u2PhsjmB9kurb6FOSWQmj
	jxLt4p2j1Q3P9bWyNds6DWRoIPkxWGk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-9wv3WzTVOe-YEP6tw4BFfA-1; Thu, 30 Mar 2023 02:33:03 -0400
X-MC-Unique: 9wv3WzTVOe-YEP6tw4BFfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 302298030DE;
	Thu, 30 Mar 2023 06:33:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DC3A406AA69;
	Thu, 30 Mar 2023 06:33:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5240C1946A7D;
	Thu, 30 Mar 2023 06:32:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F164F194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:26:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E75BA1121331; Wed, 29 Mar 2023 08:26:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFBA51121330
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5560101A54F
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:13 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-JyfGZGo8N1qHILFfKGBrDA-1; Wed, 29 Mar 2023 04:26:10 -0400
X-MC-Unique: JyfGZGo8N1qHILFfKGBrDA-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230329081623epoutp022fc3db5e2b5fcd29b504286fef453ae4~Q1desDyP92902229022epoutp02_
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:16:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230329081623epoutp022fc3db5e2b5fcd29b504286fef453ae4~Q1desDyP92902229022epoutp02_
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230329081622epcas5p1a7f50fa27f85dcd3a7b76448190e44b1~Q1deGUzbP2757827578epcas5p1r;
 Wed, 29 Mar 2023 08:16:22 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4PmfX460PJz4x9QB; Wed, 29 Mar
 2023 08:16:20 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 53.D5.55678.4D3F3246; Wed, 29 Mar 2023 17:16:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230327084303epcas5p22fdd3af683d3eb1b3f503bcf045f578a~QOiMcX0NT3264932649epcas5p26;
 Mon, 27 Mar 2023 08:43:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230327084303epsmtrp2de2d978cc2ef367704d325a24699efe9~QOiMbD6sH2690426904epsmtrp2C;
 Mon, 27 Mar 2023 08:43:03 +0000 (GMT)
X-AuditID: b6c32a4a-909fc7000000d97e-59-6423f3d4c087
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 30.D5.31821.71751246; Mon, 27 Mar 2023 17:43:03 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084259epsmtip13b16a43ea53bf9752786ce31bd4566df~QOiI4hjQ93003630036epsmtip1L;
 Mon, 27 Mar 2023 08:42:59 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Mon, 27 Mar 2023 14:10:54 +0530
Message-Id: <20230327084103.21601-7-anuj20.g@samsung.com>
In-Reply-To: <20230327084103.21601-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbZRjGPef0BrNyKCN8oNvwwMLFAGXcPgjsEgk5MlCMzMRJxDN6BEJp
 u150Q5MVGjAjQy5jcxS2DtgwFAbKbeU2ubgBBUZMYUrZBkNQGXIpiDc2teWA7r/f877Pm/fy
 5eNhgmKuGy9doqTlEkpMcOxZbf0+3n7j6x4i4a+j3rDReAeDOUVPMVj3oJADF/vXEHhx9U8M
 bo6OYbB7uZwNJ3vaUdhVVYLC2rrbKOystKDw9j9LHFjSdw+B8xNaFHabX4Fd3UMsaOqo4EBd
 zTwX9p3XoNAwl43Atk0dBhsWV1hw0PwiHHs6wD4MSNP4UVI7Pcoh27UPuOTYw69YpGlURTbp
 z3LI5mtnyM5JNYcs0CxbDbnTbHLl1gSH/KxFj5DNwx+T6017yaa5JTTB4XhGZBpNiWi5Oy1J
 kYrSJalRxNG3kl9NDgkVBvoFhsMwwl1CZdJRRHRcgl9Muth6B8L9Q0qssoYSKIWCCDgYKZeq
 lLR7mlShjCJomUgsC5b5K6hMhUqS6i+hlRGBQuGBEKvx/Yy0ypourqzu8Kn+KSc18jAkH7Hj
 ATwYmLNbuPmIPU+AdyLgeoMZZcQaAupbqzFGrFuFrgDbKeno1bOZRAcChmcsHEZoUHBpZAWx
 uTi4F/jmp1zEltiN52HAMn+WZRMYPoMCXc61LZcTHgfKZnO2mIXvB2r9EtvGfDwclNQ0Wvvx
 rP0CQOG0oy1sh0eACoNx2+IIhsrmWDbG8H1A01q+NSvAv7ADlxcuspnaaHBd48CM7QQeD9g2
 tbEbWF/u5jCcCv4wzaMMy4Dmzi2E4UMg11i4NQKG+4DGjgAmvAdcMDagTNsXQMHm3HYpHxiu
 7DABPq2t2GYAuu+qt5kERRsWFnOsAgS0azTcIsRd+8w62mfW0f7f+iqC6RFXWqbITKUVIbID
 Evqj/145RZrZhGz9Dd9YA/JoZtW/D0F5SB8CeBixm795jxAJ+CLqdBYtlybLVWJa0YeEWM9d
 jLk5p0itn0uiTA4MDhcGh4aGBocHhQYSLnyvqKEUAZ5KKekMmpbR8p06lGfnpkar9rnEN+gW
 JqJvHJ+ajBip3lWq9UqnltY9B74Pey09H6vg9bjE1p9M8rZPahG81KsZyZqr5dIt44bT8b15
 iQOJcb6l8Zd+dBj3wXU8y5mi12OGEwYb8fsHK94eXXV1LU86Ye/6uX/bd19PfftD1q7ZvLJK
 4zu1T24cOfa7h6fzz7GC5//2TXx3dvmJeMH8S9R753qF3vcLJ2qIKg+1cxD9pZFck/GXij0x
 0+XI3yxCUPJXT/XsYO6jnuas59jkm9l7WvPhoWkqqH6xNuykUWLKV+nMsn41ctUD3XB8/Eb7
 J85kZuWmeP9N/FjPzZh61fmX9YZK9G7pqam95zaOmK+c+KCUYCnSqEBfTK6g/gX3wOwgpAQA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra2xLYRjH855zenY2K6etxLuRsTKio9tc4nWJjBAvI5lLSEZG6bHRtdva
 zX3UFmSjttQtamwTKT1ziY2lW9eh21gnM3YRSldkLLPsggjFsHaR+PY8/98vz//Dw5DiBiqU
 2aHJ4LQaRYqUDqIqaqVh08dsCFdG/2oQoVuND0mUXTBIolJ3Po16aj8DdHbAS6KfTc0ksvdd
 EKCX9ysJVH3ZSCBLaT2BbCWfCFT/p5dGRsdzgN63mwhkd0WiaruTQq1VhTQqMr8PQI5TOQSy
 dh4GqOJnEYlu9vRTqME1FjUPPhLEQtzaFodNniYaV5rcAbi54zaFW5sycRmfS+PyK4ew7aWe
 xoacviHhiEeA+2vaaXzyDg9w+eP9+EtZGC7r7CXiRyUELVByKTt2cdqohVuCkkvM1QFppbF7
 al9J9KBjdh4IZCA7C1Y94AV5IIgRs1YAa7xXyWEAYWO3GQzPEmj53RUwLB0m4Jl7xZQP0OwU
 WNd1BPjAaLaAhC0ePe1bSLaPgPxbs8BnSdiV8Py7bP8pio2Aer7XnwvZudBovjVUxwxVRMF8
 j8gXB7LzYKG10a+Ih5T8Y1XEsC6CzvOd/mKSHQ9z7l4gCwBr+g+Z/kPFgOBBCJemUyepdTFp
 MzTcbrlOodZlapLk21LVZcD/bJnMCqr5AbkDEAxwAMiQ0tHC8rhwpVioVOzdx2lTN2szUzid
 A4xlKOkY4dM852Yxm6TI4FQcl8Zp/1GCCQzVE7uWR/6pnBayXyv52mrIwSNPKw6xVGyLdfFr
 Ecy6u6CTFj6JSj9e4vaqZsYcSDz3kRlR0lVY7vWEVCwKv/TN8C7qx/fQsMj+e/xiiZdMCH42
 n58/cs5lG7cysd04MZdN335jnMpyxhpR9My0KdyiHi8iE1VH27atlikrR8T9uFNnsaUuWlrT
 tiQ3fVl81pToA+DFpFylfVBGGw3pc+cpJ8mDnQ9VLpv7keHNsaqENY6ai3jv09hXn6+FCbfW
 ygfM/fXtdW+7TSJ3W4+JfnwiuWPjutsrnJMHvVm7C6+IpA8+rN953YaDEyZEX5vzdcWETZqD
 vzLsjrUtrlXd16fGu7KllC5ZESMjtTrFX/CwBMJbAwAA
X-CMS-MailID: 20230327084303epcas5p22fdd3af683d3eb1b3f503bcf045f578a
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084303epcas5p22fdd3af683d3eb1b3f503bcf045f578a
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084303epcas5p22fdd3af683d3eb1b3f503bcf045f578a@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: [dm-devel] [PATCH v8 6/9] nvmet: add copy command support for bdev
 and file ns
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

Add support for handling target command on target.
For bdev-ns we call into blkdev_issue_copy, which the block layer
completes by a offloaded copy request to backend bdev or by emulating the
request.

For file-ns we call vfs_copy_file_range to service our request.

Currently target always shows copy capability by setting
NVME_CTRL_ONCS_COPY in controller ONCS.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/target/admin-cmd.c   |  9 +++--
 drivers/nvme/target/io-cmd-bdev.c | 58 +++++++++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-file.c | 52 +++++++++++++++++++++++++++
 drivers/nvme/target/loop.c        |  6 ++++
 drivers/nvme/target/nvmet.h       |  1 +
 5 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 80099df37314..978786ec6a9e 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -433,8 +433,7 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 	id->nn = cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id->mnan = cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id->oncs = cpu_to_le16(NVME_CTRL_ONCS_DSM |
-			NVME_CTRL_ONCS_WRITE_ZEROES);
-
+			NVME_CTRL_ONCS_WRITE_ZEROES | NVME_CTRL_ONCS_COPY);
 	/* XXX: don't report vwc if the underlying device is write through */
 	id->vwc = NVME_CTRL_VWC_PRESENT;
 
@@ -536,6 +535,12 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 
 	if (req->ns->bdev)
 		nvmet_bdev_set_limits(req->ns->bdev, id);
+	else {
+		id->msrc = (u8)to0based(BIO_MAX_VECS - 1);
+		id->mssrl = cpu_to_le16(BIO_MAX_VECS <<
+				(PAGE_SHIFT - SECTOR_SHIFT));
+		id->mcl = cpu_to_le32(le16_to_cpu(id->mssrl));
+	}
 
 	/*
 	 * We just provide a single LBA format that matches what the
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index c2d6cea0236b..0af273097aa4 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -46,6 +46,19 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	id->npda = id->npdg;
 	/* NOWS = Namespace Optimal Write Size */
 	id->nows = to0based(bdev_io_opt(bdev) / bdev_logical_block_size(bdev));
+
+	/*Copy limits*/
+	if (bdev_max_copy_sectors(bdev)) {
+		id->msrc = id->msrc;
+		id->mssrl = cpu_to_le16((bdev_max_copy_sectors(bdev) <<
+				SECTOR_SHIFT) / bdev_logical_block_size(bdev));
+		id->mcl = cpu_to_le32(id->mssrl);
+	} else {
+		id->msrc = (u8)to0based(BIO_MAX_VECS - 1);
+		id->mssrl = cpu_to_le16((BIO_MAX_VECS << PAGE_SHIFT) /
+				bdev_logical_block_size(bdev));
+		id->mcl = cpu_to_le32(id->mssrl);
+	}
 }
 
 void nvmet_bdev_ns_disable(struct nvmet_ns *ns)
@@ -184,6 +197,19 @@ static void nvmet_bio_done(struct bio *bio)
 	nvmet_req_bio_put(req, bio);
 }
 
+static void nvmet_bdev_copy_end_io(void *private, int comp_len)
+{
+	struct nvmet_req *req = (struct nvmet_req *)private;
+
+	if (comp_len == req->copy_len) {
+		req->cqe->result.u32 = cpu_to_le32(1);
+		nvmet_req_complete(req, errno_to_nvme_status(req, 0));
+	} else {
+		req->cqe->result.u32 = cpu_to_le32(0);
+		nvmet_req_complete(req, blk_to_nvme_status(req, BLK_STS_IOERR));
+	}
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 				struct sg_mapping_iter *miter)
@@ -450,6 +476,34 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	}
 }
 
+/* At present we handle only one range entry */
+static void nvmet_bdev_execute_copy(struct nvmet_req *req)
+{
+	struct nvme_copy_range range;
+	struct nvme_command *cmnd = req->cmd;
+	int ret;
+
+
+	ret = nvmet_copy_from_sgl(req, 0, &range, sizeof(range));
+	if (ret)
+		goto out;
+
+	ret = blkdev_issue_copy(req->ns->bdev,
+		le64_to_cpu(cmnd->copy.sdlba) << req->ns->blksize_shift,
+		req->ns->bdev,
+		le64_to_cpu(range.slba) << req->ns->blksize_shift,
+		(le16_to_cpu(range.nlb) + 1) << req->ns->blksize_shift,
+		nvmet_bdev_copy_end_io, (void *)req, GFP_KERNEL);
+	if (ret) {
+		req->cqe->result.u32 = cpu_to_le32(0);
+		nvmet_req_complete(req, blk_to_nvme_status(req, BLK_STS_IOERR));
+	}
+
+	return;
+out:
+	nvmet_req_complete(req, errno_to_nvme_status(req, ret));
+}
+
 u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 {
 	switch (req->cmd->common.opcode) {
@@ -468,6 +522,10 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_bdev_execute_write_zeroes;
 		return 0;
+	case nvme_cmd_copy:
+		req->execute = nvmet_bdev_execute_copy;
+		return 0;
+
 	default:
 		return nvmet_report_invalid_opcode(req);
 	}
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 2d068439b129..69f198ecec77 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -322,6 +322,49 @@ static void nvmet_file_dsm_work(struct work_struct *w)
 	}
 }
 
+static void nvmet_file_copy_work(struct work_struct *w)
+{
+	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
+	int nr_range;
+	loff_t pos;
+	struct nvme_command *cmnd = req->cmd;
+	int ret = 0, len = 0, src, id;
+
+	nr_range = cmnd->copy.nr_range + 1;
+	pos = le64_to_cpu(req->cmd->copy.sdlba) << req->ns->blksize_shift;
+	if (unlikely(pos + req->transfer_len > req->ns->size)) {
+		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
+		return;
+	}
+
+	for (id = 0 ; id < nr_range; id++) {
+		struct nvme_copy_range range;
+
+		ret = nvmet_copy_from_sgl(req, id * sizeof(range), &range,
+					sizeof(range));
+		if (ret)
+			goto out;
+
+		len = (le16_to_cpu(range.nlb) + 1) << (req->ns->blksize_shift);
+		src = (le64_to_cpu(range.slba) << (req->ns->blksize_shift));
+		ret = vfs_copy_file_range(req->ns->file, src, req->ns->file,
+					pos, len, 0);
+out:
+		if (ret != len) {
+			pos += ret;
+			req->cqe->result.u32 = cpu_to_le32(id);
+			nvmet_req_complete(req, ret < 0 ?
+					errno_to_nvme_status(req, ret) :
+					errno_to_nvme_status(req, -EIO));
+			return;
+
+		} else
+			pos += len;
+	}
+
+	nvmet_req_complete(req, 0);
+
+}
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
@@ -330,6 +373,12 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
 	queue_work(nvmet_wq, &req->f.work);
 }
 
+static void nvmet_file_execute_copy(struct nvmet_req *req)
+{
+	INIT_WORK(&req->f.work, nvmet_file_copy_work);
+	queue_work(nvmet_wq, &req->f.work);
+}
+
 static void nvmet_file_write_zeroes_work(struct work_struct *w)
 {
 	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
@@ -376,6 +425,9 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_file_execute_write_zeroes;
 		return 0;
+	case nvme_cmd_copy:
+		req->execute = nvmet_file_execute_copy;
+		return 0;
 	default:
 		return nvmet_report_invalid_opcode(req);
 	}
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index f2d24b2d992f..d18ed8067a15 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -146,6 +146,12 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return ret;
 
 	nvme_start_request(req);
+	if (unlikely((req->cmd_flags & REQ_COPY) &&
+				(req_op(req) == REQ_OP_READ))) {
+		blk_mq_set_request_complete(req);
+		blk_mq_end_request(req, BLK_STS_OK);
+		return BLK_STS_OK;
+	}
 	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
 	iod->req.port = queue->ctrl->port;
 	if (!nvmet_req_init(&iod->req, &queue->nvme_cq,
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 89bedfcd974c..69ed4c8469e5 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -393,6 +393,7 @@ struct nvmet_req {
 	struct device		*p2p_client;
 	u16			error_loc;
 	u64			error_slba;
+	size_t			copy_len;
 };
 
 #define NVMET_MAX_MPOOL_BVEC		16
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

