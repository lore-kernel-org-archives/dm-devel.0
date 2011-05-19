From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-io: reserve just one structure
Date: Thu, 19 May 2011 12:57:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105191256010.17915@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-io: reserve just one structure

The reservation counting was totally meaningless.
We always allocate one "struct io" for request, no matter how big the request
is. The code calculated the number of reserved structures depending on request
size and used some "magic" multiplication constant 4. It didn't have any
purpose. The patch changes it to reserve just one structure.

Note that if there is no memory stress, we can still allocate arbitrary number
of "struct io" structures. If there is memory stress, we are guaranteed to
allocate one "io" structure. One structure is enough to process the whole
request, so it's ok.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c              |   23 ++---------------------
 drivers/md/dm-kcopyd.c          |    2 +-
 drivers/md/dm-log.c             |    3 +--
 drivers/md/dm-raid1.c           |    3 +--
 drivers/md/dm-snap-persistent.c |   13 +------------
 include/linux/dm-io.h           |    3 +--
 6 files changed, 7 insertions(+), 40 deletions(-)

Index: linux-2.6.39-rc7-fast/drivers/md/dm-io.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-io.c	2011-05-18 19:48:30.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-io.c	2011-05-18 20:51:32.000000000 +0200
@@ -43,29 +43,17 @@ struct io {
 static struct kmem_cache *_dm_io_cache;
 
 /*
- * io contexts are only dynamically allocated for asynchronous
- * io.  Since async io is likely to be the majority of io we'll
- * have the same number of io contexts as bios! (FIXME: must reduce this).
- */
-
-static unsigned int pages_to_ios(unsigned int pages)
-{
-	return 4 * pages;	/* too many ? */
-}
-
-/*
  * Create a client with mempool and bioset.
  */
-struct dm_io_client *dm_io_client_create(unsigned num_pages)
+struct dm_io_client *dm_io_client_create(void)
 {
-	unsigned ios = pages_to_ios(num_pages);
 	struct dm_io_client *client;
 
 	client = kmalloc(sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
-	client->pool = mempool_create_slab_pool(ios, _dm_io_cache);
+	client->pool = mempool_create_slab_pool(1, _dm_io_cache);
 	if (!client->pool)
 		goto bad;
 
@@ -83,13 +71,6 @@ struct dm_io_client *dm_io_client_create
 }
 EXPORT_SYMBOL(dm_io_client_create);
 
-int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client)
-{
-	return mempool_resize(client->pool, pages_to_ios(num_pages),
-			      GFP_KERNEL);
-}
-EXPORT_SYMBOL(dm_io_client_resize);
-
 void dm_io_client_destroy(struct dm_io_client *client)
 {
 	mempool_destroy(client->pool);
Index: linux-2.6.39-rc7-fast/include/linux/dm-io.h
===================================================================
--- linux-2.6.39-rc7-fast.orig/include/linux/dm-io.h	2011-05-18 18:30:45.000000000 +0200
+++ linux-2.6.39-rc7-fast/include/linux/dm-io.h	2011-05-18 20:51:32.000000000 +0200
@@ -69,8 +69,7 @@ struct dm_io_request {
  *
  * Create/destroy may block.
  */
-struct dm_io_client *dm_io_client_create(unsigned num_pages);
-int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client);
+struct dm_io_client *dm_io_client_create(void);
 void dm_io_client_destroy(struct dm_io_client *client);
 
 /*
Index: linux-2.6.39-rc7-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-raid1.c	2011-05-18 18:30:45.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-raid1.c	2011-05-18 20:51:32.000000000 +0200
@@ -22,7 +22,6 @@
 #define DM_MSG_PREFIX "raid1"
 
 #define MAX_RECOVERY 1	/* Maximum number of regions recovered in parallel. */
-#define DM_IO_PAGES 64
 #define DM_KCOPYD_PAGES 64
 
 #define DM_RAID1_HANDLE_ERRORS 0x01
@@ -887,7 +886,7 @@ static struct mirror_set *alloc_context(
 		return NULL;
 	}
 
-	ms->io_client = dm_io_client_create(DM_IO_PAGES);
+	ms->io_client = dm_io_client_create();
 	if (IS_ERR(ms->io_client)) {
 		ti->error = "Error creating dm_io client";
 		mempool_destroy(ms->read_record_pool);
Index: linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-kcopyd.c	2011-05-18 20:51:31.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c	2011-05-18 20:51:32.000000000 +0200
@@ -645,7 +645,7 @@ int dm_kcopyd_client_create(unsigned int
 	if (r)
 		goto bad_client_pages;
 
-	kc->io_client = dm_io_client_create(nr_pages);
+	kc->io_client = dm_io_client_create();
 	if (IS_ERR(kc->io_client)) {
 		r = PTR_ERR(kc->io_client);
 		goto bad_io_client;
Index: linux-2.6.39-rc7-fast/drivers/md/dm-log.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-log.c	2011-05-18 18:30:45.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-log.c	2011-05-18 20:51:32.000000000 +0200
@@ -449,8 +449,7 @@ static int create_log_context(struct dm_
 
 		lc->io_req.mem.type = DM_IO_VMA;
 		lc->io_req.notify.fn = NULL;
-		lc->io_req.client = dm_io_client_create(dm_div_up(buf_size,
-								   PAGE_SIZE));
+		lc->io_req.client = dm_io_client_create();
 		if (IS_ERR(lc->io_req.client)) {
 			r = PTR_ERR(lc->io_req.client);
 			DMWARN("couldn't allocate disk io client");
Index: linux-2.6.39-rc7-fast/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-snap-persistent.c	2011-05-18 20:00:13.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-snap-persistent.c	2011-05-18 20:51:32.000000000 +0200
@@ -154,11 +154,6 @@ struct pstore {
 	struct workqueue_struct *metadata_wq;
 };
 
-static unsigned sectors_to_pages(unsigned sectors)
-{
-	return DIV_ROUND_UP(sectors, PAGE_SIZE >> 9);
-}
-
 static int alloc_area(struct pstore *ps)
 {
 	int r = -ENOMEM;
@@ -318,8 +313,7 @@ static int read_header(struct pstore *ps
 		chunk_size_supplied = 0;
 	}
 
-	ps->io_client = dm_io_client_create(sectors_to_pages(ps->store->
-							     chunk_size));
+	ps->io_client = dm_io_client_create();
 	if (IS_ERR(ps->io_client))
 		return PTR_ERR(ps->io_client);
 
@@ -368,11 +362,6 @@ static int read_header(struct pstore *ps
 		return r;
 	}
 
-	r = dm_io_client_resize(sectors_to_pages(ps->store->chunk_size),
-				ps->io_client);
-	if (r)
-		return r;
-
 	r = alloc_area(ps);
 	return r;
 
