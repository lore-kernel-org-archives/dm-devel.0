Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977ECC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:33:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-oPuFoQESOc6agkbnalMatg-1; Tue, 08 Feb 2022 17:33:46 -0500
X-MC-Unique: oPuFoQESOc6agkbnalMatg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB9D684B9A5;
	Tue,  8 Feb 2022 22:33:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFC3A879F7;
	Tue,  8 Feb 2022 22:33:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A864B50486;
	Tue,  8 Feb 2022 22:33:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217EUd6J012657 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 09:30:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BADB01454543; Mon,  7 Feb 2022 14:30:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B66641454538
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9714710AF7C2
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:39 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-189-taFlx00aOdiumSwAIJ7adw-1; Mon, 07 Feb 2022 09:30:37 -0500
X-MC-Unique: taFlx00aOdiumSwAIJ7adw-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id
	20220207142301epoutp0426400536f0acc497a8f136bcfde51a9e~RhwH_0ZIo1978519785epoutp04Z
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:23:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
	20220207142301epoutp0426400536f0acc497a8f136bcfde51a9e~RhwH_0ZIo1978519785epoutp04Z
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20220207142300epcas5p12234e1ca79163589c3076cd92d89717c~RhwHTuydG0954809548epcas5p1y;
	Mon,  7 Feb 2022 14:23:00 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4JspJc28mZz4x9Px;
	Mon,  7 Feb 2022 14:22:56 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C8.C5.05590.5FA21026; Mon,  7 Feb 2022 23:21:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770~RhtDWlMgg1158611586epcas5p2M;
	Mon,  7 Feb 2022 14:19:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220207141930epsmtrp21b9db411c3a7e6b4f999cb91f5d68f68~RhtDVVysP0696106961epsmtrp2U;
	Mon,  7 Feb 2022 14:19:30 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-76-62012af5077e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	98.43.08738.27A21026; Mon,  7 Feb 2022 23:19:30 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20220207141926epsmtip102d2e45931c03e67130238beb97316d9~Rhs-lY_vs0283802838epsmtip1d;
	Mon,  7 Feb 2022 14:19:26 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: mpatocka@redhat.com
