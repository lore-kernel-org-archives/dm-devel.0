Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BD1C43219
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-8ROvqzkPNd6Vgzgz9pMBAw-1; Fri, 29 Apr 2022 04:23:50 -0400
X-MC-Unique: 8ROvqzkPNd6Vgzgz9pMBAw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AB84185A7B2;
	Fri, 29 Apr 2022 08:23:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27FB046A0C7;
	Fri, 29 Apr 2022 08:23:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D1AC1947B9D;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5133F1947042
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D930111D7BB; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39561111D7B7
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20F873C21F80
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:59 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-A3yOffLTPcuN6_wdjkRSuQ-1; Wed, 27 Apr 2022 12:11:52 -0400
X-MC-Unique: A3yOffLTPcuN6_wdjkRSuQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160314euoutp02ee64bbc8841041139a46d258826f46f3~pzFK3u6Dr1442014420euoutp023
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160314euoutp02ee64bbc8841041139a46d258826f46f3~pzFK3u6Dr1442014420euoutp023
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160312eucas1p287fed8f498db8495d7a0e270dbca8ab1~pzFJXt9m32337223372eucas1p28;
 Wed, 27 Apr 2022 16:03:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id C8.14.09887.04969626; Wed, 27
 Apr 2022 17:03:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746~pzFJABirU0627806278eucas1p2D;
 Wed, 27 Apr 2022 16:03:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427160312eusmtrp1554db7f7acd8df39fab8ccb76d9490ec~pzFI-Cgfl2077420774eusmtrp1d;
 Wed, 27 Apr 2022 16:03:12 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-6b-62696940e55b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 6C.A7.09404.F3969626; Wed, 27
 Apr 2022 17:03:11 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160311eusmtip2e43e337671f79300cb30594cd877a901~pzFIsidNe2538025380eusmtip2Q;
 Wed, 27 Apr 2022 16:03:11 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:54 +0200
