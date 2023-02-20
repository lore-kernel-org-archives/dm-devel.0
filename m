Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC8BC636CC
	for <dm-devel@archiver.kernel.org>; Mon, 20 Feb 2023 13:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676898468;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=SXxQ6oaFixjSNMDbmYc7bfybtP/dAz5OFz1W9gQHNuU=;
	b=PTy/YlVU6JLU1S06jOleRqbKm88Z5i3jF9Dc7+TeMnSFvaJt67EX5IVl871TOD6cUUaxx2
	Ql3pdnmiccD5ymJ23+esTIUTLdg1YewrDRZ+hIqhJ8iHkLZHZHdhn/Q9Q8X7VOQi5mkS8P
	qS169EZLGVeUwn4kRCZOWM2yw7KJuS0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-dZC8eCF1O1C1SOEC4ysJwg-1; Mon, 20 Feb 2023 08:07:47 -0500
X-MC-Unique: dZC8eCF1O1C1SOEC4ysJwg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68D79100F907;
	Mon, 20 Feb 2023 13:07:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D80D9140EBF6;
	Mon, 20 Feb 2023 13:07:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A02B21946588;
	Mon, 20 Feb 2023 13:07:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6B1541946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Feb 2023 13:07:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C4D6C15BAD; Mon, 20 Feb 2023 13:07:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A77C15BA0
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 13:07:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 235E338149A3
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 13:07:39 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-eIPO2su3NnWihylK6sSwPA-1; Mon, 20 Feb 2023 08:07:36 -0500
X-MC-Unique: eIPO2su3NnWihylK6sSwPA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20230220130034euoutp020bd8a8f55a7c9a727c5b630e8507c4bd~FieCZ4qcB2583925839euoutp02J
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 13:00:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20230220130034euoutp020bd8a8f55a7c9a727c5b630e8507c4bd~FieCZ4qcB2583925839euoutp02J
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230220130033eucas1p200fe8d50e0df282135c6f739eb6331dc~FieBeYtai2069120691eucas1p2m;
 Mon, 20 Feb 2023 13:00:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 62.10.01471.0FE63F36; Mon, 20
 Feb 2023 13:00:32 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20230220130032eucas1p2b5b7bee68b20c1daee92226691dd8302~FieBFIumS1864018640eucas1p2v;
 Mon, 20 Feb 2023 13:00:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230220130032eusmtrp162f742012f42af0335ba3829e9d53e48~FieBEXprN1316113161eusmtrp1q;
 Mon, 20 Feb 2023 13:00:32 +0000 (GMT)
X-AuditID: cbfec7f2-2b1ff700000105bf-45-63f36ef07493
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id F9.20.02722.0FE63F36; Mon, 20
 Feb 2023 13:00:32 +0000 (GMT)
