Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 307D5C5479D
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 08:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672994558;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jTaXnOBJ5GEr4EkLi5QhX4BjDe/o0SffCJKXLkvGdBc=;
	b=BpODhbhTalRjHBcouBf8Jjtjvhonz0QYdfiYexfqpWu52hHL1v4rmmDn+2TTGDW7Ga2SOq
	DybeAwxxh0okr3JwBdAuXGYtVvFBqD9Q2OrewrFomeSrahpmaIJnjnStwGCQWIoYmdnL1g
	t6T+b0AOeyEyZHM5+6unE53eq7ZYDTg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-qLaEpbP1MAyA_08d2MVh1Q-1; Fri, 06 Jan 2023 03:42:36 -0500
X-MC-Unique: qLaEpbP1MAyA_08d2MVh1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72A9D101A52E;
	Fri,  6 Jan 2023 08:42:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 621F5140EBF5;
	Fri,  6 Jan 2023 08:42:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31C8A194658D;
	Fri,  6 Jan 2023 08:42:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EEAB21946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 08:42:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E291140C2004; Fri,  6 Jan 2023 08:42:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA8A640C2064
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:42:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A926E3C10ED2
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:42:34 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-SAeTeIXKODqNE1SZDu7xVw-1; Fri, 06 Jan 2023 03:42:25 -0500
X-MC-Unique: SAeTeIXKODqNE1SZDu7xVw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20230106083321euoutp02be4a60da51aa38f98f0a4ab56576bf60~3qy5AoPfp2142821428euoutp02m
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:33:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20230106083321euoutp02be4a60da51aa38f98f0a4ab56576bf60~3qy5AoPfp2142821428euoutp02m
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230106083320eucas1p2d90ff0852e090e65aca5fa311795922e~3qy3_jx7W0127301273eucas1p2-;
 Fri,  6 Jan 2023 08:33:20 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 46.43.43884.0DCD7B36; Fri,  6
 Jan 2023 08:33:20 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f~3qy3k3X6I2244622446eucas1p12;
 Fri,  6 Jan 2023 08:33:20 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230106083320eusmtrp1ca7857a1c230a82c8c50a2ca90d049a8~3qy3kPC_x2166121661eusmtrp1h;
 Fri,  6 Jan 2023 08:33:20 +0000 (GMT)
X-AuditID: cbfec7f5-271ff7000000ab6c-44-63b7dcd0381b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id E7.C6.23420.0DCD7B36; Fri,  6
 Jan 2023 08:33:20 +0000 (GMT)
