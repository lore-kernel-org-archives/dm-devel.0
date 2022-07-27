Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5AAC19F2B
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658940497;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vfQCAB14zQ43PjHqwHbwpOhLg9xP3FTqrg8jS8LlbJE=;
	b=NfODhjlSIfFqsYEIi4SmCklCVndQSlFtfmipMo7MRRyNd04gAxkRs/4OODgXLkA9l1qKqN
	3aBlP2WPI1zcbc5vu5jlTAwToX6bdWqdI0/FZg/PkwsJg/htdJ6pmAxjVVyk4BimO9zQpT
	JoJjGKprlykOlJEvgSi3gFBcOenl7ZI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-iFnYjyqYMJa14YiSrr8CWA-1; Wed, 27 Jul 2022 12:48:14 -0400
X-MC-Unique: iFnYjyqYMJa14YiSrr8CWA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0630828084ED;
	Wed, 27 Jul 2022 16:48:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E511D492CA5;
	Wed, 27 Jul 2022 16:48:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5FE571947060;
	Wed, 27 Jul 2022 16:48:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 434001945DA7
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 34BD440CFD0A; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FBED40CF8E2
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14C99805AF5
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-YBajfqGZPiCFzX5Nv0VSsw-1; Wed, 27 Jul 2022 12:31:23 -0400
X-MC-Unique: YBajfqGZPiCFzX5Nv0VSsw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162253euoutp010c4b802870586ab72dc35d421f23274f~FvDT406hR2521125211euoutp01j
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220727162253euoutp010c4b802870586ab72dc35d421f23274f~FvDT406hR2521125211euoutp01j
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162252eucas1p2d1d5681c130281324a73b4703be63e00~FvDSn8ez52169521695eucas1p2l;
 Wed, 27 Jul 2022 16:22:52 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 40.C3.09664.B5661E26; Wed, 27
 Jul 2022 17:22:52 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f~FvDSJxEkF1290212902eucas1p1C;
 Wed, 27 Jul 2022 16:22:51 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220727162251eusmtrp2555dbc48e32b198aa34ad92aed686343~FvDSJEXCA0811608116eusmtrp2w;
 Wed, 27 Jul 2022 16:22:51 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-ec-62e1665b6998
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 8A.1E.09095.B5661E26; Wed, 27
 Jul 2022 17:22:51 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162251eusmtip1dfc3f183a47358335b251e9c7f2f11bb~FvDRv8eGX0448504485eusmtip1C;
 Wed, 27 Jul 2022 16:22:51 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:39 +0200
Message-Id: <20220727162245.209794-6-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djP87oxaQ+TDCZPZbJYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDLO7TIvmG5S
 sffefpYGxiuaXYwcHBICJhL/j6h1MXJxCAmsYJRYNX0rK4TzhVHi64wF7BDOZ0aJ/e0r2LoY
 OcE6vr/9B1W1nFFi+4cvTBDOc0aJaf8nM4LMZRPQkmjsZAdpEBEolnj4rpUFpIZZ4ACTxIPb
 LWCThAXcJE49vcICYrMIqEpMvTuTCcTmFbCS+HR/CTPENnmJmZe+gw3iFLCW2DxlHlSNoMTJ
 mU/AepmBapq3zoaqX88pcX1aPYTtInFpxUsWCFtY4tXxLewQtozE/53zmSDsaomnN34zgxwn
 IdDCKNG/cz0bJGCsJfrO5ICYzAKaEut36UOUO0pceXWcCaKCT+LGW0GIC/gkJm2bzgwR5pXo
 aBOCqFaS2PnzCdRSCYnLTXOgjvGQWPi9n3kCo+IsJL/MQvLLLIS9CxiZVzGKp5YW56anFhvm
 pZbrFSfmFpfmpesl5+duYgSmwNP/jn/awTj31Ue9Q4xMHIyHGCU4mJVEeBOi7ycJ8aYkVlal
 FuXHF5XmpBYfYpTmYFES503O3JAoJJCeWJKanZpakFoEk2Xi4JRqYMp5dS7k5NkT4VwfOBtc
 brYuXdYjsHa3or5M/URT58aU50U/FVr57tpe/8G3ce576z/clcabCow8Q+YyHOubW8JmVs34
 8bHi518Ge5g92U9N+ZtZsipssZNaJPsBx3XHm0NmzViZ+knxVsmz2h8f57z3CP7FYq38ZWX1
 38uJPXsYd3W927r0jk3hmpqZ1vJTTGJ+zxHpOWYzZ4t33/tCvtNPBfhOztqz98Y8D/vktf82
 8a6P6S6xFJQScnoi5zo1/XD5Odbsng2dD8PzAqw1vUWFfVaFyd76f/Gax/wU02nzdcpOxfb9
 NCss+Ge6iHdypM9aqU7OqzfffJmg0B4V//+BjvabK3VnXxkuFOJULlRiKc5INNRiLipOBABO
 FLOe8AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xu7rRaQ+TDO6vlbJYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLO7TIvmG5SsffefpYGxiuaXYycHBICJhLf
 3/5j7WLk4hASWMooMeXFJnaIhITE7YVNjBC2sMSfa11sEEVPGSWebrgG1MHBwSagJdHYyQ5i
 ighUSpz9IgtSwixwjkni5sVrbCC9wgJuEqeeXmEBsVkEVCWm3p3JBGLzClhJfLq/hBlivrzE
 zEvfwfZyClhLbJ4yD6xGCKjm2YOPbBD1ghInZz4Bm8MMVN+8dTbzBEaBWUhSs5CkFjAyrWIU
 SS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM123Hfm7ewTjv1Ue9Q4xMHIyHGCU4mJVEeBOi7ycJ
 8aYkVlalFuXHF5XmpBYfYjQFunsis5Rocj4wYeSVxBuaGZgamphZGphamhkrifN6FnQkCgmk
 J5akZqemFqQWwfQxcXBKNTDlJqUZ8yxlf7JMvfTZonvHfzL9/1LyuHTnDv11pz+vi5kY7KzE
 xvz7jLr9w4831VfU789ccmDlFfm7wocY4znuW0WmXLGfWXJl8qYmWY1tmkwS7wO/BBuetU1c
 3XGcsWPW3XligkFhf7ffO5p9zop5ymrxyuhrAlxPft1+s+art4emxoGg6YtP3e6P3FbWk7Uv
 rGfD5OeLt9cqzuc9qZkQWN/NvODg3VsiTOv01gQsrzP70/pW78hPvkrNxM9cX5aJPTzvHrgj
 7rTBMuu36bYuL2+JNn1TP3TlJMeJj/cOhH5Ks893UBHY28H7ku3M5HmHJ/g+/N2o98Hm0Vv1
 JZO+5EalPShcLtHCNPNyK4vaNCWW4oxEQy3mouJEAIWhMsdgAwAA
