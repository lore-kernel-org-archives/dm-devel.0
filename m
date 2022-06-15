Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65739C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:20:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-XPoa-_CYPg2XDF2h1F38IA-1; Wed, 15 Jun 2022 06:20:00 -0400
X-MC-Unique: XPoa-_CYPg2XDF2h1F38IA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FD5D801E67;
	Wed, 15 Jun 2022 10:19:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D4B91415106;
	Wed, 15 Jun 2022 10:19:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D65631947B84;
	Wed, 15 Jun 2022 10:19:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A7C01949759
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:19:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0293400DF1D; Wed, 15 Jun 2022 10:19:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CBB7740CFD0A
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B42993804516
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:55 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-94gJWWA1P0KVGJsrQ5nbjw-1; Wed, 15 Jun 2022 06:19:48 -0400
X-MC-Unique: 94gJWWA1P0KVGJsrQ5nbjw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101947euoutp023669c17652f78ea718ddba73f6da33ec~4xAS1yZmz2930429304euoutp02G
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220615101947euoutp023669c17652f78ea718ddba73f6da33ec~4xAS1yZmz2930429304euoutp02G
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220615101945eucas1p1d5342ae55cf549f7f52be0f3f500a61c~4xARRJUWa2260522605eucas1p1F;
 Wed, 15 Jun 2022 10:19:45 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 39.3B.09664.142B9A26; Wed, 15
 Jun 2022 11:19:45 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220615101945eucas1p16fa264e81d9b6027ff131dd311ed91e2~4xAQvVa5T1177311773eucas1p1k;
 Wed, 15 Jun 2022 10:19:45 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101945eusmtrp22c89343c319808137c8290492d5eddfa~4xAQudBoS0361403614eusmtrp2X;
 Wed, 15 Jun 2022 10:19:45 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-f7-62a9b24146d1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id B5.55.09095.142B9A26; Wed, 15
 Jun 2022 11:19:45 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101943eusmtip1dcf863a2a0f7ec36b4725dadaac7a2c0~4xAPefbdk0536005360eusmtip1f;
 Wed, 15 Jun 2022 10:19:43 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:13 +0200
