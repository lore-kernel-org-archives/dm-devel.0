Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B978C7619A
	for <dm-devel@archiver.kernel.org>; Wed, 12 Apr 2023 06:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681281568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0uXPqZBhQs8HUl+W32c2fBaO9jQezHWWKtt55x6CGy0=;
	b=c3dVERqTswA78DWsXo4xamLKnobpXtgZj4vz2S3QV8DID8dtOgM2iJe3oeVNaNYDQfNI74
	H/q23lCH260m/3vWROHmDbXPiJWn8E5SQiFmJBRXKxu3qIQXyOD0VTP9iZ37itW+7NhDfg
	IfjMB+bOZvYirIq1cJp1d2UlkJj1+W4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-lZuYFg-TNRCUMOorL1RVMg-1; Wed, 12 Apr 2023 02:39:24 -0400
X-MC-Unique: lZuYFg-TNRCUMOorL1RVMg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E8A585A588;
	Wed, 12 Apr 2023 06:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E136492C1B;
	Wed, 12 Apr 2023 06:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B343419472D2;
	Wed, 12 Apr 2023 06:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 132F91946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 08:19:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E857D2027040; Tue, 11 Apr 2023 08:19:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFA10202701E
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB1E7858F0E
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:38 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-UcG66hhLMUO8lWZU2mDFTg-1; Tue, 11 Apr 2023 04:19:35 -0400
X-MC-Unique: UcG66hhLMUO8lWZU2mDFTg-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230411081932epoutp030293d693a3d775996e5fd1c9d9ce959b~U048B428B1233312333epoutp03c
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230411081932epoutp030293d693a3d775996e5fd1c9d9ce959b~U048B428B1233312333epoutp03c
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230411081930epcas5p170a47f66c746b9701742d0cc9b3d1f10~U047APlX-0386303863epcas5p1H;
 Tue, 11 Apr 2023 08:19:30 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4Pwdzj188Bz4x9Ps; Tue, 11 Apr
 2023 08:19:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 4F.6B.09961.01815346; Tue, 11 Apr 2023 17:19:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081332epcas5p257c090a0d1ea6abf98416ca687f6c1e1~U0ztP0i8E1989319893epcas5p2A;
 Tue, 11 Apr 2023 08:13:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230411081332epsmtrp13f71e3a58be2eae3a33c354b1ea119e8~U0ztO7KNa1918219182epsmtrp1N;
 Tue, 11 Apr 2023 08:13:32 +0000 (GMT)
X-AuditID: b6c32a49-2c1ff700000026e9-62-64351810ea7f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 11.FD.08609.CA615346; Tue, 11 Apr 2023 17:13:32 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081329epsmtip281d01e8da5afbcf0f02a3ea104ab9c3c~U0zp45Bn81199111991epsmtip2T;
 Tue, 11 Apr 2023 08:13:28 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Apr 2023 13:40:33 +0530
