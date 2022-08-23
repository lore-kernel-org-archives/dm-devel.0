Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE36C32772
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257161;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zXRrEw/xlHg2yUiXbIexExSGCcFDmib8c/Sx4wzdX+4=;
	b=RQI/iKcxPhSohrYtXr3SHCasiFlFPf+Nk/tgjpDdGWIOQpg4U++Um8pacuZUFlx9cnjVeu
	Juq7bNorShUNlQYEGTyfEd8HyewQF+G+pcVdYR3u9y78LZ4ApbHa9fHpZtZ+SjANBMZQYV
	DGFZWUHMhc9oLNZS2nSN+n6umP5vNOY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-TpJmYFdbOIuM8_0rOWjANw-1; Tue, 23 Aug 2022 08:19:20 -0400
X-MC-Unique: TpJmYFdbOIuM8_0rOWjANw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A75680252E;
	Tue, 23 Aug 2022 12:19:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7D93C15BBA;
	Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C4ECF1946A47;
	Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00DC31946A47
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E89B9C15BBD; Tue, 23 Aug 2022 12:19:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4607C15BB3
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCFEE29DD998
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:15 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-hXy6C_XYNhO3tnWwgxQzqQ-1; Tue, 23 Aug 2022 08:19:14 -0400
X-MC-Unique: hXy6C_XYNhO3tnWwgxQzqQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121913euoutp011551627ebd8f99ad4a7bd84b00ecaaa5~N_JRBcyyN1942519425euoutp01e
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220823121913euoutp011551627ebd8f99ad4a7bd84b00ecaaa5~N_JRBcyyN1942519425euoutp01e
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121910eucas1p206e6e5c5cbb03ac40a9e7b55978a31a9~N_JOrpiCL1807618076eucas1p2G;
 Tue, 23 Aug 2022 12:19:10 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id DE.82.29727.EB5C4036; Tue, 23
 Aug 2022 13:19:10 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220823121909eucas1p113c0c29f7e28d0ee3e1161f7da243baf~N_JN-u-W01882018820eucas1p1U;
 Tue, 23 Aug 2022 12:19:09 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220823121909eusmtrp150c510413ffc810768faee3cc512696f~N_JN_6pIf1042010420eusmtrp1H;
 Tue, 23 Aug 2022 12:19:09 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-8f-6304c5bede52
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id D5.81.10862.DB5C4036; Tue, 23
 Aug 2022 13:19:09 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121909eusmtip100fdaff39bbf167292206c172f54e8a0~N_JNsdKjr0901809018eusmtip1I;
 Tue, 23 Aug 2022 12:19:09 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:54 +0200
