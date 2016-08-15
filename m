From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH 15/16] DM: Add sysfs parameters to track total memory saved and allocated.
Date: Mon, 15 Aug 2016 10:36:52 -0700
Message-ID: <1471282613-31006-16-git-send-email-linuxram@us.ibm.com>
References: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471282613-31006-1-git-send-email-linuxram@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-doc@vger.kernel.org
Cc: shli@kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, Ram Pai <linuxram@us.ibm.com>
List-Id: dm-devel.ids

Add parameters to monitor the memory efficiency of the module.
dm_icomp_total_alloc_size: total memory currently in use.
dm_icomp_total_bio_save: total memory allocation saved by the optimizations.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 drivers/md/dm-inplace-compress.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-inplace-compress.c b/drivers/md/dm-inplace-compress.c
index 31b144b..0a7790a 100644
--- a/drivers/md/dm-inplace-compress.c
+++ b/drivers/md/dm-inplace-compress.c
@@ -82,6 +82,23 @@ static int dm_icomp_compressor_param_set(const char *val,
 	return 0;
 }
 
+static const struct kernel_param_ops dm_icomp_alloc_param_ops = {
+	.set    = param_set_ulong,
+	.get    = param_get_ulong,
+};
+
+static atomic64_t dm_icomp_total_alloc_size;
+#define DMCP_ALLOC(s) {atomic64_add(s, &dm_icomp_total_alloc_size); }
+#define DMCP_FREE_ALLOC(s) {atomic64_sub(s, &dm_icomp_total_alloc_size); }
+module_param_cb(dm_icomp_total_alloc_size, &dm_icomp_alloc_param_ops,
+				&dm_icomp_total_alloc_size, 0644);
+
+static atomic64_t dm_icomp_total_bio_save;
+#define DMCP_ALLOC_SAVE(s) {atomic64_add(s, &dm_icomp_total_bio_save); }
+module_param_cb(dm_icomp_total_bio_save, &dm_icomp_alloc_param_ops,
+				&dm_icomp_total_bio_save, 0644);
+
+
 static struct kmem_cache *dm_icomp_req_cachep;
 static struct kmem_cache *dm_icomp_io_range_cachep;
 static struct kmem_cache *dm_icomp_meta_io_cachep;
@@ -616,6 +633,9 @@ static int dm_icomp_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	atomic64_set(&info->compressed_write_size, 0);
 	atomic64_set(&info->uncompressed_write_size, 0);
 	atomic64_set(&info->meta_write_size, 0);
+	atomic64_set(&dm_icomp_total_alloc_size, 0);
+	atomic64_set(&dm_icomp_total_bio_save, 0);
+
 	ti->num_flush_bios = 1;
 	/* ti->num_discard_bios = 1; */
 	ti->private = info;
@@ -781,18 +801,28 @@ static void dm_icomp_get_req(struct dm_icomp_req *req)
 
 static void *dm_icomp_kmalloc(size_t size, gfp_t flags)
 {
-	return  kmalloc(size, flags);
+	void *addr = kmalloc(size, flags);
+
+	if (addr)
+		DMCP_ALLOC(size);
+	return addr;
 }
 
 static void *dm_icomp_krealloc(void *addr, size_t size,
 		 size_t orig_size, gfp_t flags)
 {
-	return krealloc(addr, size, flags);
+	void *taddr = krealloc(addr, size, flags);
+
+	DMCP_FREE_ALLOC(orig_size);
+	if (taddr)
+		DMCP_ALLOC(size);
+	return taddr;
 }
 
 static void dm_icomp_kfree(void *addr, unsigned int size)
 {
 	kfree(addr);
+	DMCP_FREE_ALLOC(size);
 }
 
 static void dm_icomp_release_decomp_buffer(struct dm_icomp_io_range *io)
@@ -1056,6 +1086,8 @@ static struct dm_icomp_io_range *dm_icomp_create_io_write_range(
 	io->decomp_kmap = (segments == 1);
 	if (!io->decomp_kmap)
 		dm_icomp_bio_copy(req->bio, 0, io->decomp_data, size, true);
+	else
+		DMCP_ALLOC_SAVE(size);
 
 	return io;
 }
-- 
1.7.1
