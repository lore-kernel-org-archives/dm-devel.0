Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33091C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-e9cO3EqzOZmsJ2wbzteklA-1; Mon, 16 May 2022 12:54:28 -0400
X-MC-Unique: e9cO3EqzOZmsJ2wbzteklA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0765D804190;
	Mon, 16 May 2022 16:54:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4EB8C27E85;
	Mon, 16 May 2022 16:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 50AE3194706E;
	Mon, 16 May 2022 16:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0D920194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3CF01537687; Mon, 16 May 2022 16:54:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEAA61534FE3
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C570880418F
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:24 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-RFw2YXLbOQmq878fhNIZxQ-1; Mon, 16 May 2022 12:54:23 -0400
X-MC-Unique: RFw2YXLbOQmq878fhNIZxQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165422euoutp015b0ba936f349a91b49e4498c8c6c3a4a~vpCPeImZv2240822408euoutp01C
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516165422euoutp015b0ba936f349a91b49e4498c8c6c3a4a~vpCPeImZv2240822408euoutp01C
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220516165420eucas1p1bcc0f0bd3a9d48f46d084febc883e0cc~vpCNyNJtW3183531835eucas1p1K;
 Mon, 16 May 2022 16:54:20 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 9E.D6.10260.CB182826; Mon, 16
 May 2022 17:54:20 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220516165419eucas1p104aadda60df323e6154bfc3b92103b7b~vpCNYo_z33185231852eucas1p1L;
 Mon, 16 May 2022 16:54:19 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220516165419eusmtrp1da80ad51c871b452d6f5500bc402eb7f~vpCNXvW_c2961829618eusmtrp1E;
 Mon, 16 May 2022 16:54:19 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-3e-628281bc9a2c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 4B.89.09522.BB182826; Mon, 16
 May 2022 17:54:19 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165419eusmtip17f050be3da427ead4fb6b476c789280b~vpCNDBYCX2383023830eusmtip1X;
 Mon, 16 May 2022 16:54:19 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:04 +0200
