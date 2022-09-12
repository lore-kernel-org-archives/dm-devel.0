Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBABECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970964;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4Xzs35L4FLJ7z/BCMkF0Q/pRYwfiZRJp3PCcAxBi8PU=;
	b=gfNfINsUOT5niYPQ+oWiOdFoLLn5oqgpf90CMI74lQrU99wKYpe4n2QJmx32e8bWFbJaQa
	CPXnuH8P6UeKH2+KqRBokd3B1klYU5xetdmvil+8ka5PL6kxF8r++YlG5zRwY6pAso2nmT
	oZ9902cbtQwxg1YhEoMQOMqxDk1HFzs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-crlNnfooPCCRjCKahIlvGg-1; Mon, 12 Sep 2022 04:22:41 -0400
X-MC-Unique: crlNnfooPCCRjCKahIlvGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CBC0811E90;
	Mon, 12 Sep 2022 08:22:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF44AC15BA5;
	Mon, 12 Sep 2022 08:22:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CDDB61946A43;
	Mon, 12 Sep 2022 08:22:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB5021946A48
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE792C15BAB; Mon, 12 Sep 2022 08:22:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA6E1C15BA5
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C288A801231
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:36 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-gvr_xd8XMZOOuCRF51psPA-1; Mon, 12 Sep 2022 04:22:32 -0400
X-MC-Unique: gvr_xd8XMZOOuCRF51psPA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082216euoutp010ff57fde9fd926646f8869c384c3a1aa~UD0FsgsuL1429114291euoutp01M
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220912082216euoutp010ff57fde9fd926646f8869c384c3a1aa~UD0FsgsuL1429114291euoutp01M
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082211eucas1p2f4e53c71b5ea9a1f0214abe7042837cf~UD0A-672_2521325213eucas1p2K;
 Mon, 12 Sep 2022 08:22:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id FD.93.19378.23CEE136; Mon, 12
 Sep 2022 09:22:10 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220912082210eucas1p2a27e358b12b0e4b06a7e00938251c90c~UD0ATwGB62085220852eucas1p28;
 Mon, 12 Sep 2022 08:22:10 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220912082210eusmtrp1f5c6636a975c4ba6a58f300fa8852a07~UD0ASz6Sq1301813018eusmtrp1a;
 Mon, 12 Sep 2022 08:22:10 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-4c-631eec32418d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 38.2F.07473.23CEE136; Mon, 12
 Sep 2022 09:22:10 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082209eusmtip191ef30b7acb64dd77f15d10c24dee9b1~UD0AAjOPs0956209562eusmtip1a;
 Mon, 12 Sep 2022 08:22:09 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:55 +0200
