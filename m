Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4ABBC19F2C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yT3dmacz2EKSkOdLkqrGdjDeENqxcYkAsl92+ZIljOs=;
	b=eKtdYXzeQtopDcjmMNRRn47YJQVsGGpXMKNbIMxvIWtid3CDaapDc/qkna5Jhk1kb5rjIs
	FCScjgRrLUiQ4cy1rxkMndSJKjcTNThAE2B5N4AgA7OsTUBIycyfdok0ToEtLKCD6MUCjX
	WlWx+dxMXShn1M77cUkdpYi4nv9RVvw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-kl88HH9VM2aki3JI-1-iLw-1; Wed, 03 Aug 2022 05:48:15 -0400
X-MC-Unique: kl88HH9VM2aki3JI-1-iLw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF3A811E75;
	Wed,  3 Aug 2022 09:48:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF7972026D4C;
	Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C0E1B1946A50;
	Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E3D71946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6521D40E80E5; Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DEB940E80E0
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17E041824607
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:13 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-gFMtH__-ORy-3ehCoFWiMg-1; Wed, 03 Aug 2022 05:48:11 -0400
X-MC-Unique: gFMtH__-ORy-3ehCoFWiMg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094810euoutp0224d3ef8e38560cae397b92f3ee49e27a~HzLrPAGDB1891118911euoutp02S
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220803094810euoutp0224d3ef8e38560cae397b92f3ee49e27a~HzLrPAGDB1891118911euoutp02S
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094808eucas1p20fccdbf39db130f1fcffa078d5c3ffd0~HzLpo-yKd1615116151eucas1p21;
 Wed,  3 Aug 2022 09:48:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 2C.F2.09580.8544AE26; Wed,  3
 Aug 2022 10:48:08 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527~HzLpBPANP1078810788eucas1p1N;
 Wed,  3 Aug 2022 09:48:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220803094808eusmtrp111d241cef0397c0689130cd7d8eb2553~HzLpAXxR92000320003eusmtrp1R;
 Wed,  3 Aug 2022 09:48:08 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-14-62ea4458fe5e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 94.9B.09038.7544AE26; Wed,  3
 Aug 2022 10:48:07 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094807eusmtip2c69438db6f11c983d60b36accf56cbb4~HzLosQXnL1679416794eusmtip2n;
 Wed,  3 Aug 2022 09:48:07 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:53 +0200
