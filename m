Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D0BC04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658940356;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DvXfaXspPE8+gbbXIUs91HnN2pjzVLY20W+mJFdqkV8=;
	b=PcL4iwV3sbK+03eCeOcvBqEIQxdrQpDCh6kMNDemXjV5f2KPn4klVeQM7DPxbASTkl9JEK
	KGbrHbRH4Om1cx7c5wFE+gLl/WUN2feC83/DkptukSr8KevkvNhE7553Z3P/xG7pqg72+M
	PX4WLpGEp+Gd1fCwAcj9uOasN86ARs0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-_u6GgG-dN8yaMj7ShiWciw-1; Wed, 27 Jul 2022 12:45:53 -0400
X-MC-Unique: _u6GgG-dN8yaMj7ShiWciw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A03E08037B7;
	Wed, 27 Jul 2022 16:45:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D1F640CF8E2;
	Wed, 27 Jul 2022 16:45:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 09A621945DB0;
	Wed, 27 Jul 2022 16:45:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F67F1945DAF
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:32:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2B0641121319; Wed, 27 Jul 2022 16:32:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 277F11121314
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A627108C09A
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:32:44 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-TF9aAWi4PWOe9K1usvmQZw-1; Wed, 27 Jul 2022 12:32:36 -0400
X-MC-Unique: TF9aAWi4PWOe9K1usvmQZw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162258euoutp02dca8a80e86122a63a9ed45e1998e7e2d~FvDZBJNy81023510235euoutp02E
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220727162258euoutp02dca8a80e86122a63a9ed45e1998e7e2d~FvDZBJNy81023510235euoutp02E
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162257eucas1p2ba22d6ac666789dc7c83c0c09c8dd771~FvDXYuC2n0838408384eucas1p2E;
 Wed, 27 Jul 2022 16:22:57 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id E9.E8.09580.16661E26; Wed, 27
 Jul 2022 17:22:57 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd~FvDXATaOk2238722387eucas1p2n;
 Wed, 27 Jul 2022 16:22:56 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220727162256eusmtrp23d991b641b5e5403010138b48180dea3~FvDW-f_cM0811608116eusmtrp20;
 Wed, 27 Jul 2022 16:22:56 +0000 (GMT)
X-AuditID: cbfec7f5-9adff7000000256c-ed-62e166617204
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id CD.1E.09095.06661E26; Wed, 27
 Jul 2022 17:22:56 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162256eusmtip1be6834eb505d89c9e19b839ab128d9cd~FvDWoSEpk0050700507eusmtip1i;
 Wed, 27 Jul 2022 16:22:56 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:44 +0200
