Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F23DC04A95
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954611;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KwKVS8lQq2jJ+5NFUcqJ/V28y2Cin5NHjnVrTuk5Q4g=;
	b=LYgY7badn0kfV50m6n43xPcbfL0OqAiQhgYeTjkxgobpPMe5ri0ox7lq1x4yMv7QN/E2VD
	cHa0BWZY5sNZRTkU86uEDebWllS2Aovrp2nfh5KH9Ltg3IanOA1kHBwkU2qD6IQmCifwpr
	/VS/7gPycaz3IUtIJ3Ou6mdTn/hISSQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-E6SzX4EIPieqAxykdAYVvw-1; Fri, 23 Sep 2022 13:36:47 -0400
X-MC-Unique: E6SzX4EIPieqAxykdAYVvw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11BFD3C0F68B;
	Fri, 23 Sep 2022 17:36:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01A02492B05;
	Fri, 23 Sep 2022 17:36:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DAF2119465B9;
	Fri, 23 Sep 2022 17:36:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39CA319465B9
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D71E1400AFC; Fri, 23 Sep 2022 17:36:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 054B01400E43
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDD872A59555
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:42 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-_Mjt5-w2MhCHby6mJ2uKgg-1; Fri, 23 Sep 2022 13:36:35 -0400
X-MC-Unique: _Mjt5-w2MhCHby6mJ2uKgg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173634euoutp0241d427a5ed93a5305cc361e2dcd5e21e~XjeM6_Gx62792727927euoutp02B
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220923173634euoutp0241d427a5ed93a5305cc361e2dcd5e21e~XjeM6_Gx62792727927euoutp02B
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173632eucas1p1e9795110811de8541695b2c4f2710fb0~XjeK9i_9O1387913879eucas1p1N;
 Fri, 23 Sep 2022 17:36:32 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 22.2F.07817.0AEED236; Fri, 23
 Sep 2022 18:36:32 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220923173631eucas1p23cceb8438d6b8b9c3460192c0ad2472d~XjeKiK2ty2441724417eucas1p2L;
 Fri, 23 Sep 2022 17:36:31 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220923173631eusmtrp24c355eec72b16adf2b5af6b9f91c9d89~XjeKhNNeo1023410234eusmtrp2-;
 Fri, 23 Sep 2022 17:36:31 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-3d-632deea03b08
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id EC.5F.10862.F9EED236; Fri, 23
 Sep 2022 18:36:31 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173631eusmtip2e03787d8bb3d48ec0db7b3d7ae7a333e~XjeKHxeXU2194521945eusmtip2g;
 Fri, 23 Sep 2022 17:36:31 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:16 +0200
Message-Id: <20220923173618.6899-12-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djPc7oL3ukmGzx5wm+x/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBEcdmkpOZklqUW6dslcGWs37OBqWAe
 X8WURdvZGhgvcncxcnJICJhILJhylK2LkYtDSGAFo8TuWU9YQRJCAl8YJW4/C4RIfGaU+HDj
 LgtMx4sjc5khEssZJd70zIfqeMkoses+YxcjBwebgJZEYyc7SFhEIF3i+Nab7CD1zALbmCTa
 Zu4EGyQskCpxfOdeMJtFQFWi9ch2ZhCbV8BSYv7umVDL5CVmXvrODjKTEyje31gDUSIocXLm
 E7ASZqCS5q2zwe6REFjPKdGx/S8jRK+LxIKzZ6FsYYlXx7ewQ9gyEv93zmeCsKslnt74DdXc
 wijRv3M9G8gyCQFrib4zOSAms4CmxPpd+hDljhLNG14zQlTwSdx4KwhxAp/EpG3TmSHCvBId
 bUIQ1UoSO38+gVoqIXG5aQ7UUx4SX17uY5zAqDgLyTOzkDwzC2HvAkbmVYziqaXFuempxUZ5
 qeV6xYm5xaV56XrJ+bmbGIEp8PS/4192MC5/9VHvECMTB+MhRgkOZiUR3pSLuslCvCmJlVWp
 RfnxRaU5qcWHGKU5WJTEedlmaCULCaQnlqRmp6YWpBbBZJk4OKUamPxciu/Uzf+q0qr7oy87
 vTu6z+7f18NWK6cvjHhvXCzJxVI+2XSfvs/9H3YrqrbEvH9jstb1RETv3mhvPWU/+Q/su/64
 +6hwSh6u2bxfQClqvqPg6mUzG2v+3klvvVhd7dV4a8srYctjR9xkChyTVY+bFk364rgi84xH
 7avPM7Z82braW5lH8OWuw4eUttr1GZr8mvK6fo22R7RTfNxZ23fzb+nv44yc+C1wR3e33PIo
 T2fJu3K3heudbpqxnoljiWqaMWnR5JIVatPsNHgMrwVlnkuqXDePvy3xbaBmxyddgf2WYuVp
 6osmqt1yWJBhVOLgJxJx88WVDu9dbcsMZ/qIv+g+ZcZg0Sf9/TivEktxRqKhFnNRcSIAWGcn
 fvADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xe7rz3+kmG2xfpm2x/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBE6dkU5ZeWpCpk5BeX2CpFG1oY6Rla
 WugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GWs37OBqWAeX8WURdvZGhgvcncxcnJICJhI
 vDgyl7mLkYtDSGApo8Sb3T1MEAkJidsLmxghbGGJP9e62CCKnjNKTNu9nL2LkYODTUBLorGT
 HaRGRCBX4tjae6wgNcwCR5gk2nbfB0sICyRLLHvyhBXEZhFQlWg9sp0ZxOYVsJSYv3smC8QC
 eYmZl76DzeQEivc31oCEhQQsJM4vfsQOUS4ocXLmE7ByZqDy5q2zmScwCsxCkpqFJLWAkWkV
 o0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYMRuO/Zzyw7Gla8+6h1iZOJgPMQowcGsJMKbclE3
 WYg3JbGyKrUoP76oNCe1+BCjKdDZE5mlRJPzgSkjryTe0MzA1NDEzNLA1NLMWEmc17OgI1FI
 ID2xJDU7NbUgtQimj4mDU6qBqaXwcaWWRlDSlXkubLWdEUqiC+9P5TX58ZF7vjPffsaexqzO
 1xNnT+iT62p8Efhry7bZf3hX2kn4dq5ckmg2I/Tgwbkdiyv3ZwtKz1iXzumr+XpPtbhssdnh
 IvHdP2oVLnWEzDNn0VYJnO370KHt/7Q8loqfFy2qfn5pU+vbfJ3x+Z7KRZps7mXmvG9qZL3C
 zCIO9/NHnFI5xfx9CkdxNnuPEE8Zc8HU8w8+PJgVIHLP5Kj8hEtMMa8cH5p6lFu4Xi1vqfbs
 496ywNal99GD+PUihz3lw11W6h+6tUNnbqj82yse22929n08tkafJzwjrX3TsfzFOo8kUuzy
 ZrM99BDdVKIUz5N8w+/5ZV0lluKMREMt5qLiRABm3IwQYQMAAA==
X-CMS-MailID: 20220923173631eucas1p23cceb8438d6b8b9c3460192c0ad2472d
X-Msg-Generator: CA
X-RootMTR: 20220923173631eucas1p23cceb8438d6b8b9c3460192c0ad2472d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173631eucas1p23cceb8438d6b8b9c3460192c0ad2472d
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173631eucas1p23cceb8438d6b8b9c3460192c0ad2472d@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v15 11/13] dm: call dm_zone_endio after the
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