Message-Id: <20220516165416.171196-2-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsWy7djP87p7GpuSDK53CFqsvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJoufABxaLvbe0LS49XsFusWfvSRaLy7vmsFnM
 X/aU3eLGhKeMFp+XtrBbrLn5lMVBwOPfiTVsHjtn3WX3uHy21GPTqk42j81L6j1232wACrfe
 Z/V4v+8qm0ffllWMHuu3XGXx2Hy62uPzJrkAnigum5TUnMyy1CJ9uwSujL7FixgLZopUHPg8
 mamB8ZZAFyMnh4SAicSN7uusXYxcHEICKxgl/l3YxwSSEBL4wihxvF8dwv7MKHFwlitMw9KZ
 v1kg4ssZJWb0u0A0P2eUWPbqBGMXIwcHm4CWRGMnO0iNiECWxLQTDxlBapgFDjNJPD86nxWk
 RlggWeLScmOQGhYBVYndsxvZQGxeASuJF5uns0PskpeYeek7O0g5p4C1xOoubogSQYmTM5+A
 ncAMVNK8dTYzyHgJgeWcEqcP/GKD6HWROPHzFROELSzx6vgWqJkyEqcn97BA2NUST2/8hmpu
 YZTo37meDWSZBNCyvjM5ICazgKbE+l36EOWOEituvGeBqOCTuPFWEOIEPolJ26YzQ4R5JTra
 hCCqlSR2/nwCtVRC4nLTHKilHhJ/5jxnmcCoOAvJM7OQPDMLYe8CRuZVjOKppcW56anFxnmp
 5XrFibnFpXnpesn5uZsYgYnv9L/jX3cwrnj1Ue8QIxMH4yFGCQ5mJRFeg4qGJCHelMTKqtSi
 /Pii0pzU4kOM0hwsSuK8yZkbEoUE0hNLUrNTUwtSi2CyTBycUg1MO1iXfz+SyuXyYm2Q202J
 S3OX8rzKzHd8OVXuQH1c4a9PGW2cLe9ezPqpqiOzKzL4bJ395D3flPquzHDMCNC+bfZNI3nt
 ruPySWfeqxmGFGTNcZovwRnqdiLKvrIowz9Zfd+cSUe41IOCuOS+71uUY9HF1qW29N1XU5GF
 uVklpR43c63e/mzXEL/glRKZN+EQP0+v3K6lkQzdConlm/bxJIebHHh83Mf934eJBw/omG2v
 +dcdyH7iv/ffEmXT4s8zbu1ebviNZ4JGcZfmtjXf212sKkz/MOf/YdZRT+ft+fN8w5nNrndn
 BAXLH6j9x/X69oaJXurNwp7C3cuuKn9umVBZoHLdy3jCH25t8SolluKMREMt5qLiRAAcKPbk
 6wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xu7q7G5uSDP5uN7dYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTRc+BDywWe29pW1x6vILdYs/ekywWl3fNYbOY
 v+wpu8WNCU8ZLT4vbWG3WHPzKYuDgMe/E2vYPHbOusvucflsqcemVZ1sHpuX1HvsvtkAFG69
 z+rxft9VNo++LasYPdZvucrisfl0tcfnTXIBPFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYm
 lnqGxuaxVkamSvp2NimpOZllqUX6dgl6GX2LFzEWzBSpOPB5MlMD4y2BLkZODgkBE4mlM3+z
 dDFycQgJLGWUWNb/hQkiISFxe2ETI4QtLPHnWhcbRNFTRolNTe1ARRwcbAJaEo2d7CA1IgIF
 EnP6t7CA2MwC55kk9q93B7GFBRIlZv14D1bDIqAqsXt2IxuIzStgJfFi83R2iPnyEjMvfWcH
 GckpYC2xuosbJCwEVPL1yS12iHJBiZMzn0CNl5do3jqbeQKjwCwkqVlIUgsYmVYxiqSWFuem
 5xYb6hUn5haX5qXrJefnbmIERuq2Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrwGFQ1JQrwpiZVV
 qUX58UWlOanFhxhNgc6eyCwlmpwPTBV5JfGGZgamhiZmlgamlmbGSuK8ngUdiUIC6Yklqdmp
 qQWpRTB9TBycUg1M7Pcbb0tJiolxsB7lSj8p7O2mczzNa6/e03UhRcc/ZTV7T12oVKO1tmLB
 5k+7z9gd7FoZfeVKzbaD6cYzWpdJmPY9dPz867vTiyfPZK8+CDr/XvzALNdV/DcDu20XHDeo
 cfig/vuHTtQqtX39O3oMf87gSa1tdk2YMGdLf+SLEyXpqepFZkLSS9PbXjqza64469h0NiLS
 5N71KXy8Gmlpe3+3/j/4ItlCNvD7E4F7vw/sLvivvTV54aq/DssuJIns/mL2SuIq84tb8/Zw
 3Fe4vWGzrmKwxL0Z13W+f3dSmrWn2dB4wcOFsc2VNyLfBt2dULbGqySWK0BW/6HJzXuvthp9
 n28zeQlr9ossmQxPEyWW4oxEQy3mouJEALGUZ2ldAwAA
X-CMS-MailID: 20220516165419eucas1p104aadda60df323e6154bfc3b92103b7b
X-Msg-Generator: CA
X-RootMTR: 20220516165419eucas1p104aadda60df323e6154bfc3b92103b7b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165419eucas1p104aadda60df323e6154bfc3b92103b7b
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165419eucas1p104aadda60df323e6154bfc3b92103b7b@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v4 01/13] block: make blkdev_nr_zones and
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
Cc: p.raghav@samsung.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-zoned.c      | 13 ++++++++++---
 include/linux/blkdev.h |  8 +++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 38cd840d8..140230134 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -111,16 +111,23 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
  * blkdev_nr_zones - Get number of zones
  * @disk:	Target gendisk
  *
- * Return the total number of zones of a zoned block device.  For a block
- * device without zone capabilities, the number of zones is always 0.
+ * Return the total number of zones of a zoned block device, including the
+ * eventual small last zone if present. For a block device without zone
+ * capabilities, the number of zones is always 0.
  */
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
index 1b24c1fb3..22fe512ee 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -675,9 +675,15 @@ static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
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

