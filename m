Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 872FDECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970975;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KwKVS8lQq2jJ+5NFUcqJ/V28y2Cin5NHjnVrTuk5Q4g=;
	b=bnMc4ekkKEblktJnMZpctv0CufUq8xPikcslIObDC9CjTHPdjYljPjFqqx8joZMVhLFDi2
	pDVxyDC5a2upL2MbWtr6VYmv+4OUSyE/vm4ztWrYWSb3+Fiv3ZH9X7L+8ij6MiBcxFu5Dn
	+eVguYaswSZemB/iFIIJrRAuoU1YUUk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467--yiIw_o-NDmp0vvuyMapCQ-1; Mon, 12 Sep 2022 04:22:52 -0400
X-MC-Unique: -yiIw_o-NDmp0vvuyMapCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76BAF29AB434;
	Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6638510EB8;
	Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 566641946A43;
	Mon, 12 Sep 2022 08:22:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7109A1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C195112131B; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 584471121315
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EE3A811E80
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-VrmiryBOMVufTICTpjOVQg-1; Mon, 12 Sep 2022 04:22:47 -0400
X-MC-Unique: VrmiryBOMVufTICTpjOVQg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082229euoutp0107f86d830fa28e9786b7f8c24d1eb528~UD0R6gZaf1404314043euoutp01g
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220912082229euoutp0107f86d830fa28e9786b7f8c24d1eb528~UD0R6gZaf1404314043euoutp01g
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082218eucas1p25aec09241db9eba6d129d00870d39881~UD0IVRA_d2083820838eucas1p2b;
 Mon, 12 Sep 2022 08:22:18 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 31.A8.29727.A3CEE136; Mon, 12
 Sep 2022 09:22:18 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220912082218eucas1p23b4bcf6d76947724b9a7468a4b82a7f6~UD0H3RlcH2085220852eucas1p2X;
 Mon, 12 Sep 2022 08:22:18 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220912082218eusmtrp1990f88d4f6be66802adc81c7f14a6e5a~UD0H2XOxU1362613626eusmtrp1J;
 Mon, 12 Sep 2022 08:22:18 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-1b-631eec3a28a6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 16.3F.07473.A3CEE136; Mon, 12
 Sep 2022 09:22:18 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082218eusmtip2ca44631e327ca0164a0583a8af1664a1~UD0HkB02t2962029620eusmtip2r;
 Mon, 12 Sep 2022 08:22:18 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:22:02 +0200
Message-Id: <20220912082204.51189-12-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djPc7pWb+SSDWacNbZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDLW79nAVDCP
 r2LKou1sDYwXubsYOTkkBEwkPvd8ZOpi5OIQEljBKLH/zDVGCOcLo8TUTy3sEM5nRomrZ36z
 w7S82rWbDSKxnFFiwf2tLBDOS0aJr5cWMncxcnCwCWhJNHaCNYgIpEt8n/4ObAezwDYmifsP
 XzCDJIQFUiU2HT3HCGKzCKhKnHz7kRGkl1fASuLAb0GIZfISMy99B5vDCRR+vaoVrJxXQFDi
 5MwnLCA2M1BN89bZzCDzJQRWc0rsvd/ACNHsIvH5SC/U1cISr45vgbJlJE5P7mGBsKslnt74
 DdXcwijRv3M9G8gREgLWEn1nckBMZgFNifW79CHKHSUmrb7ADFHBJ3HjrSDECXwSk7ZNhwrz
 SnS0CUFUK0ns/PkEaqmExOWmOVBLPSSmt25nncCoOAvJM7OQPDMLYe8CRuZVjOKppcW56anF
 hnmp5XrFibnFpXnpesn5uZsYgWnw9L/jn3Ywzn31Ue8QIxMH4yFGCQ5mJRFeFkPpZCHelMTK
 qtSi/Pii0pzU4kOM0hwsSuK8yZkbEoUE0hNLUrNTUwtSi2CyTBycUg1MDDteKC2vCmb3/66V
 uar8juO1vyGc5xjPTpEzVb6y0ye+pfDWpjOV/19f1Sqe+TZk/ht9t4vJd87wLn4pULl4/psk
 y9618ZFd06Tfzvjnq8P+wrzYRoCXbYdcdpn8KUO5WbNtbgf8tJ3606PPk/v8trvGZ7s1WMSf
 X52z3H3r+5Kld86y/z45+dnPPwv+P1fbP33t16edelWrsr4cZAiu5Zc7dbU+5IPcqvgz/8wl
 di2fZP/1+R2eP6anJrUlRxa0LG70+bmuedJhBU/RpZXNVSbBzd1m92bal1Y3yLcJ6XrkV7gd
 VVzSb3nhfd+sbRlTjXMUf16q1inaUrXK83+zIceRuWe35HgEcN4zW3OuR4mlOCPRUIu5qDgR
 AN8VzOPyAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xe7pWb+SSDQ52ClusP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFp+XtrBbrLn5lMXixC1pB0GPy1e8PXbOusvucflsqcemVZ1sHpuX1HvsvtnA
 5rGz9T6rx/t9V9k8+rasYvTYfLra4/MmOY/2A91MATxRejZF+aUlqQoZ+cUltkrRhhZGeoaW
 FnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehnr92xgKpjHVzFl0Xa2BsaL3F2MnBwSAiYS
 r3btZuti5OIQEljKKHHh22pmiISExO2FTYwQtrDEn2tdUEXPGSWmPLjM1MXIwcEmoCXR2MkO
 UiMikCvxeeUPsBpmgSNMEn9frQAbJCyQLPGt6wUTiM0ioCpx8u1HRpBeXgEriQO/BSHmy0vM
 vPQdbA4nUPj1qlawvUIClhJnv90Ai/MKCEqcnPmEBcRmBqpv3jqbeQKjwCwkqVlIUgsYmVYx
 iqSWFuem5xYb6hUn5haX5qXrJefnbmIERuy2Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrwshtLJ
 QrwpiZVVqUX58UWlOanFhxhNgc6eyCwlmpwPTBl5JfGGZgamhiZmlgamlmbGSuK8ngUdiUIC
 6YklqdmpqQWpRTB9TBycUg1M83O4GKysTaWNJiuoSk5K+5R7UcOoTvDvOQeJ5IRb0azr8ioe
 xJy9Uz/n77dVHB2hMYnplkcO1SitWr7gpvTXOa91zgnf4N8txdBw3ud+Sv60baL83S/C3Exn
 v1oZPSlgiyiLuK5AflpZ2LMcbQbHMzmiSgE9nJ9cJT02BkSw6MqvlQ6/myiy7rPC7oxJjGxp
 /VsUtt7ZbZdRopRR+HHV8yvOK6ddvrj1cXDzKbWL65abpJnL2S98wOtpclTfgqFjr99y0Tvu
 XVJtfNzuU19mMXh0t/rYPODfVWKZp7e+b9mceXPZPp+Y9sq6nEf9012WFx51OQ323Nbdlx0i
 /CM4tn4SfWhQ6M395OQONiWW4oxEQy3mouJEAJx94GNhAwAA
X-CMS-MailID: 20220912082218eucas1p23b4bcf6d76947724b9a7468a4b82a7f6
X-Msg-Generator: CA
X-RootMTR: 20220912082218eucas1p23b4bcf6d76947724b9a7468a4b82a7f6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082218eucas1p23b4bcf6d76947724b9a7468a4b82a7f6
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082218eucas1p23b4bcf6d76947724b9a7468a4b82a7f6@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v13 11/13] dm: call dm_zone_endio after the
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
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