Message-Id: <20220615101920.329421-7-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7djPc7qOm1YmGVzYbWSx+m4/m8W0Dz+Z
 LX6fPc9s0dr+jcli77vZrBYXfjQyWdw8sJPJYs+iSUwWK1cfZbJ4sn4Ws0XPgQ8sFn+77gHF
 Wh4yW+y9pW1xedccNov5y56yW9yY8JTR4vPSFnaLNTefsli0bfzK6CDicfmKt8e/E2vYPHbO
 usvucflsqcemVZ1sHgsbpjJ7bF5S77H7ZgNQrvU+q8f7fVfZPPq2rGL0WL/lKovH5tPVHp83
 yXm0H+hmCuCP4rJJSc3JLEst0rdL4MpofXqaseC7UMWqX0vYGxh/8HcxcnJICJhI9H/6xQZi
 CwmsYJSYsjWpi5ELyP7CKPFu0zJGCOczo8Si0y+ZYDren13NBJFYziixt3E7M4TzklFixdJ1
 7F2MHBxsAloSjZ3sIA0iAuESR/fcA2tgFtjBLLGs5SHYPmGBGIljm6eBTWURUJU4f/YYI0gv
 r4CVxJJrGRDL5CVmXvoONodTwFpix+weVhCbV0BQ4uTMJywgNjNQTfPW2WA3SAjc45Q4evww
 O0Szi8SdfY1QtrDEq+NboGwZif8750N9Uy3x9MZvqOYWRon+nevZQI6QANrWdyYHxGQW0JRY
 v0sfIuoo8W5KJoTJJ3HjrSDEBXwSk7ZNZ4YI80p0tAlBzFaS2PnzCdROCYnLTXNYIGwPiXtd
 cxknMCrOQvLLLCS/zEJYu4CReRWjeGppcW56arFhXmq5XnFibnFpXrpecn7uJkZgAj397/in
 HYxzX33UO8TIxMF4iFGCg1lJhNcseGWSEG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLp
 iSWp2ampBalFMFkmDk6pBqZAlo5EsdWOtufWGi7td+G7dPHPop8b2PjvWvEbnambViN4vY7n
 mH9f2vSIaI/e3N8HTEq1erPkjtQHTr5+iX2T3ictbcnNuw/9Ou6zYmXBojX7y9uvn2mbFyTn
 +qr8Vtyk6YnaFxx3vm/ekvj7RMnRj6ohvt42OowKGpUeklU6c+6XrK0JTfRUn9yjWd4b2nxE
 /JagBfNUK6UDwTV7Dun/2xVWa3Tfbfv72KdTssxsuwxmLg0+ev7Lgjc7Fh9yZGzoqdCyvvk5
 ZI+L4bGdeVlzcua0n99Qf6VIWfrfKRW9bTZTasLW5TKyTxVXm5YovlgqM6w8+0VliVbdfa9t
 X79vute9TTA155OITtqt10osxRmJhlrMRcWJAGn10hkPBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t/xu7qOm1YmGZybxWmx+m4/m8W0Dz+Z
 LX6fPc9s0dr+jcli77vZrBYXfjQyWdw8sJPJYs+iSUwWK1cfZbJ4sn4Ws0XPgQ8sFn+77gHF
 Wh4yW+y9pW1xedccNov5y56yW9yY8JTR4vPSFnaLNTefsli0bfzK6CDicfmKt8e/E2vYPHbO
 usvucflsqcemVZ1sHgsbpjJ7bF5S77H7ZgNQrvU+q8f7fVfZPPq2rGL0WL/lKovH5tPVHp83
 yXm0H+hmCuCP0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXSt7NJSc3JLEst
 0rdL0MtofXqaseC7UMWqX0vYGxh/8HcxcnJICJhIvD+7mqmLkYtDSGApo8TJRQ3sEAkJidsL
 mxghbGGJP9e62CCKnjNKHF23lrmLkYODTUBLorETrF5EIFqi8+Z7sBpmgVPMEltmvWcCSQgL
 RElsObmFBcRmEVCVOH/2GCNIL6+AlcSSaxkQ8+UlZl76DjaHU8BaYsfsHlaQEiGgkl3v4kHC
 vAKCEidnPgGbwgxU3rx1NvMERoFZSFKzkKQWMDKtYhRJLS3OTc8tNtQrTswtLs1L10vOz93E
 CIz2bcd+bt7BOO/VR71DjEwcjIcYJTiYlUR4zYJXJgnxpiRWVqUW5ccXleakFh9iNAW6eiKz
 lGhyPjDd5JXEG5oZmBqamFkamFqaGSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1MG3/4vx+
 ZuC+DPEPhw4bi3SvWiSTp625OfFez8MyJaZLxqpGr1wepvrsFZ8w797jmnc/RPfurPm+u2e2
 ZsltLi/ZuI7OSsb/9adXPrtl82516wauLTE1Pa9SE5cYKgXe159+MMK0uIKd++VM9doju/su
 r9t8Mu7yomUTOIPESqbOdJUOPjz/RvSta7djshc49G34efXxjdQ1Vp497BWell4qXw9H21zL
 6VwaafBh5bck4btl2e8vLzr66Elr1tXfs5/cufhv0tVb4rO/2VzpWRK0+kCQ9Q+ZGp3yv/b7
 J/6YHV71Ju69/hGdsq6i5c73f5ltidkvHHtEUdwok1NYRuK2yJ7W7IOVmnyrUlwvMy1VYinO
 SDTUYi4qTgQABDAVGH8DAAA=
X-CMS-MailID: 20220615101945eucas1p16fa264e81d9b6027ff131dd311ed91e2
X-Msg-Generator: CA
X-RootMTR: 20220615101945eucas1p16fa264e81d9b6027ff131dd311ed91e2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101945eucas1p16fa264e81d9b6027ff131dd311ed91e2
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101945eucas1p16fa264e81d9b6027ff131dd311ed91e2@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v7 06/13] null_blk: use zone_size_sects_shift for
 power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of doing is_power_of_2 and ilog2 operation for every IO, cache
the zone_size_sects_shift variable and use it for power of 2 zoned
devices.

This variable will be set to zero for non power of 2 zoned devices.

Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/null_blk.h |  6 ++++++
 drivers/block/null_blk/zoned.c    | 11 ++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 8359b4384..3bc7cbf25 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -83,6 +83,12 @@ struct nullb_device {
 	unsigned int imp_close_zone_no;
 	struct nullb_zone *zones;
 	sector_t zone_size_sects;
+	/*
+	 * zone_size_sects_shift is only useful when the zone size is
+	 * power of 2. This variable is set to zero when zone size is non
+	 * power of 2.
+	 */
+	unsigned int zone_size_sects_shift;
 	bool need_zone_res_mgmt;
 	spinlock_t zone_res_lock;
 
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index daf327015..5f929944b 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -16,8 +16,8 @@ static inline sector_t mb_to_sects(unsigned long mb)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
-	if (is_power_of_2(dev->zone_size_sects))
-		return sect >> ilog2(dev->zone_size_sects);
+	if (dev->zone_size_sects_shift)
+		return sect >> dev->zone_size_sects_shift;
 
 	return div64_u64(sect, dev->zone_size_sects);
 }
@@ -85,9 +85,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
+
+	if (is_power_of_2(dev->zone_size_sects))
+		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
+	else
+		dev->zone_size_sects_shift = 0;
+
 	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
 					      dev->zone_size_sects);
-
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
 				    GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

