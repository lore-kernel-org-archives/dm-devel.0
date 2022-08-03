Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A834C25B0C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520102;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P2ijAOrj3EQvRt8HEUH68Cr49EMwEqwYN1C1f0Kv7Ww=;
	b=hk2uEPibDytXm+bcKvS//ZHRLINd1/dvBdvVPen9Agwma7+IZDcrVIICGWpdqftEjHIZx4
	w70IgWpS2mTmf3oQuzvoEDVvDufMXaAM8wsGaaRRZuCemHrevN+uBAHqJjo24Bmapjxhj0
	PCJBi0DaSeCmyojy75ucn3V5ns5efn8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-uYmNlpwjNmqdQ_WmBQ2otA-1; Wed, 03 Aug 2022 05:48:21 -0400
X-MC-Unique: uYmNlpwjNmqdQ_WmBQ2otA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7C21802D2C;
	Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D309C90A04;
	Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 93A9C1946A52;
	Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D8A801946A5E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD0CA40CFD0A; Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B897E40CF8F0
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2BB31019C95
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-sFFFTCF6OCi1_-QhYMjoQg-1; Wed, 03 Aug 2022 05:48:16 -0400
X-MC-Unique: sFFFTCF6OCi1_-QhYMjoQg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094815euoutp02b0a6c9319d58db99f05bd4f3a474bd82~HzLwRkIB32085520855euoutp02C
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220803094815euoutp02b0a6c9319d58db99f05bd4f3a474bd82~HzLwRkIB32085520855euoutp02C
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094813eucas1p298cfe017fbfdca6d5c606989f4a95a2e~HzLucPuni2470524705eucas1p2s;
 Wed,  3 Aug 2022 09:48:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 37.03.09580.D544AE26; Wed,  3
 Aug 2022 10:48:13 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220803094813eucas1p2eab78901e97417ad52be1f8023db3d82~HzLt5TeNj2471024710eucas1p2t;
 Wed,  3 Aug 2022 09:48:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220803094813eusmtrp236987c6f523104e1e5ca3c0b8fa8741c~HzLt4bV-v0985709857eusmtrp2v;
 Wed,  3 Aug 2022 09:48:13 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-2a-62ea445daf58
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 93.EB.09095.D544AE26; Wed,  3
 Aug 2022 10:48:13 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094812eusmtip235cf51eca89103da97520a59ca801576~HzLtdCtG01623516235eusmtip2n;
 Wed,  3 Aug 2022 09:48:12 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:58 +0200
