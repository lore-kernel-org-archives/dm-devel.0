From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: change __GFP_IO to __GFP_FS in
 shrinker callbacks
Date: Thu, 16 Oct 2014 14:45:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410161443130.28500@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Zdenek Kabelac <zkabelac@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This supposedly fixes the loop and dm-bufio deadlock observed by Zdenek. 
The deadlock is not reproducible. There are many other loop-based 
deadlocks in the kernel.

Mikulas



From: mpatocka@redhat.com

The shrinker uses gfp flags to indicate what kind of operation can the
driver wait for. If __GFP_IO flag is present, the driver can wait for
block I/O operations, if __GFP_FS flag is present, the driver can wait on
operations involving the filesystem.

dm-bufio tested for __GFP_IO. However, dm-bufio can run on a loop block
device that makes calls into the filesystem. If __GFP_IO is present and
__GFP_FS isn't, dm-bufio could still block on filesystem operations if it
runs on a loop block device.

The change from __GFP_IO to __GFP_FS supposedly fixes one observed (though
unreproducible) deadlock involving dm-bufio and loop device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-3.17/drivers/md/dm-bufio.c
===================================================================
--- linux-3.17.orig/drivers/md/dm-bufio.c	2014-10-16 16:57:26.000000000 +0200
+++ linux-3.17/drivers/md/dm-bufio.c	2014-10-16 16:57:35.000000000 +0200
@@ -1491,7 +1491,7 @@ static int __cleanup_old_buffer(struct d
 	if (jiffies - b->last_accessed < max_jiffies)
 		return 0;
 
-	if (!(gfp & __GFP_IO)) {
+	if (!(gfp & __GFP_FS)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
@@ -1533,7 +1533,7 @@ dm_bufio_shrink_scan(struct shrinker *sh
 	unsigned long freed;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_IO)
+	if (sc->gfp_mask & __GFP_FS)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
 		return SHRINK_STOP;
@@ -1550,7 +1550,7 @@ dm_bufio_shrink_count(struct shrinker *s
 	unsigned long count;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_IO)
+	if (sc->gfp_mask & __GFP_FS)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
 		return 0;
