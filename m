Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C4EC6FA8E
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665100;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FeXsgVSaKTlZ8GW+gCZFeY2z0WmxRw8Xh22VzpvV2Mo=;
	b=iY47xAVonMF7kw2yFrImV14dbLRjHrebnGAG1+bd0mANAWAZQhSo60CgXFCIxfA7I31OVE
	VjwlrUrq88CGkvHVhTYqBb7vfobcIj0wfJGf4dBxVyE9FI2b+Ve78zI9O3hwh1WkV5s6ps
	VyP8K+hCQ2q78f/EC7fMGWg38FIbAtA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-O7DpAfALNQ62imNlWMWetg-1; Tue, 20 Sep 2022 05:11:36 -0400
X-MC-Unique: O7DpAfALNQ62imNlWMWetg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A421C8027F5;
	Tue, 20 Sep 2022 09:11:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 910A61759F;
	Tue, 20 Sep 2022 09:11:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D16919465A3;
	Tue, 20 Sep 2022 09:11:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D33AE19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4C551121315; Tue, 20 Sep 2022 09:11:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACF7E1121314
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E0C93C0D84A
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:32 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-2mkOaS3yPLaFlSPKjd2G_w-1; Tue, 20 Sep 2022 05:11:30 -0400
X-MC-Unique: 2mkOaS3yPLaFlSPKjd2G_w-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091129euoutp01e8ae5c97218bd5f2302df248090c3ca3~WhpWnPGBV1236612366euoutp01d
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220920091129euoutp01e8ae5c97218bd5f2302df248090c3ca3~WhpWnPGBV1236612366euoutp01d
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091127eucas1p2bfde5f6f6da6da9046b3c015edb3f0b9~WhpUdi2_A2443624436eucas1p22;
 Tue, 20 Sep 2022 09:11:27 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 16.98.19378.FB389236; Tue, 20
 Sep 2022 10:11:27 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091126eucas1p2e2665221ea346937bff44c9fd6963928~WhpTxSxyC3137931379eucas1p2B;
 Tue, 20 Sep 2022 09:11:26 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220920091126eusmtrp2176399f34cf723dc15a739cce07e14be~WhpTvlI2H2425424254eusmtrp2d;
 Tue, 20 Sep 2022 09:11:26 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-bb-632983bfe2b7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 13.0E.07473.EB389236; Tue, 20
 Sep 2022 10:11:26 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091126eusmtip116ced0f784749a0c8a090aad914fac0b~WhpTbzA2l1070710707eusmtip1o;
 Tue, 20 Sep 2022 09:11:26 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:12 +0200
