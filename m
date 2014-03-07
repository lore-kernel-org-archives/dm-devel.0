From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: randconfig build error with next-20140307, in
 drivers/md/dm-era-target.c
Date: Fri, 7 Mar 2014 08:52:02 -0500
Message-ID: <20140307135202.GA31136@redhat.com>
References: <CA+r1ZhiRiT-fQz9-QYAPaq9CBwUQMtHy2HpDg2nmbsqeU05yyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+r1ZhiRiT-fQz9-QYAPaq9CBwUQMtHy2HpDg2nmbsqeU05yyA@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 07 2014 at  6:57am -0500,
Jim Davis <jim.epost@gmail.com> wrote:

> Building with the attached random configuration file,
> 
>   LD      init/built-in.o
> drivers/built-in.o: In function `do_work':
> dm-era-target.c:(.text+0x7304ea): undefined reference to `__udivdi3'
> drivers/built-in.o: In function `era_map':
> dm-era-target.c:(.text+0x730759): undefined reference to `__udivdi3'
> make: *** [vmlinux] Error 1

Thanks for the report.  This patch will fix it (I'll fold it into the
"dm era: support non power-of-2 blocksize" commit now):

From 342553076366eac8b1718488045f710cd935636f Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 7 Mar 2014 08:47:56 -0500
Subject: [PATCH] dm era: fix 64 bit divide on 32 bit

  LD      init/built-in.o
drivers/built-in.o: In function `do_work':
dm-era-target.c:(.text+0x7304ea): undefined reference to `__udivdi3'
drivers/built-in.o: In function `era_map':
dm-era-target.c:(.text+0x730759): undefined reference to `__udivdi3'
make: *** [vmlinux] Error 1
---
 drivers/md/dm-era-target.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index d7bd7b3..3a72206 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1120,7 +1120,7 @@ static bool block_size_is_power_of_two(struct era *era)
 
 static dm_block_t get_block(struct era *era, struct bio *bio)
 {
-	dm_block_t block_nr = bio->bi_iter.bi_sector;
+	sector_t block_nr = bio->bi_iter.bi_sector;
 
 	if (!block_size_is_power_of_two(era))
 		(void) sector_div(block_nr, era->sectors_per_block);
-- 
1.7.1
