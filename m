Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EF6C001DB
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691752813;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nWmDxDGuM9/AstrHxKkhFHPjiSpzI5e2IWfhmckgRag=;
	b=Or9f8Qiu30SuhegsL+ymmFcAGADFOYTg2X3KCMzfwXN1B2v/LRg98hx9Zfp9N0YYd4tT8W
	kUXfHIkig+PoKQ3bxBxgxwPdMhGPJA/oTi5hB2GJjC0om0HwPYgbw3ZDJyVOOuNF6upjuS
	mLpbS1GRr96710RlVk/Tao4NO98r/Lw=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-o9jt9v_aP6WhNqC1K-FHqw-1; Fri, 11 Aug 2023 07:20:10 -0400
X-MC-Unique: o9jt9v_aP6WhNqC1K-FHqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B1BF3C0ED57;
	Fri, 11 Aug 2023 11:20:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 23A6C2026D4B;
	Fri, 11 Aug 2023 11:20:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C5259194658F;
	Fri, 11 Aug 2023 11:20:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 08B181946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 11:20:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED439401E6A; Fri, 11 Aug 2023 11:20:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5461492C13
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C43098007A4
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:05 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-Ma4YPoF7Ms-JDP92jrstyA-1; Fri, 11 Aug 2023 07:20:03 -0400
X-MC-Unique: Ma4YPoF7Ms-JDP92jrstyA-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230811112000epoutp02593953d6226c45d33b7f50b2537e9fe8~6UDVu9zqq0061900619epoutp02B
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230811112000epoutp02593953d6226c45d33b7f50b2537e9fe8~6UDVu9zqq0061900619epoutp02B
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230811111959epcas5p310abffa070f3b06fd2aa676f39c92e0f~6UDVKQ8cr0454504545epcas5p33;
 Fri, 11 Aug 2023 11:19:59 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4RMhCf1GS8z4x9Px; Fri, 11 Aug
 2023 11:19:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 AB.6F.06099.D5916D46; Fri, 11 Aug 2023 20:19:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d~6TvFJkQgU0358903589epcas5p3u;
 Fri, 11 Aug 2023 10:56:48 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230811105648epsmtrp2135127c9e7c0872014886bc89f5c5026~6TvFIW5pe2537325373epsmtrp2S;
 Fri, 11 Aug 2023 10:56:48 +0000 (GMT)
X-AuditID: b6c32a4b-d308d700000017d3-75-64d6195d20e9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 E4.01.30535.0F316D46; Fri, 11 Aug 2023 19:56:48 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230811105644epsmtip206de4c4d739f8977e77b63f6a0e97fc4~6TvBPrv_V1192511925epsmtip2d;
 Fri, 11 Aug 2023 10:56:43 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Fri, 11 Aug 2023 16:22:45 +0530
