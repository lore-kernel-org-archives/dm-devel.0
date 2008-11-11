From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: updated Chandra's patch for dm_any_congested
Date: Mon, 10 Nov 2008 18:17:51 -0800
Message-ID: <1226369871.14830.1186.camel@chandra-ubuntu>
References: <Pine.LNX.4.64.0811101206570.7687@hs20-bc2-1.build.redhat.com>
	<1226338466.5014.29.camel@localhost.localdomain>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1226338466.5014.29.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, mpatocka@redhat.com, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids


Here is an updated version based on James's comments:

From: Chandra Seetharaman <sekharan@us.ibm.com>

dm_any_congested() just checks for the DMF_BLOCK_IO and has no
code to make sure that suspend waits for dm_any_congested() to
complete.  This patch adds such a check.

Without it, a race can occur with dm_table_put() attempting to
destroying the table in the wrong thread, the one running
dm_any_congested() which is meant to be quick and return
immediately.

Two examples of problems:
1. Sleeping functions called from congested code, the caller
   of which holds a spin lock.
2. An ABBA deadlock between pdflush and multipathd. The two locks
   in contention are inode lock and kernel lock.
----------------
Updates from the original patch:
 - Mikulas changed 
	atomic_dec(&md->pending));
   to
	if (!atomic_dec_return(&md->pending))
		wake_up(&md->wait);
 - Chandra changed the code organization to get rid of the goto
   as per James Bottemley' suggestion.
----------------

[AGK: Is the return value always correct when the table is skipped?]

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
--------

Index: linux-2.6.28-rc3/drivers/md/dm.c
===================================================================
--- linux-2.6.28-rc3.orig/drivers/md/dm.c
+++ linux-2.6.28-rc3/drivers/md/dm.c
@@ -937,16 +937,20 @@ static void dm_unplug_all(struct request
 
 static int dm_any_congested(void *congested_data, int bdi_bits)
 {
-	int r;
+	int r = bdi_bits;
 	struct mapped_device *md = (struct mapped_device *) congested_data;
-	struct dm_table *map = dm_get_table(md);
-
-	if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
-		r = bdi_bits;
-	else
-		r = dm_table_any_congested(map, bdi_bits);
+	struct dm_table *map;
 
-	dm_table_put(map);
+	atomic_inc(&md->pending);
+	if (!test_bit(DMF_BLOCK_IO, &md->flags)) {
+		map = dm_get_table(md);
+		if (map) {
+			r = dm_table_any_congested(map, bdi_bits);
+			dm_table_put(map);
+		}
+	}
+	if (!atomic_dec_return(&md->pending))
+		wake_up(&md->wait);
 	return r;
 }
 
