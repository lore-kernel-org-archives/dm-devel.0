From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFCv2 01/10] dm-dedup: main data structures
Date: Thu, 28 Aug 2014 17:56:35 -0400
Message-ID: <53ffb64d.c58d320a.14c8.1413@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

We maintain one dedup_config structure for every dm-dedup target
instance. Every target instance has a metadata backend associated with
it. Metadata backends should implement operations defined in the
metadata_ops structure. Every backend should support two key-value
stores: (1) sparse store, where the hash-to-pbn mapping (the hash index)
is stored; and (2) linear store, where the lbn-to-pbn mapping is stored.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 drivers/md/dm-dedup-backend.h |  114 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-dedup-kvstore.h |   51 ++++++++++++++++++
 drivers/md/dm-dedup-target.h  |  100 ++++++++++++++++++++++++++++++++++++
 3 files changed, 265 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-dedup-backend.h
 create mode 100644 drivers/md/dm-dedup-kvstore.h
 create mode 100644 drivers/md/dm-dedup-target.h

diff --git a/drivers/md/dm-dedup-backend.h b/drivers/md/dm-dedup-backend.h
new file mode 100644
index 0000000..63223a1
--- /dev/null
+++ b/drivers/md/dm-dedup-backend.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2012-2014 Vasily Tarasov
+ * Copyright (C) 2012-2014 Geoff Kuenning
+ * Copyright (C) 2012-2014 Sonam Mandal
+ * Copyright (C) 2012-2014 Karthikeyani Palanisami
+ * Copyright (C) 2012-2014 Philip Shilane
+ * Copyright (C) 2012-2014 Sagar Trehan
+ * Copyright (C) 2012-2014 Erez Zadok
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef BACKEND_H
+#define BACKEND_H
+
+struct metadata;		/* metadata store identifier */
+struct kvstore;			/* key-value store identifier */
+
+#define BF_NEGATIVE -1
+#define BF_POSITIVE 0
+
+struct metadata_ops {
+	/*
+	 * Returns ERR_PTR(*) on error.
+	 * Valid pointer on success.
+	 */
+	struct metadata * (*init_meta)(void *init_param, bool *unformatted);
+
+	void (*exit_meta)(struct metadata *md);
+
+	/*
+	 * Creates linear key-value store. Ksize and vsize in bytes.
+	 * If ksize or vsize are equal to zero, it means that keys
+	 * and values will be of a variable size. kmax is the
+	 * maximum _value_ of the key. If kmax is equal to zero,
+	 * then maximum is not known by the caller.
+	 *
+	 * Returns -ERR_PTR(*) on error.
+	 * Valid pointer on success.
+	 */
+	struct kvstore * (*kvs_create_linear)(struct metadata *md,
+			uint32_t ksize, uint32_t vsize, uint32_t kmax,
+			bool unformatted);
+	/*
+	 * Creates sparse key-value store. Ksize and vsize in bytes.
+	 * If ksize or vsize are equal to zero, it means that keys
+	 * and values will be of a variable size. knummax is the
+	 * maximum _number_ of the keys. If keymax is equal to zero,
+	 * then maximum is not known by the caller.
+	 *
+	 * Returns -ERR_PTR(*) on error.
+	 * Valid pointer on success.
+	 */
+	struct kvstore * (*kvs_create_sparse)(struct metadata *md,
+			uint32_t ksize, uint32_t vsize, uint32_t knummax,
+			bool unformatted);
+
+	/*
+	 * Returns -ERR* on error.
+	 * Returns 0 on success. In this case, "blockn" contains a newly
+	 * allocated block number.
+	 */
+	int (*alloc_data_block)(struct metadata *md, uint64_t *blockn);
+
+	/*
+	 * Returns -ERR* on error.
+	 * Returns 0 on success.
+	 */
+	int (*inc_refcount)(struct metadata *md, uint64_t blockn);
+
+	/*
+	 * Returns -ERR* on error.
+	 * Returns 0 on success.
+	 */
+	int (*dec_refcount)(struct metadata *md, uint64_t blockn);
+
+	/*
+	 * Returns -ERR* on error.
+	 * Returns 0 on success.
+	 */
+	int (*get_refcount)(struct metadata *md, uint64_t blockn);
+
+	/*
+	 * Returns -ERR on error.
+	 * Return 0 on success.
+	 */
+	int (*flush_meta)(struct metadata *md);
+
+	/*
+	 * Returns the private data stored in the metadata.
+	 *
+	 * Returns -ERR* on error.
+	 * Returns 0 on success.
+	 */
+	int (*get_private_data)(struct metadata *md, void **data,
+			uint32_t size);
+
+	/*
+	 * Fills in private data stored in the metadata.
+	 *
+	 * Returns -ERR* on error.
+	 * Returns 0 on success.
+	 */
+	int (*set_private_data)(struct metadata *md, void *data, uint32_t size);
+
+	/*
+	 * This is a hack to drop cache. In future we want to implement
+	 * proper message passing interface, to accomplish this and other
+	 * tasks.
+	 */
+	void (*flush_bufio_cache)(struct metadata *md);
+};
+
+#endif /* BACKEND_H */
diff --git a/drivers/md/dm-dedup-kvstore.h b/drivers/md/dm-dedup-kvstore.h
new file mode 100644
index 0000000..365a7f6
--- /dev/null
+++ b/drivers/md/dm-dedup-kvstore.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2012-2014 Vasily Tarasov
+ * Copyright (C) 2012-2014 Geoff Kuenning
+ * Copyright (C) 2012-2014 Sonam Mandal
+ * Copyright (C) 2012-2014 Karthikeyani Palanisami
+ * Copyright (C) 2012-2014 Philip Shilane
+ * Copyright (C) 2012-2014 Sagar Trehan
+ * Copyright (C) 2012-2014 Erez Zadok
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef KVSTORE_H
+#define KVSTORE_H
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
+#include <linux/list.h>
+#include <linux/err.h>
+#include <asm/current.h>
+#include <linux/string.h>
+#include <linux/gfp.h>
+
+#include <linux/scatterlist.h>
+#include <asm/page.h>
+#include <asm/unaligned.h>
+#include <crypto/hash.h>
+#include <crypto/md5.h>
+#include <crypto/algapi.h>
+
+#include "dm-dedup-target.h"
+
+struct kvstore {
+	uint32_t vsize;
+	uint32_t ksize;
+
+	int (*kvs_delete)(struct kvstore *kvs, void *key, int32_t ksize);
+	int (*kvs_lookup)(struct kvstore *kvs, void *key, int32_t ksize,
+				void *value, int32_t *vsize);
+	int (*kvs_insert)(struct kvstore *kvs, void *key, int32_t ksize,
+				void *value, int32_t vsize);
+	int (*kvs_iterate)(struct kvstore *kvs, int (*itr_action)
+				(void *key, int32_t ksize, void *value,
+				 int32_t vsize, void *data), void *data);
+};
+
+#endif /* KVSTORE_H */
diff --git a/drivers/md/dm-dedup-target.h b/drivers/md/dm-dedup-target.h
new file mode 100644
index 0000000..703ad04
--- /dev/null
+++ b/drivers/md/dm-dedup-target.h
@@ -0,0 +1,100 @@
+/*
+ * Copyright (C) 2012-2014 Vasily Tarasov
+ * Copyright (C) 2012-2014 Geoff Kuenning
+ * Copyright (C) 2012-2014 Sonam Mandal
+ * Copyright (C) 2012-2014 Karthikeyani Palanisami
+ * Copyright (C) 2012-2014 Philip Shilane
+ * Copyright (C) 2012-2014 Sagar Trehan
+ * Copyright (C) 2012-2014 Erez Zadok
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_DEDUP_H
+#define DM_DEDUP_H
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
+#include <linux/list.h>
+#include <linux/err.h>
+#include <asm/current.h>
+#include <linux/string.h>
+#include <linux/gfp.h>
+#include <linux/delay.h>
+#include <linux/time.h>
+#include <linux/parser.h>
+#include <linux/blk_types.h>
+#include <linux/mempool.h>
+
+#include <linux/scatterlist.h>
+#include <asm/page.h>
+#include <asm/unaligned.h>
+#include <crypto/hash.h>
+#include <crypto/md5.h>
+#include <crypto/sha.h>
+#include <crypto/algapi.h>
+
+#define DM_MSG_PREFIX "dedup-mod"
+
+#define CRYPTO_ALG_NAME_LEN     16
+#define MAX_DIGEST_SIZE	SHA256_DIGEST_SIZE
+
+#define MIN_DEDUP_WORK_IO	16
+
+/* Per target instance structure */
+struct dedup_config {
+	struct dm_dev *data_dev;
+	struct dm_dev *metadata_dev;
+
+	uint32_t block_size;	/* in bytes */
+	uint32_t sectors_per_block;
+
+	uint32_t pblocks;	/* physical blocks */
+	uint32_t lblocks;	/* logical blocks */
+
+	struct workqueue_struct *workqueue;
+
+	struct hash_desc_table *desc_table;
+
+	uint64_t logical_block_counter;	/* Total number of used LBNs */
+	uint64_t physical_block_counter;/* Total number of allocated PBNs */
+
+	uint64_t	writes;		/* total number of writes */
+	uint64_t	dupwrites;
+	uint64_t	uniqwrites;
+	uint64_t	reads_on_writes;
+	uint64_t	overwrites;	/* writes to a prev. written offset */
+	uint64_t	newwrites;	/* writes to never written offsets */
+
+	struct dm_io_client *io_client;		/* used for read-on-write
+						   of misaligned requests */
+
+	struct metadata_ops *mdops;
+	struct metadata *bmd;
+	struct kvstore *kvs_hash_pbn;
+	struct kvstore *kvs_lbn_pbn;
+
+	char crypto_alg[CRYPTO_ALG_NAME_LEN];
+	int crypto_key_size;
+
+	uint32_t flushrq;		/* after how many writes call flush */
+	uint64_t writes_after_flush;	/* # of writes after the last flush */
+
+	mempool_t *dedup_work_pool;	/* Dedup work pool */
+};
+
+/* Value of the HASH-PBN key-value store */
+struct hash_pbn_value {
+	uint64_t pbn;	/* in blocks */
+};
+
+/* Value of the LBN-PBN key-value store */
+struct lbn_pbn_value {
+	uint64_t pbn;	/* in blocks */
+};
+
+#endif /* DM_DEDUP_H */
-- 
1.7.1
