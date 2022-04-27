Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BE1C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-dyoQIL7_P1WhG3kFEx3SAQ-1; Fri, 29 Apr 2022 04:23:54 -0400
X-MC-Unique: dyoQIL7_P1WhG3kFEx3SAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D56FB80418D;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BFB1D1468949;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 12F51194706E;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 11FB91947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6C35698CE3; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F7A57F027
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9C4C802819
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-nVepg40QMC6A8dzxP0b_XA-1; Wed, 27 Apr 2022 12:11:48 -0400
X-MC-Unique: nVepg40QMC6A8dzxP0b_XA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160310euoutp0277b05ef6a694e9c12ca2b8d9e064378d~pzFHMcIim1442014420euoutp02v
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160310euoutp0277b05ef6a694e9c12ca2b8d9e064378d~pzFHMcIim1442014420euoutp02v
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160308eucas1p29e66b3685c84483f3fdd5a90299d93e1~pzFFvrXVn2333623336eucas1p2p;
 Wed, 27 Apr 2022 16:03:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 8C.0A.10260.C3969626; Wed, 27
 Apr 2022 17:03:08 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220427160307eucas1p229f9ebae38fcca9974909799e5e63ccf~pzFFKDoBX2335623356eucas1p2h;
 Wed, 27 Apr 2022 16:03:07 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427160307eusmtrp194cac78e29ca037961137d3a49caf9ec~pzFFDipZN2142221422eusmtrp1D;
 Wed, 27 Apr 2022 16:03:07 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-96-6269693c7e10
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 85.A7.09404.B3969626; Wed, 27
 Apr 2022 17:03:07 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160307eusmtip1fe2208eed35a4c2cc164aecccf9c648a~pzFEt7JbD1109611096eusmtip1x;
 Wed, 27 Apr 2022 16:03:07 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:50 +0200
Message-Id: <20220427160255.300418-12-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTZxzNd+/t7S2z7lpd+CLdiFWmuPAQMPvG2MIWs924p7pMMNmwwOWR
 8XAt4BAX64oOOnlVUB5uQh2TAqGUh1lBSIMCMoa6YkeBDOKEqSCt8kjpEFjLrZn/nXN+5/zO
 70s+ChfpyM1UYkoaK0uRJklID+JKj+OmX1hiYnTgco8Y6X7rwVHdXwUkOvfYgaP+kgEMqQtK
 +Whp4BaOOqwVPHR78SSGho0GDGnrujE0oSvH0RnjYwItq8acWvZdHD29uwupu/4EaNJcjqGO
 kdeQ6V4NH5k076OrHX0EGmy7QKKLv0zyUeHpBRxZCicBKupt5qG56mw+api2EejGiFf4y8zg
 nQ+YlRv1JFOktPKZW2N6ghkcSGeaanNJpkpRgjPNP59g2ivnMKZ9WEEyeUoryRhOjfMYW6eZ
 ZPJbagGjazETTGGznvep6JBHWCyblJjBygLePuyRYCrOx44o1n2z0mTnK8CiQAUEFKRDoL7K
 gauAByWiawA8t7xKcmQeQIW2wk3mALxe14E9i1y71OqOXAawbLERcOQhgPfGTM4JRZH0Tngy
 l+/SN9EWAIsaGzEXwekpHN5uGVpbtZE+CPWLVuDCBO0D8+by1rCQfhPa74zyuTpvWGay811L
 BU69cDaCs2yAfWUThAvjTouytWLtIkhrPeC4qRhw2T2wumUC5/BGONXb4t4phv1nzxAczoKT
 liV3OBvAAoOOdJVBZ1n+70kuiNO+UNcWwNnfgdctBh7nWA8tMxu4E9ZD9ZXzOCcLYc5pEeeW
 QINjwl0K4eB3FwjOwkDD0t5CsKX8ubeUP/eW8v9rKwFeCzzZdHlyPCsPTmGP+sulyfL0lHj/
 mNTkJuD80/0rvQu/gpqpJ/5dAKNAF4AULtkknG9PiBYJY6WZx1hZapQsPYmVdwEvipB4CmMS
 G6UiOl6axn7FskdY2bMpRgk2KzCv+jJhZEZw67qg6QXpt5KPM7UfhVrT7seZc5JrreNBr74e
 fvT+zIcvafy2WEvtQ/b34vzSA//VBBmK2zQp+n1ZMDNb3aAmJjSVA7v3BeERxqhHxu/HRsOE
 OT7nfecv7pU0PEwVp379hWm1x3dZXLzDR6na+lnuZcGxEDgjLXG88GPp8LveMUPH/zn1R3DA
 tC33wbYn9It/q2pWFw490n651bPEM8RBNYyHrUZHHoyIN1bVd0YFbCsw6iWx1uN9/vu1scod
 b72SaQsIDzzw9CfJgZVr3bPb94d2x3lGPnjDODLsvWeWarQczhAPh3p1niB++Byxtu2726tH
 L+mzrn5iKr1plhDyBOmunbhMLv0P+DRJV0IEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xu7rWmZlJBlem61isP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehmXpvQxFTTwVPzb9J29gfEHZxcjJ4eEgInE4cVbmbsYuTiEBJYySvQ/WcAKkZCQuL2w
 iRHCFpb4c62LDcQWEnjOKDHhtGQXIwcHm4CWRGMnO0iviMATRon7Px+zgDjMAg0sErcm7mIC
 aRAWCJWY1NLMDmKzCKhK9H7uBRvKK2At8f3KbXaIBfISMy99ZwcZygkUn/ApAmKXlUT3olus
 EOWCEidnPmEBsZmBypu3zmaewCgwC0lqFpLUAkamVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmb
 GIEJZduxn1t2MK589VHvECMTB+MhRgkOZiUR3i+7M5KEeFMSK6tSi/Lji0pzUosPMZoCnT2R
 WUo0OR+Y0vJK4g3NDEwNTcwsDUwtzYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpjmrbjk
 9E73Oa/J+if9fbyVPcrR819umO4l9WfiedHM9K3yc/6Gbyg62Tsx7MYf/zfPimqaavWu+PZK
 MFqoGGlO1k35krMgp0nx9Pnrk9v+V+5Oj9WaYmo1f90kBvnlXxa+kvf/lb3Zf/fVXQn9s8vy
 mlri9jQ9lBUtLUw71Ht/Pu/8Sx8y+xa/z3qlkhm3PE9bSebp4+RTjpGcG7Rv817UnFhZHV72
 4sg0++ZHk1j8eddUrNkx64SjxfM/27/d+Mxw52zurrkCx825z/sceibeyelzr+vJC48DMxy0
 3zutXD6Fa2E1z7w1r6a1PD37+/TBpn/VXgebj/CvDIt2udqfe01MzXFXetXfVRx1z3r8lViK
 MxINtZiLihMBMHgdG7EDAAA=