Message-Id: <20220803094801.177490-11-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7djPc7qxLq+SDNZ161isP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFp+XtrBbrLn5lMXixC1pB0GPy1e8PXbOusvucflsqcemVZ1sHpuX1HvsvtnA
 5rGz9T6rx/t9V9k8+rasYvTYfLra4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBlfjvSwFFzk
 qXhw6SxbA2MnVxcjJ4eEgInEjnvN7F2MXBxCAisYJRZs74FyvjBKzLjWyArhfGaUWPTxFxNM
 S/u9OUwQieWMEvuOr4aqeskocadtL1sXIwcHm4CWRGMn2CgRgWZGibt/e8CKmAVmMEl0fOxj
 ARklLBAhceP8O7CxLAKqEldnbgSzeQWsJf5M28YGsU5eYual7+wgNidQfMq/f8wQNYISJ2c+
 AZvDDFTTvHU2M8gCCYHNnBIz+p4wQjS7SEz/9YkVwhaWeHV8CzuELSPxf+d8qH+qJZ7e+A3V
 3MIo0b9zPdgLEkDb+s7kgJjMApoS63fpQ5Q7SvycM40VooJP4sZbQYgT+CQmbZvODBHmleho
 E4KoVpLY+fMJ1FIJictNc1ggbA+Jew8ns05gVJyF5JlZSJ6ZhbB3ASPzKkbx1NLi3PTUYuO8
 1HK94sTc4tK8dL3k/NxNjMBUePrf8a87GFe8+qh3iJGJg/EQowQHs5II7x2X50lCvCmJlVWp
 RfnxRaU5qcWHGKU5WJTEeZMzNyQKCaQnlqRmp6YWpBbBZJk4OKUamPrzZe99EFYvjbD1KHL5
 4LLVcMazPIUbIgoL9mn89jWbfb1kr3m7J5t81E+fjo+fzVs7ZHMWrf+YYRi1yPBlS8K6Px2y
 IQq/3x3KUbtSWfSJTaxgm8PC1Wu0dDWnuImqM29Pm3Li2J/ASfPeq+4qbXjj0f9hYbtWoHpr
 t+89Nv3Evd9XnNWv8mk4Nvt14crgmiPz0254/eaRu/GiTPjrAqE4JrYE4dsZkoppnPK/lU68
 u53AdjH/6Pv6GlGLuPKf2WtnSfxzuCX8reOiyIvz/1nVuX91nA35rnJ0w+uE6vJte+T2/mLb
 /urvKaee6xPXbYq8OEcsVs68+uzOj6fnrP0ep/9p7+b+eTc0f2w326vEUpyRaKjFXFScCABy
 XoX79AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/xe7qxLq+SDNZP57FYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DK+HOlhKbjIU/Hg0lm2BsZOri5GTg4JAROJ
 9ntzmLoYuTiEBJYySsxau5gFIiEhcXthEyOELSzx51oXG0TRc0aJhjsHWLsYOTjYBLQkGjvZ
 QeIiAt2MEpfPnGMFcZgFljFJNH25zgZSJCwQJrH4exXIIBYBVYmrMzcygdi8AtYSf6ZtY4NY
 IC8x89J3dhCbEyg+5d8/ZhBbSMBKYt3fWawQ9YISJ2c+ATuOGai+eets5gmMArOQpGYhSS1g
 ZFrFKJJaWpybnltsqFecmFtcmpeul5yfu4kRGLPbjv3cvINx3quPeocYmTgYDzFKcDArifDe
 cXmeJMSbklhZlVqUH19UmpNafIjRFOjuicxSosn5wKSRVxJvaGZgamhiZmlgamlmrCTO61nQ
 kSgkkJ5YkpqdmlqQWgTTx8TBKdXA1KNx4/0D7+4L58O0d9+y5FIq9Tdf0H5/Uh3XwZyyZ2q+
 F+ytfaevTj0Q/+nofN2QFdK2EbvKpKaUdWh6eQUG6va4HPqylYlv0tsAYPqaf8BY4OX5aRcd
 6hKsJnM9kOdPLjwpNvvoX0HNum3KZRPF63X3TOAM2LW/vO0pe6R46PHWoMdv01jK3OJuhiUk
 SAZ+yz1qpT3BbL7XwnCBw3uO3vteffT++y9Hm+t/VUqvVTz4UfyE448oNg/T6n+czMFrGCKd
 2L3/HnxjlPb18IXZH/IzH/X/W8L+QO3EweW8l48EO04tvGfINKNidtCMw0qbJ8Tvvax3b+5F
 u6lSJRem/mLR/C0dfnlS7JwgRlFpJZbijERDLeai4kQAvr79AmIDAAA=
X-CMS-MailID: 20220803094813eucas1p2eab78901e97417ad52be1f8023db3d82
X-Msg-Generator: CA
X-RootMTR: 20220803094813eucas1p2eab78901e97417ad52be1f8023db3d82
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094813eucas1p2eab78901e97417ad52be1f8023db3d82
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094813eucas1p2eab78901e97417ad52be1f8023db3d82@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v9 10/13] dm-table: allow zoned devices with non
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
the block layer now supports it.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-table.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 332f96b58252..31eb1d29d136 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -250,7 +250,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (start & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, start)) {
 			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)start,
@@ -267,7 +267,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, len)) {
 			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)len,
@@ -1642,8 +1642,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 		return -EINVAL;
 	}
 
-	/* Check zone size validity and compatibility */
-	if (!zone_sectors || !is_power_of_2(zone_sectors))
+	if (!zone_sectors)
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

