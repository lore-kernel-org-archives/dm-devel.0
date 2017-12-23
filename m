From: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Subject: [PATCH 1/2] dm bufio: add missed destroy of client's
	mutex
Date: Sat, 23 Dec 2017 13:27:03 +0300
Message-ID: <20171223102704.3087-1-akaraliou.dev@gmail.com>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, Aliaksei Karaliou <akaraliou.dev@gmail.com>
List-Id: dm-devel.ids

dm_bufio_client_destroy() does not destroy dm_bufio_client->lock.
dm_bufio_client_create() does not do that on fallback path too.

Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>
---
 drivers/md/dm-bufio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index c546b567f3b5..1c661d4c211c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1767,6 +1767,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	}
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
+	mutex_destroy(&c->lock);
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
@@ -1811,6 +1812,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 		BUG_ON(c->n_buffers[i]);
 
 	dm_io_client_destroy(c->dm_io);
+	mutex_destroy(&c->lock);
 	kfree(c);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_client_destroy);
-- 
2.11.0