Message-Id: <20220823121859.163903-9-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djP87r7jrIkG9w5qGSx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK2Ne
 u0TBPJ6KOQ1fWRoYW7i6GDk5JARMJBpu7GDrYuTiEBJYwSjx+cAvVgjnC6PE5RcP2CGcz4wS
 FxYfYYRpWbHqHSNEYjmjRNeu5cwQzgtGidbO60AOBwebgJZEYyc7SIOIQLrE168bwBqYBe4w
 Sfzcs5AFJCEsECKx8v8dNhCbRUBV4s/26WAbeAWsJD5u7GeC2CYvMfPSd7BBnALWEvOWnoKq
 EZQ4OfMJ2BxmoJrmrbPBjpAQ2M4p8XLfZDaIZheJ3msfoWxhiVfHt7BD2DISpyf3sEDY1RJP
 b/yGam5hlOjfuZ4N5AMJoG19Z3JATGYBTYn1u/Qhyh0l3q86xAJRwSdx460gxAl8EpO2TWeG
 CPNKdLQJQVQrSez8+QRqqYTE5aY5UEs9JFbMfc46gVFxFpJnZiF5ZhbC3gWMzKsYxVNLi3PT
 U4sN81LL9YoTc4tL89L1kvNzNzECE+Lpf8c/7WCc++qj3iFGJg7GQ4wSHMxKIrzVFxmShXhT
 EiurUovy44tKc1KLDzFKc7AoifMmZ25IFBJITyxJzU5NLUgtgskycXBKNTAlXnLYzcA+W8E1
 4evBDaxMSrv2PAsUeZxZ8fvL3yfGIRc6k1WLZfYsd+WcrD+hco335qrf5c+3Cycvr6xo0/hh
 tWXPlE+F4fMys1+YTxPuFO9TPDu1SPR4RzDDKUfDFI/MWfIVGanvqyomSArV2vZYVQssOLH7
 1xbFxtvcOav8laPezaw/E/fyu7MN/wrmqWpbX3x3U40yKuxYPfcgv0nAxol33I5/v2Lctzxk
 yskkCTHXIGuda1w3ZGS5k/51dXfuLv90utlga8HHH/mnIz8rzmareM3+RPtkzP8HGx6yHXc3
 enzX1jM5Z/cHkzdWnFuOpxkVP+50uGUXqRujzmls81RI48fSGmHr67yrDiixFGckGmoxFxUn
 AgCYPxRE9wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7p7j7IkGzz/a2ax/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina
 0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2Neu0TBPJ6KOQ1fWRoYW7i6GDk5
 JARMJFasesfYxcjFISSwlFHi2+UPrBAJCYnbC5sYIWxhiT/Xutggip4xStx6uZK5i5GDg01A
 S6Kxkx2kRkQgV+Lw5glMIDXMAm+YJC5PP8cCkhAWCJJoufMUbCiLgKrEn+3TwYbyClhJfNzY
 zwSxQF5i5qXvYIM4Bawl5i09BVYjBFQz/9YnNoh6QYmTM5+AzWQGqm/eOpt5AqPALCSpWUhS
 CxiZVjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgTG7rZjP7fsYFz56qPeIUYmDsZDjBIczEoi
 vNUXGZKFeFMSK6tSi/Lji0pzUosPMZoC3T2RWUo0OR+YPPJK4g3NDEwNTcwsDUwtzYyVxHk9
 CzoShQTSE0tSs1NTC1KLYPqYODilGpiE5fziTq3lK96pmJv7QO//uS8JS4+ked890X65eaXO
 H7Pr6z4sMZJvzlJdO9fN+xDHleIujuaT2qE6Zw+7H91bE7T93tJfpY/mXDoV9rHw77xdut95
 HE4fjrBv+/z96ybp1rW6q/wOfGo9H5rcvOt8hczb/Jm2B8+ZMU+X1Ur3fBbCEx0+9waj3eNc
 sS/G0+cpTDH+czBo9+bVP8WKD3BFrJgmuHej8JOyuXOfzHOtXbe9b8Fuffd/ntfO6SeFtvJE
 lDPf3H9f8q4du7PCnuqQ7dbV0Q6b5C29TlpfMWVIkou+5HAxtlNj3vuO1Y0zdtbUhJyp43zj
 4dF7bdfEhlJxt45ZW34WX3785frnV5x6SizFGYmGWsxFxYkA7sABNWYDAAA=
X-CMS-MailID: 20220823121909eucas1p113c0c29f7e28d0ee3e1161f7da243baf
X-Msg-Generator: CA
X-RootMTR: 20220823121909eucas1p113c0c29f7e28d0ee3e1161f7da243baf
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121909eucas1p113c0c29f7e28d0ee3e1161f7da243baf
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121909eucas1p113c0c29f7e28d0ee3e1161f7da243baf@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v12 08/13] dm-zoned: ensure only power of 2 zone
 sizes are allowed
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
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

dm-zoned relies on the assumption that the zone size is a
power-of-2(po2) and the zone capacity is same as the zone size.

Ensure only po2 devices can be used as dm-zoned target until a native
support for zoned devices with non-po2 zone size is added.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zoned-target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 95b132b52f33..9325bf5dee81 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -792,6 +792,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 				return -EINVAL;
 			}
 			zone_nr_sectors = bdev_zone_sectors(bdev);
+			if (!is_power_of_2(zone_nr_sectors)) {
+				ti->error = "Zone size is not a power-of-2 number of sectors";
+				return -EINVAL;
+			}
 			zoned_dev->zone_nr_sectors = zone_nr_sectors;
 			zoned_dev->nr_zones = bdev_nr_zones(bdev);
 		}
@@ -804,6 +808,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 			return -EINVAL;
 		}
 		zoned_dev->zone_nr_sectors = bdev_zone_sectors(bdev);
+		if (!is_power_of_2(zoned_dev->zone_nr_sectors)) {
+			ti->error = "Zone size is not a power-of-2 number of sectors";
+			return -EINVAL;
+		}
 		zoned_dev->nr_zones = bdev_nr_zones(bdev);
 	}
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