Message-Id: <20220803094801.177490-6-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsWy7djPc7oRLq+SDFZu0LBYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlbF5
 /1b2gj6RiiOdk1kaGC8JdDFyckgImEjcOP6crYuRi0NIYAWjxIKDr1kgnC+MEv8m9jNDOJ8Z
 Jfa9bWOCadmybQEjRGI5o8TsVxtZIZyXjBKtmxcAtXBwsAloSTR2soPERQSaGSXu/u0BK2IW
 OMAkcXPLLbBRwgJREjvunWAGsVkEVCVOr5kCZvMKWElsvTCRHWKdvMTMS9/BbE4Ba4kp//5B
 1QhKnJz5hAXEZgaqad46G+xWCYHtnBJ3l3SzQTS7SHxZuBJqkLDEq+NboGwZidOTe1gg7GqJ
 pzd+QzW3MEr071zPBvKCBNC2vjM5ICazgKbE+l36EOWOEotnzmCFqOCTuPFWEOIEPolJ26Yz
 Q4R5JTrahCCqlSR2/nwCtVRC4nLTHKilHhKXz35lm8CoOAvJM7OQPDMLYe8CRuZVjOKppcW5
 6anFxnmp5XrFibnFpXnpesn5uZsYgUnx9L/jX3cwrnj1Ue8QIxMH4yFGCQ5mJRHeOy7Pk4R4
 UxIrq1KL8uOLSnNSiw8xSnOwKInzJmduSBQSSE8sSc1OTS1ILYLJMnFwSjUwcfXt3pd77WJt
 1Jk7hqvu9u2u6Ok/MnP+z9V3Dv+sSv+y55WR6eyH2y1Dzh7JTI/Y0rbva+gFJieWBFsbJnOR
 vqmG0x0y/kpwd5x63fRJ6MTOmIIP5cLOa411vuR91TzntpGPkbOuOP9GsvqferXUVZrCBzbs
 luGQ0Nwwvf+v+ZGWhpjz3ytdN5eqLkvb/lPlkOKp/f2PrcoyF9zfMGnNguc/lGyeKUWu2+tb
 Ll6hy9jpfo5Fa6pz8zdT+Y3TQkO2mBx84J/atfiA+99TrVfMVESzVDUnvoq+vbpA4bqNdUJU
 96dtsqzi84yO/ufS4HL5d+/gOoudx2ZsWJHofPtzuSprlIWQzawZOlcMpifeU2Ipzkg01GIu
 Kk4EABdgS875AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xe7rhLq+SDHavs7JYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7F5/1b2gj6RiiOdk1kaGC8JdDFy
 ckgImEhs2baAsYuRi0NIYCmjxKTJC1kgEhIStxc2MULYwhJ/rnWxQRQ9Z5Q43/SfqYuRg4NN
 QEuisZMdJC4i0M0ocfnMOVYQh1ngHJPEnKcP2EC6hQUiJG7u+soOYrMIqEqcXjOFGcTmFbCS
 2HphIjvEBnmJmZe+g9mcAtYSU/79A6sRAqpZ93cWK0S9oMTJmU/ArmMGqm/eOpt5AqPALCSp
 WUhSCxiZVjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgTG77ZjP7fsYFz56qPeIUYmDsZDjBIc
 zEoivHdcnicJ8aYkVlalFuXHF5XmpBYfYjQFunsis5Rocj4wgeSVxBuaGZgamphZGphamhkr
 ifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTAl+sp25f3lqDz+RSuO29Y9z3DFlsNdmnpzghR/
 F1u98So+PoH7yo6M2jKWeQK5ObMXsFZx1lYx+BeIBRQZOqvne3LM+6i6iTUtk+H5LqYIhv+z
 JV4qfeWwiNSzn3VH77SJRFTou/j0+PvPrj6SsuF8UqPwKPZ52EPnZJP0KysSPTyj8qbxXO/5
 /6kg8PYqxXO5uoFtu+UZz04Oit02zWqGd9W/+Xuj03kn3UrVmzpX9I3LSc79u/qjozhsdq8t
 WdL/me1q0epZK7Sac+/kXnr4Z47V7b8cRXNsGrw0kmZIrN6p8j6Z1WRjyvujqQbLL/ntiFjk
 PEPlkM1emaiyxvmM3s9Ld245VdHvFXjSSYmlOCPRUIu5qDgRAAllp1doAwAA
X-CMS-MailID: 20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527
X-Msg-Generator: CA
X-RootMTR: 20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094808eucas1p1a6a800161d32fe4242d39e669e5f3527@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v9 05/13] nvme: zns: Allow ZNS drives that have
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

As rounddown macro from math.h does not work for 32 bit architectures,
round down operation is open coded.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/host/zns.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 12316ab51bda..73e4ad495ae8 100644
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
 
 	disk_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
@@ -129,7 +122,7 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 				   sizeof(struct nvme_zone_descriptor);
 
 	nr_zones = min_t(unsigned int, nr_zones,
-			 get_capacity(ns->disk) >> ilog2(ns->zsze));
+			 div64_u64(get_capacity(ns->disk), ns->zsze));
 
 	bufsize = sizeof(struct nvme_zone_report) +
 		nr_zones * sizeof(struct nvme_zone_descriptor);
@@ -182,6 +175,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
+	u64 remainder = 0;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
 		return -EINVAL;
@@ -197,7 +191,11 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
 	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
 
-	sector &= ~(ns->zsze - 1);
+	/*
+	 * Round down the sector value to the nearest zone start
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

