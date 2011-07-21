From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] dm: fix dm-flakey printk warning
Date: Thu, 21 Jul 2011 16:10:47 -0700
Message-ID: <20110721161047.8a62d89a.rdunlap@xenotime.net>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning for sector_t, which can be (unsigned)
long or long long.

drivers/md/dm-flakey.c:257: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'sector_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/md/dm-flakey.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20110721.orig/drivers/md/dm-flakey.c
+++ linux-next-20110721/drivers/md/dm-flakey.c
@@ -255,10 +255,11 @@ static void corrupt_bio_data(struct bio 
 		data[fc->corrupt_bio_byte - 1] = fc->corrupt_bio_value;
 
 		DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
-			"(rw=%c bi_rw=%lu bi_sector=%lu cur_bytes=%u)\n",
+			"(rw=%c bi_rw=%lu bi_sector=%llu cur_bytes=%u)\n",
 			bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
 			(bio_data_dir(bio) == WRITE) ? 'w' : 'r',
-			bio->bi_rw, bio->bi_sector, bio_bytes);
+			bio->bi_rw, (unsigned long long)bio->bi_sector,
+			bio_bytes);
 	}
 }
 
