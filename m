From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace <sys/poll.h> with
	<poll.h>
Date: Thu, 21 Jul 2016 21:29:28 +0200
Message-ID: <1469129368-2855-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

The standard place of poll.h is in /usr/include/
Spotted by musl libc.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_updatepr.c | 2 +-
 libmultipath/uevent.c            | 2 +-
 libmultipath/uxsock.c            | 2 +-
 multipathd/uxclnt.c              | 2 +-
 multipathd/uxlsnr.c              | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index be73de4..9ff4b30 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -9,7 +9,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <errno.h>
 #include "debug.h"
 #include "mpath_cmd.h"
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index ca41d35..5f3204b 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -33,7 +33,7 @@
 #include <sys/socket.h>
 #include <sys/user.h>
 #include <sys/un.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <linux/types.h>
 #include <linux/netlink.h>
 #include <pthread.h>
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index f6d4ffa..775e278 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -13,7 +13,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <signal.h>
 #include <errno.h>
 #ifdef USE_SYSTEMD
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 109a217..62ff6f4 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -14,7 +14,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <readline/readline.h>
 #include <readline/history.h>
 
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 8ab55ea..0159648 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -19,7 +19,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
-#include <sys/poll.h>
+#include <poll.h>
 #include <sys/time.h>
 #include <signal.h>
 #include "checkers.h"
-- 
2.7.4
