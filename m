From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: avoid a possible deadlock due to lock
	ordering
Date: Sun, 30 Apr 2017 17:33:26 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1704301732290.25063@file01.intranet.prod.int.rdu2.redhat.com>
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

The function __get_memory_limit tests if dm_bufio_cache_size changed and
calls __cache_size_refresh if it did. It takes dm_bufio_clients_lock while
it already holds the client lock. However, lock ordering is violated
because in the function cleanup_old_buffers dm_bufio_clients_lock is taken
before the client lock.

This results in a possible deadlock and lockdep engine warning.

This patch fixes the deadlock by changing mutex_lock to mutex_trylock. If
the lock can't be taken, it will be re-checked next time when a new buffer
is be allocated. The patch also adds "unlikely" to the if confition, so
that the optimizer assumes that the condition is false.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -959,10 +959,11 @@ static void __get_memory_limit(struct dm
 {
 	unsigned long buffers;
 
-	if (ACCESS_ONCE(dm_bufio_cache_size) != dm_bufio_cache_size_latch) {
-		mutex_lock(&dm_bufio_clients_lock);
-		__cache_size_refresh();
-		mutex_unlock(&dm_bufio_clients_lock);
+	if (unlikely(ACCESS_ONCE(dm_bufio_cache_size) != dm_bufio_cache_size_latch)) {
+		if (mutex_trylock(&dm_bufio_clients_lock)) {
+			__cache_size_refresh();
+			mutex_unlock(&dm_bufio_clients_lock);
+		}
 	}
 
 	buffers = dm_bufio_cache_size_per_client >>
