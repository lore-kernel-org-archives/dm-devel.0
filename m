Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F128C54EBD
	for <dm-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673535514;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ugt0TQKjYZBY9iB4mlXFyH77V9ujEYcx6Awd4AVXKEI=;
	b=Jq8UQGkzHPn2rLtqZb/E3kkNm2A/tHjuJZiU6ozuhVKtYL0Rk0YSR/8f186jo2KJaKZvWz
	IkIBUFXwTWKN/uCprqYeBHvnbzN94wB6v5D2gZVjFTrenjtpIeYadkE+P6yGpooBkMaIHh
	66v7p8IF5pBq/hxdKGBmUH34zqL7gYI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407--2l1xH9iPtu7gW8O1fPZ1g-1; Thu, 12 Jan 2023 09:58:31 -0500
X-MC-Unique: -2l1xH9iPtu7gW8O1fPZ1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 778C9858F09;
	Thu, 12 Jan 2023 14:58:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6304E4078903;
	Thu, 12 Jan 2023 14:58:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66AF0194705D;
	Thu, 12 Jan 2023 14:58:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5CFA91946A78
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 Jan 2023 13:37:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4BF8940C1074; Thu, 12 Jan 2023 13:37:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4308E40C1060
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22C013815F68
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:32 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-FRsPJrfMOH6fj5qSv_qoPg-1; Thu, 12 Jan 2023 08:37:30 -0500
X-MC-Unique: FRsPJrfMOH6fj5qSv_qoPg-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230112133727epoutp042b90efeafdbf947709853b63ac45d270~5k0Hcj9c23145031450epoutp04K
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230112133727epoutp042b90efeafdbf947709853b63ac45d270~5k0Hcj9c23145031450epoutp04K
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230112133726epcas5p45954e7cf152d246adbbfab3893c97ed5~5k0GfcAcl1397713977epcas5p4B;
 Thu, 12 Jan 2023 13:37:26 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4Nt5Fd0Nz7z4x9Pt; Thu, 12 Jan
 2023 13:37:25 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 16.66.03362.41D00C36; Thu, 12 Jan 2023 22:37:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230112120201epcas5p1d2ee1f9fd6a1f458ffa770bb33b4bb41~5jgybUTpm2086220862epcas5p17;
 Thu, 12 Jan 2023 12:02:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230112120201epsmtrp1ec0c3eaa4e90bef1349565279d9543fc~5jgyZ-8hr2544625446epsmtrp1E;
 Thu, 12 Jan 2023 12:02:01 +0000 (GMT)
X-AuditID: b6c32a4b-4e5fa70000010d22-e7-63c00d14a9b3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 FE.B5.02211.9B6FFB36; Thu, 12 Jan 2023 21:02:01 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230112120158epsmtip2bfefac09dabeba4c439c80267b278eeb~5jgvu0heN0767707677epsmtip2e;
 Thu, 12 Jan 2023 12:01:58 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Date: Thu, 12 Jan 2023 17:29:00 +0530
