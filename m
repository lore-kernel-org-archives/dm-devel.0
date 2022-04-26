Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15756C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:19:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-_0y9lJOaPUm1IlFnI2h_lA-1; Wed, 27 Apr 2022 08:19:24 -0400
X-MC-Unique: _0y9lJOaPUm1IlFnI2h_lA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB38D83397F;
	Wed, 27 Apr 2022 12:19:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C021B2166B5D;
	Wed, 27 Apr 2022 12:19:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 35E85194704B;
	Wed, 27 Apr 2022 12:19:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E4751947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 12:24:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 619A3401E97; Tue, 26 Apr 2022 12:24:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D1F1463E17
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 12:24:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 363378001EA
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 12:24:40 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-Eq6dRfCtOTOskqwnaWfZpA-1; Tue, 26 Apr 2022 08:24:28 -0400
X-MC-Unique: Eq6dRfCtOTOskqwnaWfZpA-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20220426121509epoutp03683a4ab48b63f19af30f75532c893003~pcUwFM7631718017180epoutp03b;
 Tue, 26 Apr 2022 12:15:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20220426121509epoutp03683a4ab48b63f19af30f75532c893003~pcUwFM7631718017180epoutp03b
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20220426121509epcas5p10681d041cb3a2dab2d7e9fac1d620772~pcUvv6drF2178321783epcas5p1r;
 Tue, 26 Apr 2022 12:15:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4Kngn54tQ5z4x9Ps; Tue, 26 Apr
 2022 12:15:05 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 A1.23.10063.942E7626; Tue, 26 Apr 2022 21:15:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20220426101951epcas5p1f53a2120010607354dc29bf8331f6af8~pawFTa_Zl2413724137epcas5p1G;
 Tue, 26 Apr 2022 10:19:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220426101951epsmtrp176ced2e9b9a9f969fd96eb3b8dc05e12~pawFSMys82263822638epsmtrp1b;
 Tue, 26 Apr 2022 10:19:51 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-b7-6267e24970f3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 5F.AA.08924.747C7626; Tue, 26 Apr 2022 19:19:51 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220426101946epsmtip14d82f1c02263c9ee984eda8ecb45bbfd~pawAJsemo3271432714epsmtip1a;
 Tue, 26 Apr 2022 10:19:46 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Tue, 26 Apr 2022 15:42:32 +0530
