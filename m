Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC26C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 08:55:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-ePZ6uRkJM_al8-xZ0t_dcQ-1; Wed, 09 Feb 2022 03:55:38 -0500
X-MC-Unique: ePZ6uRkJM_al8-xZ0t_dcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FB01932480;
	Wed,  9 Feb 2022 08:55:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BD641038ABC;
	Wed,  9 Feb 2022 08:55:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 61ADB4BB7C;
	Wed,  9 Feb 2022 08:55:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2198tS19020235 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 03:55:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 983212166B13; Wed,  9 Feb 2022 08:55:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 938F62166B14
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:55:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DC161066680
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 08:55:25 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-492-BAeF9jFjPMO4Dm4qF1ZD8g-1; Wed, 09 Feb 2022 03:55:23 -0500
X-MC-Unique: BAeF9jFjPMO4Dm4qF1ZD8g-1
Received: from [2001:4bb8:188:3efc:ea2:7599:7eeb:4b5a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nHiL8-00GcAG-EB; Wed, 09 Feb 2022 08:28:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, jinpu.wang@ionos.com, manoj@linux.ibm.com,
	mrochs@linux.ibm.com, ukrishn@linux.ibm.com
Date: Wed,  9 Feb 2022 09:28:23 +0100
Message-Id: <20220209082828.2629273-3-hch@lst.de>
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 2/7] drbd: drop REQ_OP_WRITE_SAME support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

REQ_OP_WRITE_SAME was only ever submitted by the legacy Linux zeroing
code, which has switched to use REQ_OP_WRITE_ZEROES long ago.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c     | 31 ++-----------
 drivers/block/drbd/drbd_nl.c       | 72 +-----------------------------
 drivers/block/drbd/drbd_receiver.c | 47 +++----------------
 drivers/block/drbd/drbd_req.c      |  1 -
 drivers/block/drbd/drbd_worker.c   |  5 ---
 5 files changed, 13 insertions(+), 143 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6f450816c4fa6..96881d5babd9e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -912,7 +912,7 @@ assign_p_sizes_qlim(struct drbd_device *device, struct p_sizes *p,
 		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
 		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
 		p->qlim->discard_enabled = blk_queue_discard(q);
-		p->qlim->write_same_capable = !!q->limits.max_write_same_sectors;
+		p->qlim->write_same_capable = 0;
 	} else {
 		q = device->rq_queue;
 		p->qlim->physical_block_size = cpu_to_be32(queue_physical_block_size(q));
@@ -1591,9 +1591,6 @@ static int _drbd_send_bio(struct drbd_peer_device *peer_device, struct bio *bio)
 					 ? 0 : MSG_MORE);
 		if (err)
 			return err;
-		/* REQ_OP_WRITE_SAME has only one segment */
-		if (bio_op(bio) == REQ_OP_WRITE_SAME)
-			break;
 	}
 	return 0;
 }
@@ -1612,9 +1609,6 @@ static int _drbd_send_zc_bio(struct drbd_peer_device *peer_device, struct bio *b
 				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
 			return err;
-		/* REQ_OP_WRITE_SAME has only one segment */
-		if (bio_op(bio) == REQ_OP_WRITE_SAME)
-			break;
 	}
 	return 0;
 }
