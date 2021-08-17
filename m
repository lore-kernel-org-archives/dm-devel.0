Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F69C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 11:32:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 582C260FC3
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 11:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 582C260FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-uagI_LuuPq2f1NwLKZFd3A-1; Tue, 17 Aug 2021 07:32:40 -0400
X-MC-Unique: uagI_LuuPq2f1NwLKZFd3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CF0E1008065;
	Tue, 17 Aug 2021 11:32:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 483F75DA60;
	Tue, 17 Aug 2021 11:32:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BBA544BB7C;
	Tue, 17 Aug 2021 11:32:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HBTmik009562 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 07:29:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7DC4F2033954; Tue, 17 Aug 2021 11:29:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 794B220341A8
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:29:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C850518A01A0
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:29:44 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-429-W-yHMMetP7C0KCe7bbZrAg-1; Tue, 17 Aug 2021 07:29:42 -0400
X-MC-Unique: W-yHMMetP7C0KCe7bbZrAg-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id
	20210817112936epoutp0360927d0674a50aa46158e7a9ab8da36a~cFJCx68iP2784227842epoutp038
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:29:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
	20210817112936epoutp0360927d0674a50aa46158e7a9ab8da36a~cFJCx68iP2784227842epoutp038
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20210817112935epcas5p1c85a4d338de4388002d2ed46ef2c3f39~cFJB1cQDN0060000600epcas5p15;
	Tue, 17 Aug 2021 11:29:35 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Gpphq5p9Mz4x9Px;
	Tue, 17 Aug 2021 11:29:31 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	13.9B.09595.B9D9B116; Tue, 17 Aug 2021 20:29:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20210817101822epcas5p470644cf681d5e8db5367dc7998305c65~cEK1x04pr2768027680epcas5p47;
	Tue, 17 Aug 2021 10:18:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20210817101822epsmtrp138474bfe16a311ca3898be176791ab29~cEK1wcEAH2073620736epsmtrp1f;
	Tue, 17 Aug 2021 10:18:22 +0000 (GMT)
X-AuditID: b6c32a4a-ed5ff7000000257b-5d-611b9d9b47ff
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	1D.19.32548.EEC8B116; Tue, 17 Aug 2021 19:18:22 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20210817101818epsmtip24573d2010be5372cecb5a4286a23f483~cEKyBa81A3274532745epsmtip2H;
	Tue, 17 Aug 2021 10:18:18 +0000 (GMT)
