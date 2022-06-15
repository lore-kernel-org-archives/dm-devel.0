Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0C1C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-JNOy-C-XO3GZXFLGHJfByg-1; Wed, 15 Jun 2022 06:20:05 -0400
X-MC-Unique: JNOy-C-XO3GZXFLGHJfByg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBDE3185A7A4;
	Wed, 15 Jun 2022 10:20:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA6682166B26;
	Wed, 15 Jun 2022 10:20:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5434F1949759;
	Wed, 15 Jun 2022 10:20:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 62AB5194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:20:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3DD0D1415107; Wed, 15 Jun 2022 10:20:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 394C61415106
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21E5F3C025C9
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:01 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-Am2zJGCuMQu95r0rClKYoA-1; Wed, 15 Jun 2022 06:19:58 -0400
X-MC-Unique: Am2zJGCuMQu95r0rClKYoA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101957euoutp01f9ec2788827cb3d62370cb1c5a8dd5a9~4xAb9HyQy2463124631euoutp01I
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220615101957euoutp01f9ec2788827cb3d62370cb1c5a8dd5a9~4xAb9HyQy2463124631euoutp01I
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615101955eucas1p2eee10b45941965e4935abb0ebb017993~4xAaUbccm1132211322eucas1p2C;
 Wed, 15 Jun 2022 10:19:55 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 1E.3B.09664.B42B9A26; Wed, 15
 Jun 2022 11:19:55 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220615101955eucas1p19b9d42ead7331f69f7dad1ec100312c2~4xAZ4G7zF1177311773eucas1p1q;
 Wed, 15 Jun 2022 10:19:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101955eusmtrp2c7777997ad5bfc414e0f88aef0add88c~4xAZ3Pb9R0349503495eusmtrp28;
 Wed, 15 Jun 2022 10:19:55 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-14-62a9b24bd01e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id E8.24.09038.A42B9A26; Wed, 15
 Jun 2022 11:19:54 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101954eusmtip2aae9fd8bd11cf5ddb8d433d9ef34f41f~4xAZGNSD70755407554eusmtip2f;
 Wed, 15 Jun 2022 10:19:54 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:16 +0200