Message-Id: <20220920091119.115879-7-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUxTdxTd7732tZCUPFsmd3zMWMUFF0Eim2+wLINg9gIs0xm3zD/GuvJW
 CrS4lk42zVakMMCtNpCgFhaMH6DUpayUjiJ+AOWzEDY6stbFMV3rsAoyO9Smilt5NfO/c+89
 555zk8vHhXe48Xy5soJRKSVlYiKaYxsJTm+5XJ0i3dpsFVLmiRGcMl07QlDNS0GcCk1N49TF
 xRYu5blix6j+k40Ydc40jFFesxGnHjf8jlG+WSNGXbz6MuXqayWotnYfjzLULuOU2+BDVOCM
 jked9/g41NjVhDdFtOuXfNpuvMajXVMa2tJZT9Ddp7+iL3i0BP1t9SJB22vmuPTdS7MErbd2
 IrrbeYAOWF6kv75yGNsp2Bv9ehFTJv+MUaW98VF0cZXhEb7Pn1g51hPCtKgPGlAUH8gMaKmf
 5DSgaL6QPIvgu/PBSPEPghuXeyNFAIF+6C/OU8nhJgPBDjoQ+PROFB4IyVsIXENbGhCfT5Cb
 oaqeF27HkjJYXu5apeCkDYfT84owFpEfwMycnghjDpkM3cFfVzkCMhNGT56LeK2D4zMPVvdE
 kVnQekFHsJw1MH7cy2F3roPqnhY8nAfIoSi4O+DmhjMAmQuWRim7RwT+USuPxYnwxN6GsfgA
 +NyhiFaH4IjdTLDaLNBPloUhTqaAuS+NpWeDo2cJZxkx4F5YwyaIgUbb0UhbAHW1QpYtBnvQ
 GzEFcB1qjRxFg8Pi5RrQeuMztxifucX4v+8JhHeiOEajVsgY9TYlsz9VLVGoNUpZqrRcYUH/
 PaRzZXS5F531/506iDA+GkTAx8WxAt07KVKhoEjy+ReMqrxQpSlj1IMogc8Rxwmk8i6JkJRJ
 KphShtnHqJ5OMX5UvBbLshfqEhK7fhLbNvUH/fGVI6/ZqkuOiW6tLQrG5uwt6Mh5SB86+HzS
 dSjMypA8ouX5OTUT9vXjKpS5dC+pA3Z4bbsN+vStudkrj3+sSspr2mmaXOj2Z0gIbmlbclpd
 79q3bgzvf5Jr2eRIl3fU1u/6RmDRWP9ods17ZLPH8hxzue9v3LCrpHT7/ZSPraT2Ejr455cF
 7TdfLSi2tWd+OPBDKjzXuMP9m3ZGZG26NxxaTFtYeal1W69xcuLt0KCp31Qx9d54MvHupzUv
 fHLm/gan7IRi+/XpjeI7HuX3ELh99JXC/kBdpUPz881TbXnlpwbmSyayVXHmPTG3H0xi+Rzn
 2EMxR10sSd+Mq9SSfwEtLBHl/wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t/xu7r7mjWTDW7cVrBYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UXo2Rfml
 JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZjRP+MBe8kqk4
 sfU3UwPjLokuRk4OCQETie7JE9i6GLk4hASWMkp8fbqQBSIhIXF7YRMjhC0s8edaF1TRc0aJ
 f23vmLsYOTjYBLQkGjvZQWpEBHIlDm+ewARSwyxwjFni7JmDYIOEBcIlDk6awwxiswioSmz+
 eR1sKK+AlcTxRSuhlslLzLz0HWwQp4C1xJzdLWwgthBQTceszWwQ9YISJ2c+AatnBqpv3jqb
 eQKjwCwkqVlIUgsYmVYxiqSWFuem5xYb6hUn5haX5qXrJefnbmIERvS2Yz8372Cc9+qj3iFG
 Jg7GQ4wSHMxKIrwt/prJQrwpiZVVqUX58UWlOanFhxhNge6eyCwlmpwPTCl5JfGGZgamhiZm
 lgamlmbGSuK8ngUdiUIC6YklqdmpqQWpRTB9TBycUg1MITJfXt75mFlhc+zn6n8mATvCD56P
 CH7XsI792BHDUM8zNuc/3p5ygC0xn22OrtWj39lsi3/rTzKI5P2alnjQhLOc/cNVxl3lmyy4
 ZNNjufna716NDDMTtjj7qODeoh2cYR6K6g1hf8+vntJ0e/J6vYbL00wa89oCJk5I+rk8jP/A
 /9fWDa5ungGXbxw8/G7vuTNteZPfu9Y7nHA+LveiJatYxEFAMJdtO59S3u24k1pJZ7anbIz2
 Nt8kXzpJ3uj2kxgeTneHQ9974qON3SOXrSmKTQ9xLgr4lTZb6fzs1sbpVkyz+v43T41z4y06
 tPxDitpHyR/7BNfG5pxaftRjZor06//TDmd8f2RQvv2zEktxRqKhFnNRcSIAYkOasnEDAAA=
X-CMS-MailID: 20220920091126eucas1p2e2665221ea346937bff44c9fd6963928
X-Msg-Generator: CA
X-RootMTR: 20220920091126eucas1p2e2665221ea346937bff44c9fd6963928
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091126eucas1p2e2665221ea346937bff44c9fd6963928
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091126eucas1p2e2665221ea346937bff44c9fd6963928@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v14 06/13] null_blk: allow zoned devices with non
 power-of-2 zone sizes
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the power-of-2(po2) based calculation with zone size to be generic
in null_zone_no with optimization for po2 zone sizes.

The nr_zones calculation in null_init_zoned_dev has been replaced with a
division without special handling for po2 zone sizes as this function is
called only during the initialization and will not be invoked in the hot
path.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/main.c     |  5 ++---
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 18 +++++++++++-------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 1f154f92f4c2..3b24125d8594 100644
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
index 94ff68052b1e..f63b6bed1bb3 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -83,6 +83,7 @@ struct nullb_device {
 	unsigned int imp_close_zone_no;
 	struct nullb_zone *zones;
 	sector_t zone_size_sects;
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

