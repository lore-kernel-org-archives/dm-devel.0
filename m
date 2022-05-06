Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F55C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  6 May 2022 08:11:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-JFWgJjcbN2ildqkxn-n6jQ-1; Fri, 06 May 2022 04:11:19 -0400
X-MC-Unique: JFWgJjcbN2ildqkxn-n6jQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68F651014A64;
	Fri,  6 May 2022 08:11:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C3E31416364;
	Fri,  6 May 2022 08:11:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 11D6C1947B8D;
	Fri,  6 May 2022 08:11:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A80919451F0
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 08:11:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D7015D4CE5; Fri,  6 May 2022 08:11:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0803D5D4CE7
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4381380406E
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:14 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-kIXa6r84Op6P47gmglbhCw-1; Fri, 06 May 2022 04:11:13 -0400
X-MC-Unique: kIXa6r84Op6P47gmglbhCw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220506081111euoutp02e32b4edfcb36c013eabf9504910770e5~sdcmM9NSq2349823498euoutp02v
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220506081111euoutp02e32b4edfcb36c013eabf9504910770e5~sdcmM9NSq2349823498euoutp02v
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220506081110eucas1p2cfc43e30c9c38c97e466527376ef9f90~sdckiaQVi1314813148eucas1p2Z;
 Fri,  6 May 2022 08:11:10 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 96.05.09887.D18D4726; Fri,  6
 May 2022 09:11:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220506081109eucas1p26bbb68a1740b1af923ed862a93112780~sdcj-rG7n1919419194eucas1p2Q;
 Fri,  6 May 2022 08:11:09 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220506081109eusmtrp2db398a0a3f09537f71805983a29bb2c9~sdcj_iEtg2593625936eusmtrp2V;
 Fri,  6 May 2022 08:11:09 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-2d-6274d81df581
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 9D.E9.09404.D18D4726; Fri,  6
 May 2022 09:11:09 +0100 (BST)
