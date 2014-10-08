From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 4/5] lightnvm: NVMe integration
Date: Wed,  8 Oct 2014 17:55:35 +0200
Message-ID: <1412783736-18115-5-git-send-email-m@bjorling.me>
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

NVMe devices are identified by the vendor specific bits:

Bit 3 in OACS (device-wide). Currently made per device, as the nvme
namespace is missing in the completion path.
Bit 1 in DSM (per-namespace).

The OACS change can be removed when the namespace is resolvable from th=
e
completion path.

=46rom there, the NVMe specification is extended with the following
commands:

LightNVM Identify
LightNVM Channel identify
LightNVM Synchronious/Asynchronious erase
LightNVM Get Features
LightNVM Set Responsibility
LightNVM Get Logical to Physical map
LightNVM Get Physical to Logical map

The NVMe integration can be tested using Keith Busch NVMe qemu simulato=
r
Lwith ightNVM patches on top. This can be found at:
https://github/LightNVM/qemu-nvme

Contributions in this patch from:

  Jesper Madsen <jmad@itu.dk>

Signed-off-by: Matias Bj=C3=B8rling <m@bjorling.me>
---
 drivers/block/nvme-core.c | 256 ++++++++++++++++++++++++++++++++++++++=
++++++--
 include/linux/nvme.h      |   4 +
 include/uapi/linux/nvme.h |  57 +++++++++++
 3 files changed, 311 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 337878b..22319a5 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -38,6 +38,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/lightnvm.h>
 #include <scsi/sg.h>
 #include <asm-generic/io-64-nonatomic-lo-hi.h>
=20
@@ -60,6 +61,10 @@ static unsigned char retry_time =3D 30;
 module_param(retry_time, byte, 0644);
 MODULE_PARM_DESC(retry_time, "time in seconds to retry failed I/O");
=20
+static unsigned char force_lightnvm;
+module_param(force_lightnvm, byte, 0644);
+MODULE_PARM_DESC(force_lightnvm, "force initialization of lightnvm");
+
 static int nvme_major;
 module_param(nvme_major, int, 0);
=20
@@ -139,8 +144,19 @@ struct nvme_cmd_info {
 	void *ctx;
 	int aborted;
 	struct nvme_queue *nvmeq;
+	struct nvme_ns *ns;
 };
=20
+static void host_lba_set(struct nvme_command *cmd, u32 val)
+{
+	__le32 *cdw12 =3D &cmd->common.cdw10[2];
+	__le32 *cdw13 =3D &cmd->common.cdw10[3];
+
+	val =3D cpu_to_le32(val);
+	*cdw12 =3D ((*cdw12) & 0xff00ffff) | ((val & 0xff) << 16);
+	*cdw13 =3D ((*cdw13) & 0xff) | (val & 0xffffff00);
+}
+
 static int nvme_admin_init_hctx(struct blk_mq_hw_ctx *hctx, void *data=
,
 				unsigned int hctx_idx)
 {
@@ -405,7 +421,10 @@ static void req_completion(struct nvme_queue *nvme=
q, void *ctx,
 			rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	nvme_free_iod(nvmeq->dev, iod);
=20
-	blk_mq_complete_request(req);
+	if (nvmeq->dev->oacs & NVME_CTRL_OACS_LIGHTNVM || force_lightnvm)
+		nvm_complete_request(cmd_rq->ns->nvm_dev, req);
+	else
+		blk_mq_complete_request(req);
 }
=20
 /* length is in bytes.  gfp flags indicates whether we may sleep. */
@@ -576,6 +595,10 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hct=
x, struct request *req)
 	enum dma_data_direction dma_dir;
 	int psegs =3D req->nr_phys_segments;
 	int result =3D BLK_MQ_RQ_QUEUE_BUSY;
+
+	if (ns->nvm_dev)
+		nvm_queue_rq(ns->nvm_dev, req);
+
 	/*
 	 * Requeued IO has already been prepped
 	 */
@@ -591,6 +614,7 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx=
, struct request *req)
 	req->special =3D iod;
