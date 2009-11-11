From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] Allocate "struct io" from a slab.
Date: Tue, 10 Nov 2009 21:04:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911102104080.23116@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Allocate "struct io" from a slab.

This patch changes dm-io, so that "struct io" is allocated from a slab cache.
It used to be allocated with kmalloc. Allocating from a slab will be needed
for the next patch, because it requires a special alignment of "struct io"
and kmalloc cannot meet this alignment.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |   19 ++++++++++++++++++-
 drivers/md/dm.c    |    2 ++
 drivers/md/dm.h    |    3 +++
 3 files changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6.31.6-fast/drivers/md/dm-io.c
===================================================================
--- linux-2.6.31.6-fast.orig/drivers/md/dm-io.c	2009-11-11 00:51:03.000000000 +0100
+++ linux-2.6.31.6-fast/drivers/md/dm-io.c	2009-11-11 00:51:22.000000000 +0100
@@ -30,6 +30,8 @@ struct io {
 	void *context;
 };
 
+static struct kmem_cache *_io_cache = NULL;
+
 /*
  * io contexts are only dynamically allocated for asynchronous
  * io.  Since async io is likely to be the majority of io we'll
@@ -53,7 +55,7 @@ struct dm_io_client *dm_io_client_create
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
-	client->pool = mempool_create_kmalloc_pool(ios, sizeof(struct io));
+	client->pool = mempool_create_slab_pool(ios, _io_cache);
 	if (!client->pool)
 		goto bad;
 
@@ -476,3 +478,18 @@ int dm_io(struct dm_io_request *io_req, 
 			&dp, io_req->notify.fn, io_req->notify.context);
 }
 EXPORT_SYMBOL(dm_io);
+
+int __init dm_io_init(void)
+{
+	_io_cache = KMEM_CACHE(io, 0);
+	if (!_io_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void dm_io_exit(void)
+{
+	kmem_cache_destroy(_io_cache);
+	_io_cache = NULL;
+}
Index: linux-2.6.31.6-fast/drivers/md/dm.c
===================================================================
--- linux-2.6.31.6-fast.orig/drivers/md/dm.c	2009-11-11 00:51:04.000000000 +0100
+++ linux-2.6.31.6-fast/drivers/md/dm.c	2009-11-11 00:51:22.000000000 +0100
@@ -275,6 +275,7 @@ static int (*_inits[])(void) __initdata 
 	dm_target_init,
 	dm_linear_init,
 	dm_stripe_init,
+	dm_io_init,
 	dm_kcopyd_init,
 	dm_interface_init,
 };
@@ -284,6 +285,7 @@ static void (*_exits[])(void) = {
 	dm_target_exit,
 	dm_linear_exit,
 	dm_stripe_exit,
+	dm_io_exit,
 	dm_kcopyd_exit,
 	dm_interface_exit,
 };
Index: linux-2.6.31.6-fast/drivers/md/dm.h
===================================================================
--- linux-2.6.31.6-fast.orig/drivers/md/dm.h	2009-11-11 00:51:04.000000000 +0100
+++ linux-2.6.31.6-fast/drivers/md/dm.h	2009-11-11 00:51:22.000000000 +0100
@@ -118,6 +118,9 @@ int dm_lock_for_deletion(struct mapped_d
 void dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 		       unsigned cookie);
 
+int dm_io_init(void);
+void dm_io_exit(void);
+
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
 
