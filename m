Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 194D1C4321E
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 16:16:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-iVLpPq2UN8qEApczIF-HGA-1; Mon, 23 May 2022 12:16:18 -0400
X-MC-Unique: iVLpPq2UN8qEApczIF-HGA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBD2A85A5BE;
	Mon, 23 May 2022 16:16:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C893140D1B99;
	Mon, 23 May 2022 16:16:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9149B194705E;
	Mon, 23 May 2022 16:16:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 845671947059
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 69DD8492CA4; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65DD0492C3B
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FEC885A5BC
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-0WwpTHo9ObCNWgL98HlK4g-1; Mon, 23 May 2022 12:16:12 -0400
X-MC-Unique: 0WwpTHo9ObCNWgL98HlK4g-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523161611euoutp02339f46b9c596a9ad2dc4a995b40000c1~xyB529bO01844818448euoutp02a
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220523161611euoutp02339f46b9c596a9ad2dc4a995b40000c1~xyB529bO01844818448euoutp02a
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220523161609eucas1p27754a51739628374be85028f4954b683~xyB4VyB3q0957009570eucas1p2Z;
 Mon, 23 May 2022 16:16:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id E4.A4.10009.943BB826; Mon, 23
 May 2022 17:16:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220523161609eucas1p16c381cd9438240905bfdb0a739132e65~xyB3z4X131867318673eucas1p1E;
 Mon, 23 May 2022 16:16:09 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523161609eusmtrp2b6776808758c9ecadcc8ec5d2a7ac2a3~xyB3zBIlt0219002190eusmtrp2N;
 Mon, 23 May 2022 16:16:09 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-13-628bb3493b82
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 7D.19.09404.943BB826; Mon, 23
 May 2022 17:16:09 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220523161608eusmtip23cd80bf73bf7fb5af10d44d04beb495e~xyB3eFHeK0812708127eusmtip2N;
 Mon, 23 May 2022 16:16:08 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, hare@suse.de, Johannes.Thumshirn@wdc.com
