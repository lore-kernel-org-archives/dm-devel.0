Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB193ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970959;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WJKErgm9sKg3du9HTlsaQiFRsJuJkb/b98khkUDZFGs=;
	b=fLc8+BYi4zSEN+DXcH73/JGBcx93GA7ZWUhobgwBBC9UsCTRAUH8Fkv52jov4jN03KiDTV
	bUL7DlgtD8DWcx7zRdgTmfr8OmqVW0bFXtN8DFE7oLnsdGMIYlv1inOXhdBgFgXqvRTZyf
	r1RsOrajAviHHEdYxeCTlVSV3DgKhJ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-O4ipTDRHPVmU2Mhozkn5Pw-1; Mon, 12 Sep 2022 04:22:38 -0400
X-MC-Unique: O4ipTDRHPVmU2Mhozkn5Pw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F27B33C0E201;
	Mon, 12 Sep 2022 08:22:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E08D32166B26;
	Mon, 12 Sep 2022 08:22:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D4BE71946A43;
	Mon, 12 Sep 2022 08:22:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A3F21946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF6AE2024CBE; Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB66B2028DC1
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDF433810781
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-ldomgpf8MZG8mNfJyI_nVQ-1; Mon, 12 Sep 2022 04:22:33 -0400
X-MC-Unique: ldomgpf8MZG8mNfJyI_nVQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082216euoutp0204645f4e6daec4a0b1c7029278916ce3~UD0Gby8832672726727euoutp02D
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220912082216euoutp0204645f4e6daec4a0b1c7029278916ce3~UD0Gby8832672726727euoutp02D
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082212eucas1p227cff65cf4d38a4326b690c0955c4dad~UD0CRIaG83149631496eucas1p2I;
 Mon, 12 Sep 2022 08:22:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id F7.98.29727.43CEE136; Mon, 12
 Sep 2022 09:22:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220912082211eucas1p2d7cbc34d8ba679e525442128698a1116~UD0BaXdfk0134901349eucas1p24;
 Mon, 12 Sep 2022 08:22:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220912082211eusmtrp1a506910c09c509ba02e69c14d0927f7b~UD0BZjqKh1301813018eusmtrp1h;
 Mon, 12 Sep 2022 08:22:11 +0000 (GMT)
X-AuditID: cbfec7f2-7932da800001741f-f8-631eec345fe9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 2B.2F.07473.33CEE136; Mon, 12
 Sep 2022 09:22:11 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082211eusmtip12c21b3997194ab192c3022a7c08b005b~UD0BBbxCs0841308413eusmtip1V;
 Mon, 12 Sep 2022 08:22:11 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:56 +0200