Date: Mon,  7 Feb 2022 19:43:43 +0530
Message-Id: <20220207141348.4235-6-nj.shetty@samsung.com>
In-Reply-To: <20220207141348.4235-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd2+5LSTAHY/0k2kk100jhELH64MILoh6N+YkcZpFJ1jgCgxo
	m5ai6JaBnVFggLDgsGxaBMczQoAVxjOUMQKUBcZLmMwhOB1gQWCjPAYrvZ3zv9853+93fuec
	L4eH21VxnXix4kRGJhbFU4QVR9Oxf5/bXy4gwqOjhUDNY0sWqGIim0A3F1ZxNN8+ZYFys/O5
	aHDaBrXoCyxQvyEVQ1M1WxhqvpuLobKKTgw9LSkCKK23H0Mbk0LUufWcQLnaEYBaxl1Rc0s3
	B9357gkXZYw2EKh1tgVHJV2bGMq5Poyhn1UbBNKs38FRx2/DHFSxgdDVL1e5aKYt7J1d9OBQ
	CJ2j1HNppfohhx7sU9A15WkEXVv8Of3VgxJAN42lEPQVXSdO5y8uE/Sorh6jM5V6gn7xZJxD
	ayYzufR86zBBZ9WVg1CH03EHYhhRFCNzZsSRkqhYcXQAFXIi/FC4t4+H0E3oh3wpZ7EogQmg
	gt8PdTsSG29cEuWcJIpXGFOhIrmccg88IJMoEhnnGIk8MYBipFHxUi+pQC5KkCvE0QIxk+gv
	9PB429tIPBcXU9dzXKqmLpYOfANSQMkb6cCSB0kvONWfR6QDK54d2QTgr6szgA0WAUx7vsZl
	gyUA5364a5EOeCZJaXckm28EcFM1gbPBVQz+VNCHbZMI0hX2bvG2LRxIPtzo15iq4uQSB46M
	qrjbD/akLyxqHTNhDvkWXOju5Wxja9IPDui7Mba/PbBwst1iG1uS/vDvjZtmzuuw+9a0CePk
	bqj8vsDUBCTHLeEXhU1mcTD8c7rSjO3hTFcdl8VOcEnfQrCCDAANukcYG+QDqLyhJFjWQTjQ
	/I9pHJzcD6sa3dn0LpjXcx9jnW1g5vq02cAaNtyeftl1ZZXaXGYHHFlJNWMaZn3bxmHXNWTc
	9sRTzg3grHplItUrE6n+t1YDvBzsYKTyhGhG7i31FDMXXn5zpCShBpguxyWkATz+fUGgBRgP
	aAHk4ZSD9c6MLZGddZQo+RIjk4TLFPGMXAu8jSvPwZ0cIyXG0xMnhgu9/Dy8fHx8vPw8fYQU
	37onulpkR0aLEpk4hpEysv90GM/SKQU7qsuyr68endN6NH7mdqx2ZRN/YTi1Nz/nXnbcwQ8W
	bR88qqF+3Dor0SaUVrcmh5R38nuG6pK4XJtPu/gnl08f1swarvvWHgry5tD2r0lLYorVmbub
	jzTlwSESZZY9DLKNSHL/xL908dnX89SxwLV2R9c3e2eBwCpK88dy4AKa+viocH1dnXL58tyl
	gYiMD/uqYt7VD0ZHPLMpCP7IxxCmWOnx25N6IVVxsidsn9Ps5rWiRV1Rh8PY4aCL1mPUL15t
	J9pCiqnhMJWbgHveYi//Mb978egZ22vvXQleZc4OClIjz6m154/fu6XrTe5fK6w8M3NKbRDw
	lz1vx9XvdBy7j5VRHHmMSOiCy+SifwG2PN8jwgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWy7bCSnG6RFmOSwe7zohZ7bn5mtVh9t5/N
	YtqHn8wW7w8+ZrWY1D+D3eLyEz6Lve9ms1pc+NHIZPF4038miz2LJjFZrFx9lMni+fLFjBad
	py8wWfx5aGhx9P9bNotJh64xWuy9pW2xZ+9JFov5y56yW3Rf38Fmse/1XmaL5cf/MVlM7LjK
	ZHFu1h82i22/5zNbHL53lcVi9R8Li9aen+wWr/bHOch6XL7i7TGx+R27R/OCOywel8+Wemxa
	1cnmsXlJvcfkG8sZPXbfbGDzaDpzlNljxqcvbB7Xz2xn8uhtfsfm8fHpLRaPbQ972T3e77vK
	5tG3ZRVjgEgUl01Kak5mWWqRvl0CV8aWU/4FC5QqVlycw9jAuFy6i5GDQ0LARGLFyeQuRi4O
	IYEdjBI7vu5n7WLkBIpLSiz7e4QZwhaWWPnvOTuILSTQzCSx9ZI5SC+bgLbE6f8cIGERAXGJ
	Pxe2MYLMYRaYzirRcOoyE0hCWMBcYvG+m2C9LAKqEh9OnmYBsXkFLCUuvjvJBDFfWWLhw4Ng
	ezkFrCS+/ZnGAnFQA6NEw7kVrBANghInZz4Ba2YWkJdo3jqbeQKjwCwkqVlIUgsYmVYxSqYW
	FOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgSnAy2tHYx7Vn3QO8TIxMF4iFGCg1lJhFem+3+i
	EG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUx5crHi3+8+
	fhthHJAWGPz/3eUVmi128RHH63sV5x7/VeS2eEeU98HWZWwf71ye99HmhU2Or9W/4qB7R5rv
	L2Y9OnvZpfbJ7uf/H3e9uJWx9+hE7bMC6ffKz347dLFk9e21kQ3TFqU/1mF7l5V7bcvGefcW
	3PHZ16xmxxEV8KfN2M5SSXull2f2GoYCa5HX0zS9v1w0sn6S7sTO+zpLL31r+DHt4+zRtecv
	Tg+oj56terVF6uP36zNYn2fZ/w2fXce1aell/ZkfS24/yfvIHG85eea67yybGhMP/vD6q5DY
	//NLwp/TTvskXwhV7G6urbzR07dcumx57L6eVv6ycMPVPuI1dw57am/Pn1V8+26DEktxRqKh
	FnNRcSIANdWiInYDAAA=
X-CMS-MailID: 20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 217EUd6J012657
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 08 Feb 2022 02:51:51 -0500
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: [dm-devel] [PATCH v2 05/10] block: add emulation for copy
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For the devices which does not support copy, copy emulation is
added. Copy-emulation is implemented by reading from source ranges
into memory and writing to the corresponding destination synchronously.

TODO: Optimise emulation.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/blk-lib.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3ae2c27b566e..05c8cd02fffc 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -272,6 +272,65 @@ int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
 	return cio_await_completion(cio);
 }
 
