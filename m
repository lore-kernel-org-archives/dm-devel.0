Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC1AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 13:39:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-jWhTfFPOO_icRk56jXN04Q-1; Mon, 16 May 2022 09:39:35 -0400
X-MC-Unique: jWhTfFPOO_icRk56jXN04Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FE7D86B8B3;
	Mon, 16 May 2022 13:39:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34A9D403171;
	Mon, 16 May 2022 13:39:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0173D1947055;
	Mon, 16 May 2022 13:39:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B6F21947040
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57AFC40CF8EF; Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16A1040CF8E2
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3CBE833961
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:30 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-CcyeqLseOzKLiWG4EpwE_Q-1; Mon, 16 May 2022 09:39:29 -0400
X-MC-Unique: CcyeqLseOzKLiWG4EpwE_Q-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516133928euoutp02303be76c38a936a7fdc8d389ecf403e1~vmYEefSeW1619516195euoutp02u
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220516133928euoutp02303be76c38a936a7fdc8d389ecf403e1~vmYEefSeW1619516195euoutp02u
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220516133927eucas1p122d438c502813e5d8e9ce1dc6e441a37~vmYD2eBBu1349413494eucas1p1O;
 Mon, 16 May 2022 13:39:27 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id FD.8D.09887.F0452826; Mon, 16
 May 2022 14:39:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220516133926eucas1p15c7ba425b67ce4ac824c6bd3263e2dd4~vmYDKZOUU3151131511eucas1p1j;
 Mon, 16 May 2022 13:39:26 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220516133926eusmtrp174af8671b36c1e39eea07ca2cc88c788~vmYDJC_8M0312203122eusmtrp1d;
 Mon, 16 May 2022 13:39:26 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-62-6282540fd992
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id D0.12.09522.E0452826; Mon, 16
 May 2022 14:39:26 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220516133926eusmtip2d219a7d8011c216ec7799bbaa6786ab3~vmYC5lFEU2362623626eusmtip27;
 Mon, 16 May 2022 13:39:26 +0000 (GMT)
Received: from localhost (106.110.32.130) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 16 May 2022 14:39:25 +0100
From: Pankaj Raghav <p.raghav@samsung.com>
To: <axboe@kernel.dk>, <naohiro.aota@wdc.com>,
 <damien.lemoal@opensource.wdc.com>, <Johannes.Thumshirn@wdc.com>,
 <snitzer@kernel.org>, <dsterba@suse.com>, <jaegeuk@kernel.org>, <hch@lst.de>
