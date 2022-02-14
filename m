Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F72C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:49:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-_wakOlLkM1WCJZSf9Ckisg-1; Mon, 14 Feb 2022 03:48:24 -0500
X-MC-Unique: _wakOlLkM1WCJZSf9Ckisg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EAA31006AB0;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8373478C39;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 309131806D2B;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8aPd8009276 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:36:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 394D9C50949; Mon, 14 Feb 2022 08:36:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 350BCC50941
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18B1B1C05AE1
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:25 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-606-DgM2u08NPIS5MEc0658h5A-1; Mon, 14 Feb 2022 03:36:23 -0500
X-MC-Unique: DgM2u08NPIS5MEc0658h5A-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id
	20220214083619epoutp03fdafbcfeb68da98e253b27a5749ed248~TmiahyoXG0835308353epoutp03p;
	Mon, 14 Feb 2022 08:36:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
	20220214083619epoutp03fdafbcfeb68da98e253b27a5749ed248~TmiahyoXG0835308353epoutp03p
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20220214083619epcas5p2c99d2183476cd8fa4403752a5619e589~TmiaKIGT70375203752epcas5p2x;
	Mon, 14 Feb 2022 08:36:19 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4JxyHK2H6Gz4x9QR;
	Mon, 14 Feb 2022 08:36:13 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EA.66.05590.D741A026; Mon, 14 Feb 2022 17:36:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080703epcas5p2980d814681e2f3328490824710c8fded~TmI3USuY90791707917epcas5p2u;
	Mon, 14 Feb 2022 08:07:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220214080703epsmtrp249b45a8cd1222a254a2ef47f35286212~TmI3SuWDK2569225692epsmtrp2X;
	Mon, 14 Feb 2022 08:07:03 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-f2-620a147d56dd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	31.C4.08738.7AD0A026; Mon, 14 Feb 2022 17:07:03 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080658epsmtip21e180a2b3b2f84a24af9a6880292d0cf~TmIyx1Bi52320123201epsmtip2t;
	Mon, 14 Feb 2022 08:06:58 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:30:00 +0530
