Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FD3C7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684772992;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pLjFjNMXZktf2U7sIXO9TJVCh6MQ4bkUsUN9kKBCc8g=;
	b=LDO+XtcDhscpd6eYXny6X5BaA+JZAmmrXT6baCciu8ivU98bTGhLCB2LO8WjJ0UcPC+vY5
	ydwTJBTQkW/JRlkvIZXJ5+b+88UiHehIe0H9bD3ldFu0lhJcAORHKXH0IPmcvtk4bupkTO
	OVBUZgYcFpQ7ttVYd1sS7H/swdWlNuk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-SAmeoxvTMu2yjyMOPrTB5A-1; Mon, 22 May 2023 12:29:49 -0400
X-MC-Unique: SAmeoxvTMu2yjyMOPrTB5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 340AA8032F1;
	Mon, 22 May 2023 16:29:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2079020296C8;
	Mon, 22 May 2023 16:29:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D6F819452C6;
	Mon, 22 May 2023 16:29:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E6A0194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 11:10:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6E991407DEC3; Mon, 22 May 2023 11:10:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66DF0407DEC0
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:52 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40AE2811E86
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:52 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-f6BKE5_SNn-XW46ubW445w-1; Mon, 22 May 2023 07:10:50 -0400
X-MC-Unique: f6BKE5_SNn-XW46ubW445w-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230522111047epoutp038413cea7ee4cadec3379cdd70614acb0~hcrK1FTAm1243812438epoutp03i
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230522111047epoutp038413cea7ee4cadec3379cdd70614acb0~hcrK1FTAm1243812438epoutp03i
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230522111046epcas5p130438bdfeb6809a0fb2f9de869a58115~hcrJ-ArNi0198501985epcas5p1G;
 Mon, 22 May 2023 11:10:46 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4QPvrP34PJz4x9Py; Mon, 22 May
 2023 11:10:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 5C.39.16380.5BD4B646; Mon, 22 May 2023 20:10:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230522104638epcas5p1caf2dc21c5ef7149a10a298b9baeda60~hcWFFOj3c1779017790epcas5p1O;
 Mon, 22 May 2023 10:46:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230522104638epsmtrp19306ae1a3f1187411e109137da914275~hcWFELCXc1501415014epsmtrp1F;
 Mon, 22 May 2023 10:46:38 +0000 (GMT)
X-AuditID: b6c32a4b-56fff70000013ffc-0b-646b4db56bd0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 AC.23.27706.D084B646; Mon, 22 May 2023 19:46:38 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230522104634epsmtip28e582cb8bc1a0c76c43316a6fe85ddb4~hcWBSeZpY1590015900epsmtip25;
 Mon, 22 May 2023 10:46:34 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 May 2023 16:11:37 +0530
