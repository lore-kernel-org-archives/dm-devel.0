Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76BB22092
	for <dm-devel@lists.linux.dev>; Sat, 22 Mar 2025 01:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742606817; cv=none; b=ujwb0mlmPer1KqU0HLkyFeoGGV9THbqaW7wcD06qX4cKCwJpklrOKXYDAmrM+nMaLXM4TPsYUs/FaIBOgRwLk7+FzZbeXjQuIvMzeUf8uisIvZsGdNsOzeoZ3Ts9zgbOMxEDaVWJSBi/rjCiZVQcDnxVn1t0sVrbuISoROk76Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742606817; c=relaxed/simple;
	bh=kuqS8iSpcRU+SSvfXL1fQh6lxOKvz35yAlmqzSeQOPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DngVwAxa40IzuWDcfZDLfqCPx7DHkFCxHLlUoweZa6EAax+wBzOgTA8JCpQ6GpWEgCuZTH/NPx4D/DuNISc1pa8opfj2LAMb4s/bhtLOee54vgksaCUSslY1In4aWU3XMpv6H/V0AnBILQsTPK0sk7CtMhp7xC4Nvd+QdBgk8d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kgb2+Zy2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kgb2+Zy2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742606814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RzI3y1nF+BEHh35uiaLiJdf3GCOURyVB0kOargkdN8Y=;
	b=Kgb2+Zy2TvMrQ48nAECMzMT7kA1N54GUJSibFhEWVds0oBJf5AY82XK6Oy3HWREoWTGmv3
	L60sGfropKYZngcPQzkd0r2OR3Um49iNfgOIPHZHF7qr7BrHbmekLTKdS+2a2secMbhr6m
	nH2uSrX3Z2Qe+lWHknfHu6rn0P5f+Bw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-04gooGbsP5mZbJQc0Q-qjQ-1; Fri,
 21 Mar 2025 21:26:53 -0400
X-MC-Unique: 04gooGbsP5mZbJQc0Q-qjQ-1
X-Mimecast-MFC-AGG-ID: 04gooGbsP5mZbJQc0Q-qjQ_1742606812
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C638180025B;
	Sat, 22 Mar 2025 01:26:52 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 72C9E19373C4;
	Sat, 22 Mar 2025 01:26:49 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 4/5] loop: try to handle loop aio command via NOWAIT IO first
Date: Sat, 22 Mar 2025 09:26:13 +0800
Message-ID: <20250322012617.354222-5-ming.lei@redhat.com>
In-Reply-To: <20250322012617.354222-1-ming.lei@redhat.com>
References: <20250322012617.354222-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Try to handle loop aio command via NOWAIT IO first, then we can avoid to
queue the aio command into workqueue. This is usually one big win in
case that FS block mapping is stable, Mikulas verified [1] that this way
improves IO perf by close to 5X in 12jobs sequential read/write test,
in which FS block mapping is just stable.

Fallback to workqueue in case of -EAGAIN. This way may bring a little
cost from the 1st retry, but when running the following write test over
loop/sparse_file, the actual effect on randwrite is obvious:

```
truncate -s 4G 1.img    #1.img is created on XFS/virtio-scsi
losetup -f 1.img --direct-io=on
fio --direct=1 --bs=4k --runtime=40 --time_based --numjobs=1 --ioengine=libaio \
	--iodepth=16 --group_reporting=1 --filename=/dev/loop0 -name=job --rw=$RW
```

- RW=randwrite: obvious IOPS drop observed
- RW=write: a little drop(%5 - 10%)

This perf drop on randwrite over sparse file will be addressed in the
following patch.

BLK_MQ_F_BLOCKING has to be set for calling into .read_iter() or .write_iter()
which might sleep even though it is NOWAIT, and the only effect is that rcu read
lock is replaced with srcu read lock.

