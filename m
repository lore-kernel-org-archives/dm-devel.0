From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 5/5] lightnvm: null_blk integration
Date: Wed,  8 Oct 2014 17:55:36 +0200
Message-ID: <1412783736-18115-6-git-send-email-m@bjorling.me>
References: <1412783736-18115-1-git-send-email-m@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412783736-18115-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: thornber@redhat.com, snitzer@redhat.com, hch@infradead.org, hayakawa@valinux.co.jp, axboe@fb.com, andy@rudoff.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, bvanassche@acm.org, linux-nvme@lists.infradead.org
Cc: jmad@itu.dk, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
List-Id: dm-devel.ids

Allows the null_blk driver to hook into LightNVM for performance
evaluation. The number of channels exposed to LightNVM can be configure=
d
through the lightnvm_num_channels module parameter.

Contributions in this patch from:

  Jesper Madsen <jmad@itu.dk>

Signed-off-by: Matias Bj=C3=B8rling <m@bjorling.me>
---
 Documentation/block/null_blk.txt |   9 +++
 drivers/block/null_blk.c         | 149 +++++++++++++++++++++++++++++++=
++++----
 2 files changed, 144 insertions(+), 14 deletions(-)

diff --git a/Documentation/block/null_blk.txt b/Documentation/block/nul=
l_blk.txt
index b2830b4..639d378 100644
--- a/Documentation/block/null_blk.txt
+++ b/Documentation/block/null_blk.txt
@@ -14,6 +14,9 @@ The following instances are possible:
   Multi-queue block-layer
     - Request-based.
     - Configurable submission queues per device.
+  LightNVM compatible
+    - Request-based.
+    - Same configuration as the multi-queue block layer.
   No block-layer (Known as bio-based)
     - Bio-based. IO requests are submitted directly to the device driv=
er.
     - Directly accepts bio data structure and returns them.
@@ -28,6 +31,7 @@ queue_mode=3D[0-2]: Default: 2-Multi-queue
   0: Bio-based.
   1: Single-queue.
   2: Multi-queue.
+  3: LightNVM device with multi-queue.
=20
 home_node=3D[0--nr_nodes]: Default: NUMA_NO_NODE
   Selects what CPU node the data structures are allocated from.
@@ -70,3 +74,8 @@ use_per_node_hctx=3D[0/1]: Default: 0
      parameter.
   1: The multi-queue block layer is instantiated with a hardware dispa=
tch
      queue for each CPU node in the system.
+
+IV: LightNVM specific parameters
+
+lightnvm_num_channels=3D[x]: Default: 1
+  Number of LightNVM channels that are exposed to the LightNVM driver.
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 00d469c..2f679b1 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/blk-mq.h>
+#include <linux/lightnvm.h>
 #include <linux/hrtimer.h>
