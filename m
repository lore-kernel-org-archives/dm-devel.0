From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] md: Fix "strchr" [drivers/md/dm-log-userspace.ko]
 undefined!
Date: Thu, 10 Sep 2009 23:13:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0909102311520.10463@ayla.of.borg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@linux-foundation.org>, Linux/m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Commit b8313b6da7e2e7c7f47d93d8561969a3ff9ba0ea ("dm log: remove incorrect
field from userspace table output") added a call to strstr() with a
single-character "needle" string parameter.
Unfortunately some versions of gcc replace such calls to strstr() by calls
to strchr() behind our back.  This causes linking errors if strchr() is
defined as an inline function in <asm/string.h> (e.g. on m68k):

| WARNING: "strchr" [drivers/md/dm-log-userspace.ko] undefined!

Avoid this by explicitly calling strchr() instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@kernel.org
---
This fixes a regression introduced in 2.6.31-rc9, and detected by m68k
allmodconfig, cfr. http://kisskb.ellerman.id.au/kisskb/config/164/

 drivers/md/dm-log-userspace-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 6e186b1..652bd33 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -582,7 +582,7 @@ static int userspace_status(struct dm_dirty_log *log, status_type_t status_type,
 		break;
 	case STATUSTYPE_TABLE:
 		sz = 0;
-		table_args = strstr(lc->usr_argv_str, " ");
+		table_args = strchr(lc->usr_argv_str, ' ');
 		BUG_ON(!table_args); /* There will always be a ' ' */
 		table_args++;
 
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
