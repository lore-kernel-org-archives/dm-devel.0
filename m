Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DCF4C77B73
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973842;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KaWNpQYU1ZsYWFsIJABVh8VmIhuUHmwB4hvH9ga6Uuw=;
	b=g+yfsjKFuOftY7dSom6ZFwi+N41oGCb+Xzz5SqoxG6d7wRDcjd6e/alUKWTJLgr+nrD45y
	tl8bDxiWe6qHxm9HwO4MwIn73hqGYyU3sgzLRkaTq2FUWGc2WzxYxI9sKeb5IRO37ro4DS
	2pKbpbY2AbVLDeIHyaP0I7eOUkyCY6M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-T6BAAEpPN1il05j8qFPO4A-1; Thu, 20 Apr 2023 02:57:18 -0400
X-MC-Unique: T6BAAEpPN1il05j8qFPO4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FC151014707;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8DB6040C2064;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5421119472C1;
	Thu, 20 Apr 2023 06:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A11219465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 11:54:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3BF92492B05; Wed, 19 Apr 2023 11:54:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32DAA492B04
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14161101A531
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:51 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-XSvEyWLKPruKfS-QuiJpkA-1; Wed, 19 Apr 2023 07:54:49 -0400
X-MC-Unique: XSvEyWLKPruKfS-QuiJpkA-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230419115446epoutp04f960aeddac6a09df9f37c7f40cfe80eb~XU-JO-Ljw1585715857epoutp04h
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230419115446epoutp04f960aeddac6a09df9f37c7f40cfe80eb~XU-JO-Ljw1585715857epoutp04h
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230419115445epcas5p23004130fd2cf0bfe8717f938b8114447~XU-Ii0bRw1844418444epcas5p2d;
 Wed, 19 Apr 2023 11:54:45 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Q1fNM4lj4z4x9Pr; Wed, 19 Apr
 2023 11:54:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 82.8D.09540.386DF346; Wed, 19 Apr 2023 20:54:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114743epcas5p155559f1777d242e9d68c43cb61eb5777~XU4-aDjn30344203442epcas5p1_;
 Wed, 19 Apr 2023 11:47:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230419114743epsmtrp1a134ebcb049f457752518b814bf27c26~XU4-Yz49h1843518435epsmtrp1V;
 Wed, 19 Apr 2023 11:47:43 +0000 (GMT)
X-AuditID: b6c32a4a-4afff70000002544-7a-643fd683b348
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 D1.93.08609.ED4DF346; Wed, 19 Apr 2023 20:47:43 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114739epsmtip1627264bbec8b39e9107854556df05662~XU48URkOI2496324963epsmtip1E;
 Wed, 19 Apr 2023 11:47:39 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Wed, 19 Apr 2023 17:13:11 +0530
