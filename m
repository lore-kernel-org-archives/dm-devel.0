Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE9CC54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665104;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RPUjXoy/I4wmstxi8pEcNi2ISwWmXasYElj7VOoSvcs=;
	b=CrA8kr3zGGfVp7yhFQR++3Lno/7Q/3bzkOEndDWPv4ba0o99rCRa6REZP9Ik7UTsyRJiH6
	kOhob6GQ+ViAIVOW0OUHh08QOlIlgsIR7FJQV39mHXLS20Ao+4UyBlRZ6iJJExQ3UTjbk3
	JRNeqBIepzAggxk+Fk9A4rbhbH3GJW8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-2Cak3AGUM9yeZKFmjNaLfA-1; Tue, 20 Sep 2022 05:11:41 -0400
X-MC-Unique: 2Cak3AGUM9yeZKFmjNaLfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E2203825785;
	Tue, 20 Sep 2022 09:11:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D62540E80E3;
	Tue, 20 Sep 2022 09:11:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 28E2219465A3;
	Tue, 20 Sep 2022 09:11:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E53019465A3
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5171318ECC; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 47CB51759F
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27582857F8F
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-KiIfeDNpMH2MA0AtCzN2PA-1; Tue, 20 Sep 2022 05:11:33 -0400
X-MC-Unique: KiIfeDNpMH2MA0AtCzN2PA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091132euoutp02cb193c663740853850c29386cdfde8d0~WhpY94Opo2726527265euoutp02H
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220920091132euoutp02cb193c663740853850c29386cdfde8d0~WhpY94Opo2726527265euoutp02H
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091129eucas1p2c8c037d698574fc9f77d875389dd6ed5~WhpWnT_Mq1764517645eucas1p2B;
 Tue, 20 Sep 2022 09:11:29 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id BA.98.19378.1C389236; Tue, 20
 Sep 2022 10:11:29 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091128eucas1p2d9c9dcebdce4039360f92b0f577ab649~WhpV7FHQL1155311553eucas1p2H;
 Tue, 20 Sep 2022 09:11:28 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091128eusmtrp14229902d0f5956c1a621460964c32551~WhpV6JdbH0212802128eusmtrp1l;
 Tue, 20 Sep 2022 09:11:28 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-c5-632983c11bbd
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 09.53.10862.0C389236; Tue, 20
 Sep 2022 10:11:28 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091128eusmtip1ca4a4c4aeda06c94dd20fb7b9e2a2951~WhpVhcVOi1126811268eusmtip1z;
 Tue, 20 Sep 2022 09:11:28 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:14 +0200
Message-Id: <20220920091119.115879-9-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djP87oHmzWTDZ68VrVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXGh
 dSZLwX7eivU3lzM1ME7l7mLk5JAQMJHYuvo7cxcjF4eQwApGifnzLjJBOF8YJW53LWODcD4z
 Srw/vYgdpuXl9IusEInljBIH131nhHBeMkocW9AIVMXBwSagJdHYCdYgIpAu8fXrBkYQm1mg
 n1li6RVzEFtYIETi14a5YOUsAqoS0zrFQMK8AlYS95vnMEHskpeYeek72BhOAWuJObtb2CBq
 BCVOznzCAjFSXqJ562ywFyQEdnNKzH9xCqrZRWLxk7vMELawxKvjW6AekJE4PbmHBcKulnh6
 4zdUcwujRP/O9WwgB0kAbes7kwNiMgtoSqzfpQ9R7igx+/lcqAo+iRtvBSFO4JOYtG06M0SY
 V6KjTQiiWkli588nUEslJC43zYFa6iFxZv5qxgmMirOQPDMLyTOzEPYuYGRexSieWlqcm55a
 bJyXWq5XnJhbXJqXrpecn7uJEZgOT/87/nUH44pXH/UOMTJxMB5ilOBgVhLhbfHXTBbiTUms
 rEotyo8vKs1JLT7EKM3BoiTOm5y5IVFIID2xJDU7NbUgtQgmy8TBKdXAtJz/wKuFLWEHJ/5K
 6WVck7f6xNYprJN/hn29LPJ83QaBv60rmDvS7KYuDV/bHbnU6/iO99ekTHMmK3uvNZSaOy9t
 ldcb8SnbbwT4McbPL/C5zHN8asL2uNeXj3X9cRNVmrhv16E/Jb7SD76UeWxKeaV9aHbv58aT
 VcyzPt2+28r8Nl5FSins3JevUvW1hwr2bAxvzmdmFzy/i+eyYdmd/UeOtG7IFbv0Z67jioBH
 2S9+m6r6ikzuuviBz6E//pfjmkrGRZafZTRlJtxb5XfX9ca6b7wnNx5nFWZb0aL/Zcuuf15J
 V3UdGMWPztnkPslp9V5FDb2TMx6V1q7ekuUZGa4YL5w6X3pR3dwEJYUpKw4qsRRnJBpqMRcV
 JwIAQF9rlfYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7oHmjWTDZZO1LdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl3GhdSZLwX7eivU3lzM1ME7l7mLk
 5JAQMJF4Of0iaxcjF4eQwFJGiWNP9zFDJCQkbi9sYoSwhSX+XOtigyh6zihx9Mk6li5GDg42
 AS2Jxk52kBoRgVyJw5snMIHUMAvMZ5bo+LMHbJCwQJBE5+xn7CD1LAKqEtM6xUDCvAJWEveb
 5zBBzJeXmHnpO9gcTgFriTm7W9hAbCGgmo5Zm9kg6gUlTs58wgJiMwPVN2+dzTyBUWAWktQs
 JKkFjEyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAmN327GfW3Ywrnz1Ue8QIxMH4yFGCQ5m
 JRHeFn/NZCHelMTKqtSi/Pii0pzU4kOMpkBnT2SWEk3OByaPvJJ4QzMDU0MTM0sDU0szYyVx
 Xs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGJtNnr2SY+iQfGhrv17W46ad7aqtB+wKmd3qSku9Z
 dhzNlbxhsLyr30E43Fp01caSI9yNq3c5pC756av0pv6yaYtm7VLu9LOaWzZfmbZY+mzE8xZf
 fqu/TtJnvdsuBN4/WsJ4h7dG6nKFxPpFastOny5tD923RPV94ydusfn/84zXvd8mIjPHfEv/
 Vh/7V59cVz57d4lHfe75/LWGKRtvieit+nbzaeTW42X5HjWX9txJa1i60YPVzmipU3rmwYO9
 j27G7vx58c+BHwIrH5xbuzli3ap7r86+8hVY9+B+WdS2Kd8/+a16ep3rbqnjWsNnZyfdjA1o
 jCm/flFk/ftyq9AJ9WVFuzXk3VWPJXfUruRTYinOSDTUYi4qTgQAvqKJtGYDAAA=
X-CMS-MailID: 20220920091128eucas1p2d9c9dcebdce4039360f92b0f577ab649
X-Msg-Generator: CA
X-RootMTR: 20220920091128eucas1p2d9c9dcebdce4039360f92b0f577ab649
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091128eucas1p2d9c9dcebdce4039360f92b0f577ab649
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091128eucas1p2d9c9dcebdce4039360f92b0f577ab649@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v14 08/13] dm-zoned: ensure only power of 2 zone
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
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

