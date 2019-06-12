From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: [PATCH] dm table: don't copy from a null pointer in realloc_argv
Date: Wed, 12 Jun 2019 18:22:26 +0200
Message-ID: <20190612162226.18536-1-jmarchan@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

For the first call to realloc_argv() in dm_split_args(), old_argv is
NULL and size is zero. Then memcpy is called, with the NULL old_argv
as the source argument and a zero size argument. AFAIK, this is
undefined behavior and generates the following warning when compiled
with UBSAN on ppc64le:

In file included from ./arch/powerpc/include/asm/paca.h:19,
                 from ./arch/powerpc/include/asm/current.h:16,
                 from ./include/linux/sched.h:12,
                 from ./include/linux/kthread.h:6,
                 from drivers/md/dm-core.h:12,
                 from drivers/md/dm-table.c:8:
In function 'memcpy',
    inlined from 'realloc_argv' at drivers/md/dm-table.c:565:3,
    inlined from 'dm_split_args' at drivers/md/dm-table.c:588:9:
./include/linux/string.h:345:9: error: argument 2 null where non-null expected [-Werror=nonnull]
  return __builtin_memcpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/md/dm-table.c: In function 'dm_split_args':
./include/linux/string.h:345:9: note: in a call to built-in function '__builtin_memcpy'

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 350cf0451456..ec8b27e20de3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -561,7 +561,7 @@ static char **realloc_argv(unsigned *size, char **old_argv)
 		gfp = GFP_NOIO;
 	}
 	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
-	if (argv) {
+	if (argv && old_argv) {
 		memcpy(argv, old_argv, *size * sizeof(*argv));
 		*size = new_size;
 	}
-- 
2.20.1
