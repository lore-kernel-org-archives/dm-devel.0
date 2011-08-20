From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm bufio: fix "value computed is not used"
	warnings
Date: Fri, 19 Aug 2011 21:10:33 -0400
Message-ID: <1313802634-15884-1-git-send-email-snitzer@redhat.com>
References: <20110819161745.GA27778@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110819161745.GA27778@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/dm-bufio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 942dc59..4ecb8b8 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -213,7 +213,7 @@ static void cache_size_refresh(void)
 		 * Modify dm_bufio_cache_size to report the real used cache
 		 * size to the user.
 		 */
-		cmpxchg(&dm_bufio_cache_size, 0, dm_bufio_default_cache_size);
+		(void)cmpxchg(&dm_bufio_cache_size, 0, dm_bufio_default_cache_size);
 		dm_bufio_cache_size_latch = dm_bufio_default_cache_size;
 	}
 	dm_bufio_cache_size_per_client = dm_bufio_cache_size_latch /
@@ -841,7 +841,7 @@ static void write_endio(struct bio *bio, int error)
 	b->write_error = error;
 	if (unlikely(error)) {
 		struct dm_bufio_client *c = b->c;
-		cmpxchg(&c->async_write_error, 0, error);
+		(void)cmpxchg(&c->async_write_error, 0, error);
 	}
 	BUG_ON(!test_bit(B_WRITING, &b->state));
 	smp_mb__before_clear_bit();
-- 
1.7.4.4
