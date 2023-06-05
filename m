Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686D6C7EE24
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 12:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685968330;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+Z0ekJonurTJjKXNjxViH2krxcN/ZqWCkCikmwHZsEM=;
	b=KDXqlwAYBOGGljqzgMo/Xr0Khl1n3H240vqStcXmB8oA790qF5dolh2zfruo1g92MwxtVr
	MAnFOcEwxaHaO2eceRZQ0xpoXn93531wPrPrUcta9TVMpM2OJZW3mIL1it9UViidttY8ry
	WK2tT3JL9Of8Dm9X5/wsPXniVVTN3hY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-4zBhQJ4jM22ybSO4RNs0bQ-1; Mon, 05 Jun 2023 08:30:14 -0400
X-MC-Unique: 4zBhQJ4jM22ybSO4RNs0bQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C4FA3825BA0;
	Mon,  5 Jun 2023 12:30:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 894582026D6A;
	Mon,  5 Jun 2023 12:30:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 177D11946A46;
	Mon,  5 Jun 2023 12:29:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 51FD419465BD
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 12:29:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E53B140E956; Mon,  5 Jun 2023 12:29:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35C31140E954
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 12:29:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 183D23825BB4
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 12:29:56 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-_udiLZSpPcOFRDaGZgsGWg-1; Mon, 05 Jun 2023 08:29:54 -0400
X-MC-Unique: _udiLZSpPcOFRDaGZgsGWg-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230605122951epoutp0353a1e17c342d6c9fb6cb58e551e589d1~lwyMZyNrN1128511285epoutp03N
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 12:29:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230605122951epoutp0353a1e17c342d6c9fb6cb58e551e589d1~lwyMZyNrN1128511285epoutp03N
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230605122950epcas5p136d93b014386a849cfd5869aaec685f3~lwyLul6So0215902159epcas5p1h;
 Mon,  5 Jun 2023 12:29:50 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4QZXx91CgYz4x9Pv; Mon,  5 Jun
 2023 12:29:49 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 8C.5D.16380.D35DD746; Mon,  5 Jun 2023 21:29:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230605122349epcas5p2de6c758bc38194ebfb1fd8c700e45608~lws7aUZgZ3244532445epcas5p2G;
 Mon,  5 Jun 2023 12:23:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230605122349epsmtrp29f7a21e8ed8ea1907e7bb327a40f384c~lws7ZGsem1056310563epsmtrp2Z;
 Mon,  5 Jun 2023 12:23:49 +0000 (GMT)
X-AuditID: b6c32a4b-7dffd70000013ffc-11-647dd53dac52
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 09.D5.28392.5D3DD746; Mon,  5 Jun 2023 21:23:49 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230605122343epsmtip245dddb1bc0bcc26599c570b39b4b9fcb~lws2FYJfX2527325273epsmtip2l;
 Mon,  5 Jun 2023 12:23:43 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, James Smart
 <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Date: Mon,  5 Jun 2023 17:47:23 +0530
