Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8936DECAAD8
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665105;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KwKVS8lQq2jJ+5NFUcqJ/V28y2Cin5NHjnVrTuk5Q4g=;
	b=JtSc/SjrxzOfCfLESfXuufAGnLdcED5kd/X40BzSsCPzXu3FA/RZzjKM4LrZooHq1zxbPk
	DBP9zbZMyfeiCivQE8/S+jH77pIDBM6LZq5Ono0r6rHfWSCzy5LYImh/+lDHOq40yBJESV
	qlCAt4/xhI1y/7BsHQPsZrukL/+x0KA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-K5TQ87RSOw-z7e0Xw344Zw-1; Tue, 20 Sep 2022 05:11:44 -0400
X-MC-Unique: K5TQ87RSOw-z7e0Xw344Zw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E5CA3825786;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BF8C2166B36;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4478F19465A3;
	Tue, 20 Sep 2022 09:11:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 104EF19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 028EC492B2E; Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF141492B2C
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2B7B3C0D84E
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:38 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-NvyRKFjuPx-EaXb79o-D6Q-1; Tue, 20 Sep 2022 05:11:35 -0400
X-MC-Unique: NvyRKFjuPx-EaXb79o-D6Q-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091134euoutp01b1e32094c57def0c87e2257bf861e3ef~WhpbdPvUS1236212362euoutp01q
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220920091134euoutp01b1e32094c57def0c87e2257bf861e3ef~WhpbdPvUS1236212362euoutp01q
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091132eucas1p258906bd9e7c9bcde2cddfce391c4a8d5~WhpZanmJ73137931379eucas1p2P;
 Tue, 20 Sep 2022 09:11:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 5E.98.19378.4C389236; Tue, 20
 Sep 2022 10:11:32 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091132eucas1p2e98ce6f411f1c3e8e10c4eae81aba296~WhpY6EFIs3137931379eucas1p2M;
 Tue, 20 Sep 2022 09:11:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091132eusmtrp18c66e0aef4e2083a5eb7781af15d74e1~WhpY4-1NW0212802128eusmtrp15;
 Tue, 20 Sep 2022 09:11:32 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-d1-632983c471be
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id F9.0E.07473.3C389236; Tue, 20
 Sep 2022 10:11:32 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091131eusmtip1e6641e79ecaaeeccfd239bb6f758759d~WhpYkCkHT1070710707eusmtip1t;
 Tue, 20 Sep 2022 09:11:31 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:17 +0200
