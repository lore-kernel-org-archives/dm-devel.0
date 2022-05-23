Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2314DC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 16:16:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-iDpu-fJtPcegiGr2rQv0ug-1; Mon, 23 May 2022 12:16:25 -0400
X-MC-Unique: iDpu-fJtPcegiGr2rQv0ug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 326E32919EAA;
	Mon, 23 May 2022 16:16:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E5652026D6A;
	Mon, 23 May 2022 16:16:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DEC9B194705A;
	Mon, 23 May 2022 16:16:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 614C31947059
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 16:16:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5387B40E6A4E; Mon, 23 May 2022 16:16:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DF4140E6A5D
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0072E85A5BC
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:17 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-fDwJCpvqNV6vcP7YP9f4kQ-1; Mon, 23 May 2022 12:16:15 -0400
X-MC-Unique: fDwJCpvqNV6vcP7YP9f4kQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523161613euoutp01eee73aa7a04bbf2490a5df49b0955ba8~xyB8M3wDg1912419124euoutp01q
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220523161613euoutp01eee73aa7a04bbf2490a5df49b0955ba8~xyB8M3wDg1912419124euoutp01q
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220523161612eucas1p1a9d5050929914d94c05669bd95e7e5c5~xyB66Yz_y1870118701eucas1p17;
 Mon, 23 May 2022 16:16:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id FA.7E.09887.C43BB826; Mon, 23
 May 2022 17:16:12 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220523161612eucas1p102a76ba431c934230309042521018915~xyB6eyhDU1546315463eucas1p1U;
 Mon, 23 May 2022 16:16:12 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523161612eusmtrp291363c1e24ed18c446c30856c864aca3~xyB6eBYUJ0219402194eusmtrp2L;
 Mon, 23 May 2022 16:16:12 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-21-628bb34c5ddf
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id AE.92.09522.B43BB826; Mon, 23
 May 2022 17:16:11 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220523161611eusmtip23dcc1d85f474d9be5b8476ac221bd377~xyB6E6DfN0632306323eusmtip2G;
 Mon, 23 May 2022 16:16:11 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, hare@suse.de, Johannes.Thumshirn@wdc.com
