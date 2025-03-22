Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB89200B0
	for <dm-devel@lists.linux.dev>; Sat, 22 Mar 2025 01:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742606804; cv=none; b=jUSHsfxJWSrrCpJ0/q6oiYhUxIKuA1v4NbvghtF8m20D1+ztB/j7tFU1bvY5Dn1qn3GD83SSNjJ9qH6FFbsEVCbMF+uZX94LDaHSe5RxkFnURq/vfX7vfc7BkeRvMsYhFye69U6K5gvGY6+EC6osuCRwzQ82O6AFCbTim+mWHy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742606804; c=relaxed/simple;
	bh=NcAuwn+i8L5oEuXthUIDxYma2alnjm5NSxoSC+LOAzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbtKutZIBnLMTOrd7v4VPNdgT6NPKc6jsoz3leL1TN/nifTtkIJAeMBd4H75/wJRp6vwRKwFB080hkrQ/xup+NNEOIPi8p053OG8mxJieQs/KUQoGObnReFAL+mXzdVMr48gDnV2Re/ETUoPCzksZTYZtVXKA0CfHTwJJFquRGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RMGMak0L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RMGMak0L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742606801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nUlqBDHfwWUJZK2tW62gTBJFE4Ef6WuSuhLHJpSvsEw=;
	b=RMGMak0LZB7/bF+NBIWnzDxBRZvQkgxYL6NiJuum3uqVvWChJYkVoyFd9WxV7dxeuDW7mB
	O+w1cNx/c7rY7b6BmqcgQKeXtFTwTrBsVAbngQv/HkD+BgQ59EIGOIqdNDDawnSSmIskVy
	yLOkyaHPP+ixdkzmjLpukb6badTiSl0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-yVCNuLI3NP275SQFsWYb3A-1; Fri,
 21 Mar 2025 21:26:38 -0400
X-MC-Unique: yVCNuLI3NP275SQFsWYb3A-1
X-Mimecast-MFC-AGG-ID: yVCNuLI3NP275SQFsWYb3A_1742606797
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 307311801A06;
	Sat, 22 Mar 2025 01:26:36 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6650219560AF;
	Sat, 22 Mar 2025 01:26:33 +0000 (UTC)
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
Subject: [PATCH V3 1/5] loop: simplify do_req_filebacked()
Date: Sat, 22 Mar 2025 09:26:10 +0800
Message-ID: <20250322012617.354222-2-ming.lei@redhat.com>
In-Reply-To: <20250322012617.354222-1-ming.lei@redhat.com>
References: <20250322012617.354222-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

lo_rw_aio() is only called for READ/WRITE operation, which can be
figured out from request directly, so remove 'rw' parameter from
lo_rw_aio(), meantime rename the local variable as 'dir' which makes
the check more readable in lo_rw_aio().

Meantime add lo_rw_simple() so that do_req_filebacked() can be
simplified in the following way:

```
	if (cmd->use_aio)
		return lo_rw_aio(lo, cmd, pos);
	else
		return lo_rw_simple(lo, rq, pos);
```

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 674527d770dc..339b19671450 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -277,6 +277,13 @@ static int lo_read_simple(struct loop_device *lo, struct request *rq,
 	return 0;
 }
 
+static int lo_rw_simple(struct loop_device *lo, struct request *rq, loff_t pos)
+{
+	if (req_op(rq) == REQ_OP_READ)
+		return lo_read_simple(lo, rq, pos);
+	return lo_write_simple(lo, rq, pos);
+}
+
 static void loop_clear_limits(struct loop_device *lo, int mode)
 {
 	struct queue_limits lim = queue_limits_start_update(lo->lo_queue);
@@ -392,13 +399,13 @@ static void lo_rw_aio_complete(struct kiocb *iocb, long ret)
 	lo_rw_aio_do_completion(cmd);
 }
 
-static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
-		     loff_t pos, int rw)
+static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd, loff_t pos)
 {
 	struct iov_iter iter;
 	struct req_iterator rq_iter;
 	struct bio_vec *bvec;
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
+	int dir = (req_op(rq) == REQ_OP_READ) ? ITER_DEST : ITER_SOURCE;
 	struct bio *bio = rq->bio;
 	struct file *file = lo->lo_backing_file;
 	struct bio_vec tmp;
@@ -440,7 +447,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	}
 	atomic_set(&cmd->ref, 2);
 
-	iov_iter_bvec(&iter, rw, bvec, nr_bvec, blk_rq_bytes(rq));
+	iov_iter_bvec(&iter, dir, bvec, nr_bvec, blk_rq_bytes(rq));
 	iter.iov_offset = offset;
 
 	cmd->iocb.ki_pos = pos;
@@ -449,7 +456,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_flags = IOCB_DIRECT;
 	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
 
-	if (rw == ITER_SOURCE)
+	if (dir == ITER_SOURCE)
 		ret = file->f_op->write_iter(&cmd->iocb, &iter);
 	else
 		ret = file->f_op->read_iter(&cmd->iocb, &iter);
@@ -490,15 +497,11 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_WRITE:
-		if (cmd->use_aio)
-			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
-		else
-			return lo_write_simple(lo, rq, pos);
 	case REQ_OP_READ:
 		if (cmd->use_aio)
-			return lo_rw_aio(lo, cmd, pos, ITER_DEST);
+			return lo_rw_aio(lo, cmd, pos);
 		else
-			return lo_read_simple(lo, rq, pos);
+			return lo_rw_simple(lo, rq, pos);
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
-- 
2.47.0

