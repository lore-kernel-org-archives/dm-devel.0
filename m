Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E3FC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:20:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-xZoE4Sp3NNaEEI_NEMq-8w-1; Wed, 15 Jun 2022 06:20:01 -0400
X-MC-Unique: xZoE4Sp3NNaEEI_NEMq-8w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF9F0299E77E;
	Wed, 15 Jun 2022 10:19:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D450401E68;
	Wed, 15 Jun 2022 10:19:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 122BC195D4D1;
	Wed, 15 Jun 2022 10:19:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ABB75194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:19:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9105D1415107; Wed, 15 Jun 2022 10:19:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB5D1415106
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 767E718A6524
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:56 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-kNCPiRjDMUqHqDJKQ4T7_w-1; Wed, 15 Jun 2022 06:19:54 -0400
X-MC-Unique: kNCPiRjDMUqHqDJKQ4T7_w-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101953euoutp01ed50f2f4dff269e8ef66c51ef2328c0c~4xAYq4Cmc2526325263euoutp01k
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220615101953euoutp01ed50f2f4dff269e8ef66c51ef2328c0c~4xAYq4Cmc2526325263euoutp01k
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220615101951eucas1p18d84bd7b38d6657a6c512bd382ceedf6~4xAW0wNp51438314383eucas1p1I;
 Wed, 15 Jun 2022 10:19:51 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 39.77.10067.742B9A26; Wed, 15
 Jun 2022 11:19:51 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220615101951eucas1p238eb45e563bd9645af81bf16c56d98ec~4xAWbmb-F2114221142eucas1p2b;
 Wed, 15 Jun 2022 10:19:51 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101951eusmtrp2c759d4ee173fff60b6c81fb090bf1131~4xAWarPxE0361403614eusmtrp2l;
 Wed, 15 Jun 2022 10:19:51 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-9e-62a9b247678f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 07.24.09038.742B9A26; Wed, 15
 Jun 2022 11:19:51 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101950eusmtip1b23a4a7a289c85a785fe400b913c2e54~4xAVmPX1i1152711527eusmtip1J;
 Wed, 15 Jun 2022 10:19:50 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:15 +0200
