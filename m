Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B55CC6FA83
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970959;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6RZsm9Z0aI+d2x0ZJCGqfSlNbphX3h1kHVaRONg2a4E=;
	b=MfNz8nDckyRLLjxmw+R/f3shQDA76y+ySYuO+grr8juU0rART2MS9lmCVTBskgR7h4vb38
	Jm+GTcgwMKlE0iPeEX8hh90BXpLDyAfqw0htWK5WFKjbNGQwK+3ej94d0nsGHH5MYVANp2
	qwZ4dVzXN+M974olV5tynBHAIYPwZKc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-wWAN0gy-Pz6X54gg9UA0DA-1; Mon, 12 Sep 2022 04:22:36 -0400
X-MC-Unique: wWAN0gy-Pz6X54gg9UA0DA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7833D101E9B0;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7AF32C15BA4;
	Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4ED7C1946A4E;
	Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7230E1946A4E
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 554D2112131B; Mon, 12 Sep 2022 08:22:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5147C1121315
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3175329AA384
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:32 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-2JRdHHWJMZa6B7x6ehiBpA-1; Mon, 12 Sep 2022 04:22:30 -0400
X-MC-Unique: 2JRdHHWJMZa6B7x6ehiBpA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082214euoutp012fd231ca0d3643406e0dd108d537e200~UD0EKDEk61403214032euoutp01Z
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220912082214euoutp012fd231ca0d3643406e0dd108d537e200~UD0EKDEk61403214032euoutp01Z
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082207eucas1p29c7db135677f5003724aae601b8c346b~UDz9pzoBc0134101341eucas1p2i;
 Mon, 12 Sep 2022 08:22:07 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id A0.98.29727.F2CEE136; Mon, 12
 Sep 2022 09:22:07 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220912082206eucas1p25336d07279850f7009be6b5d1fccf558~UDz9G3b792084220842eucas1p2y;
 Mon, 12 Sep 2022 08:22:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220912082206eusmtrp1650c92c0efd28a6fd06dff561d98c82c~UDz9F6VZF1301813018eusmtrp1S;
 Mon, 12 Sep 2022 08:22:06 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-de-631eec2fb1fe
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 64.2F.07473.E2CEE136; Mon, 12
 Sep 2022 09:22:06 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082206eusmtip101d2c775cf01540cc46c480381f1d24c~UDz8utiBG1320313203eusmtip1f;
 Mon, 12 Sep 2022 08:22:06 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:52 +0200
