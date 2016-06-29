From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 5/6] lightnvm: expose device geometry through sysfs
Date: Wed, 29 Jun 2016 16:51:40 +0200
Message-ID: <1467211901-26707-6-git-send-email-m@bjorling.me>
References: <1467211901-26707-1-git-send-email-m@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467211901-26707-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@fb.com, keith.busch@intel.com, linux-nvme@lists.infradead.org, dm-devel@redhat.com
Cc: "Simon A. F. Lund" <slund@cnexlabs.com>, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
List-Id: dm-devel.ids

=46rom: "Simon A. F. Lund" <slund@cnexlabs.com>

=46or a host to access an Open-Channel SSD, it has to know its geometry=
,
so that it writes and reads at the appropriate device bounds.

Currently, the geometry information is kept within the kernel, and not
exported to user-space for consumption. This patch exposes the
configuration through sysfs and enables user-space libraries, such as
liblightnvm, to use the sysfs implementation to get the geometry of an
Open-Channel SSD.

The sysfs entries are stored within the device hierarchy, and can be
found using the "lightnvm" device type.

An example configuration looks like this:

/sys/class/nvme/
=E2=94=94=E2=94=80=E2=94=80 nvme0n1
   =E2=94=9C=E2=94=80=E2=94=80 capabilities: 3
   =E2=94=9C=E2=94=80=E2=94=80 device_mode: 1
   =E2=94=9C=E2=94=80=E2=94=80 channel_parallelism: 0
   =E2=94=9C=E2=94=80=E2=94=80 erase_max: 1000000
   =E2=94=9C=E2=94=80=E2=94=80 erase_typ: 1000000
   =E2=94=9C=E2=94=80=E2=94=80 flash_media_type: 0
   =E2=94=9C=E2=94=80=E2=94=80 media_capabilities: 0x00000001
   =E2=94=9C=E2=94=80=E2=94=80 media_type: 0
   =E2=94=9C=E2=94=80=E2=94=80 multiplane: 0x00010101
   =E2=94=9C=E2=94=80=E2=94=80 num_blocks: 1022
   =E2=94=9C=E2=94=80=E2=94=80 num_channels: 1
   =E2=94=9C=E2=94=80=E2=94=80 num_luns: 4
   =E2=94=9C=E2=94=80=E2=94=80 num_pages: 64
   =E2=94=9C=E2=94=80=E2=94=80 num_planes: 1
   =E2=94=9C=E2=94=80=E2=94=80 page_size: 4096
   =E2=94=9C=E2=94=80=E2=94=80 prog_max: 100000
   =E2=94=9C=E2=94=80=E2=94=80 prog_typ: 100000
   =E2=94=9C=E2=94=80=E2=94=80 read_max: 10000
   =E2=94=9C=E2=94=80=E2=94=80 read_typ: 10000
   =E2=94=9C=E2=94=80=E2=94=80 sector_oob_size: 0
   =E2=94=9C=E2=94=80=E2=94=80 sector_size: 4096
   =E2=94=9C=E2=94=80=E2=94=80 media_manager: gennvm
   =E2=94=9C=E2=94=80=E2=94=80 ppa_format: 0x380830082808001010102008
   =E2=94=9C=E2=94=80=E2=94=80 vendor_opcode: 0
   =E2=94=94=E2=94=80=E2=94=80 version: 1

Signed-off-by: Simon A. F. Lund <slund@cnexlabs.com>
Signed-off-by: Matias Bj=C3=B8rling <m@bjorling.me>
---
 drivers/lightnvm/Makefile    |   2 +-
 drivers/lightnvm/core.c      |  20 +++--
 drivers/lightnvm/lightnvm.h  |  35 ++++++++
 drivers/lightnvm/sysfs.c     | 195 +++++++++++++++++++++++++++++++++++=
