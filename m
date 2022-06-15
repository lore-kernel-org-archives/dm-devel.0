Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEEEAC43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:19:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-QuAO9P0gPsaJVL9_1WMvpg-1; Wed, 15 Jun 2022 06:19:44 -0400
X-MC-Unique: QuAO9P0gPsaJVL9_1WMvpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 894F6800971;
	Wed, 15 Jun 2022 10:19:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7683F4010E4D;
	Wed, 15 Jun 2022 10:19:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2AF5A1947B84;
	Wed, 15 Jun 2022 10:19:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC7F5194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:19:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71DE31121319; Wed, 15 Jun 2022 10:19:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D9181121315
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50E0D802D1F
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:40 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-WjtbEnucOFKs6b_aThvZ7A-1; Wed, 15 Jun 2022 06:19:38 -0400
X-MC-Unique: WjtbEnucOFKs6b_aThvZ7A-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101937euoutp028ce7392b3dc4ff539b4bc5e4db64be03~4xAJoEgzG2870528705euoutp02S
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220615101937euoutp028ce7392b3dc4ff539b4bc5e4db64be03~4xAJoEgzG2870528705euoutp02S
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615101935eucas1p28855fe6444bf0d736a79f31c7e260f2e~4xAH-GRyc1132211322eucas1p2x;
 Wed, 15 Jun 2022 10:19:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 28.67.10067.732B9A26; Wed, 15
 Jun 2022 11:19:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220615101935eucas1p26a7bc245d88a89312158d7a265f64aef~4xAHQro9O1132211322eucas1p2w;
 Wed, 15 Jun 2022 10:19:35 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101935eusmtrp25b8235c373fbcc302cd299295374e82b~4xAHPZ7Ei0361403614eusmtrp2B;
 Wed, 15 Jun 2022 10:19:34 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-6a-62a9b23727ab
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 0B.14.09038.632B9A26; Wed, 15
 Jun 2022 11:19:34 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101934eusmtip1d8b298e6c644ba681b491ec040203480~4xAGNVgnE1144211442eusmtip1H;
 Wed, 15 Jun 2022 10:19:34 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:10 +0200
