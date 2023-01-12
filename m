Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D1DC678D5
	for <dm-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673535510;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0Q1+AHEhVDcTQlRAphzX9sWtQT9m6svnnW3cLuODAjU=;
	b=IsrCFwplWf5y1Er6up0CxukWEseURmsEzN3dNYw6yA/J4wHLeXwdbUGxpWcSrgBSpmPSBs
	/mWsD4e02h0d9RFQcR49QG2jj/sNvfTT8+S4WniFhJNpulAclA9TSc+OXOuB1py6BZWjsg
	Cq77pDlT7smPrLypledtpBLltuR4v1A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-ifn1WLTJP86PK06ScruiaQ-1; Thu, 12 Jan 2023 09:58:28 -0500
X-MC-Unique: ifn1WLTJP86PK06ScruiaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F16B4802D1A;
	Thu, 12 Jan 2023 14:58:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC7434078903;
	Thu, 12 Jan 2023 14:58:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D0E691947049;
	Thu, 12 Jan 2023 14:58:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E8941946A78
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 Jan 2023 13:37:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 655F1492B01; Thu, 12 Jan 2023 13:37:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E144492B00
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F78A1C09047
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:47 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-O-NuQjI8OSqaLOw53dIIQA-1; Thu, 12 Jan 2023 08:37:42 -0500
X-MC-Unique: O-NuQjI8OSqaLOw53dIIQA-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230112133740epoutp041be8ab5ff1db481d0df7c25c11ea0e4e~5k0TDkxSZ0247902479epoutp04E
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230112133740epoutp041be8ab5ff1db481d0df7c25c11ea0e4e~5k0TDkxSZ0247902479epoutp04E
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230112133739epcas5p206af3cc1f5dec226c2cbae46ae12620e~5k0SefRfj0471004710epcas5p2i;
 Thu, 12 Jan 2023 13:37:39 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4Nt5Fs5pj2z4x9Pq; Thu, 12 Jan
 2023 13:37:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 36.E4.02301.12D00C36; Thu, 12 Jan 2023 22:37:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230112120229epcas5p38a07a42302d823422960eb11de5d685b~5jhMvmI8a1350713507epcas5p3t;
 Thu, 12 Jan 2023 12:02:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230112120229epsmtrp219acd6ff30d1e478e4572c00456c771e~5jhMuw5Oq3008330083epsmtrp2_;
 Thu, 12 Jan 2023 12:02:29 +0000 (GMT)
X-AuditID: b6c32a49-473fd700000108fd-43-63c00d213f98
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 A7.C5.02211.5D6FFB36; Thu, 12 Jan 2023 21:02:29 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230112120226epsmtip266a12aa2937ea1ba7ca4953b1e3b4fa2~5jhKEUpPU0963109631epsmtip2M;
 Thu, 12 Jan 2023 12:02:26 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Date: Thu, 12 Jan 2023 17:29:03 +0530
