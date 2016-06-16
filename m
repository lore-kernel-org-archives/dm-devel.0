From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] dm raid: don't use 'const' in function return
Date: Thu, 16 Jun 2016 11:03:25 +0200
Message-ID: <20160616090359.984712-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

A newly introduced function has 'const int' as the return type,
but as "make W=1" reports, that has no meaning:

drivers/md/dm-raid.c:510:18: error: type qualifiers ignored on function return type [-Werror=ignored-qualifiers]

This changes the return type to plain 'int'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 96bcff7a0b94..55d25ac87bda 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -507,7 +507,7 @@ static const char *raid10_md_layout_to_format(int layout)
 }
 
 /* Return md raid10 algorithm for @name */
-static const int raid10_name_to_format(const char *name)
+static int raid10_name_to_format(const char *name)
 {
 	if (!strcasecmp(name, "near"))
 		return ALGORITHM_RAID10_NEAR;
-- 
2.9.0
