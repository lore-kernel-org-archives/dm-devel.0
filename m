From: Guido Guenther <agx@sigxcpu.org>
Subject: [PATCH] fix debugging macro
Date: Sat,  9 Jun 2007 17:30:38 +0200
Message-ID: <11814030382850-git-send-email-agx@sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Minor cleanup: let the macro do something useful when DEBUG is defined

Signed-off-by: Guido Guenther <agx@sigxcpu.org>
---
 libmultipath/sysfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index cf3af36..2625ee5 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -6,9 +6,9 @@
 #define _LIBMULTIPATH_SYSFS_H
 
 #ifdef DEBUG
-# define dbg printf
+# define dbg(format, args...) printf(format "\n", ##args)
 #else
-# define dbg(format, arg...) do {} while (0)
+# define dbg(format, args...) do {} while (0)
 #endif
 
 int sysfs_init(char *path, size_t len);
-- 
1.5.2.1
