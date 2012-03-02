From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm thin: rename dm_thin_id to more generic
	dm_dev_id
Date: Fri,  2 Mar 2012 18:59:29 -0500
Message-ID: <1330732770-18621-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

dm_thin_id is too specific to thin devices.  Rename to allow for reuse
by other targets.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c |   24 ++++++++++++------------
 drivers/md/dm-thin-metadata.h |   14 +++++++-------
 drivers/md/dm-thin.c          |   16 ++++++++--------
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 1783741..62e7024 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -184,7 +184,7 @@ struct dm_pool_metadata {
 struct dm_thin_device {
 	struct list_head list;
 	struct dm_pool_metadata *pmd;
-	dm_thin_id id;
+	dm_dev_id id;
 
 	int open_count;
 	int changed;
@@ -799,7 +799,7 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
  * on failure, @td is not initialized.
  */
 static int __open_device(struct dm_pool_metadata *pmd,
-			 dm_thin_id dev, int create,
+			 dm_dev_id dev, int create,
 			 struct dm_thin_device **td)
 {
 	int r, changed = 0;
@@ -867,7 +867,7 @@ static void __close_device(struct dm_thin_device *td)
 }
 
 static int __create_thin(struct dm_pool_metadata *pmd,
-			 dm_thin_id dev)
+			 dm_dev_id dev)
 {
 	int r;
 	dm_block_t dev_root;
@@ -910,7 +910,7 @@ static int __create_thin(struct dm_pool_metadata *pmd,
 	return r;
 }
 
-int dm_pool_create_thin(struct dm_pool_metadata *pmd, dm_thin_id dev)
+int dm_pool_create_thin(struct dm_pool_metadata *pmd, dm_dev_id dev)
 {
 	int r;
 
@@ -923,7 +923,7 @@ int dm_pool_create_thin(struct dm_pool_metadata *pmd, dm_thin_id dev)
 
 static int __set_snapshot_details(struct dm_pool_metadata *pmd,
 				  struct dm_thin_device *snap,
-				  dm_thin_id origin, uint32_t time)
+				  dm_dev_id origin, uint32_t time)
 {
 	int r;
 	struct dm_thin_device *td;
@@ -943,7 +943,7 @@ static int __set_snapshot_details(struct dm_pool_metadata *pmd,
 }
 
 static int __create_snap(struct dm_pool_metadata *pmd,
-			 dm_thin_id dev, dm_thin_id origin)
+			 dm_dev_id dev, dm_dev_id origin)
 {
 	int r;
 	dm_block_t origin_root;
@@ -1000,8 +1000,8 @@ bad:
 }
 
 int dm_pool_create_snap(struct dm_pool_metadata *pmd,
-				 dm_thin_id dev,
-				 dm_thin_id origin)
+				 dm_dev_id dev,
+				 dm_dev_id origin)
 {
 	int r;
 
@@ -1012,7 +1012,7 @@ int dm_pool_create_snap(struct dm_pool_metadata *pmd,
 	return r;
 }
 
-static int __delete_device(struct dm_pool_metadata *pmd, dm_thin_id dev)
+static int __delete_device(struct dm_pool_metadata *pmd, dm_dev_id dev)
 {
 	int r;
 	uint64_t key = dev;
@@ -1045,7 +1045,7 @@ static int __delete_device(struct dm_pool_metadata *pmd, dm_thin_id dev)
 }
 
 int dm_pool_delete_thin_device(struct dm_pool_metadata *pmd,
-			       dm_thin_id dev)
+			       dm_dev_id dev)
 {
 	int r;
 
@@ -1188,7 +1188,7 @@ int dm_pool_get_held_metadata_root(struct dm_pool_metadata *pmd,
 	return r;
 }
 
-int dm_pool_open_thin_device(struct dm_pool_metadata *pmd, dm_thin_id dev,
+int dm_pool_open_thin_device(struct dm_pool_metadata *pmd, dm_dev_id dev,
 			     struct dm_thin_device **td)
 {
 	int r;
@@ -1209,7 +1209,7 @@ int dm_pool_close_thin_device(struct dm_thin_device *td)
 	return 0;
 }
 
-dm_thin_id dm_thin_dev_id(struct dm_thin_device *td)
+dm_dev_id dm_thin_dev_id(struct dm_thin_device *td)
 {
 	return td->id;
 }
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 4460857..511a223 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -34,7 +34,7 @@ struct dm_thin_device;
 /*
  * Device identifier
  */
-typedef uint64_t dm_thin_id;
+typedef uint64_t dm_dev_id;
 
 /*
  * Reopens or creates a new, empty metadata volume.
@@ -55,7 +55,7 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd);
 /*
  * Device creation/deletion.
  */
-int dm_pool_create_thin(struct dm_pool_metadata *pmd, dm_thin_id dev);
+int dm_pool_create_thin(struct dm_pool_metadata *pmd, dm_dev_id dev);
 
 /*
  * An internal snapshot.
@@ -63,8 +63,8 @@ int dm_pool_create_thin(struct dm_pool_metadata *pmd, dm_thin_id dev);
  * You can only snapshot a quiesced origin i.e. one that is either
  * suspended or not instanced at all.
  */
-int dm_pool_create_snap(struct dm_pool_metadata *pmd, dm_thin_id dev,
-			dm_thin_id origin);
+int dm_pool_create_snap(struct dm_pool_metadata *pmd, dm_dev_id dev,
+			dm_dev_id origin);
 
 /*
  * Deletes a virtual device from the metadata.  It _is_ safe to call this
@@ -72,7 +72,7 @@ int dm_pool_create_snap(struct dm_pool_metadata *pmd, dm_thin_id dev,
  * failing.  You still need to call close() on the device.
  */
 int dm_pool_delete_thin_device(struct dm_pool_metadata *pmd,
-			       dm_thin_id dev);
+			       dm_dev_id dev);
 
 /*
  * Commits _all_ metadata changes: device creation, deletion, mapping
@@ -106,12 +106,12 @@ int dm_pool_get_held_metadata_root(struct dm_pool_metadata *pmd,
 /*
  * Opening the same device more than once will fail with -EBUSY.
  */
-int dm_pool_open_thin_device(struct dm_pool_metadata *pmd, dm_thin_id dev,
+int dm_pool_open_thin_device(struct dm_pool_metadata *pmd, dm_dev_id dev,
 			     struct dm_thin_device **td);
 
 int dm_pool_close_thin_device(struct dm_thin_device *td);
 
-dm_thin_id dm_thin_dev_id(struct dm_thin_device *td);
+dm_dev_id dm_thin_dev_id(struct dm_thin_device *td);
 
 struct dm_thin_lookup_result {
 	dm_block_t block;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d9ea643..536835f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -107,7 +107,7 @@ struct bio_prison;
 
 struct cell_key {
 	int virtual;
-	dm_thin_id dev;
+	dm_dev_id dev;
 	dm_block_t block;
 };
 
@@ -560,7 +560,7 @@ struct pool_c {
 struct thin_c {
 	struct dm_dev *pool_dev;
 	struct dm_dev *origin_dev;
-	dm_thin_id dev_id;
+	dm_dev_id dev_id;
 
 	struct pool *pool;
 	struct dm_thin_device *td;
@@ -2116,7 +2116,7 @@ static int check_arg_count(unsigned argc, unsigned args_required)
 	return 0;
 }
 
-static int read_dev_id(char *arg, dm_thin_id *dev_id, int warning)
+static int read_dev_id(char *arg, dm_dev_id *dev_id, int warning)
 {
 	if (!kstrtoull(arg, 10, (unsigned long long *)dev_id) &&
 	    *dev_id <= MAX_DEV_ID)
@@ -2130,7 +2130,7 @@ static int read_dev_id(char *arg, dm_thin_id *dev_id, int warning)
 
 static int process_create_thin_mesg(unsigned argc, char **argv, struct pool *pool)
 {
-	dm_thin_id dev_id;
+	dm_dev_id dev_id;
 	int r;
 
 	r = check_arg_count(argc, 2);
@@ -2153,8 +2153,8 @@ static int process_create_thin_mesg(unsigned argc, char **argv, struct pool *poo
 
 static int process_create_snap_mesg(unsigned argc, char **argv, struct pool *pool)
 {
-	dm_thin_id dev_id;
-	dm_thin_id origin_dev_id;
+	dm_dev_id dev_id;
+	dm_dev_id origin_dev_id;
 	int r;
 
 	r = check_arg_count(argc, 3);
@@ -2181,7 +2181,7 @@ static int process_create_snap_mesg(unsigned argc, char **argv, struct pool *poo
 
 static int process_delete_mesg(unsigned argc, char **argv, struct pool *pool)
 {
-	dm_thin_id dev_id;
+	dm_dev_id dev_id;
 	int r;
 
 	r = check_arg_count(argc, 2);
@@ -2201,7 +2201,7 @@ static int process_delete_mesg(unsigned argc, char **argv, struct pool *pool)
 
 static int process_set_transaction_id_mesg(unsigned argc, char **argv, struct pool *pool)
 {
-	dm_thin_id old_id, new_id;
+	dm_dev_id old_id, new_id;
 	int r;
 
 	r = check_arg_count(argc, 3);
-- 
1.7.1
