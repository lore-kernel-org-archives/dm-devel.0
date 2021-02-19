Return-Path: <SRS0=bZhs=HW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92DCC433DB
	for <dm-devel@archiver.kernel.org>; Sat, 20 Feb 2021 02:09:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 38F7064EDF
	for <dm-devel@archiver.kernel.org>; Sat, 20 Feb 2021 02:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38F7064EDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-Zkgb0ZDGMGSUmJ0gmpiwAg-1; Fri, 19 Feb 2021 21:09:33 -0500
X-MC-Unique: Zkgb0ZDGMGSUmJ0gmpiwAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4895E8030C1;
	Sat, 20 Feb 2021 02:09:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5AD75D9C2;
	Sat, 20 Feb 2021 02:09:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4AB014EE4D;
	Sat, 20 Feb 2021 02:09:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11K28NCD015627 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Feb 2021 21:08:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AB7251635BA; Sat, 20 Feb 2021 02:08:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4D9B16359B
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 02:08:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BFC7800962
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 02:08:23 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-555-dVYu3Q-WO0OrDH3W2hrt0g-1; Fri, 19 Feb 2021 21:08:21 -0500
X-MC-Unique: dVYu3Q-WO0OrDH3W2hrt0g-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20210220020130epoutp02395379b4c0596cda1f9db855a550cd09~lUkM0dlMV1741417414epoutp02D
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 02:01:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20210220020130epoutp02395379b4c0596cda1f9db855a550cd09~lUkM0dlMV1741417414epoutp02D
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20210220020129epcas5p3c13f985c823c12ccb8b383e911355eeb~lUkMAbWS92049720497epcas5p3a;
	Sat, 20 Feb 2021 02:01:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9D.F7.50652.97D60306; Sat, 20 Feb 2021 11:01:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20210219124559epcas5p41da46f1c248e334953d407a154697903~lJtoHS3Mt2098420984epcas5p4K;
	Fri, 19 Feb 2021 12:45:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20210219124559epsmtrp1fef1b54166bacd3d630f5686fcb408ca~lJtoFV7DI0509805098epsmtrp1T;
	Fri, 19 Feb 2021 12:45:59 +0000 (GMT)
X-AuditID: b6c32a4a-6c9ff7000000c5dc-95-60306d79ea3e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E6.7A.13470.703BF206; Fri, 19 Feb 2021 21:45:59 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20210219124556epsmtip294ecebf376f5ad1f2f7d9beb2f4d0c4e~lJtlh9Gr51410314103epsmtip2S;
	Fri, 19 Feb 2021 12:45:56 +0000 (GMT)