From: SelvaKumar S <selvakuma.s1@samsung.com>
To: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
Date: Tue, 17 Aug 2021 15:44:23 +0530
Message-Id: <20210817101423.12367-8-selvakuma.s1@samsung.com>
In-Reply-To: <20210817101423.12367-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd29pC1lNVyB+VhzsJsjAAa0W9rGBksjMFR/DkcVA2OAOLs++
	0hZRMxyMN8jLIWABUac4WwVX5CEW40DX0IVtDijDiIGtzIyHIJ0DB4yVFp3//c7v/M73O+d8
	OWycV83is1OkKlohpcQE04nR3uvt7VvXsJkSrGZtQy3G73FUr2kHSDtazkTVc89xlFfwN4YG
	zBtQ95M6B3RFew9Dvz+0sNBK8SMM3VudYaKfZnoxdKrHBJBeV8VArQuFTNT9YBvSd/cxUGPT
	BAuVDHcy0WXDvxiqLBzCUKc5G6D2pUYcDVZdwNHY7DALTS32MVH+t88AWlqsZ4a6kQOD+8ib
	6lEW2fqNDznQn07qNEVMsvXiF+StkSwm+XTiAYOcvT3EJMtuaABp0b1JFtwpwSJej04LTqap
	BFrhQUvjZQkp0qQQYl9k7O7YgECB0FcYhN4lPKSUhA4hwvZH+O5JEVuXQXgcocTpViqCUioJ
	/53BClm6ivZIlilVIQQtTxDLRXI/JSVRpkuT/KS06j2hQLA9wCqMS0uuH61jyc3uR//RX8az
	QAW/GDiyIVcET/1w1aEYOLF53FsA1pXWrAfzAOY1NOP2wAJgx+kq/EVJg/4OZk90AWgYtLBe
	qh62VTisqZhcX2i6qGOsYRfuLnjlucb2Ls41MmDN7AXWWsLZmpj6tRZbwwyuJzyfu2LjOdwQ
	OHP3Z8xu5w7P/LJg5dlsR+5O2DXvaZe8AfvOmG3v41ZJTludrVXI1TrCq6Yapr02DBrPLTHs
	2BlOGm6w7JgP/yzPX8cZ8I+i6nWvLADLZjPseBe8r1/B1nxxrjds6fK301vgaWMzZvfdAEuX
	zOulHNh51myTQ+5WaOwItNNucK63a70bEpbf1KwvrhLA/uXvHCqAh/qVcdSvjKP+3/kcwDVg
	Ey1XSpJoZYB8u5TOePnL8TKJDtgOxCe8E4yPzfn1AIwNegBk44QLx4vNp3icBOrYcVohi1Wk
	i2llDwiwrrsS57vGy6wXJlXFCkVBAlFgYKAoaEegkNjIidm/meJxkygVnUbTclrxog5jO/Kz
	sIyDezmGty5df9o2b5Is0FMRi65PTkamVro9DqvtatmY+Ki90TPq7tixyEuvVfDzS6gopfNk
	U3/4llGBU8ymI7UZ13cI+9SlH33qN97T3Hot80BTYWhRaN6Yi0K7mtM8J6nOrdXTBF9R5hjf
	K5teqJiUE+Wp4zMKQ67UU9BwOLrAf4/4aFJL99vPdNPvSJarGv2/DjfK3v+wT3P4eKElZaID
	jP01WJPo7jXMM2VOp33lTjuvfpki+fx21CfL2Sd0lsaRzEPXTi4fqMx2fXy/2nhQDX6MIeJG
	ks4rcqI5H2hxQ6TWxButkB/6eCpRJVrx+2x36m8ntkaKw4K9huKqcs82EAxlMiX0wRVK6j8p
	fxJIqQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHe885nZ2tVscp9M4uxsCiVUtL6i3TiiAOlFYQCGmsoQctb2PT
	7AJpmNXULppWusW6SOq026ylc6thas2SpGle6pTpLMk0tcyszHQa9O3P//d7nufDQ+GiesKT
	2heXwKriFDESUkCYHku8lvdlzlX4ZJkodLuuFkc6gwmgEu4siS70j+Ao7eR3DDmcs5C1Tzsd
	FZfUYKjzzVceGk1/i6GasV4Sveh9jKHsqlcAWYw5BCobPkUia9tSZLHaCaS/0cVDGc3lJCp8
	8gdDWaeaMFTuPAaQ6ZceR40513DU/qWZh3p+2El04u4QQL9+6MiN8xhH41amIp/jMWVFUsZR
	n8gYDRqSKStIZipbU0hmoKuNYL48bCKZM/cMgPlqXMCctGVgO2buFqyPYGP2HWBVKwL3CqJ0
	nJandHod/GkpxFPAOc90wKcg7QcvW2xYOhBQIrocwOvt+dgkmAdvchpyMrvD4j8feZPSAIBP
	02wuiaSXw1cFRmIie9Cb4LNBk2sTTn8i4FuuEp8A7vQG2NNyyTVA0N7w6vFR3kQW0gGwt7ph
	6poXzHs5PN5TFJ8OhOZB74laNK48suRO6W7Qnud03cLH9dT7WvwcoPP/Q/n/oSsAMwAxq1TH
	RsaqfZUr49gkmVoRq06Mi5SFx8cagevjUmk5sBj6ZVUAo0AVgBQu8RAupjwVImGE4tBhVhUv
	VyXGsOoqMJciJHOEDel2uYiOVCSw0SyrZFX/KEbxPVOwgG9B3OHtIeeviqfNqo/w6WI+67Cm
	LfKwwfbQ7FG3m2eEI1CUevTIWf26/lKrPeS2d7S5o9FjJ/8IeVqckCxoq/AL7LPqzZl7CuR1
	3dJFqm65YBk/zSa+HzYQ9KYmdX5owIoM7evkhpYUaXBBy/7eqMyR4Lo9d2yJ1avMtcPf6LwP
	+ncHHQH6zbIikf+22Yb4leE+O8wznpOyav8x60W3z0ty39+FODcjZq27mxLThtInutfoFvol
	FZk7s7lnFTe6dLc0d3ZlPekplRc+iHaeLikN35n0tGZklZ7r0OQU+QYGi98Rn8I0rZWW32Ot
	694PLQhuXg2Hhhz+eTB7aa2EUEcpfKW4Sq34CwqI2DlgAwAA
