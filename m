From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-raid: fix default region size
Date: Fri, 2 Oct 2015 11:17:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510021114550.7505@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Jonathan Brassow <jbrassow@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

The commit 3a0f9aaee02857609d79b20c809c02a8b7c39d06 should make sure that
the default region size is a power of two. However, the logic is incorrect
and sets the variable region_size to 0 or 1, depending on whether
min_region_size is a power of two.

This patch fixes the logic, so that region_size is set to min_region_size
rounded up to the next power of two.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 3a0f9aaee028 ("dm raid: round region_size to power of two")
Cc: stable@vger.kernel.org	# v3.8+

---
 drivers/md/dm-raid.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-4.3-rc3/drivers/md/dm-raid.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-raid.c	2015-10-02 15:20:04.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-raid.c	2015-10-02 15:29:34.000000000 +0200
@@ -329,8 +329,7 @@ static int validate_region_size(struct r
 		 */
 		if (min_region_size > (1 << 13)) {
 			/* If not a power of 2, make it the next power of 2 */
-			if (min_region_size & (min_region_size - 1))
-				region_size = 1 << fls(region_size);
+			region_size = roundup_pow_of_two(min_region_size);
 			DMINFO("Choosing default region size of %lu sectors",
 			       region_size);
 		} else {
