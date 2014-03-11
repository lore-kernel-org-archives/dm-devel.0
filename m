From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] dm: era: use do_div for 64-bit division
Date: Tue, 11 Mar 2014 09:31:33 +0100
Message-ID: <3014967.i7OXqBNQ5E@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Commit 983043be0c1de "dm era: support non power-of-2 blocksize"
introduced the use of sector_div to divide a variable of type
dm_block_t by an integer. This fails on 32-bit machines when
CONFIG_LBDAF is not set, because that assumes that the first
argument is a 32-bit number.

To allow building this driver in all configurations, we either
have to cast the dm_block_t to sector_t or use do_div(), which
always takes a 64-bit argument. This patch uses the second
approach in order to cope with theoretical configurations where
dm_block_t contains a number that does not fit into sector_t.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
This currently only occurs in linux-next. Please apply.

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index d7bd7b3..3383423 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1123,7 +1123,7 @@ static dm_block_t get_block(struct era *era, struct bio *bio)
 	dm_block_t block_nr = bio->bi_iter.bi_sector;
 
 	if (!block_size_is_power_of_two(era))
-		(void) sector_div(block_nr, era->sectors_per_block);
+		(void) do_div(block_nr, era->sectors_per_block);
 	else
 		block_nr >>= era->sectors_per_block_shift;
 