=20
 	nvme_set_info(cmd, iod, req_completion);
+	cmd->ns =3D ns;
=20
 	if (req->cmd_flags & REQ_DISCARD) {
 		void *range;
@@ -895,11 +919,61 @@ static int adapter_delete_sq(struct nvme_dev *dev=
, u16 sqid)
 	return adapter_delete_queue(dev, nvme_admin_delete_sq, sqid);
 }
=20
+int lnvm_identify(struct nvme_dev *dev, dma_addr_t dma_addr)
+{
+	struct nvme_command c;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode =3D lnvm_admin_identify;
+	c.common.nsid =3D cpu_to_le32(0);
+	c.common.prp1 =3D cpu_to_le64(dma_addr);
+
+	return nvme_submit_admin_cmd(dev, &c, NULL);
+}
+
+int lnvm_identify_channel(struct nvme_dev *dev, unsigned nsid,
+							dma_addr_t dma_addr)
+{
+	struct nvme_command c;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode =3D lnvm_admin_identify_channel;
+	c.common.nsid =3D cpu_to_le32(nsid);
+	c.common.cdw10[0] =3D cpu_to_le32(nsid);
+	c.common.prp1 =3D cpu_to_le64(dma_addr);
+
+	return nvme_submit_admin_cmd(dev, &c, NULL);
+}
+
+int lnvm_get_features(struct nvme_dev *dev, unsigned nsid, dma_addr_t =
dma_addr)
+{
+	struct nvme_command c;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode =3D lnvm_admin_get_features;
+	c.common.nsid =3D cpu_to_le32(nsid);
+	c.common.prp1 =3D cpu_to_le64(dma_addr);
+
+	return nvme_submit_admin_cmd(dev, &c, NULL);
+}
+
+int lnvm_set_responsibility(struct nvme_dev *dev, unsigned nsid,
+							dma_addr_t dma_addr)
+{
+	struct nvme_command c;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode =3D lnvm_admin_set_responsibility;
+	c.common.nsid =3D cpu_to_le32(nsid);
+	c.common.prp1 =3D cpu_to_le64(dma_addr);
+
+	return nvme_submit_admin_cmd(dev, &c, NULL);
+}
+
 int nvme_identify(struct nvme_dev *dev, unsigned nsid, unsigned cns,
 							dma_addr_t dma_addr)
 {
 	struct nvme_command c;
-
 	memset(&c, 0, sizeof(c));
 	c.identify.opcode =3D nvme_admin_identify;
 	c.identify.nsid =3D cpu_to_le32(nsid);
@@ -1282,6 +1356,90 @@ static int nvme_shutdown_ctrl(struct nvme_dev *d=
ev)
 	return 0;
 }
