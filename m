Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769F7EB64DC
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 07:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687936118;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NTFWCANvx/SKP/0ncHJl7O5F09Uzi02BPHBWV6jOTMI=;
	b=MOIlLFbguz/VoOuTU94A5KbI8mcdNpJXkw01iu9zON78g1MaBZx2Y/kYsL/64LWRD5nv/c
	dSQ6HeYT3v8W5hy5bpHhIUNamKxbd/WocOOSq7kGNwuWFeSkl56Su0bts1i2byecmRHmxW
	OkM8kv3bi6szK2PNAzq/NFumlY3JS+o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-oZ-Bk2fQPXCm1dZUCtbEvg-1; Wed, 28 Jun 2023 03:08:36 -0400
X-MC-Unique: oZ-Bk2fQPXCm1dZUCtbEvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F30B38ED600;
	Wed, 28 Jun 2023 07:08:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFB3740C206F;
	Wed, 28 Jun 2023 07:08:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C06C91946588;
	Wed, 28 Jun 2023 07:08:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F2591946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Jun 2023 07:08:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8005F40C206F; Wed, 28 Jun 2023 07:08:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7827040C2063
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 07:08:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55FBE858290
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 07:08:32 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-SfOAPKolMJ-56-m8MzZ5fA-1; Wed, 28 Jun 2023 03:08:29 -0400
X-MC-Unique: SfOAPKolMJ-56-m8MzZ5fA-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230628070826epoutp043a45f18a78c91d6775bce4acc427c336~swPIpQo8C2059520595epoutp049
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 07:08:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230628070826epoutp043a45f18a78c91d6775bce4acc427c336~swPIpQo8C2059520595epoutp049
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230628070825epcas5p12f0105c8988933eb58c7a33998c975d6~swPIAeKkI0239002390epcas5p1b;
 Wed, 28 Jun 2023 07:08:25 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4QrXjg0FkXz4x9Pw; Wed, 28 Jun
 2023 07:08:23 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
 AE.8E.55173.66CDB946; Wed, 28 Jun 2023 16:08:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230627184049epcas5p293a6e6b75c93e39c7fca1a702e3e3774~smCXwvC5p0137701377epcas5p2z;
 Tue, 27 Jun 2023 18:40:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230627184049epsmtrp1b3edff9691c1a969e4c08d7fc25d4841~smCXvlbDA1784017840epsmtrp1E;
 Tue, 27 Jun 2023 18:40:49 +0000 (GMT)
X-AuditID: b6c32a50-e61c07000001d785-0b-649bdc660b65
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 15.49.34491.03D2B946; Wed, 28 Jun 2023 03:40:48 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230627184045epsmtip20437419e8f057cf4b4ca6c996362aed3~smCUHgHlT0383003830epsmtip2g;
 Tue, 27 Jun 2023 18:40:45 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 28 Jun 2023 00:06:20 +0530
