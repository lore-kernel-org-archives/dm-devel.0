From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH v2] dm-crypt: fix possible mempool deadlock
Date: Mon, 19 Mar 2012 13:01:30 +0100
Message-ID: <1332158490-13130-1-git-send-email-mbroz@redhat.com>
References: <Pine.LNX.4.64.1201151723540.26479@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1201151723540.26479@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

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
Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8c2a000..72eb06f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -176,7 +176,6 @@ struct crypt_config {
 
 #define MIN_IOS        16
 #define MIN_POOL_PAGES 32
-#define MIN_BIO_PAGES  8
 
 static struct kmem_cache *_crypt_io_pool;
 
@@ -852,8 +851,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size,
 		 * return a partially allocated bio, the caller will then try
 		 * to allocate additional bios while submitting this partial bio
 		 */
-		if (i == (MIN_BIO_PAGES - 1))
-			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
+		gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
 
-- 
1.7.9.1