=20
 struct nullb_cmd {
@@ -25,6 +26,7 @@ struct nullb_queue {
 	unsigned int queue_depth;
=20
 	struct nullb_cmd *cmds;
+	struct nullb *nb;
 };
=20
 struct nullb {
@@ -33,6 +35,7 @@ struct nullb {
 	struct request_queue *q;
 	struct gendisk *disk;
 	struct blk_mq_tag_set tag_set;
+	struct nvm_dev *nvm_dev;
 	struct hrtimer timer;
 	unsigned int queue_depth;
 	spinlock_t lock;
@@ -67,6 +70,7 @@ enum {
 	NULL_Q_BIO		=3D 0,
 	NULL_Q_RQ		=3D 1,
 	NULL_Q_MQ		=3D 2,
+	NULL_Q_LIGHTNVM		=3D 4,
 };
=20
 static int submit_queues;
@@ -79,7 +83,7 @@ MODULE_PARM_DESC(home_node, "Home node for the device=
");
=20
 static int queue_mode =3D NULL_Q_MQ;
 module_param(queue_mode, int, S_IRUGO);
-MODULE_PARM_DESC(queue_mode, "Block interface to use (0=3Dbio,1=3Drq,2=
=3Dmultiqueue)");
+MODULE_PARM_DESC(queue_mode, "Block interface to use (0=3Dbio,1=3Drq,2=
=3Dmultiqueue,4=3Dlightnvm)");
=20
 static int gb =3D 250;
 module_param(gb, int, S_IRUGO);
@@ -109,6 +113,10 @@ static bool use_per_node_hctx =3D false;
 module_param(use_per_node_hctx, bool, S_IRUGO);
 MODULE_PARM_DESC(use_per_node_hctx, "Use per-node allocation for hardw=
are context queues. Default: false");
=20
+static int lightnvm_num_channels =3D 1;
+module_param(lightnvm_num_channels, int, S_IRUGO);
+MODULE_PARM_DESC(lightnvm_num_channels, "Number of channels to be expo=
sed to LightNVM. Default: 1");
+
 static void put_tag(struct nullb_queue *nq, unsigned int tag)
 {
 	clear_bit_unlock(tag, nq->tag_map);
@@ -179,6 +187,9 @@ static void end_cmd(struct nullb_cmd *cmd)
 	case NULL_Q_MQ:
 		blk_mq_end_io(cmd->rq, 0);
 		return;
+	case NULL_Q_LIGHTNVM:
+		nvm_end_io(cmd->nq->nb->nvm_dev, cmd->rq, 0);
+		return;
 	case NULL_Q_RQ:
 		INIT_LIST_HEAD(&cmd->rq->queuelist);
 		blk_end_request_all(cmd->rq, 0);
@@ -227,7 +238,7 @@ static void null_cmd_end_timer(struct nullb_cmd *cm=
d)
=20
 static void null_softirq_done_fn(struct request *rq)
 {
-	if (queue_mode =3D=3D NULL_Q_MQ)
+	if (queue_mode & (NULL_Q_MQ|NULL_Q_LIGHTNVM))
 		end_cmd(blk_mq_rq_to_pdu(rq));
 	else
 		end_cmd(rq->special);
@@ -239,6 +250,7 @@ static inline void null_handle_cmd(struct nullb_cmd=
 *cmd)
 	switch (irqmode) {
 	case NULL_IRQ_SOFTIRQ:
 		switch (queue_mode)  {
+		case NULL_Q_LIGHTNVM:
 		case NULL_Q_MQ:
 			blk_mq_complete_request(cmd->rq);
 			break;
@@ -313,14 +325,67 @@ static void null_request_fn(struct request_queue =
*q)
 	}
 }
=20
+static int null_nvm_id(struct nvm_dev *dev, struct nvm_id *nvm_id)
+{
+	nvm_id->ver_id =3D 0x1;
+	nvm_id->nvm_type =3D NVM_NVMT_BLK;
+	nvm_id->nchannels =3D lightnvm_num_channels;
+	return 0;
+}
+
+static int null_nvm_id_chnl(struct nvm_dev *dev, int chnl_num,
+							struct nvm_id_chnl *ic)
+{
+	sector_t size =3D gb * 1024 * 1024 * 1024ULL;
+
+	sector_div(size, bs);
+	ic->queue_size =3D hw_queue_depth;
+	ic->gran_read =3D bs;
+	ic->gran_write =3D bs;
+	ic->gran_erase =3D bs * 256;
+	ic->oob_size =3D 0;
+	ic->t_r =3D ic->t_sqr =3D 25000; /* 25us */
+	ic->t_w =3D ic->t_sqw =3D 500000; /* 500us */
+	ic->t_e =3D 1500000; /* 1.500us */
+	ic->io_sched =3D NVM_IOSCHED_CHANNEL;
+	ic->laddr_begin =3D 0;
+	ic->laddr_end =3D size / 8;
+
+	return 0;
+}
+
+static int null_nvm_get_features(struct nvm_dev *dev,
+						struct nvm_get_features *gf)
+{
+	gf->rsp[0] =3D (1 << NVM_RSP_L2P);
+	gf->rsp[0] |=3D (1 << NVM_RSP_P2L);
+	gf->rsp[0] |=3D (1 << NVM_RSP_GC);
+	return 0;
+}
+
+static int null_nvm_set_rsp(struct nvm_dev *dev, u8 rsp, u8 val)
+{
+	return NVM_RID_NOT_CHANGEABLE | NVM_DNR;
+}
+
 static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *r=
q)
 {
 	struct nullb_cmd *cmd =3D blk_mq_rq_to_pdu(rq);
+	struct nullb_queue *nq =3D hctx->driver_data;
+	struct nvm_dev *nvm_dev =3D nq->nb->nvm_dev;
+	int ret =3D BLK_MQ_RQ_QUEUE_OK;
+
+	if (nvm_dev) {
+		ret =3D nvm_queue_rq(nvm_dev, rq);
+		if (ret)
+			goto out;
+	}
=20
 	cmd->rq =3D rq;
-	cmd->nq =3D hctx->driver_data;
+	cmd->nq =3D nq;
=20
 	null_handle_cmd(cmd);
+out:
 	return BLK_MQ_RQ_QUEUE_OK;
 }
=20
@@ -331,6 +396,7 @@ static void null_init_queue(struct nullb *nullb, st=
ruct nullb_queue *nq)
=20
 	init_waitqueue_head(&nq->wait);
 	nq->queue_depth =3D nullb->queue_depth;
+	nq->nb =3D nullb;
 }
=20
 static int null_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
@@ -346,6 +412,13 @@ static int null_init_hctx(struct blk_mq_hw_ctx *hc=
tx, void *data,
 	return 0;
 }
=20
+static struct lightnvm_dev_ops null_nvm_dev_ops =3D {
+	.identify		=3D null_nvm_id,
+	.identify_channel	=3D null_nvm_id_chnl,
+	.get_features		=3D null_nvm_get_features,
+	.set_responsibility	=3D null_nvm_set_rsp,
+};
+
 static struct blk_mq_ops null_mq_ops =3D {
 	.queue_rq       =3D null_queue_rq,
 	.map_queue      =3D blk_mq_map_queue,
@@ -359,8 +432,11 @@ static void null_del_dev(struct nullb *nullb)
=20
 	del_gendisk(nullb->disk);
 	blk_cleanup_queue(nullb->q);
-	if (queue_mode =3D=3D NULL_Q_MQ)
+	if (queue_mode & (NULL_Q_MQ|NULL_Q_LIGHTNVM)) {
+		if (queue_mode =3D=3D NULL_Q_LIGHTNVM)
+			nvm_remove_sysfs(nullb->disk->private_data);
 		blk_mq_free_tag_set(&nullb->tag_set);
+	}
 	put_disk(nullb->disk);
 	kfree(nullb);
 }
@@ -374,10 +450,26 @@ static void null_release(struct gendisk *disk, fm=
ode_t mode)
 {
 }
=20
+static int null_ioctl(struct block_device *bdev, fmode_t mode, unsigne=
d int cmd,
+							unsigned long arg)
+{
+	struct nullb *nullb =3D bdev->bd_disk->private_data;
+	int ret;
+
+	if (nullb->nvm_dev) {
+		ret =3D nvm_ioctl(nullb->nvm_dev, mode, cmd, arg);
+		if (ret !=3D -ENOTTY)
+			return ret;
+	}
+
+	return -ENOTTY;
+};
+
 static const struct block_device_operations null_fops =3D {
 	.owner =3D	THIS_MODULE,
 	.open =3D		null_open,
 	.release =3D	null_release,
+	.ioctl =3D	null_ioctl,
 };
=20
 static int setup_commands(struct nullb_queue *nq)
@@ -461,6 +553,7 @@ static int null_add_dev(void)
 {
 	struct gendisk *disk;
 	struct nullb *nullb;
+	struct nvm_dev *nvm_dev =3D NULL;
 	sector_t size;
 	int rv;
=20
@@ -472,14 +565,14 @@ static int null_add_dev(void)
=20
 	spin_lock_init(&nullb->lock);
=20
-	if (queue_mode =3D=3D NULL_Q_MQ && use_per_node_hctx)
+	if ((queue_mode & (NULL_Q_MQ|NULL_Q_LIGHTNVM)) && use_per_node_hctx)
 		submit_queues =3D nr_online_nodes;
=20
 	rv =3D setup_queues(nullb);
 	if (rv)
 		goto out_free_nullb;
=20
-	if (queue_mode =3D=3D NULL_Q_MQ) {
+	if (queue_mode & (NULL_Q_MQ|NULL_Q_LIGHTNVM)) {
 		nullb->tag_set.ops =3D &null_mq_ops;
 		nullb->tag_set.nr_hw_queues =3D submit_queues;
 		nullb->tag_set.queue_depth =3D hw_queue_depth;
@@ -497,6 +590,18 @@ static int null_add_dev(void)
 			rv =3D -ENOMEM;
 			goto out_cleanup_tags;
 		}
+
+		if (queue_mode =3D=3D NULL_Q_LIGHTNVM) {
+			nvm_dev =3D nvm_alloc();
+			if (!nvm_dev)
+				goto out_cleanup_tags;
+
+			nvm_dev->ops =3D &null_nvm_dev_ops;
+			nvm_dev->driver_data =3D nullb;
+
+			nvm_dev->drv_cmd_size =3D nullb->tag_set.cmd_size;
+			nullb->tag_set.cmd_size +=3D nvm_cmd_size();
+		}
 	} else if (queue_mode =3D=3D NULL_Q_BIO) {
 		nullb->q =3D blk_alloc_queue_node(GFP_KERNEL, home_node);
 		if (!nullb->q) {
@@ -517,6 +622,7 @@ static int null_add_dev(void)
 	}
=20
 	nullb->q->queuedata =3D nullb;
+
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, nullb->q);
=20
 	disk =3D nullb->disk =3D alloc_disk_node(1, home_node);
@@ -525,11 +631,6 @@ static int null_add_dev(void)
 		goto out_cleanup_blk_queue;
 	}
=20
-	mutex_lock(&lock);
-	list_add_tail(&nullb->list, &nullb_list);
-	nullb->index =3D nullb_indexes++;
-	mutex_unlock(&lock);
-
 	blk_queue_logical_block_size(nullb->q, bs);
 	blk_queue_physical_block_size(nullb->q, bs);
=20
@@ -540,17 +641,37 @@ static int null_add_dev(void)
 	disk->flags |=3D GENHD_FL_EXT_DEVT;
 	disk->major		=3D null_major;
 	disk->first_minor	=3D nullb->index;
-	disk->fops		=3D &null_fops;
 	disk->private_data	=3D nullb;
+	disk->fops		=3D &null_fops;
 	disk->queue		=3D nullb->q;
+
+	if (nvm_dev) {
+		nvm_dev->q =3D nullb->q;
+		nvm_dev->disk =3D disk;
+
+		if (nvm_init(disk, nvm_dev))
+			goto out_cleanup_nvm;
+
+		nullb->nvm_dev =3D nvm_dev;
+	}
+
+	mutex_lock(&lock);
+	list_add_tail(&nullb->list, &nullb_list);
+	nullb->index =3D nullb_indexes++;
+	mutex_unlock(&lock);
+
 	sprintf(disk->disk_name, "nullb%d", nullb->index);
 	add_disk(disk);
+	nvm_add_sysfs(nvm_dev);
 	return 0;
=20
+out_cleanup_nvm:
+	put_disk(disk);
 out_cleanup_blk_queue:
 	blk_cleanup_queue(nullb->q);
 out_cleanup_tags:
-	if (queue_mode =3D=3D NULL_Q_MQ)
+	nvm_free(nvm_dev);
+	if (queue_mode & (NULL_Q_MQ|NULL_Q_LIGHTNVM))
 		blk_mq_free_tag_set(&nullb->tag_set);
 out_cleanup_queues:
 	cleanup_queues(nullb);
@@ -570,7 +691,7 @@ static int __init null_init(void)
 		bs =3D PAGE_SIZE;
 	}
=20
-	if (queue_mode =3D=3D NULL_Q_MQ && use_per_node_hctx) {
+	if (queue_mode & (NULL_Q_MQ|NULL_Q_LIGHTNVM) && use_per_node_hctx) {
 		if (submit_queues < nr_online_nodes) {
 			pr_warn("null_blk: submit_queues param is set to %u.",
 							nr_online_nodes);
--=20
1.9.1
