From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-io: reserve just one bioset structure
Date: Thu, 19 May 2011 12:57:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105191257030.17915@hs20-bc2-1.build.redhat.com>
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

dm-io: reserve just one bioset structure

The number 16 was "magic" and meaningless. This patch changes it to reserve just
one "struct bio", which is the minimum required.

If there is no memory pressure, the code can allocate arbitrary number of bios.

If there is memory pressure, the code can allocate just one bio. The code in
"do_region" contains a loop, it allocates a bio, fills it and submits it. If we
have just one bio available, the code wouldn't deadlock, it would just wait
with the allocation of next bio until the previous bio finished.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.39-rc7-fast/drivers/md/dm-io.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-io.c	2011-05-18 20:51:32.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-io.c	2011-05-18 20:51:37.000000000 +0200
@@ -57,7 +57,7 @@ struct dm_io_client *dm_io_client_create
 	if (!client->pool)
 		goto bad;
 
-	client->bios = bioset_create(16, 0);
+	client->bios = bioset_create(1, 0);
 	if (!client->bios)
 		goto bad;
 