Received: from localhost (unknown [106.210.248.118]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230220130032eusmtip2024976c02e4977c023d88146c3a822de~FieAvaU3E0206502065eusmtip2j;
 Mon, 20 Feb 2023 13:00:32 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org
Date: Mon, 20 Feb 2023 18:28:41 +0530
Message-Id: <20230220125839.64459-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42LZduzned0PeZ+TDT4ds7JYf+oYs8W0Dz+Z
 Lfa+m81qcfPATiaLz0tb2C1O3JJ2YPO4fMXbY9OqTjaP9/uusnn0bVnFGMASxWWTkpqTWZZa
 pG+XwJVxfsVl1oKvfBWf3ts3ME7n6WLk5JAQMJE41rmdvYuRi0NIYAWjxISlD1ggnC+MEodm
 r4ByPjNK9Jy+zwTT0nb5PytEYjmjRNOyA1DOS0aJZxuPALVwcLAJaEk0drKDNIgIiEk0XL8I
 toNZoJtRYsqS1WwgCWGBaInPnfNYQGwWAVWJ9q3NYHFeAUuJv0ufsUJsk5eYeek7O0RcUOLk
 zCdg9cxA8eats5lBhkoI9HJIPPnxhRmiwUWi6fJ0FghbWOLV8S3sELaMxOnJPVDxaomnN35D
 NbcwSvTvXM8GcrWEgLVE35kcEJNZQFNi/S59iHJHiQdrtrJCVPBJ3HgrCHECn8SkbdOZIcK8
 Eh1tQhDVShI7fz6BWiohcblpDtRSD4nVcyBhKCQQK3F/aSfjBEaFWUgem4XksVkINyxgZF7F
 KJ5aWpybnlpsmJdarlecmFtcmpeul5yfu4kRmFJO/zv+aQfj3Fcf9Q4xMnEwHmKU4GBWEuH9
 z/s5WYg3JbGyKrUoP76oNCe1+BCjNAeLkjivtu3JZCGB9MSS1OzU1ILUIpgsEwenVANTqoJ3
 S3pvqdDvrto876ivP9+ys13c2Kd5eEbtPEuXkufeS3VvbFU0u9dsNS8yssxl8XyTNfNdU7+Y
 7l50UvONm84ek/exu0zVs53b5Yvsvss+jVFYbuYa8uhT4jPlyZcT04zO3wixZOjfsYFn70XX
 9oyjhfn+93ydpLWfTNosrzVjU+tcScZvuyVZa+fvZRQxm7ixrXrXYYsffW4BXlormv40Ri1I
 v1e741FKc/XpHc63nmbdnW+yMeaY7tSFBusNGqNvNMglqL457S+39+6vZxM9DQv/Mvqsqnh8
 dmuJVo2517Yt27x2FK1VqDnAIMa87AHPaa79+f9uec99m/9Oaont1u/nd1w6027zcP0NJZbi
 jERDLeai4kQA0NdxiJgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xe7of8j4nGzRPUrRYf+oYs8W0Dz+Z
 Lfa+m81qcfPATiaLz0tb2C1O3JJ2YPO4fMXbY9OqTjaP9/uusnn0bVnFGMASpWdTlF9akqqQ
 kV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqkb2eTkpqTWZZapG+XoJdxfsVl1oKvfBWf3ts3
 ME7n6WLk5JAQMJFou/yftYuRi0NIYCmjxOFP55ghEhIStxc2MULYwhJ/rnWxQRQ9Z5RouzgT
 qIODg01AS6Kxkx2kRkRATKLh+kV2kBpmgYlAg85fAGsWFoiUmNZxgwnEZhFQlWjf2swGYvMK
 WEr8XfqMFWKBvMTMS9/ZIeKCEidnPmEBsZmB4s1bZzNPYOSbhSQ1C0lqASPTKkaR1NLi3PTc
 YkO94sTc4tK8dL3k/NxNjMBg3nbs5+YdjPNefdQ7xMjEwXiIUYKDWUmE9z/v52Qh3pTEyqrU
 ovz4otKc1OJDjKZA901klhJNzgfGU15JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6Yklqdmpq
 QWoRTB8TB6dUAxPvv5UHIq/P2SFeLSvS73xneZYYx8tH4Qebrx0zSFGYPuvygrgtXCdz8yI4
 gyxVymXWy8qtP+PySc9B3n2vfLL/OZaKB2t31uvorfA8UMF34v7J+/3hRytD3s7QjXlTGqUc
 fopvipu5QetprhqLarMr//R7/31pejm/sH+JT53pHg4Lprvxr1Kj19iyWHdaPbTXemJ06XH4
 6uB9c/VnWS0oT/t6z+D6qyXB3M6/nHXXCt4OL9+uGfdjQlPi0QTGtHlp8T8XOxtaWaZNvhI7
 y6SZ9Qbvukcbqy1WPl6/wVHAxb5d9dbqljnHtswvtPjf9dg2vFH0V+cPDWvGb7LnMozkfnyz
 dDnUUyG0ambyHCWW4oxEQy3mouJEAGtDL+TvAgAA
X-CMS-MailID: 20230220130032eucas1p2b5b7bee68b20c1daee92226691dd8302
X-Msg-Generator: CA
X-RootMTR: 20230220130032eucas1p2b5b7bee68b20c1daee92226691dd8302
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230220130032eucas1p2b5b7bee68b20c1daee92226691dd8302
References: <CGME20230220130032eucas1p2b5b7bee68b20c1daee92226691dd8302@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH] dm: call dm_zone_endio after the target endio
 callback for zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com,
 dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

Call dm_zone_endio for zoned devices after calling the target's endio
function.

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Hi Mike,
  This is one of the patch that was part of my po2 series that did not
  get merged but this individual patch can be applied independently.

 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index adb002b8648d..fe4bfbb18af0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1111,10 +1111,6 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (static_branch_unlikely(&zoned_enabled) &&
-	    unlikely(bdev_is_zoned(bio->bi_bdev)))
-		dm_zone_endio(io, bio);
-
 	if (endio) {
 		int r = endio(ti, bio, &error);
 
@@ -1144,6 +1140,10 @@ static void clone_endio(struct bio *bio)
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

