Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C9FC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 11:40:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 262EB61038
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 11:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 262EB61038
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-Tsa6eL6bNF6pdcXpYuYdwg-1; Tue, 17 Aug 2021 07:40:48 -0400
X-MC-Unique: Tsa6eL6bNF6pdcXpYuYdwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43588107ACF5;
	Tue, 17 Aug 2021 11:40:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C6D95D6A8;
	Tue, 17 Aug 2021 11:40:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BDA77181A0F7;
	Tue, 17 Aug 2021 11:40:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HBbFLe010926 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 07:37:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C81D0C77CA; Tue, 17 Aug 2021 11:37:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C28DBC77FF
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:37:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B880800260
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:37:13 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-72-w8u-5-DYN4aDt2imo8pFww-1; Tue, 17 Aug 2021 07:37:11 -0400
X-MC-Unique: w8u-5-DYN4aDt2imo8pFww-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id
	20210817112846epoutp045ff0b6c3300ffa31ba89e94e145c941c~cFIT4fAni1040610406epoutp04h
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:28:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
	20210817112846epoutp045ff0b6c3300ffa31ba89e94e145c941c~cFIT4fAni1040610406epoutp04h
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20210817112845epcas5p32d1c089554c65f3e91025beaf33a6e7a~cFITDu5-e3045330453epcas5p3g;
	Tue, 17 Aug 2021 11:28:45 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Gppgr4VQ5z4x9Pv;
	Tue, 17 Aug 2021 11:28:40 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1D.6B.09595.86D9B116; Tue, 17 Aug 2021 20:28:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20210817101747epcas5p1242e63ec29b127b03b6f9f5f1b57f86e~cEKVUwePg2631326313epcas5p1u;
	Tue, 17 Aug 2021 10:17:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210817101747epsmtrp2b441c8dd1f0d6b49880929fbd90a78c8~cEKVTZycv2759327593epsmtrp2e;
	Tue, 17 Aug 2021 10:17:47 +0000 (GMT)
X-AuditID: b6c32a4a-ed5ff7000000257b-db-611b9d682598
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CF.4E.08394.BCC8B116; Tue, 17 Aug 2021 19:17:47 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20210817101743epsmtip26ea1dba895d2587d2d1253811ee1d451~cEKRjxdLs0079500795epsmtip2g;
	Tue, 17 Aug 2021 10:17:43 +0000 (GMT)