Message-Id: <20220615101920.329421-10-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsWy7djP87rem1YmGcx9J2+x+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 AvijuGxSUnMyy1KL9O0SuDIm7hMt2MtV8XvKbPYGxuMcXYycHBICJhK7f55g7WLk4hASWMEo
 8Wr+R3YI5wujxIplj9kgnM+MEtO3HgMq4wBraT6qDBFfziix/ss+NpBRQgIvgZx5hiA1bAJa
 Eo2d7CBhEYFwiaN77jGB2MwCfcwST17WgdjCAjEST782g41kEVCVuP64BiTMK2AtsXzCTBaI
 4+QlZl76DjaGEyi+Y3YPK0SNoMTJmU9YIEbKSzRvnc0Mco6EwDlOiaWzG5ggml0kDi7fxQhh
 C0u8Or6FHcKWkfi/cz5UTbXE0xu/oZpbGCX6d65ng/jRWqLvTA6IySygKbF+lz5EuaPE1ul3
 WCAq+CRuvBWEOIFPYtK26cwQYV6JjjYhiGoliZ0/n0AtlZC43DQHqtNDov9/yARGxVlIfpmF
 5JdZCGsXMDKvYhRPLS3OTU8tNsxLLdcrTswtLs1L10vOz93ECEyYp/8d/7SDce6rj3qHGJk4
 GA8xSnAwK4nwmgWvTBLiTUmsrEotyo8vKs1JLT7EKM3BoiTOm5y5IVFIID2xJDU7NbUgtQgm
 y8TBKdXA1PY4f6WvsEnbiw/3VMVT+qb9Uezhj/yeaKUutPnFoaDwuoPP3lcVxznOClQV2bGb
 s+lM9PJZ/FUfc+bPL7qXv8Zx9VPLsMXLrrz9u+iopOT1D2EPGxcEPLblvKm5Vvaszoy1atwr
 Yx5NYVZWWDHZqH+aG1u04InaBTJZP9KsVihPm1CSttd752elEne/YxMXqqyX+t+8PPSyW2z9
 1fJHj64d3vrGJZ7nxpnQPZOUrac8j5rySSl2MfdJfqvINLlEjQpd+4lTXkS/W7/m9MVdv/pO
 nH5hdfr6Aq74xwsb/1qvLPl2qeGYdCZrnOgK5e7XKZrnHe8p6P2XnH/e68aGLcl3H7gUW2ce
 8T18SMTxOoMSS3FGoqEWc1FxIgCbBCwoBwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t/xe7rem1YmGZzTslh9t5/NYtqHn8wW
 v8+eZ7bY+242q8WFH41MFjcP7GSy2LNoEpPFytVHmSyerJ/FbNFz4AOLxd+ue0CxlodAxbe0
 LS7vmsNmMX/ZU3aLGxOeMlp8XtrCbrHm5lMWi7aNXxkdhD0uX/H2+HdiDZvHzll32T0uny31
 2LSqk81jYcNUZo/NS+o9dt9sAMq13mf1eL/vKptH35ZVjB7rt1xl8dh8utrj8yY5j/YD3UwB
 /FF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkamSvp2NimpOZllqUX6dgl6GRP3
 iRbs5ar4PWU2ewPjcY4uRg4OCQETieajyl2MXBxCAksZJc5/e8XcxcgJFJeQuL2wiRHCFpb4
 c62LDaLoOaPEzTf32ECa2QS0JBo72UFqRASiJTpvvgerYRZYwCxx+s4EsISwQJTE3WUrWEHq
 WQRUJa4/rgEJ8wpYSyyfMJMFYr68xMxL38HKOYHiO2b3gJULCVhJ7HoXD1EuKHFy5hOwcmag
 8uats5knMArMQpKahSS1gJFpFaNIamlxbnpusZFecWJucWleul5yfu4mRmB0bzv2c8sOxpWv
 PuodYmTiYDzEKMHBrCTCaxa8MkmINyWxsiq1KD++qDQntfgQoynQ1ROZpUST84HpJa8k3tDM
 wNTQxMzSwNTSzFhJnNezoCNRSCA9sSQ1OzW1ILUIpo+Jg1OqgWnm4qZLge3dfFP7Tk3bt8fM
 LK0keMM0Odc5fIvz3v5R+3Jqs51MavjaNQEls+SzPj98rauveXcL437umzLx+Z8+/v9x3Glb
 a+VN2QsbUxdPtTixq6Ptrc/yFYkpHbnMOsflL5xq5r1sl/bSpLS0rPpgy1Pj93cPh39f/uWe
 V6NOqE8c4y/P5ZtnNK5Y85b/tP7asJrsZ28OZAvdN7Q7Fem2bf3TBPd7euHP18Xcna2zunD+
 yz8KTBd4Vq1r/Tcj+816t0kVSYn6sybLuf/6eCvfxGGfe5lE9seXNxfcuNEuN0Pjvv7mgk1T
 Pp6oVk3td7D6s/zepNo96xR3Z3S8uelw9OJj3vyNTFdzOq7N/qkXqMRSnJFoqMVcVJwIAGEU
 qwx3AwAA
X-CMS-MailID: 20220615101955eucas1p19b9d42ead7331f69f7dad1ec100312c2
X-Msg-Generator: CA
X-RootMTR: 20220615101955eucas1p19b9d42ead7331f69f7dad1ec100312c2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101955eucas1p19b9d42ead7331f69f7dad1ec100312c2
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101955eucas1p19b9d42ead7331f69f7dad1ec100312c2@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v7 09/13] dm-zone: use generic helpers to
 calculate offset from zone start
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
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the blk_queue_offset_from_zone_start() helper function to calculate
the offset from zone start instead of using power of 2 based
calculation.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/dm-zone.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3e7b1fe15..af36d33f9 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -395,7 +395,8 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE:
 		/* Writes must be aligned to the zone write pointer */
-		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
+		if ((blk_queue_offset_from_zone_start(md->queue,
+						      clone->bi_iter.bi_sector)) != zwp_offset)
 			return false;
 		break;
 	case REQ_OP_ZONE_APPEND:
@@ -608,10 +609,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 		 */
 		if (clone->bi_status == BLK_STS_OK &&
 		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
-			sector_t mask = (sector_t)blk_queue_zone_sectors(q) - 1;
-
 			orig_bio->bi_iter.bi_sector +=
-				clone->bi_iter.bi_sector & mask;
+				blk_queue_offset_from_zone_start(q, clone->bi_iter.bi_sector);
 		}
 
 		return;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

