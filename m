Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E242C43219
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 13:39:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-LbALx5GnMcK9Waxf3T2rpQ-1; Mon, 16 May 2022 09:39:36 -0400
X-MC-Unique: LbALx5GnMcK9Waxf3T2rpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D41E13810787;
	Mon, 16 May 2022 13:39:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A93E14DE22F;
	Mon, 16 May 2022 13:39:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4537C1947054;
	Mon, 16 May 2022 13:39:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFA381947040
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBAE614DE230; Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B743814DE22F
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F5053810789
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:31 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-_czgAvJzMQeqRW8yDoOeGw-1; Mon, 16 May 2022 09:39:29 -0400
X-MC-Unique: _czgAvJzMQeqRW8yDoOeGw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516133928euoutp010b161caed05bc852f75a0e8fb224563e~vmYFGdg491681516815euoutp01R
 for <dm-devel@redhat.com>; Mon, 16 May 2022 13:39:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516133928euoutp010b161caed05bc852f75a0e8fb224563e~vmYFGdg491681516815euoutp01R
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220516133928eucas1p17f913d0f1876cd98dcc58f76f736ade6~vmYEsE7iP0943109431eucas1p1M;
 Mon, 16 May 2022 13:39:28 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id FF.8D.09887.01452826; Mon, 16
 May 2022 14:39:28 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220516133927eucas1p1bab57e07c14c1194705e254afdd5d346~vmYEMRaTH0242102421eucas1p1n;
 Mon, 16 May 2022 13:39:27 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220516133927eusmtrp20361a1951764c888368339cde1da5799~vmYELPEDL2486924869eusmtrp2W;
 Mon, 16 May 2022 13:39:27 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-64-62825410e4a6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 02.09.09404.F0452826; Mon, 16
 May 2022 14:39:27 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220516133927eusmtip18398a47cd4b3d6f2c96039f7a1ceee72~vmYEAZeBt0855508555eusmtip1b;
 Mon, 16 May 2022 13:39:27 +0000 (GMT)
Received: from localhost (106.110.32.130) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 16 May 2022 14:39:26 +0100
From: Pankaj Raghav <p.raghav@samsung.com>
To: <axboe@kernel.dk>, <naohiro.aota@wdc.com>,
 <damien.lemoal@opensource.wdc.com>, <Johannes.Thumshirn@wdc.com>,
 <snitzer@kernel.org>, <dsterba@suse.com>, <jaegeuk@kernel.org>, <hch@lst.de>