Message-Id: <20220920091119.115879-12-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf0wTVwDOu2uvR6V4HDjewIxQwyYYEadLXgZxGme5xQSnGUtm/EFTbtjQ
 ImmtsmE2NstvEaw4oBAGzAEDYxELpVCQNJOqaApWkxasGqUOEERWmRIjjnI1+t/3vh/ve1/y
 SJy+zw8n5ZlHWFWmVCEmhLyuwQX7+r9PxMjiLzujkeH6II7a3GUE+u3ZAo5e3bTjqO9pDR+5
 BswYsjTqMPRX2xUMjRv0OHpdfA9DfaPrkKOnlkC/N3kEqDx/HkfeP7UCdN7l4aGroxFbgxnH
 7Z2MWe8WMI6bGqajtYhgLp37mel15RKMOe8+n5ntv0Mwp4ytgLk0lMN4Oz5iCgZKsK8D9woT
 01iF/Cir2rAlVXjIYGnHsuqCsisaTUQuGFlRDAJISG2G1pEavBgISZpqAfDBtXKMOzwHsG1i
 2q94ARzwzGFvI7kVTj4nNAPY132a8Ak0NQngI903xYAkCSoW/lIk8NGhVDqcn28HPj9OdWGw
 sqIR9wkhFAvHXs8uZ3lUNDR19izzIioBOvr/43NlkbD61ovliwKW+NpeLcF5guG16nGeD+NL
 nhOd3AZIGQKg867RH/4SjowWAg6HwCmbUcDh1XDozEkeh3Ogx/nKH9YCWGY2EL4FcKnt1A2F
 D+JUDDT0bODs2+C/N27hnCMIOmeCuScEQV1XpZ8WwcJ8mnOLoXlh3F8KoePXWn8pA51TVlAO
 ovTvjdG/N0b/rrce4K0gjNWolemselMmeyxOLVWqNZnpcbLDyg6w9AeHFm3z3aBlai7OCjAS
 WAEkcXGoSLsrRkaL0qQ//MiqDh9UaRSs2goiSJ44TCSTt0tpKl16hM1g2SxW9VbFyIDwXCxs
 p8s8k3RHfkEpe/msuzIuuy7j05RVZ+ojvy/rPvYiZqNx+HrJVx+f++cnlXuCdsSbarSx7qGo
 OmSik6syjMrJZFeWZ9+iqeDAtF46UfhZwdNZu61UkfxF1OIbSYP3ZXRV8/ZPGlPGdqfs0Goj
 tk4mFiaV2PIekgV5qjdNXY8lylXiPU8Gv3twVG+020sVkrDw4SRvKd9iD5yJHiwz0TXVwrQ5
 pn7L8UcJCWzz2LeBkhadUz6t+zyx3ZJky46aPdtwceWUcY0t4oPzitQPHY/jO/Jvszv259c3
 8eRVVzYnWqjszsvDdyVr/zjwpKgh8rk75/RxwcDeEY1NES7vFV8V89SHpBtjcZVa+j/ndTSZ
 8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xu7pHmjWTDX69ZbJYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLW79nAVDCPr2LKou1sDYwXubsYOTkkBEwk
 GqbcYO1i5OIQEljKKHF52zc2iISExO2FTYwQtrDEn2tdbBBFzxklXs47BtTBwcEmoCXR2MkO
 UiMikCtxePMEJhCbWeAIk8TiqTEgtrBAssSL5TNZQWwWAVWJ7Vt3MYPYvALWEpf3fWOFmC8v
 MfPSd7A5nEDxObtbwG4QErCS6Ji1mQ2iXlDi5MwnLBDz5SWat85mnsAoMAtJahaS1AJGplWM
 IqmlxbnpucWGesWJucWleel6yfm5mxiBEbvt2M/NOxjnvfqod4iRiYPxEKMEB7OSCG+Lv2ay
 EG9KYmVValF+fFFpTmrxIUZToLsnMkuJJucDU0ZeSbyhmYGpoYmZpYGppZmxkjivZ0FHopBA
 emJJanZqakFqEUwfEwenVAPT5lPleUsOp/OzVwmYzTUr/Kd9xvnFpKKAy1rCL3euObRCeaPn
 mrgN7etzn07s1DUM85XKCLVcf1V8W9aXJ5vnaaz5OCGO4VhAa1rkG5ldLRe925mCwj/y/Xvw
 49qjwAdrjjwq2RAjfG6i7fUb2xd8dmY61bq7cbGtXPrdWwy3K2wi3tWpON9Ws59/1ry9Sz6m
 pE3vM9tTw2DPwMo/G+98ETTXMwo88uULX9YXnTTujit8Hbs6HnwNzXB1kjn7xGLLq+tfun5x
 Z/7sDdl24RTT5rBgO845bo9Cz5w/0/b6Z5t3/W+1qUddTya8eWh2vCVm0lFd9/sTdrec3M8l
 f+1/607vsC7N+JCjm79t5Pq0T4mlOCPRUIu5qDgRALvGQYBhAwAA
X-CMS-MailID: 20220920091132eucas1p2e98ce6f411f1c3e8e10c4eae81aba296
X-Msg-Generator: CA
X-RootMTR: 20220920091132eucas1p2e98ce6f411f1c3e8e10c4eae81aba296
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091132eucas1p2e98ce6f411f1c3e8e10c4eae81aba296
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091132eucas1p2e98ce6f411f1c3e8e10c4eae81aba296@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v14 11/13] dm: call dm_zone_endio after the
 target endio callback for zoned devices
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
 dm-devel@redhat.com, Johannes.Thumshirn@wdc.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
uses either native append or append emulation, and it is called before the
endio of the target. But target endio can still update the clone bio
after dm_zone_endio is called, thereby, the orig bio does not contain
the updated information anymore.

Currently, this is not a problem as the targets that support zoned devices
such as dm-zoned, dm-linear, and dm-crypt do not have an endio function,
and even if they do (such as dm-flakey), they don't modify the
bio->bi_iter.bi_sector of the cloned bio that is used to update the
orig_bio's bi_sector in dm_zone_endio function.

This is a prep patch for the new dm-po2zoned target as it modifies
bi_sector in the endio callback.

Call dm_zone_endio for zoned devices after calling the target's endio
function.

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7c35dea88ed1..874e1dc9fc26 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1122,10 +1122,6 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (static_branch_unlikely(&zoned_enabled) &&
-	    unlikely(bdev_is_zoned(bio->bi_bdev)))
-		dm_zone_endio(io, bio);
-
 	if (endio) {
 		int r = endio(ti, bio, &error);
 		switch (r) {
@@ -1154,6 +1150,10 @@ static void clone_endio(struct bio *bio)
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