Message-Id: <20220214080002.18381-11-nj.shetty@samsung.com>
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd+/tbcvEXXnto9ONlc35CEhHwQ8VJdO4ayCRZDqdy4YFroVR
	StcW3ZxuhUaNYAEhTiyEhzAqorycphbqLA4JIMhS0cF4iNC4iONtAHmt5eLmf7/zO7/fd75z
	Tg4Pd2nlCnixcjWjlEtkQtKJuHFn7Rqf425OkX4vJ5ahiqa7OKrtGOegsu50Ev08Mo2jYUs/
	B2WmZ3ORdWA5Mg/lcFDbVBKG+qsXMFR7MRNDpWX1GHpqKAKopnAUQ6eb2zA02ydC9Qv/kCiz
	7iFAtnY9hsyd61GtuZFAVlMuifJLbFyU+shIoluDZhwZGuYx1KqfJZFxIAmgGzP5OLrT006g
	8sFhAg1ONZLoZNULgE6cmeai+3MNnBBv2voglNb3tpD0We0Ql76p7+bS93uqCFpb0EXQ1pZE
	uvryaZK+VvwTnfWnAdA1HRqSTr5Xj9PZYxMkrdMOkfSorZOgh2+1k+EeB+K2xDCSaEbpxcij
	EqJj5dJgYehnEdsjAgL9RD6iILRR6CWXxDPBwh1h4T47Y2X2IQq9DktkiXYqXKJSCTds3aJM
	SFQzXjEJKnWwkFFEyxRiha9KEq9KlEt95Yx6k8jP7+MAu/BgXIzpUieh6PL67mZbGkcD5gQp
	gM+DlBhWXtURKcCJ50LVAKgraeewwRiAz4vnMTYYBzCjaYZ8ZWmpuE2yCROAp4pal/wnMGjT
	9HFTAI9HUuth8wLPYXCjCFg6Obmowak8LrzeOMh1JFypYGgpaiUdeoL6EOpqpQ7amdoMTdeM
	OFvMGxb2WTgOzLfztwcNOKtZARsvDBAOjFPvQe31nCX9PB8WX/2IxTtgiX3BLHaFzxp+5bJY
	AMeHzIsNQCoVwKl7vRgbZAOozdAuObbBP2rnMMfncGotrDBtYOlV8FxTOcYWXg51MwMYyztD
	Y94r7A2vVBQsPeMJH04mLfYIKRo2J0N2VmkA3n3QjWUAL/1r/ehf60f/f+UCgF8GnoxCFS9l
	VAEKfzlz5L8tRyXEV4PFw1oXagRPHo/41gGMB+oA5OFCN+evW/iRLs7Rku+PMsqECGWijFHV
	gQD7vM/iAveoBPtlytURInGQnzgwMFAc5B8oEr7t3CStlLhQUomaiWMYBaN85cN4fIEGO7z/
	3PLIBo/I8N7NWStL0/xXXwrbd5SYeWpJfVca/HlAfkyNopU+dObxNfNJrejgijX8D4z9HH83
	2dTqvv4XnuXj7i+422y9mrmSVIPLrMDj+PiJJFfrXnWuR5j5Td9DG5sWOPtXLYDKJ8nuv4Ws
	vT7y6SPe7POvclfm/1gUFlnZFfMsnJfanlX6IGVsuqN52ewvGeXa8xf27gnRzPwdceVUbJvt
	i6jRN+Z3VaVXGiwdx9aHbtr6ztBb90M1O3Iv3owzFGFpgr7tu5utZ/a0ytyPje+cSC/Me5+Q
	ZgJZtGuZUfrDkcLbB0K/+d0ic/oy+ZOV3wY15fRs2IXO79ttkuv4Ti/d/hILCVWMRLQOV6ok
	/wLNPg7W4QQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yUdRzH931+362rpwP0C7RgZ7QJSuBYfoxQ22o8y3RWjqU1z0MeTwbc
	0d2BmW1iV25ASpEanhlyFhdHkwGJBxyXPIR68uvceVwSmgaEdeOQ0yaoJ3lRm/+99n6/9t7n
	jw9HKs10HJevM4kGnaZQxcipth5VwnKbQp6b9sPBFGi6eI4E55XbNDRerWLgyK05Eqa7x2io
	rqphwTv+JHQFj9Hgmd1HwFjLPAFOazUBDY29BEzaTiLorJshoLzPQ8CDG+nQOz/FQLU0jGDC
	ZyGgayQFnF1uCrwdXzNQWz/BQqXfwYAr0EWC7fxDAgYtDxhwjO9D0Ha/loSeaz4KTgWmKQjM
	uhnY3/w3gk8/m2NhKHyeXrtE8F5eJ1h+G2CEL8xBVmi3XGWFoWvNlGA+MUoJ3oESocVezgit
	3+4VvvzFhoTOK2WM8HF/LynUhO4wwgFzkBFmJkYoYdrlYzYu2iJ/OU8szC8VDS+s3ibf2fH9
	CFU8mvhBu+cgXYbCcRVIxmE+Aw80nWUirOQdCLeFNyzksbg+/DO5wFG44eEkW4HkjxwzgQPe
	flSBOI7hU3DfPBdxonkKN9y9S0Uckr/A4qFPJDZSRPFZuPvkIBPxKT4JH3BqI7GCz8QdrY7/
	9pfguhvddIRlj/KzARu5cM9LuMa3MKPgn8buo+NUhEk+AZtPHyM/R7zlscryWHUCEXYUKxYb
	i7RFxvTiFTpxV6pRU2Qs0WlTt+uLWtC/f5Kc7EBO+61UCREckhDmSFW0YuuALFepyNPs/lA0
	6NWGkkLRKKF4jlItVngq3Golr9WYxAJRLBYN/7cEJ4srI1ZefiWR6bmp/em129mhpxBSxO5J
	bGuS6y9k5lVlOSCB3VZnXRTu3LAKjt9j4sv75kKq3d/1bQ+uz6pMUy+T1LYdMUux0mL/asaM
	D52beKLZt3ksp/mdtKD7ee9bwR0N9b9bc0yLoVZ/r9y+f3POj67nxJqhP9+350S/ZzHpNN+M
	uwa1IUNo8M6KI+30JtNwUjVND0d/tPZt9eH03DdX7bn0bkHGbP/K/KP+qcqL1uWt8Wck72pK
	FnX9maYkf6l7o29076+Xetdlv+gafWPpXFX2+teVszfTkjadEktpv39L5l/DjYf+eHbXmVev
	l249PillxHiscWsa9VJhQWJ7zFSdTEUZd2rSk0mDUfMP3I9B1JYDAAA=
X-CMS-MailID: 20220214080703epcas5p2980d814681e2f3328490824710c8fded
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080703epcas5p2980d814681e2f3328490824710c8fded
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080703epcas5p2980d814681e2f3328490824710c8fded@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8aPd8009276
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
Subject: [dm-devel] [PATCH v3 10/10] dm kcopyd: use copy offload support
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

From: SelvaKumar S <selvakuma.s1@samsung.com>