X-CMS-MailID: 20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f
X-Msg-Generator: CA
X-RootMTR: 20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162251eucas1p12939ac3864fd8705ae139eb2d1087d8f@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v8 05/11] null_blk: allow non power of 2 zoned
 devices
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the power of 2 based calculation with zone size to be generic in
null_zone_no with optimization for power of 2 based zone sizes.

The nr_zones calculation in null_init_zoned_dev has been replaced with a
division without special handling for power of 2 based zone sizes as
this function is called only during the initialization and will not
invoked in the hot path.

Performance Measurement:

Device:
zone size = 128M, blocksize=4k

FIO cmd:

fio --name=zbc --filename=/dev/nullb0 --direct=1 --zonemode=zbd  --size=23G
--io_size=<iosize> --ioengine=io_uring --iodepth=<iod> --rw=<mode> --bs=4k
--loops=4

The following results are an average of 4 runs on AMD Ryzen 5 5600X with
32GB of RAM:

Sequential Write:

x-----------------x---------------------------------x---------------------------------x
|     IOdepth     |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  578     |  2257    |   12.80   |  576     |  2248    |   25.78   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  581     |  2268    |   12.74   |  576     |  2248    |   25.85   |
x-----------------x---------------------------------x---------------------------------x

Sequential read:

x-----------------x---------------------------------x---------------------------------x
| IOdepth         |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  667     |  2605    |   11.79   |  675     |  2637    |   23.49   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  667     |  2605    |   11.79   |  675     |  2638    |   23.48   |
x-----------------x---------------------------------x---------------------------------x

Random read:

x-----------------x---------------------------------x---------------------------------x
| IOdepth         |            8                    |            16                   |
x-----------------x---------------------------------x---------------------------------x
|                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
x-----------------x---------------------------------x---------------------------------x
| Without patch   |  522     |  2038    |   15.05   |  514     |  2006    |   30.87   |
x-----------------x---------------------------------x---------------------------------x
|  With patch     |  522     |  2039    |   15.04   |  523     |  2042    |   30.33   |
x-----------------x---------------------------------x---------------------------------x

Minor variations are noticed in Sequential write with io depth 8 and
in random read with io depth 16. But overall no noticeable differences
were noticed

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/main.c     |  5 ++---
 drivers/block/null_blk/null_blk.h |  6 ++++++
 drivers/block/null_blk/zoned.c    | 18 +++++++++++-------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index c451c477978f..f1e0605dee94 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1976,9 +1976,8 @@ static int null_validate_conf(struct nullb_device *dev)
 	if (dev->queue_mode == NULL_Q_BIO)
 		dev->mbps = 0;
 
-	if (dev->zoned &&
-	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
-		pr_err("zone_size must be power-of-two\n");
+	if (dev->zoned && !dev->zone_size) {
+		pr_err("Invalid zero zone size\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 94ff68052b1e..ece6dded9508 100644
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
index 55a69e48ef8b..015f6823706c 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -16,7 +16,10 @@ static inline sector_t mb_to_sects(unsigned long mb)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
-	return sect >> ilog2(dev->zone_size_sects);
+	if (dev->zone_size_sects_shift)
+		return sect >> dev->zone_size_sects_shift;
+
+	return div64_u64(sect, dev->zone_size_sects);
 }
 
 static inline void null_lock_zone_res(struct nullb_device *dev)
@@ -65,10 +68,6 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	sector_t sector = 0;
 	unsigned int i;
 
-	if (!is_power_of_2(dev->zone_size)) {
-		pr_err("zone_size must be power-of-two\n");
-		return -EINVAL;
-	}
 	if (dev->zone_size > dev->size) {
 		pr_err("Zone size larger than device capacity\n");
 		return -EINVAL;
@@ -86,9 +85,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
-	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
-		>> ilog2(dev->zone_size_sects);
 
+	if (is_power_of_2(dev->zone_size_sects))
+		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
+	else
+		dev->zone_size_sects_shift = 0;
+
+	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
+					      dev->zone_size_sects);
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
 				    GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

