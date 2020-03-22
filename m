From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/7] dm-integrity: dont replay journal data past
	the end of the device
Date: Sun, 22 Mar 2020 20:42:23 +0100
Message-ID: <20200322194422.575390680@debian-a64.vm>
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
Content-Disposition: inline;
	filename=dm-integrity-dont-replay-past-the-end-of-device.patch
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

The following patches make it possible to shrink or extend the device. If
the device was shrunk, we don't want to replay journal data pointing past
the end of the device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-03-09 15:44:41.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-03-09 15:44:41.000000000 +0100
@@ -2193,6 +2193,8 @@ static void do_journal_write(struct dm_i
 					sec &= ~(sector_t)(ic->sectors_per_block - 1);
 				}
 			}
+			if (unlikely(sec >= ic->provided_data_sectors))
+				continue;
 			get_area_and_offset(ic, sec, &area, &offset);
 			restore_last_bytes(ic, access_journal_data(ic, i, j), je);
 			for (k = j + 1; k < ic->journal_section_entries; k++) {
@@ -2202,6 +2204,8 @@ static void do_journal_write(struct dm_i
 					break;
 				BUG_ON(unlikely(journal_entry_is_inprogress(je2)) && !from_replay);
 				sec2 = journal_entry_get_sector(je2);
+				if (unlikely(sec2 >= ic->provided_data_sectors))
+					break;
 				get_area_and_offset(ic, sec2, &area2, &offset2);
 				if (area2 != area || offset2 != offset + ((k - j) << ic->sb->log2_sectors_per_block))
 					break;