Message-Id: <20230811105300.15889-3-nj.shetty@samsung.com>
In-Reply-To: <20230811105300.15889-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHc+693Bax8wLiDphtpGw6MECrbTmADDPQ3OnYcGxhDzbo6A1F
 +lofMpZF65CpJPKewYIioJN31+pQYRWsGSiKJBhAUAszZaIE8DGGj5SNcnHzv8/ve36/8zvf
 38mPi/vMkQHcTJWe0aqkCj65jGi9GBwS+pX/oExgnMCRuacLRz8UuXDUeLuQRJMXHwHk7NwH
 0FhHLLJNV3ig4c5zGKpv/B1DJfZBgMYHTBiyjaxD1T8eJ9BvtssEut5WSaKqn8c56GT3PIZu
 FI0D1Pq8CkctkzMEujSyGvW5uj02raL7HBaCvt5roK0NB0j61PHddPuwkaRrC0o96IO50yT9
 cHyEoGfOD5B0wekGQD+2vk5bnVNY4vLPszbKGamM0QYyqnS1LFOVEcPflpQalyqWCIShwkgU
 wQ9USZVMDD/+/cTQLZmKBb/8wJ1ShWFBSpTqdPzwdzZq1QY9EyhX6/QxfEYjU2hEmjCdVKkz
 qDLCVIw+SigQrBcvJKZlyUcnBnDNkehvhwbFRmAU5ANPLqREsKJ8jMwHy7g+VDuATR0PMDZ4
 BKDDUb4U/A3gXEkFyAfcxZL5mvWsbgPwxtwFDhvkYfCQ4ynhTiKpdfDKP1y3vpIy4vCX9lrg
 DnDKjkFT9RTmbu5LpcAZl8XDzQT1Fvxz1O7hLuZRUbBmIoRtFg4LR73dGZ5UNJyx9pNu5lHe
 8PJhJ+FmnHoD5v5agbN2cj3h6F9qluNh/X4Hh2VfeL/79BIHwMfTNpLlbFhfVrdoH1J7ATQN
 mQB7EAvzegpx9xtwKhia28JZ+TX4U08LxvZ9BR587sRYnQfPHn3BQbDJfGzpfn84OLdniWlY
 Pn1maaAFAF5pb+EUgUDTS35ML/kx/d/6GMAbgD+j0SkzGJ1Ys0HFZP/3x+lqpRUsbkDItrPg
 ztiDMDvAuMAOIBfnr+TFJPXLfHgyac53jFadqjUoGJ0diBfGXYwH+KWrF1ZIpU8ViiIFIolE
 IorcIBHyX+VN5h2R+VAZUj2TxTAaRvuiDuN6BhixD3Y8lezCu54YKlPWRFTG7Xv7VOmKL3Kn
 GOHWW9GrquY5MSexu11lhzp9BMOrx85wzKnOtaqGlrimozUo4eGlTZkJJXUOr45K3q78lvat
 5lbL1eJvnpWGNRQrNCBuhzw9YLPLZSrYrjCKr5XpPqt3KNfmTFoKs5P1d9XmsVsfDaWs3tNs
 /OTwpPft2ZsrntyMz94/N/jps4GC2vjlW4KIYe/5iNlev5Cc99qakziZyd22XtGXwQl9Zab+
 fOXXzTuveZ34cIBbl/xm04wlgazPi+qttnjJdzeeiC+1Mvf8cmveldwLSps474w9Fxrmecc3
 6P7ej783R/ZemN2eJvc+cPUP1xo+oZNLhSG4Vif9F7j7ZoKKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Re0hTYRjG+845nh1Hw+MW+aldVxbM1BkVX60bRHCIEEuymIIOdzDJXdrJ
 rn+4WjcNb92b9xStrSynRt7KpmUWJSVeo2alNhvqpiRJOWtZ0H8Pv+d5Xh54KVxoJgKoJPUh
 VqdWJItJPvGgWbw4xCnqUkrHHQS69+IZjk5lT+PI/D6LRI7mcYAGms4B1P94C2oczfVCvU21
 GLptfoqhi9YugAY7jRhq7AtGxWdLCdTQ2Eagjro8EhWWDfJQeasbQz3ZgwA9+FGIowrHGIGe
 9wWi9ulWr63zmfYPlQTT8SqFsZjSSKaqNJWp79WTTEnmJS8mwzBKMq7BPoIZe9RJMpnVJsBM
 WBYxloERLHKunL9RySYnHWZ1YZvj+ftt9k5cmy872t21Vg/00nRAUZBeA903V6cDPiWk6wH8
 +WMMpAPv39wflk234LNaBG+7v/BmQwYMdnWXYJ4ySQfDlzOUh8+j03GYVjtKeAo4/RqDbe98
 PBkRLYe25gQPJuggOGSzenmwgN4Ab9olsxPCYJbN15PwpmVwzPKW9Gjh74Sz7MmfNQLaF7bd
 GPh7fDE01OTi2YA2/mcZ/7OKAGYC/qyWUyWquHDtajV7JJRTqLgUdWJogkZlAX/+KZE8BA0m
 Z6gVYBSwAkjh4nmCTVFvlUKBUnHsOKvTxOlSklnOCgIpQuwnmHRkKIV0ouIQe4Bltazun4tR
 3gF67BZToz/DyTdXDGes6JkT4tpVFTCqlaamLI1bt3P59rAYOyoH7ifqbyPXamPMa0/mbctc
 EfWhf4+wHivZ1ylXFefHuhumnKf3Gsyugu4dshxlZvXpoa39mtQ3k7sXDr20nfdB1zVSae+0
 iO9/ue4UKt17QpSzwC8nQr2SF3glacR2RRJ/dcrgGMJinvsVtbTwTup6h42fXLtZ+Yb71Hr7
 MKj0+d4/cdiRUBX+kYdyPldjFcHcXGn5m6N3ty97f0kUVVIca7LeaY//ODUzX1Qaq9I//LZS
 NjlQ74w+yPWk+TZhXyOC/CjThSZjjWbGLjsRuWhJQvWqqOisnwV1IQvFBLdfES7BdZziF+Av
 meE+AwAA
