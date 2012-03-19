From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm: zero out bi_end_io on remapping failure
Date: Mon, 19 Mar 2012 16:53:46 +0100
Message-ID: <1332172428-35948-2-git-send-email-hare@suse.de>
References: <1332172428-35948-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1332172428-35948-1-git-send-email-hare@suse.de>
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
Cc: Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

To be symmetric we should be setting bi_end_io to NULL when failing
to remap.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b89c548..e24143c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1016,6 +1016,7 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 		/*
 		 * Store bio_set for cleanup.
 		 */
+		clone->bi_end_io = NULL;
 		clone->bi_private = md->bs;
 		bio_put(clone);
 		free_tio(md, tio);
-- 
1.6.0.2