Message-Id: <20220912082204.51189-6-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djP87omb+SSDU7sE7ZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlTG7
 ZRtbwRaRit2n37A2MP4U6GLk5JAQMJHYdLSFvYuRi0NIYAWjxJuDL9ggnC+MEl9+r2WGcD4z
 Ssw+85QNpmXymTlMILaQwHJGicY/ZRBFLxkl5hx9xtLFyMHBJqAl0djJDlIjIpAu8X36OyaQ
 GmaBO0wSTYdeMIIkhAWiJX7c6GQFsVkEVCWuvusCs3kFLCVO73jMCrFMXmLmpe9ggzgFrCRe
 r2plhKgRlDg58wkLiM0MVNO8dTbYpRIC2zklrk9byQTR7CLR9nAOO4QtLPHq+BYoW0bi9OQe
 Fgi7WuLpjd9QzS2MEv0717OBfCAhYC3RdyYHxGQW0JRYv0sfIuooMfkZI4TJJ3HjrSDEBXwS
 k7ZNZ4YI80p0tAlBzFaS2PnzCdROCYnLTXOgdnpIdO04xDKBUXEWkl9mIfllFsLaBYzMqxjF
 U0uLc9NTiw3zUsv1ihNzi0vz0vWS83M3MQLT4el/xz/tYJz76qPeIUYmDsZDjBIczEoivCyG
 0slCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZMzNyQKCaQnlqRmp6YWpBbBZJk4OKUamPIizkas
 4mBpsP50WuPctvaHu/p27og2U5mebnn634VZ6VWyaVysvi9r2u41uefH1544ovB0YuVmucyM
 i2vWV0xmF+xQD878Lee6SNqLX0U65F60bvbKgk96JRlFu46lfqvawGe+5kKil/iDL5uPPzEw
 2Bqb9XxKWimnr1RZikaU1t5tM7MYF2ruTvwUm9vLuqKf7RPbii2O31Zvm/PTwvdg54TCCtEe
 zr/frxh1L7F1zjc5N/FfV/gc/xXvdXduK9KJfuwSs1xQmvuFVbWv+Lmjmg8cW5SqZj7rbsuJ
 XG9/8vKJJyL+L78JOC/98Vt2q9eWiJJDj5lqO3RWvF1z4eDGNt4vPfsvKlycWVPDpsRSnJFo
 qMVcVJwIAI3fKHv2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xu7rGb+SSDY7+EbVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eglzG7ZRtbwRaRit2n37A2MP4U6GLk
 5JAQMJGYfGYOUxcjF4eQwFJGiWd7P7BAJCQkbi9sYoSwhSX+XOtigyh6zihxfPU/oCIODjYB
 LYnGTnaQGhGBXInPK3+A1TALvGGS+LJkEhNIQlggUuLO3IVgRSwCqhJX33Wxgti8ApYSp3c8
 ZoVYIC8x89J3sBpOASuJ16tawRYLAdWc/XaDHaJeUOLkzCdgxzED1Tdvnc08gVFgFpLULCSp
 BYxMqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQKjd9uxn5t3MM579VHvECMTB+MhRgkOZiUR
 XhZD6WQh3pTEyqrUovz4otKc1OJDjKZAd09klhJNzgemj7ySeEMzA1NDEzNLA1NLM2MlcV7P
 go5EIYH0xJLU7NTUgtQimD4mDk6pBibJ5eof5ijMiUs+dUUlI3T+MtMDM1r/3+OaFX+x3PxM
 3zqhxvpP9ySyf3zi3aghPG/fBd3jgUqhG27vbOub3+qkPo+ZaXvfH8F9YjP5eb9POOwRuccr
 LfPi31MHVvTfX/X3oOSlv5H/xOUX7P6sZpMYkMxvt93nXMzshHLlokkng9c+fBRvrPbDUbYq
 ds5Kw7DbNw482hnYEp5efXfVHLPcl9tduN02bg7Zsvfgs21aH+JUb0/v89vmGy2X8cKg6oY6
 f0zK8mZXm0+cJeturVO50+aY7v+u/6r4/7P2mk9MCr75SM06XRrZJi6abXZgxqwF566I/H3M
 vOR38Ym3Aqdc1mV1nZRJDmQr/dsslvhAiaU4I9FQi7moOBEAzfaJO2cDAAA=
X-CMS-MailID: 20220912082211eucas1p2d7cbc34d8ba679e525442128698a1116
X-Msg-Generator: CA
X-RootMTR: 20220912082211eucas1p2d7cbc34d8ba679e525442128698a1116
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082211eucas1p2d7cbc34d8ba679e525442128698a1116
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082211eucas1p2d7cbc34d8ba679e525442128698a1116@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v13 05/13] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the condition which disallows non-power_of_2 zone size ZNS drive
to be updated and use generic method to calculate number of zones
instead of relying on log and shift based calculation on zone size.

The power_of_2 calculation has been replaced directly with generic
calculation without special handling. Both modified functions are not
used in hot paths, they are only used during initialization &
revalidation of the ZNS device.

As rounddown macro from math.h does not work for 32 bit architectures,
round down operation is open coded.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/host/zns.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 12316ab51bda..fe1d715d61cc 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -101,13 +101,6 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 	}
 
 	ns->zsze = nvme_lba_to_sect(ns, le64_to_cpu(id->lbafe[lbaf].zsze));
-	if (!is_power_of_2(ns->zsze)) {
-		dev_warn(ns->ctrl->device,
-			"invalid zone size:%llu for namespace:%u\n",
-			ns->zsze, ns->head->ns_id);
-		status = -ENODEV;
-		goto free_data;
-	}
 
 	disk_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
@@ -129,7 +122,7 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 				   sizeof(struct nvme_zone_descriptor);
 
 	nr_zones = min_t(unsigned int, nr_zones,
-			 get_capacity(ns->disk) >> ilog2(ns->zsze));
+			 div64_u64(get_capacity(ns->disk), ns->zsze));
 
 	bufsize = sizeof(struct nvme_zone_report) +
 		nr_zones * sizeof(struct nvme_zone_descriptor);
@@ -182,6 +175,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
+	u64 remainder = 0;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
 		return -EINVAL;
@@ -197,7 +191,9 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
 	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
 
-	sector &= ~(ns->zsze - 1);
+	/* Round down the sector value to the nearest zone start */
+	div64_u64_rem(sector, ns->zsze, &remainder);
+	sector -= remainder;
 	while (zone_idx < nr_zones && sector < get_capacity(ns->disk)) {
 		memset(report, 0, buflen);
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