Message-Id: <20230522104146.2856-7-nj.shetty@samsung.com>
In-Reply-To: <20230522104146.2856-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xTZxjOOaeclkuXw2XyAQK102zSQSmX+uFEt8jMIXUbOrNlTMMaegaE
 0jZtGWpc5LoLQlsrmq1yn2EIBLByRwYrYKEoxDFhVhFEcHXIpcSMOYaspbj573me733e25eX
 gXno6b6MFImSkkuEYjbuQmvp3flGcPN7qaLQgXJP2GC6jsHihjocZmvWMFg7ocbhXO8yAi8s
 PcPgVPc+2LVw0Qne6WlH4bVKLQov1/aj8IqaATsrrCjsX5/HodYwhsDZ2zoUdpk58FrXIA2O
 dhTj8H7duhMsq5qlwzPjbTj80fgchYZzOShsm8lCYMtqGQbr5xZpcMDsB0fWjE5w9a9i/O0A
 cvRXAambvImT7boJOjly/wqNvKA14eTV6iBy9GY6qa/5Fif1y1o6OfDdKo28euk02XknEycL
 cxZw0jprppGLP93GSVVTDRLnGZ+6J5kSiig5i5IkSkUpkqRotuDDhP0JkfxQXjAvCu5isyTC
 NCqaHXMwLvhAiti2KTbrC6E43SbFCRUKNnfvHrk0XUmxkqUKZTSbkonEsghZiEKYpkiXJIVI
 KOVuXmhoWKQt8LPU5Of1Ytn8O8effjOEZyJWfj7CYAAiAqgGTucjLgwPohMBsyUGuoMs28iI
 iZaPONvInwg4X+xtx3bDSsE91BHUhYDHFaWYg+ShoGhMT7enxQkOGFpn2HUvYgYD8x1PNoIw
 wogBTdUgZk/lSXwANHrLRgkasQOMlbY62TGTiALLDb9jjv64QD3pbpedid3AckuHOULcweD3
 MxtWjAgEOc0XN/IDwuwMpp+s4Y5WY8BQsw51YE/wh7GJ7sC+4LH6q02cAS4XVeMOcy4CdOM6
 xPGwD+SZ1BtNYMRO0NDBdcj+4LypHnUUfgUUrs5s5meCttIX+DVQ11C+2YMPGFvJ2sQkmMw1
 bq6uEAGtXWZEg7B0Lw2ke2kg3f+lyxGsBvGhZIq0JEoRKQuXUBn/fXKiNE2PbBxPkKANmZ5a
 CjEgKAMxIICBsb2Yh1SJIg+mSHjiJCWXJsjTxZTCgETaFn4W8301UWq7PokygRcRFRrB5/Mj
 osL5PLY38/XowUQPIkmopFIpSkbJX/hQhrNvJur289ctMmNsr+XGs75L7P7GXV+GBBz3a4rf
 8o+5dUfwo0mR4q1bWU5cDefN7eOC9gXnQ6lDuTX1/oFT8aVevTGqrIKlwf2nurnx7xZsjT0a
 WW3SniWj76b3L/YKqhanh8M81/zdCt0XVCePyI897ZhuqpgucfK2+GyzPhxuypij1bs9yLYI
 XGvPndnr2gexLdLGh58eo/W4cn1rK+ddfsk++vfh98d7Ao/kndLeq+84wSlnsUIOVMYO9/lZ
 thepPAJG4xIKVw5qJn5TNT/46PNwq/huTLAaREY9+uE6SGMuVn3MSc7RqPo6PxEdbimrHmYs
 qsJS4636rtWSrZyCG42B3blsmiJZyAvC5Arhvy3onOvFBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0xTVxjGPffcXm7rai7FhaMmNmk0rphRasCcqYH5ZR4lOt0yR5o5aNo7
 YNLStaBiTMTV+acg1JIZqTgnYzgr2giCVECw5V8xgqMVkIHwgQYMQQEFdQzYSrPEb0+e3+99
 Pr0slIzSq9l0fRZv1KszZIyIrvHIpB+vIAe1Mb/fh9jZ0QpxibOCwT9a5yG+MVjI4HHPNMAX
 Jt9BPNyYgBteXBLgp00uCteX2ih8/UYLhW8Xsrju6hSFWxYnGGxz9wAceGKncEP/Rlzf4KWx
 714Jg59VLArwlfJAGM7rrWXwtbYFCruLzBSuHTkBcM3cFYhvjb+kcXv/Gtw13ybAc29LmE/X
 Ep8/kdiHHjHEZR8MI13PbtPkgq2DIVV/RBHfo2xS6TjLkMppWxhpvzhHk6qy46TuaS5Dzplf
 MGQq0E+Tl/efMKTgjgPsjVCJtmn5jPRDvFERnyJKW7iVYZjYfuT1mYdMLpjabAFCFnGx6E3+
 AGUBIlbC1QF0qrQRhMAqVD7fDEM5Al1fGA0LSWYKTdWXCiyAZRluI3q4yAb7ldwkRM47pUvH
 kPsLoprepGCO4HajvjeepSGaW496frkrCGYx9wmado7C4A7iFKhwKDxYC7ktaOxP+1It+U+x
 lm8K2eHIWzxCh9alyFx9CVoBZ38P2d9DvwLKAVbxBpMuVWdSGpR6/nC0Sa0zZetTozWZukqw
 9AtR8lpw1zEZ7QYUC9wAsVC2UryvQKOViLXqnKO8MTPZmJ3Bm9xgDUvLIsWPLd5kCZeqzuIP
 8ryBN/5PKVa4Opc69vkXDXnjJ6DzokatrGoWpQxqxfKe2XQOWr/acU1wbAPgzrz6J/Fm/tgu
 bU5VdXe+0iX6Pg3pz6qKDp03H3iu1607FX96a2vF5c8id6QodsoppuNLXU3eELtiJG+Us98E
 nSqX4d5jUKk8EBPj+Xpn72xsS5xvmab5tVc1nD7YWv3NzP6rpzc07SvJPC+1dcdlD1gCy3ep
 SGcyzPHINyf9VjHjUyi8iW+JpAsM/fDdmIc9skgmG0/2zZYd/0D2s6lz28yenxI8ez50/G0V
 RmqKY4v2v4ssHGg/Gqjzr51QfNvk978SxmdJO9v6Cj4Sxkld8uGE3ROurcj/IKm5W0ab0tTK
 KGg0qf8FLCrG7XoDAAA=
X-CMS-MailID: 20230522104638epcas5p1caf2dc21c5ef7149a10a298b9baeda60
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230522104638epcas5p1caf2dc21c5ef7149a10a298b9baeda60
References: <20230522104146.2856-1-nj.shetty@samsung.com>
 <CGME20230522104638epcas5p1caf2dc21c5ef7149a10a298b9baeda60@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 22 May 2023 16:29:19 +0000
Subject: [dm-devel] [PATCH v11 6/9] nvmet: add copy command support for bdev
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
Cc: linux-block@vger.kernel.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 James.Bottomley@HansenPartnership.com, linux-fsdevel@vger.kernel.org,
 dlemoal@kernel.org, Nitesh Shetty <nj.shetty@samsung.com>, joshi.k@samsung.com,
 nitheshshetty@gmail.com, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add support for handling nvme_cmd_copy command on target.
For bdev-ns we call into blkdev_issue_copy, which the block layer
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
 drivers/nvme/target/loop.c        |  6 +++
 drivers/nvme/target/nvmet.h       |  1 +
 5 files changed, 128 insertions(+), 2 deletions(-)

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
index c2d6cea0236b..d92dfe86c647 100644
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
+	int ret;
+	u16 status;
+
+	status = nvmet_copy_from_sgl(req, 0, &range, sizeof(range));
+	if (status)
+		goto out;
+
+	ret = blkdev_issue_copy(req->ns->bdev,
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