From: SelvaKumar S <selvakuma.s1@samsung.com>
To: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
Date: Tue, 17 Aug 2021 15:44:17 +0530
Message-Id: <20210817101423.12367-2-selvakuma.s1@samsung.com>
In-Reply-To: <20210817101423.12367-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxj23FtuC6HmWjAeq9tYE2CFAK2j3QEBMaK5EXAky8ZwOLjATcso
	bdMPcOoGuA8QpoKWr1oGMQwHJDiLVD4NAcTxFZgoiBsGNtCIU0CmYABZS3Hz33Oe933eJ+9z
	8nJwXiGbz0lW6hiNklYICCeWpVP4no+8bActmnjIR5d7u3FkqrEAVDt+lkBFcy9x9F32CwwN
	T21GbU8vOKDq2hsY+uuPBTZazb2PoRtrTwg0+KQTQ+c6RgBqNRtYqH4xh0Bt97xRa1sPC5VX
	TbNR3mgjgS7dfIWhgpw7GGqcygLIslyOo9uGiziamB1lo8dLPQT6/spzgJaXTEToTmr4djjV
	ZBxnU/U/e1HDA3rKXHOKoOorM6iWsUyCmp++x6Jmr98hqDNXawC1YH6bym7Pw6KcD6cEyRk6
	idG4McpEVVKyUhYsCP8obl+cRCoS+4gD0AcCNyWdygQLwiKifA4kK6xhCNzSaIXeSkXRWq3A
	LyRIo9LrGDe5SqsLFjDqJIXaX+2rpVO1eqXMV8noAsUi0S6JtTE+Rd7UOeSgHnM+Ovh8lMgE
	TU65wJEDSX/4e95P7FzgxOGRLQCe7zJg9sczAPset29UXgBYdf0H7LWkpapuo9AG4LmKk7it
	wCMXABxpkNkwQfrAkUozy4ZdyT2w+mWNg02Ak70sWDx7kW0ruJCBsNGY5WDDLNIdDixPr/Nc
	MhgaJ06y7W7vwNJbi1bM4TiSIbD5mbu9ZQvsKZ1an49bW75puIDb5kOy1hEWWOaBXRsGS1qK
	cTt2gTM3r27M5MOFp22EHafDB6eKNjbLBPDMbLod74G/ta5iNl+cFMLLzX52+i1Y2FuH2X03
	w9PLUxtSLmz8cWq9HZIesPea1E7vhHOdzRtOFCxpX2XZcyuwpjt6hZUP3IxvrGN8Yx3j/84V
	AK8B2xm1NlXGaCXqXUom/b9PTlSlmsH6fXgdbASTE3O+HQDjgA4AObjAlevJ4dM8bhL95TFG
	o4rT6BWMtgNIrHEX4PytiSrrgSl1cWL/AJG/VCr1D3hfKhZs48ZG7KB5pIzWMSkMo2Y0r3UY
	x5Gfie2nV/w8jsSuxJi7nTkN40dn9xd6C6fXJksf9vRFhwRGhxH94Nfu7n3KfEPiNql3/PLe
	/rSMlQcfk1tE1b/kx3oc2h6SzDN+EhTo07UKDot55si9f6vr3CVxbM/o8BOfOifohZt80+ay
	dIZQGUzoKopNE7p8fTyKGPDs2eR57JrTu0EJuQdOdPDlJV94vTqbE3P6q/GK0EsztJPFlKk4
	YmzpPx6vC2GI+Xy982yGUXBfmvfI1Rtnhszhn3Fj6ky9I6MJJsehwdWysRjToicZOaAM7Lu7
	dbfhz6JHH2avlVfKb90t+3wfv2B3sVBycPAflxnivBmPWJKOfTvZ7hppCROwtHJa7IVrtPS/
	ClP5S6gEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWy7bCSvO7pHulEg++HRSzWnzrGbDFn1TZG
	i9V3+9kspn34yWzR2v6NyeLyEz6Lve9ms1qsXH2UyeLxnc/sFn+77jFZHP3/ls3i/NvDTBaT
	Dl1jtNizaQqLxebvHWwWe29pW+zZe5LFYv6yp+wW3dd3sFksP/6PyWJix1Umix1PGhkttv2e
	z2xxZcoiZosH76+zW7z+cZLNom3jV0aL3z/msDnIeFy+4u2xc9Zddo/NK7Q8Lp8t9di0qpPN
	Y/OSeo/dNxvYPD4+vcXi8X7fVTaPvi2rGD0+b5LzaD/QzRTAE8Vlk5Kak1mWWqRvl8CVsfPw
	BdaCmzwV579eZ2tg3MnVxcjJISFgIrF72Tp2EFtIYDejxIoOeYi4jMTau51sELawxMp/z4Fq
	uIBqPjJKLOu8xwSSYBPQlbi2ZBMLiC0i4Chx+tM2JpAiZoFXLBL37u5mBkkIC1hJ7JjVyApi
	swioSpz9/RRsG6+ArcSsB03sEBvkJWZe+g5kc3BwCthJ7PqkCnGQrcT+PVOhygUlTs58AraL
	Gai8eets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREc4Vqa
	Oxi3r/qgd4iRiYPxEKMEB7OSCK86h1SiEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTS
	E0tSs1NTC1KLYLJMHJxSDUxVLwud3lq2fFOscdqW2XPEjUdUI8bw3+elt1tX8QrIMLEeu57/
	fq9V8cbPwdYGxr+srV/27dU+YXW69WnZ7EeJZ0qdJHN+evEdjXdke/Xbd1r7mbMT1jJUWbB5
	PCm8++tr9O/uZ9ufpR6PrLFb/J0vZ2Or/fR/fz90rcuc0PjQ+012lIDKcVWNRW7KYTPZPNfY
	77GQnmhyyT14D0Osf/CRR2ra9iX+uro7N68WfN96xL5/thy356K0qqXX9q42Nr2gV3hZW7Go
	sorjqOCfs4WrS2Kf2146aiyTfnzluV6Ly8tYymOnFq4NYhfnEP3te0ViXUNXG2enzo4P5xf+
	1epx+8ppmMq6YkPBg8rnPUosxRmJhlrMRcWJAJ0CkOFfAwAA
X-CMS-MailID: 20210817101747epcas5p1242e63ec29b127b03b6f9f5f1b57f86e
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210817101747epcas5p1242e63ec29b127b03b6f9f5f1b57f86e
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101747epcas5p1242e63ec29b127b03b6f9f5f1b57f86e@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17HBbFLe010926
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, djwong@kernel.org, dm-devel@redhat.com, hch@lst.de,
	agk@redhat.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, willy@infradead.org,
	nj.shetty@samsung.com, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, selvajove@gmail.com,
	mpatocka@redhat.com, javier.gonz@samsung.com, kbusch@kernel.org,
	axboe@kernel.dk, damien.lemoal@wdc.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-api@vger.kernel.org,
	johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
	joshiiitr@gmail.com, asml.silence@gmail.com
Subject: [dm-devel] [PATCH 1/7] block: make bio_map_kern() non static
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Make bio_map_kern() non static, so that copy offload/emulation can use
it to add vmalloced memory to bio.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/blk-map.c        | 2 +-
 include/linux/blkdev.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index d1448aaad980..1b97b9b503f4 100644
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
index df404c1fb087..28a193225cf2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -903,6 +903,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
 extern int blk_rq_unmap_user(struct bio *);
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+			gfp_t gfp_mask);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, const struct iov_iter *,
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

