Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47C8C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-e0DKlTfGNTenaC8O5yyEZA-1; Fri, 29 Apr 2022 04:23:45 -0400
X-MC-Unique: e0DKlTfGNTenaC8O5yyEZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7994383396B;
	Fri, 29 Apr 2022 08:23:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDF751468946;
	Fri, 29 Apr 2022 08:23:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3D6E194705E;
	Fri, 29 Apr 2022 08:23:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 736D21947042
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B5BD416146; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4759A463E02
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1799D1E10B41
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:50 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-kkZNumMPNseV_iK10cvnhQ-1; Wed, 27 Apr 2022 12:11:48 -0400
X-MC-Unique: kkZNumMPNseV_iK10cvnhQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160304euoutp0232d52607625c8a40d4eedd0b507054da~pzFCYiQbB1442014420euoutp02l
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160304euoutp0232d52607625c8a40d4eedd0b507054da~pzFCYiQbB1442014420euoutp02l
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160303eucas1p22d7897065d614fc598a2b9280bec4adb~pzFA9zWA62335623356eucas1p2b;
 Wed, 27 Apr 2022 16:03:03 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id BE.04.09887.73969626; Wed, 27
 Apr 2022 17:03:03 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035~pzFAbPWo12290322903eucas1p1u;
 Wed, 27 Apr 2022 16:03:02 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427160302eusmtrp1f372a17275b8fcf9c53a511412b0283f~pzFAYod592077420774eusmtrp1N;
 Wed, 27 Apr 2022 16:03:02 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-52-62696937cddc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id FF.97.09404.63969626; Wed, 27
 Apr 2022 17:03:02 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160302eusmtip1f317e24df26397b4f560f917fa75f11b~pzE-yyoKH1317113171eusmtip1K;
 Wed, 27 Apr 2022 16:03:02 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:45 +0200
Message-Id: <20220427160255.300418-7-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG8957e++lse5aNL4ggqCOAYEicdkrELdlEu9gcctwUfZpwRs+
 VkBbO9Ftsa7gpGNQMEwoLIJRUWBrKYxYGIThBsi3LSiosCDgBoSP8RGtBbaWWzP/e857fs95
 zkleGhfrSXc6MeUEJ0+RynxIIVHbYu0OfC0xMTa41/oS0re34KhiKIdEP8xZcdSR34WhvJwC
 Ctm6enDUMFMkQL1Pz2JosMmEoRsVf2BoTK/DUVbTHIFWNMP2t/QRHC2P7EJ5zXcBGu/XYajh
 fgAyj16nkPnyfvRrw20CWeqKSXTp2jiFtOeWcDSgHQcot7VagBauplPo56lZArXd3/LGVtbS
 F8WutlWSbK56hmJ7hqsI1tKlZI3lmSRbqsrH2eorZ9j6kgWMrR9Ukez36hmSNWX8KWBnG/tJ
 NrumHLD6mn6C1VZXCd4TfygMP8rJEr/g5JK9R4QJl8ZM1LFiOq0yI5NUARupAS40ZHbDO+kq
 uxbSYuY6gBUXdRhfLAL4WDtI8MUCgI3TT6nnltlvuym+UQZgW2u70zIBYNXiit1C0yTjD89m
 rkEbmQEAcw2GNQhnJnHYW3MPc0CuzKvQNrO2CMHshHezJ9a0iAmF+cN9GJ/mBQvNTygH7sKE
 Qe38YR7ZAG8XjhEOjdsR9S9FuGM8ZEqFsOHhHMF798GyrHnnHFc42VrjvMADdlzIcjJfwvEB
 m9OcDmCOSU86wqA9LLtT5pA44wf1dRIefxOODg1SPLEeDkxv4FdYD/NqL+L8swiePyfmaR9o
 so45QyG0fFPsDGXhQ1WOQAu8dS8co3vhGN3/uSUALwebOaUiOZ5ThKRwJ4MU0mSFMiU+KC41
 2Qjsf7pjtXXxJiib/CeoGWA0aAaQxn02ihbrE2LFoqPSU6c5eepncqWMUzSDLTThs1kUl2iQ
 ipl46Qnuc447xsmfdzHaxV2Fue0JGJQ13vs0eMErwO+rv7btuRMLr1nKNTcvj3fvNPjH7JcV
 dgeGJQ8HmoPOeMqXzieByoQ4o6DFoJwvNP40uju1QB+y0vSx5HUqu/PZg+WlA+rOhbBbEW+F
 3tj+7pA86hNPy6Nsv01tIZFWLCJmWHPLl/rtkSxq68TB6HdqbYcKopO26S70276rOX4k48mV
 kAduriXiuj7NjhGz6Gt1e2jZKz1Tecf3hhcdupr2QcWq+rEElnoZrPrl00knwzXaj9xH+jzo
 TcF4RJWJ63t5ynfaFvdj3r44BeaZFfl3jHdv5Ns09HZzK3p20P33desOs5I039yq9xNc/92O
 KU8Z46NVHj6EIkG6yx+XK6T/AbMmFzlCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xu7pmmZlJBufeqFmsP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehnzn+xkL5jDUbGmtZOtgfE3WxcjJ4eEgInE+/Zz7F2MXBxCAksZJQ7dWsUOkZCQuL2w
 iRHCFpb4c62LDaLoOaPEtilzgBwODjYBLYnGTrBmEYEnjBL3fz5mAXGYBRpYJG5N3MUEUiQs
 YCrx+x3YNhYBVYlrfS/BbF4BK4mp964wQSyQl5h56Ts7SDmngLXEhE8RIGEhoJLuRbdYIcoF
 JU7OfMICYjMDlTdvnc08gVFgFpLULCSpBYxMqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQIT
 yrZjP7fsYFz56qPeIUYmDsZDjBIczEoivF92ZyQJ8aYkVlalFuXHF5XmpBYfYjQFOnsis5Ro
 cj4wpeWVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTBpzluoMtPG
 K3C1+c/PW6x+Rh5axbDhjLXQ1hzr5EN5l7WfRYu01XJO3u96W8Djr0Ixq6SQw6KXRu4sc15d
 Epx8WqbMgrnbMolX0OeAo1XJ7s95hcyTNl8IWJcsZtXfw1r+m2PzB4lzd2ev7WcK5jGI19nT
 xf1L+upsh3u2QlwT0uTO6/xcxJb/aYp0zxKp1W+fsLFPv7HzWvxjvX5zro85MWdVb+o1vXOt
 f9Kd/H3dElNB4cyy/WGy+hKfllx5NT0on0FWjFX+V6+Ewl+jI7NqjavYJ3VNXJyUadFqZqDs
 sXPKBsmt988Ur1ip9Fdo9RU7+16Gi61C0wrvBv5anWXTt9+17ZyIitD6L0zvSpVYijMSDbWY
 i4oTAU7HChCxAwAA
X-CMS-MailID: 20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035
X-Msg-Generator: CA
X-RootMTR: 20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160302eucas1p1aaba7a309778d3440c3315ad899e4035@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 06/16] nvmet: use blk_queue_zone_no()
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

From: Luis Chamberlain <mcgrof@kernel.org>

Instead of open coding the number of zones given a sector, use the helper
blk_queue_zone_no(). This let's us make modifications to the math if
needed in one place and adds now support for npo2 zone devices.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index e34718b09550..e41b6a6ef048 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -243,7 +243,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
 	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	       bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

