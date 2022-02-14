Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A509C43217
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:25 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-bKQCn2UTOUK0zE6gOr5zWQ-1; Mon, 14 Feb 2022 03:48:21 -0500
X-MC-Unique: bKQCn2UTOUK0zE6gOr5zWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6663E1006AAB;
	Mon, 14 Feb 2022 08:48:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46AD255F6D;
	Mon, 14 Feb 2022 08:48:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1F3C24CA93;
	Mon, 14 Feb 2022 08:48:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8ZRqS009199 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:35:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BF6865361CD; Mon, 14 Feb 2022 08:35:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA70C5361CC
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:35:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A143A811E78
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:35:27 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-221-1hYJfRgqPbKDTRrTBgqjqA-1; Mon, 14 Feb 2022 03:35:25 -0500
X-MC-Unique: 1hYJfRgqPbKDTRrTBgqjqA-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20220214083521epoutp025ba97d9fe8a39ef44d248309d2a63c94~TmhkvZKHH1820318203epoutp021;
	Mon, 14 Feb 2022 08:35:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20220214083521epoutp025ba97d9fe8a39ef44d248309d2a63c94~TmhkvZKHH1820318203epoutp021
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20220214083521epcas5p3faa13564d4db2b93ad37de4a2fde889d~TmhkZ4JD40865408654epcas5p3Q;
	Mon, 14 Feb 2022 08:35:21 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4JxyG94kpTz4x9QG;
	Mon, 14 Feb 2022 08:35:13 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.16.05590.1441A026; Mon, 14 Feb 2022 17:35:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20220214080558epcas5p17c1fb3b659b956908ff7215a61bcc0c9~TmH6th4YZ3176231762epcas5p1S;
	Mon, 14 Feb 2022 08:05:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220214080558epsmtrp2c5a3f5d650b84129c4a6aabcc9512707~TmH6q_H_O2569425694epsmtrp2M;
	Mon, 14 Feb 2022 08:05:58 +0000 (GMT)
X-AuditID: b6c32a4b-723ff700000015d6-f1-620a1441c60b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.C1.29871.66D0A026; Mon, 14 Feb 2022 17:05:58 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080553epsmtip2d84b9b4e078e403260c79d7d89473125~TmH2M4tpN2253222532epsmtip2t;
	Mon, 14 Feb 2022 08:05:53 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:29:51 +0530
