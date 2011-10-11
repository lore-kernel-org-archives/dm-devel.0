From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: set ACT_RESIZE when the size has
	changed
Date: Mon, 10 Oct 2011 22:19:13 -0500
Message-ID: <20111011031913.GV24133@ether.msp.redhat.com>
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

When the multipath path devices change size, multipath can't be reloaded
with noflush set.  So, don't set the action to ACT_RELOAD, which will
cause the multipath device to get stuck in SUSPEND. Use ACT_RESIZE.

Also, I was seeing some messages that were getting cut off with the
128 byte messages size, so I doubled that, and the log area size.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c |    4 ++--
 libmultipath/log.h       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: multipath-tools-111010/libmultipath/configure.c
===================================================================
--- multipath-tools-111010.orig/libmultipath/configure.c
+++ multipath-tools-111010/libmultipath/configure.c
@@ -193,8 +193,8 @@ select_action (struct multipath * mpp, v
 		return;
 	}
 	if (cmpp->size != mpp->size) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (size change)",
+		mpp->action = ACT_RESIZE;
+		condlog(3, "%s: set ACT_RESIZE (size change)",
 			mpp->alias);
 		return;
 	}
Index: multipath-tools-111010/libmultipath/log.h
===================================================================
--- multipath-tools-111010.orig/libmultipath/log.h
+++ multipath-tools-111010/libmultipath/log.h
@@ -1,8 +1,8 @@
 #ifndef LOG_H
 #define LOG_H
 
-#define DEFAULT_AREA_SIZE 8192
-#define MAX_MSG_SIZE 128
+#define DEFAULT_AREA_SIZE 16384
+#define MAX_MSG_SIZE 256
 
 #ifndef LOGLEVEL
 #define LOGLEVEL 5