Message-Id: <20230112115908.23662-7-nj.shetty@samsung.com>
In-Reply-To: <20230112115908.23662-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUxTVxT3vldeH8aaJ7B4wYBd6zaQAS0WfCAMP6p5RjdIzLKMbZaX8gKE
 0tZ+qJAZQMAENooScNI6kYmI4FrHd6l8DIIIhKFDGBCEIWUZEmDIIovEsJYHm//9zu+c3z3n
 d+69OOq2iHnhSUodo1HSCgG2ldPQ6fdBgAevXS6607qftPQ+RMmLl9+gZPWzAoxsWTC5kKPt
 VoS8W92FkLayJYTsWpvHyMKOYUDODBkRsmXMn3zQ0sMhB5uvY2RpxQyXbLJnArJhtRQll29n
 c0nz3CKHfDS2ixx40+1y0IMyTvZjlNX4jEsNTPzEoQb79VRNVS5G1ZanU7bRDIzKz1rAqMXW
 IYwy1FUBarnGh6qxzyMx22KTIxIZOp7R8BmlXBWfpEyIFJw4JTsiCwkViQPEYeR+AV9JpzCR
 AunJmIBjSQqHTQH/LK3QO6gYWqsVBH0UoVHpdQw/UaXVRQoYdbxCLVEHaukUrV6ZEKhkdOFi
 kSg4xFEYl5xYXVnMUddKz0/9cjwD9JF5wBWHhASaLI1YHtiKuxE2AGfvjHHY4CWAl+asG5lX
 AGbeXgWbkoxfLSibaAGwquG6CxtkIbAi909HgOMY4Q/71nCnwIMYR6C1T+isQQkTAh/NT7k4
 E+7ESWhum+c6MYd4Dz55ObfegUeEw2/zFrjOcyARBAsmdzhpV+IAvDfyN4ct2QF7SuzrGCV2
 w6x60/pAkFjDYdZII2C1Uji59CU7tDt80V3HZbEXnC24tIHPwbtFlRirzQbQ+Jtxw2UUzOkt
 QJ3noIQftDQHsbQ3LO41I2zf7TB/1Y6wPA823djEQnjPchNjsSccXsncwBRcLszbWK8BwNdX
 l8BlwDe+5cf4lh/j/61vArQKeDJqbUoCow1R71My5/67ZLkqpQasv/y9J5rA89//CuwACA46
 AMRRgQfvQVeb3I0XT6emMRqVTKNXMNoOEOLY9xXU6x25yvF1lDqZWBImkoSGhkrC9oWKBTt5
 TH2p3I1IoHVMMsOoGc2mDsFdvTKQRsPs/f4f0g964yqPTyq/j8oI8kv77mf/M9jTw61CzKQY
 Eupjk7++UX5oxZS2e7jwiTnO5jvdza3x3bN0y8se/HmqccjVJ7NL5E3U1kelFc0VZ79vL0rP
 ke3c0jzx8ZXTtmOfdTOjlYsXnkbHnh6Snveb/mP6rOHHuOCxcFlX2cAWmeX5SDvftcx36v54
 urVi+4BwfObxP5+WVOuiD2HunZ7Hv+kOSBaaj35Ruyvw6oQmuM3a8zpi9EBPDJgbLI/Kk3jb
 zIajL0rVadKZPaJOH6soeiZ/dO3iGc/2psWyNt6Fa9dS5Y8jXw0fHrnVkrsiL/yqxD/p3Zyp
 DwdzDafq6IfbIgUcbSIt3otqtPS/rbdHPoIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCSvO7Ob/uTDW6d57BYf+oYs0XThL/M
 Fqvv9rNZ7H03m9Xi5oGdTBYrVx9lsti98COTxdH/b9ksJh26xmjx9OosJou9t7Qt9uw9yWJx
 edccNov5y56yW+x40shose33fGaLz0tb2C3WvX7PYnHilrTF+b/HWR1EPGbdP8vmsXPWXXaP
 8/c2snhcPlvqsWlVJ5vH5iX1HrtvNrB59Da/Y/N4v+8qm0ffllWMHp83yXlsevKWKYAnissm
 JTUnsyy1SN8ugStj9YqpLAWbXSoenvNsYDxt0cXIySEhYCLRcGk9cxcjF4eQwG5Gid9HrzNC
 JCQllv09wgxhC0us/PecHaKokUni1st1QAkODjYBbYnT/zlA4iICz5gkzt57BDaJWWApk8SC
 fY2sIN3CAj4S6/a/ZQexWQRUJS5+eg22gVfASqKn6x07yCAJAX2J/vuCIGFOAWuJNTe+sIDY
 QkAls/ZcZYIoF5Q4OfMJWJxZQF6ieets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCYl1qu
 V5yYW1yal66XnJ+7iREclVqaOxi3r/qgd4iRiYPxEKMEB7OSCO+eo/uThXhTEiurUovy44tK
 c1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamDq/uTCsfGEp4+F3cbGxjNdl9mu
 NuoKbXjNnKm+LaW5fuK1Y1GFfSLxG+9ozP1TWqh9orzwk3G38DbBmG25X1XmPPtmrS3ExW3S
 YsIqkr047Xps3yszJeHtr2YsX7fHhmG+RFJA0LRTGf0FH9pqLP6rWuefjnQ1Zn+6UWd764/i
 eVfmr/4o+fLLnADho8fSns7RbLVNWnvzYPm95A0h5x4o1yuVZ61N2nLxo1xU9VnzbQf/mUwT
 07N1m9p25q19SaVK4qebrJ/377h0Q+vKU4bZ/9NaAvZyzdzVGN95a96GPKYyLYUEu/1ZV61b
 r5ak3nfaY3ImbHvNu63rdOcqL5ZvMYszC3gc2n+hv4E78agSS3FGoqEWc1FxIgAYjirpOQMA
 AA==