Message-Id: <20230411081041.5328-7-anuj20.g@samsung.com>
In-Reply-To: <20230411081041.5328-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVDTdRzH+/5+48fG3byfYPCNTlhLWkA8DBh94XjwQrlfpweUUV6njB37
 OTjGtvaQUNw1ITAwwbDsHBTKFR5MISbZxsPsQORJoJp0ogxMwQcQpmBXhEhjPyj/e30+3/fn
 8XsfNu55xN2XnaPQ0mqFRM4nPFgXugMFISQUScP7KmJR88BlHBUdW8GR0V5JoNnuBYBOPFzC
 0c2LiahzvtoNjf1swVBHXRWGGow9GGo//QhDPatzBKrq+h2g6VEDhjqvB6OOzn4WsrXVEKi2
 ftoddR0vxpB56hBAF5ZrcdQ062ChvusvopGVXrftkLJd3UUZJocIymKwu1MjEy0syjako0yN
 ZQR1/rtPqPYxPUEdLZ4nKId1lKAqWhsBdX7wY2rR5EeZpuawtE3v58Zl0xIprebRiiylNEch
 i+fv2iNOEouiw4Uhwhj0Op+nkOTR8fwdu9NCknPkzg3weR9K5DqnK02i0fDDEuLUSp2W5mUr
 Ndp4Pq2SylVRqlCNJE+jU8hCFbQ2VhgeHiFyCjNzs0/Xd7irjNvzu2946cGEqBxw2JCMgnfu
 6oly4MH2JNsBnF/8CTDGAoCWs/0sxlgEcGD8Gr4RYh01uDEPbQC2Nc+tG8UYvNX5PbamIkgB
 vHS3xJVrC1mKw0fTZa5cOPkbBp+0Oly5vMjd8JLlIlhjFhkAK2xFrDXmkgjaW1ucGrazXhis
 nNy85uaQMfDJN58RjGQz7D855ZLjpD8s/rEaX8sPyVoObL8zzGJ63QF/WBghGPaCM72t7gz7
 wvuVpessg3/bpjGGVbD4shUwnAhLBipdPeBkIGxuC2PcW+FXA00YU3cTPLo8tR7KheZvN5gP
 DzfUrDOEncN6jBmFglc6uMyyPgfw9o1h/BjgGZ4Zx/DMOIb/K58CeCN4gVZp8mS0RqQSKuiD
 //1yljLPBFxXEfSmGdhvPgztAhgbdAHIxvlbuH+uRko9uVJJwUe0WilW6+S0pguInOv+Avd9
 PkvpPCuFViyMigmPio6OjoqJjBbyfbiC+P4sT1Im0dK5NK2i1RtxGJvjq8cSdm5NfXDvQKN5
 tVAiPJB5yO1pkGfy/LlVWa81veTL56Rmb6+AWz7skomIJTH76crtM96c2l/8CiOU5emn0l+O
 9ZmJ6Bsqzbde8W/SQ+v+OkOkKuj41+qD93OvBjY7xh3+RWX73zq8czYsYfzMu/UB1ANzNWeZ
 J3gM/LrlQfcElG5sVMx5r8eYspR5Ai/I4I56F7w9kyvdti+f9UeG+x7Vpyb5iKNmG5nc3BKc
 +pLjXFxK+AcRfb5JwTn814ZT/tk7OCsm7MJylWmQk2S3vPHqr5NFZQl746o4J98xHtn3WGGL
 zHolXWBewRMNhrMef1mEqRmlk8YGczcoKGy6FgLq+CxNtkQYhKs1kn8BDrSeF54EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfyyUcRzH932e5557WNceR903Ku2WVcqPkvn2Q6SVZ0st6Q9rK566Zzzj
 ZHf0Q6krs+qWI7aa0y9mzClxSuSUTgklzaH8uChkJodiJqGO2vrv/Xm/Xvt8/vhQuPgF4Ujx
 MXGcIoaNlpK2RFmN1Nnt/lJvmefllGXoYUMtji6lzeCo0JxKoqGa7wDdGJ3CUc9zP1RlyRKg
 9uoKDBly0jFUUPgKQ5XZYxh6NTdMonRjG0D9rVoMVXWsR4aqegKZnt4i0d28fiEyZiRhqLzv
 IkBl03dxVDQ0QqC6DifUNPNa4A8ZU8teRtvdSDIVWrOQafpUQjCmxnhGr7tKMqW5F5jKdhXJ
 pCRZSGbkWSvJaB7pAFP65izzQ7+S0fcNYwcWH7bdLuOi+ZOcwmNHuG1kdp5BGFvof7qm014F
 PnmrgQ0F6c3wWatWoAa2lJguB/BKbZlwAUDYMJgHFrI9LJgdEC5IFzGY3ZYzL5H0GvhyIBlY
 gQOdhsPmbhVpHXC6B4NNA+MCq2VPB8GXFc/nVxG0C9SYLhHWLKIRND8qwdWA+nPCA6Z221lr
 G3oL/HX7CmmtxX+UXMNf2w7WZ/bNZ5x2hkmPs/A0QGv/Q9r/0D2A6cAyLlYpj5ArN8ZuiuFO
 uStZuTI+JsL9+Am5Hsx/2dW1HBh0o+5GgFHACCCFSx1EE3NeMrFIxp5J4BQnwhTx0ZzSCJwo
 QioRvVfXh4npCDaOi+K4WE7xj2KUjaMKK4qK1idf9Vu1b2+QIAccWV7dUY/koU98A0BmicuN
 sQEOfeXOX9/ZCRZFhGQUOzmvmPGzkRx+4BNWGx68QRNQpcZEmYKptwk+bflZrCmQTTcHJU26
 7BnPKOF98zfMPs6/8Hmo+lzK7p6ZNpMhhOuTNjcbNO2qQ+zN/AbeEufrJUm8nZy4dnrXOnaC
 gEddhwO7ln/W534zN852TXs2rQ5eophmVsnqKvV5RXssIbzEThr6sS6Yv/aBf+ff/UWTYbZX
 v9gZlVXB77+OZ6aWToUfnDtaKu93K7rjmSpKKByTWAZ9J8u2um0WjB/b1vwz4IdHcW9vZ+Ao
 v1/RdV7XIiWUkexGV1yhZH8DcS0kglQDAAA=
X-CMS-MailID: 20230411081332epcas5p257c090a0d1ea6abf98416ca687f6c1e1
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230411081332epcas5p257c090a0d1ea6abf98416ca687f6c1e1
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081332epcas5p257c090a0d1ea6abf98416ca687f6c1e1@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 12 Apr 2023 06:39:18 +0000
Subject: [dm-devel] [PATCH v9 6/9] nvmet: add copy command support for bdev
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