Message-Id: <20220427160255.300418-16-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTZxTee+/t7aWm5FJEXmCb0MkiMEDZou8CYywjcjf4sfhjIW7GFbkC
 o0VoQTdMNgRk0jBoMUgpDNGNiaAWBMn4qCuED1lt6ujK+NgYxjYqc4C2bKsgWcvtNv895znP
 c55zkkPhok4ymMrJK2TleRKpmBQQvWMuc3RSTk7GrtNrAUj3wxiOOn6tIdHZFReOjHUmDNXW
 aPhozWTGkX6pkYdu/30SQzOGPgxd6hjFkE2nxVGVYYVAT5Xzbq78Do7W7+xGtcNTANmtWgzp
 Z6PQ5N02Ppq8kIIG9RMEsvQ3kejct3Y+UlWs4mhaZQdIPd7NQ47Wcj66+vsygW7OhiS9wFh+
 SmU2bl4mGXXZEp8xz3cRjMVUxFxrrySZ8yV1ONP9zefMQIsDYwZmSkjmy7Ilkuk79RuPWb5h
 JZnqnnbA6HqsBKPq7uK9JzogSMhkpTnHWHls4keCbIezGctfoD5Zt3RjJUDDVwIfCtKvQdPG
 VzwlEFAiug1A+5VLBFc4AVzve4xzhQNAx+zqf5bZqTaMa1wEsHRoAXDFAwBHTz1yD6Moko6E
 Jyv5Hn4rPQ2gurNz04HTizi83fMz5hnlT78LR75f2MQEHQ6t5QbSg4V0PLzcYAVc3HbYMPkX
 3zPUx82rHqdzEj840WAjPBh3S8quN26uCulWAWy4v8rjvMnQMTfixf5wcbzHe8Lz0HimiuDw
 CWifXvOaywGs6dORnjDoDqu+JfVAnI6Auv5YTv4WrKhpxjiFL5z+w49bwRfW9tbjHC2EpytE
 nFoM+1w2byiEltImbygDDSYjrgJh2meO0T5zjPb/3BaAt4NAtkghy2IVcXns8RiFRKYoysuK
 OXxUdg24n9q4Me78DlxcfBQzDDAKDANI4eKtQudAdoZImCn5tJiVHz0kL5KyimEQQhHiQOHh
 nE6JiM6SFLK5LJvPyv/tYpRPcAlWkF66uvMz+szcvGjKyCQ3HtGUmaz6d7b51qdGKIJ0gbqn
 X4QayWNpg3EpuS+qQ6Mzqj72s11Zzm/GI4fSfqxre3tf70KtWqoueBivHBne38Wr3jfgan0u
 S99d6BuWmLDi089Ll+z8RRV3bstxc0Js8FBSbvbDqHjNanE4L7TukN3f+STi4LaAfPNMyI6B
 1/d+3bW/uoJ69ZUO/fbrBwruwrWW+JnUgPsHQ5Rjqht/try854QwaC94I2+Ly+X34b2ypkyZ
 6Wpg4g6obwqLvmWrPBtZbKocfT895cl88pJ/5p4P4mVBb0bNHkkzMAsvEZK5MG24OnEEDT6o
 v9ei26Up1U+ICUW2ZHckLldI/gEmqmc5QwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0wbdRzfPXp3kGBuBbOz07g0QxOMBy2F/crmMBvYmyRqpkEyZ7bCLqVZ
 H9iHcWbTAlVH2aTUTUeHW6nDQJlFRjGUDiRNx8OF4KhlrCiwQGVCwmMghRXQdmiy/z6v7+OP
 D4Fwr3J4hFylYzUqqYKPxaO3N3vHXs6WywvTugNZoPmXHgQ0/VGFga8X1hBw++IADCxVl3AQ
 GRhEQOfcZQ74dbUUBve63TBobLoFg6lmKwLOdS+gYMM0FtWM9xGwfl8ALN5hCIQCVhh0Bl8C
 Q5MNOBiyS8DNzn4U+DtqMXD1+xAOzJ//jYARcwgC1b2tHLBUb8SBc3YeBX3Bna8+x/h/y2M2
 +65jTHX5HM4MjrWgjH9Az9xwVGBMneEiwrRe+5Tx2JZgxnPPgDHny+cwxv3ZOIeZ7wpgzJcu
 B8Q0uwIoY25t4bzFPULv06j1OnZXsVqre4X/ngAIaYEY0EKRmBak73k/S5jBT92/7wSrkH/I
 alL3H6eLl5avwCUTxEfr/lbYAF3CTVAcQZEiKjjcAJugeIJL1kPUSMCKbhkUNVpXBm3hRGp9
 2IRthaYh6vzD2ighCIxMoUor8JieRE5B1PjaJBojCGlAqWB1BxybTiRfp3w/TzzGKJlMBYzd
 WAwnkHup6zWB/y48T9UMhfHY0riobn5YEJO5ZBZVaQ9ytuLbqf6aqcfPIdF4edtlxAyR1ics
 6xOWDYIdUBKr1yplSq2Q1kqVWr1KRheplTegaFN+6llztUONM4u0F4IJyAtRBMJPSlj2FBdy
 E05IT33MatTHNHoFq/VCGdG3qxHe00XqaNVUumOCzLQMgShTnJYhzkzn70g4VHJWyiVlUh17
 kmVLWM3/czARxzPAZ+05myblmVzLiqD/SFVu6sY7rj3PuJYVi55ZRUGf2mP+Qd9eMatjtvEi
 Xy0eAhLblI1ePeVh8t+cgc2EM0/y2mnxG6cnPT63qO1B4ODOHqf8UY6zKO+piG7VeLj0QO4H
 e4saZJ27scbCFhN7lHO3IGKf9l2xVW778+Taixu5vXfqk3cL372Z80V4tExcsNDlvzA/uOJT
 ybYHb9Xhlk/Ibx51hUqc6ZWJK+ObKflJ+sMtevdB+4Mfuc+29YRnhqxHLWHjXyOjv8ddM8SH
 Jh3nVBNN/Gzam+2byREt71jcJU6W5Kvdx/+5Y3jhu7LpFd63dyUyx9sHIu1n/OHaDiMf1RZL
 BSmIRiv9F9LcNg2yAwAA
X-CMS-MailID: 20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746
X-Msg-Generator: CA
X-RootMTR: 20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160312eucas1p279bcffd97ef83bd3617a38b80d979746@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 15/16] f2fs: ensure only power of 2 zone sizes
 are allowed
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
Cc: jiangbo.365@bytedance.com, Pankaj Raghav <p.raghav@samsung.com>,
 kch@nvidia.com, bvanassche@acm.org, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

F2FS zoned support has power of 2 zone size assumption in many places
such as in __f2fs_issue_discard_zone, init_blkz_info. As the power of 2
requirement has been removed from the block layer, explicitly add a
condition in f2fs to allow only power of 2 zone size devices.

This condition will be relaxed once those calculation based on power of
2 is made generic.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/f2fs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f64761a15df7..db79abf30002 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3685,6 +3685,10 @@ static int init_blkz_info(struct f2fs_sb_info *sbi, int devi)
 		return 0;
 
 	zone_sectors = bdev_zone_sectors(bdev);
+	if (!is_power_of_2(zone_sectors)) {
+		f2fs_err(sbi, "F2FS does not support non power of 2 zone sizes\n");
+		return -EINVAL;
+	}
 
 	if (sbi->blocks_per_blkz && sbi->blocks_per_blkz !=
 				SECTOR_TO_BLOCK(zone_sectors))
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

