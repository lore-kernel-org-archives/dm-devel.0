Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 895C0C5479D
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 08:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672994554;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2Rx+gDt+m0fe+7tADitEzejjQOfDHNrUHNHRSyGA+zk=;
	b=AfsW+/g2Px4ubja2t20/LPYEsxsp1qtZPzN+RpaPWOWambIVwvgG0Q+my3AF/2v56Osp6C
	NEwLqsUZ9F4RO1JieUJMTEsP8ddgv+jtJXpla390yQwp7pSpKeihEGOUYyF7IqR1rXRnJ6
	eAgpD4Ahuu7f8EOxLRPLPUQVWFqbE9I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-kUtxlW33NWaWHFM2XgoUXQ-1; Fri, 06 Jan 2023 03:42:31 -0500
X-MC-Unique: kUtxlW33NWaWHFM2XgoUXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B3752A59560;
	Fri,  6 Jan 2023 08:42:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79BC5401530D;
	Fri,  6 Jan 2023 08:42:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0676E19465B7;
	Fri,  6 Jan 2023 08:42:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9ECE1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C1A1C2166B31; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B74602166B30
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 839DA3C10ED2
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:42:27 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-uCmmdM5ZO-eu6pq1L-c4YA-1; Fri, 06 Jan 2023 03:42:25 -0500
X-MC-Unique: uCmmdM5ZO-eu6pq1L-c4YA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20230106083325euoutp02105771ee24a1b570dd8441b3ae81b8ae~3qy8kC0y02102221022euoutp02s
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:33:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20230106083325euoutp02105771ee24a1b570dd8441b3ae81b8ae~3qy8kC0y02102221022euoutp02s
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230106083324eucas1p2a41a4dc8a4943a42cebd2faff7b4f11b~3qy7O-sUd0368903689eucas1p23;
 Fri,  6 Jan 2023 08:33:24 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 5A.14.61936.3DCD7B36; Fri,  6
 Jan 2023 08:33:23 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e~3qy6rXvLi0142401424eucas1p2Q;
 Fri,  6 Jan 2023 08:33:23 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230106083323eusmtrp21b31fb042b763934d753f5d411f81c64~3qy6qwBSI1128211282eusmtrp2F;
 Fri,  6 Jan 2023 08:33:23 +0000 (GMT)
X-AuditID: cbfec7f4-a2dff7000002f1f0-de-63b7dcd3c38d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id FE.AB.52424.3DCD7B36; Fri,  6
 Jan 2023 08:33:23 +0000 (GMT)