Received: from localhost (unknown [106.210.248.174]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220506081109eusmtip22afa82e359d99dbc946388ce73357abc~sdcjmtyWb1925719257eusmtip28;
 Fri,  6 May 2022 08:11:09 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, hare@suse.de, dsterba@suse.com, axboe@kernel.dk,
 hch@lst.de, damien.lemoal@opensource.wdc.com, snitzer@kernel.org
Date: Fri,  6 May 2022 10:10:57 +0200
Message-Id: <20220506081105.29134-4-p.raghav@samsung.com>
In-Reply-To: <20220506081105.29134-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTVxjeuff29lKtu7RGDiox6z4SIYAYNQdcHG5k3m3qdMk+QqZb0Tsg
 FjAtzDl+WIGBgCsFYYwWpDD5BosUyLCwkW7jGwUqs3YDSgdxYFZorDIsgVluzfz3PO/7POd9
 nzeHwkXN5FYqPjGZlSdKZRJSQLT3LN8KDrAkx+yaHYpA+oEeHK119pCoYSKPRN8tLuOoIO97
 PnIP38ZRl0PLQyP/XsTQve4ODHVWFmCoruE3DM3oNTi63L1IoLqMaRytTIehaZeVQAWm3wGa
 HddgqMsahMb+quWjzq5+AplvlpKovHqWj9SZj3BkUc8ClN9r4KGHVRl8dP3BAoH6rNsiAxjz
 nfeY1b5GkslPd/CZ25M3CMY8nMK01GeTTIWyCGcM1y4wxntKkvk23UEyHd9M8ZiFn8ZJRtVa
 Dxh96zjBGAZTGbXhBu+YKFrw+mlWFv8lKw898Lkgrk1XiJ1t3fKV09pNKEGTKAf4UJDeA92P
 ikAOEFAiuhZAq82Ic8QFYPr1uzyOPASw26HkP7MUXs73NmoAbG4ZwjgyB+DAip3MARRF0oHw
 YjbfU99M5wKYN5W17sZpAw+ONH3hwWI6Gg45npAeTNCvQpPSgnmwkA6H7UsOgpu2A5aMLa17
 fegImHZljuQ0vrC/ZIbg3twB09u063tDuk4AK1ddOGeOguZMTzoPFsP53lZvhO1wraMc43Aq
 nLW4veaMp5t26NcTQHo/VA3JPBCnd0L9zVBOfhCOZhZ5FZug5R9fboVNsKC9GOfKQngp03te
 CexYnvEOhdCcVupNxUDzsg2owUua58Jonguj+X+uDuD1wI9NUSTEsordiey5EIU0QZGSGBty
 KimhBTz91IOrva4fQc28M8QEMAqYAKRwyWahWJMcIxKelp7/mpUnfSZPkbEKE9hGERI/4an4
 ZqmIjpUms2dY9iwrf9bFKJ+tSkwdpG1q+2H0QvEH9wecR97Ya2jMov3r3+7bV1iXdAK+sm97
 SdYLbXbV3NVjh29Zjzv/viTQ8Wt507ZfUh4Yh2Kr84xXQqePv7Pr/YmR4I1RfknnbFPqT8p+
 vnu0XTXfvNasN1L+47K33AcrMQHqx87nlFVENEoCI13DCSFX7ftVWF3aZPnRqABjzUp9bont
 0MbKl2NOssMr2tQ3x/6Y3G0/Qr0mNsw1sNc+HgkN+mgyYDhr8PHh4BNnFtOK3St2fUV4T+Sn
 0d3ZE6Nhj+N0YVAn/nXvu1V3qsP9D6S+uHB/6sMtMmuj3XeprHenUFwqO9RWtUHmjMzVxmyw
 Gf9UmPY8GTgpIRRx0rBAXK6Q/gdbsHbUQwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t/xe7qyN0qSDLr3ilmsP3WM2eL/nmNs
 Fqvv9rNZTPvwk9liUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlnsWTSJyWLl6qNMFk/Wz2K2
 6DnwgcViZctDZos/Dw0tHn65xWIx6dA1RounV2cxWey9pW1x6fEKdos9e0+yWFzeNYfNYv6y
 p+wWE9q+MlvcmPCU0WLi8c2sFp+XtrBbrHv9nsXixC1pB1mPy1e8Pf6dWMPmMbH5HbvH+Xsb
 WTwuny312LSqk81jYcNUZo/NS+o9dt9sYPPobX7H5rGz9T6rx/t9V9k8+rasYvRYv+Uqi8fm
 09UeEzZvZA0QitKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxL
 LdK3S9DL2LpgClPBFrGKj7cOsDQwrhXqYuTkkBAwkZjSM5G1i5GLQ0hgKaPEk5cfGSESEhK3
 FzZB2cISf651sUEUPWeU+HX9IFMXIwcHm4CWRGMnO0hcRGAqo8SldSdZQBxmgdOsEls3HWAC
 6RYWiJDoO3UWzGYRUJU41HADzOYVsJTY9v0dC8QGeYmZl76zg9icAlYSTZNfsoHYQkA185fs
 YYWoF5Q4OfMJWD0zUH3z1tnMExgFZiFJzUKSWsDItIpRJLW0ODc9t9hIrzgxt7g0L10vOT93
 EyMwqWw79nPLDsaVrz7qHWJk4mA8xCjBwawkwis8qyRJiDclsbIqtSg/vqg0J7X4EKMp0N0T
 maVEk/OBaS2vJN7QzMDU0MTM0sDU0sxYSZzXs6AjUUggPbEkNTs1tSC1CKaPiYNTqoGJYZaH
 oMzujjB13YSji04LiYfp7lthlhT+O1X7+ekjgseaumLvrX8l/79ad+f3PXdkDvwT6Hu7sosz
 iuPlCo7cK1LMCa33/8pKeZrNmC+9oOXLF7ZA5+sRfHMr8kK35UyccUNHQ3D3Xu35k2WjH8st
 6aiLSpn13HOVjsIB39Apz0LedrLUzOc8x/XY5HZFYrV9uxX35lsLb7w+6/SjMcLW6v7TSzlZ
 s7bkTp0lHF4dvO3o/oNqx99qtiyUYEw7Lv+o3/ju0XqrH7Hsa63vrC//cjLgupHL9tv3J2+d
 lPR5zgGf830h6geOLKsrtl5nPKPQ1P7m1R69a8tzzrAkZEUd1f1b9qaMZ03noT32BkcalFiK
 MxINtZiLihMBVhMFw7MDAAA=
X-CMS-MailID: 20220506081109eucas1p26bbb68a1740b1af923ed862a93112780
X-Msg-Generator: CA
X-RootMTR: 20220506081109eucas1p26bbb68a1740b1af923ed862a93112780
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220506081109eucas1p26bbb68a1740b1af923ed862a93112780
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081109eucas1p26bbb68a1740b1af923ed862a93112780@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v3 03/11] nvme: zns: Allow ZNS drives that have
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 bvanassche@acm.org, gost.dev@samsung.com, jonathan.derrick@linux.dev,
 Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, matias.bjorling@wdc.com,
 Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
 linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 linux-fsdevel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>,
 linux-btrfs@vger.kernel.org
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