Message-Id: <20230627183629.26571-7-nj.shetty@samsung.com>
In-Reply-To: <20230627183629.26571-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzH59x7ubug6OWhnDYr5lYQII/FfRxeaZMT19QgycmSoI29AQK7
 6z4yrRkWFRowWMCAWBwkYQiB4R2zCJu4oLxqqAEkGAXSpSICBJJsEIhtofzv8/vO7/t7nTlc
 3LGCw+PGy9SsUiZJpEk7ornDw8P7wztFUr++wkBU23sLR2ezV3BUdVdHoumOBYDyH/yNI3P7
 ZwANmLehiet7kXG2yAaNtLdgqO1KLoauVt3EUK7pNkCTQ3oMGUe90FdpZQRqM/YQaODaJRJd
 Lp/koAvDBhJ93bWKIdPFcxgymFMAal6+jKOa6TkCdY8+jfpXumzQ8qNL5L5dzMDgQaZFf5fD
 9I/VE0xjhScz8L2GaahMJ5nGsmSmdURLMqVZF22YzHOzJDM/OUowc98OkUxWUyVgGvs+YRYb
 nmUazDNYOPVuQnAcK5GySldWFiOXxstiQ+iDEdGvRgtFfnxvfgAS064ySRIbQu8/FO79Wnzi
 +nVo148kiZp1KVyiUtG+Lwcr5Ro16xonV6lDaFYhTVQIFD4qSZJKI4v1kbHqQL6fn79wPfH9
 hLjGzDlccSP44zvjPwAtqPbPALZcSAmgqXqNzAB2XEeqDcC1nw021mABwKKuBxvBEoArpWtg
 0/IwJw+zsCNlBLBghbAmpWLwRvGf67W4XJLygn1rXIvuTGlxWNdaCiwBTnXh8NZ8Cm5xO1Fh
 sCy1m7AYCOpF+Ph+kEW2pwJhWX0nxyJDyhfqxh0ssi0VBFv7O22sKQ6wp9BMWBinnoPnvinC
 LeUh1WsLW4zTuHXQ/bCko22DneDvXU0cK/PglC5tg0/Bq19UkFbzeQD1w/qNLffC1F4dbhkC
 pzxg7TVfq/wMzOutwayNt8HMZTNm1e2hoXiTn4fVtSWklZ+Ct/9K2WAGTmV9zrEeKwvAyoUJ
 TjZw1T+xkP6JhfT/ty4BeCXgsQpVUiwbI1TwvWXsqf+eOUae1AD+/TKe4QZQVbfiYwIYF5gA
 5OK0s/3ORwVSR3up5PQZVimPVmoSWZUJCNcPnoPzdsTI1/+cTB3NFwT4CUQikSBgj4hPu9iP
 haZLHalYiZpNYFkFq9z0YVxbnhY7oj3RImw5nEu21pWMicg3Zk6nmdIcyu/fe0UR2uRh1H2K
 VvMiw6j6Cf6bQz0Oe9oP/TSvTcYn5ruHY3zFZ+UFYt3brx/JR0LHwshuH8Y36sBKRvj1Y8f0
 6Sf1i7998B2Bhh6+VTba5D478GPZSPrhX6a27ir3CZq2XRK8kHreYNx9PGpOfG9HKRxkbL32
 LYy6u/zafWbSziBUd9b5746MmBXX1DvRwUlz45rt7B9RRTPNYXk738vpveJ2oeboyWqXrY/F
 FSGLgUtbaHHI6vEo3lFTfZB9xIHtE1K3Yn9NbuCX2frUxFBw4qXe6nylyFnpvsVNwnunJf9m
 WnKmZtB9tpAmVHESvieuVEn+AbqXXlW7BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWy7bCSvK6B7uwUg4vvrS3WnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFpef8Fk82G9vsffdbFaLmwd2MlnsWTSJyWLl6qNMFpMO
 XWO0eHp1FpPF3lvaFgvblrBY7Nl7ksXi8q45bBbzlz1lt+i+voPNYvnxf0wWhyY3M1nseNLI
 aLHt93xmi3Wv37NYnLglbXH+73FWi98/5rA5yHhcvuLtsXPWXXaP8/c2snhsXqHlcflsqcem
 VZ1sHpuX1HvsvtnA5rG4bzKrR2/zOzaPj09vsXi833eVzaNvyypGj82nqz0+b5Lz2PTkLVOA
 QBSXTUpqTmZZapG+XQJXxube98wFB20q7ty/wNjAuMaoi5GTQ0LAROLrxKlMXYxcHEICuxkl
 Zv3exwqRkJRY9vcIM4QtLLHy33N2iKJmJon2HbeAOjg42AS0JU7/5wCJiwh0MUt07nzHAtLA
 LHCbWWLmWRkQW1jAV+Jc21k2kHoWAVWJP4+tQcK8AlYSSzYeYQcJSwjoS/TfFwQJcwpYS+w+
 f4QVJCwEVPL+eABEtaDEyZlPoIbLSzRvnc08gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LDPNS
 y/WKE3OLS/PS9ZLzczcxguNfS3MH4/ZVH/QOMTJxMB5ilOBgVhLhFfsxPUWINyWxsiq1KD++
 qDQntfgQozQHi5I4r/iL3hQhgfTEktTs1NSC1CKYLBMHp1QD05HLIv0ftOJFOpq4J78sPeL6
 ImF/wsuwTQvZJ/AK7/ojdF5I6d9/ZakJ1bnOX1MP2e183ySQN0lFzLgv/rzWvm1nwq8aOjmn
 lwqtNJ7r2JtemS7yOG1mjv/Gte4OTgbSIjY/K95N/XSpVGfHfjF+6ZjN3P/65lZnnXGKDW77
 tOu6jvaLCUY9Vx+8MF5sdO9p4Cnb8HU7og9Vc2t4c1YY7J9WK5HkIPlja+ccjafeXHGfTT4U
 accdq7WRvmcrWXWxu+7Whx3vuww8+3jib9zIV5CL3TPjjA5bnEjEWq7ygycXflk742iL8KLM
 gr17FXM394kVua0S1Vo7882B6KyfLEKii1osIz/8v1Rd+GeaEktxRqKhFnNRcSIAPl7Pmm4D
 AAA=
