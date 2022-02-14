Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20393C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-MZwf-RnlPFG5TcRTfv7cZQ-1; Mon, 14 Feb 2022 03:48:23 -0500
X-MC-Unique: MZwf-RnlPFG5TcRTfv7cZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47E9E2F4E;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27D8F4F875;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C14044A7CD;
	Mon, 14 Feb 2022 08:48:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8a7kO009250 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:36:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 07F51112131F; Mon, 14 Feb 2022 08:36:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02C6A1121314
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDBB910665A0
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:03 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-460-S1z1NYBEMiKEkJkIZl-WUQ-1; Mon, 14 Feb 2022 03:35:59 -0500
X-MC-Unique: S1z1NYBEMiKEkJkIZl-WUQ-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20220214083556epoutp024dddc4b9d802bf82dc7061e2d9370414~TmiEs-XB41892418924epoutp02l;
	Mon, 14 Feb 2022 08:35:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20220214083556epoutp024dddc4b9d802bf82dc7061e2d9370414~TmiEs-XB41892418924epoutp02l
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20220214083555epcas5p424b251263923f65aed745ef628764e64~TmiEW4rq60059600596epcas5p4R;
	Mon, 14 Feb 2022 08:35:55 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4JxyGs4hCfz4x9Q8;
	Mon, 14 Feb 2022 08:35:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.F6.06423.1641A026; Mon, 14 Feb 2022 17:35:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20220214080627epcas5p11a8aef1b6aae05f61c7d241477bd11a3~TmIVGw70B0153001530epcas5p1J;
	Mon, 14 Feb 2022 08:06:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220214080627epsmtrp123429468577eabaf6365018f3ea1987c~TmIVFYbve0046200462epsmtrp1R;
	Mon, 14 Feb 2022 08:06:27 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-4c-620a146142fe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DE.D1.29871.28D0A026; Mon, 14 Feb 2022 17:06:26 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080622epsmtip28823f62221122673c71d380c4a49e123~TmIQp-CxL2250822508epsmtip24;
	Mon, 14 Feb 2022 08:06:22 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:29:55 +0530