@@ -1646,7 +1640,6 @@ static u32 bio_flags_to_wire(struct drbd_connection *connection,
 		return  (bio->bi_opf & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bio->bi_opf & REQ_FUA ? DP_FUA : 0) |
 			(bio->bi_opf & REQ_PREFLUSH ? DP_FLUSH : 0) |
-			(bio_op(bio) == REQ_OP_WRITE_SAME ? DP_WSAME : 0) |
 			(bio_op(bio) == REQ_OP_DISCARD ? DP_DISCARD : 0) |
 			(bio_op(bio) == REQ_OP_WRITE_ZEROES ?
 			  ((connection->agreed_features & DRBD_FF_WZEROES) ?
@@ -1665,7 +1658,6 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 	struct drbd_device *device = peer_device->device;
 	struct drbd_socket *sock;
 	struct p_data *p;
-	struct p_wsame *wsame = NULL;
 	void *digest_out;
 	unsigned int dp_flags = 0;
 	int digest_size;
@@ -1703,29 +1695,14 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 		err = __send_command(peer_device->connection, device->vnr, sock, cmd, sizeof(*t), NULL, 0);
 		goto out;
 	}
-	if (dp_flags & DP_WSAME) {
-		/* this will only work if DRBD_FF_WSAME is set AND the
-		 * handshake agreed that all nodes and backend devices are
-		 * WRITE_SAME capable and agree on logical_block_size */
-		wsame = (struct p_wsame*)p;
-		digest_out = wsame + 1;
-		wsame->size = cpu_to_be32(req->i.size);
-	} else
-		digest_out = p + 1;
+	digest_out = p + 1;
 
 	/* our digest is still only over the payload.
 	 * TRIM does not carry any payload. */
 	if (digest_size)
 		drbd_csum_bio(peer_device->connection->integrity_tfm, req->master_bio, digest_out);
-	if (wsame) {
-		err =
-		    __send_command(peer_device->connection, device->vnr, sock, P_WSAME,
-				   sizeof(*wsame) + digest_size, NULL,
-				   bio_iovec(req->master_bio).bv_len);
-	} else
-		err =
-		    __send_command(peer_device->connection, device->vnr, sock, P_DATA,
-				   sizeof(*p) + digest_size, NULL, req->i.size);
+	err = __send_command(peer_device->connection, device->vnr, sock, P_DATA,
+			     sizeof(*p) + digest_size, NULL, req->i.size);
 	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 44ccf8b4f4b29..02030c9c4d3b1 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1265,71 +1265,6 @@ static void fixup_write_zeroes(struct drbd_device *device, struct request_queue
 		q->limits.max_write_zeroes_sectors = 0;
 }
 
-static void decide_on_write_same_support(struct drbd_device *device,
-			struct request_queue *q,
-			struct request_queue *b, struct o_qlim *o,
-			bool disable_write_same)
-{
-	struct drbd_peer_device *peer_device = first_peer_device(device);
-	struct drbd_connection *connection = peer_device->connection;
-	bool can_do = b ? b->limits.max_write_same_sectors : true;
-
-	if (can_do && disable_write_same) {
-		can_do = false;
-		drbd_info(peer_device, "WRITE_SAME disabled by config\n");
-	}
-
-	if (can_do && connection->cstate >= C_CONNECTED && !(connection->agreed_features & DRBD_FF_WSAME)) {
-		can_do = false;
-		drbd_info(peer_device, "peer does not support WRITE_SAME\n");
-	}
-
-	if (o) {
-		/* logical block size; queue_logical_block_size(NULL) is 512 */
-		unsigned int peer_lbs = be32_to_cpu(o->logical_block_size);
-		unsigned int me_lbs_b = queue_logical_block_size(b);
-		unsigned int me_lbs = queue_logical_block_size(q);
-
-		if (me_lbs_b != me_lbs) {
-			drbd_warn(device,
-				"logical block size of local backend does not match (drbd:%u, backend:%u); was this a late attach?\n",
-				me_lbs, me_lbs_b);
-			/* rather disable write same than trigger some BUG_ON later in the scsi layer. */
-			can_do = false;
-		}
-		if (me_lbs_b != peer_lbs) {
-			drbd_warn(peer_device, "logical block sizes do not match (me:%u, peer:%u); this may cause problems.\n",
-				me_lbs, peer_lbs);
-			if (can_do) {
-				drbd_dbg(peer_device, "logical block size mismatch: WRITE_SAME disabled.\n");
-				can_do = false;
-			}
-			me_lbs = max(me_lbs, me_lbs_b);
-			/* We cannot change the logical block size of an in-use queue.
-			 * We can only hope that access happens to be properly aligned.
-			 * If not, the peer will likely produce an IO error, and detach. */
-			if (peer_lbs > me_lbs) {
-				if (device->state.role != R_PRIMARY) {
-					blk_queue_logical_block_size(q, peer_lbs);
-					drbd_warn(peer_device, "logical block size set to %u\n", peer_lbs);
-				} else {
-					drbd_warn(peer_device,
-						"current Primary must NOT adjust logical block size (%u -> %u); hope for the best.\n",
-						me_lbs, peer_lbs);
-				}
-			}
-		}
-		if (can_do && !o->write_same_capable) {
-			/* If we introduce an open-coded write-same loop on the receiving side,
-			 * the peer would present itself as "capable". */
-			drbd_dbg(peer_device, "WRITE_SAME disabled (peer device not capable)\n");
-			can_do = false;
-		}
-	}
-
-	blk_queue_max_write_same_sectors(q, can_do ? DRBD_MAX_BBIO_SECTORS : 0);
-}
-
 static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backing_dev *bdev,
 				   unsigned int max_bio_size, struct o_qlim *o)
 {
@@ -1339,7 +1274,6 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 	struct request_queue *b = NULL;
 	struct disk_conf *dc;
 	bool discard_zeroes_if_aligned = true;
-	bool disable_write_same = false;
 
 	if (bdev) {
 		b = bdev->backing_bdev->bd_disk->queue;
@@ -1349,7 +1283,6 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 		dc = rcu_dereference(device->ldev->disk_conf);
 		max_segments = dc->max_bio_bvecs;
 		discard_zeroes_if_aligned = dc->discard_zeroes_if_aligned;
-		disable_write_same = dc->disable_write_same;
 		rcu_read_unlock();
 
 		blk_set_stacking_limits(&q->limits);
@@ -1360,7 +1293,6 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 	blk_queue_max_segments(q, max_segments ? max_segments : BLK_MAX_SEGMENTS);
 	blk_queue_segment_boundary(q, PAGE_SIZE-1);
 	decide_on_discard_support(device, q, b, discard_zeroes_if_aligned);
-	decide_on_write_same_support(device, q, b, o, disable_write_same);
 
 	if (b) {
 		blk_stack_limits(&q->limits, &b->limits, 0);
@@ -1666,8 +1598,8 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (write_ordering_changed(old_disk_conf, new_disk_conf))
 		drbd_bump_write_ordering(device->resource, NULL, WO_BDEV_FLUSH);
 
-	if (old_disk_conf->discard_zeroes_if_aligned != new_disk_conf->discard_zeroes_if_aligned
-	||  old_disk_conf->disable_write_same != new_disk_conf->disable_write_same)
+	if (old_disk_conf->discard_zeroes_if_aligned !=
+	    new_disk_conf->discard_zeroes_if_aligned)
 		drbd_reconsider_queue_parameters(device, device->ldev, NULL);
 
 	drbd_md_sync(device);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 04e3ec12d8b49..46e2ec0bd2f98 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1604,19 +1604,7 @@ static void drbd_issue_peer_discard_or_zero_out(struct drbd_device *device, stru
 	drbd_endio_write_sec_final(peer_req);
 }
 
-static void drbd_issue_peer_wsame(struct drbd_device *device,
-				  struct drbd_peer_request *peer_req)
-{
-	struct block_device *bdev = device->ldev->backing_bdev;
-	sector_t s = peer_req->i.sector;
-	sector_t nr = peer_req->i.size >> 9;
-	if (blkdev_issue_write_same(bdev, s, nr, GFP_NOIO, peer_req->pages))
-		peer_req->flags |= EE_WAS_ERROR;
-	drbd_endio_write_sec_final(peer_req);
-}
-
-
-/*
+/**
  * drbd_submit_peer_request()
  * @device:	DRBD device.
  * @peer_req:	peer request
@@ -1651,7 +1639,7 @@ int drbd_submit_peer_request(struct drbd_device *device,
 	 * Correctness first, performance later.  Next step is to code an
 	 * asynchronous variant of the same.
 	 */
-	if (peer_req->flags & (EE_TRIM|EE_WRITE_SAME|EE_ZEROOUT)) {
+	if (peer_req->flags & (EE_TRIM | EE_ZEROOUT)) {
 		/* wait for all pending IO completions, before we start
 		 * zeroing things out. */
 		conn_wait_active_ee_empty(peer_req->peer_device->connection);
@@ -1668,10 +1656,7 @@ int drbd_submit_peer_request(struct drbd_device *device,
 			spin_unlock_irq(&device->resource->req_lock);
 		}
 
-		if (peer_req->flags & (EE_TRIM|EE_ZEROOUT))
-			drbd_issue_peer_discard_or_zero_out(device, peer_req);
-		else /* EE_WRITE_SAME */
-			drbd_issue_peer_wsame(device, peer_req);
+		drbd_issue_peer_discard_or_zero_out(device, peer_req);
 		return 0;
 	}
 
@@ -1854,7 +1839,6 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 	unsigned long *data;
 	struct p_trim *trim = (pi->cmd == P_TRIM) ? pi->data : NULL;
 	struct p_trim *zeroes = (pi->cmd == P_ZEROES) ? pi->data : NULL;
-	struct p_trim *wsame = (pi->cmd == P_WSAME) ? pi->data : NULL;
 
 	digest_size = 0;
 	if (!trim && peer_device->connection->peer_integrity_tfm) {
@@ -1869,7 +1853,7 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 		data_size -= digest_size;
 	}
 
-	/* assume request_size == data_size, but special case trim and wsame. */
+	/* assume request_size == data_size, but special case trim. */
 	ds = data_size;
 	if (trim) {
 		if (!expect(data_size == 0))
@@ -1879,23 +1863,11 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 		if (!expect(data_size == 0))
 			return NULL;
 		ds = be32_to_cpu(zeroes->size);
-	} else if (wsame) {
-		if (data_size != queue_logical_block_size(device->rq_queue)) {
-			drbd_err(peer_device, "data size (%u) != drbd logical block size (%u)\n",
-				data_size, queue_logical_block_size(device->rq_queue));
-			return NULL;
-		}
-		if (data_size != bdev_logical_block_size(device->ldev->backing_bdev)) {
-			drbd_err(peer_device, "data size (%u) != backend logical block size (%u)\n",
-				data_size, bdev_logical_block_size(device->ldev->backing_bdev));
-			return NULL;
-		}
-		ds = be32_to_cpu(wsame->size);
 	}
 
 	if (!expect(IS_ALIGNED(ds, 512)))
 		return NULL;
-	if (trim || wsame || zeroes) {
+	if (trim || zeroes) {
 		if (!expect(ds <= (DRBD_MAX_BBIO_SECTORS << 9)))
 			return NULL;
 	} else if (!expect(ds <= DRBD_MAX_BIO_SIZE))
@@ -1927,8 +1899,6 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 		peer_req->flags |= EE_ZEROOUT;
 		return peer_req;
 	}
-	if (wsame)
-		peer_req->flags |= EE_WRITE_SAME;
 
 	/* receive payload size bytes into page chain */
 	ds = data_size;
@@ -2427,8 +2397,6 @@ static unsigned long wire_flags_to_bio_op(u32 dpf)
 		return REQ_OP_WRITE_ZEROES;
 	if (dpf & DP_DISCARD)
 		return REQ_OP_DISCARD;
-	if (dpf & DP_WSAME)
-		return REQ_OP_WRITE_SAME;
 	else
 		return REQ_OP_WRITE;
 }
@@ -2695,11 +2663,11 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		update_peer_seq(peer_device, peer_seq);
 		spin_lock_irq(&device->resource->req_lock);
 	}
-	/* TRIM and WRITE_SAME are processed synchronously,
+	/* TRIM and is processed synchronously,
 	 * we wait for all pending requests, respectively wait for
 	 * active_ee to become empty in drbd_submit_peer_request();
 	 * better not add ourselves here. */
-	if ((peer_req->flags & (EE_TRIM|EE_WRITE_SAME|EE_ZEROOUT)) == 0)
+	if ((peer_req->flags & (EE_TRIM | EE_ZEROOUT)) == 0)
 		list_add_tail(&peer_req->w.list, &device->active_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
@@ -5068,7 +5036,6 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_TRIM]	    = { 0, sizeof(struct p_trim), receive_Data },
 	[P_ZEROES]	    = { 0, sizeof(struct p_trim), receive_Data },
 	[P_RS_DEALLOCATED]  = { 0, sizeof(struct p_block_desc), receive_rs_deallocated },
-	[P_WSAME]	    = { 1, sizeof(struct p_wsame), receive_Data },
 };
 
 static void drbdd(struct drbd_connection *connection)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c00ae8619519e..d46a3c450af26 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -36,7 +36,6 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device, struct bio
 	req->private_bio->bi_end_io = drbd_request_endio;
 
 	req->rq_state = (bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0)
-		      | (bio_op(bio_src) == REQ_OP_WRITE_SAME ? RQ_WSAME : 0)
 		      | (bio_op(bio_src) == REQ_OP_WRITE_ZEROES ? RQ_ZEROES : 0)
 		      | (bio_op(bio_src) == REQ_OP_DISCARD ? RQ_UNMAP : 0);
 	req->device = device;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index a5e04b38006b6..76af6c249df37 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -329,11 +329,6 @@ void drbd_csum_bio(struct crypto_shash *tfm, struct bio *bio, void *digest)
 		src = kmap_atomic(bvec.bv_page);
 		crypto_shash_update(desc, src + bvec.bv_offset, bvec.bv_len);
 		kunmap_atomic(src);
-
-		/* REQ_OP_WRITE_SAME has only one segment,
-		 * checksum the payload only once. */
-		if (bio_op(bio) == REQ_OP_WRITE_SAME)
-			break;
 	}
 	crypto_shash_final(desc, digest);
 	shash_desc_zero(desc);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

