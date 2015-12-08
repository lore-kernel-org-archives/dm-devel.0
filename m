From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] dm verity: use sector_div for division
Date: Tue, 08 Dec 2015 16:42:12 +0100
Message-ID: <2666833.eM84rj4CYY@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

The dm verity sec implementation uses do_div for dividing a sector_t,
which is slower than necessary when sector_t is a 32-bit type, and
we now get a warning for this case:

include/asm-generic/div64.h:224:22: warning: passing argument 1 of '__div64_32' from incompatible pointer type [-Wincompatible-pointer-types]
drivers/md/dm-verity-fec.c:725:6: note: in expansion of macro 'do_div'
  if (do_div(f->rounds, f->rsn))

This changes the code to use sector_div instead, which does the
right thing and avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/dm-verity-fec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I believe we had a fix for this in the series that introduced the optimized
do_div, but the file got moved around and the fix got lost.

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index e722ce57520f..1bddaca37e98 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -722,7 +722,7 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	f->rounds = f->blocks;
-	if (do_div(f->rounds, f->rsn))
+	if (sector_div(f->rounds, f->rsn))
 		f->rounds++;
 
 	/*
-- 
2.1.0.rc2
