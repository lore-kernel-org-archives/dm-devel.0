From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 3/3] dm: add reserved_bio_based_ios module
	parameter
Date: Fri, 13 Sep 2013 14:59:40 -0400
Message-ID: <1379098780-15141-4-git-send-email-snitzer@redhat.com>
References: <1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379098780-15141-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379098780-15141-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Allow user to change the number of IOs that are reserved by
bio-based DM's mempools by writing to this file:
/sys/module/dm_mod/parameters/reserved_bio_based_ios

The default value is RESERVED_BIO_BASED_IOS (16).

Export dm_get_reserved_bio_based_ios() for use by DM targets and core
code.  Switch to sizing dm-io's mempool and bioset using DM core's
configurable 'reserved_bio_based_ios'.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-io.c |    7 +++----
 drivers/md/dm.c    |   16 +++++++++++++++-
 drivers/md/dm.h    |    1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index ea49834..2a20986 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -19,8 +19,6 @@
 #define DM_MSG_PREFIX "io"
 
 #define DM_IO_MAX_REGIONS	BITS_PER_LONG
-#define MIN_IOS		16
-#define MIN_BIOS	16
 
 struct dm_io_client {
 	mempool_t *pool;
@@ -50,16 +48,17 @@ static struct kmem_cache *_dm_io_cache;
 struct dm_io_client *dm_io_client_create(void)
 {
 	struct dm_io_client *client;
+	unsigned min_ios = dm_get_reserved_bio_based_ios();
 
 	client = kmalloc(sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
-	client->pool = mempool_create_slab_pool(MIN_IOS, _dm_io_cache);
+	client->pool = mempool_create_slab_pool(min_ios, _dm_io_cache);
 	if (!client->pool)
 		goto bad;
 
-	client->bios = bioset_create(MIN_BIOS, 0);
+	client->bios = bioset_create(min_ios, 0);
 	if (!client->bios)
 		goto bad;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5a4854f..a617fe3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -217,10 +217,21 @@ static struct kmem_cache *_io_cache;
 static struct kmem_cache *_rq_tio_cache;
 
 /*
+ * Bio-based DM's mempools' reserved IOs set by the user.
+ */
+static unsigned reserved_bio_based_ios = RESERVED_BIO_BASED_IOS;
+
+/*
  * Request-based DM's mempools' reserved IOs set by the user.
  */
 static unsigned reserved_rq_based_ios = RESERVED_REQUEST_BASED_IOS;
 
+unsigned dm_get_reserved_bio_based_ios(void)
+{
+	return ACCESS_ONCE(reserved_bio_based_ios);
+}
+EXPORT_SYMBOL_GPL(dm_get_reserved_bio_based_ios);
+
 unsigned dm_get_reserved_rq_based_ios(void)
 {
 	return ACCESS_ONCE(reserved_rq_based_ios);
@@ -2874,7 +2885,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 
 	if (type == DM_TYPE_BIO_BASED) {
 		cachep = _io_cache;
-		pool_size = RESERVED_BIO_BASED_IOS;
+		pool_size = dm_get_reserved_bio_based_ios();
 		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 	} else if (type == DM_TYPE_REQUEST_BASED) {
 		cachep = _rq_tio_cache;
@@ -2937,6 +2948,9 @@ module_exit(dm_exit);
 module_param(major, uint, 0);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
 
+module_param(reserved_bio_based_ios, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(reserved_bio_based_ios, "Reserved IOs in bio-based mempools");
+
 module_param(reserved_rq_based_ios, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools");
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 1539650..1d1ad7b 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -184,6 +184,7 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
 /*
  * Helpers that are used by DM core
  */
+unsigned dm_get_reserved_bio_based_ios(void);
 unsigned dm_get_reserved_rq_based_ios(void);
 
 static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen)
-- 
1.7.1