X-CMS-MailID: 20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v14 02/11] Add infrastructure for copy offload in
 block and request layer.
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 dlemoal@kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We add two new opcode REQ_OP_COPY_SRC, REQ_OP_COPY_DST.
Since copy is a composite operation involving src and dst sectors/lba,
each needs to be represented by a separate bio to make it compatible
with device mapper.
We expect caller to take a plug and send bio with source information,
followed by bio with destination information.
Once the src bio arrives we form a request and wait for destination
bio. Upon arrival of destination we merge these two bio's and send
corresponding request down to device driver.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-core.c          |  7 +++++++
 block/blk-merge.c         | 41 +++++++++++++++++++++++++++++++++++++++
 block/blk.h               | 16 +++++++++++++++
 block/elevator.h          |  1 +
 include/linux/bio.h       |  6 +-----
 include/linux/blk_types.h | 10 ++++++++++
 6 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 90de50082146..2bcd06686560 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -121,6 +121,8 @@ static const char *const blk_op_name[] = {
 	REQ_OP_NAME(ZONE_FINISH),
 	REQ_OP_NAME(ZONE_APPEND),
 	REQ_OP_NAME(WRITE_ZEROES),
+	REQ_OP_NAME(COPY_SRC),
+	REQ_OP_NAME(COPY_DST),
 	REQ_OP_NAME(DRV_IN),
 	REQ_OP_NAME(DRV_OUT),
 };
@@ -796,6 +798,11 @@ void submit_bio_noacct(struct bio *bio)
 		if (!q->limits.max_write_zeroes_sectors)
 			goto not_supported;
 		break;
+	case REQ_OP_COPY_SRC:
+	case REQ_OP_COPY_DST:
+		if (!q->limits.max_copy_sectors)
+			goto not_supported;
+		break;
 	default:
 		break;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 65e75efa9bd3..bcb55ba48107 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -158,6 +158,20 @@ static struct bio *bio_split_write_zeroes(struct bio *bio,
 	return bio_split(bio, lim->max_write_zeroes_sectors, GFP_NOIO, bs);
 }
 
