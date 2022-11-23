Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A62C3A59F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669191967;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z9Hf6A0yfgqELr9CUbluk/PYjujv9HXKcpXZJgWTKzs=;
	b=US+TDKzl6WPtRoLaHsM/7W110L3RRlL3DOMDdHvp89beUUaL9R5z++ROzxhM4OXRspt3IP
	8dydVtgf714r+VaQp/mKRIqQydZw1/mdxPUOCuPyISEpA5xc35oXEN4nAHDa3NhBPQB8RC
	2YWF9Bei4ARjy+Vj47ed/pVDWJIxE0M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-6e7prxmUOjOsLJ41P8SWPA-1; Wed, 23 Nov 2022 03:26:04 -0500
X-MC-Unique: 6e7prxmUOjOsLJ41P8SWPA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15413833AF1;
	Wed, 23 Nov 2022 08:26:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 017B64B3FC6;
	Wed, 23 Nov 2022 08:26:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC3C1194658D;
	Wed, 23 Nov 2022 08:25:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01C961946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 06:21:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90F2E40C83AD; Wed, 23 Nov 2022 06:21:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 896F740C2086
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 669941C0519B
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:06 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-olM9L-eoM86gbVqIq4-7Zw-1; Wed, 23 Nov 2022 01:21:04 -0500
X-MC-Unique: olM9L-eoM86gbVqIq4-7Zw-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20221123061334epoutp01507479ee3b9849375d407b08b57c9a14~qIgRwD6RO1779817798epoutp01H
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:13:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20221123061334epoutp01507479ee3b9849375d407b08b57c9a14~qIgRwD6RO1779817798epoutp01H
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20221123061333epcas5p3d7047503fc13d684839f2e540dd699c9~qIgRCyl411162411624epcas5p3E;
 Wed, 23 Nov 2022 06:13:33 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4NH9mW6VpVz4x9Q2; Wed, 23 Nov
 2022 06:13:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 47.50.39477.B0ABD736; Wed, 23 Nov 2022 15:13:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20221123061031epcas5p3745558c2caffd2fd21d15feff00495e9~qIdnWPTRR2070420704epcas5p3D;
 Wed, 23 Nov 2022 06:10:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20221123061031epsmtrp183e514c3833a8cb7c05d9ed5236a695d~qIdnVMmo81965419654epsmtrp1i;
 Wed, 23 Nov 2022 06:10:31 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-62-637dba0bc80e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 7E.0B.14392.759BD736; Wed, 23 Nov 2022 15:10:31 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20221123061028epsmtip1037ad002957474830da1f8292a02e3a5~qIdkYhWF21761417614epsmtip1L;
 Wed, 23 Nov 2022 06:10:28 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 james.smart@broadcom.com, kch@nvidia.com, damien.lemoal@opensource.wdc.com,
 naohiro.aota@wdc.com, jth@kernel.org, viro@zeniv.linux.org.uk