Received: from localhost (unknown [106.210.248.66]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230106083323eusmtip2fe614ae8c9a0dcec5c403fa52c600eb8~3qy6fASkM2941329413eusmtip2G;
 Fri,  6 Jan 2023 08:33:23 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk
Date: Fri,  6 Jan 2023 09:33:17 +0100
Message-Id: <20230106083317.93938-8-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7djPc7qX72xPNvi01dpi9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLM68/MxisfeWtsXlXXPYLOYve8pu8XlpC7vF
 iVvSDrwel694e1w+W+qxaVUnm8fmJfUeu282sHnsbL3P6nF2paPH+31X2Tz6tqxi9Nh8utrj
 8ya5AO4oLpuU1JzMstQifbsErozTq7IKXvJW9E1rZWtgXMPdxcjJISFgIjGnr4cdxBYSWMEo
 0XE8BcL+wigx/4Z2FyMXkP2ZUWL/2alsMA2dP36wQiSWM0rsfnqABcJ5wSjxbcYDxi5GDg42
 AS2Jxk6wqSICwhL7O1rBapgFNjNJ3P69lhEkISwQL3FhXQfYVBYBVYmP/ffYQHp5BSwlPpzN
 hVgmLzHz0newOZwCVhLPp69hArF5BQQlTs58wgJiMwPVNG+dzQwyX0KgnVPiz9XTLBDNLhLz
 LnxjhrCFJV4d38IOYctI/N85nwnCrpZ4euM3VHMLo0T/zvVgR0gIWEv0nckBMZkFNCXW79KH
 KHeU2H/+BiNEBZ/EjbeCECfwSUzaNp0ZIswr0dEmBFGtJLHz5xOopRISl5vmQB3mIbGs8Q/r
 BEbFWUiemYXkmVkIexcwMq9iFE8tLc5NTy02ykst1ytOzC0uzUvXS87P3cQITGan/x3/soNx
 +auPeocYmTgYDzFKcDArifCW9W9LFuJNSaysSi3Kjy8qzUktPsQozcGiJM47Y+v8ZCGB9MSS
 1OzU1ILUIpgsEwenVANTadtTYcPT903PZf6LiTt++ZyYFk/qhOh3/5MVbz25vK4rcOMElTDP
 9TEBfw4Z8VT/vFK7ZdK6K8zLBMWVTcRZ2/N4drdZPkhn7VA6p7lJvX0Vp/+BuQXOJ6trQs/m
 yeR8n6DR0Lho71HO1e6TqpWL+Het2h6w1ITnR+wklQ+JXwxuaWlG7l4x48h5w0mac08m9K9/
 G5lZGPlQ90fB83vKHB+E5v7Un6DE9rt5A/fe/dwGj0rOb9127q+XXdO5pJ2srU8+XAld5MZ9
 zr+5WG2Hxeqn7UoHpI7z9/tndB/bd6aGgffM5vzuq4Y2X04od4t0y5+fIez98GH2HouK3SL+
 Cgu3bpRXsN40PybyKNtXJZbijERDLeai4kQAPHRhhtUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xe7qX72xPNni9R9pi9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLM68/MxisfeWtsXlXXPYLOYve8pu8XlpC7vF
 iVvSDrwel694e1w+W+qxaVUnm8fmJfUeu282sHnsbL3P6nF2paPH+31X2Tz6tqxi9Nh8utrj
 8ya5AO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsE
 vYzTq7IKXvJW9E1rZWtgXMPdxcjJISFgItH54wdrFyMXh5DAUkaJz99uMUMkJCRuL2xihLCF
 Jf5c62KDKHoGVDR5FlCCg4NNQEuisZMdpEYEqGZ/RysLSA2zwEEmiWdTvoMNEhaIlXh4djtY
 EYuAqsTH/ntsIL28ApYSH87mQsyXl5h56TtYCaeAlcTz6WuYQGwhoJKOj71sIDavgKDEyZlP
 WEBsZqD65q2zmScwCsxCkpqFJLWAkWkVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYOxtO/Zz
 yw7Gla8+6h1iZOJgPMQowcGsJMJb1r8tWYg3JbGyKrUoP76oNCe1+BCjKdDZE5mlRJPzgdGf
 VxJvaGZgamhiZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXAxGHALnq8uOu5I6vY
 iwOrt6eJ3LbvVd1r4uVvJDFBK83eKabvpn3mrAzzO3dOuZxT+XtivsWGK8y2KjHVorNqyp2P
 1UuwBJ3+E9l4oeCCb0KMQ/2W2zeLHrsGq/zqW7R9yQE/b6OOmFW55styWvY4LP78+b24kW5p
 s4NH159l1oIacYtbPa5Z2XFNuKemGNs57T2bi4KKo0Nmr5LPqcK/lm5lWrMvF3st5Z0vLHD1
 RO6bk1yy10rqlyaEb0v+uuYzw9c8t6lB008qGuRus/VcOeniyoZFsqb3sq0VQz6Xd4vdvvMj
 2n/blJh4443s7Mz5mlqR0/fMUBDnrwg+ERR5+fO5nUKTGT58vn7gFZ8SS3FGoqEWc1FxIgDt
 M+6dRgMAAA==
X-CMS-MailID: 20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e
X-Msg-Generator: CA
X-RootMTR: 20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 7/7] dm: call dm_zone_endio after the target
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
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b424a6ee27ba..fdef74fe8bd1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1109,10 +1109,6 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (static_branch_unlikely(&zoned_enabled) &&
-	    unlikely(bdev_is_zoned(bio->bi_bdev)))
-		dm_zone_endio(io, bio);
-
 	if (endio) {
 		int r = endio(ti, bio, &error);
 		switch (r) {
@@ -1141,6 +1137,10 @@ static void clone_endio(struct bio *bio)
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

