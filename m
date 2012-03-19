From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-table: simplify call to free_devices()
Date: Mon, 19 Mar 2012 16:53:47 +0100
Message-ID: <1332172428-35948-3-git-send-email-hare@suse.de>
References: <1332172428-35948-1-git-send-email-hare@suse.de>
	<1332172428-35948-2-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1332172428-35948-2-git-send-email-hare@suse.de>
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

free_devices already uses list_for_each(), so we don't need to
check if the list is empty.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-table.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 63cc542..a3d1e18 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -268,8 +268,7 @@ void dm_table_destroy(struct dm_table *t)
 	vfree(t->highs);
 
 	/* free the device list */
-	if (t->devices.next != &t->devices)
-		free_devices(&t->devices);
+	free_devices(&t->devices);
 
 	dm_free_md_mempools(t->mempools);
 
-- 
1.6.0.2