X-CMS-MailID: 20220427160307eucas1p229f9ebae38fcca9974909799e5e63ccf
X-Msg-Generator: CA
X-RootMTR: 20220427160307eucas1p229f9ebae38fcca9974909799e5e63ccf
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160307eucas1p229f9ebae38fcca9974909799e5e63ccf
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160307eucas1p229f9ebae38fcca9974909799e5e63ccf@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 11/16] btrfs: zoned: relax the alignment
 constraint for zoned devices
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
Cc: jiangbo.365@bytedance.com, Pankaj Raghav <p.raghav@samsung.com>,
 kch@nvidia.com, bvanassche@acm.org, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Checks were in place to return error when a non power-of-2 zoned devices
is detected. Remove those checks as non power-of-2 zoned devices are
now supported.

Relax the zone size constraint to align with the BTRFS_STRIPE_LEN(64k)
so that block groups are aligned to the BTRFS_STRIPE_LEN.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/btrfs/zoned.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 8f3f542e174c..3ed085762f14 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -395,8 +395,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		zone_sectors = bdev_zone_sectors(bdev);
 	}
 
-	/* Check if it's power of 2 (see is_power_of_2) */
-	ASSERT(zone_sectors != 0 && (zone_sectors & (zone_sectors - 1)) == 0);
+	ASSERT(zone_sectors != 0 && IS_ALIGNED(zone_sectors, BTRFS_STRIPE_LEN));
 	zone_info->zone_size = zone_sectors << SECTOR_SHIFT;
 
 	/* We reject devices with a zone size larger than 8GB */
@@ -835,9 +834,11 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 
 	ASSERT(rw == READ || rw == WRITE);
 
-	if (!is_power_of_2(bdev_zone_sectors(bdev)))
-		return -EINVAL;
 	nr_sectors = bdev_nr_sectors(bdev);
+
+	if (!IS_ALIGNED(nr_sectors, BTRFS_STRIPE_LEN))
+		return -EINVAL;
+
 	nr_zones = bdev_zone_no(bdev, nr_sectors);
 
 	sb_zone = sb_zone_number(bdev, mirror);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

