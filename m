From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] DEVICE-MAPPER: Use shorter list_splice_init()
	for brevity.
Date: Sun, 23 Mar 2008 10:32:39 -0400 (EDT)
Message-ID: <alpine.LFD.1.00.0803231031110.11428@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Andrew Morton <akpm@osdl.org>
List-Id: dm-devel.ids


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 5160587..e7c4432 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -405,24 +405,21 @@ static void rh_update_states(struct region_hash *rh)
 	write_lock_irq(&rh->hash_lock);
 	spin_lock(&rh->region_lock);
 	if (!list_empty(&rh->clean_regions)) {
-		list_splice(&rh->clean_regions, &clean);
-		INIT_LIST_HEAD(&rh->clean_regions);
+		list_splice_init(&rh->clean_regions, &clean);

 		list_for_each_entry(reg, &clean, list)
 			list_del(&reg->hash_list);
 	}

 	if (!list_empty(&rh->recovered_regions)) {
-		list_splice(&rh->recovered_regions, &recovered);
-		INIT_LIST_HEAD(&rh->recovered_regions);
+		list_splice_init(&rh->recovered_regions, &recovered);

 		list_for_each_entry (reg, &recovered, list)
 			list_del(&reg->hash_list);
 	}

 	if (!list_empty(&rh->failed_recovered_regions)) {
-		list_splice(&rh->failed_recovered_regions, &failed_recovered);
-		INIT_LIST_HEAD(&rh->failed_recovered_regions);
+		list_splice_init(&rh->failed_recovered_regions, &failed_recovered);

 		list_for_each_entry(reg, &failed_recovered, list)
 			list_del(&reg->hash_list);
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