++++++++
 drivers/nvme/host/core.c     |  13 +--
 drivers/nvme/host/lightnvm.c |   6 +-
 drivers/nvme/host/nvme.h     |  20 ++++-
 include/linux/lightnvm.h     |   3 +
 8 files changed, 277 insertions(+), 17 deletions(-)
 create mode 100644 drivers/lightnvm/lightnvm.h
 create mode 100644 drivers/lightnvm/sysfs.c

diff --git a/drivers/lightnvm/Makefile b/drivers/lightnvm/Makefile
index a7a0a22..1f6b652 100644
--- a/drivers/lightnvm/Makefile
+++ b/drivers/lightnvm/Makefile
@@ -2,6 +2,6 @@
 # Makefile for Open-Channel SSDs.
 #
=20
-obj-$(CONFIG_NVM)		:=3D core.o sysblk.o
+obj-$(CONFIG_NVM)		:=3D core.o sysblk.o sysfs.o
 obj-$(CONFIG_NVM_GENNVM) 	+=3D gennvm.o
 obj-$(CONFIG_NVM_RRPC)		+=3D rrpc.o
diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index 0654c06..0208635 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -27,6 +27,8 @@
 #include <linux/lightnvm.h>
 #include <linux/sched/sysctl.h>
=20
+#include "lightnvm.h"
+
 static LIST_HEAD(nvm_tgt_types);
 static DECLARE_RWSEM(nvm_tgtt_lock);
 static LIST_HEAD(nvm_mgrs);
@@ -598,15 +600,19 @@ static void nvm_free_mgr(struct nvm_dev *dev)
 	dev->mt =3D NULL;
 }
=20
-static void nvm_free(struct nvm_dev *dev)
+void nvm_free(struct nvm_dev *dev)
 {
 	if (!dev)
 		return;
=20
 	nvm_free_mgr(dev);
=20
+	if (dev->dma_pool)
+		dev->ops->destroy_dma_pool(dev->dma_pool);
+
 	kfree(dev->lptbl);
 	kfree(dev->lun_map);
+	kfree(dev);
 }
=20
 static int nvm_init(struct nvm_dev *dev)
@@ -653,11 +659,7 @@ err:
=20
 static void nvm_exit(struct nvm_dev *dev)
 {
-	if (dev->dma_pool)
-		dev->ops->destroy_dma_pool(dev->dma_pool);
-	nvm_free(dev);
-
-	pr_info("nvm: successfully unloaded\n");
+	nvm_sysfs_unregister_dev(dev);
 }
=20
 struct nvm_dev *nvm_alloc_dev(int node)
@@ -688,6 +690,10 @@ int nvm_register(struct nvm_dev *dev)
 		}
 	}
