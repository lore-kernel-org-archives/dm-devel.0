Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421F3C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-or-7um_SPKyiD7LFQsR_Dw-1; Fri, 29 Apr 2022 04:23:51 -0400
X-MC-Unique: or-7um_SPKyiD7LFQsR_Dw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17C7586B8A5;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 014F4400E436;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C0DB194705B;
	Fri, 29 Apr 2022 08:23:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0BB201947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D005FC2812C; Wed, 27 Apr 2022 16:11:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CBE0DC08087
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7913D383218D
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:48 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-UNlzty6QPMSYnbB2mvSoBA-1; Wed, 27 Apr 2022 12:11:46 -0400
X-MC-Unique: UNlzty6QPMSYnbB2mvSoBA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160259euoutp024bd5ee002009b957f97818e21622c9ec~pzE9SAUnb1441914419euoutp02o
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:02:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160259euoutp024bd5ee002009b957f97818e21622c9ec~pzE9SAUnb1441914419euoutp02o
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160257eucas1p248f9fb67b38f65e92cd401d8333f1f48~pzE7tOLRh2334023340eucas1p2g;
 Wed, 27 Apr 2022 16:02:57 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 40.0A.10260.13969626; Wed, 27
 Apr 2022 17:02:57 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895~pzE7TkyRS2335223352eucas1p2Z;
 Wed, 27 Apr 2022 16:02:57 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220427160257eusmtrp29abf9fbaa39f05eb9b4bd28a52f41a07~pzE7Sr62r2598325983eusmtrp2c;
 Wed, 27 Apr 2022 16:02:57 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-7e-62696931489b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 9B.71.09522.13969626; Wed, 27
 Apr 2022 17:02:57 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160256eusmtip1cbd768be896ffc9fa5c108cd32dcf1a6~pzE67wefT0884308843eusmtip1h;
 Wed, 27 Apr 2022 16:02:56 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:40 +0200
Message-Id: <20220427160255.300418-2-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se1BUZRjG+8539pzDjmuH1dEv6ebOaGGGMEZ+E0YxOniwGeCf2GiYkQVO
 sAWr7Epg6bTcDFaTywTCAgNYEFeXe1xEaUEuIcGwYMAQRrKjILAYEpctjOXQ5H/P+36/533f
 Z+ZjoPQ6tYdRqs7yapUiXEaJyYbO1f43XZTKIOdLeY7Y8HMnxOW/pVA4c2EV4t6MPgKnp2TR
 2NrXD3HrfI4ID6zEEni0rYnApeW3CTxl0EN8uW2BxP/oJjZ6CZMQ/z3pgtONdwE2D+sJ3Dr2
 Bh68X0LjwWsn8I3WHhKbmnMpnF9spnHqxSWIR1LNAKd11YrwYlECja8/spC4e8zh/Zc409AH
 3Hp3BcWlxc/TXP9ENcmZ+qK4mrJkiivUZkCu9vuvuJaCRYJrGdVS3Dfx8xTXlHhPxFluDlPc
 lboywBnqhkkutbZa5Cv9WHw0hA9Xfs6rD7kHisMst/afSWJjLGurQAsaJTpgxyD2LZRQnAJ1
 QMxI2RKAEjtnCaF4AtBYaRYtFIsAxa0li3SA2bQs1kcI/R8Aim9cEwnFNEC5+krKBlHsARSb
 vGneyY4AlFZVtTkWsjMQDdT9StiW72AD0f2lAdqmSXYfmjMvQ5uWsO+gnyz1pHDgKyh7cJm2
 DbVj3VDqnx8JiD3qyZ7aROAGEl+fs5kBsUVi9G3hVUrwHkdzGfNQ0DvQTFcdLegX0dOmfELQ
 XyLziHXLnABQSpOBEmK6oSt3wm0Sso7I0HxIwD2QtqN+i9iORubshRO2o/SGq1BoS1DSRalA
 y1DT6tTWUoRMcblboTiUXRVHpIK9+mfC6J8Jo/9/bwGAZWA3H6WJCOU1h1V8tJNGEaGJUoU6
 BZ+OqAEbX7p3vWupEZTMPHYyAoIBRoAYKNspedISFiSVhCjOfcGrT59SR4XzGiNwYEjZbkmw
 skohZUMVZ/nPeP4Mr/7vlWDs9mgJ57FrxzpaypPk28yPjpS997Z94ct7f/8x0hCou6Ct+DTT
 xzQiD5qCmdW3tnnq7PhdFTEOQSGqx9Ou4wULN2oVp9r78Yf+d/c93OUXG3D+QnPA5TKmx+Ne
 a87t4NKObBQ9kCaK9HTeb0l54fga3VnSoPOdtVLe098praqAoIyArNcr7Y95JMBqpf+Kw8MA
 l+wVL6/JyEsFeHbtqOcvbWLSNOeGcr52Hf9kVO7zHHKslOe99m510Tlv18SV5UBj++Gbzxe7
 6yas3Udq8h7QXvLxkxPrMX5yX+apn7d/dO+DO/nuV17V5p4kq+rP5x/kR2eHRq0KY277wT9i
 PIdkPieS/gqUkZowhcsBqNYo/gWtMydhQQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t/xu7qGmZlJBmsu8VisP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehnv96sVdAhUvP/1k7GBcQdvFyMHh4SAicTnrbldjFwcQgJLGSV+PNjF2MXICRSXkLi9
 sAnKFpb4c62LDaLoOaPEll2TmECa2QS0JBo72UHiIgJPGCXu/3zMAuIwCzSwSNyauIsJpFtY
 IE5i5rFDzCA2i4CqxNun38FsXgEriYPvt7JAbJCXmHnpOzvIUE4Ba4kJnyJAwkJAJd2LbrFC
 lAtKnJz5BKycGai8eets5gmMArOQpGYhSS1gZFrFKJJaWpybnltsqFecmFtcmpeul5yfu4kR
 mE62Hfu5eQfjvFcf9Q4xMnEwHmKU4GBWEuH9sjsjSYg3JbGyKrUoP76oNCe1+BCjKdDZE5ml
 RJPzgQktryTe0MzA1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQimj4mDU6qBidvFgLde
 KU2Y82fPlJdpbQYOeVKdrT8nT3Zp9Pj6z2de32p1k57g7xxG05c4HVkckRoT84zVlGX/068R
 548EqHmt61bz5bh/wTjjCUfeQ4bqHexaC7W2bOSLuPV7i+rMeyH8OUptHw5s2bp94dn6fd48
 xw08429uNq5fmZm7q8uq/KTxmvVfZy5uYXjf25yisU2u2EFIbncqy0K7WYa9j2bz3DRWNlwc
 /0XLevpHofcCOleeiO5kuMZeM2mD2aZzB1k4tN5POijOtaC4/L/gnT1nPbS5plTdKfk1cZv4
 KyPNxzP+OphweMVyeCp8dXoVczXr7Lbu0mUBOSv/Oa3N3OHt8YV/9cX87Pf163yclFiKMxIN
 tZiLihMBAepjMLADAAA=
