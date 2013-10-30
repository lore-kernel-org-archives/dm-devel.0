From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH] drivers: md: include "linux/vmalloc.h" in "dm-cache-policy-hints.c"
Date: Wed, 30 Oct 2013 14:17:09 +0800
Message-ID: <5270A465.2040200@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, neilb@suse.de
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Need include related header file, or can not pass compiling, the
related error (for powerpc with allmodconfig):

    CC [M]  drivers/md/dm-cache-policy-hints.o
  drivers/md/dm-cache-policy-hints.c: In function =91alloc_hash=92:
  drivers/md/dm-cache-policy-hints.c:94:2: error: implicit declaration =
of function =91vzalloc=92 [-Werror=3Dimplicit-function-declaration]
  drivers/md/dm-cache-policy-hints.c:94:14: warning: assignment makes p=
ointer from integer without a cast [enabled by default]
  drivers/md/dm-cache-policy-hints.c: In function =91free_hash=92:
  drivers/md/dm-cache-policy-hints.c:101:2: error: implicit declaration=
 of function =91vfree=92 [-Werror=3Dimplicit-function-declaration]
  drivers/md/dm-cache-policy-hints.c: In function =91alloc_bitset=92:
  drivers/md/dm-cache-policy-hints.c:184:2: warning: return makes point=
er from integer without a cast [enabled by default]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/md/dm-cache-policy-hints.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-cache-policy-hints.c b/drivers/md/dm-cache-p=
olicy-hints.c
index 312cfb7..a8c1930 100644
--- a/drivers/md/dm-cache-policy-hints.c
+++ b/drivers/md/dm-cache-policy-hints.c
@@ -15,6 +15,7 @@
 #include <linux/hash.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/vmalloc.h>
=20
 #define DM_MSG_PREFIX "cache-policy-hints"
=20
--=20
1.7.7.6
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