Message-Id: <20220615101920.329421-4-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7djPc7rmm1YmGcztNLJYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBY3D+xkstizaBKTxcrVR5ksnqyfxWzRc+ADi8XfrntAsZaHQMW3
 tC0u75rDZjF/2VN2ixsTnjJafF7awm6x5uZTFou2jV8ZHYQ9Ll/x9vh3Yg2bx85Zd9k9Lp8t
 9di0qpPNY2HDVGaPzUvqPXbfbADKtd5n9Xi/7yqbR9+WVYwe67dcZfHYfLra4/MmOY/2A91M
 AfxRXDYpqTmZZalF+nYJXBlzNm5jLfgtWvH4oFQDY4dQFyMnh4SAicSNe6uZuxi5OIQEVjBK
 XNy2iw3C+cIocWzCB3aQKiGBz4wST755wXScPvSGHaJoOaPErWdbWSGKXjJKzG4I7GLk4GAT
 0JJo7ATrFREIlzi65x4TiM0s0Mcs8eRlHYgtLBAl8eP9eTYQm0VAVeLpsXdgY3gFrCQmvVzF
 CLFLXmLmpe9gczgFrCV2zO6BqhGUODnzCQvETHmJ5q2zwT6QELjEKfHo53cmiGYXiaaefqhB
 whKvjm9hh7BlJP7vnA9VUy3x9MZvqOYWRon+nevZQB6QANrWdyYHxGQW0JRYv0sfotxR4vDh
 dmaICj6JG28FIU7gk5i0bTpUmFeiow0atkoSO38+gVoqIXG5aQ4LhO0hsezmdtYJjIqzkDwz
 C8kzsxD2LmBkXsUonlpanJueWmyUl1quV5yYW1yal66XnJ+7iRGYNE//O/5lB+PyVx/1DjEy
 cTAeYpTgYFYS4TULXpkkxJuSWFmVWpQfX1Sak1p8iFGag0VJnDc5c0OikEB6YklqdmpqQWoR
 TJaJg1Oqgcl+e+/CzW82nZp1wjtR0oD9bPg91h2NT3du3Wjy+sius5lqlpsE7+YtP3u74c48
 5jd73PgOGTN88jf48ch1FZPALbXvwhxmaid7W7zVC2w93x+sWsc0v/RMz3YvraLN7OnmjNY2
 RzkZnyurib+cc+npBE3v45XGsXMmHNCR+3FxyaS8rb8WMO1ewsRz4ayD4h8ZhgqjXfXbglSM
 LyhprRefvCMxaF6G0e7YUmOug3wvf2pHrrZ+/PXQLUEeo2uuKilmPNmBu27Wc/jovm3xyL8r
 o2v74PDXxQeXr8z/fFwgpPvwp+uyDxSK77MebP1f3Hvho8pq7ys7tvw8sTfhV/SiDt9dHEke
 7/jrJEzaN05XYinOSDTUYi4qTgQAsawYCQkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7pmm1YmGXw5bGax+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 Avij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DLm
 bNzGWvBbtOLxQakGxg6hLkZODgkBE4nTh96wdzFycQgJLGWU2Pf9HxtEQkLi9sImRghbWOLP
 tS42iKLnjBI/Dh1j6mLk4GAT0JJo7GQHqRERiJbovPkerIZZYAGzxOk7E9hBaoQFIiT+PjIB
 qWERUJV4euwdK4jNK2AlMenlKqj58hIzL30Hm8MpYC2xY3YPK0irEFDNrnfxEOWCEidnPmEB
 sZmBypu3zmaewCgwC0lqFpLUAkamVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIERvu3Yzy07
 GFe++qh3iJGJg/EQowQHs5IIr1nwyiQh3pTEyqrUovz4otKc1OJDjKZAZ09klhJNzgemmLyS
 eEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0xJLU7NTUgtQimD4mDk6pBqaWk6Y35X1bNPc/efzh
 l/Khc1Exm9fl3A19E+h2f9P2jugu8SO/7820OX76z/6HbtvVrS+dT6xet2FD96yNQXltRz8z
 1N6WMXyn+kLaYHtbX0nW4dfaNn432o5aLihoX7ex7PdtuTU/v79fVRmSWRwbZjODq79HheXW
 ApbmxQbdUpNjXJfJsa65wxsYuWlOXLNKf+qu9b/zirJU/0mlqgdHb/a43GX+Oezr1Fv515lE
 H07bxueqvjHb+fQ/gwdunYEm4eJslzm3cpjfUzJb9+Ji4CePq0JzVt/xWrNGe24X4yxTGZ/o
 fYJ70+ND13tEBJxmuCEVVOfQx+S1btWS/qXpb2V2BJkkXs9MuhlU6K7EUpyRaKjFXFScCACL
 +j2SeQMAAA==
X-CMS-MailID: 20220615101935eucas1p26a7bc245d88a89312158d7a265f64aef
X-Msg-Generator: CA
X-RootMTR: 20220615101935eucas1p26a7bc245d88a89312158d7a265f64aef
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101935eucas1p26a7bc245d88a89312158d7a265f64aef
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101935eucas1p26a7bc245d88a89312158d7a265f64aef@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v7 03/13] nvme: zns: Allow ZNS drives that have
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
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/host/zns.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 9f81beb4d..d92f937d5 100644
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
 
 	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
@@ -128,8 +121,13 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 	const size_t min_bufsize = sizeof(struct nvme_zone_report) +
 				   sizeof(struct nvme_zone_descriptor);
 
+	/*
+	 * Division is used to calculate nr_zones with no special handling
+	 * for power of 2 zone sizes as this function is not invoked in a
+	 * hot path
+	 */
 	nr_zones = min_t(unsigned int, nr_zones,
-			 get_capacity(ns->disk) >> ilog2(ns->zsze));
+			 div64_u64(get_capacity(ns->disk), ns->zsze));
 
 	bufsize = sizeof(struct nvme_zone_report) +
 		nr_zones * sizeof(struct nvme_zone_descriptor);
@@ -182,6 +180,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
+	u64 remainder = 0;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
 		return -EINVAL;
@@ -197,7 +196,11 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
 	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
 
-	sector &= ~(ns->zsze - 1);
+	/*
+	 * Round down the sector value to the nearest zone start
+	 */
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

