From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] dm: writecache: fix format string warning
Date: Mon, 28 May 2018 17:54:08 +0200
Message-ID: <20180528155432.2864616-1-arnd@arndb.de>
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
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: dm-devel.ids

The return type of ACCESS_ONCE is configuration dependent and may be either
'int' or 'long int' for the writecache_has_error() macro, so we get a warning
like this for either format string:

In file included from drivers/md/dm-writecache.c:8:
drivers/md/dm-writecache.c: In function 'writecache_status':
drivers/md/dm-writecache.c:2227:10: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'int' [-Werror=format=]
   DMEMIT("%ld %llu %llu %llu", writecache_has_error(wc),
          ^~~~~~~~~~~~~~~~~~~~
include/linux/device-mapper.h:549:46: note: in definition of macro 'DMEMIT'
      0 : scnprintf(result + sz, maxlen - sz, x))
                                              ^

The code is otherwise correct, so we just need to shut up the warning,
which can be done using an extra type cast.

Fixes: bb15b431d650 ("dm: add writecache target")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/dm-writecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 1ef06e738eb6..772ac3a57287 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2224,7 +2224,7 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%ld %llu %llu %llu", writecache_has_error(wc),
+		DMEMIT("%ld %llu %llu %llu", (long)writecache_has_error(wc),
 		       (unsigned long long)wc->n_blocks, (unsigned long long)wc->freelist_size,
 		       (unsigned long long)wc->writeback_size);
 		break;
-- 
2.9.0
