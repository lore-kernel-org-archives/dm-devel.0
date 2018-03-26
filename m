From: mpatocka@redhat.com
Subject: [patch 5/8] dm-bufio recorder fields in dm-buffer
Date: Mon, 26 Mar 2018 20:29:44 +0200
Message-ID: <20180326183057.493320133@debian.vm>
References: <20180326182939.169591126@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-bufio-reorder.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com, msnitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Reorder fields in dm-buffer, so that it improves packing and reduces
structure size. The compiler allocates 32-bit integer for field 'enum
data_mode', so we change it to unsigned char.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-03-26 17:35:00.149999000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2018-03-26 17:35:00.139999000 +0200
@@ -147,11 +147,11 @@ struct dm_buffer {
 	struct list_head lru_list;
 	sector_t block;
 	void *data;
-	enum data_mode data_mode;
+	unsigned char data_mode;		/* DATA_MODE_* */
 	unsigned char list_mode;		/* LIST_* */
-	unsigned hold_count;
 	blk_status_t read_error;
 	blk_status_t write_error;
+	unsigned hold_count;
 	unsigned long state;
 	unsigned long last_accessed;
 	unsigned dirty_start;
@@ -303,7 +303,7 @@ static void __remove(struct dm_bufio_cli
 
 /*----------------------------------------------------------------*/
 
-static void adjust_total_allocated(enum data_mode data_mode, long diff)
+static void adjust_total_allocated(unsigned char data_mode, long diff)
 {
 	static unsigned long * const class_ptr[DATA_MODE_LIMIT] = {
 		&dm_bufio_allocated_kmem_cache,
@@ -368,7 +368,7 @@ static void __cache_size_refresh(void)
  * space.
  */
 static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
-			       enum data_mode *data_mode)
+			       unsigned char *data_mode)
 {
 	if (unlikely(c->slab_cache != NULL)) {
 		*data_mode = DATA_MODE_SLAB;
@@ -408,7 +408,7 @@ static void *alloc_buffer_data(struct dm
  * Free buffer's data.
  */
 static void free_buffer_data(struct dm_bufio_client *c,
-			     void *data, enum data_mode data_mode)
+			     void *data, unsigned char data_mode)
 {
 	switch (data_mode) {
 	case DATA_MODE_SLAB:
