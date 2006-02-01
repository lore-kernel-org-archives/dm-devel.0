From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [Patch] dm-log.c: Use ext2_find_next_zero_bit()
Date: Wed, 01 Feb 2006 17:54:57 +0100
Message-ID: <43E0E7E1.6050400@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050109070506030906010802"
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050109070506030906010802
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch will replace the find_next_zero_bit function with the
appropriate ext2 counterpart. Without this on 64 bit BE machines the
mirror target will try to recover regions beyond the end of device.

Regards,
Stefan


--------------050109070506030906010802
Content-Type: text/plain;
 name="dm-log-fix-synccount-be64.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-log-fix-synccount-be64.patch"

From: Stefan Bader <shbader@de.ibm.com>

This is an addition to the endian fixes that introduce ext2_* versions
of the set and clear bit functions. The find_next_zero_bit also has to
be the ext2 one. Otherwise the mirror target tries to recover non-existent
regions beyond the end of device.

Signed-Off-By: Stefan Bader <shbader@de.ibm.com>

diff -Nurp linux-2.6.15/drivers/md/dm-log.c linux-2.6.15-fix/drivers/md/dm-log.c
--- linux-2.6.15/drivers/md/dm-log.c	2006-02-01 16:43:32.707368696 +0100
+++ linux-2.6.15-fix/drivers/md/dm-log.c	2006-02-01 16:48:40.344639085 +0100
@@ -545,7 +545,8 @@ static int core_get_resync_work(struct d
 		return 0;
 
 	do {
-		*region = find_next_zero_bit((unsigned long *) lc->sync_bits,
+		*region = ext2_find_next_zero_bit(
+					     (unsigned long *) lc->sync_bits,
 					     lc->region_count,
 					     lc->sync_search);
 		lc->sync_search = *region + 1;


--------------050109070506030906010802
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050109070506030906010802--
