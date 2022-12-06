Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4CBC352A1
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420246;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EpUKwrKWUECRRyGyYnDYFDxmVhBEpR1SlkxbCrkFf3o=;
	b=RWtHdzdvEWgWXXcZRbFkowvsJCaexHgdfG94p+3YWIFUNKvxgcTpbpgryexNjJHAprROnQ
	wq40nOFZpQCptx8fBW1B1W7DIMSPnWYUYTPIs9PT+GMn45YW3umiNVZiQdCEVpn22jNdze
	djO4oJ20kuAn05L3R+D1gGIEUQQcSxA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-2zNiyBtQNQmV5v-0sxyw7g-1; Wed, 07 Dec 2022 08:37:24 -0500
X-MC-Unique: 2zNiyBtQNQmV5v-0sxyw7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F0E23804081;
	Wed,  7 Dec 2022 13:37:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECCE140C83C5;
	Wed,  7 Dec 2022 13:37:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D68641946A5A;
	Wed,  7 Dec 2022 13:37:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 475881946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 18:48:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 361C21415100; Tue,  6 Dec 2022 18:48:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E759140EBF5
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:48:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F0D487B2A0
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:48:25 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-G2IFyQmPNN2_O-JtbR-9Jg-1; Tue, 06 Dec 2022 13:48:23 -0500
X-MC-Unique: G2IFyQmPNN2_O-JtbR-9Jg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 2B6Gwflp002541; Tue, 6 Dec 2022 18:15:38 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yeqr5x2-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 06 Dec 2022 18:15:38 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 2B6HPwkF008231; Tue, 6 Dec 2022 18:15:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3maa4nj3vw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 06 Dec 2022 18:15:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6IB2lO039309;
 Tue, 6 Dec 2022 18:15:36 GMT
Received: from bm-iostat-test-2.osdevelopmeniad.oraclevcn.com
 (bm-iostat-test-2.allregionaliads.osdevelopmeniad.oraclevcn.com
 [100.100.255.177])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3maa4nj3vh-1; Tue, 06 Dec 2022 18:15:36 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: linux-block@vger.kernel.org
Date: Tue,  6 Dec 2022 18:15:36 +0000
Message-Id: <20221206181536.13333-1-gulam.mohamed@oracle.com>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_11,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060152
X-Proofpoint-GUID: 42DVSNeqnDdG-flWUf8_lcLseT0PATe1
X-Proofpoint-ORIG-GUID: 42DVSNeqnDdG-flWUf8_lcLseT0PATe1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
Subject: [dm-devel] [RFC] block: Change the granularity of io ticks from ms
 to ns
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
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, ira.weiny@intel.com, agk@redhat.com,
 drbd-dev@lists.linbit.com, dave.jiang@intel.com,
 christoph.boehmwalder@linbit.com, vishal.l.verma@intel.com,
 konrad.wilk@oracle.com, kent.overstreet@gmail.com, ngupta@vflare.org,
 kch@nvidia.com, senozhatsky@chromium.org, gulam.mohamed@oracle.com,
 snitzer@kernel.org, colyli@suse.de, linux-raid@vger.kernel.org,
 linux-bcache@vger.kernel.org, dan.j.williams@intel.com, axboe@kernel.dk,
 martin.petersen@oracle.com, philipp.reisner@linbit.com, junxiao.bi@oracle.com,
 minchan@kernel.org, lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use ktime to change the granularity of IO accounting in block layer from
milli-seconds to nano-seconds to get the proper latency values for the
devices whose latency is in micro-seconds. After changing the granularity
to nano-seconds the iostat command, which was showing incorrect values for
%util, is now showing correct values.

We did not work on the patch to drop the logic for
STAT_PRECISE_TIMESTAMPS yet. Will do it if this patch is ok.

The iostat command was run after starting the fio with following command
on an NVME disk. For the same fio command, the iostat %util was showing
~100% for the disks whose latencies are in the range of microseconds.
With the kernel changes (granularity to nano-seconds), the %util was
showing correct values. Following are the details of the test and their
output:

fio command
-----------
[global]
bs=128K
iodepth=1
direct=1
ioengine=libaio
group_reporting
time_based
runtime=90
thinktime=1ms
numjobs=1
name=raw-write
rw=randrw
ignore_error=EIO:EIO
[job1]
filename=/dev/nvme0n1

