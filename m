From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-verity: fix coverity warning
Date: Fri, 28 Jun 2013 11:00:44 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1306281100050.16714@file01.intranet.prod.int.rdu2.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-verity: fix coverity warning

Fix a trivial warning issued by coverity.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-3.9.8-fast/drivers/md/dm-verity.c
===================================================================
--- linux-3.9.8-fast.orig/drivers/md/dm-verity.c	2013-06-28 00:55:58.000000000 +0200
+++ linux-3.9.8-fast/drivers/md/dm-verity.c	2013-06-28 00:57:20.000000000 +0200
@@ -695,8 +695,8 @@ static int verity_ctr(struct dm_target *
 		goto bad;
 	}
 
-	if (sscanf(argv[0], "%d%c", &num, &dummy) != 1 ||
-	    num < 0 || num > 1) {
+	if (sscanf(argv[0], "%u%c", &num, &dummy) != 1 ||
+	    num > 1) {
 		ti->error = "Invalid version";
 		r = -EINVAL;
 		goto bad;
