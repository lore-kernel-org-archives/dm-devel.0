From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RESEND][PATCH] multipath: better check for daemon mode
Date: Mon, 10 Oct 2011 22:16:51 -0500
Message-ID: <20111011031651.GT24133@ether.msp.redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

With the existing check, if a multipath device gets created with a
blacklisted path (because, for instance, the path was unblacklisted,
but multipathd was not reconfigured), multipathd will crash.  This is
because multipathd will add the path when it adds the multipath device,
but it won't have all the necessary information to use the path. The
new check makes sure multipathd won't add blacklisted paths, simply
because they are part of a multipath device.

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
