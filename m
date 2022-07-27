Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76BDC19F2C
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658940842;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sVNMamHo/byeg4V1qNX44lrQa2WD2LVspGDpdcUKdEs=;
	b=bJZtyTyK+3ZNnreMI+C46Kw2f9d8G32U6GF0urh/sq5e3I4WLevyoJXsvQbcEpwXWtqCIX
	bYQmqiGlZdU0RRvZiOEiMY5iMKYibhzwXlzsITL0Oeeo6CsD87TxzsaVSldYXPEFALmNT8
	thtaT2H1Ink5aBttaj/617B4yFPbxRg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-sb2M1UWxNiOw2V85-pQ4Fw-1; Wed, 27 Jul 2022 12:54:01 -0400
X-MC-Unique: sb2M1UWxNiOw2V85-pQ4Fw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85D05805AF5;
	Wed, 27 Jul 2022 16:53:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74E201121314;
	Wed, 27 Jul 2022 16:53:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39AFD1945DAB;
	Wed, 27 Jul 2022 16:53:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 540C71945DBA
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:32:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24DE0400DEF8; Wed, 27 Jul 2022 16:32:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 208DC40CF8E2
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0008E18A653F
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:39 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-KYyfPGw2OEiDQAnvVuX7Vg-1; Wed, 27 Jul 2022 12:32:36 -0400
X-MC-Unique: KYyfPGw2OEiDQAnvVuX7Vg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162257euoutp023b50b038aa2015ed6cdc0b6a22498dd2~FvDYGbNtm1023510235euoutp02D
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220727162257euoutp023b50b038aa2015ed6cdc0b6a22498dd2~FvDYGbNtm1023510235euoutp02D
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162256eucas1p26353ef138695507e6f8643aeaede4e78~FvDWuiFFY2169421694eucas1p2t;
 Wed, 27 Jul 2022 16:22:56 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id B2.C3.09664.06661E26; Wed, 27
 Jul 2022 17:22:56 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220727162255eucas1p2945c6dca42b799bb3b4abf3edb83dde8~FvDWEgher2238722387eucas1p2k;
 Wed, 27 Jul 2022 16:22:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220727162255eusmtrp1e5f37af38464571ccadbe3d2a13e71c3~FvDWDv6y10298902989eusmtrp1Q;
 Wed, 27 Jul 2022 16:22:55 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-f3-62e16660d0c6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id BA.8D.09038.F5661E26; Wed, 27
 Jul 2022 17:22:55 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162255eusmtip25fb2b24fbcb9d0862c628cfdc10559a5~FvDVtuT4W2868528685eusmtip2J;
 Wed, 27 Jul 2022 16:22:55 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:43 +0200
