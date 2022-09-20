Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EF7C6FA94
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jTjR+ZlQuiBEGgIyW0rFhICJ/hWgFHAdhiF4+pPITf8=;
	b=dKqdVuPM7gjQOx4hlG5RemBsXY6UZ0HNDSAKxV5n4GdSlnhcDpREKlAMwplJvWLA6EBy+X
	tnf+/LiOzDMPYJb9QyfmmKziHV9mXQYsGxx37EaYYCRv72vcrwwWNrjCcFTGiAGFpzl5mE
	YtrtugbUKJXBPFH9afdM4lvIKpykqeM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-OweLygazPYadeJ28YuET2g-1; Tue, 20 Sep 2022 05:11:44 -0400
X-MC-Unique: OweLygazPYadeJ28YuET2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E56B1805F53;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D16CC1121315;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F57F1946A48;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C1D5319465A8
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93662C07F55; Tue, 20 Sep 2022 09:11:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B3C6C06224
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B02A9833941
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-UYrHzbRSNtCcdKPKI0wbRg-1; Tue, 20 Sep 2022 05:11:34 -0400
X-MC-Unique: UYrHzbRSNtCcdKPKI0wbRg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091132euoutp01c985778a561a7a24ae32940a1ef15d70~WhpZqgkot1166811668euoutp014
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220920091132euoutp01c985778a561a7a24ae32940a1ef15d70~WhpZqgkot1166811668euoutp014
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091130eucas1p2a0838123c18e4e17ea3e770248bdfbbf~WhpXhxK5M1326413264eucas1p2N;
 Tue, 20 Sep 2022 09:11:30 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 1E.2E.29727.2C389236; Tue, 20
 Sep 2022 10:11:30 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091129eucas1p26137d368bf7e2cfc2d585ce41f3cdc86~WhpW2ihrg3137931379eucas1p2G;
 Tue, 20 Sep 2022 09:11:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091129eusmtrp119499d96c3e89392e5cec7a704d0ccbd~WhpW1uUQ30212802128eusmtrp1q;
 Tue, 20 Sep 2022 09:11:29 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-47-632983c2ca6a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 17.0E.07473.1C389236; Tue, 20
 Sep 2022 10:11:29 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091129eusmtip266122eeddf42e613961d590179a06c75~WhpWgYaD32182421824eusmtip2e;
 Tue, 20 Sep 2022 09:11:29 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:15 +0200
