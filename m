Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01EF175A5
	for <dm-devel@lists.linux.dev>; Sat, 22 Mar 2025 01:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742606824; cv=none; b=py2K8Ah5u7N/SRKbc4IXUa3R+I2ZPJ7tRd+i5qoRl7WInS/CoAyiBCjnbzpLIlM/8xeB1H/1mE12rHV4nXmx/+ihPxvCh38QoNulUNRJO5NoFNSGVItmolKyC2S7kmIojN9QAW2WA3PwA2I0lvXqImb1CziF7pk1UGc62aUIfOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742606824; c=relaxed/simple;
	bh=MfuJx2JFE7rySp1wL8KWaIeNvk+j4K/SO9XmQTgbmDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2wDw/K9WHKevUqPxkCvEvfcvkTFdK8YujWiPm6TQX9g08kDiH9vEpL5pqPlwjGJH2VvhK5qh00eZizuSCcp+LXS8/vLIF/NPkGUm+MTCTgA94m4H5zJh8owMzNnyofIodvQ4pVPYqwtjXfNuOW5u5rMlg+hoipNmod9K7JubHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2hH9L6l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2hH9L6l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742606821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5AkDzj9Edwtpo2uTQ1fy7/wklQm03FMr+RqJXBF5uA=;
	b=A2hH9L6lWwq/LkW3KsK/DLOH+tv4xqig+gupNtJCizxs+TXI98JSbn49vMb4BXZsOr1S32
	qA1BjYcSZmHQh7P8wz+6PJpCm/VeZK6sK+r+rQhr8o3irq1HI5PozrV89AxX1uRNopQjx+
	X6v1r3mhsmvCSMKZrQizUzxjsX9TiV0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-aI3_AqM_PwCNMa_S-NhfFw-1; Fri,
 21 Mar 2025 21:26:59 -0400
X-MC-Unique: aI3_AqM_PwCNMa_S-NhfFw-1
X-Mimecast-MFC-AGG-ID: aI3_AqM_PwCNMa_S-NhfFw_1742606818
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E786E1903081;
	Sat, 22 Mar 2025 01:26:57 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4934D180174E;
	Sat, 22 Mar 2025 01:26:55 +0000 (UTC)
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
Subject: [PATCH V3 5/5] loop: add hint for handling aio via IOCB_NOWAIT
Date: Sat, 22 Mar 2025 09:26:14 +0800
Message-ID: <20250322012617.354222-6-ming.lei@redhat.com>
In-Reply-To: <20250322012617.354222-1-ming.lei@redhat.com>
References: <20250322012617.354222-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add hint for using IOCB_NOWAIT to handle loop aio command for avoiding
to cause write(especially randwrite) perf regression on sparse backed file.

Try IOCB_NOWAIT in the following situations:

- backing file is block device

OR

- READ aio command

OR

- there isn't any queued blocking async WRITEs, because NOWAIT won't cause
contention with blocking WRITE, which often implies exclusive lock

With this simple policy, perf regression of randwrite/write on sparse
backing file is fixed.

Link: https://lore.kernel.org/dm-devel/7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3baabf150488..e1b01285da2a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -68,6 +68,7 @@ struct loop_device {
 	struct rb_root          worker_tree;
 	struct timer_list       timer;
 	bool			sysfs_inited;
+	unsigned 		lo_nr_blocking_writes;
 
 	struct request_queue	*lo_queue;
 	struct blk_mq_tag_set	tag_set;
@@ -514,6 +515,33 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd)
 	return 0;
 }
 