From: SelvaKumar S <selvakuma.s1@samsung.com>
To: linux-nvme@lists.infradead.org
Date: Fri, 19 Feb 2021 18:15:14 +0530
Message-Id: <20210219124517.79359-2-selvakuma.s1@samsung.com>
In-Reply-To: <20210219124517.79359-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0xTVxTHc997fe/RWPdoYbur6LYmuMBCi0zlkkg3N7M894c/ojNmMUKD
	DyRQIK3AKn+scRGUTcEF2ChjEANEyyihQGXQLqQVBTrGilrCHMi0oANrxTpKVpDt8Vjmf59z
	zv2e7zknl8alPpGczs47xenyNLkKUkzYXHFvJxi0iemJfU4KtU5WkOhs2SKGHE/qROhq6wCG
	HvwepNDAqp9Eo34Xhr52egGyW6sI5PjtHWR3DBHoVu93JGpomaGQLdyAo9tVl3FkmQ8QaDow
	TqH5pSESlXb8Bd6XsT+aJil2dKqDYG+NFLJW83mS7Wz6nO2bMJJs4Kc7JHuxywzYoHULW9b/
	JXZA/Kl41wkuN7uI06nU6eKTjVXNoGB8w2eh3hrSCGzichBBQ2Y7/PauGysHYlrK9AFYV98G
	hOAZgP2lbkoIFgH8e3mAKAf0msR175iQdwBo7FoEfCspEwSwuSyHZ5JJgN4mK8FzFKOAK+1n
	CF6AM5U4vDBej/MFGbMbtt17TvJMMLFwZKJRxBtImFR45pFBGO8NWDsWoniOYNTQ9ti7JpUw
	kXCo1rfWH//3zRfddTjfHzI+GpadqyQF8R7YULssElgG5252UQLL4Z8VpetcDGfP12ACGwG8
	GCgW+D3osa9g/Dw4Ewfbe1VCejOsHrZggu9GeCHsW5dKYM/3Pky4z1Y4fG2nkI6BT12969Ow
	cLBigRROdQnAwNxbleBN00vbmF7axvS/cSPAzeB1rkCvzeL0OwqS8rhipV6j1RfmZSkz8rVW
	sPYR4z/uAX9MP1U6AUYDJ4A0roiSXHuoTJdKTmgMpzldfpquMJfTO8EmmlC8JulJnE6TMlma
	U1wOxxVwuv+qGB0hN2Kd/nZLjmIHMlenHynJLVIfPS4RbzycuTt2140bEcnZV0pS+hVTCp2j
	ryjUpjO+kvZB9yetLwLh1E1u1YcJhqW7bnqDZ388EXs9/ISIsXts951HucgVZcjbM1sTo26s
	PjxHLq0apsLbis9Gy0Ob2y6du6mMfHframwG1Zyjjpr1yycPbsGfPx7Vgkh5gzf6arLKMTNv
	9KSqm5JnfnmWoq6X0ZYXpeYfzIMD9tPu4yke6a+Zj1RSIvjRwt5lWH1ENVwSNu3JH0u6nS/K
	uNPhF19vwQjLz52D0Ts1rUnBtKiWgNxy7OC0CzEdmQe6A/sefiUzx+2feHVsZvvIN4cUhP6k
	Zls8rtNr/gGXAnrr9wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWy7bCSvC77Zv0Eg+vNPBar7/azWbS2f2Oy
	2PtuNqvFytVHmSwe3/nMbnH0/1s2i/NvDzNZTDp0jdFiz6YpLBZ7b2lb7Nl7ksXi8q45bBbz
	lz1lt9j2ez6zxZUpi5gt1r1+z2Lx4P11dovXP06yWbRt/MroIOyxc9Zddo/z9zayeFw+W+qx
	aVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5DzaD3QzBXBFcdmkpOZklqUW6dslcGUsmLKU
	seA6T8X3XdPYGhi3cXUxcnBICJhIHL4f08XIxSEksJtR4uGHpyxdjJxAcRmJtXc72SBsYYmV
	/56zQxR9ZJSYsucAK0iCTUBX4tqSTWANIgJKEn/XN4HZzALLmCUezVQEsYUFHCXW3v8CNohF
	QFXi7M0FrCCLeQVsJZpeVELMl5eYeek7O4jNKWAnse3NNWYQWwio5MP3aWCtvAKCEidnPoEa
	Ly/RvHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOOy3N
	HYzbV33QO8TIxMF4iFGCg1lJhHf7c70EId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmk
	J5akZqemFqQWwWSZODilGpi28FRLFwhFz/3y7j/fU/9sqXqX/SLrd/8JfrAkcQ3r3B1/9fuZ
	r9rrxzHFG75k/6q69OHuydMOmou/NkloOtgQOtOr9pxrzWzNu5MUl6j7Tb7mIMTw0u7xydtm
	yUVbPmh+ipVuq3dWOdVuXRTY91tFv++L4cKAtzHP+U7/DfVVqjp7kqMtZ+OWZymdWrUZW5oV
	Pj+NW/P7wqebKRovkz6EtBdfvs8y/9kTxwMaT0J+7F++5QND0X2BM4wRGauNPeIm1ap0Ljwv
	Ebj0pNIbxT0OXAw+0Z/rcg4dqlp9fpHiBN9fJ/4/76s4tF+CvUunlnnr9jcvOXpC7Pc0L35+
	8ZKZn6ql5z+mxksa2ZXMspVKLMUZiYZazEXFiQB9lYxxKgMAAA==
X-CMS-MailID: 20210219124559epcas5p41da46f1c248e334953d407a154697903
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210219124559epcas5p41da46f1c248e334953d407a154697903
References: <20210219124517.79359-1-selvakuma.s1@samsung.com>
	<CGME20210219124559epcas5p41da46f1c248e334953d407a154697903@epcas5p4.samsung.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11K28NCD015627
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, damien.lemoal@wdc.com, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, nj.shetty@samsung.com,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, joshi.k@samsung.com,
	javier.gonz@samsung.com, kbusch@kernel.org, joshiiitr@gmail.com, hch@lst.de
Subject: [dm-devel] [RFC PATCH v5 1/4] block: make bio_map_kern() non static
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Make bio_map_kern() non static, so that copy offload emulation can use
it to add vmalloced memory to bio.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Chaitanya Kulkarni <kch@kernel.org>
---
 block/blk-map.c        | 2 +-
 include/linux/blkdev.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 21630dccac62..17381b1643b8 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -378,7 +378,7 @@ static void bio_map_kern_endio(struct bio *bio)
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_map_kern(struct request_queue *q, void *data,
+struct bio *bio_map_kern(struct request_queue *q, void *data,
 		unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94ee3089e01..699ace6b25ff 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -944,6 +944,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
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

