From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] Clear the discard flag if the device loses
 discard capability
Date: Fri, 2 Jul 2010 11:18:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Clear the discard flag if the device loses discard capability
because of table reload.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35-rc3-fast/drivers/md/dm-table.c
===================================================================
--- linux-2.6.35-rc3-fast.orig/drivers/md/dm-table.c	2010-07-02 16:04:36.000000000 +0200
+++ linux-2.6.35-rc3-fast/drivers/md/dm-table.c	2010-07-02 16:07:49.000000000 +0200
@@ -1098,7 +1098,9 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
-	if (dm_table_supports_discards(t))
+	if (!dm_table_supports_discards(t))
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
+	else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 
 	dm_table_set_integrity(t);