Date: Mon, 16 May 2022 15:39:12 +0200
Message-ID: <20220516133921.126925-5-p.raghav@samsung.com>
In-Reply-To: <20220516133921.126925-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Originating-IP: [106.110.32.130]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTZxjG851zenraWXZanH6pZGaVjSiReWHuy0SciX8cd0WyZYubcS0e
 LuNS1lpUDLFy2yBgodtUKEzYrdh2dlBgoIUIxBbFAqFDoWMQgs0Qxr1kEgaMcnDhv+d939/7
 fM+bfBQuuUFKqYSUM6wqRZ4kI4VEvWOhczf9QaZij76ORtb7Dhyt2B0kMv+pI9GV6QUc6XXX
 +GjR1YWjpkkDD3U/vYQh+/d6DN0w38XQY2spjgruTBNoKX9wtZc9jKN/h/eiYZ+HQPrWhwB5
 e0sx1OQJRT0jVXxkb7pHIPetMhJd/9nLR0W58zjqK/ICVOy08dDN8SkCtXu2vRnEuH9/m1lu
 t5BMcdYkn+karCYYt0vD1JjySKZS+y3O2H68yNzu15JMYdYkyTTmDPGYqeZekrHW9hKMreMC
 U2Sr5jFzNS9GiU8II06zSQlprOrVyM+E8V0T3VjqSsC5kv5BoAX9m/KBgIJ0ODRrZ4l8IKQk
 dBWAOZN5PK7wAXh7tBznijkAr+rrsGcrv1m+43MDI4D1VSX8/6nOoen1lVoAy4qdq2YURdK7
 4KW8NWgz3QLgQncV5i9w+j4PLrTX437fQPpj2DChJfyaoF+GmeP1a1pEvwHdS0ace3s7LOn5
 h+83FdAH4ezlwxwihvdKHq/h+CqSVWfAOQ1hy+go7schLYMGdxjnkgF/cTzgc9olhLkz73DI
 Uejq2sG1A+GYs3YdCYIrjdfXj78AvX2LaydCOhtAXaOV5HYPwssPkjh5BGbmpnEyAPZNiLks
 AVBff3U9iwh+lSspAsGlG9KXbkhfuiF9BcBNYCurUSfHsep9KezZMLU8Wa1JiQuLUSbXgNXf
 3LHs9DUA49hMWCvAKNAKIIXLNov2nNMqJKLT8vPprEp5SqVJYtWtYBtFyLaKYhJ+lUvoOPkZ
 NpFlU1nVsylGCaRaLDwtsEf32lt/iF/KyZRbmsceuTKivYpIxvGoWZnf8CQkdr9deSRZ9vQ9
 wfHcnYrzn8Ah+3Si+kTBYd81IDWEPPnSIFcccmENppbw/baZvq+XgtpgT9Td4Ur9LUt1vHe7
 WHqy1fh+VPGYceWvD0MLRc+frJ6XNT730dFPTebUEE0HdkVqGIqPDp3j5RWORFQcGqyI3fJ3
 2bs329oGYqWeWN8m3Fo2MHjMpIxRzYqzFw4sQ0t6Uec3mV8UBKeYKk+9En02whWTQTnjytMj
 L/ZOGW3HdzvKl1mBcMs+J5q/o3uoPfa5eSdY9LTogg/s+EGNmRoH5rCgkYDxxJ9iX3+hSUao
 4+V7d+Eqtfw/D6uZRDwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t/xu7r8IU1JBtfeaVusP3WM2eL/nmNs
 Fqvv9rNZTPvwk9liUv8MdovfZ88zW+x9N5vV4sKPRiaLPYsmMVmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocXDL7dYLCYdusZo8fTqLCaLvbe0LS49XsFusWfvSRaLy7vmsFnMX/aU
 3WJC21dmixsTnjJaTDy+mdVi3ev3LBYnbkk7yHhcvuLt8e/EGjaPic3v2D3O39vI4nH5bKnH
 plWdbB4LG6Yye2xeUu+x+2YDm0dv8zs2j52t91k93u+7yuaxfstVFo/Np6s9JmzeyOrxeZNc
 gGCUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsb5
 txeYCv7zVcy8eY+xgfEmTxcjJ4eEgInE9jXz2LsYuTiEBJYyShy6MZ0ZIiEj8enKR3YIW1ji
 z7UuNoiij4wSaw7vgerYwigx6fhLoAwHB5uAlkRjJ1hcROAgo8TPCyuYQLqZBU6xSszbKAdS
 IywQJvHhgy9ImEVAVaLp9TYWEJtXwEri8t/lUIvlJWZe+s4OUs4pYC3xqc8exBQCKln/pgii
 WlDi5MwnLBDD5SWat85mhrAlJA6+eMEMUi4hoCQx+7IexMBaiVf3dzNOYBSZhaR7FpLuWUi6
 FzAyr2IUSS0tzk3PLTbSK07MLS7NS9dLzs/dxAhMXNuO/dyyg3Hlq496hxiZOBgPMUpwMCuJ
 8BpUNCQJ8aYkVlalFuXHF5XmpBYfYjQFenIis5Rocj4wdeaVxBuaGZgamphZGphamhkrifN6
 FnQkCgmkJ5akZqemFqQWwfQxcXBKNTCtEHCYzbPrqcmaxul6ExqbVOb+aFpkUL6qrGLvxlfB
 u3U/qW/wPHZayam+UTEoPMBdJGbVPK4k1RWPrE4lPV3xcvmDvZYBRc3L5DadP99apMG65rnI
 ur03530332RzopdpPuMRC1b/gMZF5z2PKK8OSA+qfSV9+r+m9E3m3Yabbt36vDn8lPX8je31
 ns8eSr+ODHgtLnhZi6eSf5G2p5b+hWUT5mqkCj91O65ycrda5s65yf6B5eHffc1Vbt4WCN2d
 GfKh+XNB/fOHDd90Xy8JPRe3L6a3SbUgVvi1E+Pxtqft8YE196LLfew0Pl1YPvmfqZTtDZYn
 S0JDueY386pVfNDPaOYV/xPOr9hw+IgSS3FGoqEWc1FxIgCY9rvo5QMAAA==
X-CMS-MailID: 20220516133927eucas1p1bab57e07c14c1194705e254afdd5d346
X-Msg-Generator: CA
X-RootMTR: 20220516133927eucas1p1bab57e07c14c1194705e254afdd5d346
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516133927eucas1p1bab57e07c14c1194705e254afdd5d346
References: <20220516133921.126925-1-p.raghav@samsung.com>
 <CGME20220516133927eucas1p1bab57e07c14c1194705e254afdd5d346@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v4 04/13] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, bvanassche@acm.org, gost.dev@samsung.com,
 jonathan.derrick@linux.dev, Pankaj Raghav <p.raghav@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Josef Bacik <josef@toxicpanda.com>,
 Jens Axboe <axboe@fb.com>, Keith Busch <kbusch@kernel.org>,
 matias.bjorling@wdc.com, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
 Johannes Thumshirn <jth@kernel.org>, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A generic bdev_zone_no helper is added to calculate zone number for a given
sector in a block device. This helper internally uses blk_queue_zone_no to
find the zone number.

Use the helper bdev_zone_no() to calculate nr of zones. This let's us
make modifications to the math if needed in one place and adds now
support for npo2 zone devices.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 2 +-
 include/linux/blkdev.h    | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 82b61acf7..5516dd6cc 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -242,7 +242,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
 	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	       bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32d7bd7b1..967790f51 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1370,6 +1370,13 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
+static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	return blk_queue_zone_no(q, sec);
+}
+
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

