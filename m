From: Jan Blunck <jblunck@suse.de>
Subject: [patch 02/11] dm-snap: Replace special round_up()
Date: Fri, 10 Aug 2007 22:02:06 +0200
Message-ID: <20285.3155126379$1186776753@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-snap-remove-round_up.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch replaces the special round_up() implementation used in the snapshot
target. The code is not very performance critical so I think it is not worth
having a special variant here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-snap.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -371,16 +371,6 @@ static int init_hash_tables(struct dm_sn
 	return 0;
 }
 
-/*
- * Round a number up to the nearest 'size' boundary.  size must
- * be a power of 2.
- */
-static ulong round_up(ulong n, ulong size)
-{
-	size--;
-	return (n + size) & ~size;
-}
-
 static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
 			  char **error)
 {
@@ -402,7 +392,7 @@ static int set_chunk_size(struct dm_snap
 	 * Chunk size must be multiple of page size.  Silently
 	 * round up if it's not.
 	 */
-	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
+	chunk_size = roundup(chunk_size, PAGE_SIZE >> 9);
 
 	/* Check chunk_size is a power of 2 */
 	if (chunk_size & (chunk_size - 1)) {

-- 
