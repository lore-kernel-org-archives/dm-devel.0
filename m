From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/9] dm snapshot: make chunk_io handle any buffer
Date: Thu, 27 Nov 2008 01:17:31 +0900
Message-ID: <1227716259-31952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1227716259-31952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1227716259-31952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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

chunk_io() can perform I/Os only with ps->area. This patch adds a new
argument (a pointer to a buffer) to chunk_io() so that it can performs
I/Os with the buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-exception-store.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 01590f3..6c5ea26 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -188,7 +188,8 @@ static void do_metadata(struct work_struct *work)
 /*
  * Read or write a chunk aligned and sized block of data from a device.
  */
-static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata)
+static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata,
+		    void *data)
 {
 	struct dm_io_region where = {
 		.bdev = ps->snap->cow->bdev,
@@ -198,7 +199,7 @@ static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata)
 	struct dm_io_request io_req = {
 		.bi_rw = rw,
 		.mem.type = DM_IO_VMA,
-		.mem.ptr.vma = ps->area,
+		.mem.ptr.vma = data,
 		.client = ps->io_client,
 		.notify.fn = NULL,
 	};
@@ -240,7 +241,7 @@ static int area_io(struct pstore *ps, int rw)
 
 	chunk = area_location(ps, ps->current_area);
 
-	r = chunk_io(ps, chunk, rw, 0);
+	r = chunk_io(ps, chunk, rw, 0, ps->area);
 	if (r)
 		return r;
 
@@ -297,7 +298,7 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	if (r)
 		return r;
 
-	r = chunk_io(ps, 0, READ, 1);
+	r = chunk_io(ps, 0, READ, 1, ps->area);
 	if (r)
 		goto bad;
 
@@ -359,7 +360,7 @@ static int write_header(struct pstore *ps)
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->snap->chunk_size);
 
-	return chunk_io(ps, 0, WRITE, 1);
+	return chunk_io(ps, 0, WRITE, 1, ps->area);
 }
 
 /*
-- 
1.5.5.GIT
