From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-snapshot: flush disk cache when merging
Date: Wed, 8 Jun 2011 18:02:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106081801550.7811@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm-snapshot: flush disk cache when merging

This patch makes dm-snapshot flush disk cache when writing metadata for
merging snapshot.

Without cache flushing the disk may reorder metadata write and other
data writes and there is a possibility of data corruption in case of
power fault.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.39-fast/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-snap-persistent.c	2011-06-08 23:56:49.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-snap-persistent.c	2011-06-08 23:59:05.000000000 +0200
@@ -753,7 +753,7 @@ static int persistent_commit_merge(struc
 	for (i = 0; i < nr_merged; i++)
 		clear_exception(ps, ps->current_committed - 1 - i);
 
-	r = area_io(ps, WRITE);
+	r = area_io(ps, WRITE_FLUSH_FUA);
 	if (r < 0)
 		return r;
 
