From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: fix possible mempool deadlock
Date: Sun, 15 Jan 2012 17:24:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201151723540.26479@hs20-bc2-1.build.redhat.com>
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
To: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-crypt: fix possible mempool deadlock

This patch fixes a possible deadlock in mempool in dm-crypt.

Currently, dm-crypt reserves a mempool of MIN_BIO_PAGES reserved pages.
It allocates first MIN_BIO_PAGES with non-failing allocation (the allocation
cannot fail and waits until the mempool is refilled). Further pages are
allocated with different gfp flags that allow failing.

Because allocations may be done in parallel, this code can deadlock. Example:
There are two processes, each tries to allocate MIN_BIO_PAGES and the processes
run simultaneously.
It may end up in a situation where each process allocates (MIN_BIO_PAGES / 2)
pages. The mempool is exhausted. Each process waits for more pages to be freed
to the mempool, which never happens.

To avoid this deadlock scenario, this patch changes the code so that only
the first page is allocated with non-failing gfp mask. Allocation of further
pages may fail.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-3.2-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-3.2-fast.orig/drivers/md/dm-crypt.c	2012-01-15 22:39:47.000000000 +0100
+++ linux-3.2-fast/drivers/md/dm-crypt.c	2012-01-15 22:40:31.000000000 +0100
@@ -852,8 +852,7 @@ static struct bio *crypt_alloc_buffer(st
 		 * return a partially allocated bio, the caller will then try
 		 * to allocate additional bios while submitting this partial bio
 		 */
-		if (i == (MIN_BIO_PAGES - 1))
-			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
+		gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
 
