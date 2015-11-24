From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: code cleanup - return NULL, not b
Date: Mon, 23 Nov 2015 19:11:32 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511231911120.16811@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

A small code cleanup - return NULL instead of b (although b is NULL at
this point). This function is not returning pointer to the buffer, it is
returning pointer to bufffer's data, thus it makes no sense to return the
variable b.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-4.4-rc2/drivers/md/dm-bufio.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/dm-bufio.c
+++ linux-4.4-rc2/drivers/md/dm-bufio.c
@@ -1068,7 +1068,7 @@ static void *new_read(struct dm_bufio_cl
 	__flush_write_list(&write_list);
 
 	if (!b)
-		return b;
+		return NULL;
 
 	if (need_submit)
 		submit_io(b, READ, b->block, read_endio);
