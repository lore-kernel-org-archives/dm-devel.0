Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCE3C54EBD
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 08:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672994437;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=pB/jfHa9866QHsZGyo5NyRNkYDboXFuWaggcubZmKqk=;
	b=R7J0PmDOMQWLx0IHl38+61b3tmhU5JxxsBT/iBhG//Pxp8tGeA0KJp8pNM9Fkcj3Vh1JQL
	O0wV+4OFCIkhe66FGJUdzTaZLlCwor15FkOUlQ8HuKhZ5mK75qb/hVQo01gKvHSAab8bFI
	imTtwhdAW34UqmbeI9NeP7RSv/usSLM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-bcYPO_W5PKua1O4S_csR8w-1; Fri, 06 Jan 2023 03:40:34 -0500
X-MC-Unique: bcYPO_W5PKua1O4S_csR8w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E57857F82;
	Fri,  6 Jan 2023 08:40:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D565D492B01;
	Fri,  6 Jan 2023 08:40:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 740E31946A75;
	Fri,  6 Jan 2023 08:40:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 79508194658F
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6BE052026D68; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63E862026D4B
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D60A2A5955D
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-cMquyd-MMl2i-ntwcqU5cQ-1; Fri, 06 Jan 2023 03:40:26 -0500
X-MC-Unique: cMquyd-MMl2i-ntwcqU5cQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20230106083320euoutp01379abeb7168d124ed483fb7c5759de0f~3qy3qHelY1990519905euoutp013
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:33:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230106083320euoutp01379abeb7168d124ed483fb7c5759de0f~3qy3qHelY1990519905euoutp013
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230106083319eucas1p2f07e06335cea133036a099678e5780c8~3qy2t7MAJ0992309923eucas1p26;
 Fri,  6 Jan 2023 08:33:19 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 96.14.61936.FCCD7B36; Fri,  6
 Jan 2023 08:33:19 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230106083318eucas1p1a2ab71a95ab2906b4651538c63a94ae2~3qy2XZ6nJ1095210952eucas1p1E;
 Fri,  6 Jan 2023 08:33:18 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230106083318eusmtrp1a6df33b9d2377ba20b7a7b965d6a9e93~3qy2Wlb9c2166121661eusmtrp1f;
 Fri,  6 Jan 2023 08:33:18 +0000 (GMT)
X-AuditID: cbfec7f4-a2dff7000002f1f0-ce-63b7dccfbd0d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id E6.C6.23420.ECCD7B36; Fri,  6
 Jan 2023 08:33:18 +0000 (GMT)