Date: Mon, 16 May 2022 15:39:11 +0200
Message-ID: <20220516133921.126925-4-p.raghav@samsung.com>
In-Reply-To: <20220516133921.126925-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Originating-IP: [106.110.32.130]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89x7e3tprN6WMp9AM7YqX7oAsjn3TJlKZNs17oPELTNmyCrc
 QCNFbOlwOqEd8iIyC9W6UbYMEwUEofQFpggIXQYy3gxvA8ZgZHZh4EALCBXEUa4ufPuf5/z+
 5/xP8lC4+BrpTymTUlh1kiJRRgqI2hZPV/Cmj78+ts1olCDLry04el7fQqKKPwwkuvLIgyOj
 4Ts+WursxlHDdBEP3V/UY+hGxS8YemAx4yiv6RGBnuWOrr6dG8fR8ngYGp8bJpDROQCQq9+M
 oYbhN1DPX2V8VN/QRqDeuu9J9GOJi4/ys+ZxNJjvAqig1c5DVVMzBLo3HLA3gOntO8Cs3LtJ
 MgUZ03yme9RKML2dWsZWfp5krupMOGO/ls7cGdKRzDcZ0yRzO3OMx8w09pOMxdFPMPl2K4+Z
 tb3KZDddwA7SRwThcWyi8gtWHbr7c0FCTfFlLNnxyqnHw02EDlSKc4EPBent0NV5icwFAkpM
 lwG4YnQTXDEH4POSJT5XzAJY/aSUeGlpbG7DuEYpgCP/VIP/qaHL9XwvJaYdABqMylxAUSQt
 h/rza5MkdDOAnvtla26cLuPBupVFwgv50kdgn22v10vQQXC+6yfcq4X0Tmi6/gPGbQ6EhT0L
 fC/uQ++C7ot7OEQE2wofrIXDV5GMmiKc0xA2T0zgXhzSMljUG8JNOQsrWzrW4kC6TQA7r9zg
 c0wkdC18wjG+cLLVwee0FLZfyntx+xnoGlzCOe+51QtvW0jOuwte7EjkZAScnxZzciMc/FfE
 hdkIjbXfvggjhDlZ4nyw1bwuvnldfPO6+MUALwebWa1GFc9q3kxiU0M0CpVGmxQfEntCZQOr
 H7l9pXXuFiidfBziBBgFnABSuEwi3HZKd0wsjFN8eZpVn4hRaxNZjRMEUIRsszBWWa0Q0/GK
 FPY4yyaz6pddjPLx12El2SdfH0haiLGnTL0TcTJc7qYfBlduyCx862fz8Zm7jWO+trd3BhnY
 gFtB/gf7DpVb3u1p6JFK5dJU62d+pqc7BGdStjgjt6Qtffpw62tnx6RubUWW0K8gwnq0PWqf
 zbMcbTLkHdjg+1sQFeUXeHOqeoTUBFr9nrrvWHaPRj2JC/7oEJZ2uHI/IcrJtqdNSK4368sX
 ZrMnh+r2fVXtDN/0zI/17FhOH4nJqTUlNNmqTodCk1X+/nSNpDvmqNlQnhrK10cGF28XLP5Z
 EqaK7i77/W/P1cyMmg8Kox2q8NKAKrd2QBTRkRw7eTdN8N6e4kbQJYqv+zBPeVh2oSO9w6SP
 lhGaBEWYHFdrFP8BmTVqYTcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t/xe7p8IU1JBo0NKhbrTx1jtvi/5xib
 xeq7/WwW0z78ZLaY1D+D3eL32fPMFnvfzWa1uPCjkcli5eqjTBZP1s9itug58IHF4m/XPaBY
 y0Nmiz8PDS0efrnFYjHp0DVGi6dXZzFZ7L2lbXHp8Qp2iz17T7JYXN41h81i/rKn7BYT2r4y
 W9yY8JTRYuLxzawW616/Z7E4cUvaQdrj8hVvj38n1rB5TGx+x+5x/t5GFo/LZ0s9Nq3qZPNY
 2DCV2WPzknqP3Tcb2Dx6m9+xeexsvc/q8X7fVTaP9VuusnhM2LyR1ePzJjmP9gPdTAECUXo2
 RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZWxdMYSrY
 Ilbx8dYBlgbGtUJdjJwcEgImEvsOnmTqYuTiEBJYyiix7fJ0FoiEjMSnKx/ZIWxhiT/Xutgg
 ij4ySvROaIHq2MIo0bx4E1AHBwebgJZEYyc7SFxE4CCjxM8LK5hAupkFVrBK/NlTC2ILC0RI
 XHy+gBnEZhFQlfh6bjuYzStgJTF16VwmiG3yEjMvfWcHmckpYC3xqc8exBQCKln/pgiiWlDi
 5MwnLBDT5SWat85mhrAlJA6+eMEMUi4hoCQx+7IexMBaiVf3dzNOYBSZhaR7FpLuWUi6FzAy
 r2IUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAhMWduO/dy8g3Heq496hxiZOBgPMUpwMCuJ8BpU
 NCQJ8aYkVlalFuXHF5XmpBYfYjQFenIis5Rocj4waeaVxBuaGZgamphZGphamhkrifN6FnQk
 CgmkJ5akZqemFqQWwfQxcXBKNTCZb17z8x47fzufkEuD3RsrlbrSo17yj/Nf16gr8rCpy2lv
 aH0YtCmR20b4oXpX5PKzJXvPnnIOjzqVnZ8//ddKHeuT8iW/1sTsXxsnuc54srvro/IAZr25
 O7vj96wrt90yqXBW09d30RK+J/pLJsRfeLasLbuQd/PJn64TxZ12LH88qSLl+2qz6X2ZtxrN
 zk0NvXbQYjqnTUxkjzljz9KIZ2tjhTsq/jNpbdyx5vkxnhXL3fetOLzz0nr9z0yTa3qnvph9
 3962zKunk/3ipDV8XfFCusfN7N5vMO7/yM7kKF92IXKW8xYb5efCa2fm5nZ8ahaM+OtQFXhh
 sXfmEuWz8ys/fL77MaPm2jHe9rtKLMUZiYZazEXFiQApbGJp4gMAAA==