Correct values after kernel changes:
====================================
iostat output
-------------
iostat -d /dev/nvme0n1 -x 1

Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1              0.08    0.05   0.06   128.00   128.00   0.07   6.50

Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1              0.08    0.06   0.06   128.00   128.00   0.07   6.30

Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1              0.06    0.05   0.06   128.00   128.00   0.06   5.70

From fio
--------
Read Latency: clat (usec): min=32, max=2335, avg=79.54, stdev=29.95
Write Latency: clat (usec): min=38, max=130, avg=57.76, stdev= 3.25

Values before kernel changes
============================
iostat output
-------------

iostat -d /dev/nvme0n1 -x 1

Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1              0.08    0.06   0.06   128.00   128.00   1.07  97.70

Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1              0.08    0.06   0.06   128.00   128.00   1.08  98.80

Device            r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1              0.08    0.05   0.06   128.00   128.00   1.06  97.20

From fio
--------
Read Latency: clat (usec): min=33, max=468, avg=79.56, stdev=28.04
Write Latency: clat (usec): min=9, max=139, avg=57.10, stdev= 3.79

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
---
 block/blk-core.c                  | 26 +++++++++++++-------------
 block/blk-mq.c                    |  4 ++--
 block/blk.h                       |  2 +-
 block/genhd.c                     |  8 ++++----
 drivers/block/drbd/drbd_debugfs.c |  4 ++--
 drivers/block/drbd/drbd_int.h     |  2 +-
 drivers/block/zram/zram_drv.c     |  4 ++--
 drivers/md/bcache/request.c       | 10 +++++-----
 drivers/md/dm-core.h              |  2 +-
 drivers/md/dm.c                   |  8 ++++----
 drivers/md/md.h                   |  2 +-
 drivers/md/raid1.h                |  2 +-
 drivers/md/raid10.h               |  2 +-
 drivers/md/raid5.c                |  2 +-
 drivers/nvdimm/btt.c              |  2 +-
 drivers/nvdimm/pmem.c             |  2 +-
 include/linux/blk_types.h         |  2 +-
 include/linux/blkdev.h            | 14 +++++++-------
 include/linux/part_stat.h         |  2 +-
 19 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5487912befe8..069c29dad3e7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -912,12 +912,12 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 }
 EXPORT_SYMBOL_GPL(iocb_bio_iopoll);
 
-void update_io_ticks(struct block_device *part, unsigned long now, bool end)
+void update_io_ticks(struct block_device *part, u64 now, bool end)
 {
-	unsigned long stamp;
+	u64 stamp;
 again:
 	stamp = READ_ONCE(part->bd_stamp);
-	if (unlikely(time_after(now, stamp))) {
+	if (unlikely(time_after64(now, stamp))) {
 		if (likely(try_cmpxchg(&part->bd_stamp, &stamp, now)))
 			__part_stat_add(part, io_ticks, end ? now - stamp : 1);
 	}
@@ -927,9 +927,9 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 	}
 }
 
-unsigned long bdev_start_io_acct(struct block_device *bdev,
+u64 bdev_start_io_acct(struct block_device *bdev,
 				 unsigned int sectors, enum req_op op,
-				 unsigned long start_time)
+				 u64 start_time)
 {
 	const int sgrp = op_stat_group(op);
 
@@ -949,7 +949,7 @@ EXPORT_SYMBOL(bdev_start_io_acct);
  * @bio:	bio to start account for
  * @start_time:	start time that should be passed back to bio_end_io_acct().
  */
-void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
+void bio_start_io_acct_time(struct bio *bio, u64 start_time)
 {
 	bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
 			   bio_op(bio), start_time);
@@ -962,29 +962,29 @@ EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
  *
  * Returns the start time that should be passed back to bio_end_io_acct().
  */
-unsigned long bio_start_io_acct(struct bio *bio)
+u64 bio_start_io_acct(struct bio *bio)
 {
 	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-				  bio_op(bio), jiffies);
+				  bio_op(bio), ktime_get_ns());
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
-		      unsigned long start_time)
+		      u64 start_time)
 {
 	const int sgrp = op_stat_group(op);
-	unsigned long now = READ_ONCE(jiffies);
-	unsigned long duration = now - start_time;
+	u64 now = ktime_get_ns();
+	u64 duration = now - start_time;
 
 	part_stat_lock();
 	update_io_ticks(bdev, now, true);
-	part_stat_add(bdev, nsecs[sgrp], jiffies_to_nsecs(duration));
+	part_stat_add(bdev, nsecs[sgrp], duration);
 	part_stat_local_dec(bdev, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 }
 EXPORT_SYMBOL(bdev_end_io_acct);
 
-void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
+void bio_end_io_acct_remapped(struct bio *bio, u64 start_time,
 			      struct block_device *orig_bdev)
 {
 	bdev_end_io_acct(orig_bdev, bio_op(bio), start_time);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 228a6696d835..45bc2fc3d4e7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -948,7 +948,7 @@ static void __blk_account_io_done(struct request *req, u64 now)
 	const int sgrp = op_stat_group(req_op(req));
 
 	part_stat_lock();
-	update_io_ticks(req->part, jiffies, true);
+	update_io_ticks(req->part, ktime_get_ns(), true);
 	part_stat_inc(req->part, ios[sgrp]);
 	part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
 	part_stat_unlock();
@@ -980,7 +980,7 @@ static void __blk_account_io_start(struct request *rq)
 		rq->part = rq->q->disk->part0;
 
 	part_stat_lock();
-	update_io_ticks(rq->part, jiffies, false);
+	update_io_ticks(rq->part, ktime_get_ns(), false);
 	part_stat_unlock();
 }
 
diff --git a/block/blk.h b/block/blk.h
index a186ea20f39d..938607c9964a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -345,7 +345,7 @@ static inline bool blk_do_io_stat(struct request *rq)
 	return (rq->rq_flags & RQF_IO_STAT) && !blk_rq_is_passthrough(rq);
 }
 