Message-Id: <20220920091119.115879-10-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djPc7qHmjWTDfofy1usP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InisklJzcksSy3St0vgylh3
 ZAlrwUqeit5Vb5kbGOdxdTFyckgImEhsu36OpYuRi0NIYAWjxP0rr9khnC+MEv1PvjFBOJ8Z
 Jbq7p7HBtCz99oYZIrGcUeLkuStMIAkhgZeMEkdbRLsYOTjYBLQkGjvZQcIiAukSX79uYASp
 ZxaYyCzxcPYnFpCEsECsxJmlK8BsFgFVibVfHzCC2LwC1hJbp09mhlgmLzHz0newQZxA8Tm7
 W9ggagQlTs58AtbLDFTTvHU22EESAps5JV4e28cC0ewi0f99JiOELSzx6vgWdghbRuL05B6o
 mmqJpzd+QzW3AP28cz0byAcSQNv6zuSAmMwCmhLrd+lDlDtKHOg7D1XBJ3HjrSDECXwSk7ZN
 Z4YI80p0tAlBVCtJ7Pz5BGqphMTlpjlQSz0kvjTfY53AqDgLyTOzkDwzC2HvAkbmVYziqaXF
 uempxYZ5qeV6xYm5xaV56XrJ+bmbGIEJ8fS/4592MM599VHvECMTB+MhRgkOZiUR3hZ/zWQh
 3pTEyqrUovz4otKc1OJDjNIcLErivMmZGxKFBNITS1KzU1MLUotgskwcnFINTIvzAtf35eZ+
 klv6jvFVq8sKFsuizdPFCruEjxzdvnyxXG3y563ryu7N2ZiwqG2FwskfvEePzk5p+unyw+r+
 0bvqiT7FmrbbaqrnS221yN0pYeAsvLvR5VW45RyZj8XTgwtXeHLYVHZMmWjXfH3u+bnV+myv
 4hyYV5yL/vG4ITHkCvfnGI2KDR6zf7Jbf7zB93Ere752ltlWfz43lm8/hC7M9DP/kGW7V17T
 Sn3VYp8a5j1RjzN4TLcc/Fqx6GF61OebvKY7ZrGUWoQsl4nUdNL01W5fHabP43nwwKLAJSWr
 sy9P9dm602mrznmH7RH9E5JM5DrizpWxBBsu0xSS+t+95LrmSe7GJeFfjr2fpsRSnJFoqMVc
 VJwIAKPF4fj3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xe7oHmzWTDb7PN7JYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7HuyBLWgpU8Fb2r3jI3MM7j6mLk
 5JAQMJFY+u0NM4gtJLCUUeJscwhEXELi9sImRghbWOLPtS62LkYuoJrnjBL3729g6WLk4GAT
 0JJo7GQHqRERyJU4vHkCE0gNs8B8Zold/96CJYQFoiX6n79mArFZBFQl1n59ADaUV8BaYuv0
 ycwQC+QlZl76DlbPCRSfs7uFDeIgK4mOWZvZIOoFJU7OfMICYjMD1Tdvnc08gVFgFpLULCSp
 BYxMqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQJjd9uxn5t3MM579VHvECMTB+MhRgkOZiUR
 3hZ/zWQh3pTEyqrUovz4otKc1OJDjKZAd09klhJNzgcmj7ySeEMzA1NDEzNLA1NLM2MlcV7P
 go5EIYH0xJLU7NTUgtQimD4mDk6pBqbl65Inbv8j+1rvj3e28t6PZny3fzj8lZLl97jmddvn
 8PYVlw6+mpmakORT+bnEZqeafmCzwP7Q5XIpUg6zH4qFT9b0zJc5VvGryavH+bh0f9+X0y/9
 JqYuLJH5z3Lkyza1J2f73Iy+O0tbr1xY3njru6NecDdHzdXnD+I+T+6Q1Yz2llvKVGPK8mHB
 ybCLs7OLok8/aemzuaBvK2Zv7fiIX6Ak7+rZ2omtZfPkOmYKT/769n9lYfKKLPW2tuMrN6z3
 6Vv2JHjhV6OahTb+V4oV+5RY1OTqtgm+L3R7s6B/dZmT88IPDg8XzVXOEPPMW/KCLyQkf02f
 c1RLXtC9ZAOWviXdym93PbpgfFTQT4mlOCPRUIu5qDgRAM8iv9dmAwAA
X-CMS-MailID: 20220920091129eucas1p26137d368bf7e2cfc2d585ce41f3cdc86
X-Msg-Generator: CA
X-RootMTR: 20220920091129eucas1p26137d368bf7e2cfc2d585ce41f3cdc86
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091129eucas1p26137d368bf7e2cfc2d585ce41f3cdc86
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091129eucas1p26137d368bf7e2cfc2d585ce41f3cdc86@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v14 09/13] dm-zone: use generic helpers to
 calculate offset from zone start
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the bdev_offset_from_zone_start() helper function to calculate
the offset from zone start instead of using power of 2 based
calculation.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-zone.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3dafc0e8b7a9..ac6fc1293d41 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -390,7 +390,8 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE:
 		/* Writes must be aligned to the zone write pointer */
-		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
+		if (bdev_offset_from_zone_start(md->disk->part0,
+						clone->bi_iter.bi_sector) != zwp_offset)
 			return false;
 		break;
 	case REQ_OP_ZONE_APPEND:
@@ -602,11 +603,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 		 */
 		if (clone->bi_status == BLK_STS_OK &&
 		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
-			sector_t mask =
-				(sector_t)bdev_zone_sectors(disk->part0) - 1;
-
 			orig_bio->bi_iter.bi_sector +=
-				clone->bi_iter.bi_sector & mask;
+				bdev_offset_from_zone_start(disk->part0, clone->bi_iter.bi_sector);
 		}
 
 		return;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