Message-Id: <20220615101920.329421-9-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7djP87rum1YmGdyfpG+x+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 AvijuGxSUnMyy1KL9O0SuDJ+3znDVvCLu6Jj3mGmBsY3nF2MnBwSAiYSE9vfsIPYQgIrGCW2
 bLTrYuQCsr8wSvTs3MgKkfjMKPHsQx1Mw8PDS5ghipYzSjS8Pc4K4bxklLi0Yx1TFyMHB5uA
 lkRjJ9hUEYFwiaN77jGB1DAL9DFLbD3XBzZVWCBYYv/BfUwgNouAqsTfvqMsIDavgJXE8Y6D
 bBDb5CVmXvoONohTwFpix+weVogaQYmTM5+A1TMD1TRvnQ12kYTAOU6J3v1PmSCaXSS6Jr+G
 soUlXh3fwg5hy0j83zkfKl4t8fTGb6jmFkaJ/p3r2UA+kADa1ncmB8RkFtCUWL9LH6LcUeLd
 gqnsEBV8EjfeCkKcwCcxadt0Zogwr0RHmxBEtZLEzp9PoJZKSFxumsMCYXtIXP86gWkCo+Is
 JM/MQvLMLIS9CxiZVzGKp5YW56anFhvlpZbrFSfmFpfmpesl5+duYgQmztP/jn/Zwbj81Ue9
 Q4xMHIyHGCU4mJVEeM2CVyYJ8aYkVlalFuXHF5XmpBYfYpTmYFES503O3JAoJJCeWJKanZpa
 kFoEk2Xi4JRqYGp4NPuC2qbV1R0qS5ftOxipW13ON0tPLFchdeGhXOFZPfmfLiVdXZqnE1IX
 sUtKoa+/iVs8cm3HCdfzZ53TGzhdH/ldu2CXFHb1ad3mmVIO4pGrrLIKv75OEOhTrTG2Y3bR
 abL3qhVfGf37a+bfGPuzbl1yS2amXneOt/56lOXstY6zX1ds+1B/98zRYp+GuurNUz8YfHC4
 qLnO4I7Y/oMei8V+Ka3rSr7696CL444437KXN3Tkt03K+uW7T6uuYDmPsZ6g4UwZ+Z1P/Y9H
 PhQN1Yzefepu/KuJyewFz+fMF10zOdXfY5noo8aaRWUdXOH82/mn7WwOiNv0ZMnza3JLNvZU
 p2x+PfGT6fGPLEosxRmJhlrMRcWJAP1zcsMLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xu7rum1YmGXz5KWyx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 Avij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJ+
 3znDVvCLu6Jj3mGmBsY3nF2MnBwSAiYSDw8vYe5i5OIQEljKKLEB6CqIhITE7YVNjBC2sMSf
 a11sEEXPGSUaT+0DSnBwsAloSTR2gtWLCERLdN58D1bDLLCAWeL57VlsIAlhgUCJZccbmUBs
 FgFVib99R1lAbF4BK4njHQfZIBbIS8y89B1sEKeAtcSO2T2sIPOFgGp2vYuHKBeUODnzCVgr
 M1B589bZzBMYBWYhSc1CklrAyLSKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMMq3Hfu5ZQfj
 ylcf9Q4xMnEwHmKU4GBWEuE1C16ZJMSbklhZlVqUH19UmpNafIjRFOjsicxSosn5wDSTVxJv
 aGZgamhiZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXAVGqfM/9J7trGTYu3n9tg
 4f+6KSlr6sv5XMxR4TEBV8I/7rsd7JjDtLRgWejBXSq/Yg8ucnnRobpMQmLKu7+l8w4sdJ5e
 n8f+4FAJx0PWK3Z8z3gZsgMfSAh8i/HQWWHlZP/n3IatOxkaljuevx8hevV6r6pM/7bYL4+f
 XWO0On3zzhMpv8Dj/J2lDRPLrV48XfZ+l131eaZHtncMtDR0BGf69/9MVEq8zXRhzi4HR9tl
 uvb8L/QX3PeQOxcX4TXpQFrRw5kHIhfUbVCLWre/p64y6xDPxAI92YwA9VqRVy9Vf7von9cL
 CGo44dS10dFQ0fvkjzXRh4KdJ2gE2554ryL78Ohj7jufGreXXkhtU2Ipzkg01GIuKk4EAHwS
 U/N7AwAA
X-CMS-MailID: 20220615101951eucas1p238eb45e563bd9645af81bf16c56d98ec
X-Msg-Generator: CA
X-RootMTR: 20220615101951eucas1p238eb45e563bd9645af81bf16c56d98ec
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101951eucas1p238eb45e563bd9645af81bf16c56d98ec
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101951eucas1p238eb45e563bd9645af81bf16c56d98ec@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v7 08/13] dm-zoned: ensure only power of 2 zone
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
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org,
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

From: Luis Chamberlain <mcgrof@kernel.org>

Today dm-zoned relies on the assumption that you have a zone size
with a power of 2. Even though the block layer today enforces this
requirement, these devices do exist and so provide a stop-gap measure
to ensure these devices cannot be used by mistake

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zoned-target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 0ec5d8b9b..ad4228db5 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -792,6 +792,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 				return -EINVAL;
 			}
 			zone_nr_sectors = blk_queue_zone_sectors(q);
+			if (!is_power_of_2(zone_nr_sectors)) {
+				ti->error = "Zone size not power of 2";
+				return -EINVAL;
+			}
 			zoned_dev->zone_nr_sectors = zone_nr_sectors;
 			zoned_dev->nr_zones =
 				blkdev_nr_zones(zoned_dev->bdev->bd_disk);
@@ -806,6 +810,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 		q = bdev_get_queue(zoned_dev->bdev);
 		zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
 		zoned_dev->nr_zones = blkdev_nr_zones(zoned_dev->bdev->bd_disk);
+		if (!is_power_of_2(zoned_dev->zone_nr_sectors)) {
+			ti->error = "Zone size not power of 2";
+			return -EINVAL;
+		}
 	}
 
 	if (reg_dev) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

