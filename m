From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] shmfs: don't allocate pages on read
Date: Tue, 21 Jul 2020 05:12:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007210510230.6959@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-396230313-1595322775=:6959"
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
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-396230313-1595322775=:6959
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

Hi

Do we still need the patch a0ee5ec520ede?

We are using the loop device for testing and when we read something from 
the loop device, it allocates the pages on the underlying shmfs 
filesystem. See this example:

# mkdir -p /mnt/test
# mount -t tmpfs /dev/null /mnt/test
# cd /mnt/test
# truncate -s 1GiB file
# du -hs file
0       file
# losetup /dev/loop0 file
# du -hs file
1,1M    file
# dd if=/dev/loop0 of=/dev/null
2097152+0 záznamů přečteno
2097152+0 záznamů zapsáno
1073741824 bajtů (1,1 GB, 1,0 GiB) zkopírováno, 4,06865 s, 264 MB/s
# du -hs file
1,0G    file

This patch turns off the allocation on read.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/shmem.c |    8 --------
 1 file changed, 8 deletions(-)

Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2020-06-29 14:50:06.000000000 +0200
+++ linux-2.6/mm/shmem.c	2020-07-16 19:22:58.000000000 +0200
@@ -2507,14 +2507,6 @@ static ssize_t shmem_file_read_iter(stru
 	ssize_t retval = 0;
 	loff_t *ppos = &iocb->ki_pos;
 
-	/*
-	 * Might this read be for a stacking filesystem?  Then when reading
-	 * holes of a sparse file, we actually need to allocate those pages,
-	 * and even mark them dirty, so it cannot exceed the max_blocks limit.
-	 */
-	if (!iter_is_iovec(to))
-		sgp = SGP_CACHE;
-
 	index = *ppos >> PAGE_SHIFT;
 	offset = *ppos & ~PAGE_MASK;
 
--185206533-396230313-1595322775=:6959
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--185206533-396230313-1595322775=:6959--
