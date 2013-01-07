From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] use WRITE_FLUSH instead of REQ_FLUSH
Date: Mon, 7 Jan 2013 00:12:19 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1301070009230.7490@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
List-Id: dm-devel.ids

Hi Alasdair

Please push this patch to 3.8 kernel. (I already sent it before, but it 
was forgotten somehow).

Mikulas

---

dm-bufio: use WRITE_FLUSH instead of REQ_FLUSH

Use WRITE_FLUSH instead of REQ_FLUSH to make it consistent with the rest
of the kernel. There is no functional change - the kernel accepts either
WRITE_FLUSH or REQ_FLUSH.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.7-rc6/drivers/md/dm-bufio.c
===================================================================
--- linux-3.7-rc6.orig/drivers/md/dm-bufio.c	2012-11-17 21:14:01.000000000 +0100
+++ linux-3.7-rc6/drivers/md/dm-bufio.c	2012-11-17 21:29:50.000000000 +0100
@@ -1193,7 +1193,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_b
 int dm_bufio_issue_flush(struct dm_bufio_client *c)
 {
 	struct dm_io_request io_req = {
-		.bi_rw = REQ_FLUSH,
+		.bi_rw = WRITE_FLUSH,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = c->dm_io,
