Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F04CCA473
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:20:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-9snFiOvtP3GEJIlsTFxCUQ-1; Wed, 15 Jun 2022 06:20:13 -0400
X-MC-Unique: 9snFiOvtP3GEJIlsTFxCUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC8CA3C01D96;
	Wed, 15 Jun 2022 10:20:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 990862026D07;
	Wed, 15 Jun 2022 10:20:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3B2A61949759;
	Wed, 15 Jun 2022 10:20:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB970194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DDFC01415107; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA2D51415106
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C33DC101E986
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:09 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-vu_7nrq0O0u2sgCgSxv8ww-1; Wed, 15 Jun 2022 06:20:08 -0400
X-MC-Unique: vu_7nrq0O0u2sgCgSxv8ww-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615102006euoutp017a34bf14b11372fb3ec55b91646abdad~4xAk5KXLM2495924959euoutp01s
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220615102006euoutp017a34bf14b11372fb3ec55b91646abdad~4xAk5KXLM2495924959euoutp01s
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615102005eucas1p2e51799f03f95acf5c1f7703f8351de94~4xAjFUQzG2114721147eucas1p2r;
 Wed, 15 Jun 2022 10:20:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 6A.4B.09664.452B9A26; Wed, 15
 Jun 2022 11:20:04 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220615102004eucas1p1e458ea097d381058b16fc6daa3eec998~4xAipn0SG1175911759eucas1p1l;
 Wed, 15 Jun 2022 10:20:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615102004eusmtrp2ba89836fb0aa21ef02b3525c2b0f566c~4xAiouw-J0361403614eusmtrp2F;
 Wed, 15 Jun 2022 10:20:04 +0000 (GMT)
X-AuditID: cbfec7f2-d97ff700000025c0-37-62a9b254e53c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 63.34.09038.452B9A26; Wed, 15
 Jun 2022 11:20:04 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615102003eusmtip1d5651274b4871f0239331522fba58745~4xAhxZ7w90653206532eusmtip1U;
 Wed, 15 Jun 2022 10:20:03 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:18 +0200
