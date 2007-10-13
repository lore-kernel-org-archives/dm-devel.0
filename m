From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 5/8] dm: emc_endio returns void
Date: Sat, 13 Oct 2007 14:31:28 +0200
Message-ID: <20071013123413.662203144@mail.of.borg>
References: <20071013123123.085686856@mail.of.borg>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760125AbXJMMf6@vger.kernel.org>
Content-Disposition: inline; filename=dm-emc_endio-returns-void.diff
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

emc_endio returns void:
linux/drivers/md/dm-emc.c: In function 'emc_endio':
linux/drivers/md/dm-emc.c:58: warning: 'return' with a value, in function returning void

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/dm-emc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/md/dm-emc.c
+++ b/drivers/md/dm-emc.c
@@ -54,8 +54,6 @@ static void emc_endio(struct bio *bio, i
 
 	/* request is freed in block layer */
 	free_bio(bio);
-
-	return 0;
 }
 
 static struct bio *get_failover_bio(struct dm_path *path, unsigned data_size)

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