+static struct bio *bio_split_copy(struct bio *bio,
+				  const struct queue_limits *lim,
+				  unsigned int *nsegs)
+{
+	*nsegs = 1;
+	if (bio_sectors(bio) <= lim->max_copy_sectors)
+		return NULL;
+	/*
+	 * We don't support splitting for a copy bio. End it with EIO if
+	 * splitting is required and return an error pointer.
+	 */
+	return ERR_PTR(-EIO);
+}
+
 /*
  * Return the maximum number of sectors from the start of a bio that may be
  * submitted as a single request to a block device. If enough sectors remain,
@@ -366,6 +380,12 @@ struct bio *__bio_split_to_limits(struct bio *bio,
 	case REQ_OP_WRITE_ZEROES:
 		split = bio_split_write_zeroes(bio, lim, nr_segs, bs);
 		break;
+	case REQ_OP_COPY_SRC:
+	case REQ_OP_COPY_DST:
+		split = bio_split_copy(bio, lim, nr_segs);
+		if (IS_ERR(split))
+			return NULL;
+		break;
 	default:
 		split = bio_split_rw(bio, lim, nr_segs, bs,
 				get_max_io_size(bio, lim) << SECTOR_SHIFT);
@@ -922,6 +942,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
+	if (blk_copy_offload_mergable(rq, bio))
+		return true;
+
 	if (req_op(rq) != bio_op(bio))
 		return false;
 
@@ -951,6 +974,8 @@ enum elv_merge blk_try_merge(struct request *rq, struct bio *bio)
 {
 	if (blk_discard_mergable(rq))
 		return ELEVATOR_DISCARD_MERGE;
+	else if (blk_copy_offload_mergable(rq, bio))
+		return ELEVATOR_COPY_OFFLOAD_MERGE;
 	else if (blk_rq_pos(rq) + blk_rq_sectors(rq) == bio->bi_iter.bi_sector)
 		return ELEVATOR_BACK_MERGE;
 	else if (blk_rq_pos(rq) - bio_sectors(bio) == bio->bi_iter.bi_sector)
@@ -1053,6 +1078,20 @@ static enum bio_merge_status bio_attempt_discard_merge(struct request_queue *q,
 	return BIO_MERGE_FAILED;
 }
 
+static enum bio_merge_status bio_attempt_copy_offload_merge(struct request *req,
+							    struct bio *bio)
+{
+	if (req->__data_len != bio->bi_iter.bi_size)
+		return BIO_MERGE_FAILED;
+
+	req->biotail->bi_next = bio;
+	req->biotail = bio;
+	req->nr_phys_segments++;
+	req->__data_len += bio->bi_iter.bi_size;
+
+	return BIO_MERGE_OK;
+}
+
 static enum bio_merge_status blk_attempt_bio_merge(struct request_queue *q,
 						   struct request *rq,
 						   struct bio *bio,
@@ -1073,6 +1112,8 @@ static enum bio_merge_status blk_attempt_bio_merge(struct request_queue *q,
 		break;
 	case ELEVATOR_DISCARD_MERGE:
 		return bio_attempt_discard_merge(q, rq, bio);
+	case ELEVATOR_COPY_OFFLOAD_MERGE:
+		return bio_attempt_copy_offload_merge(rq, bio);
 	default:
 		return BIO_MERGE_NONE;
 	}
diff --git a/block/blk.h b/block/blk.h
index 686712e13835..2b3eff2c488f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -155,6 +155,20 @@ static inline bool blk_discard_mergable(struct request *req)
 	return false;
 }
 
+/*
+ * Copy offload sends a pair of bio with REQ_OP_COPY_SRC and REQ_OP_COPY_DST
+ * operation by taking a plug.
+ * Initially SRC bio is sent which forms a request and
+ * waits for DST bio to arrive. Once DST bio arrives
+ * we merge it and send request down to driver.
+ */
+static inline bool blk_copy_offload_mergable(struct request *req,
+					     struct bio *bio)
+{
+	return (req_op(req) == REQ_OP_COPY_SRC &&
+		bio_op(bio) == REQ_OP_COPY_DST);
+}
+
 static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 {
 	if (req_op(rq) == REQ_OP_DISCARD)
@@ -297,6 +311,8 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_COPY_SRC:
+	case REQ_OP_COPY_DST:
 		return true; /* non-trivial splitting decisions */
 	default:
 		break;
diff --git a/block/elevator.h b/block/elevator.h
index 7ca3d7b6ed82..eec442bbf384 100644
--- a/block/elevator.h
+++ b/block/elevator.h
@@ -18,6 +18,7 @@ enum elv_merge {
 	ELEVATOR_FRONT_MERGE	= 1,
 	ELEVATOR_BACK_MERGE	= 2,
 	ELEVATOR_DISCARD_MERGE	= 3,
+	ELEVATOR_COPY_OFFLOAD_MERGE	= 4,
 };
 
 struct blk_mq_alloc_data;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 027ff9ab5d12..9547f31882cf 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -53,11 +53,7 @@ static inline unsigned int bio_max_segs(unsigned int nr_segs)
  */
 static inline bool bio_has_data(struct bio *bio)
 {
-	if (bio &&
-	    bio->bi_iter.bi_size &&
-	    bio_op(bio) != REQ_OP_DISCARD &&
-	    bio_op(bio) != REQ_OP_SECURE_ERASE &&
-	    bio_op(bio) != REQ_OP_WRITE_ZEROES)
+	if (bio && (bio_op(bio) == REQ_OP_READ || bio_op(bio) == REQ_OP_WRITE))
 		return true;
 
 	return false;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 0bad62cca3d0..de0ad7a0d571 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -394,6 +394,10 @@ enum req_op {
 	/* reset all the zone present on the device */
 	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
 
+	/* copy offload dst and src operation */
+	REQ_OP_COPY_SRC		= (__force blk_opf_t)19,
+	REQ_OP_COPY_DST		= (__force blk_opf_t)21,
+
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,
 	REQ_OP_DRV_OUT		= (__force blk_opf_t)35,
@@ -482,6 +486,12 @@ static inline bool op_is_write(blk_opf_t op)
 	return !!(op & (__force blk_opf_t)1);
 }
 
+static inline bool op_is_copy(blk_opf_t op)
+{
+	return ((op & REQ_OP_MASK) == REQ_OP_COPY_SRC ||
+		(op & REQ_OP_MASK) == REQ_OP_COPY_DST);
+}
+
 /*
  * Check if the bio or request is one that needs special treatment in the
  * flush state machine.
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

