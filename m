From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: Clear map_context pointer when
	requeuing
Date: Wed, 30 Nov 2011 15:25:18 +0100
Message-ID: <1322663118-53387-1-git-send-email-hare__49283.5031044253$1322664209$gmane$org@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20111130144110.GA13739@redhat.com>
Resent-To: dm-devel@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, James Bottomley <jbottomley@parallels.com>
List-Id: dm-devel.ids

When requeing a request we should be clearing the map_context
pointer, otherwise we might access an invalid memory location.

Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/md/dm-mpath.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5e0090e..e6fad46 100644
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
-- 
1.6.0.2
