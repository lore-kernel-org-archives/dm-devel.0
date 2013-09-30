From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: allocate buffer for messages with small
 number of arguments with GFP_NOIO
Date: Mon, 30 Sep 2013 13:54:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309301351100.32071@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi

Here I'm sending the GFP_NOIO message patch.

I tried the approach with double scan of the message and no reallocation, 
but it performs 5% worse on dm-switch table loading. So I stayed with the 
current approach that does single scan and argv reallocation.

Mikulas

---

dm: allocate buffer for messages with small number of arguments with GFP_NOIO

dm-mpath and dm-thin must process messages even if some device is
suspended, so we allocate argv buffer with GFP_NOIO. These messages have a
small fixed number of arguments.

On the other hand, dm-switch needs to process bulk data using messages and
excessive use of GFP_NOIO could cause trouble.

The patch also lowers the default number of arguments from 64 to 8, so
that there is smaller load on GFP_NOIO allocations.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-table.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-3.11.2-fast/drivers/md/dm-table.c
===================================================================
--- linux-3.11.2-fast.orig/drivers/md/dm-table.c	2013-09-30 19:39:40.000000000 +0200
+++ linux-3.11.2-fast/drivers/md/dm-table.c	2013-09-30 19:40:44.000000000 +0200
@@ -545,14 +545,28 @@ static int adjoin(struct dm_table *table
 
 /*
  * Used to dynamically allocate the arg array.
+ *
+ * We do first allocation with GFP_NOIO because dm-mpath and dm-thin must
+ * process messages even if some device is suspended. These messages have a
+ * small fixed number of arguments.
+ *
+ * On the other hand, dm-switch needs to process bulk data using messages and
+ * excessive use of GFP_NOIO could cause trouble.
  */
 static char **realloc_argv(unsigned *array_size, char **old_argv)
 {
 	char **argv;
 	unsigned new_size;
+	gfp_t gfp;
 
-	new_size = *array_size ? *array_size * 2 : 64;
-	argv = kmalloc(new_size * sizeof(*argv), GFP_KERNEL);
+	if (*array_size) {
+		new_size = *array_size * 2;
+		gfp = GFP_KERNEL;
+	} else {
+		new_size = 8;
+		gfp = GFP_NOIO;
+	}
+	argv = kmalloc(new_size * sizeof(*argv), gfp);
 	if (argv) {
 		memcpy(argv, old_argv, *array_size * sizeof(*argv));
 		*array_size = new_size;
