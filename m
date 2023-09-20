Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD74FCE79BE
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 10:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695205553;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c1RWNcMl9obzQs/78yZOz3+KHPiEnPYegiaH1TcuHGk=;
	b=RF4h4EGNWx/oZPLi3QjyyVFyjCeVrxl8P4HFUMDhy9gEPpNM4f0fJlmDdwwSAzTXL6oPzv
	lC2gwzxA4A5d5ON5rlseYxiIW1TIoLDTzZP+jmhegZhAjv3CmEe/LHqDQ03caAM4PmKyvy
	+a9SmXS9X9+CpXwoDEBUj+CVBFwUneU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-UojzPVG3MgmlCogJimFd8g-1; Wed, 20 Sep 2023 06:25:51 -0400
X-MC-Unique: UojzPVG3MgmlCogJimFd8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A9331C07563;
	Wed, 20 Sep 2023 10:25:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61CD640C6EC1;
	Wed, 20 Sep 2023 10:25:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 030EB194658F;
	Wed, 20 Sep 2023 10:25:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B16E194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 08:58:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1AB3920268CC; Wed, 20 Sep 2023 08:58:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1244720268CB
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:23 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5014299E753
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:22 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-BWgXUm2SOwGzVGpGtjJJdQ-1; Wed, 20 Sep 2023 04:58:20 -0400
X-MC-Unique: BWgXUm2SOwGzVGpGtjJJdQ-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230920085816epoutp0425ab38329022d1f16bd909588e10b951~Gj7A4TQtq1440014400epoutp04L
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230920085816epoutp0425ab38329022d1f16bd909588e10b951~Gj7A4TQtq1440014400epoutp04L
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230920085816epcas5p17b3562069a838dadb4a226894d1be337~Gj7AZHHlU3216432164epcas5p1n;
 Wed, 20 Sep 2023 08:58:16 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4RrC9f3y3Bz4x9Pt; Wed, 20 Sep
 2023 08:58:14 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
 70.D1.19094.624BA056; Wed, 20 Sep 2023 17:58:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230920081435epcas5p48932d9fc9ae0016b1edb2694d63fd885~GjU4ANEUu0845408454epcas5p4F;
 Wed, 20 Sep 2023 08:14:35 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230920081435epsmtrp2167d7cef5c04ab05508bf1abc12a80ae~GjU3-EuLP0164101641epsmtrp2h;
 Wed, 20 Sep 2023 08:14:35 +0000 (GMT)
X-AuditID: b6c32a50-39fff70000004a96-7d-650ab4260bf5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 1E.00.18916.BE9AA056; Wed, 20 Sep 2023 17:14:35 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230920081432epsmtip16afa5a70149a342ef8c197c1cbd17ffc~GjU0zuW3m0186201862epsmtip1G;
 Wed, 20 Sep 2023 08:14:32 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 20 Sep 2023 13:37:39 +0530
