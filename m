From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-snap: remove unused definitions
Date: Wed, 8 Jun 2011 17:56:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106081755510.7811@hs20-bc2-1.build.redhat.com>
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

dm-snap: remove unused definitions

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-snap.c	2011-06-08 15:39:23.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-snap.c	2011-06-08 15:39:39.000000000 +0200
@@ -30,16 +30,6 @@ static const char dm_snapshot_merge_targ
 	((ti)->type->name == dm_snapshot_merge_target_name)
 
 /*
- * The percentage increment we will wake up users at
- */
-#define WAKE_UP_PERCENT 5
-
-/*
- * kcopyd priority of snapshot operations
- */
-#define SNAPSHOT_COPY_PRIORITY 2
-
-/*
  * The size of the mempool used to track chunks in use.
  */
 #define MIN_IOS 256