=20
+static int nvme_nvm_id(struct nvm_dev *nvm_dev, struct nvm_id *nvm_id)
+{
+	struct nvme_ns *ns =3D nvm_dev->driver_data;
+	struct nvme_dev *dev =3D ns->dev;
+	struct pci_dev *pdev =3D dev->pci_dev;
+	struct nvme_lnvm_id_ctrl *ctrl;
+	void *mem;
+	dma_addr_t dma_addr;
+	unsigned int ret =3D 0;
+
+	mem =3D dma_alloc_coherent(&pdev->dev, 4096, &dma_addr, GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+
+	ret =3D lnvm_identify(dev, dma_addr);
+	if (ret) {
+		ret =3D -EIO;
+		goto out;
+	}
+
+	ctrl =3D mem;
+	nvm_id->ver_id =3D le16_to_cpu(ctrl->ver_id);
+	nvm_id->nvm_type =3D ctrl->nvm_type;
+	nvm_id->nchannels =3D le16_to_cpu(ctrl->nchannels);
+ out:
+	dma_free_coherent(&pdev->dev, 4096, mem, dma_addr);
+	return ret;
+}
+
+
+static int nvme_nvm_id_chnl(struct nvm_dev *nvm_dev, int chnl_id,
+							struct nvm_id_chnl *ic)
+{
+	struct nvme_ns *ns =3D nvm_dev->driver_data;
+	struct nvme_dev *dev =3D ns->dev;
+	struct pci_dev *pdev =3D dev->pci_dev;
+	struct nvme_lnvm_id_chnl *chnl;
+	void *mem;
+	dma_addr_t dma_addr;
+	unsigned int ret =3D 0;
+
+	mem =3D dma_alloc_coherent(&pdev->dev, 4096, &dma_addr, GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+
+	ret =3D lnvm_identify_channel(dev, chnl_id, dma_addr);
+	if (ret) {
+		ret =3D -EIO;
+		goto out;
+	}
+
+	chnl =3D mem;
+	ic->queue_size =3D le64_to_cpu(chnl->queue_size);
+	ic->gran_read =3D le64_to_cpu(chnl->gran_read);
+	ic->gran_write =3D le64_to_cpu(chnl->gran_write);
+	ic->gran_erase =3D le64_to_cpu(chnl->gran_erase);
+	ic->oob_size =3D le64_to_cpu(chnl->oob_size);
+	ic->t_r =3D le32_to_cpu(chnl->t_r);
+	ic->t_sqr =3D le32_to_cpu(chnl->t_sqr);
+	ic->t_w =3D le32_to_cpu(chnl->t_w);
+	ic->t_sqw =3D le32_to_cpu(chnl->t_sqw);
+	ic->t_e =3D le32_to_cpu(chnl->t_e);
+	ic->io_sched =3D chnl->io_sched;
+	ic->laddr_begin =3D le64_to_cpu(chnl->laddr_begin);
+	ic->laddr_end =3D le64_to_cpu(chnl->laddr_end);
+ out:
+	dma_free_coherent(&pdev->dev, 4096, mem, dma_addr);
+	return ret;
+}
+
+static int nvme_nvm_get_features(struct nvm_dev *dev,
+						struct nvm_get_features *gf)
+{
+	gf->rsp[0] =3D (1 << NVM_RSP_L2P);
+	gf->rsp[0] |=3D (1 << NVM_RSP_P2L);
+	gf->rsp[0] |=3D (1 << NVM_RSP_GC);
+	return 0;
+}
+
+static int nvme_nvm_set_rsp(struct nvm_dev *dev, u8 rsp, u8 val)
+{
+	return NVM_RID_NOT_CHANGEABLE | NVM_DNR;
+}
+
 static struct blk_mq_ops nvme_mq_admin_ops =3D {
 	.queue_rq	=3D nvme_admin_queue_rq,
 	.map_queue	=3D blk_mq_map_queue,
@@ -1290,6 +1448,13 @@ static struct blk_mq_ops nvme_mq_admin_ops =3D {
 	.timeout	=3D nvme_timeout,
 };
=20
+static struct lightnvm_dev_ops nvme_nvm_dev_ops =3D {
+	.identify		=3D nvme_nvm_id,
+	.identify_channel	=3D nvme_nvm_id_chnl,
+	.get_features		=3D nvme_nvm_get_features,
+	.set_responsibility	=3D nvme_nvm_set_rsp,
+};
+
 static struct blk_mq_ops nvme_mq_ops =3D {
 	.queue_rq	=3D nvme_queue_rq,
 	.map_queue	=3D blk_mq_map_queue,
@@ -1455,6 +1620,26 @@ void nvme_unmap_user_pages(struct nvme_dev *dev,=
 int write,
 		put_page(sg_page(&iod->sg[i]));
 }
=20
+static int lnvme_submit_io(struct nvme_ns *ns, struct nvme_user_io *io=
)
+{
+	struct nvme_command c;
+	struct nvme_dev *dev =3D ns->dev;
+
+	memset(&c, 0, sizeof(c));
+	c.rw.opcode =3D io->opcode;
+	c.rw.flags =3D io->flags;
+	c.rw.nsid =3D cpu_to_le32(ns->ns_id);
+	c.rw.slba =3D cpu_to_le64(io->slba);
+	c.rw.length =3D cpu_to_le16(io->nblocks);
+	c.rw.control =3D cpu_to_le16(io->control);
+	c.rw.dsmgmt =3D cpu_to_le32(io->dsmgmt);
+	c.rw.reftag =3D cpu_to_le32(io->reftag);
+	c.rw.apptag =3D cpu_to_le16(io->apptag);
+	c.rw.appmask =3D cpu_to_le16(io->appmask);
+
+	return nvme_submit_io_cmd(dev, ns, &c, NULL);
+}
+
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __us=
er *uio)
 {
 	struct nvme_dev *dev =3D ns->dev;
@@ -1481,6 +1666,8 @@ static int nvme_submit_io(struct nvme_ns *ns, str=
uct nvme_user_io __user *uio)
 		iod =3D nvme_map_user_pages(dev, io.opcode & 1, io.addr, length);
 		break;
 	default:
+		if (ns->nvm_dev)
+			return lnvme_submit_io(ns, &io);
 		return -EINVAL;
 	}
=20
@@ -1498,6 +1685,7 @@ static int nvme_submit_io(struct nvme_ns *ns, str=
uct nvme_user_io __user *uio)
 	c.rw.reftag =3D cpu_to_le32(io.reftag);
 	c.rw.apptag =3D cpu_to_le16(io.apptag);
 	c.rw.appmask =3D cpu_to_le16(io.appmask);
+	host_lba_set(&c, io.host_lba);
=20
 	if (meta_len) {
 		meta_iod =3D nvme_map_user_pages(dev, io.opcode & 1, io.metadata,
@@ -1632,6 +1820,13 @@ static int nvme_ioctl(struct block_device *bdev,=
 fmode_t mode, unsigned int cmd,
 							unsigned long arg)
 {
 	struct nvme_ns *ns =3D bdev->bd_disk->private_data;
+	int ret;
+
+	if (ns->nvm_dev) {
+		ret =3D nvm_ioctl(ns->nvm_dev, mode, cmd, arg);
+		if (ret !=3D -ENOTTY)
+			return ret;
+	}
=20
 	switch (cmd) {
 	case NVME_IOCTL_ID:
@@ -1655,6 +1850,13 @@ static int nvme_compat_ioctl(struct block_device=
 *bdev, fmode_t mode,
 					unsigned int cmd, unsigned long arg)
 {
 	struct nvme_ns *ns =3D bdev->bd_disk->private_data;
+	int ret;
+
+	if (ns->nvm_dev) {
+		ret =3D nvm_ioctl(ns->nvm_dev, mode, cmd, arg);
+		if (ret !=3D -ENOTTY)
+			return ret;
+	}
=20
 	switch (cmd) {
 	case SG_IO:
@@ -1756,6 +1958,7 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_=
dev *dev, unsigned nsid,
 			struct nvme_id_ns *id, struct nvme_lba_range_type *rt)
 {
 	struct nvme_ns *ns;
+	struct nvm_dev *nvm_dev =3D NULL;
 	struct gendisk *disk;
 	int node =3D dev_to_node(&dev->pci_dev->dev);
 	int lbaf;
@@ -1766,15 +1969,27 @@ static struct nvme_ns *nvme_alloc_ns(struct nvm=
e_dev *dev, unsigned nsid,
 	ns =3D kzalloc_node(sizeof(*ns), GFP_KERNEL, node);
 	if (!ns)
 		return NULL;
+
+	if (id->nsfeat & NVME_NS_FEAT_LIGHTNVM || force_lightnvm) {
+		nvm_dev =3D nvm_alloc();
+		if (!nvm_dev)
+			goto out_free_ns;
+
+		nvm_dev->ops =3D &nvme_nvm_dev_ops;
+
+		nvm_dev->driver_data =3D ns;
+		nvm_dev->drv_cmd_size =3D dev->tagset.cmd_size - nvm_cmd_size();
+	}
+
 	ns->queue =3D blk_mq_init_queue(&dev->tagset);
 	if (!ns->queue)
-		goto out_free_ns;
-	queue_flag_set_unlocked(QUEUE_FLAG_DEFAULT, ns->queue);
+		goto out_free_nvm;
 	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_SG_GAPS, ns->queue);
 	queue_flag_clear_unlocked(QUEUE_FLAG_IO_STAT, ns->queue);
 	ns->dev =3D dev;
+
 	ns->queue->queuedata =3D ns;
=20
 	disk =3D alloc_disk_node(0, node);
@@ -1807,8 +2022,24 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme=
_dev *dev, unsigned nsid,
 	if (dev->oncs & NVME_CTRL_ONCS_DSM)
 		nvme_config_discard(ns);
=20
+	if (id->nsfeat & NVME_NS_FEAT_LIGHTNVM || force_lightnvm) {
+		/* Limit to 4K until LightNVM supports multiple IOs */
+		blk_queue_max_hw_sectors(ns->queue, 8);
+
+		nvm_dev->q =3D ns->queue;
+		nvm_dev->disk =3D disk;
+
+		if (nvm_init(disk, nvm_dev))
+			goto out_put_disk;
+
+		ns->nvm_dev =3D nvm_dev;
+	}
+
 	return ns;
-
+ out_put_disk:
+	put_disk(disk);
+ out_free_nvm:
+	nvm_free(nvm_dev);
  out_free_queue:
 	blk_cleanup_queue(ns->queue);
  out_free_ns:
@@ -1954,6 +2185,7 @@ static int nvme_dev_add(struct nvme_dev *dev)
 	ctrl =3D mem;
 	nn =3D le32_to_cpup(&ctrl->nn);
 	dev->oncs =3D le16_to_cpup(&ctrl->oncs);
+	dev->oacs =3D le16_to_cpup(&ctrl->oacs);
 	dev->abort_limit =3D ctrl->acl + 1;
 	dev->vwc =3D ctrl->vwc;
 	memcpy(dev->serial, ctrl->sn, sizeof(ctrl->sn));
@@ -1983,6 +2215,15 @@ static int nvme_dev_add(struct nvme_dev *dev)
 	dev->tagset.flags =3D BLK_MQ_F_SHOULD_MERGE;
 	dev->tagset.driver_data =3D dev;
=20
+	/* LightNVM is actually per ns, but as the tagset is defined with a s=
et
+	 * of operations for the hole device. It currently is either all or
+	 * no lightnvm compatible name-spaces for a given device. This should
+	 * either be moved toward the nvme_queue_rq function, or allow per ns
+	 * queue_rq function to be specified.
+	 */
+	if (dev->oacs & NVME_CTRL_OACS_LIGHTNVM || force_lightnvm)
+		dev->tagset.cmd_size +=3D nvm_cmd_size();
+
 	if (blk_mq_alloc_tag_set(&dev->tagset))
 		goto out;
=20
@@ -2004,8 +2245,11 @@ static int nvme_dev_add(struct nvme_dev *dev)
 		if (ns)
 			list_add_tail(&ns->list, &dev->namespaces);
 	}
-	list_for_each_entry(ns, &dev->namespaces, list)
+	list_for_each_entry(ns, &dev->namespaces, list) {
 		add_disk(ns->disk);
+		if (ns->nvm_dev)
+			nvm_add_sysfs(ns->nvm_dev);
+	}
 	res =3D 0;
=20
  out:
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 299e6f5..242ad31 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -20,6 +20,7 @@
 #include <linux/miscdevice.h>
 #include <linux/kref.h>
 #include <linux/blk-mq.h>
+#include <linux/lightnvm.h>
=20
 struct nvme_bar {
 	__u64			cap;	/* Controller Capabilities */
@@ -100,6 +101,7 @@ struct nvme_dev {
 	u32 max_hw_sectors;
 	u32 stripe_size;
 	u16 oncs;
+	u16 oacs;
 	u16 abort_limit;
 	u8 vwc;
 	u8 initialized;
@@ -120,6 +122,8 @@ struct nvme_ns {
 	int ms;
 	u64 mode_select_num_blocks;
 	u32 mode_select_block_len;
+
+	struct nvm_dev *nvm_dev;
 };
=20
 /*
diff --git a/include/uapi/linux/nvme.h b/include/uapi/linux/nvme.h
index 29a7d86..965da53 100644
--- a/include/uapi/linux/nvme.h
+++ b/include/uapi/linux/nvme.h
@@ -85,6 +85,30 @@ struct nvme_id_ctrl {
 	__u8			vs[1024];
 };
=20
+struct nvme_lnvm_id_ctrl {
+	__le16			ver_id;
+	__u8			nvm_type;
+	__le16			nchannels;
+	__u8			unused[4091];
+} __attribute__((packed));
+
+struct nvme_lnvm_id_chnl {
+	__le64			queue_size;
+	__le64			gran_read;
+	__le64			gran_write;
+	__le64			gran_erase;
+	__le64			oob_size;
+	__le32			t_r;
+	__le32			t_sqr;
+	__le32			t_w;
+	__le32			t_sqw;
+	__le32			t_e;
+	__u8			io_sched;
+	__le64			laddr_begin;
+	__le64			laddr_end;
+	__u8			unused[4034];
+} __attribute__((packed));
+
 enum {
 	NVME_CTRL_ONCS_COMPARE			=3D 1 << 0,
 	NVME_CTRL_ONCS_WRITE_UNCORRECTABLE	=3D 1 << 1,
@@ -123,7 +147,12 @@ struct nvme_id_ns {
 };
=20
 enum {
+	NVME_CTRL_OACS_LIGHTNVM	=3D 1 << 3,
+};
+
+enum {
 	NVME_NS_FEAT_THIN	=3D 1 << 0,
+	NVME_NS_FEAT_LIGHTNVM	=3D 1 << 1,
 	NVME_LBAF_RP_BEST	=3D 0,
 	NVME_LBAF_RP_BETTER	=3D 1,
 	NVME_LBAF_RP_GOOD	=3D 2,
@@ -192,6 +221,11 @@ enum nvme_opcode {
 	nvme_cmd_dsm		=3D 0x09,
 };
=20
+enum lnvme_opcode {
+	lnvme_cmd_erase_sync	=3D 0x80,
+	lnvme_cmd_erase_async	=3D 0x81,
+};
+
 struct nvme_common_command {
 	__u8			opcode;
 	__u8			flags;
@@ -287,6 +321,15 @@ enum nvme_admin_opcode {
 	nvme_admin_security_recv	=3D 0x82,
 };
=20
+enum lnvm_admin_opcode {
+	lnvm_admin_identify		=3D 0xc0,
+	lnvm_admin_identify_channel	=3D 0xc1,
+	lnvm_admin_get_features		=3D 0xc2,
+	lnvm_admin_set_responsibility	=3D 0xc3,
+	lnvm_admin_get_l2p_tbl		=3D 0xc4,
+	lnvm_admin_get_p2l_tbl		=3D 0xc5,
+};
+
 enum {
 	NVME_QUEUE_PHYS_CONTIG	=3D (1 << 0),
 	NVME_CQ_IRQ_ENABLED	=3D (1 << 1),
@@ -410,6 +453,18 @@ struct nvme_format_cmd {
 	__u32			rsvd11[5];
 };
=20
+struct nvme_lnvm_identify {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__u64			rsvd[2];
+	__le64			prp1;
+	__le64			prp2;
+	__le32			cns;
+	__u32			rsvd11[5];
+};
+
 struct nvme_command {
 	union {
 		struct nvme_common_command common;
@@ -423,6 +478,7 @@ struct nvme_command {
 		struct nvme_format_cmd format;
 		struct nvme_dsm_cmd dsm;
 		struct nvme_abort_cmd abort;
+		struct nvme_lnvm_identify lnvm_identify;
 	};
 };
=20
@@ -487,6 +543,7 @@ struct nvme_user_io {
 	__u32	reftag;
 	__u16	apptag;
 	__u16	appmask;
+	__u32	host_lba;
 };
=20
 struct nvme_admin_cmd {
--=20
1.9.1