Date: Mon, 23 May 2022 18:16:00 +0200
Message-Id: <20220523161601.58078-7-p.raghav@samsung.com>
In-Reply-To: <20220523161601.58078-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djP87o+m7uTDJ7skrFYfbefzeL32fPM
 Fq3t35gs9r6bzWpx4Ucjk8XNAzuZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x5Q3S1ti8u7
 5rBZzF/2lN3i89IWdou2jV8ZHQQ8/p1Yw+Zx+Wypx6ZVnWwem5fUe+y+2cDmsbP1PqvH+31X
 2Tz6tqxi9Fi/5SqLx+bT1R6fN8l5tB/oZgrgieKySUnNySxLLdK3S+DK6OiexViwXrBi+6F2
 9gbG63xdjBwcEgImEpe3m3cxcnEICaxglOi+94EZwvnCKPH36z12COczo8TqbxuZuhg5wTpu
 ndnDBpFYzigxc+psFgjnBaNE//53rCBz2QS0JBo7wbpFBBoZJd4fnccK4jALzGWSWHvyDyPI
 KGGBKInNBx+AjWURUJWY3HeOBcTmFbCU2PbsPRvEOnmJmZe+s4PYnAJWEtevXmWDqBGUODnz
 CVg9M1BN89bZYIdLCKzmlOj/dZ8VotlFYkHnJRYIW1ji1fEt7BC2jMT/nfOh/qmWeHrjN1Rz
 C9ALO9ezQYLGWqLvTA6IySygKbF+lz5EuaPEn5vtrBAVfBI33gpCnMAnMWnbdGaIMK9ER5sQ
 RLWSxM6fT6CWSkhcbpoDdYyHxM8FL1knMCrOQvLMLCTPzELYu4CReRWjeGppcW56arFRXmq5
 XnFibnFpXrpecn7uJkZgCjz97/iXHYzLX33UO8TIxMF4iFGCg1lJhHd7YkeSEG9KYmVValF+
 fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBiaZvP8nax5Y2ESoV/XqOPA8
 8NBYoX4w4YNRz9U/XpaXF6rOeMHJ/WyjY+O/6vYXZyXu7Dkk80ybK7E/Lu62vuwZxx6GNmO/
 3FM+Ci7etm4Hfz0rsuOfJud11mbGMvdM1h06vfeVZwSGWyU6GZ3Te79RXEBspvWXr76xqq8z
 42dcDDWbOP+mYGu/lc5P//BN3YeD/79XCvOJ7GnnfaBqtCog8q35RPcu90WW5+sqOUVfGytP
 LdhxN4Azwv2hXPGz/asNz91I/bp35YPCbfveBQct2hj+3YnreU2a9IzKpn2vWGPrU4y/Kat/
 638Zx6xuGvRNI/nh1TsTz6VaCaVtd5/V8+bThDWvouZvSf82W4mlOCPRUIu5qDgRAEQcSJjw
 AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xe7rem7uTDD5st7JYfbefzeL32fPM
 Fq3t35gs9r6bzWpx4Ucjk8XNAzuZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x5Q3S1ti8u7
 5rBZzF/2lN3i89IWdou2jV8ZHQQ8/p1Yw+Zx+Wypx6ZVnWwem5fUe+y+2cDmsbP1PqvH+31X
 2Tz6tqxi9Fi/5SqLx+bT1R6fN8l5tB/oZgrgidKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx
 1DM0No+1MjJV0rezSUnNySxLLdK3S9DL6OiexViwXrBi+6F29gbG63xdjJwcEgImErfO7GHr
 YuTiEBJYyihxYfZaVoiEhMTthU2MELawxJ9rXVBFzxglLn3qZepi5OBgE9CSaOxkB4mLCHQy
 ShxdcYoFxGEWWMkkMe/wViaQbmGBCInFPceYQWwWAVWJyX3nWEBsXgFLiW3P3rNBbJCXmHnp
 OzuIzSlgJXH96lWwuBBQzan1E9gh6gUlTs58AtbLDFTfvHU28wRGgVlIUrOQpBYwMq1iFEkt
 Lc5Nzy021CtOzC0uzUvXS87P3cQIjNdtx35u3sE479VHvUOMTByMhxglOJiVRHi3J3YkCfGm
 JFZWpRblxxeV5qQWH2I0Bbp7IrOUaHI+MGHklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJpCeW
 pGanphakFsH0MXFwSjUwGX6aZ7Qlbrle4tei6mNrW/fYFZbmNm+M+3uDL3kBk9bJ8FUMe3XW
 7f0e8O1IzfUTa3ay8DBM3rjecWtiptbkwleHOCUu9AfFse7OudS+lNU3+8uh0nz3FTF/zMpF
 ZVz+ZR327yj7phozSV/Lao6t5876Ne8kLt66w9Grafom5+XpNyruPjvTKqSvvvw8W6Cua8Ju
 TuFPyX+ZTRpETEz/lF0vE1J4d/rg0tMO3WWbXFoby0X/LO4/ERUdMv/vyb4uL8Y/Mgt+WRtt
 NfpzZEvf2VWZxk87dp4JVC8M4uiK5Pfc7uEzSSplkXjxjEel5z6q6pU7+3J8WB317LhRocx3
 2Uc8a1aGKk7b+fLuvu8PlFiKMxINtZiLihMBPcXgGmADAAA=
X-CMS-MailID: 20220523161612eucas1p102a76ba431c934230309042521018915
X-Msg-Generator: CA
X-RootMTR: 20220523161612eucas1p102a76ba431c934230309042521018915
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161612eucas1p102a76ba431c934230309042521018915
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161612eucas1p102a76ba431c934230309042521018915@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v5 6/7] null_blk: use zone_size_sects_shift for
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
 Damien Le Moal <damien.lemoal@wdc.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/null_blk.h |  6 ++++++
 drivers/block/null_blk/zoned.c    | 10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 78eb56b0ca55..3d6e41a9491f 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -74,6 +74,12 @@ struct nullb_device {
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
index 00c34e65ef0a..806bef98ac83 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -13,8 +13,8 @@ static inline sector_t mb_to_sects(unsigned long mb)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
-	if (is_power_of_2(dev->zone_size_sects))
-		return sect >> ilog2(dev->zone_size_sects);
+	if (dev->zone_size_sects_shift)
+		return sect >> dev->zone_size_sects_shift;
 
 	return div64_u64(sect, dev->zone_size_sects);
 }
@@ -82,6 +82,12 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
+
+	if (is_power_of_2(dev->zone_size_sects))
+		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
+	else
+		dev->zone_size_sects_shift = 0;
+
 	dev->nr_zones =
 		div64_u64(roundup(dev_capacity_sects, dev->zone_size_sects),
 			  dev->zone_size_sects);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

