From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-raid: suppress uninitialized variable warning
Date: Thu, 21 Mar 2013 17:32:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1303211722150.31035@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, neilb@suse.de, dm-devel@redhat.com
List-Id: dm-devel.ids

dm-raid: suppress uninitialized variable warning

This patch suppresses this warning:

drivers/md/dm-raid.c: In function 'raid_ctr':
drivers/md/dm-raid.c:427:54: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here

The warning doesn't represent a real bug (rebuilds_per_group is always
initialized in the first iteration of a loop), but gcc can't deduce it.

This patch should be backported to 3.8. It doesn't have to be backported 
to 3.7 and below because they don't have the problem with this varning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.9-rc3-fast/drivers/md/dm-raid.c
===================================================================
--- linux-3.9-rc3-fast.orig/drivers/md/dm-raid.c	2013-03-21 22:16:42.000000000 +0100
+++ linux-3.9-rc3-fast/drivers/md/dm-raid.c	2013-03-21 22:17:05.000000000 +0100
@@ -380,7 +380,7 @@ static int validate_region_size(struct r
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned i, rebuild_cnt = 0;
-	unsigned rebuilds_per_group, copies, d;
+	unsigned uninitialized_var(rebuilds_per_group), copies, d;
 	unsigned group_size, last_group_start;
 
 	for (i = 0; i < rs->md.raid_disks; i++)