Date: Mon, 23 May 2022 18:15:58 +0200
Message-Id: <20220523161601.58078-5-p.raghav@samsung.com>
In-Reply-To: <20220523161601.58078-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djPc7qem7uTDA73aVisvtvPZjHtw09m
 i99nzzNb7H03m9Xiwo9GJoubB3YyWexZNInJYuXqo0wWT9bPYrboOfCBxeJv1z0mi723tC0u
 75rDZjF/2VN2ixsTnjJafF7awm7RtvEro4Ogx+Ur3h7/Tqxh87h8ttRj06pONo/NS+o9dt9s
 YPPY2Xqf1eP9vqtsHn1bVjF6rN9ylcVj8+lqj8+b5DzaD3QzBfBGcdmkpOZklqUW6dslcGWc
 XGNZcJK/Yte5x+wNjPN4uxg5OSQETCQ+bPrB1sXIxSEksIJR4tGD/2wgCSGBL4wS3+bxQSQ+
 M0pcfzeJDaaj8eFdZojEckaJ75vWs0I4Lxgljl//w97FyMHBJqAl0djJDhIXEWhklHh/dB5Y
 EbPANyaJu/M2MYMUCQuESVy+nA4ylUVAVeLU4QfMIDavgKXE3BmPmCG2yUvMvPSdHcTmFLCS
 uH71KhtEjaDEyZlPWEBsZqCa5q2zwS6SENjOKdHwcztUs4vE8XuvGSFsYYlXx7ewQ9gyEv93
 zmeCsKslnt74DdXcwijRv3M9G8hxEgLWEn1nckBMZgFNifW79CHKHSVOvpzNBFHBJ3HjrSDE
 CXwSk7ZNZ4YI80p0tAlBVCtJ7Pz5BGqphMTlpjksELaHxJM1M1knMCrOQvLMLCTPzELYu4CR
 eRWjeGppcW56arFhXmq5XnFibnFpXrpecn7uJkZgQjz97/inHYxzX33UO8TIxMF4iFGCg1lJ
 hHd7YkeSEG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBqbF
 Hz4xp+ystG5mrZn7wnXNZqNfkVc3NbFJBt73ZtgwS//ga8kpj/NXn/JpbpUUf5Dx57rp+9om
 udnuXLd/LhBpnHzZKe/F4tc60x5IVdn+8Z820ZZ/26I6wTizstk+PnNer79+9NubL3aJ92Q2
 eR05JbLwVWmR6AfDYwFf3n14qvbo+1WLfn41qT+1xyuVsurMPliuLP3SKaMd+5+n4ljP8013
 qlcsbRFpirIPZTjK0v8pcvfrmW8eL1Go/ulxuGTmparNJ4UzxCLlPhzw+7b/2+LdzHoiH6Z3
 T/rbXrpn+dp9nFHMlp8PJT3kO+vZwfmkWsLYVC1KsGLZxGyPScqF7DPWNrxju9GkbMT/nGOC
 EktxRqKhFnNRcSIAuQmgVvcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7qem7uTDLoa2S1W3+1ns5j24Sez
 xe+z55kt9r6bzWpx4Ucjk8XNAzuZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x6Txd5b2haX
 d81hs5i/7Cm7xY0JTxktPi9tYbdo2/iV0UHQ4/IVb49/J9aweVw+W+qxaVUnm8fmJfUeu282
 sHnsbL3P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZAnij9GyK8ktLUhUy8otLbJWi
 DS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJOrrEsOMlfsevcY/YGxnm8XYyc
 HBICJhKND+8ydzFycQgJLGWUmHD2BCNEQkLi9sImKFtY4s+1LjYQW0jgGaPE4Wf5XYwcHGwC
 WhKNnewgvSICnYwSR1ecYgFxmAWamCXeT90D1iAsECJxePpHVhCbRUBV4tThB8wgNq+ApcTc
 GY+YIRbIS8y89J0dxOYUsJK4fvUq1DJLiVPrJ7BD1AtKnJz5hAXEZgaqb946m3kCo8AsJKlZ
 SFILGJlWMYqklhbnpucWG+kVJ+YWl+al6yXn525iBEbvtmM/t+xgXPnqo94hRiYOxkOMEhzM
 SiK82xM7koR4UxIrq1KL8uOLSnNSiw8xmgLdPZFZSjQ5H5g+8kriDc0MTA1NzCwNTC3NjJXE
 eT0LOhKFBNITS1KzU1MLUotg+pg4OKUamMRqY/aauLR+bci+4n6kZ3NGJKeO/vI5S/W85oX7
 s3l8u60cnb/TTmS2ROqKvayCp/b7TPasP/tvtb+r1c67y8+URZtxK53x3OKgEulkasukfPbr
 nTlW66ZPNS1f7X96P0vRxLfyNnINnq92ThFpz3PitDvWys7YKcT++1e7ibGPgtD+Zd/nRtT8
 ucJSlV+9TC9FQl1RfmP9F+trbtdmz5vjcHdmX6H0rNdxz5Qvvr+78qNdc4LHJvHv6XnC7fMl
 wpdr6D20jD0bovKN/UsZu6TMnPIU2zrxlwufvc3zk3nL9mn3btd/XKttdmXeCclf+0rhzGXV
 yKn/2m7d+Bh4956FXqzxnnafPdv89K8fV2Ipzkg01GIuKk4EACpvuzJnAwAA
X-CMS-MailID: 20220523161609eucas1p16c381cd9438240905bfdb0a739132e65
X-Msg-Generator: CA
X-RootMTR: 20220523161609eucas1p16c381cd9438240905bfdb0a739132e65
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161609eucas1p16c381cd9438240905bfdb0a739132e65
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161609eucas1p16c381cd9438240905bfdb0a739132e65@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v5 4/7] nvmet: Allow ZNS target to support
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Bart Van Assche <bvanassche@acm.org>,
 gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, dsterba@suse.com,
 jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 2 +-
 include/linux/blkdev.h    | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index e34718b09550..e41b6a6ef048 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -243,7 +243,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
 	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	       bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f5c7a41032ba..ed8742a72dcb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1382,6 +1382,13 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
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