X-CMS-MailID: 20220516133926eucas1p15c7ba425b67ce4ac824c6bd3263e2dd4
X-Msg-Generator: CA
X-RootMTR: 20220516133926eucas1p15c7ba425b67ce4ac824c6bd3263e2dd4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516133926eucas1p15c7ba425b67ce4ac824c6bd3263e2dd4
References: <20220516133921.126925-1-p.raghav@samsung.com>
 <CGME20220516133926eucas1p15c7ba425b67ce4ac824c6bd3263e2dd4@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v4 03/13] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
Cc: jiangbo.365@bytedance.com, Jens Axboe <axboe@fb.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, bvanassche@acm.org,
 Chris Mason <clm@fb.com>, matias.bjorling@wdc.com, gost.dev@samsung.com,
 Pankaj Raghav <p.raghav@samsung.com>, Luis Chamberlain <mcgrof@kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, jonathan.derrick@linux.dev,
 Keith Busch <kbusch@kernel.org>, Johannes Thumshirn <jth@kernel.org>,
 linux-btrfs@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the condition which disallows non-power_of_2 zone size ZNS drive
to be updated and use generic method to calculate number of zones
instead of relying on log and shift based calculation on zone size.

The power_of_2 calculation has been replaced directly with generic
calculation without special handling. Both modified functions are not
used in hot paths, they are only used during initialization &
revalidation of the ZNS device.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/host/zns.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 9f81beb4d..65d2aa68a 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -101,13 +101,6 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 	}
 
 	ns->zsze = nvme_lba_to_sect(ns, le64_to_cpu(id->lbafe[lbaf].zsze));
-	if (!is_power_of_2(ns->zsze)) {
-		dev_warn(ns->ctrl->device,
-			"invalid zone size:%llu for namespace:%u\n",
-			ns->zsze, ns->head->ns_id);
-		status = -ENODEV;
-		goto free_data;
-	}
 
 	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
@@ -128,8 +121,13 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 	const size_t min_bufsize = sizeof(struct nvme_zone_report) +
 				   sizeof(struct nvme_zone_descriptor);
 
+	/*
+	 * Division is used to calculate nr_zones with no special handling
+	 * for power of 2 zone sizes as this function is not invoked in a
+	 * hot path
+	 */
 	nr_zones = min_t(unsigned int, nr_zones,
-			 get_capacity(ns->disk) >> ilog2(ns->zsze));
+			 div64_u64(get_capacity(ns->disk), ns->zsze));
 
 	bufsize = sizeof(struct nvme_zone_report) +
 		nr_zones * sizeof(struct nvme_zone_descriptor);
@@ -182,6 +180,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
+	u64 remainder = 0;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
 		return -EINVAL;
@@ -197,7 +196,14 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
 	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
 
-	sector &= ~(ns->zsze - 1);
+	/*
+	 * rounddown the sector value to the nearest zone size. roundown macro
+	 * provided in math.h will not work for 32 bit architectures.
+	 * Division is used here with no special handling for power of 2
+	 * zone sizes as this function is not invoked in a hot path
+	 */
+	div64_u64_rem(sector, ns->zsze, &remainder);
+	sector -= remainder;
 	while (zone_idx < nr_zones && sector < get_capacity(ns->disk)) {
 		memset(report, 0, buflen);
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