Message-Id: <20220426101241.30100-5-nj.shetty@samsung.com>
In-Reply-To: <20220426101241.30100-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1RTZRg+3713dxun0RUhP/AQ8yLVQIUpG58oVEfqXJUKtXM6BzvglNuG
 jG3thwoeE0RQEViAPycJBOgRUhIFBtuM8BCKTtMJISYoIiUUCFpEYsQYlv893/O+z/P++M7L
 wz06uD68RJWe1apkSpp0I+ouigIXruyVbwz5+ao/qm77AUfW2084qOqukUSHHo/jaPj7BxxU
 YDzCRc/s13Hk6HNHtqFjHPTjX+kYelAziaHbTQ0Ysn5dgKFTVS0Y+uVkGUCW0hEMTdwXo/tP
 uwhU0NwB0MN2E4ZsXUHIartMIEdjEYmKTzzkov0/mUl0YdCGo5Ot/2DommmCRPmt5zjI3JcO
 UN2zYhxd7G4n0JnBYQJd6pqLMnPGuejB/r0AXX/eynkngHHcWs2Yeuwkk58xxGUaTHe5zPXu
 swTjsBuYmsp9JHOufCdT2HkSMJbbaSSz62oLzhwZfUoyuRlDJNOQ2cNhRh52EczwhXYyZk5s
 0nIFK0tgtUJWtUmdkKiSR9Cr18WviJdIQ8QLxUtRGC1UyZLZCDoqOmbh+4nKqW3Swi0ypWGK
 ipHpdHRw5HKt2qBnhQq1Th9Bs5oEpSZUs0gnS9YZVPJFKlYfLg4JWSyZStyQpGjKcABN2eJt
 eeM5RBqwv5UN+DxIhcLDtyqwbODG86AsAP79Ry/X9RgFcLz90EzkCYClWVXgheT3iwdIJ/ag
 GgGssPNdOBODZTf8swGPR1JB8Mokz0l7UgQ8NTZGOH1w6iAPHmitJ5yB2VQY/LO4aNqHoAKg
 dVfFNBZQ4XAibwg4fSAVDI09s5w0n1oGK1qGMFfKLHj5aN+0DU75wYzaY7jTH1JZbtCWe5hw
 9RkFe0sHSReeDQdaz3Nd2Ac+MmbN4K2wPqsEc4l3A5jd1jYjfhvesD7HnE3glAhWNwa7aF94
 sO0M5irsDnOf9WEuXgDNx19gf/hNdclMXW/YMZY+gxlYbDVzXAvNAzC9cx/3SyA0vTSQ6aWB
 TP+XLgF4JfBmNbpkOauTaMQqdut/n7xJnVwDpg8scKUZ3L33eFEzwHigGUAeTnsKDgZ8ttFD
 kCBLSWW16nitQcnqmoFkauH5uI/XJvXUhar08eLQpSGhUqk0dOkSqZieI7gi/1bmQcllejaJ
 ZTWs9oUO4/F90jCvxO/Cl0v2ONJwr09uJirv4YrNkQcqPduKrn0Vm3DeQu4oV9ypu//K7gb3
 Eyew3RXtonePn51rqxcGfT4/c9Dead2xwxAn1G1PWUvVxjbtzJ9Xzw3QfiFfmx9m9p/P1b/X
 4OcebRk4vmT01aTyvn7vkc30aRFpNEZExN4c8E3xHo1qWfXxmg+3+HHknoUbLYplY9Lq2l/t
 67ah4aCkD0p6RdvfTI2eVEQXi4R8fmRgv9caep7v86iRTz1TuzPnDxf1C0ciOxLClhh69m54
 bdVvqQuso471h/pzq1tOvx78KO5OdyHZFJfTuHXlJYmgU+ReUL/gKE+2Z5L2e2POepOkr8P8
 EU3oFDJxIK7Vyf4Ft6O9FOkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUwTdxzG/d1dr0cjy1FM+NUa7bqQzIq8ONFvQAnL/tglWxxGzSIxumPc
 QKSlaaky4xDpWKSAUIYMCwYFhQCJZlAIL0WklSG6WpOujJdgRwCNcRaZL0io6E63xP8+eT5P
 nr8ehpSXSNYyh3W5gkHHZ6tpGdXlUq/f/PlwRlps6dmNcPXWbyQ4xp9KoG2qnIbqJ0skzA/O
 SKCyvEYKy24PCd7ZD6A/UCuBuy9PETDT/pqA8es9BDgaKgloaRsi4EFzI4K+iwsEBKfjYPrZ
 BAWVzlEEcz4bAf0Tm8DRP0KBt7eOhvqmOSmU/NlNw7VH/SQ0D68QcMcWpME63CGB7tlTCLqW
 60lw3fNRcOXRPAU3J5RQVLokhZmS0wg8r4YlyZGc948vOJvfTXNWc0DK9dimpJzn3q8U53Wb
 uPbWYprruHSS+3msGXF94wU0V/j7EMnV/POM5srMAZrrKfJLuIW5CYqbv+ajUyJSZTvShezD
 RwVDTNI3sszrZi/SN27JO7NUShUg98cWFMJgdit+7KqiLUjGyNluhItamsl3QoGbXt34j8Nx
 y8oDqchy1kzgpuBWC2IYmt2Eb79mxHgNS+GWxUVK3CHZAQY7bhYToghnt+MX9XW0yBQbiR2F
 l99yKJuAg2cCSNzBbAwu94eJcQibiC8PBQgxlv9bGVvOe9cOwyPnZimRSXYDNnfWkhWItb2n
 bO+pC4hoRQpBb9RmaI1x+i064Vi0kdcaTbqM6G9ztO3o7V80mm7kaH0S7UQEg5wIM6R6TejZ
 yO/S5KHp/PfHBUPOIYMpWzA6kZKh1BGhdy0jh+RsBp8rHBEEvWD43xJMyNoCAu2632vha08c
 WK1bHiVN6/zFF/et4ruCyQ/z3UHVbD5fVT2w35ISk6ANuBaHYiPy0ajyljNs5srKCO8mWeV6
 3x3Vvpf37ZMxCfFPVccr1A1l7ZeCxaYNdQN79qu0zMLVlR9zv6KmCzMHlSdPZ50IV7TRhR/2
 tX1q3Ru365y9cXGbmU70dGzWa2TqnRFWpvq8IeqjRIW90fvQqvgpberA9JFO6su/f/hk3V/J
 ma4b0Vm1is7Y3p0enPXcQ9YnaiZTD5p/2QP687vjU5VNDb4QiWEM2UuPqmR5g7ejNA3uVZMV
 9tx4qqpm+2NrUk7O1/OfpQf9SVGr3WUpNeXpUjVlzOTjNKTByL8BBqQOep4DAAA=