X-CMS-MailID: 20230112120201epcas5p1d2ee1f9fd6a1f458ffa770bb33b4bb41
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230112120201epcas5p1d2ee1f9fd6a1f458ffa770bb33b4bb41
References: <20230112115908.23662-1-nj.shetty@samsung.com>
 <CGME20230112120201epcas5p1d2ee1f9fd6a1f458ffa770bb33b4bb41@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 12 Jan 2023 14:58:20 +0000
Subject: [dm-devel] [PATCH v6 6/9] nvmet: add copy command support for bdev
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
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Nitesh Shetty <nj.shetty@samsung.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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
 drivers/nvme/target/admin-cmd.c   |  9 +++-
 drivers/nvme/target/io-cmd-bdev.c | 79 +++++++++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-file.c | 52 ++++++++++++++++++++
 drivers/nvme/target/loop.c        |  6 +++
 drivers/nvme/target/nvmet.h       |  2 +
 5 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 6a54ed6fb121..66a45121f5a0 100644
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
index c2d6cea0236b..01f0160125fb 100644
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
@@ -184,6 +197,23 @@ static void nvmet_bio_done(struct bio *bio)
 	nvmet_req_bio_put(req, bio);
 }
 
+static void nvmet_bdev_copy_end_io(void *private, int status)
+{
+	struct nvmet_req *req = (struct nvmet_req *)private;
+	int id;
+
+	if (status) {
+		for (id = 0 ; id < req->nr_range; id++) {
+			if (req->ranges[id].len != req->ranges[id].comp_len) {
+				req->cqe->result.u32 = cpu_to_le32(id);
+				break;
+			}
+		}
+	}
+	kfree(req->ranges);
+	nvmet_req_complete(req, errno_to_nvme_status(req, status));
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 				struct sg_mapping_iter *miter)
@@ -450,6 +480,51 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	}
 }
 
+static void nvmet_bdev_execute_copy(struct nvmet_req *req)
+{
+	struct nvme_copy_range range;
+	struct range_entry *ranges;
+	struct nvme_command *cmnd = req->cmd;
+	sector_t dest, dest_off = 0;
+	int ret, id, nr_range;
+
+	nr_range = cmnd->copy.nr_range + 1;
+	dest = le64_to_cpu(cmnd->copy.sdlba) << req->ns->blksize_shift;
+	ranges = kmalloc_array(nr_range, sizeof(*ranges), GFP_KERNEL);
+
+	for (id = 0 ; id < nr_range; id++) {
+		ret = nvmet_copy_from_sgl(req, id * sizeof(range),
+					&range, sizeof(range));
+		if (ret)
+			goto out;
+
+		ranges[id].dst = dest + dest_off;
+		ranges[id].src = le64_to_cpu(range.slba) <<
+					req->ns->blksize_shift;
+		ranges[id].len = (le16_to_cpu(range.nlb) + 1) <<
+					req->ns->blksize_shift;
+		ranges[id].comp_len = 0;
+		dest_off += ranges[id].len;
+	}
+	req->ranges = ranges;
+	req->nr_range = nr_range;
+	ret = blkdev_issue_copy(req->ns->bdev, req->ns->bdev, ranges, nr_range,
+			nvmet_bdev_copy_end_io, (void *)req, GFP_KERNEL);
+	if (ret) {
+		for (id = 0 ; id < nr_range; id++) {
+			if (ranges[id].len != ranges[id].comp_len) {
+				req->cqe->result.u32 = cpu_to_le32(id);
+				break;
+			}
+		}
+		goto out;
+	} else
+		return;
+out:
+	kfree(ranges);
+	nvmet_req_complete(req, errno_to_nvme_status(req, ret));
+}
+
 u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 {
 	switch (req->cmd->common.opcode) {
@@ -468,6 +543,10 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
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
index 871c4f32f443..76db307f5b30 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -328,6 +328,49 @@ static void nvmet_file_dsm_work(struct work_struct *w)
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
@@ -336,6 +379,12 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
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
@@ -382,6 +431,9 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
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
index 89bedfcd974c..c36b55c9ff68 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -393,6 +393,8 @@ struct nvmet_req {
 	struct device		*p2p_client;
 	u16			error_loc;
 	u64			error_slba;
+	struct range_entry	*ranges;
+	unsigned int		nr_range;
 };
 
 #define NVMET_MAX_MPOOL_BVEC		16
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

