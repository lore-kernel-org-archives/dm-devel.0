From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V9 01/11] block: clone nr_integrity_segments and write_hint in blk_rq_prep_clone
Date: Sun,  3 May 2020 07:54:44 +0800
Message-ID: <20200502235454.1118520-2-ming.lei@redhat.com>
References: <20200502235454.1118520-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200502235454.1118520-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

So far blk_rq_prep_clone() is only used for setup one underlying cloned
request from dm-rq request. block intetrity can be enabled for both dm-rq
and the underlying queues, so it is reasonable to clone rq's
nr_integrity_segments. Also write_hint is from bio, it should have been
cloned too.

So clone nr_integrity_segments and write_hint in blk_rq_prep_clone.

Cc: John Garry <john.garry@huawei.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7f11560bfddb..1fe73051fec3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1630,8 +1630,12 @@ int blk_rq_prep_clone(struct request *rq, struct r=
equest *rq_src,
 		rq->rq_flags |=3D RQF_SPECIAL_PAYLOAD;
 		rq->special_vec =3D rq_src->special_vec;
 	}
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	rq->nr_integrity_segments =3D rq_src->nr_integrity_segments;
+#endif
 	rq->nr_phys_segments =3D rq_src->nr_phys_segments;
 	rq->ioprio =3D rq_src->ioprio;
+	rq->write_hint =3D rq_src->write_hint;
=20
 	return 0;
=20
--=20
2.25.2