X-CMS-MailID: 20230627184049epcas5p293a6e6b75c93e39c7fca1a702e3e3774
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230627184049epcas5p293a6e6b75c93e39c7fca1a702e3e3774
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184049epcas5p293a6e6b75c93e39c7fca1a702e3e3774@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v13 6/9] nvmet: add copy command support for bdev
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
Cc: Anuj Gupta <anuj20.g@samsung.com>, linux-nvme@lists.infradead.org,
 bvanassche@acm.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
 djwong@kernel.org, nitheshshetty@gmail.com, linux-kernel@vger.kernel.org,
 willy@infradead.org, ming.lei@redhat.com, linux-block@vger.kernel.org,
 dlemoal@kernel.org, martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add support for handling nvme_cmd_copy command on target.
For bdev-ns we call into blkdev_copy_offload, which the block layer
completes by a offloaded copy request to backend bdev or by emulating the
request.

For file-ns we call vfs_copy_file_range to service our request.

Currently target always shows copy capability by setting
NVME_CTRL_ONCS_COPY in controller ONCS.

loop target has copy support, which can be used to test copy offload.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/target/admin-cmd.c   |  9 ++++-
 drivers/nvme/target/io-cmd-bdev.c | 62 +++++++++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-file.c | 52 ++++++++++++++++++++++++++
 drivers/nvme/target/nvmet.h       |  1 +
 4 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 39cb570f833d..8e644b8ec0fd 100644
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
+		id->msrc = (__force u8)to0based(BIO_MAX_VECS - 1);
+		id->mssrl = cpu_to_le16(BIO_MAX_VECS <<
+				(PAGE_SHIFT - SECTOR_SHIFT));
+		id->mcl = cpu_to_le32(le16_to_cpu(id->mssrl));
+	}
 
 	/*
 	 * We just provide a single LBA format that matches what the
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 2733e0158585..5c4c6a460cfa 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -46,6 +46,18 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	id->npda = id->npdg;
 	/* NOWS = Namespace Optimal Write Size */
 	id->nows = to0based(bdev_io_opt(bdev) / bdev_logical_block_size(bdev));
+
+	if (bdev_max_copy_sectors(bdev)) {
+		id->msrc = id->msrc;
+		id->mssrl = cpu_to_le16((bdev_max_copy_sectors(bdev) <<
+				SECTOR_SHIFT) / bdev_logical_block_size(bdev));
+		id->mcl = cpu_to_le32((__force u32)id->mssrl);
+	} else {
+		id->msrc = (__force u8)to0based(BIO_MAX_VECS - 1);
+		id->mssrl = cpu_to_le16((BIO_MAX_VECS << PAGE_SHIFT) /
+				bdev_logical_block_size(bdev));
+		id->mcl = cpu_to_le32((__force u32)id->mssrl);
+	}
 }
 
 void nvmet_bdev_ns_disable(struct nvmet_ns *ns)