Message-Id: <20220727162245.209794-10-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7djPc7oJaQ+TDA5/F7VYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8XnpS3sFmtuPmWxOHFL2kHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPFJdNSmpOZllqkb5dAlfGh8u8Be95KjqfT2Vp
 YJzP1cXIySEhYCJxYWcraxcjF4eQwApGiZ4zR9ggnC+MEh/fz2OEcD4zSjxpXMEI0zLh3Xom
 iMRyRonnj6+wQzjPGSU+b7gB1M/BwSagJdHYyQ7SICJQLPHwXSsLSA2zwCwmidPHHjODJIQF
 7CVaJu9hBbFZBFQlFizeDRbnFbCW2LtuEzvENnmJmZe+g9mcQPHNU+YxQdQISpyc+YQFxGYG
 qmneOpsZZIGEwGJOicWbp0Kd6iJxaGonK4QtLPHq+BaooTISpyf3sEDY1RJPb/yGam5hlOjf
 uR7sAwmgbX1nckBMZgFNifW79CHKHSWuHt/FAlHBJ3HjrSDECXwSk7ZNZ4YI80p0tAlBVCtJ
 7Pz5BGqphMTlpjlQSz0kvt6dyDiBUXEWkmdmIXlmFsLeBYzMqxjFU0uLc9NTiw3zUsv1ihNz
 i0vz0vWS83M3MQKT3+l/xz/tYJz76qPeIUYmDsZDjBIczEoivAnR95OEeFMSK6tSi/Lji0pz
 UosPMUpzsCiJ8yZnbkgUEkhPLEnNTk0tSC2CyTJxcEo1MPks2n0tsC7irciUrgt7ZoeaN+3K
 eOAn1PEj8+fzo3zxMwWm6NcKau55pcGt/O0Gt2nt3sqv1p/ZmLIPRx2wkX3LeW6WtdhGgXN/
 i7nvOvzRmlW5+MTfmtmmIk1ye7kU3iXMe7BMPObkjJwVsxf07p/B8XRyzYKZzHkXpJ2ZLM6e
 8dviwB4wM+TvhttfS6yCxH3D2lY0H5u8cbVR3HXxQ97fCxqimK1+7GF+JLL66oVFSdt+3wtw
 Od/g6LOW8/Fm76qjIYWvi74YZijP8pWYs1OprT0g43XI2/JvLY9CZ2lHadh398n46wWmnJiw
 1Nb+ecvzfx6zEgKl5/sqBB12ubcwspIh3cGN++ych5/dXyuxFGckGmoxFxUnAgCDdvwC7QMA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t/xe7rxaQ+TDGZd0LBYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8XnpS3sFmtuPmWxOHFL2kHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYml
 nqGxeayVkamSvp1NSmpOZllqkb5dgl7Gh8u8Be95KjqfT2VpYJzP1cXIySEhYCIx4d16pi5G
 Lg4hgaWMElc3/maHSEhI3F7YxAhhC0v8udbFBlH0lFHi8vUFQAkODjYBLYnGTnYQU0SgUuLs
 F1mQcmaBZUwSG07IgNjCAvYSLZP3sILYLAKqEgsW72YGsXkFrCX2rtsEtUpeYual72A2J1B8
 85R5TCC2kICVxLMHH9kg6gUlTs58wgIxX16ieets5gmMArOQpGYhSS1gZFrFKJJaWpybnlts
 pFecmFtcmpeul5yfu4kRGKPbjv3csoNx5auPeocYmTgYDzFKcDArifAmRN9PEuJNSaysSi3K
 jy8qzUktPsRoCnT3RGYp0eR8YJLIK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1I
 LYLpY+LglGpgcmV1lD9VWXhgVtkRNovX3F/lCg+Emn24dtmwvUo4e4fE+58LxbskVqnZzVaQ
 OWpcd8RR/KJUfOvPXR784hFHJLy2L1Ltc+vv9/r+WPr0jWhRGcON/B/efS5Y9XXxobcNOdqr
 GZl+rvJYaXvXlz+Fo9jj66WfVXxJZa+vXik5/3hLZ97RS+dOTWjQXfbB6tmpTa/mSpYns7qZ
 tGRsF9hy+N5xxTdv/LVeTj2Z2in778nz/YX529MWyxa4TF2xV5Nr9YXg7VO2Jp356icS0h9+
 P7FJTrA0d5n1rGc777PFOfjlPz8QM0vrlkqUxW/eV2x3BXlF10+fumC5cO3XmcVar+v+Lbyr
 ypa84+7Jw5JqUkosxRmJhlrMRcWJAGBR6RRaAwAA
X-CMS-MailID: 20220727162255eucas1p2945c6dca42b799bb3b4abf3edb83dde8
X-Msg-Generator: CA
X-RootMTR: 20220727162255eucas1p2945c6dca42b799bb3b4abf3edb83dde8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162255eucas1p2945c6dca42b799bb3b4abf3edb83dde8
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162255eucas1p2945c6dca42b799bb3b4abf3edb83dde8@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v8 09/11] dm-table: allow non po2 zoned devices
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
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

As the block layer now supports non po2 zoned devices, allow dm to
support non po2 zoned device.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-table.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 332f96b58252..534fddfc2b42 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -250,7 +250,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (start & (zone_sectors - 1)) {
+		if (!bdev_is_zone_aligned(bdev, start)) {
 			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)start,
@@ -267,7 +267,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (!bdev_is_zone_aligned(bdev, len)) {
 			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)len,
@@ -1642,8 +1642,8 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 		return -EINVAL;
 	}
 
-	/* Check zone size validity and compatibility */
-	if (!zone_sectors || !is_power_of_2(zone_sectors))
+	/* Check zone size validity */
+	if (!zone_sectors)
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