Message-Id: <20230605121732.28468-8-nj.shetty@samsung.com>
In-Reply-To: <20230605121732.28468-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHPfe2t8Ws7AISDw+32k0IGB6dpTtVGWQjcjPcVrdlEXErHVwe
 AdqutwwHWYCBOjSCwJihOB5KeG4ghUEBYVJRxnuOh5MBGkLjJlsBGQEkwqgtm/99zvf8vr/X
 yeHi9hUcZ26sQkOrFfJ4AbGT1XzTw93Lf+zLSN+H/WxU33cbR7VTOQSau/kYoG8X1nA0e+Ms
 QCOztujBTwGow1TERvdutGLo+pU8DFXX3sJQe9kihvIM4wAZx7QY6pjYj8rOlLPQ9Y5eFhpp
 u0ygkgojB52/qydQZc8Ghgz5GRjSz6YD1LxegqO6uXkW+nnCBQ0/7WGj9dXLRKArNTIaQmnv
 DxJUq3aKQw1PN7CoxipPamQwkdLVZBFUY3kq1X4vjaCuZuezqQsZJoJaNE6wqPnOMYLKbqoB
 VGN/CrWke0lqdyLucAwtj6TVfFoRoYyMVUT7C0I+kL0l8xP7Cr2EEvS6gK+QJ9D+gqCjUq8j
 sfFb2xHwP5fHJ25JUjnDCHzeOKxWJmpofoyS0fgLaFVkvEqk8mbkCUyiItpbQWsOCn19X/Pb
 CgyPi/m7c5mlanI+9SQ/Pg20OZ4DNlxIimBOazvrHNjJtSfbAZwbXSUsh8cAGv8xAXOUPbkE
 4GDL7m3H4m8twBLUBmBrXr7VcRqDZ550cc4BLpcg98P+Ta5Z30VW4TB9ZeBZDZwsx2H1Xwts
 cyoHUgK75hsxM7PIfVCf/hVmNvPIg3Cg6SMzQtIH5ty3M0fYkIfgn4MG3Mw80g72Fs6yzIyT
 L8OMH4twc3pIDtnAlj+mCEunQfBK7pCVHeCjniaOhZ3hkqnDqifB6m+qCIs5E0DtXS2wXATA
 0305uLkJnPSA9W0+FnkPLOirwyyFbeGF9VnMovOgvnibX4Hf15da8zvB8ZV0K1PQmGGw7job
 wFHdGOci4GufG0j73EDa/0uXArwGONEqJiGaZvxUBxR00n+PHKFM0IFnH8YzRA9mHix4GwDG
 BQYAubhgF6/t7ZRIe16k/ItkWq2UqRPjacYA/Lb2nYs7O0Yot36cQiMTiiS+IrFYLJIcEAsF
 u3nu/r0R9mS0XEPH0bSKVm/7MK6NcxoGiAr/ZF7oypzXd8FRyYpEt0+iujJ3iEMq9bLNfTMc
 terksvvTcN0d+4LR5l/6J7tXz+aWc08uf33+UtkIf3hgr0/WcePRzXBhlKT8qnL5jtR0S8kZ
 y607XsSQoS7GydrxUwPN0hTTh06Btx8Vn+g6psceagaQg9uLqQEz3dOZP5Q21BcUKd50Ueo2
 dpjePRQ+JG73zArLW7tYqcv+9FVPVYJgOkktwYIL63yPBI2WdhtySukJ6aUpR9m13KlfM6Tv
 e78QcY39XtWUm2vYrGtwQtbehtDAzD1B74RVh9EeMtu1jsacjzfaaGqO7i1hFx5jOidTlaGf
 FXvxf28nFkWlAhYTIxd64mpG/i8/msbEuQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWy7bCSvO7Vy7UpBu/7WS3WnzrGbLH6bj+b
 xevDnxgtpn34yWzx5EA7o8XlJ3wWD/bbW+x9N5vV4uaBnUwWexZNYrJYufook8XuhR+ZLCYd
 usZo8fTqLCaLvbe0LRa2LWGx2LP3JIvF5V1z2CzmL3vKbtF9fQebxfLj/5gsDk1uZrLY8aSR
 0WLb7/nMFutev2exOHFL2uL83+OsFr9/zGFzkPG4fMXbY9b9s2weO2fdZfc4f28ji8fmFVoe
 l8+Wemxa1cnmsXlJvcfumw1sHov7JrN69Da/Y/P4+PQWi8f7fVfZPPq2rGL02Hy62uPzJrkA
 wSgum5TUnMyy1CJ9uwSujLf7vrIUbJGq+DU5p4Fxl2gXIyeHhICJxMcb2xm7GLk4hAR2MEp0
 bmtnhkhISiz7ewTKFpZY+e85O0RRM5PE843NQB0cHGwC2hKn/3OAxEUEtjBLnP01mRXEYRbY
 xizx4cMXdpBuYQFLiYPvNzOB2CwCqhI7GpuYQJp5BawkzmwJAzElBPQl+u8LglRwClhLvDx7
 iBkkLARUcfW9DUiYV0BQ4uTMJywgNrOAvETz1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iw
 wCgvtVyvODG3uDQvXS85P3cTIzj+tbR2MO5Z9UHvECMTB+MhRgkOZiUR3l1e1SlCvCmJlVWp
 RfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MIkbP1hnzBXvn/7r08Hs
 PyxMm8T0AyI23dS9++JZ7gGm9Vou2mt3WV/4t0Xnzc0qfZO5U75qesgEzp1RVXd5s8gBF/ue
 E2dnPb+9KEssXMjrbVOVpf0XPpf1tY01RdtKTqXZmlfo5r8T3P5DMs3GXit3qd7XtfwxG1NL
 LM5apX/9sf3Xq1+iKkLzmb0/Rnav+9Z5bt+8xkuLDbnEnphtylaPdPI9utGco8uFZ/eC2Q9C
 7qh9Ut46pVeJ5WfBtpyjupVT2mPU7sTLu2Umz74jdd1D79Ck73dj8jn+Hbq6Lif6ftcRbSZP
 /ozlp38HKzDbsnrO3byYd9bUevMbLE59sssr51+XOd9npt3b991mthJLcUaioRZzUXEiAC14
 gQpuAwAA