Introduce copy_jobs to use copy-offload, if supported by underlying devices
otherwise fall back to existing method.

run_copy_jobs() calls block layer copy offload API, if both source and
destination request queue are same and support copy offload.
On successful completion, destination regions copied count is made zero,
failed regions are processed via existing method.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-kcopyd.c | 55 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 37b03ab7e5c9..214fadd6d71f 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -74,18 +74,20 @@ struct dm_kcopyd_client {
 	atomic_t nr_jobs;
 
 /*
- * We maintain four lists of jobs:
+ * We maintain five lists of jobs:
  *
- * i)   jobs waiting for pages
- * ii)  jobs that have pages, and are waiting for the io to be issued.
- * iii) jobs that don't need to do any IO and just run a callback
- * iv) jobs that have completed.
+ * i)	jobs waiting to try copy offload
+ * ii)   jobs waiting for pages
+ * iii)  jobs that have pages, and are waiting for the io to be issued.
+ * iv) jobs that don't need to do any IO and just run a callback
+ * v) jobs that have completed.
  *
- * All four of these are protected by job_lock.
+ * All five of these are protected by job_lock.
  */
 	spinlock_t job_lock;
 	struct list_head callback_jobs;
 	struct list_head complete_jobs;
+	struct list_head copy_jobs;
 	struct list_head io_jobs;
 	struct list_head pages_jobs;
 };
@@ -579,6 +581,42 @@ static int run_io_job(struct kcopyd_job *job)
 	return r;
 }
 
+static int run_copy_job(struct kcopyd_job *job)
+{
+	int r, i, count = 0;
+	struct range_entry range;
+
+	struct request_queue *src_q, *dest_q;
+
+	for (i = 0; i < job->num_dests; i++) {
+		range.dst = job->dests[i].sector << SECTOR_SHIFT;
+		range.src = job->source.sector << SECTOR_SHIFT;
+		range.len = job->source.count << SECTOR_SHIFT;
+
+		src_q = bdev_get_queue(job->source.bdev);
+		dest_q = bdev_get_queue(job->dests[i].bdev);
+
+		if (src_q != dest_q || !blk_queue_copy(src_q))
+			break;
+
+		r = blkdev_issue_copy(job->source.bdev, 1, &range, job->dests[i].bdev, GFP_KERNEL);
+		if (r)
+			break;
+
+		job->dests[i].count = 0;
+		count++;
+	}
+
+	if (count == job->num_dests) {
+		push(&job->kc->complete_jobs, job);
+	} else {
+		push(&job->kc->pages_jobs, job);
+		r = 0;
+	}
+
+	return r;
+}
+
 static int run_pages_job(struct kcopyd_job *job)
 {
 	int r;
@@ -659,6 +697,7 @@ static void do_work(struct work_struct *work)
 	spin_unlock_irq(&kc->job_lock);
 
 	blk_start_plug(&plug);
+	process_jobs(&kc->copy_jobs, kc, run_copy_job);
 	process_jobs(&kc->complete_jobs, kc, run_complete_job);
 	process_jobs(&kc->pages_jobs, kc, run_pages_job);
 	process_jobs(&kc->io_jobs, kc, run_io_job);
@@ -676,6 +715,8 @@ static void dispatch_job(struct kcopyd_job *job)
 	atomic_inc(&kc->nr_jobs);
 	if (unlikely(!job->source.count))
 		push(&kc->callback_jobs, job);
+	else if (job->source.bdev->bd_disk == job->dests[0].bdev->bd_disk)
+		push(&kc->copy_jobs, job);
 	else if (job->pages == &zero_page_list)
 		push(&kc->io_jobs, job);
 	else
@@ -916,6 +957,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 	spin_lock_init(&kc->job_lock);
 	INIT_LIST_HEAD(&kc->callback_jobs);
 	INIT_LIST_HEAD(&kc->complete_jobs);
+	INIT_LIST_HEAD(&kc->copy_jobs);
 	INIT_LIST_HEAD(&kc->io_jobs);
 	INIT_LIST_HEAD(&kc->pages_jobs);
 	kc->throttle = throttle;
@@ -971,6 +1013,7 @@ void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
 
 	BUG_ON(!list_empty(&kc->callback_jobs));
 	BUG_ON(!list_empty(&kc->complete_jobs));
+	WARN_ON(!list_empty(&kc->copy_jobs));
 	BUG_ON(!list_empty(&kc->io_jobs));
 	BUG_ON(!list_empty(&kc->pages_jobs));
 	destroy_workqueue(kc->kcopyd_wq);
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

