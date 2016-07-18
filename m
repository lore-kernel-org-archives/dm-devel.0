From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace <> with "" for local
	headers
Date: Mon, 18 Jul 2016 16:42:32 +0200
Message-ID: <1468852952-9073-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/lopart.c                          |  2 +-
 libmpathpersist/mpath_persist.c          | 28 +++++++--------
 libmpathpersist/mpath_pr_ioctl.c         |  4 +--
 libmpathpersist/mpath_updatepr.c         |  6 ++--
 libmultipath/configure.c                 |  2 +-
 libmultipath/dict.c                      |  2 +-
 libmultipath/prioritizers/alua.c         |  6 ++--
 libmultipath/prioritizers/const.c        |  2 +-
 libmultipath/prioritizers/datacore.c     |  8 ++---
 libmultipath/prioritizers/emc.c          |  8 ++---
 libmultipath/prioritizers/hds.c          |  8 ++---
 libmultipath/prioritizers/hp_sw.c        |  8 ++---
 libmultipath/prioritizers/iet.c          |  6 ++--
 libmultipath/prioritizers/ontap.c        |  8 ++---
 libmultipath/prioritizers/random.c       |  2 +-
 libmultipath/prioritizers/rdac.c         |  8 ++---
 libmultipath/prioritizers/weightedpath.c | 12 +++----
 libmultipath/uxsock.c                    |  2 +-
 mpathpersist/main.c                      | 10 +++---
 multipath/main.c                         | 46 ++++++++++++-------------
 multipathd/cli.c                         | 12 +++----
 multipathd/cli_handlers.c                | 26 +++++++-------
 multipathd/main.c                        | 58 ++++++++++++++++----------------
 multipathd/pidfile.c                     |  2 +-
 multipathd/uxclnt.c                      |  8 ++---
 multipathd/uxlsnr.c                      | 18 +++++-----
 26 files changed, 151 insertions(+), 151 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 5d4967b..8eb328f 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -27,7 +27,7 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <dirent.h>
-#include <sysmacros.h>
+#include "sysmacros.h"
 #include <linux/loop.h>
 
 #include "lopart.h"
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index b037822..f2a0905 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -1,25 +1,25 @@
 #include <libdevmapper.h>
-#include <defaults.h>
+#include "defaults.h"
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <fcntl.h>
-#include <vector.h>
-#include <checkers.h>
-#include <structs.h>
-#include <structs_vec.h>
+#include "vector.h"
+#include "checkers.h"
+#include "structs.h"
+#include "structs_vec.h"
 #include <libudev.h>
 
-#include <prio.h>
+#include "prio.h"
 #include <unistd.h>
-#include <devmapper.h>
-#include <debug.h>
-#include <config.h>
-#include <switchgroup.h>
-#include <discovery.h>
-#include <dmparser.h>
+#include "devmapper.h"
+#include "debug.h"
+#include "config.h"
+#include "switchgroup.h"
+#include "discovery.h"
+#include "dmparser.h"
 #include <ctype.h>
-#include <propsel.h>
-#include <util.h>
+#include "propsel.h"
+#include "util.h"
 
 #include "mpath_persist.h"
 #include "mpathpr.h"
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index e54c804..cc781f6 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -12,9 +12,9 @@
 #include <unistd.h>
 #include <libudev.h>
 #include "mpath_pr_ioctl.h"
-#include <mpath_persist.h>
+#include "mpath_persist.h"
 
-#include <debug.h>
+#include "debug.h"
 
 #define FILE_NAME_SIZE          256
 
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 0529d13..faafe51 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -11,9 +11,9 @@
 #include <sys/un.h>
 #include <sys/poll.h>
 #include <errno.h>
-#include <debug.h>
-#include <mpath_cmd.h>
-#include <uxsock.h>
+#include "debug.h"
+#include "mpath_cmd.h"
+#include "uxsock.h"
 #include "memory.h"
 
 unsigned long mem_allocated;    /* Total memory used in Bytes */
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 4b9d0c6..1e0037f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -14,7 +14,7 @@
 #include <errno.h>
 #include <libdevmapper.h>
 #include <libudev.h>
