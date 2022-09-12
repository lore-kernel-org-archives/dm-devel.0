Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3265FC6FA8B
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970960;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oiuoOweSzWq0Pz/vD/S7eNDblMhEpwk/LTJgHPLkg/k=;
	b=Kg9yd9GVUQxiVxwLkHGn25fCjgjKhLxQKtFaQUHu+bEnNvCMfe+bMgLHgpqp9XbG4k1aWP
	KMhwuQHvZYHjYKmfccg+T2wjXrFpf/KWoZn0A6H88FyRCPbOgydiK7F/Cl7iO0u5aGVMfT
	EYhv3sIldEAEiM2WaLURMa5CTFTZlv4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-OH5IZM33P8-9Ez0f8l-Z9w-1; Mon, 12 Sep 2022 04:22:37 -0400
X-MC-Unique: OH5IZM33P8-9Ez0f8l-Z9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB662811E9B;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB17E17584;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B24D1946A46;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3AD211946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2CD13C15BA5; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 28B49C15BA4
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F8CF1818815
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-PIl1QwPRO7izLs0sQ11yVw-1; Mon, 12 Sep 2022 04:22:31 -0400
X-MC-Unique: PIl1QwPRO7izLs0sQ11yVw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082215euoutp027ebdf3d366fc4e23b475d93d3d079544~UD0EuSh2m2358323583euoutp02L
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220912082215euoutp027ebdf3d366fc4e23b475d93d3d079544~UD0EuSh2m2358323583euoutp02L
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082208eucas1p2c68fa5bb7ebe6e79e708799a3c8fafa4~UDz_jWnP-2521625216eucas1p29;
 Mon, 12 Sep 2022 08:22:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 12.98.29727.03CEE136; Mon, 12
 Sep 2022 09:22:08 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220912082207eucas1p14b1bcefc6045a0a835e83db8ed810d5e~UDz_J7ijQ1135111351eucas1p1p;
 Mon, 12 Sep 2022 08:22:07 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220912082207eusmtrp2551c7002f1c8dffd039c15e861705810~UDz_JGrjO3082830828eusmtrp2P;
 Mon, 12 Sep 2022 08:22:07 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-e2-631eec30db5d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id D5.33.10862.F2CEE136; Mon, 12
 Sep 2022 09:22:07 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082207eusmtip20acf27f91edbff5da8aa4a9d10228a95~UDz9z3BZ72962629626eusmtip2_;
 Mon, 12 Sep 2022 08:22:07 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:53 +0200
