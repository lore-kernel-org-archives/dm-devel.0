From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: better check for daemon mode.
Date: Mon, 25 Jul 2011 13:47:52 -0500
Message-ID: <20110725184752.GL15149@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Switching to conf->daemon to check if we are in daemon mode.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dmparser.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: multipath-tools-110713/libmultipath/dmparser.c
===================================================================
--- multipath-tools-110713.orig/libmultipath/dmparser.c
+++ multipath-tools-110713/libmultipath/dmparser.c
@@ -13,6 +13,7 @@
 #include "structs.h"
 #include "util.h"
 #include "debug.h"
+#include "config.h"
 
 #define WORD_SIZE 64
 
@@ -330,7 +331,7 @@ disassemble_map (vector pathvec, char * 
 				strncpy(pp->dev_t, word, BLK_DEV_SIZE);
 
 				/* Only call this in multipath client mode */
-				if (!mpp->waiter && store_path(pathvec, pp))
+				if (!conf->daemon && store_path(pathvec, pp))
 					goto out1;
 			}
 			FREE(word);
