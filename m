From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] dm dust: Convert an 'else if' into an 'else' in dust_map
Date: Mon, 29 Apr 2019 19:10:10 -0700
Message-ID: <20190430021010.25151-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: dm-devel.ids

When building with -Wsometimes-uninitialized, Clang warns:

drivers/md/dm-dust.c:216:11: warning: variable 'ret' is used
uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
        else if (bio_data_dir(bio) == WRITE)
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/bio.h:69:2: note: expanded from macro 'bio_data_dir'
        (op_is_write(bio_op(bio)) ? WRITE : READ)
        ^
drivers/md/dm-dust.c:219:9: note: uninitialized use occurs here
        return ret;
               ^~~
drivers/md/dm-dust.c:216:7: note: remove the 'if' if its condition is
always true
        else if (bio_data_dir(bio) == WRITE)
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/md/dm-dust.c:209:9: note: initialize the variable 'ret' to
silence this warning
        int ret;
               ^
                = 0
1 warning generated.

It isn't wrong; however, bio_data_dir will only ever return READ and
WRITE so the second 'else if' can really become an 'else' to silence
this warning and not change the final meaning of the code.

Link: https://github.com/ClangBuiltLinux/linux/issues/462
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/md/dm-dust.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 997830984893..5baeb56679ed 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -213,7 +213,7 @@ static int dust_map(struct dm_target *ti, struct bio *bio)
 
 	if (bio_data_dir(bio) == READ)
 		ret = dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
-	else if (bio_data_dir(bio) == WRITE)
+	else
 		ret = dust_map_write(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
 
 	return ret;
-- 
2.21.0
