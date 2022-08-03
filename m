Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB1DC19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520111;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DLoCA5AG3DPz2ir309OYfPLSGYi6e1wOfcH4H2YQE+U=;
	b=Sx/HTYvX+mtaG6p2poN7yXhr7Yoiug0XMRyc7gu2qwWlkz2ketoIRe7SIYCnWh9BHZfd2A
	FiiFXKfVsNwu9Ph1/pmYCEplzTzyIPtNzdChOfUExCyOTes7WiW4Su/fC2AX8GWcZkrEVe
	Mbyo7fItQ8FgYCjMS7biyiaKzubDLHc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-otl7rGYUP9Sek1RCEhB8Dw-1; Wed, 03 Aug 2022 05:48:24 -0400
X-MC-Unique: otl7rGYUP9Sek1RCEhB8Dw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FFF038217E2;
	Wed,  3 Aug 2022 09:48:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F355C492C3B;
	Wed,  3 Aug 2022 09:48:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D34DB1946A50;
	Wed,  3 Aug 2022 09:48:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 814471946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6443FC15D62; Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60382C15D4F
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46532185A79C
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:19 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-l00gfPQUNcuo3rc_cK0qKQ-1; Wed, 03 Aug 2022 05:48:17 -0400
X-MC-Unique: l00gfPQUNcuo3rc_cK0qKQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094816euoutp01c24e77ccd11bd91ddae7d4230fa938e6~HzLwrW9Lk3128231282euoutp01O
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220803094816euoutp01c24e77ccd11bd91ddae7d4230fa938e6~HzLwrW9Lk3128231282euoutp01O
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094814eucas1p26e088e4d1902813c1d06ef0dd994f407~HzLvOmBkY2470524705eucas1p2x;
 Wed,  3 Aug 2022 09:48:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id DB.FF.09664.E544AE26; Wed,  3
 Aug 2022 10:48:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220803094814eucas1p2789149466d095cc16710ee09a380cbdb~HzLuz7QyB1531915319eucas1p2L;
 Wed,  3 Aug 2022 09:48:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220803094814eusmtrp1addc32d50c84a58b17d01be64653b93c~HzLuy7eRs2000320003eusmtrp1m;
 Wed,  3 Aug 2022 09:48:14 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-9f-62ea445e1e5a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 9D.9B.09038.E544AE26; Wed,  3
 Aug 2022 10:48:14 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094813eusmtip148af0e15644aab588a871f6c749a8ca7~HzLudRlMc2554125541eusmtip1o;
 Wed,  3 Aug 2022 09:48:13 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:59 +0200
Message-Id: <20220803094801.177490-12-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsWy7djPc7pxLq+SDNY8UrdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJWnlcteMtb
 MetPL3sD41LuLkZODgkBE4mDL2cwdzFycQgJrGCU2PD1NhuE84VRYt3O4+wQzmdGida7k1lh
 WtovPmGCSCxnlJi//h4LhPOSUaLx1EWgfg4ONgEticZOsG4RgWZGibt/e1hBHGaBGUwSHR/7
 WEBGCQukSLy/PA3MZhFQlZh24yMjiM0rYC1xb+JPZoh18hIzL31nB7E5geJT/v1jhqgRlDg5
 8wlYLzNQTfPW2WBfSAis55R4umMSO0Szi0Tb231sELawxKvjW6DiMhKnJ/ewQNjVEk9v/IZq
 bmGU6N+5HuwFCaBtfWdyQExmAU2J9bv0IcodJdbfeM4IUcEnceOtIMQJfBKTtk1nhgjzSnS0
 CUFUK0ns/PkEaqmExOWmOVBLPSRWv5vCMoFRcRaSZ2YheWYWwt4FjMyrGMVTS4tz01OLDfNS
 y/WKE3OLS/PS9ZLzczcxAhPh6X/HP+1gnPvqo94hRiYOxkOMEhzMSiK8d1yeJwnxpiRWVqUW
 5ccXleakFh9ilOZgURLnTc7ckCgkkJ5YkpqdmlqQWgSTZeLglGpgsn/3daHVR1/GBzL/l+8q
 SNh/9qH8XaNlF1x+//FczeWvsjxx/xpd+7WrL0ozVDbNvmARr1Fjx8a7a8/SR4ozfy+JsuWc
 nfHjb0/M1Bu5D6pjLbpresrmdOrH7N6yW3r6AjOOyQ99L95vFOndn3HP3DBg84MGHo3XppYP
 Kl1Pfau8p1iwwZqtXkRXjv3h7QZ/54fT7giaLebgbZ+WIf44ZNJJ5/+Xw+f3awlP85n9q3r9
 +stlbMXcfw35vhx6effEPuEE0xgRoYdLglJyV+69lBGafdjw+u/GZ0rnU7cm3P/G3BPisUSO
 cf2Bk2VdkSp73kZdn8GSkKdQIv920VfLqgD16Ky8t2cWCKhuST99QImlOCPRUIu5qDgRAJtX
 NWXzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/xu7pxLq+SDKas57BYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJWnlcteMtbMetPL3sD41LuLkZODgkBE4n2
 i0+Yuhi5OIQEljJKtE0/xAaRkJC4vbCJEcIWlvhzrYsNoug5o8SdpyeAEhwcbAJaEo2d7CBx
 EYFuRonLZ86xgjjMAsuYJJq+XAebJCyQJHHsykFWEJtFQFVi2o2PYFN5Bawl7k38yQyxQV5i
 5qXv7CA2J1B8yr9/YHEhASuJdX9nsULUC0qcnPmEBcRmBqpv3jqbeQKjwCwkqVlIUgsYmVYx
 iqSWFuem5xYb6RUn5haX5qXrJefnbmIExuy2Yz+37GBc+eqj3iFGJg7GQ4wSHMxKIrx3XJ4n
 CfGmJFZWpRblxxeV5qQWH2I0Bbp7IrOUaHI+MGnklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJ
 pCeWpGanphakFsH0MXFwSjUwWViar29cW30op0pJn+/BunfmD0ykbxjc9mV8PWtm9R7e1y7T
 RM8u/y/PJiXzofPjduYbXTGd6xOX6N0TWOmcNklUa+8nF7uVvhKvFWam19poiCuvipmrbfBA
 IKLnypmVlzTTVhx4I5k4o2mv3Oy7b/rn289l/ndfR21lwL/iD1WyM6x6jG8c8H946/WyGW7x
 BbXLyvNmGU+bdYPHeTfTj50/XkT8j9NbfHtT3DRt2dNPjpZd0Vjg9vWTxvbc6M8PtuzYJ669
 RGR1g8bkufut1mRHxDJOVuz680iu6cC8FcvNLqf6+0x9GrC+c7a8vJHfRtvaPLvyf64Gsv51
 GVNXuugZGKzc5ZWlud4qaQcntxJLcUaioRZzUXEiAIcg50liAwAA
X-CMS-MailID: 20220803094814eucas1p2789149466d095cc16710ee09a380cbdb
X-Msg-Generator: CA
X-RootMTR: 20220803094814eucas1p2789149466d095cc16710ee09a380cbdb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094814eucas1p2789149466d095cc16710ee09a380cbdb
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094814eucas1p2789149466d095cc16710ee09a380cbdb@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v9 11/13] dm: call dm_zone_endio after the target
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

This is a prep patch for the new dm-po2zone target as it modifies
bi_sector in the endio callback.

Call dm_zone_endio for zoned devices after calling the target's endio
function.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..58b392c51d04 100644
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