Date: Wed, 23 Nov 2022 11:28:23 +0530
Message-Id: <20221123055827.26996-7-nj.shetty@samsung.com>
In-Reply-To: <20221123055827.26996-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxjOube9LbiSK8I8dnE0NRBEoZQVdlqBbZHpnZql4vxDENaUO4qU
 tvRDJ1P5UMShfJSAzLIBy4YOEDsLEgS6ISIIgswwPg0yBixjCijiFgRkLa2b/573eZ/n/To5
 bNw9m8VlJ6j0tFYlU/IJV0b9ra2+/usaT8gDS5sFyNzVjqOM/BUcVY/mEWippxdH1tkSJhpu
 uYGhyurbGGr69imGbq/OEGh8YYSBCloHAJrqN2HIOrINNVs7Gaiv8WsClV2aYiFjRy0TNUym
 A1S/VIajZxWnWejqozkGujPyFupd6WC+v5EyjfUQ1A3TKIvqfXiNQfX1GChL1ZcEVft9KtU0
 nEZQOadmbYLMMSY191M/QeXWVQHqmeVtKqvlHEZZJmcwqVtUYqiClsXRWh6tkqvjElTxYfy9
 B2J3xgaHBAr9hWL0Lp+nkiXRYfyIfVL/XQlK2/583hGZ0mCjpDKdji8ID9WqDXqap1Dr9GF8
 WhOn1Ig0ATpZks6gig9Q0XqJMDAwKNgm/DRR0TGVS2huRnyeszCFp4FRlA3YbEiK4Dcl27OB
 K9udbAIwffE+5gjmAVzquw4cwd8AFj5os2Vc1hzDGecIR8IK4OXZXKcqE4PL3ecZ9roEuQ3e
 XWXbeQ8yF4Nnm1pwe4CTJRicubTMspfaQEphfq+ZYccM0hu+GBgHdswhJXDqTAXTMaAA5o2t
 t9Mu5A7Yfb8Rc0jWw86Lk2tWnPSCp66XrNWHZJkLLL77hOkYNQLOp7904g3wr446lgNz4XTe
 GSc+CisLfyAc5tMAmgZNwJF4D2Z25eH2IXByKzQ3Chz0ZljUdRVzNHaDOUuTzrNwYEPpK7wF
 XjGXEw68CQ78k+7EFGwbKHYeOBfAnPZyVj7gmV5byPTaQqb/W5cDvApsojW6pHhaF6wJUtFH
 /3tmuTrJAtY+hd+eBjD+25OAVoCxQSuAbJzvwUn96LjcnRMnO5ZCa9WxWoOS1rWCYNvBjTjX
 U662/SqVPlYoEgeKQkJCROJ3QoT8jZzvvvKTu5PxMj2dSNMaWvvKh7FduGmYKGZ1NkjDbItp
 UzR3jia6vLCmnMRjjUU/ZpRnV6sPZaRO1FXEtERJgDlrqChr94fRgx0WecpKPX6hZLCntqjU
 K/rx+SGfwsUtbxRXHnSvLo28xlvcE3SwqEY5YahxK5T+yWs6KTtwRHLcd/7enTndm+PRoYe3
 s/t9JGdTdhldufe8b33w2KhV7F9dx7hSc6GYryhd6C+WemZlcf6YD83f4WO9OcMsI6crsb3l
 D8ZOjPnjT9XJgoKXs2Lf6sMTNUNRn/1s9Bb8LgxIj9uXeeyT/Q+jJ3TPLeGR4oTLH7c3mr0u
 Dk23JZP9XyT/6ieO3Ik/4g5olg8FeXC7n3tKwkMLftnMZ+gUMqEfrtXJ/gXd/2xKnQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWy7bCSnG74ztpkg4m/+C3WnzrGbNE04S+z
 xeq7/WwWv8+eZ7bY+242q8XNAzuZLFauPspksXvhRyaLo//fslk8/HKLxWLSoWuMFk+vzmKy
 2HtL22LP3pMsFpd3zWGzmL/sKbvFxOObWS12PGlktNj2ez6zxeelLewW616/Z7E4cUva4vzf
 46wO4h6z7p9l89g56y67x/l7G1k8Lp8t9di0qpPNY/OSeo/dNxvYPHqb3wEVtN5n9Xi/7yqb
 R9+WVYwenzfJebQf6Gby2PTkLVMAXxSXTUpqTmZZapG+XQJXxvGnfWwFB10qer88ZW5gvGvR
 xcjJISFgInGzqZuti5GLQ0hgN6PEm9W7mSASkhLL/h5hhrCFJVb+e84OUdTMJPFt4UagDg4O
 NgFtidP/OUDiIgILmCQu33vFDOIwCyxlkph95S4bSLewgJ/EkZ6FLCA2i4CqxK9rDxlBbF4B
 K4mnbUtZQQZJCOhL9N8XBAlzClhLnLm4iwkkLARUsmeZDkS1oMTJmU/ApjALyEs0b53NPIFR
 YBaS1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLjWEtzB+P2VR/0DjEy
 cTAeYpTgYFYS4a33rEkW4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoR
 TJaJg1OqgYkjP+JdaE5Hsl/M/yUTvtjJLeW3fvfB1vyqYML+5dcEeVSV+pwCgmTyeJn4jGzU
 lQUdH/7WOafOtliWkdGv4UXTPPbeCHn1wN2Tlf8f/2Kt77ha9zG/crrrr6wb5ps2PEovuLQr
 bUv63t2TWkpuOPMurLSuWJhj+PGR/IHP937f87+tEVW74WvH87Z86d+XJAKefROIT10V9bZ1
 DZPn7rhPoZs/hj3UXnzl8PUtvpmRPQ4Wp/5x3ta4JsakoKHg39RwOcJaPVYpqCx4M1NoWklr
 ETv/MYd5P//dY1gx/zv3MfnIBV+v+f1ufuew7vSh7ynh02tfP9b/sPK+h8P6SKMPdS/KV0Vx
 f/32S68zVomlOCPRUIu5qDgRAGi3Ai9SAwAA
X-CMS-MailID: 20221123061031epcas5p3745558c2caffd2fd21d15feff00495e9
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061031epcas5p3745558c2caffd2fd21d15feff00495e9
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061031epcas5p3745558c2caffd2fd21d15feff00495e9@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 23 Nov 2022 08:25:56 +0000
Subject: [dm-devel] [PATCH v5 06/10] nvmet: add copy command support for
 bdev and file ns
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 drivers/nvme/target/io-cmd-file.c | 51 ++++++++++++++++++++
 drivers/nvme/target/loop.c        |  6 +++
 drivers/nvme/target/nvmet.h       |  2 +
 5 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index c8a061ce3ee5..5ae509ff4b19 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -431,8 +431,7 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 	id->nn = cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id->mnan = cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id->oncs = cpu_to_le16(NVME_CTRL_ONCS_DSM |
-			NVME_CTRL_ONCS_WRITE_ZEROES);
-
+			NVME_CTRL_ONCS_WRITE_ZEROES | NVME_CTRL_ONCS_COPY);
 	/* XXX: don't report vwc if the underlying device is write through */
 	id->vwc = NVME_CTRL_VWC_PRESENT;
 
@@ -534,6 +533,12 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 
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
index 64b47e2a4633..a81d38796e17 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -338,6 +338,48 @@ static void nvmet_file_dsm_work(struct work_struct *w)
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
+}
+	nvmet_req_complete(req, ret);
+
+}
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
@@ -346,6 +388,12 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
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
@@ -392,6 +440,9 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
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
index b45fe3adf015..55802632b407 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -146,6 +146,12 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return ret;
 
 	blk_mq_start_request(req);
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
index dfe3894205aa..3b4c7d2ee45d 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -391,6 +391,8 @@ struct nvmet_req {
 	struct device		*p2p_client;
 	u16			error_loc;
 	u64			error_slba;
+	struct range_entry *ranges;
+	unsigned int nr_range;
 };
 
 extern struct workqueue_struct *buffered_io_wq;
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

