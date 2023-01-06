Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F5CC54EBF
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 08:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672994438;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yDUZBe0CfW3aZgeuPw+5HuUXbJkPytyIZwHFjouqG4A=;
	b=Mq26n3g14gVZDOAjwqPYI5GT+hfdqzSaV4xAzqrpqroT4k1hmCi0FzORzncLTqoBxyb0vc
	9q4WGPZY/JZ5H45D3/XanqN0OM0eMz30A+TgRuxMbOTzDApE/3OJxPKRCKHIb2BaTQgonA
	/dKo+5aFbu40wmzqMeNovRQlxoZMJiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-IOHZME5JOx6r2HACpL9hhQ-1; Fri, 06 Jan 2023 03:40:34 -0500
X-MC-Unique: IOHZME5JOx6r2HACpL9hhQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6F148828C7;
	Fri,  6 Jan 2023 08:40:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AD36140EBF6;
	Fri,  6 Jan 2023 08:40:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 318A319465B7;
	Fri,  6 Jan 2023 08:40:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 74A441946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 577ACC15BAE; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FBB6C15BAD
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34E4F1816EC3
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-n1oi-N_uOpqJKFhLeOPhvg-1; Fri, 06 Jan 2023 03:40:26 -0500
X-MC-Unique: n1oi-N_uOpqJKFhLeOPhvg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20230106083321euoutp01f3bea957c788b214e5bc4a0438145455~3qy4dtA4f1990519905euoutp015
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:33:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230106083321euoutp01f3bea957c788b214e5bc4a0438145455~3qy4dtA4f1990519905euoutp015
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230106083319eucas1p2e3212c7c60824af430d2b887b4feb81a~3qy3WM79E3119231192eucas1p2D;
 Fri,  6 Jan 2023 08:33:19 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id A7.14.61936.FCCD7B36; Fri,  6
 Jan 2023 08:33:19 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038~3qy28xCRM1636916369eucas1p1N;
 Fri,  6 Jan 2023 08:33:19 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230106083319eusmtrp2f28926097487b7893e7b9aeafb0edc06~3qy28ACgL0987109871eusmtrp2j;
 Fri,  6 Jan 2023 08:33:19 +0000 (GMT)
X-AuditID: cbfec7f4-a2dff7000002f1f0-d2-63b7dccfd9b7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id FA.AB.52424.FCCD7B36; Fri,  6
 Jan 2023 08:33:19 +0000 (GMT)