Message-Id: <20230920080756.11919-3-nj.shetty@samsung.com>
In-Reply-To: <20230920080756.11919-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxjOuff2tiXrdimQndUJTXUk4AqtAjso4NyY3gRYGtAlyhxr4AYY
 /Vo/ZE4TytcMOL4EXCgqENgGLQGGyAABocgQCBLFipAw5wQ0EiGIE4Hh1lLY/Pc873mf5/04
 eTk4P4ct4CSr9IxWJVeISBeitc/HR+zd4sJIlm3bUOPQbzha/GuNQBmF6ziyTBWQaK7vGUDT
 PWcA6povZ6GJnnYM1Vn6MXTOehegGZsJQ12Tu1DVdzUE6uwaJNBYxwUSVfw0w0Znx9tI9PPA
 KwzdK5wBqG06HaDWtQocNcwtEOjG5DY0uj7A+hDS7aYpNj36+y8EPTZioJvNOSR9uSaNvjph
 JOnq/GIWnZc5T9KLM5MEvdBtI+n8FjOgl5o96ebpp5iMdywlJImRJzBaIaOKVyckqxJDRREx
 cR/HBQZJpGJpMPpAJFTJlUyoKDxSJj6YrLDPLxKekCsM9pBMrtOJ/MNCtGqDnhEmqXX6UBGj
 SVBoAjR+OrlSZ1Al+qkY/V6pRLI70J74ZUpSX04hS2MM+aam+AxhBLckuYDLgVQAfHGvgMgF
 Lhw+1QlgfdMrtpM8A7B8fYTtyNog5t7YLUX96txmUjuABY8rSSfJxuBqnc3uxeGQ1C44/A/H
 EXenjDhsuloNHASn/sbguUdWlsPKjfocZqQvYQ5MUO/B7tvnWQ4xj9oLh7MTHRBS/rDgvqsj
 g0vtg0s14xsN8ShXOFg2TTgwTnnBzCvluMMeUj9w4YOKX3GnNhyaroudTbvBJwMtbCcWwKX5
 LtKJU2FdSS3p1GYBaBo3AefDfpg9VLDhg1M+sLHD3xneDkuHGjBn3Tdh3to05ozzYNulLbwD
 1jdWbvq/A+8up29iGlp6+oFzV/kAll3oZBUCoem1eUyvzWP6v3QlwM1AwGh0ykQmPlAjFauY
 1P9+OV6tbAYbN+ErawOWpnU/K8A4wAogBxe585TeLgyflyA/+S2jVcdpDQpGZwWB9n0X4QKP
 eLX9qFT6OGlAsCQgKCgoIHhPkFT0Nm8u+2ICn0qU65kUhtEw2i0dxuEKjNjFhdDzfg9tvYWV
 BnhkJPyR72cvyN5o+ZGhaw8/yjzsOt4JDsV6Hj/h8dXLcG9ulGA04lDuzrlZ/aph5/p24mlD
 pJDPvS47/fxO/Xy/ZfHowdIDX5stoOt2zlCH263xCbbgjfQdxeTo1EssLyMtSul+P5KqTZUY
 Yk5N9D+I9iq9YhjzM4ftqXr3mmL4+aSHuChaiVxv3nyc23dpgIn9E/f8foXfmqY8dfQLsyTf
 JplEd2qDS4dDS6K0QGZ+ktVdzRafrRosWymKyTWenPWW/DGmWK6KCD+8mvLJaUXNsdlPV+IH
 mAOXf1zIeL9olF48/pZYOJLmldVovbF/n09uSdjuGBGhS5JLfXGtTv4vatcJMpwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSnO7rlVypBp9+6VisP3WM2eLj198s
 Fk0T/jJbrL7bz2bx+vAnRosnB9oZLfa+m81qcfPATiaLlauPMllMOnSN0eLp1VlMFntvaVss
 bFvCYrFn70kWi8u75rBZzF/2lN2i+/oONovlx/8xWdyY8JTRYseTRkaLbb/nM1use/2exeLE
 LWmL83+PszpIeOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHov7JrN69Da/Y/P4+PQW
 i8f7fVfZPPq2rGL0+LxJzmPTk7dMAbxRXDYpqTmZZalF+nYJXBmHOyewFjTYVCyZ3M7SwHjR
 oIuRk0NCwERiza/X7F2MXBxCAtsZJW5O/8YKkZCUWPb3CDOELSyx8t9zdhBbSKCZSeLeT/Mu
 Rg4ONgFtidP/OUB6RQS6mCU6d75jAXGYQZxJ//+CNQgLREncf97BAmKzCKhK7Ls0jRWkmVfA
 SuJ0azqIKSGgL9F/XxCkglPAWuLzkutQq4AqLswHs3kFBCVOznwCNoVZQF6ieets5gmMArOQ
 pGYhSS1gZFrFKJpaUJybnptcYKhXnJhbXJqXrpecn7uJERy9WkE7GJet/6t3iJGJg/EQowQH
 s5IIb64aV6oQb0piZVVqUX58UWlOavEhRmkOFiVxXuWczhQhgfTEktTs1NSC1CKYLBMHp1QD
 k1tUwMPKoj2Tz7FqNJ6ZPYfb6+EBmZuGilXft2k2WHmXyTvtXbbnmPT2uZE5J1f9W5m42urx
 x5eP+Pfa7Uwx6L2YnePLE75Y71f+vza5RScnKX1eG13y/7vc4ha1Ko8A1Tl5Ce5FedzWm3Vm
 tnPZzC5P0rWfrnno0Q4V3d0Ozl5z9HQsvjx/5xH9RXxLXwW7SS6jXJPIYZYHRYnC+QeyJxSt
 3Pu1jjlh9uFjBWp3WneXWu21U/Zw8fqrUqxSpekp9u/cf9bVoXJlp1NE9+wRlDqwXVpedKLl
 feb57k1zpi0RithswyW28GCQarPxiyjB4NBHM26ltfh/KCgLm3zKr2VCEq9VgvN/c0H1Ge+U
 WIozEg21mIuKEwGguSQkTQMAAA==
X-CMS-MailID: 20230920081435epcas5p48932d9fc9ae0016b1edb2694d63fd885
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081435epcas5p48932d9fc9ae0016b1edb2694d63fd885
References: <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081435epcas5p48932d9fc9ae0016b1edb2694d63fd885@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v16 02/12] Add infrastructure for copy offload in
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
Cc: Anuj Gupta <anuj20.g@samsung.com>, anuj1072538@gmail.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-doc@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Merging non copy offload bio is avoided by checking for copy specific
opcodes in merge function.

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
index 9d51e9894ece..33aadafdb7f9 100644
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
@@ -792,6 +794,11 @@ void submit_bio_noacct(struct bio *bio)
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
index 08a358bc0919..b0c17ad635a5 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -159,6 +159,20 @@ static inline bool blk_discard_mergable(struct request *req)
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
@@ -300,6 +314,8 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
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
index 41d417ee1349..ed746738755a 100644
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
index d5c5e59ddbd2..78624e8f4ab4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -393,6 +393,10 @@ enum req_op {
 	/* reset all the zone present on the device */
 	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
 
+	/* copy offload dst and src operation */
+	REQ_OP_COPY_SRC		= (__force blk_opf_t)19,
+	REQ_OP_COPY_DST		= (__force blk_opf_t)21,
+
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,
 	REQ_OP_DRV_OUT		= (__force blk_opf_t)35,
@@ -481,6 +485,12 @@ static inline bool op_is_write(blk_opf_t op)
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