Message-Id: <20220912082204.51189-3-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djPc7oGb+SSDZasFLFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJm7tvBXDBb
 rOLszunMDYwnhLoYOTkkBEwkdu1dzNLFyMUhJLCCUeJH7yJWkISQwBdGic8H2SASnxklvp7t
 ZYHpuPboByNEYjmjxMVZs6DaXzJKfOr5x9TFyMHBJqAl0djJDtIgIpAu8X36OyaQGmaBbUwS
 9x++YAapEQZKvFjuBVLDIqAq0fPnPitImFfAUmLfnEqIXfISMy99BxvDKWAl8XpVKyOIzSsg
 KHFy5hOwe5iBapq3zmaGqF/PKTG50wTCdpHY8PkKI4QtLPHq+BZ2CFtG4v/O+UwQdrXE0xu/
 mUFOkxBoYZTo37meDeQGCQFrib4zOSAms4CmxPpd+hDljhKTvjSyQ1TwSdx4KwhxAZ/EpG3T
 mSHCvBIdbdCgVZLY+fMJ1FIJictNc6AB6CHxt2E60wRGxVlIfpmF5JdZCHsXMDKvYhRPLS3O
 TU8tNsxLLdcrTswtLs1L10vOz93ECEyAp/8d/7SDce6rj3qHGJk4GA8xSnAwK4nwshhKJwvx
 piRWVqUW5ccXleakFh9ilOZgURLnTc7ckCgkkJ5YkpqdmlqQWgSTZeLglGpgCqn+n1P1idNx
 N/u/gDn8HyJFiiW17Cf231Qpmq/tMyVhxff1XjyKr42cI55M8oj8+Sx1d7sz5xGjc9mv7Jae
 e7/DtWxZoGL5lCNSa/+fW1qhP2dG74aJK10lrc5nvg+Xtbqz6vOz80df/fveO+PEtQyV5xpV
 LCYCk7g8fyTMqOGIO/3g/Uf9RaaPzb5czhN03R3asZ9F7NKNg4/nnTZybfbS5c+PFK+yXPty
 usmrmhMszBGWr63eTdzFtv3lYUf1EGt1G6HfreceHjmxPU3EtXGasmyeYLS21y+Xy8FXOl9z
 vZ+fqrLMdn4m0yFpn2v/j/pHCp3s/fLzM1fNjM7bu1ZVBT9gvexpnvfy0n1PfyWW4oxEQy3m
 ouJEAGGE0wrvAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xe7r6b+SSDW4vMrdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJm7tvBXDBbrOLszunMDYwnhLoYOTkkBEwk
 rj36wQhiCwksZZS4sIARIi4hcXthE5QtLPHnWhdbFyMXUM1zRol5m+8CJTg42AS0JBo72UFq
 RARyJT6v/AFWwyxwhEni76sVzCAJYYFUiWNv34ANYhFQlej5c58VpJdXwFJi35xKiPnyEjMv
 fQebwylgJfF6VSvUPZYSZ7/dAIvzCghKnJz5hAXEZgaqb946m3kCo8AsJKlZSFILGJlWMYqk
 lhbnpucWG+kVJ+YWl+al6yXn525iBMbrtmM/t+xgXPnqo94hRiYOxkOMEhzMSiK8LIbSyUK8
 KYmVValF+fFFpTmpxYcYTYHOnsgsJZqcD0wYeSXxhmYGpoYmZpYGppZmxkrivJ4FHYlCAumJ
 JanZqakFqUUwfUwcnFINTJsPLThWW/1k17HLiv+7TCYFvF7mK5DxPKDsbsepwI5ZAXwKk951
 rDE2XdRrznRn0017yYd+13/nnfa1c7u1sGX5xHMFu2958K4uX+SSclokOItz57vHbMr2Vnv/
 /u/b122vdL1/xYq5ryN+dyqYPl96deKC554MOwMyNv0p2fNqau35c503p2Ya1cZGlkrVOnJy
 S93+ONkqwf712ymnud+lX5hx43HLuef/Vb9NWdyhOTezLybE/8vJ9WxLBJizvb0t5FNsG3UO
 rD/VtOKY7LfX+smfrxz7HbqDJ1nStUh9tc3knzUd1i27XY2UlHd5Tt30SYZv/esVEtKO7x2U
 t6x+eCPo/HauB7vP5TvOYlBQYinOSDTUYi4qTgQALhcDLGADAAA=
X-CMS-MailID: 20220912082207eucas1p14b1bcefc6045a0a835e83db8ed810d5e
X-Msg-Generator: CA
X-RootMTR: 20220912082207eucas1p14b1bcefc6045a0a835e83db8ed810d5e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082207eucas1p14b1bcefc6045a0a835e83db8ed810d5e
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082207eucas1p14b1bcefc6045a0a835e83db8ed810d5e@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v13 02/13] block: rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helper in blkdev.h
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
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
in the blkdev.h include file. Simplify bdev_is_zoned() by removing the
superfluous NULL check for request queue while we are at it.

This commit has no functional change, and it is a prep patch for allowing
zoned devices with non-power-of-2 zone sizes in the block layer.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/blkdev.h | 43 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ab82d1ff0cce..84e7881262e3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -635,6 +635,11 @@ static inline bool queue_is_mq(struct request_queue *q)
 	return q->mq_ops;
 }
 
+static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
+{
+	return bdev->bd_queue;	/* this is never NULL */
+}
+
 #ifdef CONFIG_PM
 static inline enum rpm_status queue_rpm_status(struct request_queue *q)
 {
@@ -666,6 +671,20 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 	}
 }
 
+static inline bool bdev_is_zoned(struct block_device *bdev)
+{
+	return blk_queue_is_zoned(bdev_get_queue(bdev));
+}
+
+static inline sector_t bdev_zone_sectors(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (!blk_queue_is_zoned(q))
+		return 0;
+	return q->limits.chunk_sectors;
+}
+
 #ifdef CONFIG_BLK_DEV_ZONED
 static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
@@ -892,11 +911,6 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags);
 int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 			unsigned int flags);
 
-static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
-{
-	return bdev->bd_queue;	/* this is never NULL */
-}
-
 /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
 const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
 
@@ -1296,25 +1310,6 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 	return BLK_ZONED_NONE;
 }
 
-static inline bool bdev_is_zoned(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return blk_queue_is_zoned(q);
-
-	return false;
-}
-
-static inline sector_t bdev_zone_sectors(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (!blk_queue_is_zoned(q))
-		return 0;
-	return q->limits.chunk_sectors;
-}
-
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

