Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 839E1C19F2A
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520103;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pFZmg5OgK2CWY8b27rhkPhcTOKEq8EiWAQHdbmeHPCc=;
	b=Unj4Jeh/Gb5SgZ27Yk8YSA+9dNiv+ZGTUA8VszVuNxGhcpq+sl9yQech59Wd6WL/MxNiCE
	2uaCSM814jiYO91KRPgmN56zHlWSDNVTsF8W6k+5g6poI8tnEZ8nAUrWohqAt1D5T4HSsc
	Rb8W312Y4KfXdz6/qg6s70H83eB14S4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-ggPYZXmMNY6oEK8kvSA1CQ-1; Wed, 03 Aug 2022 05:48:20 -0400
X-MC-Unique: ggPYZXmMNY6oEK8kvSA1CQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBC385A58B;
	Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD19790A04;
	Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 842431946A60;
	Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9969A1946A50
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8D0DE403166; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 88D63492C3B
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71306185A7B2
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-2V1Buw4DNDS2JbZFbnZ1KA-1; Wed, 03 Aug 2022 05:48:15 -0400
X-MC-Unique: 2V1Buw4DNDS2JbZFbnZ1KA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094814euoutp0232c7c78b341cddacc69405904d4d80fa~HzLvBSRyj2040620406euoutp02o
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220803094814euoutp0232c7c78b341cddacc69405904d4d80fa~HzLvBSRyj2040620406euoutp02o
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094812eucas1p2bd850e62b8b1e5b102ce5cf367481d37~HzLti7ILc2471124711eucas1p2q;
 Wed,  3 Aug 2022 09:48:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id A3.03.09580.C544AE26; Wed,  3
 Aug 2022 10:48:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220803094812eucas1p271cea804453d9dd379b919067fe5b154~HzLs1fMOB1615116151eucas1p26;
 Wed,  3 Aug 2022 09:48:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220803094812eusmtrp1a4c85857281fce3a66bd62cdfdd094cf~HzLs0miIg2000320003eusmtrp1c;
 Wed,  3 Aug 2022 09:48:12 +0000 (GMT)
X-AuditID: cbfec7f5-9adff7000000256c-27-62ea445c55ce
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id A8.9B.09038.C544AE26; Wed,  3
 Aug 2022 10:48:12 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094811eusmtip2c6b37f361d28822a8c01f5e0fb4f3c34~HzLsg0_a31632116321eusmtip2w;
 Wed,  3 Aug 2022 09:48:11 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:57 +0200