X-CMS-MailID: 20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895
X-Msg-Generator: CA
X-RootMTR: 20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160257eucas1p21fb58d0129376a135fdf0b9c2fe88895@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 01/16] block: make blkdev_nr_zones and
 blk_queue_zone_no generic for npo2 zsze
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Adapt blkdev_nr_zones and blk_queue_zone_no function so that it can
also work for non-power-of-2 zone sizes.

As the existing deployments of zoned devices had power-of-2
assumption, power-of-2 optimized calculation is kept for those devices.

There are no direct hot paths modified and the changes just
introduce one new branch per call.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-zoned.c      | 8 +++++++-
 include/linux/blkdev.h | 8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 38cd840d8838..1dff4a8bd51d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -117,10 +117,16 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
 unsigned int blkdev_nr_zones(struct gendisk *disk)
 {
 	sector_t zone_sectors = blk_queue_zone_sectors(disk->queue);
+	sector_t capacity = get_capacity(disk);
 
 	if (!blk_queue_is_zoned(disk->queue))
 		return 0;
-	return (get_capacity(disk) + zone_sectors - 1) >> ilog2(zone_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return (capacity + zone_sectors - 1) >>
+		       ilog2(zone_sectors);
+
+	return div64_u64(capacity + zone_sectors - 1, zone_sectors);
 }
 EXPORT_SYMBOL_GPL(blkdev_nr_zones);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 60d016138997..c4e4c7071b7b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -665,9 +665,15 @@ static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 					     sector_t sector)
 {
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
+
 	if (!blk_queue_is_zoned(q))
 		return 0;
-	return sector >> ilog2(q->limits.chunk_sectors);
+
+	if (is_power_of_2(zone_sectors))
+		return sector >> ilog2(zone_sectors);
+
+	return div64_u64(sector, zone_sectors);
 }
 
 static inline bool blk_queue_zone_is_seq(struct request_queue *q,
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