-void update_io_ticks(struct block_device *part, unsigned long now, bool end);
+void update_io_ticks(struct block_device *part, u64 now, bool end);
 
 static inline void req_set_nomerge(struct request_queue *q, struct request *req)
 {
diff --git a/block/genhd.c b/block/genhd.c
index 0f9769db2de8..0fb2a3dcbe9d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -956,7 +956,7 @@ ssize_t part_stat_show(struct device *dev,
 
 	if (inflight) {
 		part_stat_lock();
-		update_io_ticks(bdev, jiffies, true);
+		update_io_ticks(bdev, ktime_get_ns(), true);
 		part_stat_unlock();
 	}
 	part_stat_read_all(bdev, &stat);
@@ -976,7 +976,7 @@ ssize_t part_stat_show(struct device *dev,
 		(unsigned long long)stat.sectors[STAT_WRITE],
 		(unsigned int)div_u64(stat.nsecs[STAT_WRITE], NSEC_PER_MSEC),
 		inflight,
-		jiffies_to_msecs(stat.io_ticks),
+		(unsigned int)div_u64(stat.io_ticks, NSEC_PER_MSEC),
 		(unsigned int)div_u64(stat.nsecs[STAT_READ] +
 				      stat.nsecs[STAT_WRITE] +
 				      stat.nsecs[STAT_DISCARD] +
@@ -1245,7 +1245,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 
 		if (inflight) {
 			part_stat_lock();
-			update_io_ticks(hd, jiffies, true);
+			update_io_ticks(hd, ktime_get_ns(), true);
 			part_stat_unlock();
 		}
 		part_stat_read_all(hd, &stat);
@@ -1268,7 +1268,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   (unsigned int)div_u64(stat.nsecs[STAT_WRITE],
 							NSEC_PER_MSEC),
 			   inflight,
-			   jiffies_to_msecs(stat.io_ticks),
+			   (unsigned int)div_u64(stat.io_ticks, NSEC_PER_MSEC),
 			   (unsigned int)div_u64(stat.nsecs[STAT_READ] +
 						 stat.nsecs[STAT_WRITE] +
 						 stat.nsecs[STAT_DISCARD] +
diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index b3b9cd5628fd..5359c04e658b 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -105,7 +105,7 @@ static void seq_print_one_request(struct seq_file *m, struct drbd_request *req,
 		(s & RQ_WRITE) ? "W" : "R");
 
 #define RQ_HDR_2 "\tstart\tin AL\tsubmit"
-	seq_printf(m, "\t%d", jiffies_to_msecs(now - req->start_jif));
+	seq_printf(m, "\t%d", jiffies_to_msecs(now - nsecs_to_jiffies(req->start_jif)));
 	seq_print_age_or_dash(m, s & RQ_IN_ACT_LOG, now - req->in_actlog_jif);
 	seq_print_age_or_dash(m, s & RQ_LOCAL_PENDING, now - req->pre_submit_jif);
 
@@ -171,7 +171,7 @@ static void seq_print_waiting_for_AL(struct seq_file *m, struct drbd_resource *r
 			/* if the oldest request does not wait for the activity log
 			 * it is not interesting for us here */
 			if (req && !(req->rq_state & RQ_IN_ACT_LOG))
-				jif = req->start_jif;
+				jif = nsecs_to_jiffies(req->start_jif);
 			else
 				req = NULL;
 			spin_unlock_irq(&device->resource->req_lock);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4d661282ff41..1d605c47c592 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -300,7 +300,7 @@ struct drbd_request {
 	struct list_head req_pending_local;
 
 	/* for generic IO accounting */
-	unsigned long start_jif;
+	u64 start_jif;
 
 	/* for DRBD internal statistics */
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 966aab902d19..5376b67b88c6 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1662,7 +1662,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	u32 index;
 	struct zram *zram;
 	struct bio_vec bv;
-	unsigned long start_time;
+	u64 start_time;
 
 	if (PageTransHuge(page))
 		return -ENOTSUPP;
@@ -1682,7 +1682,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_offset = 0;
 
 	start_time = bdev_start_io_acct(bdev->bd_disk->part0,
-			SECTORS_PER_PAGE, op, jiffies);
+			SECTORS_PER_PAGE, op, ktime_get_ns());
 	ret = zram_bvec_rw(zram, &bv, index, offset, op, NULL);
 	bdev_end_io_acct(bdev->bd_disk->part0, op, start_time);
 out:
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3427555b0cca..8798b1eb6d2d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -476,7 +476,7 @@ struct search {
 	unsigned int		cache_missed:1;
 
 	struct block_device	*orig_bdev;
-	unsigned long		start_time;
+	u64			start_time;
 
 	struct btree_op		op;
 	struct data_insert_op	iop;
@@ -714,7 +714,7 @@ static void search_free(struct closure *cl)
 
 static inline struct search *search_alloc(struct bio *bio,
 		struct bcache_device *d, struct block_device *orig_bdev,
-		unsigned long start_time)
+		u64 start_time)
 {
 	struct search *s;
 
@@ -1065,7 +1065,7 @@ static void cached_dev_nodata(struct closure *cl)
 
 struct detached_dev_io_private {
 	struct bcache_device	*d;
-	unsigned long		start_time;
+	u64			start_time;
 	bio_end_io_t		*bi_end_io;
 	void			*bi_private;
 	struct block_device	*orig_bdev;
@@ -1094,7 +1094,7 @@ static void detached_dev_end_io(struct bio *bio)
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
-		struct block_device *orig_bdev, unsigned long start_time)
+		struct block_device *orig_bdev, u64 start_time)
 {
 	struct detached_dev_io_private *ddip;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
@@ -1173,7 +1173,7 @@ void cached_dev_submit_bio(struct bio *bio)
 	struct block_device *orig_bdev = bio->bi_bdev;
 	struct bcache_device *d = orig_bdev->bd_disk->private_data;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
-	unsigned long start_time;
+	u64 start_time;
 	int rw = bio_data_dir(bio);
 
 	if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags)) ||
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 6c6bd24774f2..e620fd878b08 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -284,7 +284,7 @@ struct dm_io {
 	unsigned short magic;
 	blk_short_t flags;
 	spinlock_t lock;
-	unsigned long start_time;
+	u64 start_time;
 	void *data;
 	struct dm_io *next;
 	struct dm_stats_aux stats_aux;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 95a1ee3d314e..dacd8eaadf73 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -482,7 +482,7 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 
 u64 dm_start_time_ns_from_clone(struct bio *bio)
 {
-	return jiffies_to_nsecs(clone_to_tio(bio)->io->start_time);
+	return clone_to_tio(bio)->io->start_time;
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
@@ -494,7 +494,7 @@ static bool bio_is_flush_with_data(struct bio *bio)
 static void dm_io_acct(struct dm_io *io, bool end)
 {
 	struct dm_stats_aux *stats_aux = &io->stats_aux;
-	unsigned long start_time = io->start_time;
+	u64 start_time = io->start_time;
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 	unsigned int sectors;
@@ -527,7 +527,7 @@ static void dm_io_acct(struct dm_io *io, bool end)
 
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    sector, sectors,
-				    end, start_time, stats_aux);
+				    end, nsecs_to_jiffies(start_time), stats_aux);
 	}
 }
 
@@ -589,7 +589,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->orig_bio = bio;
 	io->md = md;
 	spin_lock_init(&io->lock);
-	io->start_time = jiffies;
+	io->start_time = ktime_get_ns();
 	io->flags = 0;
 
 	if (static_branch_unlikely(&stats_enabled))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4e2d8b87b61..f129e0ae59da 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -711,7 +711,7 @@ struct md_thread {
 
 struct md_io_acct {
 	struct bio *orig_bio;
-	unsigned long start_time;
+	u64 start_time;
 	struct bio bio_clone;
 };
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index ebb6788820e7..0fb5a1148745 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -157,7 +157,7 @@ struct r1bio {
 	sector_t		sector;
 	int			sectors;
 	unsigned long		state;
-	unsigned long		start_time;
+	u64			start_time;
 	struct mddev		*mddev;
 	/*
 	 * original bio going to /dev/mdx
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 8c072ce0bc54..4cf3eec89bf3 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -123,7 +123,7 @@ struct r10bio {
 	sector_t		sector;	/* virtual sector number */
 	int			sectors;
 	unsigned long		state;
-	unsigned long		start_time;
+	u64			start_time;
 	struct mddev		*mddev;
 	/*
 	 * original bio going to /dev/mdx
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b820b81d8c2..8f4364f4bda0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5474,7 +5474,7 @@ static void raid5_align_endio(struct bio *bi)
 	struct r5conf *conf;
 	struct md_rdev *rdev;
 	blk_status_t error = bi->bi_status;
-	unsigned long start_time = md_io_acct->start_time;
+	u64 start_time = md_io_acct->start_time;
 
 	bio_put(bi);
 
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 0297b7882e33..4d7ff7c3ad11 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1442,7 +1442,7 @@ static void btt_submit_bio(struct bio *bio)
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct btt *btt = bio->bi_bdev->bd_disk->private_data;
 	struct bvec_iter iter;
-	unsigned long start;
+	u64    start;
 	struct bio_vec bvec;
 	int err = 0;
 	bool do_acct;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 96e6e9a5f235..b5b7a709e1ab 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -202,7 +202,7 @@ static void pmem_submit_bio(struct bio *bio)
 	int ret = 0;
 	blk_status_t rc = 0;
 	bool do_acct;
-	unsigned long start;
+	u64 start;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e0b098089ef2..6ffa0ca80217 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -41,7 +41,7 @@ struct block_device {
 	sector_t		bd_start_sect;
 	sector_t		bd_nr_sectors;
 	struct disk_stats __percpu *bd_stats;
-	unsigned long		bd_stamp;
+	u64			bd_stamp;
 	bool			bd_read_only;	/* read-only policy */
 	dev_t			bd_dev;
 	atomic_t		bd_openers;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 891f8cbcd043..0ecfc1ffd4a5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1452,15 +1452,15 @@ static inline void blk_wake_io_task(struct task_struct *waiter)
 		wake_up_process(waiter);
 }
 
-unsigned long bdev_start_io_acct(struct block_device *bdev,
+u64 bdev_start_io_acct(struct block_device *bdev,
 				 unsigned int sectors, enum req_op op,
-				 unsigned long start_time);
+				 u64 start_time);
 void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
-		unsigned long start_time);
+		u64 start_time);
 
-void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
-unsigned long bio_start_io_acct(struct bio *bio);
-void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
+void bio_start_io_acct_time(struct bio *bio, u64 start_time);
+u64 bio_start_io_acct(struct bio *bio);
+void bio_end_io_acct_remapped(struct bio *bio, u64 start_time,
 		struct block_device *orig_bdev);
 
 /**
@@ -1468,7 +1468,7 @@ void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
  * @bio:	bio to end account for
  * @start_time:	start time returned by bio_start_io_acct()
  */
-static inline void bio_end_io_acct(struct bio *bio, unsigned long start_time)
+static inline void bio_end_io_acct(struct bio *bio, u64 start_time)
 {
 	return bio_end_io_acct_remapped(bio, start_time, bio->bi_bdev);
 }
diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index abeba356bc3f..85c50235693c 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -10,7 +10,7 @@ struct disk_stats {
 	unsigned long sectors[NR_STAT_GROUPS];
 	unsigned long ios[NR_STAT_GROUPS];
 	unsigned long merges[NR_STAT_GROUPS];
-	unsigned long io_ticks;
+	u64 io_ticks;
 	local_t in_flight[2];
 };
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

