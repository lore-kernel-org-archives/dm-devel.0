From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] Documentation: change dm-io.txt to document the
	new ap
Date: Thu, 15 May 2008 14:46:11 +0530
Message-ID: <1210842971.5236.3.camel@nikanth-laptop.blr.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

Change documentation in dm-io.txt to the new API

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--
 Documentation/device-mapper/dm-io.txt |   87 ++++++++++++++++++++++-----------
 1 files changed, 58 insertions(+), 29 deletions(-)

diff --git a/Documentation/device-mapper/dm-io.txt b/Documentation/device-mapper/dm-io.txt
index 3b5d9a5..52ebff3 100644
--- a/Documentation/device-mapper/dm-io.txt
+++ b/Documentation/device-mapper/dm-io.txt
@@ -26,50 +26,79 @@ the I/O, along with an offset into the f
       struct page *page;
    };
 
-   int dm_io_sync(unsigned int num_regions, struct io_region *where, int rw,
-                  struct page_list *pl, unsigned int offset,
-                  unsigned long *error_bits);
-   int dm_io_async(unsigned int num_regions, struct io_region *where, int rw,
-                   struct page_list *pl, unsigned int offset,
-                   io_notify_fn fn, void *context);
-
 The second I/O service type takes an array of bio vectors as the data buffer
 for the I/O. This service can be handy if the caller has a pre-assembled bio,
 but wants to direct different portions of the bio to different devices.
 
-   int dm_io_sync_bvec(unsigned int num_regions, struct io_region *where,
-                       int rw, struct bio_vec *bvec,
-                       unsigned long *error_bits);
-   int dm_io_async_bvec(unsigned int num_regions, struct io_region *where,
-                        int rw, struct bio_vec *bvec,
-                        io_notify_fn fn, void *context);
-
 The third I/O service type takes a pointer to a vmalloc'd memory buffer as the
 data buffer for the I/O. This service can be handy if the caller needs to do
 I/O to a large region but doesn't want to allocate a large number of individual
 memory pages.
 
-   int dm_io_sync_vm(unsigned int num_regions, struct io_region *where, int rw,
-                     void *data, unsigned long *error_bits);
-   int dm_io_async_vm(unsigned int num_regions, struct io_region *where, int rw,
-                      void *data, io_notify_fn fn, void *context);
+The fourth I/O service type takes a pointer to kernel memory as the data
+buffer for I/O.
+
+To use any of the I/O service callers should setup a dm_io_request and
+submit it using dm_io().
+
+   struct dm_io_request {
+      int bi_rw;                      /* READ|WRITE - not READA */
+      struct dm_io_memory mem;        /* Memory to use for io */
+      struct dm_io_notify notify;     /* Synchronous if notify.fn is NULL */
+      struct dm_io_client *client;    /* Client memory handler */
+   };
+
+   int dm_io(struct dm_io_request *io_req, unsigned num_regions,
+          struct io_region *region, unsigned long *sync_error_bits);
+
+The type of I/O service is chosen by specifying the appropriate dm_io_mem_type
+and populating the corresponding pointer in dm_io_memory.
+
+   struct dm_io_memory {
+      enum dm_io_mem_type type;
+
+      union {
+         struct page_list *pl;
+         struct bio_vec *bvec;
+         void *vma;
+         void *addr;
+      } ptr;
+
+      unsigned offset;
+   };
+
+   enum dm_io_mem_type {
+      DM_IO_PAGE_LIST,/* Page list */
+      DM_IO_BVEC,     /* Bio vector */
+      DM_IO_VMA,      /* Virtual memory area */
+      DM_IO_KMEM,     /* Kernel memory */
+   };
+
 
 Callers of the asynchronous I/O services must include the name of a completion
 callback routine and a pointer to some context data for the I/O.
 
    typedef void (*io_notify_fn)(unsigned long error, void *context);
 
-The "error" parameter in this callback, as well as the "*error" parameter in
-all of the synchronous versions, is a bitset (instead of a simple error value).
-In the case of an write-I/O to multiple regions, this bitset allows dm-io to
-indicate success or failure on each individual region.
+   struct dm_io_notify {
+      io_notify_fn fn;        /* Callback for asynchronous requests */
+      void *context;          /* Passed to callback */
+   };
+
+
+For asynchronous I/O, private mempools should be created using
+dm_io_client_create().
+
+   struct dm_io_client *dm_io_client_create(unsigned num_pages);
+
+dm_io_client_resize() is used to resize the mempool of the client. To free the
+mempool dm_io_client_destroy() should be used.
 
-Before using any of the dm-io services, the user should call dm_io_get()
-and specify the number of pages they expect to perform I/O on concurrently.
-Dm-io will attempt to resize its mempool to make sure enough pages are
-always available in order to avoid unnecessary waiting while performing I/O.
+   int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client);
+   void dm_io_client_destroy(struct dm_io_client *client);
 
-When the user is finished using the dm-io services, they should call
-dm_io_put() and specify the same number of pages that were given on the
-dm_io_get() call.
+The "error" parameter in this callback, as well as the sync_error_bits
+parameter in dm_io for synchronous calls is a bitset (instead of a simple
+error value). In the case of an write-I/O to multiple regions, this bitset
+allows dm-io to indicate success or failure on each individual region.
 