=20
+	ret =3D nvm_sysfs_register_dev(dev);
+	if (ret)
+		goto err_ppalist;
+
 	if (dev->identity.cap & NVM_ID_DCAP_BBLKMGMT) {
 		ret =3D nvm_get_sysblock(dev, &dev->sb);
 		if (!ret)
@@ -704,6 +710,8 @@ int nvm_register(struct nvm_dev *dev)
 	up_write(&nvm_lock);
=20
 	return 0;
+err_ppalist:
+	dev->ops->destroy_dma_pool(dev->dma_pool);
 err_init:
 	kfree(dev->lun_map);
 	return ret;
diff --git a/drivers/lightnvm/lightnvm.h b/drivers/lightnvm/lightnvm.h
new file mode 100644
index 0000000..93f1aac
--- /dev/null
+++ b/drivers/lightnvm/lightnvm.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2016 CNEX Labs. All rights reserved.
+ * Initial release: Matias Bjorling <matias@cnexlabs.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
+ * USA.
+ *
+ */
+
+#ifndef LIGHTNVM_H
+#define LIGHTNVM_H
+
+#include <linux/lightnvm.h>
+
+/* core -> sysfs.c */
+int nvm_sysfs_register_dev(struct nvm_dev *);
+void nvm_sysfs_unregister_dev(struct nvm_dev *);
+int nvm_sysfs_register(void);
+void nvm_sysfs_unregister(void);
+
+/* sysfs > core */
+void nvm_free(struct nvm_dev *);
+
+#endif
diff --git a/drivers/lightnvm/sysfs.c b/drivers/lightnvm/sysfs.c
new file mode 100644
index 0000000..b714172
--- /dev/null
+++ b/drivers/lightnvm/sysfs.c
@@ -0,0 +1,195 @@
+#include <linux/kernel.h>
+#include <linux/lightnvm.h>
+#include <linux/miscdevice.h>
+#include <linux/kobject.h>
+#include <linux/blk-mq.h>
+
+#include "lightnvm.h"
+
+static ssize_t nvm_dev_attr_show(struct device *dev,
+				 struct device_attribute *dattr, char *page)
+{
+	struct nvm_dev *ndev =3D container_of(dev, struct nvm_dev, dev);
+	struct nvm_id *id =3D &ndev->identity;
+	struct nvm_id_group *grp =3D &id->groups[0];
+	struct attribute *attr =3D &dattr->attr;
+
+	if (strcmp(attr->name, "version") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", id->ver_id);
+	} else if (strcmp(attr->name, "vendor_opcode") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", id->vmnt);
+	} else if (strcmp(attr->name, "capabilities") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", id->cap);
+	} else if (strcmp(attr->name, "device_mode") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", id->dom);
+	} else if (strcmp(attr->name, "media_manager") =3D=3D 0) {
+		if (!ndev->mt)
+			return scnprintf(page, PAGE_SIZE, "%s\n", "none");
+		return scnprintf(page, PAGE_SIZE, "%s\n", ndev->mt->name);
+	} else if (strcmp(attr->name, "ppa_format") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE,
+			"0x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+			id->ppaf.ch_offset, id->ppaf.ch_len,
+			id->ppaf.lun_offset, id->ppaf.lun_len,
+			id->ppaf.pln_offset, id->ppaf.pln_len,
+			id->ppaf.blk_offset, id->ppaf.blk_len,
+			id->ppaf.pg_offset, id->ppaf.pg_len,
+			id->ppaf.sect_offset, id->ppaf.sect_len);
+	} else if (strcmp(attr->name, "media_type") =3D=3D 0) {	/* u8 */
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->mtype);
+	} else if (strcmp(attr->name, "flash_media_type") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->fmtype);
+	} else if (strcmp(attr->name, "num_channels") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->num_ch);
+	} else if (strcmp(attr->name, "num_luns") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->num_lun);
+	} else if (strcmp(attr->name, "num_planes") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->num_pln);
+	} else if (strcmp(attr->name, "num_blocks") =3D=3D 0) {	/* u16 */
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->num_blk);
+	} else if (strcmp(attr->name, "num_pages") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->num_pg);
+	} else if (strcmp(attr->name, "page_size") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->fpg_sz);
+	} else if (strcmp(attr->name, "hw_sector_size") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->csecs);
+	} else if (strcmp(attr->name, "oob_sector_size") =3D=3D 0) {/* u32 */
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->sos);
+	} else if (strcmp(attr->name, "read_typ") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->trdt);
+	} else if (strcmp(attr->name, "read_max") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->trdm);
+	} else if (strcmp(attr->name, "prog_typ") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->tprt);
+	} else if (strcmp(attr->name, "prog_max") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->tprm);
+	} else if (strcmp(attr->name, "erase_typ") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->tbet);
+	} else if (strcmp(attr->name, "erase_max") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->tbem);
+	} else if (strcmp(attr->name, "multiplane_modes") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "0x%08x\n", grp->mpos);
+	} else if (strcmp(attr->name, "media_capabilities") =3D=3D 0) {
+		return scnprintf(page, PAGE_SIZE, "0x%08x\n", grp->mccap);
+	} else if (strcmp(attr->name, "channel_parallelism") =3D=3D 0) {/* u1=
6 */
+		return scnprintf(page, PAGE_SIZE, "%u\n", grp->cpar);
+	} else {
+		return scnprintf(page,
+				 PAGE_SIZE,
+				 "Unhandled attr(%s) in `nvm_dev_attr_show`\n",
+				 attr->name);
+	}
+}
+
+#define NVM_DEV_ATTR_RO(_name)						\
+	DEVICE_ATTR(_name, S_IRUGO, nvm_dev_attr_show, NULL)
+
+static NVM_DEV_ATTR_RO(version);
+static NVM_DEV_ATTR_RO(vendor_opcode);
+static NVM_DEV_ATTR_RO(capabilities);
+static NVM_DEV_ATTR_RO(device_mode);
+static NVM_DEV_ATTR_RO(ppa_format);
+static NVM_DEV_ATTR_RO(media_manager);
+
+static NVM_DEV_ATTR_RO(media_type);
+static NVM_DEV_ATTR_RO(flash_media_type);
+static NVM_DEV_ATTR_RO(num_channels);
+static NVM_DEV_ATTR_RO(num_luns);
+static NVM_DEV_ATTR_RO(num_planes);
+static NVM_DEV_ATTR_RO(num_blocks);
+static NVM_DEV_ATTR_RO(num_pages);
+static NVM_DEV_ATTR_RO(page_size);
+static NVM_DEV_ATTR_RO(hw_sector_size);
+static NVM_DEV_ATTR_RO(oob_sector_size);
+static NVM_DEV_ATTR_RO(read_typ);
+static NVM_DEV_ATTR_RO(read_max);
+static NVM_DEV_ATTR_RO(prog_typ);
+static NVM_DEV_ATTR_RO(prog_max);
+static NVM_DEV_ATTR_RO(erase_typ);
+static NVM_DEV_ATTR_RO(erase_max);
+static NVM_DEV_ATTR_RO(multiplane_modes);
+static NVM_DEV_ATTR_RO(media_capabilities);
+static NVM_DEV_ATTR_RO(channel_parallelism);
+
+#define NVM_DEV_ATTR(_name) (dev_attr_##_name##)
+
+static struct attribute *nvm_dev_attrs[] =3D {
+	&dev_attr_version.attr,
+	&dev_attr_vendor_opcode.attr,
+	&dev_attr_capabilities.attr,
+	&dev_attr_device_mode.attr,
+	&dev_attr_media_manager.attr,
+
+	&dev_attr_ppa_format.attr,
+	&dev_attr_media_type.attr,
+	&dev_attr_flash_media_type.attr,
+	&dev_attr_num_channels.attr,
+	&dev_attr_num_luns.attr,
+	&dev_attr_num_planes.attr,
+	&dev_attr_num_blocks.attr,
+	&dev_attr_num_pages.attr,
+	&dev_attr_page_size.attr,
+	&dev_attr_hw_sector_size.attr,
+	&dev_attr_oob_sector_size.attr,
+	&dev_attr_read_typ.attr,
+	&dev_attr_read_max.attr,
+	&dev_attr_prog_typ.attr,
+	&dev_attr_prog_max.attr,
+	&dev_attr_erase_typ.attr,
+	&dev_attr_erase_max.attr,
+	&dev_attr_multiplane_modes.attr,
+	&dev_attr_media_capabilities.attr,
+	&dev_attr_channel_parallelism.attr,
+	NULL,
+};
+
+static struct attribute_group nvm_dev_attr_group =3D {
+	.name =3D "lightnvm",
+	.attrs =3D nvm_dev_attrs,
+};
+
+static const struct attribute_group *nvm_dev_attr_groups[] =3D {
+	&nvm_dev_attr_group,
+	NULL,
+};
+
+static void nvm_dev_release(struct device *device)
+{
+	struct nvm_dev *dev =3D container_of(device, struct nvm_dev, dev);
+	struct request_queue *q =3D dev->q;
+
+	pr_debug("nvm/sysfs: `nvm_dev_release`\n");
+
+	blk_mq_unregister_dev(device, q);
+
+	nvm_free(dev);
+}
+
+static struct device_type nvm_type =3D {
+	.name		=3D "lightnvm",
+	.groups		=3D nvm_dev_attr_groups,
+	.release	=3D nvm_dev_release,
+};
+
+int nvm_sysfs_register_dev(struct nvm_dev *dev)
+{
+	if (!dev->parent_dev)
+		return 0;
+
+	dev->dev.parent =3D dev->parent_dev;
+	dev_set_name(&dev->dev, "%s", dev->name);
+	dev->dev.class =3D dev->parent_dev->class;
+	dev->dev.type =3D &nvm_type;
+	device_initialize(&dev->dev);
+	device_add(&dev->dev);
+
+	blk_mq_register_dev(&dev->dev, dev->q);
+
+	return 0;
+}
+
+void nvm_sysfs_unregister_dev(struct nvm_dev *dev)
+{
+	if (dev && dev->parent_dev)
+		kobject_put(&dev->dev.kobj);
+}
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fe135d9..1c58692 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1296,7 +1296,7 @@ static DEVICE_ATTR(rescan_controller, S_IWUSR, NU=
LL, nvme_sysfs_rescan);
 static ssize_t wwid_show(struct device *dev, struct device_attribute *=
attr,
 								char *buf)
 {
-	struct nvme_ns *ns =3D dev_to_disk(dev)->private_data;
+	struct nvme_ns *ns =3D nvme_get_ns_from_dev(dev);
 	struct nvme_ctrl *ctrl =3D ns->ctrl;
 	int serial_len =3D sizeof(ctrl->serial);
 	int model_len =3D sizeof(ctrl->model);
@@ -1320,7 +1320,7 @@ static DEVICE_ATTR(wwid, S_IRUGO, wwid_show, NULL=
);
 static ssize_t uuid_show(struct device *dev, struct device_attribute *=
attr,
 								char *buf)
 {
-	struct nvme_ns *ns =3D dev_to_disk(dev)->private_data;
+	struct nvme_ns *ns =3D nvme_get_ns_from_dev(dev);
 	return sprintf(buf, "%pU\n", ns->uuid);
 }
 static DEVICE_ATTR(uuid, S_IRUGO, uuid_show, NULL);
@@ -1328,7 +1328,7 @@ static DEVICE_ATTR(uuid, S_IRUGO, uuid_show, NULL=
);
 static ssize_t eui_show(struct device *dev, struct device_attribute *a=
ttr,
 								char *buf)
 {
-	struct nvme_ns *ns =3D dev_to_disk(dev)->private_data;
+	struct nvme_ns *ns =3D nvme_get_ns_from_dev(dev);
 	return sprintf(buf, "%8phd\n", ns->eui);
 }
 static DEVICE_ATTR(eui, S_IRUGO, eui_show, NULL);
@@ -1336,7 +1336,7 @@ static DEVICE_ATTR(eui, S_IRUGO, eui_show, NULL);
 static ssize_t nsid_show(struct device *dev, struct device_attribute *=
attr,
 								char *buf)
 {
-	struct nvme_ns *ns =3D dev_to_disk(dev)->private_data;
+	struct nvme_ns *ns =3D nvme_get_ns_from_dev(dev);
 	return sprintf(buf, "%d\n", ns->ns_id);
 }
 static DEVICE_ATTR(nsid, S_IRUGO, nsid_show, NULL);
@@ -1353,7 +1353,7 @@ static umode_t nvme_attrs_are_visible(struct kobj=
ect *kobj,
 		struct attribute *a, int n)
 {
 	struct device *dev =3D container_of(kobj, struct device, kobj);
-	struct nvme_ns *ns =3D dev_to_disk(dev)->private_data;
+	struct nvme_ns *ns =3D nvme_get_ns_from_dev(dev);
=20
 	if (a =3D=3D &dev_attr_uuid.attr) {
 		if (!memchr_inv(ns->uuid, 0, sizeof(ns->uuid)))
@@ -1474,7 +1474,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl,=
 unsigned nsid)
 	sprintf(disk_name, "nvme%dn%d", ctrl->instance, ns->instance);
=20
 	if (nvme_nvm_ns_supported(ns, id)) {
-		if (nvme_nvm_register(ns, disk_name, node)) {
+		if (nvme_nvm_register(ns, disk_name, node,
+							&nvme_ns_attr_group)) {
 			dev_warn(ctrl->dev, "%s: LightNVM init failure\n",
 								__func__);
 			goto out_free_id;
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.=
c
index eb780ef..fbe3209 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -592,10 +592,12 @@ static struct nvm_dev_ops nvme_nvm_dev_ops =3D {
 	.max_phys_sect		=3D 64,
 };
=20
-int nvme_nvm_register(struct nvme_ns *ns, char *disk_name, int node)
+int nvme_nvm_register(struct nvme_ns *ns, char *disk_name, int node,
+		      const struct attribute_group *attrs)
 {
 	struct request_queue *q =3D ns->queue;
 	struct nvm_dev *dev;
+	int ret;
=20
 	dev =3D nvm_alloc_dev(node);
 	if (!dev)
@@ -604,6 +606,8 @@ int nvme_nvm_register(struct nvme_ns *ns, char *dis=
k_name, int node)
 	dev->q =3D q;
 	memcpy(dev->name, disk_name, DISK_NAME_LEN);
 	dev->ops =3D &nvme_nvm_dev_ops;
+	dev->parent_dev =3D ns->ctrl->device;
+	dev->private_data =3D ns;
 	ns->ndev =3D dev;
=20
 	ret =3D nvm_register(dev);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 7b49b45..43a6e93 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -267,11 +267,21 @@ int nvme_sg_get_version_num(int __user *ip);
=20
 #ifdef CONFIG_NVM
 int nvme_nvm_ns_supported(struct nvme_ns *ns, struct nvme_id_ns *id);
-int nvme_nvm_register(struct request_queue *q, char *disk_name);
-void nvme_nvm_unregister(struct request_queue *q, char *disk_name);
+int nvme_nvm_register(struct nvme_ns *ns, char *disk_name, int node,
+		      const struct attribute_group *attrs);
+void nvme_nvm_unregister(struct nvme_ns *ns);
+
+static inline struct nvme_ns *nvme_get_ns_from_dev(struct device *dev)
+{
+	if (dev->type->devnode)
+		return dev_to_disk(dev)->private_data;
+
+	return (container_of(dev, struct nvm_dev, dev))->private_data;
+}
 #else
 static inline int nvme_nvm_register(struct nvme_ns *ns, char *disk_nam=
e,
-								int node)
+				    int node,
+				    const struct attribute_group *attrs)
 {
 	return 0;
 }
@@ -282,6 +292,10 @@ static inline int nvme_nvm_ns_supported(struct nvm=
e_ns *ns, struct nvme_id_ns *i
 {
 	return 0;
 }
+static inline struct nvme_ns *nvme_get_ns_from_dev(struct device *dev)
+{
+	return dev_to_disk(dev)->private_data;
+}
 #endif /* CONFIG_NVM */
=20
 int __init nvme_core_init(void);
diff --git a/include/linux/lightnvm.h b/include/linux/lightnvm.h
index 5afc263..d190786 100644
--- a/include/linux/lightnvm.h
+++ b/include/linux/lightnvm.h
@@ -352,7 +352,10 @@ struct nvm_dev {
=20
 	/* Backend device */
 	struct request_queue *q;
+	struct device dev;
+	struct device *parent_dev;
 	char name[DISK_NAME_LEN];
+	void *private_data;
=20
 	struct mutex mlock;
 	spinlock_t lock;
--=20
2.1.4
