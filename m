Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DD4C3F6B0
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658940841;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TuDdCL9Xa5qRLCfJ82Pm1xXpd/5ICp1rDFV7sG3z8Es=;
	b=NhOika0V9tgD+5ZC6uYFBPB56XpZJY25Uv8ZSm9fmg8hZezKl2dzwvR7O9hDEfePAtV6Gc
	e/PZLeWfGM4RrCTN61VYy1kwWejMJgStr5olRc3cHhk6JM61CP20LTM4VIkMGPrT4sMnDc
	YNDWN2rImjWy4hUMvRqnQYq3Bcw80Ys=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-lOqAyb8DPwmpJ_HdsGTUrg-1; Wed, 27 Jul 2022 12:53:58 -0400
X-MC-Unique: lOqAyb8DPwmpJ_HdsGTUrg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 478D629AB3FD;
	Wed, 27 Jul 2022 16:53:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29603400F8F0;
	Wed, 27 Jul 2022 16:53:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E9BA41945DAB;
	Wed, 27 Jul 2022 16:53:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B83E41947077
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B559400DEF8; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9745740CFD0A
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E0043C0D1A4
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:38 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-olUd1cHrPtaYAoksnCEj_A-1; Wed, 27 Jul 2022 12:32:36 -0400
X-MC-Unique: olUd1cHrPtaYAoksnCEj_A-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162256euoutp02df9c7ee6033bea82af5e7e74d498b987~FvDW1gU6M1245112451euoutp02o
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220727162256euoutp02df9c7ee6033bea82af5e7e74d498b987~FvDW1gU6M1245112451euoutp02o
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162255eucas1p270f1762da9a9d8a41d40bde0664f9b65~FvDVcfZl82220522205eucas1p28;
 Wed, 27 Jul 2022 16:22:55 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 28.E8.09580.F5661E26; Wed, 27
 Jul 2022 17:22:55 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220727162254eucas1p1fd990f746d9f9870b8d58ee0bd01fedd~FvDVEOET21345313453eucas1p1m;
 Wed, 27 Jul 2022 16:22:54 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220727162254eusmtrp1ea1f3eb33ea28187ca0b488efe6d40d1~FvDVCBW6T0298902989eusmtrp1P;
 Wed, 27 Jul 2022 16:22:54 +0000 (GMT)
X-AuditID: cbfec7f5-9adff7000000256c-e7-62e1665f73bc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 99.8D.09038.E5661E26; Wed, 27
 Jul 2022 17:22:54 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162254eusmtip16a6354516571bc22aef68af1faaca7ef~FvDUtVvM_0065000650eusmtip1G;
 Wed, 27 Jul 2022 16:22:54 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:42 +0200
Message-Id: <20220727162245.209794-9-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djPc7rxaQ+TDFZuZrZYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDLeXzzNWnCe
 q2L+j80sDYzXOboYOTkkBEwkLrcsYQexhQRWMEpMnSLWxcgFZH9hlJh46TAbhPOZUeJQ+1lm
 mI4PtyaxQiSWM0psnzaPCcJ5ziixc/kJoFkcHGwCWhKNnWBjRQSKJR6+a2UBqWEWOMAk8eB2
 CxtIjbBAjMSEpzkgNSwCqhJN226ygti8AlYSO/Z+glomLzHz0newOZwC1hKbp4DsAqkRlDg5
 8wkLiM0MVNO8dTZU/XpOieZFCRC2i8SHvnNQcWGJV8e3sEPYMhKnJ/ewQNjVEk9v/GYGuU1C
 oIVRon/nerDbJICW9Z3JATGZBTQl1u/Shyh3lNj04yUTRAWfxI23ghAX8ElM2jadGSLMK9HR
 JgRRrSSx8+cTqKUSEpeb5kAt9ZBof3eUbQKj4iwkv8xC8ssshL0LGJlXMYqnlhbnpqcWG+el
 lusVJ+YWl+al6yXn525iBKbA0/+Of93BuOLVR71DjEwcjIcYJTiYlUR4E6LvJwnxpiRWVqUW
 5ccXleakFh9ilOZgURLnTc7ckCgkkJ5YkpqdmlqQWgSTZeLglGpgUty+wlJ217rSvexOD5eG
 XHwWNt38yk7ecv8TsV7hvE5rYuqj3P7e614X3O5WvnkmX85ClVmCPwXeeuc+Mp/8b5a8vpvV
 aufQ/B9rq4uk837e+HJkQcX2XMeVIekeZsq/J7xnmyr4K37qvMx7eb8/qldVMPjfK3iiNZV/
 SmLOccFooylCNYFlL7Y0aij4WnIoXS7Tuylb+SQ1Nuqkfl+hQcZ/69LQVIu/p7cLde7SX9/1
 OLu6UGerzXFui4kaRmlHztdIP91w2aFurWmTTWRop/vUs9+WHdT3vnLayKvs5vdSQ/V7hQF/
 M6RuiMzRMTnSFLsl5FLy283TGafkKtb+nrLoPpvJxrNqrc+enstTYinOSDTUYi4qTgQARh0b
 a/ADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xu7pxaQ+TDOZPU7FYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLeXzzNWnCeq2L+j80sDYzXOboYOTkkBEwk
 PtyaxApiCwksZZS4s8wUIi4hcXthEyOELSzx51oXWxcjF1DNU0aJP3O3sXcxcnCwCWhJNHaC
 mSIClRJnv8iClDALnGOSuHnxGhtIr7BAlMSmL/eZQGwWAVWJpm03wXbxClhJ7Nj7iRlivrzE
 zEvf2UFsTgFric1T5jFB3GMl8ezBRzaIekGJkzOfsIDYzED1zVtnM09gFJiFJDULSWoBI9Mq
 RpHU0uLc9NxiI73ixNzi0rx0veT83E2MwHjdduznlh2MK1991DvEyMTBeIhRgoNZSYQ3Ifp+
 khBvSmJlVWpRfnxRaU5q8SFGU6C7JzJLiSbnAxNGXkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQ
 QHpiSWp2ampBahFMHxMHp1QDk0331ldGj1tDHp2wZy2qWFu/4cXNjveJF0vkP7NMY1H85pnH
 dLzr6ZvWrAvq9yMjZvffZytx8H/h475VmTfq/nRd2X+PEiS++vcYGp1Wv5EYd9lMZ3u306u5
 S+8EvFFe5eE21fHbSZZ9WvuDd08vPNA4O/DUhDxdzcSlbOEXJrmnZP85UVi4da0Dq+G9Nao7
 QoytN3339kta7979jeNTvz9PV5Xlzakiv4/VeiSKvJew5/vEc2DFK3flVRf4v4emXRFL2pny
 JbeWa1U4Vx6zmJq32EbNtYu1Ih8X7xXKSczukFCqbF3rNfGs3vo3TteC586/tnXZNQPfC84b
 d4p9+rTEQcdk4f8jvducBK2YlFiKMxINtZiLihMBaWW7FWADAAA=
X-CMS-MailID: 20220727162254eucas1p1fd990f746d9f9870b8d58ee0bd01fedd
X-Msg-Generator: CA
X-RootMTR: 20220727162254eucas1p1fd990f746d9f9870b8d58ee0bd01fedd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162254eucas1p1fd990f746d9f9870b8d58ee0bd01fedd
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162254eucas1p1fd990f746d9f9870b8d58ee0bd01fedd@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v8 08/11] dm-zone: use generic helpers to
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the bdev_offset_from_zone_start() helper function to calculate
the offset from zone start instead of using power of 2 based
calculation.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
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