Received: from localhost (unknown [106.210.248.66]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230106083318eusmtip1a6555075bf69d5e8699929cba0a653cc~3qy2Gbyys0159601596eusmtip1O;
 Fri,  6 Jan 2023 08:33:18 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk
Date: Fri,  6 Jan 2023 09:33:10 +0100
Message-Id: <20230106083317.93938-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsWy7djP87rn72xPNth1gcdi9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLM68/MxisfeWtsXlXXPYLOYve8pu8XlpC7vF
 iVvSDrwel694e1w+W+qxaVUnm8fmJfUeu282sHnsbL3P6nF2paPH+31X2Tz6tqxi9Nh8utrj
 8ya5AO4oLpuU1JzMstQifbsEroy1x8+zF3TwVNzZ0M7UwDiHs4uRk0NCwESi/30LWxcjF4eQ
 wApGiYerW1lAEkICXxgl1s+CSnxmlDh/7gwbTMeZYxPZIRLLgRIrPrJCOC8YJV59nsnUxcjB
 wSagJdHYyQ7SICIgLLG/A2QqFwezwGYmidu/1zKC1AgLaEr8fx4OYrIIqEo87LABKecVsJT4
 2LeYBWKXvMTMS9/ZIeKCEidnPgGLMwPFm7fOZgYZKSHwg0Ni45d1UA0uEjsPXIKyhSVeHd/C
 DmHLSJye3AMVr5Z4euM3VHMLo0T/zvVsIEdICFhL9J3JATGZgU5bv0sfotxRoufiUWaICj6J
 G28FIU7gk5i0bTpUmFeio00IolpJYufPJ1BLJSQuN82BWuoh8WVFDxskaGMlWhb2Mk5gVJiF
 5LFZSB6bhXDDAkbmVYziqaXFuempxUZ5qeV6xYm5xaV56XrJ+bmbGIHp7PS/4192MC5/9VHv
 ECMTB+MhRgkOZiUR3rL+bclCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeWdsnZ8sJJCeWJKanZpa
 kFoEk2Xi4JRqYFpTVC2lGbfpo8OmiQsl2ubMCU72/JxgV9j3Stv0zWmezTYffmpadSht6by9
 2z+reed560nbK/5yC3UIM7Jp3Mjc4j6vhPfZst+qOasFE5P9pE0nOSYy3fmWdMZIles78575
 OsFfzmdu21MV/dVEkdlC4vHUnax53wWd5hxIqFqTecS317Lxs6xBjk6l+oH1C/ze+/XbC5ga
 BWdeuXRUqWZL4877Myv7NrKaP1cuXng6afrtP0yJQvveRtXMmxIQ6qGR3SNuvtuzetm6m9f+
 5lg/vnPlqNmNVTu2Fi7g5r86La6eY7ZrWr8151Lr/uT1k0t/n5mc815smzWny7w8De9b/tHh
 Ev0PTQ8aLTllrsRSnJFoqMVcVJwIAEX1jw/WAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t/xu7rn7mxPNmieo2ex+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLmwd2MlnsWTSJyWLl6qNMFmdefmax2HtL2+LyrjlsFvOXPWW3+Ly0hd3i
 xC1pB16Py1e8PS6fLfXYtKqTzWPzknqP3Tcb2Dx2tt5n9Ti70tHj/b6rbB59W1Yxemw+Xe3x
 eZNcAHeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2C
 Xsba4+fZCzp4Ku5saGdqYJzD2cXIySEhYCJx5thEdhBbSGApo8SfMzoQcQmJ2wubGCFsYYk/
 17rYuhi5gGqeMUqcOTUHqIGDg01AS6KxE6xXBKhmf0crC0gNs8BBJolnU74zg9QIC2hK/H8e
 DmKyCKhKPOywASnnFbCU+Ni3mAVivLzEzEvfwSYyA1Wv36UPUSIocXLmE7ASZqCS5q2zmScw
 8s9CqJqFpGoWkqoFjMyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAqNu27Gfm3cwznv1Ue8Q
 IxMH4yFGCQ5mJRHesv5tyUK8KYmVValF+fFFpTmpxYcYTYGOnsgsJZqcD4z7vJJ4QzMDU0MT
 M0sDU0szYyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGplp7ptQXvK+UEyoSXVeY7BYU3nWe
 KVXhSLfAvcNbKpsvHO7JO8B0YxJny4VFOWtevw1r7kn7UvzZ0/hWA0fuuunh76LmFj84qrXJ
 a6dCYdDT71IbZ3StqeAXybj26q9xSEjLmqL/f2vMPrLv5WRXqotwjknYIuacW1bel55VZ2FU
 b3T82jz21TfTf+d0CqwzeHbj8u7Pa1b931YvuODjl2Wvtd7OMb75Z/bDsAJxZs4/rulfO9MW
 fAq+pjK55WxD5YVGg9/7+o3ZXt8omBUUzBHTOG335Vaz89Nv3zrTGibBY/JzDd//Rr7v+Rya
 L3VEetNushrKTbrNvvPE6nvOvo4x+0P0FuudPxBw0DFURImlOCPRUIu5qDgRAD3Q8I9DAwAA
X-CMS-MailID: 20230106083318eucas1p1a2ab71a95ab2906b4651538c63a94ae2
X-Msg-Generator: CA
X-RootMTR: 20230106083318eucas1p1a2ab71a95ab2906b4651538c63a94ae2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083318eucas1p1a2ab71a95ab2906b4651538c63a94ae2
References: <CGME20230106083318eucas1p1a2ab71a95ab2906b4651538c63a94ae2@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 0/7] block zoned cleanups
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,
  It is still unclear whether the support for non-po2 zone size devices
  will be added anytime soon [1]. I have extracted out the cleanup
  patches that doesn't do any functional change but improves the
  readability by adding helpers. This also helps a bit to
  maintain off-tree support as there is an interest to have this feature
  in some companies.

I have retained the reviewed by tags for the commits that did not change
from the main patches I sent before[1].

[1] https://lore.kernel.org/lkml/20220923173618.6899-1-p.raghav@samsung.com/

Luis Chamberlain (1):
  dm-zoned: ensure only power of 2 zone sizes are allowed

Pankaj Raghav (6):
  block: remove superfluous check for request queue in bdev_is_zoned
  block: add a new helper bdev_{is_zone_start, offset_from_zone_start}
  nvmet: introduce bdev_zone_no helper
  zonefs: use bdev_zone_no helper to calculate the zone index
  dm-zone: use generic helpers to calculate offset from zone start
  dm: call dm_zone_endio after the target endio callback for zoned
    devices

 block/blk-core.c             |  2 +-
 block/blk-zoned.c            |  4 ++--
 drivers/md/dm-zone.c         |  8 +++-----
 drivers/md/dm-zoned-target.c |  8 ++++++++
 drivers/md/dm.c              |  8 ++++----
 drivers/nvme/target/zns.c    |  3 +--
 fs/zonefs/super.c            |  8 +++-----
 fs/zonefs/zonefs.h           |  1 -
 include/linux/blkdev.h       | 28 +++++++++++++++++++++++-----
 9 files changed, 45 insertions(+), 25 deletions(-)

-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

