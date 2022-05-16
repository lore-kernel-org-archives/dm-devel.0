Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D71C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-tvsuIQzXMn-mrjR3hDmlYw-1; Mon, 16 May 2022 12:54:34 -0400
X-MC-Unique: tvsuIQzXMn-mrjR3hDmlYw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC44F185A7A4;
	Mon, 16 May 2022 16:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B9242492C14;
	Mon, 16 May 2022 16:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 744461947054;
	Mon, 16 May 2022 16:54:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 976C1194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 17C87400DE5E; Mon, 16 May 2022 16:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 13217400E880
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E45F43C01D84
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:29 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-NNhwfBLbMu2f02EpgMB8xg-1; Mon, 16 May 2022 12:54:28 -0400
X-MC-Unique: NNhwfBLbMu2f02EpgMB8xg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165427euoutp02426edb0f970b8ffe2bc1b3418a9b9c40~vpCUISxd22798227982euoutp02I
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220516165427euoutp02426edb0f970b8ffe2bc1b3418a9b9c40~vpCUISxd22798227982euoutp02I
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220516165425eucas1p202583878951ecf13abff73433caed273~vpCSLKaCf2458224582eucas1p2a;
 Mon, 16 May 2022 16:54:25 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id FD.3A.09887.0C182826; Mon, 16
 May 2022 17:54:25 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220516165424eucas1p2ee38cd64260539e5cac8d1fa4d0cba38~vpCRkEAod2458324583eucas1p2a;
 Mon, 16 May 2022 16:54:24 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220516165424eusmtrp2e805a2cfc6551f0fbfbd804b04689d96~vpCRdqqyG1030710307eusmtrp2s;
 Mon, 16 May 2022 16:54:24 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-33-628281c097a2
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 9D.00.09404.0C182826; Mon, 16
 May 2022 17:54:24 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165424eusmtip1eac074d106663fe373f8f11517faf1da~vpCRLXgoG2383023830eusmtip1a;
 Mon, 16 May 2022 16:54:24 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:07 +0200