Message-Id: <20220803094801.177490-10-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7djP87oxLq+SDI53GVusP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InisklJzcksSy3St0vgyph9
 t42toJ+74vPL6cwNjBM5uxg5OSQETCQ+rW9l6mLk4hASWMEocWRTJyNIQkjgC6PEjH2xEInP
 jBKT975mhelofnuUESKxnFFi87ImVgjnJaNE/4oWoAwHB5uAlkRjJztIXESgmVHi7t8esCJm
 gQNMEje33GICGSUsECMx+dJJsH0sAqoSsx4vYwGxeQWsJa7Oa4daJy8x89J3dhCbEyg+5d8/
 ZogaQYmTM5+A1TMD1TRvnc0MskBCYDenxPx1cxghml0kuq5dYIewhSVeHd8CZctInJ7cwwJh
 V0s8vfEbqrkF6IWd69lAXpAA2tZ3JgfEZBbQlFi/Sx+i3FFi09kNTBAVfBI33gpCnMAnMWnb
 dGaIMK9ER5sQRLWSxM6fT6CWSkhcbpoDtdRD4uP85SwTGBVnIXlmFpJnZiHsXcDIvIpRPLW0
 ODc9tdg4L7Vcrzgxt7g0L10vOT93EyMwJZ7+d/zrDsYVrz7qHWJk4mA8xCjBwawkwnvH5XmS
 EG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBiY/y/o4kfrb
 js2WsuJ8B4MfHfnr1F4vuTpSy+r62ffT1Tx6lzkZ6hxzLakS91oqMe2SfGBL6+eyXq/k3Sc6
 8t77F3oqlsiUxJolzFuwVOO8Vtv0J9XzVH+eEi7f9/5a4okEf7fbKT/mFO47ffSVrvN/ucUX
 Ex9K6r+11OffcfXLLfO3Xfa3drJu6+t34RCte/pj8/FGs7fmlTaVNtcvnj79VS6Ev//jM3sn
 btWYtjqFX4o3mOzuflq0OGDPxpnHpzR4VO29kdr5U2Gf/4YVsZwvt7/u07596PSkOt0ThZW/
 LWb0fqwNnr3xvt9e5vPc7QVCpY0nhYQT5e2yd+w8dNXa+674qd9lzBqiYcobbyuxFGckGmox
 FxUnAgBKj0DI+AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xe7oxLq+SDNp+M1usP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InSsynKLy1JVcjILy6xVYo2
 tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy5h9t42toJ+74vPL6cwNjBM5uxg5
 OSQETCSa3x5l7GLk4hASWMooserDSzaIhITE7YVNjBC2sMSfa11sEEXPGSX+PrzH2sXIwcEm
 oCXR2MkOEhcR6GaUuHzmHCuIwyxwjkliztMHYJOEBaIkFj39zQxiswioSsx6vIwFxOYVsJa4
 Oq+dFWKDvMTMS9/ZQWxOoPiUf//A6oUErCTW/Z3FClEvKHFy5hOwXmag+uats5knMArMQpKa
 hSS1gJFpFaNIamlxbnpusZFecWJucWleul5yfu4mRmD8bjv2c8sOxpWvPuodYmTiYDzEKMHB
 rCTCe8fleZIQb0piZVVqUX58UWlOavEhRlOguycyS4km5wMTSF5JvKGZgamhiZmlgamlmbGS
 OK9nQUeikEB6YklqdmpqQWoRTB8TB6dUA5Pj+jXduyYqpYi5BFtr7Nted+21X57+xfnOpnpL
 b02/sWnrAUfRaZcOM10V+HtAt/xpwcyEm1/5uCd/+i6j/bP09O070T/O1//b0XhaOG9FwsPo
 TzlOmpd0L9ucCdOuF33Be3tbR+ryoD3827gvMqw3s+dd0zTr/IRrD9xP9llMUdDkjkm+VChe
 WfJ4kfXSnkjxi8V+W4pM8z5d6Oi4Fel+vrXBI+L55+Xns+6pddff8lrPvfX/psVdPvO3rArf
 d6xP227fNL92xyTfO47Pp6pEzpR+45N8afOdhavPTeh8fUYj/F6c6u2G0/cWulbzTE57ezv+
 2EoJR8813l+tv6n+ONj57WvGOtV1vbxnTU6EKbEUZyQaajEXFScCAPgIuAloAwAA
X-CMS-MailID: 20220803094812eucas1p271cea804453d9dd379b919067fe5b154
X-Msg-Generator: CA
X-RootMTR: 20220803094812eucas1p271cea804453d9dd379b919067fe5b154
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094812eucas1p271cea804453d9dd379b919067fe5b154
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094812eucas1p271cea804453d9dd379b919067fe5b154@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v9 09/13] dm-zone: use generic helpers to
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
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
---
 drivers/md/dm-zone.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3dafc0e8b7a9..31c16aafdbfc 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -390,7 +390,9 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE:
 		/* Writes must be aligned to the zone write pointer */
-		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
+		if ((bdev_offset_from_zone_start(md->disk->part0,
+						 clone->bi_iter.bi_sector)) != zwp_offset)
+
 			return false;
 		break;
 	case REQ_OP_ZONE_APPEND:
@@ -602,11 +604,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
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