Message-Id: <20230112115908.23662-10-nj.shetty@samsung.com>
In-Reply-To: <20230112115908.23662-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbVRzHc+4tlwuh5g5QD8hYd5kxQHh0K/WgPFzc5p0Yg5uJijN4Uy7P
 0tY+RDQGGCObwCgwJqGQAjoXBtuACoRXHdTgWAeyhDcbK0xIEMd7Ax1ObCno/vuez/l+z/n9
 zoPEXRcJTzJJpuaUMlZKE868lp99fQP287skwZeG/VG9+RccnS58iqO6SS2BjIvlDmi8qw1D
 V+p6MNRRvYKhnq0FAhWbRgCaHdZhyDjhjzqNt3hosL2CQJWXZx1R60wWQC2blTha++GMI7r+
 xxIP9U68hAae3nR4w53RWfoJpk036cgM3G/kMYP9GsZQ+w3B/Hgpg+kYzySY89mLBLP00zDB
 FDTVAmbN4M0YZhawaJeYlLBEjo3jlAJOJpHHJckSwumok7FvxoaIg4UBwlD0Ki2QsalcOH3k
 neiAY0lSa5u04HNWqrGiaFalooMiwpRyjZoTJMpV6nCaU8RJFSJFoIpNVWlkCYEyTv2aMDj4
 YIjV+GlK4oPSSIVW8EXWcBOWCZo9c4ETCSkRzK/Id8gFzqQr1QHgXfNDwj5YBTCv4KKjzeVK
 rQNYnyfdTfT9Po3bTUYATRf0mH2QjUFLTxbIBSRJUP7w9hZpC7hT9zDYdtvH5sGpcgz2Lkw7
 2CbcqNfhSm0JbvPzqJfh8pDIhvlWfG+jcBtDKghqLXts2MmKr4494tkte+CtspltjVP7YHZz
 +XY9kNoiYWnRn8Be6BHYPfiro127wfmbTTvaE64tGgm7ToNXSmoIe/gMgLpR3U44EuaYtdtF
 4JQvrG8PsuO98KL5Ombf+Dl4fnMGs3M+bNXvah94tb5qZ30POLKRtaMZ2Jxj2jmrAgD7Govx
 QiDQPdOQ7pmGdP9vXQXwWuDBKVSpCZwqRCGUcWn/3bFEnmoA2w/f73grmJxaDjQBjAQmAEmc
 dud39tyQuPLj2PQvOaU8VqmRcioTCLGedxHu+bxEbv05MnWsUBQaLBKLxaLQQ2Ih/SKfa66U
 uFIJrJpL4TgFp9zNYaSTZyZ2+ISPU0NxUMfExr7kqPS2d/vP9unnvPMP5H5oiDk4F/9VUP7H
 5s/WD3nVTN09ER/xfcMHQzUb1zTSZu/W44ed9Y80tZUe42elob8ZrmVEhbj5BY4UTLxdHOFg
 UXJLf82Jk13MOXUyL+n8WFnJnZG0o4kNYZalU7zqbwdWohrPVffNeL8/9512Svk3+8r8Ucle
 nvLG+uon5odFl++IQEuVU5+ih9Dv73qv0r9ic3Y0vltS/Hg05QXG5Yn/cnvnWoxwone1/f5H
 3ckB8sKTB9K8pocynS1p/R7aDN4pTS5/rKjfg27Xnk5vGBoulUSiwa/PSR8/iDMa/tFTF8re
 2nyiq4/Mo3mqRFbohytV7L8w+CsmgQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvO7Vb/uTDa7MkLRYf+oYs0XThL/M
 Fqvv9rNZ7H03m9Xi5oGdTBYrVx9lsti98COTxdH/b9ksJh26xmjx9OosJou9t7Qt9uw9yWJx
 edccNov5y56yW+x40shose33fGaLz0tb2C3WvX7PYnHilrTF+b/HWR1EPGbdP8vmsXPWXXaP
 8/c2snhcPlvqsWlVJ5vH5iX1HrtvNrB59Da/Y/N4v+8qm0ffllWMHp83yXlsevKWKYAnissm
 JTUnsyy1SN8ugSvj0XT7gn6FisarW5gaGLdKdTFyckgImEicefmQuYuRi0NIYDejxPN715kg
 EpISy/4eYYawhSVW/nvODlHUyCQx92k7YxcjBwebgLbE6f8cIHERgWdMEmfvPQKbxCywlEli
 wb5GVpBuYQFriY+rpjCDNLAIqEp8uGICEuYFCt/5PgEsLCGgL9F/XxAkzAkUXnPjCwuILSRg
 JTFrz1UmiHJBiZMzn4DFmQXkJZq3zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFhnmp5XrF
 ibnFpXnpesn5uZsYwTGppbmDcfuqD3qHGJk4GA8xSnAwK4nw7jm6P1mINyWxsiq1KD++qDQn
 tfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpqTXS/ZdDtjwomRrgceVivAQM++J
 P3hF9F6UX6rJFTCq6pC+8VaWuzS4w7R06g9GK8MnYiX/GFZPdpyb4hNZFjkzPIxny80Hskd7
 Dr2fb8c5jTUsdkqWy7qz1vdDebboMV93v7qmIjCgbFrveZ8Tf6tinxYvUdtQ2NJ03v/8yVr2
 w0ePXda+s5F/15aGLh+35rebZBSbtHX7RAXaKr03Lw82WeAyM27Fj22rC2LqHXRUfwsLTbvi
 5pU54671m5XHVMRf1hie5JmyMupRQPfG953nvq7/OPfK0hkf78+Z+G/DzIfr9ieJxd26M8l8
 IZvmComQ3DgVrz+b1u/48WTtEqeyd4Ihf/7c4JrLk5r+jFWJpTgj0VCLuag4EQA/0NL8OAMA
 AA==
X-CMS-MailID: 20230112120229epcas5p38a07a42302d823422960eb11de5d685b
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230112120229epcas5p38a07a42302d823422960eb11de5d685b
References: <20230112115908.23662-1-nj.shetty@samsung.com>
 <CGME20230112120229epcas5p38a07a42302d823422960eb11de5d685b@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 12 Jan 2023 14:58:20 +0000
Subject: [dm-devel] [PATCH v6 9/9] dm kcopyd: use copy offload support
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
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Nitesh Shetty <nj.shetty@samsung.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/md/dm-kcopyd.c | 56 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 4d3bbbea2e9a..2f9985f671ac 100644
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
+		r = blkdev_issue_copy(job->source.bdev, job->dests[i].bdev,
+				&range, 1, NULL, NULL, GFP_KERNEL);
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
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