Message-Id: <20230419114320.13674-7-nj.shetty@samsung.com>
In-Reply-To: <20230419114320.13674-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxbZRT23tveli5dLgW3d0wYqS4LEKDdaPeCFEzE7UbMJJq4TFnKXXtH
 kdI2/YANp6PiUCDANlBZUUCcIuAoMqjQDjQlsFFgX3yFZRNYQLN142PgUD6cLXfo/j3nOed5
 zznPm8PFBIWcAG6axkjrNZRaiPNYtq6QXeG5I/FKkcsphFZXDwY/Pr2GwYY7JTh0dz1C4Bdz
 f2Nw4pd42DFTwYZjv7aj8FLNWRTWNXSj0PHNPAq7nzzE4VnnCAKnhy0o7LgVBi919LLgoP0r
 HFZ9P82BztJcFLZNmRFoW6nCYKN7lgWv3NoOr61dZr8CyMGhRNIyPoCT7ZY7HPLabz+xyMEB
 E9lcn4+TF8+fJB1jOThZlDuDk7OdwzhZ3FKPkBf7PiAXmoPI5qmHaNLmd9NjVTSlpPXBtEah
 VaZpUmXCxLflr8olUpE4XBwN9wqDNVQGLRMmvJEUvi9N7XFAGJxJqU0eKokyGISRcbF6rclI
 B6u0BqNMSOuUal2ULsJAZRhMmtQIDW2MEYtEuyWewpR0VdPo72zdavwx19KnnBzEJilAfLiA
 iALupat4AcLjCggHAhqrpzlM8AgB9gsWNhMsIGC0fBHfkFTfPcf2YgFhR4Ct4SRTdAoFLmux
 J8Hl4kQY6HvC9fL+RB4G5qfzWd4AI26iYLVlFvOq/Yg3gXttiOXFLGInGMivW+/AJ2LAnw2j
 HO9DgIgEJeO+XtqHeBnUdpZiTIkv6D03tS7FiB0gt7UC874PiFofcHu0H2MmTQCdTR1sBvuB
 +5dbOAwOAPdK8p7iLFBX9gPOiD9BgGXUgjCJeHDKVYJ5h8CIEGC1RzJ0IPjc1YgyjTeDopUp
 lOH5oK1yA78IfrRWP3VrGxhZMuPMLiRo79ExZhUjoGLuPHoaCbY8s4/lmX0s/3euRrB6ZBut
 M2Sk0gaJbreGzvrvlxXajGZk/SpCX29DJifmIpwIykWcCOBiQn9+/2sxSgFfSR3PpvVaud6k
 pg1OROLx+wwW8LxC6zkrjVEujooWRUml0qjoPVKxcCt/l6xXISBSKSOdTtM6Wr+hQ7k+ATlo
 Ya/z8byqrpSX4xrf7yj/duW52OQU/+Sx2SH3YHK2/9jkg6tl1ukXMiUiATdBNDJ3Iab+ndC8
 /P3OmYM/Lw7JIm53s3jXzbM7Uk64T9xc5Rdc2dIF5ETgJlvN42FJ6+R2bdfhDFZYYCO1dWYx
 y7LFHnnoBnmMV1FuLhawviw7QC2Yj3/mLI5Lte0cMSkFJTxkz1plUFxQbcVf9srDw++F//Fh
 SMm965l9q3cn5AH6t6iXEojl5aOUqj887uiNrMhD0uUse+K+fyqBNbDq4MIm3x5bv8hcmKeo
 OfDAFZR0xNIFfEjD160OOrtpsMnvo6C97xceWS2immSO+2L1hOI7IcugosShmN5A/QteINsc
 ngQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RWUwTYRSF889Mp0MNOi2oP+ASx2AMIi5o/MWlarSO4oIxUQNxaWQsFVqa
 Vtx4EKkJAdmUSGJBrEYhlIBalLWgFEEQK8aypBSoC+CCKGIJcSmYQkx8O/d+95zzcClcVEf4
 UnLlKU6tlMYwpIAoq2fmLXW0iSOXDxdj6N7zRhwlZrpwVNSTQaLB+hGAsod/4ujNYzGq+ZrD
 Q7YnlRgy3b6KocKiBgxV3/qOoYaJIRJdNXcA1N+uw1BN1xJkqmkmkLUql0Q38/v5yJylxVBF
 30WAyn7fxFHJ4DcCNXX5oVbXM94myFrbQlmdw0KylboePtva+4BgrZY41mhIJtnSOxfYalsC
 yaZpv5Lst9p2kk1/aABsaUs8+8M4jzX2DWFh08MF6yO5GPlpTr1s4zFB1P3OAZ7qj/js87Ek
 fgIoW50CPChIr4L6d9d5KUBAiegKAC83/CKmgA/Mdz3Fp7QXLBz/wHdrEa3FoMu0LQVQFEkv
 gS0TlNvrTWfi8LUjgXQPOP0Gg60fnDy3wYveDe2mwclQgvaHluRC0q096RA4WtTJdwdBehnM
 cAjdaw96HSyozcKnukJgqnkcTJ0LYfP1vskYnJ4PtY9y8ExA6/5Duv+QHmAG4MOpNAqZQrNC
 tVLJnQnSSBWaOKUs6HiswggmvxwQUAFMhuEgM8AoYAaQwhlvzxfbQiJFnpHSc+c5dexRdVwM
 pzEDP4pgZnu+Smk+KqJl0lNcNMepOPU/ilEevglYKrd4Z2OJ05btr0hb+XKGZOehXYmx2kfE
 GmES1hC6/EZ02kFy7PfEaLqDI4KtuQMgr2WtNVk/In+lrBplkgR7a0d/tS70aiqfyY86Gy+5
 UtXUnZpncy4ynAgMlIU75+zIicgLu58vL9hRfjKZiZW/LaltPMLsqVubcUe/py3M/r345cef
 LwpKGMmGa0KbOOLKpWk9Pu38+UBcOD4yY4CN6Q6tD4zYP7JAni5B/kGbjR37otSqiHfvJWlD
 WUgfv37W59sbVVa/Un97Bt1fXZw91ms/LOt1Fnxh7METdb7YlrubOpTRTeGlQp1FlfjR5ZNL
 fuJbnjZmzd3uvW7rAYbQRElXBOBqjfQv+uYkj1QDAAA=
X-CMS-MailID: 20230419114743epcas5p155559f1777d242e9d68c43cb61eb5777
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419114743epcas5p155559f1777d242e9d68c43cb61eb5777
References: <20230419114320.13674-1-nj.shetty@samsung.com>
 <CGME20230419114743epcas5p155559f1777d242e9d68c43cb61eb5777@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v10 6/9] nvmet: add copy command support for bdev
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
index 39cb570f833d..8a09f99a2185 100644
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
index dc60a22646f7..1615dc9194ba 100644
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