Message-Id: <20220516165416.171196-5-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djPc7oHG5uSDG6rW6y+289mMe3DT2aL
 32fPM1vsfTeb1eLCj0Ymi5sHdjJZ7Fk0icli5eqjTBY9Bz6wWOy9pW1x6fEKdos9e0+yWFze
 NYfNYv6yp+wWNyY8ZbT4vLSF3WLNzacsDoIel694e/w7sYbNY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1A4db7rB7v911l8+jbsorRY/2Wqywem09Xe3zeJBfAG8Vlk5Kak1mWWqRvl8CVcf7t
 BaaC/3wVM2/eY2xgvMnTxcjJISFgIjGzYx57FyMXh5DACkaJRXf6mCGcL4wSXdvPskA4nxkl
 dix9xgzTcnb2XyaIxHJGibmfj0E5zxklvp6YBORwcLAJaEk0drKDNIgIZElMO/GQEaSGWeA1
 k8SZzjusIAlhgQiJHW8bWEDqWQRUJf5syQMJ8wpYSTS+WAy1TF5i5qXv7CAlnALWEqu7uCFK
 BCVOznzCAmIzA5U0b50NdrWEwGZOibsLZ7ND9LpINE87AmULS7w6vgXKlpH4v3M+E4RdLfH0
 xm+o5hZGif6d69lAlkkALes7kwNiMgtoSqzfpQ9R7iix8c4JqAo+iRtvBSFO4JOYtG06M0SY
 V6KjTQiiWkli588nUEslJC43zWGBsD0kPiy7yTSBUXEWkmdmIXlmFsLeBYzMqxjFU0uLc9NT
 i43yUsv1ihNzi0vz0vWS83M3MQLT4el/x7/sYFz+6qPeIUYmDsZDjBIczEoivAYVDUlCvCmJ
 lVWpRfnxRaU5qcWHGKU5WJTEeZMzNyQKCaQnlqRmp6YWpBbBZJk4OKUamHLub8+u6LkkKWbr
 GhFVcifi2jWhhQdclB8uWjTvTf1KB28WNd5brpOyP8olVTnoljJIuk/n7/lbbRjA7c07M+0p
 065lB/7Y/F62K3ZtXn/S15P6opd+yPHc1n927KS4u7aIdWFYQJff5fNRE/fyOPcozr0nEiKd
 rJn36rdcN2Moh5JMfO/fnScXhHMuTHuyd9rGJEa76vb2lMVPPLaHV90Umr/twHy1KRsfRV1i
 tNnKk8B50viXSJ7lPF/9Eq67FSk8ClJz2e853gk0LZ30bfXpqucvAlizdvEvquPd+lmxuv1K
 W4ufWGzDAVU5UcX9GxSeuDxyY9hx6nVfYqNIR+w89gVVh6eYWFi7iVYqsRRnJBpqMRcVJwIA
 Hj+Oz/YDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t/xu7oHGpuSDOZ8FrRYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBY3D+xkstizaBKTxcrVR5kseg58YLHYe0vb4tLjFewWe/aeZLG4
 vGsOm8X8ZU/ZLW5MeMpo8XlpC7vFmptPWRwEPS5f8fb4d2INm8fOWXfZPS6fLfXYtKqTzWPz
 knqP3TcbgMKt91k93u+7yubRt2UVo8f6LVdZPDafrvb4vEkugDdKz6Yov7QkVSEjv7jEVina
 0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+P82wtMBf/5KmbevMfYwHiTp4uR
 k0NCwETi7Oy/TF2MXBxCAksZJQ7fa2eBSEhI3F7YxAhhC0v8udbFBlH0lFHi6JtvrF2MHBxs
 AloSjZ3sIDUiAgUSc/q3gPUyC3xnkpj6sgCkRFggTOLDB18Qk0VAVeLPljyQCl4BK4nGF4uZ
 IabLS8y89J0dpIRTwFpidRc3SFgIqOTrk1vsEOWCEidnPoEaLi/RvHU28wRGgVlIUrOQpBYw
 Mq1iFEktLc5Nzy020itOzC0uzUvXS87P3cQIjNttx35u2cG48tVHvUOMTByMhxglOJiVRHgN
 KhqShHhTEiurUovy44tKc1KLDzGaAl09kVlKNDkfmDjySuINzQxMDU3MLA1MLc2MlcR5PQs6
 EoUE0hNLUrNTUwtSi2D6mDg4pRqYuL75WAmfOFCabszqIbKKT+eu9cGyAzP25tguja7YNclD
 3tYrrTCq2u2jki2P7i9N5qw5MxsyXdaLKG+Q6ymKTND02CVw+dL/qV+m87Te6Hmy799kfrFr
 Lx7u6lvIbiO87Zi+exVDg/7uyCUSr9e1ysxZmT3JyzHq6z6ZF8fm3V62zSCq0rJ3op7p+3mr
 3619dvjAtqc8orKnlq+6HjbhnmrwNabgrUH+6xZrtUxvqHl6x9/87qsvIS1GzcKOf9/wb5un
 +ZBp027PlrRpx5JVX/6Pe2U8e5XaMkZn99y6liaBkyfka19och3wfrlh15IJ1ftYWjifbLOJ
 5pefbF658qeYdn2oxePzExYFui/7qMRSnJFoqMVcVJwIAGIunbBkAwAA
X-CMS-MailID: 20220516165424eucas1p2ee38cd64260539e5cac8d1fa4d0cba38
X-Msg-Generator: CA
X-RootMTR: 20220516165424eucas1p2ee38cd64260539e5cac8d1fa4d0cba38
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165424eucas1p2ee38cd64260539e5cac8d1fa4d0cba38
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165424eucas1p2ee38cd64260539e5cac8d1fa4d0cba38@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v4 04/13] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
Cc: p.raghav@samsung.com, Bart Van Assche <bvanassche@acm.org>,
 gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A generic bdev_zone_no helper is added to calculate zone number for a given
sector in a block device. This helper internally uses blk_queue_zone_no to
find the zone number.

Use the helper bdev_zone_no() to calculate nr of zones. This let's us
make modifications to the math if needed in one place and adds now
support for npo2 zone devices.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 2 +-
 include/linux/blkdev.h    | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 82b61acf7..5516dd6cc 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -242,7 +242,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
 	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	       bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32d7bd7b1..967790f51 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1370,6 +1370,13 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
+static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	return blk_queue_zone_no(q, sec);
+}
+
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