Received: from localhost (unknown [106.210.248.66]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230106083319eusmtip2fc156a9b99243a61ab87bd75fb6194fb~3qy3WgiZY2797827978eusmtip2g;
 Fri,  6 Jan 2023 08:33:19 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk
Date: Fri,  6 Jan 2023 09:33:12 +0100
Message-Id: <20230106083317.93938-3-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7djP87oX7mxPNti9T8li9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLM68/MxisfeWtsXlXXPYLOYve8pu8XlpC7vF
 iVvSDrwel694e1w+W+qxaVUnm8fmJfUeu282sHnsbL3P6nF2paPH+31X2Tz6tqxi9Nh8utrj
 8ya5AO4oLpuU1JzMstQifbsErowPy7cxF8wXqVhxdjNTA+NlgS5GTg4JAROJ3xP62LoYuTiE
 BFYwStx/9IIRwvnCKPHozCdmCOczo8TerQeZYFounF0PVbWcUWLD5ulQ/S8YJd7v/QPUwsHB
 JqAl0djJDtIgIiAssb+jlQWkhllgM5PE7d9rGUESwgLREqdm72AFsVkEVCX+9xwAs3kFLCXW
 fp3PCLFNXmLmpe9ggzgFrCSeT1/DBFEjKHFy5hMWEJsZqKZ562xmiPpuTolVZ5QhbBeJ09d3
 QM0Rlnh1fAs7hC0jcXpyDwuEXS3x9MZvsDclBFoYJfp3rmcDeUBCwFqi70wOiMksoCmxfpc+
 RLmjxLo955ggKvgkbrwVhLiAT2LStunMEGFeiY42IYhqJYmdP59ALZWQuNw0B2qph8SDydvZ
 JjAqzkLyyywkv8xC2LuAkXkVo3hqaXFuemqxcV5quV5xYm5xaV66XnJ+7iZGYEo7/e/41x2M
 K1591DvEyMTBeIhRgoNZSYS3rH9bshBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeGVvnJwsJpCeW
 pGanphakFsFkmTg4pRqYpt9otLnWcNB4Q42cgHL/z0DhszXPereFZGS4MbVfvCgtskSf8eK8
 4EqLyFcsAj+zAwsXnFKZZ5GUy71X6k3BgbB1v3K4mcP3sTgfn7di8s7ZUbkREidmWrrVfCj4
 o39li0eBwZQDnisUks+9/pXdYL7+waOGvJXH3sxyP7jhscUiodD0nroULveZhZk/mudHx85U
 UvbONP8/a9USxoqvD66/bGEpNdZs1gubfK21r+vSi3ll650ubbW6zlvcMb9jf1lt1u61Tza2
 3Zn4Z27jnZoJla73ZnO0FmdMSLnEejGRq213y+eQpX6bvU/uOf238pWCycv38//2L7k861zS
 gdonxmeONTw8xTul859yghJLcUaioRZzUXEiAFtCPzPYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t/xe7oX7mxPNjjUz2qx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLmwd2MlnsWTSJyWLl6qNMFmdefmax2HtL2+LyrjlsFvOXPWW3+Ly0hd3i
 xC1pB16Py1e8PS6fLfXYtKqTzWPzknqP3Tcb2Dx2tt5n9Ti70tHj/b6rbB59W1Yxemw+Xe3x
 eZNcAHeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2C
 XsaH5duYC+aLVKw4u5mpgfGyQBcjJ4eEgInEhbPrGbsYuTiEBJYySjTeecwGkZCQuL2wiRHC
 Fpb4c62LDaLoGaPEt43fWLsYOTjYBLQkGjvZQWpEgGr2d7SygNQwCxxkkng25TszSEJYIFLi
 zKkDYDaLgKrE/54DrCA2r4ClxNqv86EWyEvMvPQdbBCngJXE8+lrmEBsIaCajo+9bBD1ghIn
 Zz5hAbGZgeqbt85mnsAoMAtJahaS1AJGplWMIqmlxbnpucWGesWJucWleel6yfm5mxiB8bft
 2M/NOxjnvfqod4iRiYPxEKMEB7OSCG9Z/7ZkId6UxMqq1KL8+KLSnNTiQ4ymQHdPZJYSTc4H
 JoC8knhDMwNTQxMzSwNTSzNjJXFez4KORCGB9MSS1OzU1ILUIpg+Jg5OqQamI6lXqrWu+PBt
 NXv77vPNgrDOTcvVy6QP/nTfJaI450CtzxZrrRXfk7bKSlQJrX/39Nn3bVKbbgmbTDxXY6t6
 d99e4xxhH+t/hmmx/h8ffDI8edp76SJ7q+6SWQKJZ3bMWTuL585LBvdXLU6x86+1rWb4Uv3t
 QtzX5ddu8Dsmvbk/w6j5xsQvcWlOrPy3z2Se1t3+WYerV31d8OLUbo+8W2cFf00Ne364Y+/V
 T84Gu+SXhDCGxIXGP3v4ifPpnfc3mI1nS6l3n08JWnDiZAnjnnaTRuuQnsnppyoj/1hp1/R+
 XZDhPHWJUI53EHv3/8ytDw4/imFUFN0/22JZ/IJXm3V+SvUcerqhYY3jpJ1fUpVYijMSDbWY
 i4oTASPl4khIAwAA
X-CMS-MailID: 20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f
X-Msg-Generator: CA
X-RootMTR: 20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 2/7] block: add a new helper bdev_{is_zone_start,
 offset_from_zone_start}
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
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of open coding to check for zone start, add a helper to improve
readability and store the logic in one place.

bdev_offset_from_zone_start() will be used later in the series.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-core.c       |  2 +-
 block/blk-zoned.c      |  4 ++--
 include/linux/blkdev.h | 18 ++++++++++++++++++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9321767470dc..0405b3144e7a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -573,7 +573,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_NOTSUPP;
 
 	/* The bio sector must point to the start of a sequential zone */
-	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
+	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector) ||
 	    !bio_zone_is_seq(bio))
 		return BLK_STS_IOERR;
 
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index db829401d8d0..614b575be899 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -277,10 +277,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
 		return -EINVAL;
 
 	/* Check alignment (handle eventual smaller last zone) */
-	if (sector & (zone_sectors - 1))
+	if (!bdev_is_zone_start(bdev, sector))
 		return -EINVAL;
 
-	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
+	if (!bdev_is_zone_start(bdev, nr_sectors) && end_sector != capacity)
 		return -EINVAL;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e40b014c40b..04b7cbfd7a2a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -715,6 +715,7 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 {
 	return 0;
 }
+
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	return 0;
@@ -1304,6 +1305,23 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return q->limits.chunk_sectors;
 }
 
+static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
+						   sector_t sec)
+{
+	if (!bdev_is_zoned(bdev))
+		return 0;
+
+	return sec & (bdev_zone_sectors(bdev) - 1);
+}
+
+static inline bool bdev_is_zone_start(struct block_device *bdev, sector_t sec)
+{
+	if (!bdev_is_zoned(bdev))
+		return false;
+
+	return bdev_offset_from_zone_start(bdev, sec) == 0;
+}
+
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->limits.dma_alignment : 511;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