X-CMS-MailID: 20230605122349epcas5p2de6c758bc38194ebfb1fd8c700e45608
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230605122349epcas5p2de6c758bc38194ebfb1fd8c700e45608
References: <20230605121732.28468-1-nj.shetty@samsung.com>
 <CGME20230605122349epcas5p2de6c758bc38194ebfb1fd8c700e45608@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v12 7/9] dm: Add support for copy offload
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
Cc: linux-nvme@lists.infradead.org, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, djwong@kernel.org,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Before enabling copy for dm target, check if underlying devices and
dm target support copy. Avoid split happening inside dm target.
Fail early if the request needs split, currently splitting copy
request is not supported.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-table.c         | 41 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  7 ++++++
 include/linux/device-mapper.h |  5 +++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1398f1d6e83e..b3269271e761 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1867,6 +1867,39 @@ static bool dm_table_supports_nowait(struct dm_table *t)
 	return true;
 }
 
+static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !blk_queue_copy(q);
+}
+
+static bool dm_table_supports_copy(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < t->num_targets; i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->copy_offload_supported)
+			return false;
+
+		/*
+		 * target provides copy support (as implied by setting
+		 * 'copy_offload_supported')
+		 * and it relies on _all_ data devices having copy support.
+		 */
+		if (!ti->type->iterate_devices ||
+		     ti->type->iterate_devices(ti,
+			     device_not_copy_capable, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -1949,6 +1982,14 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		q->limits.discard_misaligned = 0;
 	}
 
+	if (!dm_table_supports_copy(t)) {
+		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
+		q->limits.max_copy_sectors = 0;
+		q->limits.max_copy_sectors_hw = 0;
+	} else {
+		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
+	}
+
 	if (!dm_table_supports_secure_erase(t))
 		q->limits.max_secure_erase_sectors = 0;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4361a01bff3a..d9f45a1f0a77 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1720,6 +1720,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	if (unlikely(ci->is_abnormal_io))
 		return __process_abnormal_io(ci, ti);
 
+	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
+			max_io_len(ti, ci->sector) < ci->sector_count)) {
+		DMERR("Error, IO size(%u) > max target size(%llu)\n",
+			ci->sector_count, max_io_len(ti, ci->sector));
+		return BLK_STS_IOERR;
+	}
+
 	/*
 	 * Only support bio polling for normal IO, and the target io is
 	 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a52d2b9a6846..04016bd76e73 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -398,6 +398,11 @@ struct dm_target {
 	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
 	 */
 	bool needs_bio_set_dev:1;
+
+	/*
+	 * copy offload is supported
+	 */
+	bool copy_offload_supported:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