Message-Id: <20220727162245.209794-11-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djPc7qJaQ+TDH6f4bRYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8XnpS3sFmtuPmWxOHFL2kHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPFJdNSmpOZllqkb5dAlfGqWc/mAo2c1V8v7GZ
 qYHxAEcXIyeHhICJxO/jk1i7GLk4hARWMErc6TnKBOF8YZToWdXNClIlJPCZUWJJkx9Mx/Zz
 j6CKljNKPJv0iRmi6DmjxMQ3wl2MHBxsAloSjZ3sIGERgWKJh+9aWUDqmQVmMUmcPvaYGaRG
 WCBF4kOnE0gNi4CqxI9595hAbF4Ba4nDP9+wQeySl5h56TvYHE6g+OYp86BqBCVOznzCAmIz
 A9U0b53NDDJfQmA5p8TbD//ZQeZLCLhIfD0jDjFHWOLV8S3sELaMxP+d85kg7GqJpzd+Q/W2
 MEr071zPBtFrLdF3JgfEZBbQlFi/Sx+i3FHiyKMJUBV8EjfeCkJcwCcxadt0Zogwr0RHmxBE
 tZLEzp9PoJZKSFxumsMCYXtIvDh3nHECo+IsJL/MQvLLLIS9CxiZVzGKp5YW56anFhvnpZbr
 FSfmFpfmpesl5+duYgSmvdP/jn/dwbji1Ue9Q4xMHIyHGCU4mJVEeBOi7ycJ8aYkVlalFuXH
 F5XmpBYfYpTmYFES503O3JAoJJCeWJKanZpakFoEk2Xi4JRqYDJ7Xcc+O+ecdfDsz3v5qkVu
 mfmcvHH90Cc9MQfhI+H7euT4P3sIqi0uycmOm5mo/rjpwE++z/72+u4MAukfTi27ZZfpFlQ/
 VyfQkmk5p5l2s7mk9u4P4qt6P0opHzIw5DRe1nwjccEPtu9ZVkr6gov+5xsGbfAoXrtDp3re
 o2kFWuvfGEVtzvUzctYRSZXPtDv/TeXhqaQK51URTpFVR3gVtxl2nfez+mRuM/2iuRFH4OZX
 5mLbtkn9XHreocJ4Xu+qA7qGV3OWbNVYO2W2mumZSNYd5Sf6rh7gFuJ+WZv1Tsn79+RXk5V2
 uNR2ef/6xL73z5aYpNnu16awWhW+Wbrd4M5VkYjk9euXRdyrVmIpzkg01GIuKk4EAOeaQyvq
 AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xu7oJaQ+TDL5t0LBYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8XnpS3sFmtuPmWxOHFL2kHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31U2j74tqxg9Np+u9vi8Sc6j/UA3UwBPlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYml
 nqGxeayVkamSvp1NSmpOZllqkb5dgl7GqWc/mAo2c1V8v7GZqYHxAEcXIyeHhICJxPZzj5i6
 GLk4hASWMkosnr2GDSIhIXF7YRMjhC0s8edaFxtE0VNGiTvbZzN3MXJwsAloSTR2soOYIgKV
 Eme/yIKUMwssY5LYcEIGxBYWSJK4++wbC4jNIqAq8WPePSYQm1fAWuLwzzdQq+QlZl76zg5i
 cwLFN0+ZB1YjJGAl8ezBRzaIekGJkzOfsEDMl5do3jqbeQKjwCwkqVlIUgsYmVYxiqSWFuem
 5xYb6hUn5haX5qXrJefnbmIERum2Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrwJ0feThHhTEiur
 Uovy44tKc1KLDzGaAt09kVlKNDkfmCbySuINzQxMDU3MLA1MLc2MlcR5PQs6EoUE0hNLUrNT
 UwtSi2D6mDg4pRqYZKbt4p879bvdx3Ct3saNzj7d6WVmr7f3/lVgFKxskTa8d9DxQWn0ph6G
 GczNNbZN6tN9K52inc1Moz8ePbfIPndaye6qTyt0rPbkSiy426n47cXrxODeEplT5pwpOpcN
 9xVXCl0Rkctzeb3FrU/VZ9oahpZwvu/HhBe3CrNslHos6Gl1Mo/FbP08273HZcVrnoefP608
 fZNpxfToG0tunL7d/mrXx1mJWV8iNSc38m054XrRrvl6weKynwbpqnc3svy6O1HlrXC63q+4
 pdzWyy54zH+16eIEe1uftZmi+mqmb98c1VKouJY+WfcY/37tqTtsPBIdrvqd4f5qUyl0ubQr
 250xdcNb1eTQDmYlluKMREMt5qLiRABGGKl5WwMAAA==
X-CMS-MailID: 20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd
X-Msg-Generator: CA
X-RootMTR: 20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v8 10/11] dm: call dm_zone_endio after the target
 endio callback for zoned devices
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
uses either native append or append emulation and it is called before the
endio of the target. But target endio can still update the clone bio
after dm_zone_endio is called, thereby, the orig bio does not contain
the updated information anymore. Call dm_zone_endio for zoned devices
after calling the target's endio function

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 03ac6143b8aa..bc410ee04004 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1123,10 +1123,6 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (static_branch_unlikely(&zoned_enabled) &&
-	    unlikely(bdev_is_zoned(bio->bi_bdev)))
-		dm_zone_endio(io, bio);
-
 	if (endio) {
 		int r = endio(ti, bio, &error);
 		switch (r) {
@@ -1155,6 +1151,10 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    unlikely(bdev_is_zoned(bio->bi_bdev)))
+		dm_zone_endio(io, bio);
+
 	if (static_branch_unlikely(&swap_bios_enabled) &&
 	    unlikely(swap_bios_limit(ti, bio)))
 		up(&md->swap_bios_semaphore);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