Received: from localhost (unknown [106.210.248.66]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230106083319eusmtip121f48b06b25f955e94de4a91b3bdc881~3qy2vWoUw0382103821eusmtip1Z;
 Fri,  6 Jan 2023 08:33:19 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk
Date: Fri,  6 Jan 2023 09:33:11 +0100
Message-Id: <20230106083317.93938-2-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsWy7djPc7rn72xPNljxy9Bi9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLM68/MxisfeWtsXlXXPYLOYve8pu8XlpC7vF
 iVvSDrwel694e1w+W+qxaVUnm8fmJfUeu282sHnsbL3P6nF2paPH+31X2Tz6tqxi9Nh8utrj
 8ya5AO4oLpuU1JzMstQifbsErow1PWdYC66zVfzsucXawHiJtYuRk0NCwESi+ewili5GLg4h
 gRWMEosWTGUDSQgJfGGUWHnUDCLxmVGi78E+FpiO98svMkIkljNKnGpcyQLR8YJR4kV7ahcj
 BwebgJZEYyc7SFhEQFhif0cr2AZmgc1MErd/r2UESQgLRErc/7UEbBuLgKrEt7UXwOK8ApYS
 cxa2M0Esk5eYeek72CBOASuJ59PXMEHUCEqcnPkEbC8zUE3z1tnMIAskBLo5JRafWgz1m4vE
 /kPLmSFsYYlXx7ewQ9gyEv93zodaUC3x9MZvqOYWRon+nevZQD6QELCW6DuTA2IyC2hKrN+l
 DxF1lLjd7Qph8knceCsIcQGfxKRt05khwrwSHW1CELOVJHb+fAK1U0LictMcaAh6SBzc94x9
 AqPiLCS/zELyyyyEtQsYmVcxiqeWFuempxYb5aWW6xUn5haX5qXrJefnbmIEprPT/45/2cG4
 /NVHvUOMTByMhxglOJiVRHjL+rclC/GmJFZWpRblxxeV5qQWH2KU5mBREuedsXV+spBAemJJ
 anZqakFqEUyWiYNTqoFJd50j46ZtXbYbdGs0Nthc/Cn8+VGw3AaLjQenZHy90+B7qL16gXS0
 qmLw33epulonpn/8/z36jJFJa8ZXsRN8pxlcbms/8Vkwu6Tnb8v706v8lh5xPRpzzEjzyMoW
 Q/dDC/xCJs99tf/5nmfpl2P6Ozdndfqs+BWi8zxp+5HwnIRPj36KJO9Ik9uy5LK+VTT7p/a3
 0xZ8d/ZqmPf9+66KS/YFSxsE/tldrP8h9SZoP+citY3TDLYzhVxPupJgqq5jOmvT/FlXD+25
 cJdR91hI7JrnbEe/BHHOSGRtPPZr6YoSTddLseatWvLbxD8YZf1anhfQ+TPp9gTt+tinD4IP
 fZm7//uZxonB6lNNVVrOeiixFGckGmoxFxUnAgCPh/C21gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t/xu7rn72xPNrjzV9Ji9d1+NotpH34y
 W/w+e57ZYu+72awWNw/sZLLYs2gSk8XK1UeZLM68/MxisfeWtsXlXXPYLOYve8pu8XlpC7vF
 iVvSDrwel694e1w+W+qxaVUnm8fmJfUeu282sHnsbL3P6nF2paPH+31X2Tz6tqxi9Nh8utrj
 8ya5AO4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsE
 vYw1PWdYC66zVfzsucXawHiJtYuRk0NCwETi/fKLjF2MXBxCAksZJba0NbJAJCQkbi9sYoSw
 hSX+XOtiA7GFBJ4xSnQeiOpi5OBgE9CSaOxkBwmLAJXs72hlAZnDLHCQSeLZlO/MIAlhgXCJ
 hVd3gNksAqoS39ZeAJvJK2ApMWdhOxPEfHmJmZe+gw3iFLCSeD59DRPELkuJjo+9bBD1ghIn
 Zz4Bu40ZqL5562zmCYwCs5CkZiFJLWBkWsUoklpanJueW2ykV5yYW1yal66XnJ+7iREYfduO
 /dyyg3Hlq496hxiZOBgPMUpwMCuJ8Jb1b0sW4k1JrKxKLcqPLyrNSS0+xGgKdPdEZinR5Hxg
 /OeVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTCVLtpSuLt2qeJv
 1n99F8tFAiel2m576bV1UceCicoXVrC4h7g8XZQZtX/hpz0Ld3yQ43TaoPRpwsr3b1NPrxL1
 0GgRvyPccchFTC7nvP/eT5fcy5vupicYT05dtflryHl/dYnvdQtUXhW0zy69aLHubM8H71r3
 eNF/rlLONxuSM53F+ZY/iBGeduiF4SS729acSdKGVW7XGAOv3fn1J/LoF1WnZ9mn5J+3XGKp
 6J2yYuNCrzdnzv77bbnig3F0KLtG05z9JaZHtLr7ytfd/fKmVfbnr+i3T7K1fj2sqnLyadUs
 Wp70KP3//S1fQlrP7zhw++dmg7MeqUc2PT4g/mlPV+D2QutZR1/HTFTP4Dz/XomlOCPRUIu5
 qDgRANWNwXtHAwAA
X-CMS-MailID: 20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038
X-Msg-Generator: CA
X-RootMTR: 20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 1/7] block: remove superfluous check for request
 queue in bdev_is_zoned
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the superfluous request queue check in bdev_is_zoned() as the
bdev_get_queue can never return NULL.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/blkdev.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 43d4e073b111..0e40b014c40b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1283,12 +1283,7 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 
 static inline bool bdev_is_zoned(struct block_device *bdev)
 {
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return blk_queue_is_zoned(q);
-
-	return false;
+	return blk_queue_is_zoned(bdev_get_queue(bdev));
 }
 
 static inline bool bdev_op_is_zoned_write(struct block_device *bdev,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

