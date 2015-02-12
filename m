From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-mirror: do not degrade the mirror on discard
	error
Date: Thu, 12 Feb 2015 10:09:20 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502121007010.24282@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Heinz Mauelshagen <heinzm@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

It may be possible that a device claims discard support but it rejects
discards with -EOPNOTSUPP. It happens when using loopback on ext2/ext3
filesystem driven by the ext4 driver. It may also happen if the underlying
devices are moved from one disk on another.

If discard error happens, we reject the bio with -EOPNOTSUPP, but we do
not degrade the array.

This patch fixes failed test shell/lvconvert-repair-transient.sh in the
lvm2 testsuite if the testsuite is extracted on an ext2 or ext3 filesystem
and it is being driven by the ext4 driver.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c
+++ linux-2.6/drivers/md/dm-raid1.c
@@ -604,6 +604,15 @@ static void write_callback(unsigned long
 		return;
 	}
 
+	/*
+	 * If the bio is discard, return an error, but do not
+	 * degrade the array.
+	 */
+	if (bio->bi_rw & REQ_DISCARD) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return;
+	}
+
 	for (i = 0; i < ms->nr_mirrors; i++)
 		if (test_bit(i, &error))
 			fail_mirror(ms->mirror + i, DM_RAID1_WRITE_ERROR);