+static inline bool lo_aio_try_nowait(struct loop_device *lo,
+		struct loop_cmd *cmd)
+{
+	struct file *file = lo->lo_backing_file;
+	struct inode *inode = file->f_mapping->host;
+	struct request *rq = blk_mq_rq_from_pdu(cmd);
+
+	/* NOWAIT works fine for backing block device */
+	if (S_ISBLK(inode->i_mode))
+		return true;
+
+	/*
+	 * NOWAIT is supposed to be fine for READ without contending with
+	 * blocking WRITE
+	 */
+	if (req_op(rq) == REQ_OP_READ)
+		return true;
+
+	/*
+	 * If there is any queued non-NOWAIT async WRITE , don't try new
+	 * NOWAIT WRITE for avoiding contention
+	 *
+	 * Here we focus on handling stable FS block mapping via NOWAIT
+	 */
+	return READ_ONCE(lo->lo_nr_blocking_writes) == 0;
+}
+
 static blk_status_t lo_rw_aio_nowait(struct loop_device *lo,
 		struct loop_cmd *cmd)
 {
@@ -523,6 +551,9 @@ static blk_status_t lo_rw_aio_nowait(struct loop_device *lo,
 	if (unlikely(ret < 0))
 		return BLK_STS_IOERR;
 
+	if (!lo_aio_try_nowait(lo, cmd))
+		return BLK_STS_AGAIN;
+
 	cmd->iocb.ki_flags |= IOCB_NOWAIT;
 	ret = lo_submit_rw_aio(lo, cmd, nr_bvec);
 	if (ret == -EAGAIN)
@@ -820,12 +851,19 @@ static ssize_t loop_attr_dio_show(struct loop_device *lo, char *buf)
 	return sysfs_emit(buf, "%s\n", dio ? "1" : "0");
 }
 
+static ssize_t loop_attr_nr_blocking_writes_show(struct loop_device *lo,
+						 char *buf)
+{
+	return sysfs_emit(buf, "%u\n", lo->lo_nr_blocking_writes);
+}
+
 LOOP_ATTR_RO(backing_file);
 LOOP_ATTR_RO(offset);
 LOOP_ATTR_RO(sizelimit);
 LOOP_ATTR_RO(autoclear);
 LOOP_ATTR_RO(partscan);
 LOOP_ATTR_RO(dio);
+LOOP_ATTR_RO(nr_blocking_writes);
 
 static struct attribute *loop_attrs[] = {
 	&loop_attr_backing_file.attr,
@@ -834,6 +872,7 @@ static struct attribute *loop_attrs[] = {
 	&loop_attr_autoclear.attr,
 	&loop_attr_partscan.attr,
 	&loop_attr_dio.attr,
+	&loop_attr_nr_blocking_writes.attr,
 	NULL,
 };
 
@@ -909,6 +948,19 @@ static inline int queue_on_root_worker(struct cgroup_subsys_state *css)
 }
 #endif
 
+static inline void loop_update_blocking_writes(struct loop_device *lo,
+		struct loop_cmd *cmd, bool inc)
+{
+	lockdep_assert_held(&lo->lo_mutex);
+
+	if (req_op(blk_mq_rq_from_pdu(cmd)) == REQ_OP_WRITE) {
+		if (inc)
+			lo->lo_nr_blocking_writes += 1;
+		else
+			lo->lo_nr_blocking_writes -= 1;
+	}
+}
+
 static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
 {
 	struct request __maybe_unused *rq = blk_mq_rq_from_pdu(cmd);
@@ -991,6 +1043,8 @@ static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
 		work = &lo->rootcg_work;
 		cmd_list = &lo->rootcg_cmd_list;
 	}
+	if (cmd->use_aio)
+		loop_update_blocking_writes(lo, cmd, true);
 	list_add_tail(&cmd->list_entry, cmd_list);
 	queue_work(lo->workqueue, work);
 	spin_unlock_irq(&lo->lo_work_lock);
@@ -2057,6 +2111,8 @@ static void loop_process_work(struct loop_worker *worker,
 		cond_resched();
 
 		spin_lock_irq(&lo->lo_work_lock);
+		if (cmd->use_aio)
+			loop_update_blocking_writes(lo, cmd, false);
 	}
 
 	/*
-- 
2.47.0