Message-Id: <20220615101920.329421-12-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsWy7djP87ohm1YmGfT8trBYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBY3D+xkstizaBKTxcrVR5ksnqyfxWzRc+ADi8XfrntAsZaHQMW3
 tC0u75rDZjF/2VN2i89LW9gt1tx8ymLRtvEro4OQx+Ur3h7/Tqxh89g56y67x+WzpR6bVnWy
 eSxsmMrssXlJvcfumw1Audb7rB7v911l8+jbsorRY/2Wqywem09Xe3zeJOfRfqCbKYA/issm
 JTUnsyy1SN8ugSuj7+VjloLJvBVbNyxgaWC8xtXFyMkhIWAisbZnIWsXIxeHkMAKRontP3uh
 nC+MEvfmb2aCcD4zSjzfep0VpuX/nW6oxHJGidYt/6Ccl4wS/18uZOxi5OBgE9CSaOxkB2kQ
 EQiXOLrnHlgNs8ALJonFt+eCTRIWsJc4fPchWBGLgKrE08nvGEFsXgFriRXTvjBDbJOXmHnp
 O1gNJ1B8x+weVogaQYmTM5+wgNjMQDXNW2czgyyQEDjFKTHn8yuoU10krmx7DTVIWOLV8S3s
 ELaMxP+d85kg7GqJpzd+QzW3MEr071zPBvKBBNC2vjM5ICazgKbE+l36EOWOErdmP2eCqOCT
 uPFWEOIEPolJ26YzQ4R5JTrahCCqlSR2/nwCtVRC4nLTHBaIEg+JzbOYJzAqzkLyyywkv8xC
 WLuAkXkVo3hqaXFuemqxYV5quV5xYm5xaV66XnJ+7iZGYMI8/e/4px2Mc1991DvEyMTBeIhR
 goNZSYTXLHhlkhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe5MwNiUIC6YklqdmpqQWpRTBZJg5O
 qQamKK/9um/e/jupPGOmQ/LsBLupL8/Ec7DWNEUmFd2ZWVD7T2mTFofy67+37m/WFhUunaXv
 EL7/R2z9JuPvPu9XPChTXfhiWo1w06cmz+wtQtPePg379ffLsy8Kl+1i7ERbY/Y5Rs+fdlzL
 8pb2VEsG/uVF74KNeTdt9tCqZ5maG641q/ralE1ZOXJlT8JL2QUW6zGcnmz5s/9Bj+bkC/5z
 bbeLSmWvUm0+MeE7r7psX+Ht5aWqckWG985716zdWXtePsVv4+Nc9VpziekWBQ6HP73LWvd9
 aaeeKo/Jb0lGdpuF9g5S7r7/9RKLd/2x3rdhttnnxqiyp5y8mZ/l9zrxfvxsbFiareagec4s
 /Z4SS3FGoqEWc1FxIgBugslvBwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t/xu7ohm1YmGfz+L22x+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFp+XtrBbrLn5lMWibeNXRgchj8tXvD3+nVjD5rFz1l12j8tnSz02repk
 81jYMJXZY/OSeo/dNxuAcq33WT3e77vK5tG3ZRWjx/otV1k8Np+u9vi8Sc6j/UA3UwB/lJ5N
 UX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl5G38vHLAWT
 eSu2bljA0sB4jauLkZNDQsBE4v+dbqYuRi4OIYGljBK9X5uZIBISErcXNjFC2MISf651sUEU
 PWeUmLTwF5DDwcEmoCXR2MkOUiMiEC3RefM9WA2zwA8miQmL1oIlhAXsJQ7ffQhmswioSjyd
 /A5sKK+AtcSKaV+YIRbIS8y89B2shhMovmN2DyvIfCEBK4ld7+IhygUlTs58wgJiMwOVN2+d
 zTyBUWAWktQsJKkFjEyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAmN727GfW3Ywrnz1Ue8Q
 IxMH4yFGCQ5mJRFes+CVSUK8KYmVValF+fFFpTmpxYcYTYHOnsgsJZqcD0wueSXxhmYGpoYm
 ZpYGppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTGE1fct12DbUWbio1Cz6x3t4ncua
 GUItl5xyTF5/07x3uVKMR981dD9faUhh3v6XRiutYuJ9fl9ZI9DC5PEssnxitvdfYa/bvpfe
 v/1VZPr291u2fRdv/bvKdMkmc/3PmnuZDkHPt++ut7FVsSg+8Vs1s3TD6gfXXq99tf9i8Prf
 tlK/yz7v5vC9szB3y6qOzeGBH6O8L0pdydm9jndC4J3zJeydhYEm02/5f2wKv7XA00BLLz3E
 Qs/ts//pWZGpYjy/WQ9+/vnkjvXdz/+S7Hs1Su4aBuqFp0x7PmUtJ8u0wLc7Nbvi+VIennvu
 qL3q5dWlqUs9p/I3bBD+de70vRiPWd0Tzmyqbea8wbTDoUGJpTgj0VCLuag4EQDxEq7qdgMA
 AA==
X-CMS-MailID: 20220615102004eucas1p1e458ea097d381058b16fc6daa3eec998
X-Msg-Generator: CA
X-RootMTR: 20220615102004eucas1p1e458ea097d381058b16fc6daa3eec998
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102004eucas1p1e458ea097d381058b16fc6daa3eec998
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102004eucas1p1e458ea097d381058b16fc6daa3eec998@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v7 11/13] dm-table: allow non po2 zoned devices
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
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

As the block layer now supports non po2 zoned devices, allow dm to
support non po2 zoned device.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-table.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b553cdb6d..ec77e7830 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -251,7 +251,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (blk_queue_is_zone_start(bdev_get_queue(bdev), start)) {
+		if (!blk_queue_is_zone_start(bdev_get_queue(bdev), start)) {
 			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)start,
@@ -268,7 +268,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (blk_queue_is_zone_start(bdev_get_queue(bdev), len)) {
+		if (!blk_queue_is_zone_start(bdev_get_queue(bdev), len)) {
 			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)len,
@@ -1648,7 +1648,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
 	}
 
 	/* Check zone size validity and compatibility */
-	if (!zone_sectors || !is_power_of_2(zone_sectors))
+	if (!zone_sectors)
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