+int blk_submit_rw_buf(struct block_device *bdev, void *buf, sector_t buf_len,
+				sector_t sector, unsigned int op, gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct bio *bio, *parent = NULL;
+	sector_t max_hw_len = min_t(unsigned int, queue_max_hw_sectors(q),
+			queue_max_segments(q) << (PAGE_SHIFT - SECTOR_SHIFT)) << SECTOR_SHIFT;
+	sector_t len, remaining;
+	int ret;
+
+	for (remaining = buf_len; remaining > 0; remaining -= len) {
+		len = min_t(int, max_hw_len, remaining);
+retry:
+		bio = bio_map_kern(q, buf, len, gfp_mask);
+		if (IS_ERR(bio)) {
+			len >>= 1;
+			if (len)
+				goto retry;
+			return PTR_ERR(bio);
+		}
+
+		bio->bi_iter.bi_sector = sector >> SECTOR_SHIFT;
+		bio->bi_opf = op;
+		bio_set_dev(bio, bdev);
+		bio->bi_end_io = NULL;
+		bio->bi_private = NULL;
+
+		if (parent) {
+			bio_chain(parent, bio);
+			submit_bio(parent);
+		}
+		parent = bio;
+		sector += len;
+		buf = (char *) buf + len;
+	}
+	ret = submit_bio_wait(bio);
+	bio_put(bio);
+
+	return ret;
+}
+
+static void *blk_alloc_buf(sector_t req_size, sector_t *alloc_size, gfp_t gfp_mask)
+{
+	int min_size = PAGE_SIZE;
+	void *buf;
+
+	while (req_size >= min_size) {
+		buf = kvmalloc(req_size, gfp_mask);
+		if (buf) {
+			*alloc_size = req_size;
+			return buf;
+		}
+		/* retry half the requested size */
+		req_size >>= 1;
+	}
+
+	return NULL;
+}
+
 static inline int blk_copy_sanity_check(struct block_device *src_bdev,
 		struct block_device *dst_bdev, struct range_entry *rlist, int nr)
 {
@@ -297,6 +356,64 @@ static inline int blk_copy_sanity_check(struct block_device *src_bdev,
 	return 0;
 }
 
+static inline sector_t blk_copy_max_range(struct range_entry *rlist, int nr, sector_t *max_len)
+{
+	int i;
+	sector_t len = 0;
+
+	*max_len = 0;
+	for (i = 0; i < nr; i++) {
+		*max_len = max(*max_len, rlist[i].len);
+		len += rlist[i].len;
+	}
+
+	return len;
+}
+
+/*
+ * If native copy offload feature is absent, this function tries to emulate,
+ * by copying data from source to a temporary buffer and from buffer to
+ * destination device.
+ */
+static int blk_copy_emulate(struct block_device *src_bdev, int nr,
+		struct range_entry *rlist, struct block_device *dest_bdev, gfp_t gfp_mask)
+{
+	void *buf = NULL;
+	int ret, nr_i = 0;
+	sector_t src, dst, copy_len, buf_len, read_len, copied_len, max_len = 0, remaining = 0;
+
+	copy_len = blk_copy_max_range(rlist, nr, &max_len);
+	buf = blk_alloc_buf(max_len, &buf_len, gfp_mask);
+	if (!buf)
+		return -ENOMEM;
+
+	for (copied_len = 0; copied_len < copy_len; copied_len += read_len) {
+		if (!remaining) {
+			rlist[nr_i].comp_len = 0;
+			src = rlist[nr_i].src;
+			dst = rlist[nr_i].dst;
+			remaining = rlist[nr_i++].len;
+		}
+
+		read_len = min_t(sector_t, remaining, buf_len);
+		ret = blk_submit_rw_buf(src_bdev, buf, read_len, src, REQ_OP_READ, gfp_mask);
+		if (ret)
+			goto out;
+		src += read_len;
+		remaining -= read_len;
+		ret = blk_submit_rw_buf(dest_bdev, buf, read_len, dst, REQ_OP_WRITE,
+				gfp_mask);
+		if (ret)
+			goto out;
+		else
+			rlist[nr_i - 1].comp_len += read_len;
+		dst += read_len;
+	}
+out:
+	kvfree(buf);
+	return ret;
+}
+
 static inline bool blk_check_copy_offload(struct request_queue *src_q,
 		struct request_queue *dest_q)
 {
@@ -346,6 +463,8 @@ int blkdev_issue_copy(struct block_device *src_bdev, int nr,
 
 	if (blk_check_copy_offload(src_q, dest_q))
 		ret = blk_copy_offload(src_bdev, nr, rlist, dest_bdev, gfp_mask);
+	else
+		ret = blk_copy_emulate(src_bdev, nr, rlist, dest_bdev, gfp_mask);
 
 	return ret;
 }
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

