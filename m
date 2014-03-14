From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/6] dm: remove num_write_bios
Date: Fri, 14 Mar 2014 18:43:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403141843120.31047@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141841290.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141842170.31047@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1403141842170.31047@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The target can set the function num_write_bios - dm will issue this
callback to ask the target how many bios does it want to receive.

This was intended for the dm-cache target, but it is not useable due to a
race condition (see the description of
e2e74d617eadc15f601983270c4f4a6935c5a943). num_write_bios is unused, so we
remove it.

Note that we deliberately leave the for loop in __clone_and_map_data_bio -
it will be used in the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c               |    6 ------
 include/linux/device-mapper.h |   15 ---------------
 2 files changed, 21 deletions(-)

Index: linux-3.14-rc6/drivers/md/dm.c
===================================================================
--- linux-3.14-rc6.orig/drivers/md/dm.c	2014-03-14 22:02:31.000000000 +0100
+++ linux-3.14-rc6/drivers/md/dm.c	2014-03-14 22:04:39.000000000 +0100
@@ -1282,12 +1282,6 @@ static void __clone_and_map_data_bio(str
 	unsigned target_bio_nr;
 	unsigned num_target_bios = 1;
 
-	/*
-	 * Does the target want to receive duplicate copies of the bio?
-	 */
-	if (bio_data_dir(bio) == WRITE && ti->num_write_bios)
-		num_target_bios = ti->num_write_bios(ti, bio);
-
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
 		tio = alloc_tio(ci, ti, 0, target_bio_nr);
 		tio->len_ptr = len;
Index: linux-3.14-rc6/include/linux/device-mapper.h
===================================================================
--- linux-3.14-rc6.orig/include/linux/device-mapper.h	2014-03-14 22:02:05.000000000 +0100
+++ linux-3.14-rc6/include/linux/device-mapper.h	2014-03-14 22:02:21.000000000 +0100
@@ -190,14 +190,6 @@ struct target_type {
 #define DM_TARGET_IMMUTABLE		0x00000004
 #define dm_target_is_immutable(type)	((type)->features & DM_TARGET_IMMUTABLE)
 
-/*
- * Some targets need to be sent the same WRITE bio severals times so
- * that they can send copies of it to different devices.  This function
- * examines any supplied bio and returns the number of copies of it the
- * target requires.
- */
-typedef unsigned (*dm_num_write_bios_fn) (struct dm_target *ti, struct bio *bio);
-
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
@@ -237,13 +229,6 @@ struct dm_target {
 	 */
 	unsigned per_bio_data_size;
 
-	/*
-	 * If defined, this function is called to find out how many
-	 * duplicate bios should be sent to the target when writing
-	 * data.
-	 */
-	dm_num_write_bios_fn num_write_bios;
-
 	/* target specific data */
 	void *private;
 
