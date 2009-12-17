From: neilb@suse.de
Subject: [dmraid 3/4] Fix min/max macros
Date: Thu, 17 Dec 2009 16:44:13 +1100
Message-ID: <20091217054526.545361172@suse.de>
References: <20091217054410.410634166@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=remove-min-max
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

These need parentheses around them.

In particular, in hpt37x.c, in 'to_cpu'
we have an expression:
   x + min(y,z)
which will become

 x + y > z ? y : z

which is not what is wanted.

From: dmraid-fdleak.patch
Signed-off-by: NeilBrown <neilb@suse.de>

---
 lib/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- dmraid-16.orig/lib/internal.h
+++ dmraid-16/lib/internal.h
@@ -50,8 +50,8 @@
 #define	u_int64_t	uint64_t
 #endif
 
-#define min(a, b) (a) < (b) ? (a) : (b)
-#define max(a, b) (a) > (b) ? (a) : (b)
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#define max(a, b) ((a) > (b) ? (a) : (b))
 #define ARRAY_SIZE(a)   (sizeof(a) / sizeof(*a))
 #define ARRAY_END(a)   (a + ARRAY_SIZE(a))
 