Message-Id: <20220214080002.18381-6-nj.shetty@samsung.com>
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TaVBbVRjtfe/lJaFSnhTsLajQoIwUoURZLhTqQqfzoJ0OUmecOlgM8IY9
	ySSh2jpa9qFQtiAOBgtUOkCLsomIbEoAKYS1bLayylIKIwFECEKNQIL23znnfuc78313Pg5u
	3Mc244QKZYxEKIjgkQZETYvNK3YBJgYBDi2+qLzzFxw1PPiThUrH0kn0xfImjtTN0ywkT89h
	o4GZQ6hxKZeF+jQxGJqu0mKo4Ws5hu6UtmHoUXEhQPW3VjB0XdWHoe0pPmrT/kEiuXIYoNkh
	BYYaH9qihsYOAg3UfUWi/KJZNkoZqSVR02Ijjorb/8FQj2KbRLUzMQDVbOXjqGV8iEBli2oC
	JVb+BVDCjU02mk5JAqj3STvrTSt6YPAsrZjoJunMuCU2/aNijE33jlcSdFzBKEEPdEfRVXev
	k/R3t6/RWb8WA7r+QTRJx3a14XTO6hpJp8YtkfTK7EOCVjcNkT7PvR/uHsIIghiJJSMMFAWF
	CoM9eGcv+Hv6Ozk78O34rsiFZykURDIevNPnfOzOhEbs7JBneVkQEbUj+QikUt6JU+4SUZSM
	sQwRSWUePEYcFCF2FNtLBZHSKGGwvZCRufEdHF5z2in8MDwkuX+SJf6B93FMayeIBj+ZJwMu
	B1KOsKixhZ0MDDjGVD2Aaz2xLB1ZBVDbPg50ZB3AWM0quW9RTU7oLY0ApkyV6UkCBjfjf9+x
	cDgkZQtVWs6uwYQi4J2NDWK3BqcUbHhz63Ni9+Ew5QLbtDN7XQnqZfibZp61iw0pN5g9kqZP
	s4K3ppr3dC51Ev68WIzrap6FHV/O7PXBKQsY930uvhsAqUQDOLw+ytaZT8OlsixMhw/DhfZq
	vW4GH6cnsnWGFAA1XROYjuQAGJcRp49+A/Y3PMF2x8EpG1hed0InvwCzO8swXfIhmLo1ow8w
	hLV5+9gKflNeoG9zFA5vxOgxDScGlfp1pQG4pB0EGcBS8dREiqcmUvwfXQDwu+AoI5ZGBjNS
	JzFfyHz030cHiiKrwN5pHfeqBWOTy/ZKgHGAEkAOzjMxvNTNDTA2DBJcucpIRP6SqAhGqgRO
	OyvPxM1MA0U7tymU+fMdXR0cnZ2dHV1fd+bzjhiqgisExlSwQMaEM4yYkez7MA7XLBqLzH4r
	o2jN/bOMeKcFBeWZs1kSdOB5o/lP5mxG/UyzuFur3lYLBkn27fdC1YPn8l6yG8+q6L95Vf5t
	55WhA67yiu0Q60DnIsxhjmu94FdwLHPEC9X4JXTFF4+VBxLnJxMtyCn0rrq2x9u45v7tkvww
	z9no9VWPD0Jerct9+7FvT+uL92SeqX62wrmLl7JUR5Lw0vDtT1vd5GqR9tijsBRvTe5SqzV2
	odBCQ2ouelptVGb4v3OoR+leecro/hTuc9AryjA23F5krlq5Nv53NTqTWXQ5zCS3GfRyLWPn
	h33ZRoXGyhtNeeaBY5rNkyXLDKjucBmaP5/znkqdJn/m4BZmyiOkIQL+cVwiFfwLDbxU+eME
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42LZdlhJXreJlyvJYN5Ga4v1p44xW+y5+ZnV
	YvXdfjaLaR9+Mlu8P/iY1WJS/wx2i8tP+Cz2vpvNanHhRyOTxeNN/5ks9iyaxGSxcvVRJovn
	yxczWuxe+JHJovP0BSaLPw8NLY7+f8tmMenQNUaLp1dnMVnsvaVtsWfvSRaLy7vmsFnMX/aU
	3aL7+g42i32v9zJbLD/+j8ni3Kw/bBY7njQyWmz7PZ/Z4vC9qywW616/Z7Fo2/iV0aK15ye7
	xePuDkaL83+Pszooe1y+4u0x6/5ZNo+Jze/YPXbOusvucf7eRhaP5gV3WDwuny312LSqk81j
	85J6j8k3ljN67L7ZwObRdOYos8eMT1/YPHqb37F5fHx6i8Xj/b6rbAFiUVw2Kak5mWWpRfp2
	CVwZXRcfsBZsV6poPHKKsYFxv3QXIyeHhICJxOkH99m7GLk4hAR2M0os+fafGSIhKbHs7xEo
	W1hi5b/nUEXNTBLr3r9j6WLk4GAT0JY4/Z8DpEZEgEVi5ffvLCA1zAJH2CUOnVzEBJIQFjCX
	OPr/CRuIzSKgKnH7xwtWEJtXwEpi6vU+NogFyhILHx4Ei3MKWEsceL0cbLEQUM2Mq4fYIeoF
	JU7OfMICYjMLyEs0b53NPIFRYBaS1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS
	83M3MYJTipbmDsbtqz7oHWJk4mA8xCjBwawkwht3ljNJiDclsbIqtSg/vqg0J7X4EKM0B4uS
	OO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqYV06+2Cysz/524mdN13+y8HYoJutsb6s/1xyS6
	18ueWr9/7ansd75VU9yFg08mLv1yvG858961K8TyNe9bcpx08o/30w7/3tH//MHutgsOztsf
	Hd+wQzF44b5f9u+kZbbobTf6m/Ayaq3fJrfPmm+y3eesmR/RE1WifcVhTU3Es1K3UP2LXk15
	fn27/GJ0Fc1cru5x7u45snnz5SViVWGSB6LCbb9+39qyfs2cl3tY1rrybTjdw3t5RalsT/ED
	zq/NPz8mPb37bcWh68Zn1j2L2N7HauT4q11k5qJZT+WdfZ75Jp5RVnP78kv72wKjzIcVfl9D
	cmP4r1zTk1Nc4ruRfYPMT0mNr7fTtVeeNn6kxFKckWioxVxUnAgAW7qeGZgDAAA=
X-CMS-MailID: 20220214080627epcas5p11a8aef1b6aae05f61c7d241477bd11a3
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080627epcas5p11a8aef1b6aae05f61c7d241477bd11a3
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080627epcas5p11a8aef1b6aae05f61c7d241477bd11a3@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8a7kO009250
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Cc: Sagi, Nitesh, Mike Snitzer <snitzer@redhat.com>,
	Vincent Fu <vincent.fu@samsung.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
	James Smart <james.smart@broadcom.com>, hch@lst.de,
	Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
	Chaitanya Kulkarni <kch@nvidia.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [dm-devel] [PATCH v3 05/10] block: add emulation for copy
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

For the devices which does not support copy, copy emulation is
added. Copy-emulation is implemented by reading from source ranges
into memory and writing to the corresponding destination synchronously.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 block/blk-lib.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index efa7e2a5fab7..59c770814e72 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -286,6 +286,65 @@ int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
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
@@ -311,6 +370,64 @@ static inline int blk_copy_sanity_check(struct block_device *src_bdev,
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
@@ -357,6 +474,8 @@ int blkdev_issue_copy(struct block_device *src_bdev, int nr,
 
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

