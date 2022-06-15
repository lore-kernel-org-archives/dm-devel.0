Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED433CCA473
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:20:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-jYOGEL22N56rn5ZDU3-o1Q-1; Wed, 15 Jun 2022 06:20:12 -0400
X-MC-Unique: jYOGEL22N56rn5ZDU3-o1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8650A185A79C;
	Wed, 15 Jun 2022 10:20:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 707134010E4D;
	Wed, 15 Jun 2022 10:20:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 112D21956B85;
	Wed, 15 Jun 2022 10:20:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4ED00194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3A30C4010E4D; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 347B240C141F
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BF872999B28
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-Ty-n5-PyPZ2rPfxZd9vgtA-1; Wed, 15 Jun 2022 06:20:05 -0400
X-MC-Unique: Ty-n5-PyPZ2rPfxZd9vgtA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615102003euoutp02bbfd98d225eb7123eacdf897276f4d95~4xAiFRZ3B2943429434euoutp02O
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220615102003euoutp02bbfd98d225eb7123eacdf897276f4d95~4xAiFRZ3B2943429434euoutp02O
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220615102001eucas1p14900ffba109adf1d6ad58fb31b6d3662~4xAgLQcWb1438314383eucas1p1Q;
 Wed, 15 Jun 2022 10:20:01 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 0F.77.10067.152B9A26; Wed, 15
 Jun 2022 11:20:01 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498~4xAfSu7uw2162921629eucas1p2v;
 Wed, 15 Jun 2022 10:20:00 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615102000eusmtrp2756cf6a4b8bd2122ff7819f99032710c~4xAfRraCL0349503495eusmtrp2N;
 Wed, 15 Jun 2022 10:20:00 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-ba-62a9b251a009
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id EF.24.09038.052B9A26; Wed, 15
 Jun 2022 11:20:00 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101959eusmtip1f228020010ced5b70c8bfdd433177605~4xAd8XbKh1152711527eusmtip1L;
 Wed, 15 Jun 2022 10:19:59 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:17 +0200
Message-Id: <20220615101920.329421-11-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7djPc7qBm1YmGfzar2ux+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 AvijuGxSUnMyy1KL9O0SuDLmNpxjL3jKVXGzbRlrA+Nlji5GTg4JAROJ6w/XsnUxcnEICaxg
 lFj+/BWU84VRYsXlDiYI5zOjxORZXcwwLV0vu5khEssZJXpvfoSqesko8ePfTqAMBwebgJZE
 Yyc7SIOIQLjE0T33mEBsZoE+ZoknL+tAbGGBeIlf61+CDWURUJX43XqfDcTmFbCWmHF0BjvE
 MnmJmZe+g9mcQPEds3tYIWoEJU7OfMICMVNeonnrbLCDJATOcUps3buGFaLZRWJz/xZGCFtY
 4tXxLVBDZST+75zPBGFXSzy98RuquYVRon/nejaQBySAtvWdyQExmQU0Jdbv0ocod5Q42r+H
 BaKCT+LGW0GIE/gkJm2bzgwR5pXoaBOCqFaS2PnzCdRSCYnLTXNYIGwPie9bjrBMYFScheSZ
 WUiemYWwdwEj8ypG8dTS4tz01GKjvNRyveLE3OLSvHS95PzcTYzA1Hn63/EvOxiXv/qod4iR
 iYPxEKMEB7OSCK9Z8MokId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzJmRsShQTSE0tSs1NTC1KL
 YLJMHJxSDUx8xxilJRfY+MUe+NwU9+W2N9O62j0fN2ccEO2Pls81D6k79WlG/uywF00MxvOX
 phXsza8QDKlqPcuSfX9T3/fzsg4+MVMcpF47T2yV2Fuf0dszPepls20a/9sdogFh3Rsn9f2o
 drJXb9RSPcvCX6m09E/U1/dTA3IlN852aXWpL735ICPs8gpWhUvzDz85deRu85rrO5c/6J+j
 vIlp+6ojTn7Bpp/fdFZME2m13rLhRmmhyUWXysLCsk5fo6VtGh8FN3ayq7oVTysUr5Jfm3hA
 58/f5Ttctl3gjnLO3T17h8GhaqOXDGxNhlbVjY5sT/z7/dgMvhcJz2joPvV3s9a+A7t8LRiC
 XZhPVql/VGIpzkg01GIuKk4EAC6w+6IMBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xu7oBm1YmGVw8ZGCx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 Avij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLm
 NpxjL3jKVXGzbRlrA+Nlji5GTg4JAROJrpfdzF2MXBxCAksZJWb27mKGSEhI3F7YxAhhC0v8
 udbFBlH0nFGieepiIIeDg01AS6Kxkx2kRkQgWqLz5nuwGmaBBcwSp+9MAEsIC8RKzN1/GGwo
 i4CqxO/W+2wgNq+AtcSMozPYIRbIS8y89B3M5gSK75jdwwoyX0jASmLXu3iIckGJkzOfsIDY
 zEDlzVtnM09gFJiFJDULSWoBI9MqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwCjfduznlh2M
 K1991DvEyMTBeIhRgoNZSYTXLHhlkhBvSmJlVWpRfnxRaU5q8SFGU6CzJzJLiSbnA9NMXkm8
 oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2ampBahFMHxMHp1QDU8yDuaePFx5PLf7yYZ2m
 rdW2UIOnbKVf/nyvkHAXOcU652TvFIfAtkaD6HAPvw/c03zzdy+s077Dd+DMYtNSY9uZ5w3F
 V01plll91rF354KuK1bn2qL37Dtw4RNf1K7LptMVlGMDy4N5pGKEpJ5NX5PpclO1/vLlE3tt
 p3z/svZxveS6rw4Tm3RWHjPYUnntUFL/mS9OIjGTls5qMP/duEE3cWN4uOgJhh/JwiKJPIrH
 pN4JXOJc0CG05w774omn57zOjnrnsbzJbUIO+41ZNzqSmZ+eyMxizhJwll1rUVAg4mOxWzbw
 ZM2d1slW0X/3z0xfoiF1YF760Ygr0nJZkyTSHkzhVzVZJbz0lZ6HjxJLcUaioRZzUXEiAHgN
 WCd7AwAA
X-CMS-MailID: 20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498
X-Msg-Generator: CA
X-RootMTR: 20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v7 10/13] dm-table: use bdev_is_zone_start helper
 in device_area_is_invalid()
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use bdev_is_zone_start() helper that uses generic calculation to check
for zone alignment instead of using po2 based alignment check.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/dm-table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd539afbf..b553cdb6d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -251,7 +251,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (start & (zone_sectors - 1)) {
+		if (blk_queue_is_zone_start(bdev_get_queue(bdev), start)) {
 			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)start,
@@ -268,7 +268,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (blk_queue_is_zone_start(bdev_get_queue(bdev), len)) {
 			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)len,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

