Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5593C3F6B0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257157;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4Xzs35L4FLJ7z/BCMkF0Q/pRYwfiZRJp3PCcAxBi8PU=;
	b=avubVF8KSJJLWFNPW1WmRb9ZksPQopQVe7A96efPysKadvgZrxGoAXNdEUB5LbRcnoqBg1
	Qb8ELtWAKTMrWh8MBzwJj2O5wt5EcFMkQ3F6MDT1ER1Pol+JyJwCllSofMadjBBbUdT+66
	5ItYLf2PYsojTupempSd7izjdJq9XdY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-0SuMlq1GMzysV8z67_xI1w-1; Tue, 23 Aug 2022 08:19:14 -0400
X-MC-Unique: 0SuMlq1GMzysV8z67_xI1w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48252858F0C;
	Tue, 23 Aug 2022 12:19:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 36EC52026D64;
	Tue, 23 Aug 2022 12:19:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C5B421946A58;
	Tue, 23 Aug 2022 12:19:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C4021946A75
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F2D840C141D; Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B8674010D2A
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7419A8032F1
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:10 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-tfkgiVanN3SJaW759ZQeWg-1; Tue, 23 Aug 2022 08:19:08 -0400
X-MC-Unique: tfkgiVanN3SJaW759ZQeWg-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121907euoutp02b8cbd067d8fff12fd8e65b932766d5c6~N_JL3A42H2224122241euoutp02D
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220823121907euoutp02b8cbd067d8fff12fd8e65b932766d5c6~N_JL3A42H2224122241euoutp02D
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121906eucas1p2b498a4fa7a14789c5a022656defcd8d6~N_JKburp41813918139eucas1p2I;
 Tue, 23 Aug 2022 12:19:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id B8.71.07817.AB5C4036; Tue, 23
 Aug 2022 13:19:06 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220823121905eucas1p14db498525742a606137e098b3cb8f70b~N_JJ_aYve1880718807eucas1p1L;
 Tue, 23 Aug 2022 12:19:05 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220823121905eusmtrp17d1ef42f075448144496ad55cf54a82e~N_JJ9TVL_1042010420eusmtrp18;
 Tue, 23 Aug 2022 12:19:05 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-56-6304c5ba6dcf
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 91.81.10862.9B5C4036; Tue, 23
 Aug 2022 13:19:05 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121905eusmtip14552535383f77899aa661c1dcf6903db~N_JJnzsN40871108711eusmtip1p;
 Tue, 23 Aug 2022 12:19:05 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:50 +0200