X-CMS-MailID: 20220426101951epcas5p1f53a2120010607354dc29bf8331f6af8
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101951epcas5p1f53a2120010607354dc29bf8331f6af8
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101951epcas5p1f53a2120010607354dc29bf8331f6af8@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
Subject: [dm-devel] [PATCH v4 04/10] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, djwong@kernel.org,
 linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
 osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de,
 Nitesh Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For the devices which does not support copy, copy emulation is
added. Copy-emulation is implemented by reading from source ranges
into memory and writing to the corresponding destination synchronously.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
---
 block/blk-lib.c        | 128 ++++++++++++++++++++++++++++++++++++++++-
 block/blk-map.c        |   2 +-
 include/linux/blkdev.h |   2 +
 3 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index ba9da2d2f429..58c30a42ea44 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -273,6 +273,65 @@ int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
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
@@ -298,6 +357,68 @@ static inline int blk_copy_sanity_check(struct block_device *src_bdev,
 	return 0;
 }
 
+/* returns the total copy length still need to be copied */
+static inline sector_t blk_copy_max_range(struct range_entry *rlist, int nr, sector_t *max_len)
+{
+	int i;
+	sector_t len = 0;
+
+	*max_len = 0;
+	for (i = 0; i < nr; i++) {
+		*max_len = max(*max_len, rlist[i].len - rlist[i].comp_len);
+		len += (rlist[i].len - rlist[i].comp_len);
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
+	sector_t src, dst, copy_len, buf_len, read_len, copied_len,
+		 max_len = 0, remaining = 0, offset = 0;
+
+	copy_len = blk_copy_max_range(rlist, nr, &max_len);
+	buf = blk_alloc_buf(max_len, &buf_len, gfp_mask);
+	if (!buf)
+		return -ENOMEM;
+
+	for (copied_len = 0; copied_len < copy_len; copied_len += read_len) {
+		if (!remaining) {
+			offset = rlist[nr_i].comp_len;
+			src = rlist[nr_i].src + offset;
+			dst = rlist[nr_i].dst + offset;
+			remaining = rlist[nr_i++].len - offset;
+		}
+
+		read_len = min_t(sector_t, remaining, buf_len);
+		if (!read_len)
+			continue;
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
@@ -325,6 +446,7 @@ int blkdev_issue_copy(struct block_device *src_bdev, int nr,
 	struct request_queue *src_q = bdev_get_queue(src_bdev);
 	struct request_queue *dest_q = bdev_get_queue(dest_bdev);
 	int ret = -EINVAL;
+	bool offload = false;
 
 	if (!src_q || !dest_q)
 		return -ENXIO;
@@ -342,9 +464,13 @@ int blkdev_issue_copy(struct block_device *src_bdev, int nr,
 	if (ret)
 		return ret;
 
-	if (blk_check_copy_offload(src_q, dest_q))
+	offload = blk_check_copy_offload(src_q, dest_q);
+	if (offload)
 		ret = blk_copy_offload(src_bdev, nr, rlist, dest_bdev, gfp_mask);
 
+	if (ret || !offload)
+		ret = blk_copy_emulate(src_bdev, nr, rlist, dest_bdev, gfp_mask);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_issue_copy);
diff --git a/block/blk-map.c b/block/blk-map.c
index 7ffde64f9019..ca2ad2c21f42 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -340,7 +340,7 @@ static void bio_map_kern_endio(struct bio *bio)
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_map_kern(struct request_queue *q, void *data,
+struct bio *bio_map_kern(struct request_queue *q, void *data,
 		unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c6cb3fe82ba2..ea1f3c8f8dad 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1121,6 +1121,8 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+		gfp_t gfp_mask);
 int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
 		struct range_entry *src_rlist, struct block_device *dest_bdev, gfp_t gfp_mask);
 
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