@@ -184,6 +196,21 @@ static void nvmet_bio_done(struct bio *bio)
 	nvmet_req_bio_put(req, bio);
 }
 
+static void nvmet_bdev_copy_end_io(void *private, int comp_len)
+{
+	struct nvmet_req *req = (struct nvmet_req *)private;
+	u16 status;
+
+	if (comp_len == req->copy_len) {
+		req->cqe->result.u32 = cpu_to_le32(1);
+		status = errno_to_nvme_status(req, 0);
+	} else {
+		req->cqe->result.u32 = cpu_to_le32(0);
+		status = errno_to_nvme_status(req, (__force u16)BLK_STS_IOERR);
+	}
+	nvmet_req_complete(req, status);
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 				struct sg_mapping_iter *miter)
@@ -450,6 +477,37 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	}
 }
 
+/* At present we handle only one range entry, since copy offload is aligned with
+ * copy_file_range, only one entry is passed from block layer.
+ */
+static void nvmet_bdev_execute_copy(struct nvmet_req *req)
+{
+	struct nvme_copy_range range;
+	struct nvme_command *cmd = req->cmd;
+	ssize_t ret;
+	u16 status;
+
+	status = nvmet_copy_from_sgl(req, 0, &range, sizeof(range));
+	if (status)
+		goto out;
+
+	ret = blkdev_copy_offload(req->ns->bdev,
+		le64_to_cpu(cmd->copy.sdlba) << req->ns->blksize_shift,
+		req->ns->bdev,
+		le64_to_cpu(range.slba) << req->ns->blksize_shift,
+		(le16_to_cpu(range.nlb) + 1) << req->ns->blksize_shift,
+		nvmet_bdev_copy_end_io, (void *)req, GFP_KERNEL);
+	if (ret) {
+		req->cqe->result.u32 = cpu_to_le32(0);
+		status = blk_to_nvme_status(req, BLK_STS_IOERR);
+		goto out;
+	}
+
+	return;
+out:
+	nvmet_req_complete(req, errno_to_nvme_status(req, status));
+}
+
 u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 {
 	switch (req->cmd->common.opcode) {
@@ -468,6 +526,10 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
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
index 2d068439b129..f61aa834f7a5 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -322,6 +322,49 @@ static void nvmet_file_dsm_work(struct work_struct *w)
 	}
 }
 
+static void nvmet_file_copy_work(struct work_struct *w)
+{
+	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
+	int nr_range = req->cmd->copy.nr_range + 1;
+	u16 status = 0;
+	int src, id;
+	ssize_t len, ret;
+	loff_t pos;
+
+	pos = le64_to_cpu(req->cmd->copy.sdlba) << req->ns->blksize_shift;
+	if (unlikely(pos + req->transfer_len > req->ns->size)) {
+		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
+		return;
+	}
+
+	for (id = 0 ; id < nr_range; id++) {
+		struct nvme_copy_range range;
+
+		status = nvmet_copy_from_sgl(req, id * sizeof(range), &range,
+					sizeof(range));
+		if (status)
+			goto out;
+
+		src = (le64_to_cpu(range.slba) << (req->ns->blksize_shift));
+		len = (le16_to_cpu(range.nlb) + 1) << (req->ns->blksize_shift);
+		ret = vfs_copy_file_range(req->ns->file, src, req->ns->file,
+					pos, len, 0);
+		if (ret != len) {
+			pos += ret;
+			req->cqe->result.u32 = cpu_to_le32(id);
+			if (ret < 0)
+				status = errno_to_nvme_status(req, ret);
+			else
+				status = errno_to_nvme_status(req, -EIO);
+			goto out;
+		} else
+			pos += len;
+	}
+
+out:
+	nvmet_req_complete(req, status);
+}
+
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
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 6cf723bc664e..c6fb515ee1c5 100644
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