Message-Id: <20220214080002.18381-2-nj.shetty@samsung.com>
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxjOuff2tqAlV1A5sGzWEkQkfHSWelAQtxlzM0RBzLYYBS9wBQb9
	WEsViW7FThe+FHBjUA0iigQ0giiOIcWCYYYPUVPpBhuCWiaxEURBcPIxysXNf8/7nOd5n/O+
	J0eAO3fx3QVJilRWrWBSxKQjcf2Wt7fvJ0sdYwNMVhGqbv8NR409r3joYt8JEhW+eIOjkeYn
	PFRwooiPzFYnZBw+xUP3JjMw9KR2FkONZQUYqrzYiqGnFecAunF2FEOZHfcwNPVIglpnn5Oo
	oMUC0GC3AUPGXh/UaGwjkLnhNInOXBjko+zf60nUZDPiqOL2DIa6DFMkqrdmAHT97Rkc3XrY
	TaDLthEC2SbbSHTsyjhAR3Pe8NHd6du8TR60+UEYbei/Q9L5+mE+/auhj0/ffXiFoPWlfxG0
	+Y6Wrq3KJOmr57+jT/5RAegbPTqSPtLZitNFL8dIOlc/TNKjg70EPdLUTUYs35UcnMgy8axa
	xCrilPFJioQQcVhUzGcxgbIAia8kCK0TixSMnA0Rb94a4bslKWVuiWLRfiZFO0dFMBqN2H9j
	sFqpTWVFiUpNaoiYVcWnqKQqPw0j12gVCX4KNnW9JCDg48A54d7kxOc9RTxV3uK0oqZsTAdy
	HLOAgwBSUnhcdx63Y2fqBoD5XVuzgOMcfglg/c0igiteA5g1NcTPAoJ5R2GuF8cbAXz55xCP
	cx/FYEOv0q4hKR/YMSuw00spAlZOTMz3wakSPqxrs/HtBy5UKOw8aZpPJihPOPrcQtqxkFoP
	R55OAO52HvDso+b5/g7UBmiyVeCcZglsK7YSdoxTK6C+7hRuD4DUMUf4z7NCnDNvhjebDQvY
	BT67fY3PYXf4athIcoZsACc7+zGuKAJQn6cnOVUovN84jdnHwSlvWN3gz9Efwp/aL2NcshPM
	fWvFOF4I60veYQ94qbp0oY0btExkLGAaNvRPLKz0OIA2wzSRB0SG9yYyvDeR4f/oUoBXATdW
	pZEnsJpA1VoFe+C/V45TymvB/MdaE1YPHg+88GsBmAC0ACjAxUuF0XccYp2F8czBdFatjFFr
	U1hNCwicW3k+7r4sTjn3MxWpMRJpUIBUJpNJg9bKJGJXYXtCDeNMJTCpbDLLqlj1Ox8mcHDX
	YfJ9MNqysytz2+uomeBX+dF/twnLPhqNHMqb4Zn1Xoqu3SmqQxti08J7TW4hP+yr+DQ8Mm1F
	50RGybeZw1VST9H2hi8+4P3sZOm96Htgj1oQtsTV33db9umsGnlnR3mUeYd2XVj6+K7PQ7I9
	Q/sre5Lc0woYL9OsbFNd8jdSn4GvL11ycXXSjfw49njPor3Du/mtZdcekEd3rk5f5LY/2Vps
	Ta9p6zZPrxo9N1RVz3+0oxys1g0eGXtR++XKqhrH5gbhV6b26T45fnCWWTxYPjU+ELVsyz3R
	3u1BvjWrLuvDc7ot9xOW/0KXPzFHHi7229h6yGvl1dmRSg+Z+PAF18bvpzska8WEJpGRrMHV
	GuZf/OP5VOEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42LZdlhJXjeNlyvJ4FafksX6U8eYLfbc/Mxq
	sfpuP5vFtA8/mS3eH3zMajGpfwa7xeUnfBZ7381mtbjwo5HJ4vGm/0wWexZNYrJYufook8Xz
	5YsZLXYv/Mhk0Xn6ApPFn4eGFkf/v2WzmHToGqPF06uzmCz23tK22LP3JIvF5V1z2CzmL3vK
	btF9fQebxb7Xe5ktlh//x2RxbtYfNosdTxoZLbb9ns9scfjeVRaLda/fs1i8/nGSzaJt41dG
	i9aen+wW5/8eZ3VQ9rh8xdtj1v2zbB4Tm9+xe+ycdZfd4/y9jSwezQvusHhcPlvqsWlVJ5vH
	5iX1HpNvLGf02H2zgc2j6cxRZo8Zn76wefQ2v2Pz+Pj0FovH+31X2QLEorhsUlJzMstSi/Tt
	Ergy3t6cwVowgadixr5upgbGHq4uRg4OCQETiWm96l2MXBxCArsZJf717WbpYuQEiktKLPt7
	hBnCFpZY+e85O0RRM5PE5I5jzCDNbALaEqf/c4DUiAiwSKz8/p0FpIZZ4AS7xPmWQ+wgCWEB
	e4kzkw+ADWIRUJX4+PYaG4jNK2Al8f75d0aIBcoSCx8eZAWxOQWsJQ68Xg5WLwRUM+MqxBxe
	AUGJkzOfgB3HLCAv0bx1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvX
	S87P3cQITihamjsYt6/6oHeIkYmD8RCjBAezkghv3FnOJCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqY2nac05xrOOOM0YoDzzrm9l1w4CpIPpEW7B9U
	8+r47F8J+3McLi49qdy4ZFud6epX+x7qvDO8JhPknaa9M6Fg8olO2e8fmphFwjaFC1Z9Upr1
	e/9Wz/VPwyoNrPc1+hl+07k/z2p1pAqTU5rBSyWhrvnWXe6vxBVcX8hvKft/kyPl8f9WmfNM
	ce2t2rXmjaIrtn47+HT7zsprIt6q9bnFbPvPOvp1H6tj1hTY2PizZXW+HMt+x/WVaS6lPyt3
	R5+eU743t3BpQUL8olLx6wuebP2RPeXvrRz+WTzf8lUXqivv1/6iInnUdDoj3+vmSy9nMzCu
	rd6n/sE7rshMaE37uunTF5t98F14PXHv5KXlSizFGYmGWsxFxYkAWynKtZcDAAA=
X-CMS-MailID: 20220214080558epcas5p17c1fb3b659b956908ff7215a61bcc0c9
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080558epcas5p17c1fb3b659b956908ff7215a61bcc0c9
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080558epcas5p17c1fb3b659b956908ff7215a61bcc0c9@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8ZRqS009199
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
	hch@lst.de, Alexander, Nitesh Shetty <nj.shetty@samsung.com>,
	chaitanyak@nvidia.com, SelvaKumar S <selvakuma.s1@samsung.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>,
	axboe@kernel.dk, tytso@mit.edu, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Viro <viro@zeniv.linux.org.uk>
Subject: [dm-devel] [PATCH v3 01/10] block: make bio_map_kern() non static
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: SelvaKumar S <selvakuma.s1@samsung.com>

Make bio_map_kern() non static

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/blk-map.c        | 2 +-
 include/linux/blkdev.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde0156..c110205df0d5 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -336,7 +336,7 @@ static void bio_map_kern_endio(struct bio *bio)
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_map_kern(struct request_queue *q, void *data,
+struct bio *bio_map_kern(struct request_queue *q, void *data,
 		unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3bfc75a2a450..efed3820cbf7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1106,6 +1106,8 @@ extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, int flags,
 		struct bio **biop);
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+		gfp_t gfp_mask);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

