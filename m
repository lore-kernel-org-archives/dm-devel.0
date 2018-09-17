From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] dm raid: Remove bogus const from decipher_sync_action() return type
Date: Mon, 17 Sep 2018 10:02:34 +0200
Message-ID: <20180917080234.10909-1-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: dm-devel.ids

With gcc-4.1.2:

    drivers/md/dm-raid.c:3357: warning: type qualifiers ignored on function return type

Remove the "const" keyword to fix this.

Fixes: 36a240a706d43383 ("dm raid: fix RAID leg rebuild errors")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5ba067fa0c729bc8..c44925e4e4813d24 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3353,7 +3353,7 @@ static const char *sync_str(enum sync_state state)
 };
 
 /* Return enum sync_state for @mddev derived from @recovery flags */
-static const enum sync_state decipher_sync_action(struct mddev *mddev, unsigned long recovery)
+static enum sync_state decipher_sync_action(struct mddev *mddev, unsigned long recovery)
 {
 	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
 		return st_frozen;
-- 
2.17.1