X-CMS-MailID: 20210817101822epcas5p470644cf681d5e8db5367dc7998305c65
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210817101822epcas5p470644cf681d5e8db5367dc7998305c65
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101822epcas5p470644cf681d5e8db5367dc7998305c65@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17HBTmik009562
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
Subject: [dm-devel] [PATCH 7/7] dm kcopyd: add simple copy offload support
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

Introduce copy_jobs to use copy-offload, if supported by underlying devices
otherwise fall back to existing method.

run_copy_jobs() calls block layer copy offload API, if both source and
destination request queue are same and support copy offload.
On successful completion, destination regions copied count is made zero,
failed regions are processed via existing method.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-kcopyd.c | 56 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 37b03ab7e5c9..d9ee105a6127 100644
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
@@ -579,6 +581,43 @@ static int run_io_job(struct kcopyd_job *job)
 	return r;
 }
 
+static int run_copy_job(struct kcopyd_job *job)
+{
+	int r, i, count = 0;
+	unsigned long flags = 0;
+	struct range_entry srange;
+
+	struct request_queue *src_q, *dest_q;
+
+	for (i = 0; i < job->num_dests; i++) {
+		srange.src = job->source.sector;
+		srange.len = job->source.count;
+
+		src_q = bdev_get_queue(job->source.bdev);
+		dest_q = bdev_get_queue(job->dests[i].bdev);
+
+		if (src_q != dest_q && !src_q->limits.copy_offload)
+			break;
+
+		r = blkdev_issue_copy(job->source.bdev, 1, &srange,
+			job->dests[i].bdev, job->dests[i].sector, GFP_KERNEL, flags);
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
@@ -659,6 +698,7 @@ static void do_work(struct work_struct *work)
 	spin_unlock_irq(&kc->job_lock);
 
 	blk_start_plug(&plug);
+	process_jobs(&kc->copy_jobs, kc, run_copy_job);
 	process_jobs(&kc->complete_jobs, kc, run_complete_job);
 	process_jobs(&kc->pages_jobs, kc, run_pages_job);
 	process_jobs(&kc->io_jobs, kc, run_io_job);
@@ -676,6 +716,8 @@ static void dispatch_job(struct kcopyd_job *job)
 	atomic_inc(&kc->nr_jobs);
 	if (unlikely(!job->source.count))
 		push(&kc->callback_jobs, job);
+	else if (job->source.bdev->bd_disk == job->dests[0].bdev->bd_disk)
+		push(&kc->copy_jobs, job);
 	else if (job->pages == &zero_page_list)
 		push(&kc->io_jobs, job);
 	else
@@ -916,6 +958,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 	spin_lock_init(&kc->job_lock);
 	INIT_LIST_HEAD(&kc->callback_jobs);
 	INIT_LIST_HEAD(&kc->complete_jobs);
+	INIT_LIST_HEAD(&kc->copy_jobs);
 	INIT_LIST_HEAD(&kc->io_jobs);
 	INIT_LIST_HEAD(&kc->pages_jobs);
 	kc->throttle = throttle;
@@ -971,6 +1014,7 @@ void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
 
 	BUG_ON(!list_empty(&kc->callback_jobs));
 	BUG_ON(!list_empty(&kc->complete_jobs));
+	WARN_ON(!list_empty(&kc->copy_jobs));
 	BUG_ON(!list_empty(&kc->io_jobs));
 	BUG_ON(!list_empty(&kc->pages_jobs));
 	destroy_workqueue(kc->kcopyd_wq);
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