Message-Id: <20220823121859.163903-5-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djP87q7jrIkGyycy2Kx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCeKyyYlNSezLLVI3y6BK2P2
 plssBaf4K561bGNtYFzC28XIySEhYCKxbuJdFhBbSGAFo8S6RRldjFxA9hdGiT9d61ggnM+M
 Ep0HL7LAdLRt384MkVgOVLVnLROE84JR4taEG2xdjBwcbAJaEo2d7CANIgLpEl+/bmAEqWEW
 6GeWaHy+AiwhLBApMbPjLCuIzSKgKjF9zSx2kF5eASuJ9eviIJbJS8y89B2snFPAWmLe0lOM
 IDavgKDEyZlPwA5iBqpp3job7CAJgd2cEp2HFjBCNLtI/Pn3jQ3CFpZ4dXwLO4QtI3F6cg/U
 N9UST2/8hmpuYZTo37ke7AEJoG19Z3JATGYBTYn1u/Qhyh0lbq2fzARRwSdx460gxAl8EpO2
 TWeGCPNKdLQJQVQrSez8+QRqqYTE5aY5UEs9JLa938c2gVFxFpJnZiF5ZhbC3gWMzKsYxVNL
 i3PTU4uN8lLL9YoTc4tL89L1kvNzNzEC0+Hpf8e/7GBc/uqj3iFGJg7GQ4wSHMxKIrzVFxmS
 hXhTEiurUovy44tKc1KLDzFKc7AoifMmZ25IFBJITyxJzU5NLUgtgskycXBKNTBNirGYZHMn
 imH31mihgA8Ve0We3vhie8XgYriM3KusFb4uWrluRxZFrr53+sihmdEzF6j+XFz/+aeYezh7
 yr38E2fDF897zhOt2jHnROo789KIySd1+A4+WbxJZfnnWYt1XVb6KM53UF/86PlfyVkXoj0K
 IjcyP5Jql+p7+fq6Z1XbopxDxiEOM8/KPddgrEg7sbDwZ51ufbvxBPd7BkFvWywSdqoYJRZ2
 GV6XZTW9Z+VaemMmM0eXy5GHga6bHVWqGZiNcoz07+oLc966u7pzSazV9jVLbpjHvXApbnvo
 aX6Wa+bnjU51My9+lOEU4G6dY9qY1XT18KbPStKK+34UfeFVsQvR8pBv/aL0skWJpTgj0VCL
 uag4EQDnm9ki9gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7o7j7IkGzR8UrBYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eglzF70y2WglP8Fc9atrE2MC7h7WLk
 5JAQMJFo276duYuRi0NIYCmjxP5PqxkhEhIStxc2QdnCEn+udbFBFD1jlJh6+ySQw8HBJqAl
 0djJDlIjIpArcXjzBCaQGmaB+cwSr54/ZAZJCAuES+y6foAJxGYRUJWYvmYWO0gvr4CVxPp1
 cRDz5SVmXvoONodTwFpi3tJTYHuFgErm3/rEBmLzCghKnJz5hAXEZgaqb946m3kCo8AsJKlZ
 SFILGJlWMYqklhbnpucWG+kVJ+YWl+al6yXn525iBMbutmM/t+xgXPnqo94hRiYOxkOMEhzM
 SiK81RcZkoV4UxIrq1KL8uOLSnNSiw8xmgKdPZFZSjQ5H5g88kriDc0MTA1NzCwNTC3NjJXE
 eT0LOhKFBNITS1KzU1MLUotg+pg4OKUamKYfV9pvtbR/uZLb/8i5Ow++u+jgFxvUsvP0zccz
 JDyeXT14bM65T2rNIve6DPnMBH1dF7zyfhgTxT5hjdz8DYrBLvcZbF4HHbNj4mnJL7zySOSs
 5sVnx9UanndciD4U8NJ+rfGbf3fWMCl2TJUSk07sLj9VfN7g+/2OJ5GOj1xqn8m3vltku0z+
 E3frt8U7/78p2RlYmLP7f4Gk0H+GzhNLZVxZz/s6MyYlh+989HS6bUbzqUDbi6IpL/jfXzmY
 PcVrp5nD3+NNSrxbHy97sSfotWz9lBm/ldbpP/u5Kd9xgqlDynv7Vw/Pfwld7j7lb8gD/cOR
 V1r7Jxw8Lik2sXZ56OxjDiFCLKvP+QXyL72jxFKckWioxVxUnAgAWnF0ImYDAAA=
X-CMS-MailID: 20220823121905eucas1p14db498525742a606137e098b3cb8f70b
X-Msg-Generator: CA
X-RootMTR: 20220823121905eucas1p14db498525742a606137e098b3cb8f70b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121905eucas1p14db498525742a606137e098b3cb8f70b
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121905eucas1p14db498525742a606137e098b3cb8f70b@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v12 04/13] nvmet: Allow ZNS target to support
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A generic bdev_zone_no() helper is added to calculate zone number for a
given sector in a block device. This helper internally uses disk_zone_no()
to find the zone number.

Use the helper bdev_zone_no() to calculate nr of zones. This let's us
make modifications to the math if needed in one place and adds now
support for zoned devices with non po2 zone size.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 3 +--
 include/linux/blkdev.h    | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index c7ef69f29fe4..662f1a92f39b 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -241,8 +241,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 {
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
-	return bdev_nr_zones(req->ns->bdev) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	return bdev_nr_zones(req->ns->bdev) - bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d0d66a0db224..b2636dcca105 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1340,6 +1340,11 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 	return BLK_ZONED_NONE;
 }
 
+static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
+{
+	return disk_zone_no(bdev->bd_disk, sec);
+}
+
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

