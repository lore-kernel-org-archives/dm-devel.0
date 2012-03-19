From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: Track invalid map_context
Date: Mon, 19 Mar 2012 16:15:28 +0100
Message-ID: <1332170128-30232-1-git-send-email-hare@suse.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <akg@redhat.com>
List-Id: dm-devel.ids

The map_context pointer should always be set. However, we
have reports that upon requeing it is not set correctly.
So add a BUG_ON() statement and clear the pointer to
track the issue properly.

Cc: Alasdair Kergon <akg@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Dave Wysochanski <dwysocha@redhat.com>
---
 drivers/md/dm-mpath.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 801d92d..94a91d6 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 	map_context->ptr = mpio;
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	r = map_io(m, clone, mpio, 0);
-	if (r < 0 || r == DM_MAPIO_REQUEUE)
+	if (r < 0 || r == DM_MAPIO_REQUEUE) {
 		mempool_free(mpio, m->mpio_pool);
+		map_context->ptr = NULL;
+	}
 
 	return r;
 }
@@ -1228,6 +1230,8 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	int r = DM_ENDIO_REQUEUE;
 	unsigned long flags;
 
+	BUG_ON(!mpio);
+
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-- 
1.6.0.2
