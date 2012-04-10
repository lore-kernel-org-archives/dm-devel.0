From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2] multipath: enable getting uevents through
	libudev
Date: Mon, 9 Apr 2012 23:01:54 -0500
Message-ID: <20120410040154.GT1241@ether.msp.redhat.com>
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

udev is removing support for RUN+="socket:..." rules. For now, I've kept
all the existing uevent code, but I've added a new method for getting the
uevent information using libudev that will be tried first.  

This version includes more error checking.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile |    2 
 libmultipath/uevent.c |  155 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 138 insertions(+), 19 deletions(-)

Index: multipath-tools-120403/libmultipath/Makefile
===================================================================
--- multipath-tools-120403.orig/libmultipath/Makefile
+++ multipath-tools-120403/libmultipath/Makefile
@@ -7,7 +7,7 @@ include ../Makefile.inc
 SONAME=0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
-LIBDEPS = -lpthread -ldl -ldevmapper
+LIBDEPS = -lpthread -ldl -ldevmapper -ludev
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \
Index: multipath-tools-120403/libmultipath/uevent.c
===================================================================
--- multipath-tools-120403.orig/libmultipath/uevent.c
+++ multipath-tools-120403/libmultipath/uevent.c
@@ -39,6 +39,7 @@
 #include <pthread.h>
 #include <limits.h>
 #include <sys/mman.h>
+#include <libudev.h>
 #include <errno.h>
 
 #include "memory.h"
@@ -161,7 +162,7 @@ int uevent_dispatch(int (*uev_trigger)(s
 	return 0;
 }
 
-int uevent_listen(void)
+int failback_listen(void)
 {
 	int sock;
 	struct sockaddr_nl snl;
@@ -173,20 +174,6 @@ int uevent_listen(void)
 	int rcvszsz = sizeof(rcvsz);
 	unsigned int *prcvszsz = (unsigned int *)&rcvszsz;
 	const int feature_on = 1;
-
-	/*
-	 * Queue uevents for service by dedicated thread so that the uevent
-	 * listening thread does not block on multipathd locks (vecs->lock)
-	 * thereby not getting to empty the socket's receive buffer queue
-	 * often enough.
-	 */
-	INIT_LIST_HEAD(&uevq);
-
-	pthread_mutex_init(uevq_lockp, NULL);
-	pthread_cond_init(uev_condp, NULL);
-
-	pthread_cleanup_push(uevq_stop, NULL);
-
 	/*
 	 * First check whether we have a udev socket
 	 */
@@ -382,13 +369,145 @@ int uevent_listen(void)
 
 exit:
 	close(sock);
+	return 1;
+}
 
-	pthread_cleanup_pop(1);
+int uevent_listen(void)
+{
+	int err;
+	struct udev *udev = NULL;
+	struct udev_monitor *monitor = NULL;
+	int fd, socket_flags;
+	int need_failback = 1;
+	/*
+	 * Queue uevents for service by dedicated thread so that the uevent
+	 * listening thread does not block on multipathd locks (vecs->lock)
+	 * thereby not getting to empty the socket's receive buffer queue
+	 * often enough.
+	 */
+	INIT_LIST_HEAD(&uevq);
 
+	pthread_mutex_init(uevq_lockp, NULL);
+	pthread_cond_init(uev_condp, NULL);
+	pthread_cleanup_push(uevq_stop, NULL);
+
+	udev = udev_new();
+	if (!udev) {
+		condlog(2, "failed to create udev context");
+		goto out;
+	}
+	monitor = udev_monitor_new_from_netlink(udev, "udev");
+	if (!monitor) {
+		condlog(2, "failed to create udev monitor");
+		goto out;
+	}
+	if (udev_monitor_set_receive_buffer_size(monitor, 128 * 1024 * 1024))
+		condlog(2, "failed to increase buffer size");
+	fd = udev_monitor_get_fd(monitor);
+	if (fd < 0) {
+		condlog(2, "failed to get monitor fd");
+		goto out;
+	}
+	socket_flags = fcntl(fd, F_GETFL);
+	if (socket_flags < 0) {
+		condlog(2, "failed to get monitor socket flags : %s",
+			strerror(errno));
+		goto out;
+	}
+	if (fcntl(fd, F_SETFL, socket_flags & ~O_NONBLOCK) < 0) {
+		condlog(2, "failed to set monitor socket flags : %s",
+			strerror(errno));
+		goto out;
+	}
+	err = udev_monitor_filter_add_match_subsystem_devtype(monitor, "block",
+							      NULL);
+	if (err)
+		condlog(2, "failed to create filter : %s\n", strerror(-err));
+	err = udev_monitor_enable_receiving(monitor);
+	if (err) {
+		condlog(2, "failed to enable receiving : %s\n", strerror(-err));
+		goto out;
+	}
+	while (1) {
+		int i = 0;
+		char *pos, *end;
+		struct uevent *uev;
+		struct udev_device *dev;
+                struct udev_list_entry *list_entry;
+
+		dev = udev_monitor_receive_device(monitor);
+		if (!dev) {
+			condlog(0, "failed getting udev device");
+			continue;
+		}
+
+		uev = alloc_uevent();
+		if (!uev) {
+			condlog(1, "lost uevent, oom");
+			continue;
+		}
+		pos = uev->buffer;
+		end = pos + HOTPLUG_BUFFER_SIZE + OBJECT_SIZE - 1;
+		udev_list_entry_foreach(list_entry, udev_device_get_properties_list_entry(dev)) {
+			const char *name, *value;
+			int bytes;
+
+			name = udev_list_entry_get_name(list_entry);
+			if (!name)
+				name = "(null)";
+			value = udev_list_entry_get_value(list_entry);
+			if (!value)
+				value = "(null)";
+			bytes = snprintf(pos, end - pos, "%s=%s", name,
+					value);
+			if (pos + bytes >= end) {
+				condlog(2, "buffer overflow for uevent");
+				break;
+			}
+			uev->envp[i] = pos;
+			pos += bytes;
+			*pos = '\0';
+			pos++;
+			if (strcmp(name, "DEVPATH") == 0)
+				uev->devpath = uev->envp[i] + 8;
+			if (strcmp(name, "ACTION") == 0)
+				uev->action = uev->envp[i] + 7;
+			i++;
+			if (i == HOTPLUG_NUM_ENVP - 1)
+				break;
+		}
+		udev_device_unref(dev);
+		uev->envp[i] = NULL;
+
+		condlog(3, "uevent '%s' from '%s'", uev->action, uev->devpath);
+		uev->kernel = strrchr(uev->devpath, '/');
+		if (uev->kernel)
+			uev->kernel++;
+
+		/* print payload environment */
+		for (i = 0; uev->envp[i] != NULL; i++)
+			condlog(5, "%s", uev->envp[i]);
+
+		/*
+ 		 * Queue uevent and poke service pthread.
+ 		 */
+		pthread_mutex_lock(uevq_lockp);
+		list_add_tail(&uev->node, &uevq);
+		pthread_cond_signal(uev_condp);
+		pthread_mutex_unlock(uevq_lockp);
+	}
+	need_failback = 0;
+out:
+	if (monitor)
+		udev_monitor_unref(monitor);
+	if (udev)
+		udev_unref(udev);
+	if (need_failback)
+		err = failback_listen();
+	pthread_cleanup_pop(1);
 	pthread_mutex_destroy(uevq_lockp);
 	pthread_cond_destroy(uev_condp);
-
-	return 1;
+	return err;
 }
 
 extern int
