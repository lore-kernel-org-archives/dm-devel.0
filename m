Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC1DC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-BZZuJzsyMBmQGnngpsqKFQ-1; Mon, 16 May 2022 12:54:42 -0400
X-MC-Unique: BZZuJzsyMBmQGnngpsqKFQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEA17811E7A;
	Mon, 16 May 2022 16:54:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9BB63492C14;
	Mon, 16 May 2022 16:54:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A66C1947073;
	Mon, 16 May 2022 16:54:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2BBCF194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B5942166B2D; Mon, 16 May 2022 16:54:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16D622166B25
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADD9885A5A8
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:27 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-CVLit1UDNDyoR8CqV4gyCg-1; Mon, 16 May 2022 12:54:26 -0400
X-MC-Unique: CVLit1UDNDyoR8CqV4gyCg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165425euoutp016923b17af37531c040f1a5eb42e4257a~vpCSGzikC2241022410euoutp016
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516165425euoutp016923b17af37531c040f1a5eb42e4257a~vpCSGzikC2241022410euoutp016
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220516165423eucas1p158930326081e188da90c844c41449d67~vpCQpqA1T3100231002eucas1p1G;
 Mon, 16 May 2022 16:54:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id B4.40.10009.FB182826; Mon, 16
 May 2022 17:54:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220516165422eucas1p174acec28848a9c2178376f092af3fa1c~vpCQK_Iy22562625626eucas1p1X;
 Mon, 16 May 2022 16:54:22 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220516165422eusmtrp2535ec901b9fcfc699f53e88d7145bca3~vpCQKB3a51030710307eusmtrp2r;
 Mon, 16 May 2022 16:54:22 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-45-628281bf30ff
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 9C.00.09404.EB182826; Mon, 16
 May 2022 17:54:22 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165422eusmtip15250a2577700f87549716a5010c26ef5~vpCP3mI__2390423904eusmtip1u;
 Mon, 16 May 2022 16:54:22 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:06 +0200
Message-Id: <20220516165416.171196-4-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djP87r7G5uSDKbckLRYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjuKySUnNySxLLdK3S+DK2LpgClPBFrGKj7cOsDQwrhXqYuTk
 kBAwkXj05BhbFyMXh5DACkaJH00vWCCcL4wSSze3MUM4nxklDt/tYodpOXQOJrGcUeLJ9i5G
 COc5o8Tytf+B+jk42AS0JBo7wRpEBLIkpp14CFbDLLCYSWLlnslgNcICURJXNjmA1LAIqEo8
 +7KQFcTmFbCS+LyxlxVimbzEzEvf2UHKOQWsJVZ3cUOUCEqcnPmEBcRmBipp3job7B4Jgfmc
 EjPffGWG6HWR6DsBM0dY4tXxLVAPyEj83zmfCcKulnh64zdUcwujRP/O9WwgyySAlvWdyQEx
 mQU0Jdbv0ocod5S4uWQ2VAWfxI23ghAn8ElM2jadGSLMK9HRBg1cJYmdP59ALZWQuNw0hwXC
 9pC4cX4V0wRGxVlInpmF5JlZCHsXMDKvYhRPLS3OTU8tNsxLLdcrTswtLs1L10vOz93ECEx2
 p/8d/7SDce6rj3qHGJk4GA8xSnAwK4nwGlQ0JAnxpiRWVqUW5ccXleakFh9ilOZgURLnTc7c
 kCgkkJ5YkpqdmlqQWgSTZeLglGpgmuSs6+WTvTBt5Tan/oTrV9zFzfWfiBodeq/he5yjmzHn
 3oum2a98jxQm/2Z3OKjZ53ozYoltu8e3o7Ea05ccNXALvztH9drG9LfZdgmnjRVqj9V0N7/R
 Dsye1ndhbWBH8J7bYde3WL/3zdPMjvj7b0dta4p5/yW++dzavZVndu8LeJZ6ynqbXSD/78ln
 M/47POYs0JiTWqehZ5X/PSZ0kzLn18XyVpzfFbk9Lli86nuS8uS03LmoB29PKEsfeLynmyF1
 wtPf1cUyW4PlBYX33d3Vb9JcKrGEZ2sf+89JM2sUVql4/Z/6O3mFT8mxvHMn/sWu+6DL+T3d
 s/R4ldWW3U0P47POr385g33KgQu6SizFGYmGWsxFxYkAHlO3teUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t/xu7r7GpuSDE4uNrNYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9Zbe4
 MeEpo8XnpS3sFmtuPmVx4Pf4d2INm8fOWXfZPS6fLfXYtKqTzWPzknqP3TcbgMKt91k93u+7
 yubRt2UVo8f6LVdZPD5vkgvgjtKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV
 0rezSUnNySxLLdK3S9DL2LpgClPBFrGKj7cOsDQwrhXqYuTkkBAwkTh0ro25i5GLQ0hgKaPE
 rU1P2SESEhK3FzYxQtjCEn+udbFBFD1llGg5fBkowcHBJqAl0dgJVi8iUCAxp38LC0gNs8Ba
 JonXP96DNQsLREhcfL6AGcRmEVCVePZlISuIzStgJfF5Yy8rxAJ5iZmXvrODzOQUsJZY3cUN
 EhYCKvn65BY7RLmgxMmZT1hAbGag8uats5knMArMQpKahSS1gJFpFaNIamlxbnpusZFecWJu
 cWleul5yfu4mRmBkbjv2c8sOxpWvPuodYmTiYDzEKMHBrCTCa1DRkCTEm5JYWZValB9fVJqT
 WnyI0RTo7InMUqLJ+cDUkFcSb2hmYGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fE
 wSnVwJTtXWfCzMs3t5YrfM+9w/OKrcv3FO1V59/Sb6jNqWZquEXvqunu1BANBrf32ZNnSc58
 2ir+pox31e2OH6/8itJvXeiZsNLpwLvdO74xp5xZnN1Sa/nBrzyZbffZLTfjArW3svwsWNjT
 9tH+w8zTrAu6bnDPvfxgavqvxOBpF6e/jgt4M+WWuIvYb58dMma3Ckt4Pt7Z7WL+jPUyT9fv
 sy8eiN/dcPfV1/7l1+V9bsydIPTGN+RwX2PDsWYp7nVVCcf3srf8iBLZtPmZ5Kqqx2lbVrDN
 v3nSQs7vmuEMPgWOvqRjFUWilwOP77GUvLo9lXdO+eGVntIfXV5kFfqesBWb6J05vWurUtXr
 3rAPrPxKLMUZiYZazEXFiQCIvkauVQMAAA==
X-CMS-MailID: 20220516165422eucas1p174acec28848a9c2178376f092af3fa1c
X-Msg-Generator: CA
X-RootMTR: 20220516165422eucas1p174acec28848a9c2178376f092af3fa1c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165422eucas1p174acec28848a9c2178376f092af3fa1c
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165422eucas1p174acec28848a9c2178376f092af3fa1c@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Cc: p.raghav@samsung.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
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

