From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: set last_accessed when relinking the
	buffer
Date: Tue, 30 Sep 2014 11:54:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1409301150290.11404@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>, Ben Turner <bturner@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

Here I'm sending the patch for dm-bufio last_accessed. (bug 1145230)

BTW. do you think that we also need to increase default max_age value (60 
seconds)? What do you think the default value should be?

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The variable last_accessed was set only once when the buffer was created.
In the result, the buffer was discarded after dm_bufio_max_age, even if it
was used recently.

This patch changes it so that last_accessed is set each time the buffer is
moved to the head of the LRU list, so the buffer is discarded if it was
not used in dm_bufio_max_age time.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v3.2+

---
 drivers/md/dm-bufio.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-3.17-rc7/drivers/md/dm-bufio.c
===================================================================
--- linux-3.17-rc7.orig/drivers/md/dm-bufio.c	2014-09-30 17:41:31.000000000 +0200
+++ linux-3.17-rc7/drivers/md/dm-bufio.c	2014-09-30 17:41:57.000000000 +0200
@@ -465,6 +465,7 @@ static void __relink_lru(struct dm_buffe
 	c->n_buffers[dirty]++;
 	b->list_mode = dirty;
 	list_move(&b->lru_list, &c->lru[dirty]);
+	b->last_accessed = jiffies;
 }
 
 /*----------------------------------------------------------------