Link: https://lore.kernel.org/linux-block/a8e5c76a-231f-07d1-a394-847de930f638@redhat.com/ [1]
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 51 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c14da87efb07..3baabf150488 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -90,6 +90,8 @@ struct loop_cmd {
 #define LOOP_IDLE_WORKER_TIMEOUT (60 * HZ)
 #define LOOP_DEFAULT_HW_Q_DEPTH 128
 
+static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd);
+
 static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_ctl_mutex);
 static DEFINE_MUTEX(loop_validate_mutex);
@@ -385,6 +387,15 @@ static void lo_rw_aio_do_completion(struct loop_cmd *cmd)
 
 	if (!atomic_dec_and_test(&cmd->ref))
 		return;
+
+	/* -EAGAIN could be returned from bdev's ->ki_complete */
+	if (cmd->ret == -EAGAIN) {
+		struct loop_device *lo = rq->q->queuedata;
+
+		loop_queue_work(lo, cmd);
+		return;
+	}
+
 	kfree(cmd->bvec);
 	if (likely(!blk_should_fake_timeout(rq->q)))
 		blk_mq_complete_request(rq);
@@ -490,15 +501,38 @@ static int lo_submit_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd)
 {
 	unsigned int nr_bvec = lo_cmd_nr_bvec(cmd);
-	int ret = lo_rw_aio_prep(lo, cmd, nr_bvec);
+	int ret;
 
-	if (ret >= 0)
-		ret = lo_submit_rw_aio(lo, cmd, nr_bvec);
+	/*
+	 * This command is prepared, and we have tried IOCB_NOWAIT, but got
+	 * -EAGAIN, so clear it now
+	 */
+	cmd->iocb.ki_flags &= ~IOCB_NOWAIT;
+	ret = lo_submit_rw_aio(lo, cmd, nr_bvec);
 	if (ret != -EIOCBQUEUED)
 		lo_rw_aio_complete(&cmd->iocb, ret);
 	return 0;
 }
 
+static blk_status_t lo_rw_aio_nowait(struct loop_device *lo,
+		struct loop_cmd *cmd)
+{
+	unsigned int nr_bvec = lo_cmd_nr_bvec(cmd);
+	int ret = lo_rw_aio_prep(lo, cmd, nr_bvec);
+
+	if (unlikely(ret < 0))
+		return BLK_STS_IOERR;
+
+	cmd->iocb.ki_flags |= IOCB_NOWAIT;
+	ret = lo_submit_rw_aio(lo, cmd, nr_bvec);
+	if (ret == -EAGAIN)
+		return BLK_STS_AGAIN;
+
+	if (ret != -EIOCBQUEUED)
+		lo_rw_aio_complete(&cmd->iocb, ret);
+	return BLK_STS_OK;
+}
+
 static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 {
 	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
@@ -1943,6 +1977,14 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	}
 
+	if (cmd->use_aio) {
+		blk_status_t res = lo_rw_aio_nowait(lo, cmd);
+
+		if (res != BLK_STS_AGAIN)
+			return res;
+		/* fallback to workqueue for handling aio */
+	}
+
 	loop_queue_work(lo, cmd);
 
 	return BLK_STS_OK;
@@ -2093,7 +2135,8 @@ static int loop_add(int i)
 	lo->tag_set.queue_depth = hw_queue_depth;
 	lo->tag_set.numa_node = NUMA_NO_NODE;
 	lo->tag_set.cmd_size = sizeof(struct loop_cmd);
-	lo->tag_set.flags = BLK_MQ_F_STACKING | BLK_MQ_F_NO_SCHED_BY_DEFAULT;
+	lo->tag_set.flags = BLK_MQ_F_STACKING | BLK_MQ_F_NO_SCHED_BY_DEFAULT |
+		BLK_MQ_F_BLOCKING;
 	lo->tag_set.driver_data = lo;
 
 	err = blk_mq_alloc_tag_set(&lo->tag_set);
-- 
2.47.0

