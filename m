From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/7] document low hanging fruit to help improve
	code readability
Date: Fri,  2 Apr 2010 01:17:52 -0400
Message-ID: <1270185478-8870-2-git-send-email-snitzer@redhat.com>
References: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Documented some changes which should help improve code readability with
FIXME.
---
 drivers/md/dm-multisnap-mikulas.c |    4 ++++
 drivers/md/dm-multisnap-mikulas.h |    7 +++++++
 drivers/md/dm-multisnap-private.h |    5 +++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-multisnap-mikulas.c b/drivers/md/dm-multisnap-mikulas.c
index e16c0d6..1c33dd2 100644
--- a/drivers/md/dm-multisnap-mikulas.c
+++ b/drivers/md/dm-multisnap-mikulas.c
@@ -537,11 +537,15 @@ static void print_bitmaps(struct dm_exception_store *s)
  * Parse arguments, allocate structures and call read_super to read the data
  * from the disk.
  */
+/* FIXME rename all 'struct dm_multisnap *dm' to be using 's' for snapshot, e.g.: */
+/* dm-multisnap-private.h:dm_multisnap_snap uses 'struct dm_multisnap *s' */
 static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
 				     struct dm_exception_store **sp,
 				     unsigned argc, char **argv, char **error)
 {
 	int r, i;
+	/* FIXME replace all 's' with 'ps' in entire dm-multisnap-mikulas.c */
+	/* avoids confusion with 's' being widely known as some form of snapshot in dm */
 	struct dm_exception_store *s;
 
 	s = kzalloc(sizeof(struct dm_exception_store), GFP_KERNEL);
diff --git a/drivers/md/dm-multisnap-mikulas.h b/drivers/md/dm-multisnap-mikulas.h
index 52c87e0..3fdc97e 100644
--- a/drivers/md/dm-multisnap-mikulas.h
+++ b/drivers/md/dm-multisnap-mikulas.h
@@ -49,6 +49,7 @@ struct tmp_remap {
 
 struct bt_key {
 	chunk_t chunk;
+	/* FIXME rename: snapid_{from,to}? */
 	mikulas_snapid_t snap_from;
 	mikulas_snapid_t snap_to;
 };
@@ -59,8 +60,13 @@ struct path_element {
 	unsigned n_entries;
 };
 
+/* FIXME reusing 'dm_exception_store' name lends itself to confusion with legacy snapshots? */
+/* FIXME not to mention, each multisnap stores' 'dm_exception_store' is different */
+/* FIXME rename: dm_multisnap_persistent_exception_store? */
 struct dm_exception_store {
+	/* FIXME rename: multisnap? or just 's' for snapshot? */
 	struct dm_multisnap *dm;
+	/* FIXME rename: bufio_client? */
 	struct dm_bufio_client *bufio;
 
 	chunk_t dev_size;
@@ -71,6 +77,7 @@ struct dm_exception_store {
 	__u8 bt_depth;
 	__u8 flags;
 	__u32 snapshot_num;
+	/* FIXME rename: commit_block_stride? */
 	unsigned cb_stride;
 
 	chunk_t bitmap_root;
diff --git a/drivers/md/dm-multisnap-private.h b/drivers/md/dm-multisnap-private.h
index b623027..5d13ded 100644
--- a/drivers/md/dm-multisnap-private.h
+++ b/drivers/md/dm-multisnap-private.h
@@ -40,6 +40,10 @@ struct dm_multisnap_bio_queue {
 #define DM_MULTISNAP_N_QUEUES	2
 
 struct dm_multisnap {
+	/* FIXME rename 'p' to be more descriptive, maybe 'ps' or 'pstore' for persistent store? */
+	/* FIXME also reorder in struct; put 'store' before 'ps' (_init() order)? */
+	// struct dm_multisnap_exception_store *store;
+	// struct dm_multisnap_persistent_exception_store *ps;
 	struct dm_exception_store *p;
 	struct dm_multisnap_exception_store *store;
 
@@ -52,6 +56,7 @@ struct dm_multisnap {
 	unsigned char chunk_shift;
 
 	unsigned char flags;
+	/* FIXME these flags should be defined outside the struct, like agk fixed for merge */
 #define DM_MULTISNAP_SYNC_SNAPSHOTS		1
 #define DM_MULTISNAP_PRESERVE_ON_ERROR		2
 
-- 
1.6.6.1
