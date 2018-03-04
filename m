From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: delete outdated comment
Date: Sun, 4 Mar 2018 01:53:00 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1803040152260.29580@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This comment was true when dm-bufio was written, but since the kernel 4.3,
bios can have arbitrary size and the driver splits them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-02-14 20:26:06.458255000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2018-03-04 06:34:28.758289000 +0100
@@ -544,10 +544,6 @@ static void __relink_lru(struct dm_buffe
  *
  *	the memory must be direct-mapped, not vmalloced;
  *
- *	the I/O driver can reject requests spuriously if it thinks that
- *	the requests are too big for the device or if they cross a
- *	controller-defined memory boundary.
- *
  * If the buffer is small enough (up to DM_BUFIO_INLINE_VECS pages) and
  * it is not vmalloced, try using the bio interface.
  *