Message-Id: <20220912082204.51189-2-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7djP87r6b+SSDX58FbGYfljRYv2pY8wW
 q+/2s1lM+/CT2eL32fPMFnvfzWa1uHlgJ5PFnkWTmCxWrj7KZPFk/Sxmi79d95gs9t7Stri8
 aw6bxfxlT9ktJrR9Zba4MeEpo8XnpS3sFmtuPmWxOHFL2kHY4/IVb4+ds+6ye1w+W+qxaVUn
 m8fmJfUeu282sHnsbL3P6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPFJdNSmpOZllqkb5d
 AlfG36ntTAVXRSqeTXjF1sA4S7CLkZNDQsBE4nDjSsYuRi4OIYEVjBJztq5jhXC+MErcXrWK
 DcL5zCix7MZq9i5GDrCWm40pEPHljBKf1kxngXBeMkpMvvuYBaSITUBLorGTHWSFiEC6xPfp
 75hAapgFupglDny/wAaSEBZIkrj98R8TiM0ioCqxZdskMJtXwFKi7/c0Voj75CVmXvoONohT
 wEri9apWRogaQYmTM5+wgNjMQDXNW2czgyyQENjPKdE8awpUs4vE1hkfmCFsYYlXx7ewQ9gy
 Eqcn97BA2NUST2/8hmpuYZTo37meDeJNa4m+MzkgJrOApsT6XfoQ5Y4Sly88YYKo4JO48VYQ
 4gQ+iUnbpjNDhHklOtqEIKqVJHb+fAK1VELictMcqKUeEj2PH7JMYFScheSZWUiemYWwdwEj
 8ypG8dTS4tz01GLDvNRyveLE3OLSvHS95PzcTYzAxHj63/FPOxjnvvqod4iRiYPxEKMEB7OS
 CC+LoXSyEG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBqay
 kOgtk6+/u7KyVkj6/KOCVdZ/oktrysOk05bf0Fyq210l36P98/zEq9OS7Wa+UC4UP8tUdkZy
 y/f+t5dEJtyoeuz0Z87kE88fG++Z+EeZWbFuk/cxP5OUS7XRhY+tmKetL1KyYJx+Vt6j7M9x
 o58HepV6H3xuYjELSec6/Hfx3qwmq0VMS4601zyfdveKcmL0+lBrr+/fDs2rWx8qs9/g2cSw
 uXE59of+J09fsWOWvP2yk8VPDK7Jt+X9uVFk+/ppDG9NnhLXDZfQXw/Z9ZzUzj2Kdfm5ag53
 0nNNcYYgWcclT9fwPzKRjnX+c93606f0xNufz5YwpobGCJk6rJW77x5YsJ9z013jhl/eCo5K
 LMUZiYZazEXFiQCvAdvc+wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t/xu7p6b+SSDQ7N1rOYfljRYv2pY8wW
 q+/2s1lM+/CT2eL32fPMFnvfzWa1uHlgJ5PFnkWTmCxWrj7KZPFk/Sxmi79d95gs9t7Stri8
 aw6bxfxlT9ktJrR9Zba4MeEpo8XnpS3sFmtuPmWxOHFL2kHY4/IVb4+ds+6ye1w+W+qxaVUn
 m8fmJfUeu282sHnsbL3P6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPlJ5NUX5pSapCRn5x
 ia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7G36ntTAVXRSqeTXjF1sA4
 S7CLkYNDQsBE4mZjShcjJ4eQwFJGiTMXckFsCQEJidsLmxghbGGJP9e62LoYuYBqnjNKPLx2
 gBWkl01AS6Kxkx2kRkQgV+Lzyh9gNcwCs5glvkw6xASSEBZIkGie2cYGYrMIqEps2TYJLM4r
 YCnR93saK8QCeYmZl76DDeIUsJJ4vaqVEeIgS4mz326wQ9QLSpyc+YQFxGYGqm/eOpt5AqPA
 LCSpWUhSCxiZVjGKpJYW56bnFhvqFSfmFpfmpesl5+duYgRG8LZjPzfvYJz36qPeIUYmDsZD
 jBIczEoivCyG0slCvCmJlVWpRfnxRaU5qcWHGE2B7p7ILCWanA9MIXkl8YZmBqaGJmaWBqaW
 ZsZK4ryeBR2JQgLpiSWp2ampBalFMH1MHJxSDUyMwefPHo5+5nDQQYhxwpFFVzInPmv7s55h
 pcYShqDkTZJie7e9+Lpb2f2pYmH6+rnPztgrG8oqpc8WXXjkltXuLZtOvz+bfKHr2U83s6k1
 TsffRRyMjG66yi9Wse7I18OJ0i5ya9kkT6h+sEhs3Hz04PrJ2p9P6iVq35v3bEFt2a/gQ8f5
 ZJM3XlFTVN4/32bDj0lPzdf8K7xzmeE/a7BK+Zb5OlfUzxzrjNsmFyd2p2Zzhv51rUO+zme3
 igcXf2fvs923kbV6DYvgoWbf1HXXw4/Vrb0Qsf750b9F+YuTMzb+j27Xf3nh1MT9R9YvWRwi
 OeGFYOUt52dbb+xJXMns+dhWVv/pt8N6aZUhkZmeR5VYijMSDbWYi4oTAWwtWAxpAwAA
X-CMS-MailID: 20220912082206eucas1p25336d07279850f7009be6b5d1fccf558
X-Msg-Generator: CA
X-RootMTR: 20220912082206eucas1p25336d07279850f7009be6b5d1fccf558
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082206eucas1p25336d07279850f7009be6b5d1fccf558
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082206eucas1p25336d07279850f7009be6b5d1fccf558@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v13 01/13] block: make bdev_nr_zones and
 disk_zone_no generic for npo2 zone size
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
 dm-devel@redhat.com, Adam Manzanares <a.manzanares@samsung.com>,
 gost.dev@samsung.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Adapt bdev_nr_zones and disk_zone_no functions so that they can
also work for non-power-of-2 zone sizes.

As the existing deployments assume that a device zone size is a power of
2 number of sectors, power-of-2 optimized calculation is used for those
devices.

There are no direct hot paths modified and the changes just
introduce one new branch per call.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c      | 13 +++++++++----
 include/linux/blkdev.h |  8 +++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a264621d4905..dce9c95b4bcd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -111,17 +111,22 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
  * bdev_nr_zones - Get number of zones
  * @bdev:	Target device
  *
- * Return the total number of zones of a zoned block device.  For a block
- * device without zone capabilities, the number of zones is always 0.
+ * Return the total number of zones of a zoned block device, including the
+ * eventual small last zone if present. For a block device without zone
+ * capabilities, the number of zones is always 0.
  */
 unsigned int bdev_nr_zones(struct block_device *bdev)
 {
 	sector_t zone_sectors = bdev_zone_sectors(bdev);
+	sector_t capacity = bdev_nr_sectors(bdev);
 
 	if (!bdev_is_zoned(bdev))
 		return 0;
-	return (bdev_nr_sectors(bdev) + zone_sectors - 1) >>
-		ilog2(zone_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
+
+	return DIV_ROUND_UP_SECTOR_T(capacity, zone_sectors);
 }
 EXPORT_SYMBOL_GPL(bdev_nr_zones);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b13fdd34a7..ab82d1ff0cce 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -674,9 +674,15 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 
 static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 {
+	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
+
 	if (!blk_queue_is_zoned(disk->queue))
 		return 0;
-	return sector >> ilog2(disk->queue->limits.chunk_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return sector >> ilog2(zone_sectors);
+
+	return div64_u64(sector, zone_sectors);
 }
 
 static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

