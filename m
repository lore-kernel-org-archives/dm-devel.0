From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] dm raid: don't use 'const' in function return
Date: Fri, 22 Jun 2018 10:01:19 +0200
Message-ID: <20180622080119.16970-1-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: dm-devel.ids

From: Arnd Bergmann <arnd@arndb.de>

A newly introduced function has 'const int' as the return type,
but as "make W=1" reports, that has no meaning:

drivers/md/dm-raid.c:510:18: error: type qualifiers ignored on function return type [-Werror=ignored-qualifiers]

This changes the return type to plain 'int'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Fixes: 552aa679f2657431 ("dm raid: use rs_is_raid*()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Cherry-picked from 68c1c4d5eafc65dd ("dm raid: don't use 'const' in
function return") with new Fixes tag, as the issue has been
reintroduced.
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ab13fcec3fca046c..75df4c9d8b541de4 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -588,7 +588,7 @@ static const char *raid10_md_layout_to_format(int layout)
 }
 
 /* Return md raid10 algorithm for @name */
-static const int raid10_name_to_format(const char *name)
+static int raid10_name_to_format(const char *name)
 {
 	if (!strcasecmp(name, "near"))
 		return ALGORITHM_RAID10_NEAR;
-- 
2.17.1
