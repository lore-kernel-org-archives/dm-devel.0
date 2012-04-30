From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/16] Fix compilation on older udev versions
Date: Mon, 30 Apr 2012 12:26:08 +0200
Message-ID: <1335781568-13299-18-git-send-email-hare@suse.de>
References: <1335781568-13299-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335781568-13299-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

Older udev versions do not export 'udev_monitor_set_receive_buffer_size',
so we need to comment it out on those systems.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/Makefile |    7 +++++++
 libmultipath/uevent.c |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index bacd89e..fd564cf 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -29,6 +29,13 @@ ifneq ($(strip $(LIBDM_API_COOKIE)),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
+LIBUDEV_API_RECVBUF = $(shell grep -Ecs '^[a-z]*[[:space:]]+udev_monitor_set_resolve_buffer_size' /usr/include/libudev.h)
+
+ifneq ($(strip $(LIBUDEV_API_RECVBUF)),0)
+	CFLAGS += -DLIBUDEV_API_RECVBUF
+endif
+
+
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index c1d45b0..11c650f 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -189,8 +189,10 @@ int uevent_listen(void)
 		condlog(2, "failed to create udev monitor");
 		goto out;
 	}
+#ifdef LIBUDEV_API_RECVBUF
 	if (udev_monitor_set_receive_buffer_size(monitor, 128 * 1024 * 1024))
 		condlog(2, "failed to increase buffer size");
+#endif
 	fd = udev_monitor_get_fd(monitor);
 	if (fd < 0) {
 		condlog(2, "failed to get monitor fd");
-- 
1.7.3.4