Message-Id: <20220912082204.51189-5-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsWy7djPc7pGb+SSDRoarS3WnzrGbLH6bj+b
 xbQPP5ktfp89z2yx991sVoubB3YyWexZNInJYuXqo0wWT9bPYrb423WPyWLvLW2Ly7vmsFnM
 X/aU3WJC21dmixsTnjJafF7awm6x5uZTFosTt6QdhDwuX/H22DnrLrvH5bOlHptWdbJ5bF5S
 77H7ZgObx87W+6we7/ddZfPo27KK0WPz6WqPz5vkPNoPdDMF8ERx2aSk5mSWpRbp2yVwZcze
 dIul4BR/xbOWbawNjEt4uxg5OSQETCROT5nD0sXIxSEksIJR4seGw4wQzhdGif4DW5kgnM+M
 Es9O/GKHaZl68yRUy3JGiSnz54MlhAReMkpsWp/VxcjBwSagJdHYCRYWEUiX+D79HdggZoF+
 Zonbv3ezg9QIC0RKLL7kDFLDIqAqMeHLFEYQm1fAUuLYneOsELvkJWZe+g42h1PASuL1qlao
 GkGJkzOfsIDYzEA1zVtnM0PUb+eU+LO5BMJ2kZjZ9pUJwhaWeHV8C9T9MhKnJ/ewQNjVEk9v
 /GYGuU1CoAXo453r2UBukxCwlug7kwNiMgtoSqzfpQ9R7iix6sMhRogKPokbbwUhLuCTmLRt
 OjNEmFeio00IolpJYufPJ1BLJSQuN82BWuoh0fCxn2UCo+IsJL/MQvLLLIS9CxiZVzGKp5YW
 56anFhvnpZbrFSfmFpfmpesl5+duYgQmw9P/jn/dwbji1Ue9Q4xMHIyHGCU4mJVEeFkMpZOF
 eFMSK6tSi/Lji0pzUosPMUpzsCiJ8yZnbkgUEkhPLEnNTk0tSC2CyTJxcEo1MMm6feGteydi
 rPlxyyc9sa2bVz2dprlW7H3MzaPcetrubSvXZBdzdP55eIwhtfW1mvLaqP83l7wq/6nZf2rG
 O331zi7TphBrZfXl1Tbrlwp179C2SDUNfq6y8Mx/3ndft+txZ2p8unooICXt8xcTaUZdxYmH
 nJbezlgyIc9x1X+nS6mxfAxqzi8vq029M0tu+UqtG11NR7fcWZg0w2zRXqdvkUIqmv4Lqq/l
 Kam6T3v2VWJa0XL/Jh7znasdte4kHVxSYWvzcumqFH+rkJ5NM7cn299cd0j1alsv4y+l2Zqp
 M8Ocn3jITm1i3bDe02hH9I9pzPd2VehY5c7XVD/cOP/qt0d76tZHJ/NcsGUVsVBiKc5INNRi
 LipOBACDoUju9QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xu7pGb+SSDbbd57FYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eglzF70y2WglP8Fc9atrE2MC7h7WLk
 5JAQMJGYevMkSxcjF4eQwFJGiXn/r7NDJCQkbi9sYoSwhSX+XOtigyh6zijx+dIPoA4ODjYB
 LYnGTrB6EYFcic8rf4DVMAvMZ5aY8+4yWLOwQLjE6gu72UBsFgFViQlfpoDFeQUsJY7dOc4K
 sUBeYual72CDOAWsJF6vagWrEQKqOfvtBjtEvaDEyZlPWEBsZqD65q2zmScwCsxCkpqFJLWA
 kWkVo0hqaXFuem6xoV5xYm5xaV66XnJ+7iZGYPRuO/Zz8w7Gea8+6h1iZOJgPMQowcGsJMLL
 YiidLMSbklhZlVqUH19UmpNafIjRFOjuicxSosn5wPSRVxJvaGZgamhiZmlgamlmrCTO61nQ
 kSgkkJ5YkpqdmlqQWgTTx8TBKdXAtFNN5eY5kYcyDn6Cn5/u+NyWMoNVlmuf0MIr83Yrq5Tz
 Ll2UHxbNo/pj7cT3+fZJxZpzd++NY5j3pGruiTeTslZb39Sc8Pz/ucRlO7cniOjmPku7G/r/
 Ua3rJPdNrSoTbe4IZnxaKayQ9jch5egWvi7Jm5VvpniHS6+96ar92V2wPzmtco75eR3vORUV
 c/fqTeuIc/6vceVKuxbP8snXe6Z29nouffrezjPPW/aG35PPHNW5Jte37Kp699Vx9v+Ncgen
 Tzn+6H7sVrdn4QmsWzwkbl7uelL/8ec2JcW3msuvPFG/wZX2Sev8qf+SW5STV+05avF6N8ei
 ThmRN7pC65/yWv0Ufvph6+0/f3pyhXcpsRRnJBpqMRcVJwIAwJIQXGcDAAA=
X-CMS-MailID: 20220912082210eucas1p2a27e358b12b0e4b06a7e00938251c90c
X-Msg-Generator: CA
X-RootMTR: 20220912082210eucas1p2a27e358b12b0e4b06a7e00938251c90c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082210eucas1p2a27e358b12b0e4b06a7e00938251c90c
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082210eucas1p2a27e358b12b0e4b06a7e00938251c90c@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v13 04/13] nvmet: Allow ZNS target to support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

