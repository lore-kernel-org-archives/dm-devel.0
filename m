From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] There's no need to include linux/version.h in
 drivers/md/dm-bufio.c
Date: Sun, 15 Jan 2012 21:12:23 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
List-Id: dm-devel.ids

As 'make versioncheck' points out, drivers/md/dm-bufio.c has no need
to include linux/version.h, so this patch removes the unneeded
include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/md/dm-bufio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 0a6806f..b6e58c7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -12,7 +12,6 @@
 #include <linux/dm-io.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/version.h>
 #include <linux/shrinker.h>
 #include <linux/module.h>
 
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
