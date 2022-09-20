Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A63C6FA92
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IoskFOWEGXS/LC/7NJqutlW0Vr82wetlu9llxQXLYXg=;
	b=Lj23vgIvxjnxeCKcsbPBh11zWxKs/p7swuGrYFdFnzU00gEmqRFoSYGPzbHHCXQdU2lbTR
	66nF2XzNmzDsfTRu85tY3OITNzNNJOwg48Ws0NvSTkk714TS6tMDj5YQP39RUezW+Cnalv
	6XnfS0AmWwEBNcO/myXSJdnT8mVH22Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-KK_YNELKNdmUaSnVqQWb1w-1; Tue, 20 Sep 2022 05:11:35 -0400
X-MC-Unique: KK_YNELKNdmUaSnVqQWb1w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D3EE85A5A6;
	Tue, 20 Sep 2022 09:11:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C04249BB60;
	Tue, 20 Sep 2022 09:11:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DEECA19465A4;
	Tue, 20 Sep 2022 09:11:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CF32E19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2F0040E80E4; Tue, 20 Sep 2022 09:11:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ABA6540E80E3
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F5791C09C9C
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:31 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-Vx_dWcnPPCS9bEnyE7UHiA-1; Tue, 20 Sep 2022 05:11:29 -0400
X-MC-Unique: Vx_dWcnPPCS9bEnyE7UHiA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091128euoutp01e4852c0a608d3bab158d7cc18653f89e~WhpVzJerK1166211662euoutp01s
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220920091128euoutp01e4852c0a608d3bab158d7cc18653f89e~WhpVzJerK1166211662euoutp01s
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091126eucas1p2b960106fff0981cfff8bd17b57d7855a~WhpTZQJnZ2445024450eucas1p23;
 Tue, 20 Sep 2022 09:11:26 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id F6.2E.29727.EB389236; Tue, 20
 Sep 2022 10:11:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091125eucas1p2e994ea9a52fcbf50fd7242ca8949c179~WhpSw2Led2433824338eucas1p2J;
 Tue, 20 Sep 2022 09:11:25 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091125eusmtrp1934e5644da1ab6a5c755dccb11282414~WhpSvMSrL0212802128eusmtrp1S;
 Tue, 20 Sep 2022 09:11:25 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-33-632983be0f41
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 54.53.10862.DB389236; Tue, 20
 Sep 2022 10:11:25 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091125eusmtip278309fbb7f1c04c78a639799ec8f059d~WhpSZfM-x2175621756eusmtip2a;
 Tue, 20 Sep 2022 09:11:25 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:11 +0200
Message-Id: <20220920091119.115879-6-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7djPc7r7mjWTDbZdYrVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UVw2Kak5
 mWWpRfp2CVwZC5/9YC14JlJxZM40pgbGZYJdjJwcEgImEgtvLWUFsYUEVjBKvLzm28XIBWR/
 YZS4cPwZI4TzmVFi2fLtzDAdC04vZoNILGeUuLZwM1TVS0aJBZe+s3cxcnCwCWhJNHaygzSI
 CKRLfP26AayGWaCZWaL//AOwScIC0RLTHj1lAbFZBFQl2i+eBbN5BawkDhxYB7VNXmIm2ExO
 Dk4Ba4k5u1vYIGoEJU7OfAJWzwxU07x1NjPIAgmBw5wSPZuuQzW7SFz6uZoJwhaWeHV8CzuE
 LSNxenIPC4RdLfH0xm+o5hZGif6d69lAPpAA2tZ3JgfEZBbQlFi/Sx+i3FFi3tTTUBV8Ejfe
 CkKcwCcxadt0Zogwr0RHmxBEtZLEzp9PoJZKSFxumgO11EPi76pW5gmMirOQPDMLyTOzEPYu
 YGRexSieWlqcm55abJiXWq5XnJhbXJqXrpecn7uJEZgkT/87/mkH49xXH/UOMTJxMB5ilOBg
 VhLhbfHXTBbiTUmsrEotyo8vKs1JLT7EKM3BoiTOm5y5IVFIID2xJDU7NbUgtQgmy8TBKdXA
 pGdcdV6xbv6vvK2bMwqeBz7Zoch09HK1in3Ps5huWZ3tPJNcpnd2H2trTtqQwjP5/ife2mX6
 NYpS8s3OEd8Xep09nF6v+uXa+YsGs+ZPkOmO0zkiWVxirDJTMcPJ72P4ceny2gXTgy+qfQp9
 q/I++diVTWeuXbHbaX5PbkvOmrlxzZfZ1LconTdTXHv9aYXiwlbG2VZXVGzOv6/aImUSe7dO
 4cUOj9d1m55bcV25V3rp5KHbkzvry/YumhAz+XHLEfaSxm+9NZF7ziycfK+OM/hqriL7ns7P
 /xt1SlfPW7nc+LFcdyKX4Rz77Fkxs3Y2e6swNB7c4tKazcLjZXtz4wRPqYrn792li9mCF+Ua
 KrEUZyQaajEXFScCAALe4xABBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t/xe7p7mzWTDVYek7RYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UXo2Rfml
 JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZC5/9YC14JlJx
 ZM40pgbGZYJdjJwcEgImEgtOL2brYuTiEBJYyiix9/JfdoiEhMTthU2MELawxJ9rXVBFzxkl
 Dk7awNLFyMHBJqAl0dgJVi8ikCtxePMEJpAaZoHJzBLNJz8xgySEBSIllracB7NZBFQl2i+e
 ZQGxeQWsJA4cWMcMsUBeYual72CDOAWsJebsbmEDsYWAajpmbWaDqBeUODnzCVgvM1B989bZ
 zBMYBWYhSc1CklrAyLSKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMKK3Hfu5ZQfjylcf9Q4x
 MnEwHmKU4GBWEuFt8ddMFuJNSaysSi3Kjy8qzUktPsRoCnT3RGYp0eR8YErJK4k3NDMwNTQx
 szQwtTQzVhLn9SzoSBQSSE8sSc1OTS1ILYLpY+LglGpgWsLa/kX+rWko3/x9WxPf9zl+zla6
 +MB3j5KibUv+5ujSsvx8leYO/fgaTv04rr5VxwJe6D1y28Ndl+Yktz93HdPJUib/G4cuOvJs
 jEoraWouFzZe+Ppq1cvIqNnvz5/+NSXGYaKTdmhPgZn/8rzgjp+L46d++MR4dk20SKqfJeNR
 IxXRub82a3nImZx857Fzqn9Kzf7Fiw1nrGOLbTBvM50RbJM9aX2scXwCn5XAEfu5PQxRh9e9
 bDS7mb3v6JR5keLc8V97XsncXe/qrhNadqbUWjj8+4MDF9fW8+zZuHzG99fXDm9dUtU1gbXq
 9er0qCYex3X3d6ectWVcoRgYJXeJd/Mpr4k6e35wHl2lxFKckWioxVxUnAgAxW6nGXEDAAA=
X-CMS-MailID: 20220920091125eucas1p2e994ea9a52fcbf50fd7242ca8949c179
X-Msg-Generator: CA
X-RootMTR: 20220920091125eucas1p2e994ea9a52fcbf50fd7242ca8949c179
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091125eucas1p2e994ea9a52fcbf50fd7242ca8949c179
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091125eucas1p2e994ea9a52fcbf50fd7242ca8949c179@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v14 05/13] nvme: zns: Allow ZNS drives that have
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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