-#include <mpath_cmd.h>
+#include "mpath_cmd.h"
 
 #include "checkers.h"
 #include "vector.h"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7b92a91..030ad98 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -21,7 +21,7 @@
 #include "prio.h"
 #include "errno.h"
 #include <inttypes.h>
-#include <mpath_cmd.h>
+#include "mpath_cmd.h"
 
 static int
 set_int(vector strvec, void *ptr)
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index b6c5176..9f0851d 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -14,9 +14,9 @@
  */
 #include <stdio.h>
 
-#include <debug.h>
-#include <prio.h>
-#include <structs.h>
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
 
 #include "alua.h"
 
diff --git a/libmultipath/prioritizers/const.c b/libmultipath/prioritizers/const.c
index bf689cd..9d9d003 100644
--- a/libmultipath/prioritizers/const.c
+++ b/libmultipath/prioritizers/const.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 
-#include <prio.h>
+#include "prio.h"
 
 int getprio (struct path * pp, char * args)
 {
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index 658a598..9afbbfe 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -21,10 +21,10 @@
 #include <sys/ioctl.h>
 
 #include <sys/stat.h>
-#include <sg_include.h>
-#include <debug.h>
-#include <prio.h>
-#include <structs.h>
+#include "sg_include.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
 
 #define INQ_REPLY_LEN 255
 #define INQ_CMD_CODE 0x12
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index 58640ec..a2f7487 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -2,10 +2,10 @@
 #include <string.h>
 #include <sys/ioctl.h>
 
-#include <sg_include.h>
-#include <debug.h>
-#include <prio.h>
-#include <structs.h>
+#include "sg_include.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index b8df8f0..d161e68 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -72,10 +72,10 @@
 #include <sys/ioctl.h>
 #include <stdlib.h>
 
-#include <sg_include.h>
-#include <debug.h>
-#include <prio.h>
-#include <structs.h>
+#include "sg_include.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
 
 #define INQ_REPLY_LEN 255
 #define INQ_CMD_CODE 0x12
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 9fbb1ff..253fd51 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -12,10 +12,10 @@
 #include <sys/ioctl.h>
 #include <errno.h>
 
-#include <sg_include.h>
-#include <debug.h>
-#include <prio.h>
-#include <structs.h>
+#include "sg_include.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
 
 #define TUR_CMD_LEN		6
 #define SCSI_CHECK_CONDITION	0x2
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index de31ced..aa852a0 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -5,10 +5,10 @@
 #include <stdio.h>
 #include <string.h>
 #include <regex.h>
-#include <prio.h>
-#include <debug.h>
+#include "prio.h"
+#include "debug.h"
 #include <unistd.h>
-#include <structs.h>
+#include "structs.h"
 
 //
 // This prioritizer suits iSCSI needs, makes it possible to prefer one path.
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index f78e1f6..747dfb5 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -19,10 +19,10 @@
 #include <errno.h>
 #include <assert.h>
 
-#include <sg_include.h>
-#include <debug.h>
-#include <prio.h>
-#include <structs.h>
+#include "sg_include.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
 
 #define INQUIRY_CMD	0x12
 #define INQUIRY_CMDLEN	6
diff --git a/libmultipath/prioritizers/random.c b/libmultipath/prioritizers/random.c
index 281a0d1..c3ea3ac 100644
--- a/libmultipath/prioritizers/random.c
+++ b/libmultipath/prioritizers/random.c
@@ -3,7 +3,7 @@
 #include <sys/time.h>
 #include <time.h>
 
-#include <prio.h>
+#include "prio.h"
 
 int getprio (struct path * pp, char * args)
 {
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index bbd73bd..f5df032 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -2,10 +2,10 @@
 #include <string.h>
 #include <sys/ioctl.h>
 
-#include <sg_include.h>
-#include <debug.h>
-#include <prio.h>
-#include <structs.h>
+#include "sg_include.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index ba8c555..406cef5 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -25,15 +25,15 @@
 #include <stdio.h>
 #include <string.h>
 
-#include <prio.h>
+#include "prio.h"
 #include "weightedpath.h"
-#include <config.h>
-#include <structs.h>
+#include "config.h"
+#include "structs.h"
 #include <memory.h>
-#include <debug.h>
+#include "debug.h"
 #include <regex.h>
-#include <structs_vec.h>
-#include <print.h>
+#include "structs_vec.h"
+#include "print.h"
 
 char *get_next_string(char **temp, char *split_char)
 {
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index e91abd9..f6d4ffa 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -19,7 +19,7 @@
 #ifdef USE_SYSTEMD
 #include <systemd/sd-daemon.h>
 #endif
-#include <mpath_cmd.h>
+#include "mpath_cmd.h"
 
 #include "memory.h"
 #include "uxsock.h"
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index c46fca5..51f59ca 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -3,13 +3,13 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <fcntl.h>
-#include <checkers.h>
-#include <vector.h>
-#include <config.h>
-#include <structs.h>
+#include "checkers.h"
+#include "vector.h"
+#include "config.h"
+#include "structs.h"
 #include <getopt.h>
 #include <libudev.h>
-#include <mpath_persist.h>
+#include "mpath_persist.h"
 #include "main.h"
 #include <pthread.h>
 #include <ctype.h>
diff --git a/multipath/main.c b/multipath/main.c
index 0bec0d2..7dba54e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -30,34 +30,34 @@
 #include <libudev.h>
 #include <syslog.h>
 
-#include <checkers.h>
-#include <prio.h>
-#include <vector.h>
+#include "checkers.h"
+#include "prio.h"
+#include "vector.h"
 #include <memory.h>
 #include <libdevmapper.h>
-#include <devmapper.h>
-#include <util.h>
-#include <defaults.h>
-#include <config.h>
-#include <structs.h>
-#include <structs_vec.h>
-#include <dmparser.h>
-#include <sysfs.h>
-#include <blacklist.h>
-#include <discovery.h>
-#include <debug.h>
-#include <switchgroup.h>
-#include <print.h>
-#include <alias.h>
-#include <configure.h>
-#include <pgpolicies.h>
-#include <version.h>
+#include "devmapper.h"
+#include "util.h"
+#include "defaults.h"
+#include "config.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "dmparser.h"
+#include "sysfs.h"
+#include "blacklist.h"
+#include "discovery.h"
+#include "debug.h"
+#include "switchgroup.h"
+#include "print.h"
+#include "alias.h"
+#include "configure.h"
+#include "pgpolicies.h"
+#include "version.h"
 #include <errno.h>
 #include <sys/time.h>
 #include <sys/resource.h>
-#include <wwids.h>
-#include <uxsock.h>
-#include <mpath_cmd.h>
+#include "wwids.h"
+#include "uxsock.h"
+#include "mpath_cmd.h"
 
 int logsink;
 struct udev *udev;
diff --git a/multipathd/cli.c b/multipathd/cli.c
index dc675b5..4a7b24d 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -5,12 +5,12 @@
 #include <errno.h>
 #include <pthread.h>
 #include <memory.h>
-#include <vector.h>
-#include <structs.h>
-#include <structs_vec.h>
-#include <parser.h>
-#include <util.h>
-#include <version.h>
+#include "vector.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "parser.h"
+#include "util.h"
+#include "version.h"
 #include <readline/readline.h>
 
 #include "cli.h"
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 2a54cba..1b046c4 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1,23 +1,23 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
-#include <checkers.h>
+#include "checkers.h"
 #include <memory.h>
-#include <vector.h>
-#include <structs.h>
-#include <structs_vec.h>
+#include "vector.h"
+#include "structs.h"
+#include "structs_vec.h"
 #include <libdevmapper.h>
-#include <devmapper.h>
-#include <discovery.h>
-#include <config.h>
-#include <configure.h>
-#include <blacklist.h>
-#include <debug.h>
-#include <print.h>
-#include <sysfs.h>
+#include "devmapper.h"
+#include "discovery.h"
+#include "config.h"
+#include "configure.h"
+#include "blacklist.h"
+#include "debug.h"
+#include "print.h"
+#include "sysfs.h"
 #include <errno.h>
 #include <libudev.h>
-#include <util.h>
+#include "util.h"
 
 #include "main.h"
 #include "cli.h"
diff --git a/multipathd/main.c b/multipathd/main.c
index 00a70f5..fb37f0d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -27,7 +27,7 @@
 /*
  * libcheckers
  */
-#include <checkers.h>
+#include "checkers.h"
 
 #ifdef USE_SYSTEMD
 static int use_watchdog;
@@ -38,35 +38,35 @@ int uxsock_timeout;
 /*
  * libmultipath
  */
-#include <parser.h>
-#include <vector.h>
+#include "parser.h"
+#include "vector.h"
 #include <memory.h>
-#include <config.h>
-#include <util.h>
-#include <hwtable.h>
-#include <defaults.h>
-#include <structs.h>
-#include <blacklist.h>
-#include <structs_vec.h>
-#include <dmparser.h>
-#include <devmapper.h>
-#include <sysfs.h>
-#include <dict.h>
-#include <discovery.h>
-#include <debug.h>
-#include <propsel.h>
-#include <uevent.h>
-#include <switchgroup.h>
-#include <print.h>
-#include <configure.h>
-#include <prio.h>
-#include <wwids.h>
-#include <pgpolicies.h>
-#include <uevent.h>
-#include <log.h>
-
-#include <mpath_cmd.h>
-#include <mpath_persist.h>
+#include "config.h"
+#include "util.h"
+#include "hwtable.h"
+#include "defaults.h"
+#include "structs.h"
+#include "blacklist.h"
+#include "structs_vec.h"
+#include "dmparser.h"
+#include "devmapper.h"
+#include "sysfs.h"
+#include "dict.h"
+#include "discovery.h"
+#include "debug.h"
+#include "propsel.h"
+#include "uevent.h"
+#include "switchgroup.h"
+#include "print.h"
+#include "configure.h"
+#include "prio.h"
+#include "wwids.h"
+#include "pgpolicies.h"
+#include "uevent.h"
+#include "log.h"
+
+#include "mpath_cmd.h"
+#include "mpath_persist.h"
 
 #include "prioritizers/alua_rtpg.h"
 
diff --git a/multipathd/pidfile.c b/multipathd/pidfile.c
index e911358..9bac1dd 100644
--- a/multipathd/pidfile.c
+++ b/multipathd/pidfile.c
@@ -8,7 +8,7 @@
 #include <unistd.h>    /* for unlink() */
 #include <fcntl.h>     /* for fcntl() */
 
-#include <debug.h>
+#include "debug.h"
 
 #include "pidfile.h"
 
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 37afaac..a0d58c3 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -18,12 +18,12 @@
 #include <readline/readline.h>
 #include <readline/history.h>
 
-#include <mpath_cmd.h>
-#include <uxsock.h>
+#include "mpath_cmd.h"
+#include "uxsock.h"
 #include <memory.h>
-#include <defaults.h>
+#include "defaults.h"
 
-#include <vector.h>
+#include "vector.h"
 #include "cli.h"
 
 static void print_reply(char *s)
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index abd1486..4fce585 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -22,16 +22,16 @@
 #include <sys/poll.h>
 #include <sys/time.h>
 #include <signal.h>
-#include <checkers.h>
+#include "checkers.h"
 #include <memory.h>
-#include <debug.h>
-#include <vector.h>
-#include <structs.h>
-#include <structs_vec.h>
-#include <uxsock.h>
-#include <defaults.h>
-#include <config.h>
-#include <mpath_cmd.h>
+#include "debug.h"
+#include "vector.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "uxsock.h"
+#include "defaults.h"
+#include "config.h"
+#include "mpath_cmd.h"
 
 #include "main.h"
 #include "cli.h"
-- 
2.7.4
