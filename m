Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6901DC04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658940496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yT3dmacz2EKSkOdLkqrGdjDeENqxcYkAsl92+ZIljOs=;
	b=BD5uMMnLppxZ5NHBkvjmG30gz5XsYkgWZ5WhEhEw1Y9Ku3MOzmFwBGvBX0/oc9EooCBwBg
	jKhYPd0trfVErwcNlEBpOV21OSK1AIif+NCa48HtawQKCyHCTpLH/810MVri2qDPso7zWK
	F4Pzb1hV0r3bwVv6m5t2Uy0hnFXOrHk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-aR1fbE58Pti8YdmxrW06CQ-1; Wed, 27 Jul 2022 12:48:14 -0400
X-MC-Unique: aR1fbE58Pti8YdmxrW06CQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99AF8802E5C;
	Wed, 27 Jul 2022 16:48:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8847290A04;
	Wed, 27 Jul 2022 16:48:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31BED194705B;
	Wed, 27 Jul 2022 16:48:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE48A1945DA2
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:31:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CDDBF1410DDA; Wed, 27 Jul 2022 16:31:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C8DA51415118
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B025C3C1069B
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:24 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-UQxzjbmCNUmh2TrBnPdHXw-1; Wed, 27 Jul 2022 12:31:23 -0400
X-MC-Unique: UQxzjbmCNUmh2TrBnPdHXw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162251euoutp01a484904674fd6d8656e8ad80d1d6f6ab~FvDSHTTxt2257722577euoutp01d
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220727162251euoutp01a484904674fd6d8656e8ad80d1d6f6ab~FvDSHTTxt2257722577euoutp01d
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220727162250eucas1p1676d266b6651c9131d96258f7b3a9761~FvDQsKCQk1290212902eucas1p1A;
 Wed, 27 Jul 2022 16:22:50 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 6C.9B.10067.95661E26; Wed, 27
 Jul 2022 17:22:49 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220727162249eucas1p28fa44c840e590f6f1b53e0cc12ee3771~FvDQAQydk2169421694eucas1p2m;
 Wed, 27 Jul 2022 16:22:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220727162249eusmtrp144e06ed4881c4884a2ac90fdf9241a94~FvDP-ilv30298902989eusmtrp1J;
 Wed, 27 Jul 2022 16:22:49 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-b6-62e1665983b9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 76.8D.09038.95661E26; Wed, 27
 Jul 2022 17:22:49 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162248eusmtip15937a1bbdaa281a604501e0b83536562~FvDPpfQIK0065000650eusmtip1F;
 Wed, 27 Jul 2022 16:22:48 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:37 +0200
Message-Id: <20220727162245.209794-4-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djPc7qRaQ+TDJ5us7JYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDI279/KXtAn
 UnGkczJLA+MlgS5GTg4JAROJpw9XMHcxcnEICaxglFg2fQoThPOFUeLiuyZGkCohgc+MEo/+
 W8J0NH7dxQhRtJxRYt3KZ1DOc0aJ+8f2sXYxcnCwCWhJNHaygzSICBRLPHzXygJSwyxwgEni
 we0WNpCEsECUxJKrXWAbWARUJfq2LWICsXkFrCReTr/MDLFNXmLmpe9ggzgFrCU2T5kHVSMo
 cXLmExYQmxmopnnrbKj69ZwSCzeyQ9guEq2nprBC2MISr45vgYrLSJye3MMCYVdLPL3xG+x/
 CYEWRon+nevZQB6QAFrWdyYHxGQW0JRYv0sfotxRonHBJSaICj6JG28FIS7gk5i0bTozRJhX
 oqNNCKJaSWLnzydQSyUkLjfNgVrqIdG/u5ltAqPiLCS/zELyyyyEvQsYmVcxiqeWFuempxYb
 5aWW6xUn5haX5qXrJefnbmIEJsHT/45/2cG4/NVHvUOMTByMhxglOJiVRHgTou8nCfGmJFZW
 pRblxxeV5qQWH2KU5mBREudNztyQKCSQnliSmp2aWpBaBJNl4uCUamBazeAqMFlxhdJ/X5XW
 m8mLb7hu+agS5tX0ubBZUtdBp/rUsYUTjW1mrNgm82jtNZHXM7zOP75abCcm8s4qOfHx82dz
 BSa4/Hpds9uv+IxrmNWMpS9PpN1KmvFT875kl8/XfYUG71g/Td896Y3up8PMfEcS/qqJvfSM
 TTr10v3UuzTbg6KrBQVmVi/J+JdqLsS/VXmqpr7p53kTl71j0/D0sPrl3vf7qeeNR/t+li0r
 3enw1oxZm9f2h8O8N8w/Lu8JVEp0Y5AzSZR2PFbZatlvvpZreYCZ1c+unI4Pdf//pMusemwj
 Kba0jver4HQ3Xw/3q6Ff3F3O5WTu+Fn7cMWBzohDv9Nm7FJTPvAmaIKiEktxRqKhFnNRcSIA
 7/jcKfEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xu7qRaQ+TDJYc4LJYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DI279/KXtAnUnGkczJLA+MlgS5GTg4JAROJ
 xq+7GLsYuTiEBJYySqzs38sOkZCQuL2wiRHCFpb4c62LDcQWEnjKKNE4PayLkYODTUBLorGT
 HcQUEaiUOPtFFmQMs8A5JombF6+xgcSFBSIkmlZxgHSyCKhK9G1bxARi8wpYSbycfpkZYrq8
 xMxL38G2cgpYS2yeMo8JYpOVxLMHH9kg6gUlTs58wgJiMwPVN2+dzTyBUWAWktQsJKkFjEyr
 GEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAqN127GfW3Ywrnz1Ue8QIxMH4yFGCQ5mJRHehOj7
 SUK8KYmVValF+fFFpTmpxYcYTYHunsgsJZqcD0wXeSXxhmYGpoYmZpYGppZmxkrivJ4FHYlC
 AumJJanZqakFqUUwfUwcnFINTFFz49vkKwO6XskdSQ/Tr2RW985y+Zr8SaJ1StyL9RcX7N9f
 oxV8daXFnZqD22SU771hlJfkeGYYYcRwIilsFStPscKycsNPaduiKl7LyL++wcz7bPNBT7GJ
 eunr202y9oXFHyldmHfrjrhaSuSXdalxEUWz76f96w+YEvtycqG/UnfvTM3jm4/sCjqlXHM6
 Ithc0evZrvaTFeFT/S2PxhTPOVbYfsk8vO2GqN+KK7+DFsZ9up82XzV4gvvOhkNbls0U1Do8
 lZstjl9ytmndzZD2G5LFyb+1q7pCtn3JV979XneXzw2lC68uPbgawqhxc3Ogsl7IeaumRsXt
 K5mFdRqDQ6YfW9ifXGj8XMZciaU4I9FQi7moOBEAclS0ql8DAAA=
X-CMS-MailID: 20220727162249eucas1p28fa44c840e590f6f1b53e0cc12ee3771
X-Msg-Generator: CA
X-RootMTR: 20220727162249eucas1p28fa44c840e590f6f1b53e0cc12ee3771
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162249eucas1p28fa44c840e590f6f1b53e0cc12ee3771
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162249eucas1p28fa44c840e590f6f1b53e0cc12ee3771@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v8 03/11] nvme: zns: Allow ZNS drives that have
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
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
 drivers/nvme/host/zns.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 12316ab51bda..73e4ad495ae8 100644
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
@@ -197,7 +191,11 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
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

