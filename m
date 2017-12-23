From: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Subject: [PATCH 2/2] dm bufio: check result of register_shrinker()
Date: Sat, 23 Dec 2017 13:27:04 +0300
Message-ID: <20171223102704.3087-2-akaraliou.dev@gmail.com>
References: <20171223102704.3087-1-akaraliou.dev@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171223102704.3087-1-akaraliou.dev@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, Aliaksei Karaliou <akaraliou.dev@gmail.com>
List-Id: dm-devel.ids

dm_bufio_client_create() does not check result of register_shrinker()
which was tagged as __must_check recently, reported by sparse.

Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>
---
 drivers/md/dm-bufio.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 1c661d4c211c..8f3ccf88951e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1743,20 +1743,23 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		__free_buffer_wake(b);
 	}
 
+	c->shrinker.count_objects = dm_bufio_shrink_count;
+	c->shrinker.scan_objects = dm_bufio_shrink_scan;
+	c->shrinker.seeks = 1;
+	c->shrinker.batch = 0;
+	r = register_shrinker(&c->shrinker);
+	if (r)
+		goto bad_shrinker;
+
 	mutex_lock(&dm_bufio_clients_lock);
 	dm_bufio_client_count++;
 	list_add(&c->client_list, &dm_bufio_all_clients);
 	__cache_size_refresh();
 	mutex_unlock(&dm_bufio_clients_lock);
 
-	c->shrinker.count_objects = dm_bufio_shrink_count;
-	c->shrinker.scan_objects = dm_bufio_shrink_scan;
-	c->shrinker.seeks = 1;
-	c->shrinker.batch = 0;
-	register_shrinker(&c->shrinker);
-
 	return c;
 
+bad_shrinker:
 bad_buffer:
 bad_cache:
 	while (!list_empty(&c->reserved_buffers)) {
-- 
2.11.0
