From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 11/18] Add libmpathcmd library and use it
	internally
Date: Thu,  8 Oct 2015 14:44:44 -0500
Message-ID: <1444333491-16265-12-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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

Other programs would like to communicate with multipathd to issue
command or check status.  Instead of having them exec multipathd,
I've pulled the code that sends commands and receives replies from
multipathd into its own library.  I've made the multipath tools use
this library internally as well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile                         |   1 +
 Makefile.inc                     |   2 +
 libmpathcmd/Makefile             |  30 +++++++
 libmpathcmd/mpath_cmd.c          | 178 +++++++++++++++++++++++++++++++++++++++
 libmpathcmd/mpath_cmd.h          | 125 +++++++++++++++++++++++++++
 libmpathpersist/Makefile         |   9 +-
 libmpathpersist/mpath_updatepr.c |  14 +--
 libmultipath/Makefile            |   3 +-
 libmultipath/config.c            |   3 +-
 libmultipath/configure.c         |  10 +--
 libmultipath/defaults.h          |   2 -
 libmultipath/dict.c              |   8 +-
 libmultipath/uxsock.c            |  73 ++++------------
 libmultipath/uxsock.h            |   5 +-
 mpathpersist/Makefile            |   2 +-
 multipath/Makefile               |   5 +-
 multipath/main.c                 |   5 +-
 multipathd/Makefile              |   5 +-
 multipathd/main.c                |   1 +
 multipathd/uxclnt.c              |  13 ++-
 multipathd/uxlsnr.c              |  11 +--
 21 files changed, 398 insertions(+), 107 deletions(-)
 create mode 100644 libmpathcmd/Makefile
 create mode 100644 libmpathcmd/mpath_cmd.c
 create mode 100644 libmpathcmd/mpath_cmd.h

diff --git a/Makefile b/Makefile
index baf7753..06f50c8 100644
--- a/Makefile
+++ b/Makefile
@@ -20,6 +20,7 @@ export KRNLSRC
 export KRNLOBJ
 
 BUILDDIRS = \
+	libmpathcmd \
 	libmultipath \
 	libmultipath/prioritizers \
 	libmultipath/checkers \
diff --git a/Makefile.inc b/Makefile.inc
index c3ed73f..2a13b42 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -42,9 +42,11 @@ man5dir     = $(prefix)/usr/share/man/man5
 man3dir      = $(prefix)/usr/share/man/man3
 rcdir	    = $(prefix)/etc/init.d
 syslibdir   = $(prefix)/$(LIB)
+incdir      = $(prefix)/usr/include
 libdir	    = $(prefix)/$(LIB)/multipath
 unitdir     = $(prefix)/$(SYSTEMDPATH)/systemd/system
 mpathpersistdir = $(TOPDIR)/libmpathpersist
+mpathcmddir = $(TOPDIR)/libmpathcmd
 
 GZIP        = gzip -9 -c
 INSTALL_PROGRAM = install
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
new file mode 100644
index 0000000..0304ecc
--- /dev/null
+++ b/libmpathcmd/Makefile
@@ -0,0 +1,30 @@
+# Makefile
+#
+include ../Makefile.inc
+
+SONAME=0
+DEVLIB = libmpathcmd.so
+LIBS = $(DEVLIB).$(SONAME)
+
+OBJS = mpath_cmd.o
+
+all: $(LIBS)
+
+$(LIBS): $(OBJS)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
+	ln -sf $@ $(DEVLIB)
+
+install: $(LIBS)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
+	ln -sf $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(incdir)
+	$(INSTALL_PROGRAM) -m 755 mpath_cmd.h $(DESTDIR)$(incdir)
+
+uninstall:
+	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
+	rm -f $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	rm -f $(DESTDIR)$(incdir)/mpath_cmd.h
+
+clean:
+	rm -f core *.a *.o *.gz *.so *.so.*
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
new file mode 100644
index 0000000..1aaf5ea
--- /dev/null
+++ b/libmpathcmd/mpath_cmd.c
@@ -0,0 +1,178 @@
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <poll.h>
+#include <string.h>
+#include <errno.h>
+
+#include "mpath_cmd.h"
+
+/*
+ * keep reading until its all read
+ */
+static ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
+{
+	size_t total = 0;
+	ssize_t n;
+	int ret;
+	struct pollfd pfd;
+
+	while (len) {
+		pfd.fd = fd;
+		pfd.events = POLLIN;
+		ret = poll(&pfd, 1, timeout);
+		if (!ret) {
+			errno = ETIMEDOUT;
+			return -1;
+		} else if (ret < 0) {
+			if (errno == EINTR)
+				continue;
+			return -1;
+		} else if (!pfd.revents & POLLIN)
+			continue;
+		n = read(fd, buf, len);
+		if (n < 0) {
+			if ((errno == EINTR) || (errno == EAGAIN))
+				continue;
+			return -1;
+		}
+		if (!n)
+			return total;
+		buf = n + (char *)buf;
+		len -= n;
+		total += n;
+	}
+	return total;
+}
+
+/*
+ * keep writing until it's all sent
+ */
+static size_t write_all(int fd, const void *buf, size_t len)
+{
+	size_t total = 0;
+
+	while (len) {
+		ssize_t n = write(fd, buf, len);
+		if (n < 0) {
+			if ((errno == EINTR) || (errno == EAGAIN))
+				continue;
+			return total;
+		}
+		if (!n)
+			return total;
+		buf = n + (char *)buf;
+		len -= n;
+		total += n;
+	}
+	return total;
+}
+
+/*
+ * connect to a unix domain socket
+ */
+int mpath_connect(void)
+{
+	int fd, len;
+	struct sockaddr_un addr;
+
+	memset(&addr, 0, sizeof(addr));
+	addr.sun_family = AF_LOCAL;
+	addr.sun_path[0] = '\0';
+	len = strlen(DEFAULT_SOCKET) + 1 + sizeof(sa_family_t);
+	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, len);
+
+	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
+	if (fd == -1)
+		return -1;
+
+	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+int mpath_disconnect(int fd)
+{
+	return close(fd);
+}
+
+ssize_t mpath_recv_reply_len(int fd, unsigned int timeout)
+{
+	size_t len;
+	ssize_t ret;
+
+	ret = read_all(fd, &len, sizeof(len), timeout);
+	if (ret < 0)
+		return ret;
+	if (ret != sizeof(len)) {
+		errno = EIO;
+		return ret;
+	}
+	return len;
+}
+
+int mpath_recv_reply_data(int fd, char *reply, size_t len,
+			  unsigned int timeout)
+{
+	ssize_t ret;
+
+	ret = read_all(fd, reply, len, timeout);
+	if (ret < 0)
+		return ret;
+	if (ret != len) {
+		errno = EIO;
+		return -1;
+	}
+	reply[len - 1] = '\0';
+	return 0;
+}
+
+int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
+{
+	int err;
+	ssize_t len;
+
+	*reply = NULL;
+	len = mpath_recv_reply_len(fd, timeout);
+	if (len <= 0)
+		return len;
+	*reply = malloc(len);
+	if (!*reply)
+		return -1;
+	err = mpath_recv_reply_data(fd, *reply, len, timeout);
+	if (err) {
+		free(*reply);
+		*reply = NULL;
+		return err;
+	}
+	return 0;
+}
+
+int mpath_send_cmd(int fd, const char *cmd)
+{
+	size_t len;
+
+	if (cmd != NULL)
+		len = strlen(cmd) + 1;
+	else
+		len = 0;
+	if (write_all(fd, &len, sizeof(len)) != sizeof(len))
+		return -1;
+	if (len && write_all(fd, cmd, len) != len)
+		return -1;
+	return 0;
+}
+
+int mpath_process_cmd(int fd, const char *cmd, char **reply,
+		      unsigned int timeout)
+{
+	if (mpath_send_cmd(fd, cmd) != 0)
+		return -1;
+	return mpath_recv_reply(fd, reply, timeout);
+}
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
new file mode 100644
index 0000000..6d80a2f
--- /dev/null
+++ b/libmpathcmd/mpath_cmd.h
@@ -0,0 +1,125 @@
+/*
+ * Copyright (C) 2015 Red Hat, Inc.
+ *
+ * This file is part of the device-mapper multipath userspace tools.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
+ * USA.
+ */
+
+#ifndef LIB_MPATH_CMD_H
+#define LIB_MPATH_CMD_H
+
+#ifdef __cpluscplus
+extern "C" {
+#endif
+
+#define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
+#define DEFAULT_REPLY_TIMEOUT	1000
+
+
+/*
+ * DESCRIPTION:
+ * 	Connect to the running multipathd daemon. On systems with the
+ * 	multipathd.socket systemd unit file installed, this command will
+ * 	start multipathd if it is not already running. This function
+ * 	must be run before any of the others in this library
+ *
+ * RETURNS:
+ * 	A file descriptor on success. -1 on failure (with errno set).
+ */
+int mpath_connect(void);
+
+
+/*
+ * DESCRIPTION:
+ * 	Disconnect from the multipathd daemon. This function must be
+ * 	run after after processing all the multipath commands.
+ *
+ * RETURNS:
+ * 	0 on success. -1 on failure (with errno set).
+ */
+int mpath_disconnect(int fd);
+
+
+/*
+ * DESCRIPTION
+ * 	Send multipathd a command and return the reply. This function
+ * 	does the same as calling mpath_send_cmd() and then
+ *	mpath_recv_reply()
+ *
+ * RETURNS:
+ * 	0 on successs, and reply will either be NULL (if there was no
+ * 	reply data), or point to the reply string, which must be freed by
+ * 	the caller. -1 on failure (with errno set).
+ */
+int mpath_process_cmd(int fd, const char *cmd, char **reply,
+		      unsigned int timeout);
+
+
+/*
+ * DESCRIPTION:
+ * 	Send a command to multipathd
+ *
+ * RETURNS:
+ * 	0 on success. -1 on failure (with errno set)
+ */
+int mpath_send_cmd(int fd, const char *cmd);
+
+
+/*
+ * DESCRIPTION:
+ * 	Return a reply from multipathd for a previously sent command.
+ * 	This is equivalent to calling mpath_recv_reply_len(), allocating
+ * 	a buffer of the appropriate size, and then calling
+ *	mpath_recv_reply_data() with that buffer.
+ *
+ * RETURNS:
+ * 	0 on success, and reply will either be NULL (if there was no
+ * 	reply data), or point to the reply string, which must be freed by
+ * 	the caller, -1 on failure (with errno set).
+ */
+int mpath_recv_reply(int fd, char **reply, unsigned int timeout);
+
+
+/*
+ * DESCRIPTION:
+ * 	Return the size of the upcoming reply data from the sent multipath
+ * 	command. This must be called before calling mpath_recv_reply_data().
+ *
+ * RETURNS:
+ * 	The required size of the reply data buffer on success. -1 on
+ * 	failure (with errno set).
+ */
+ssize_t mpath_recv_reply_len(int fd, unsigned int timeout);
+
+
+/*
+ * DESCRIPTION:
+ * 	Return the reply data from the sent multipath command.
+ * 	mpath_recv_reply_len must be called first. reply must point to a
+ * 	buffer of len size.
+ *
+ * RETURNS:
+ * 	0 on success, and reply will contain the reply data string. -1
+ * 	on failure (with errno set).
+ */
+int mpath_recv_reply_data(int fd, char *reply, size_t len,
+			  unsigned int timeout);
+
+#ifdef __cplusplus
+}
+#endif
+#endif /* LIB_MPATH_CMD_H */
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index c4ec1c5..7dcfd26 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -10,8 +10,9 @@ DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
 
 
-CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) 
-LIBDEPS +=  -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir) 
+LIBDEPS +=  -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
+	-L$(mpathcmddir) -lmpathcmd
 
 OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o 
 
@@ -30,12 +31,12 @@ install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
-	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/include/
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(incdir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)/usr/share/doc/mpathpersist/
 	ln -sf $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	install -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)	
 	install -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)	
-	install -m 644 mpath_persist.h $(DESTDIR)/usr/include/
+	install -m 644 mpath_persist.h $(DESTDIR)$(incdir)
 
 uninstall:
 	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index dce580f..bda8991 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -12,9 +12,9 @@
 #include <sys/poll.h>
 #include <errno.h>
 #include <debug.h>
+#include <mpath_cmd.h>
+#include <uxsock.h>
 #include "memory.h"
-#include "../libmultipath/uxsock.h"
-#include "../libmultipath/defaults.h"
 
 unsigned long mem_allocated;    /* Total memory used in Bytes */
 
@@ -23,10 +23,9 @@ int update_prflag(char * arg1, char * arg2, int noisy)
 	int fd;
 	char str[64];
 	char *reply;
-	size_t len;
 	int ret = 0;
 
-	fd = ux_socket_connect(DEFAULT_SOCKET);
+	fd = mpath_connect();
 	if (fd == -1) {
 		condlog (0, "ux socket connect error");
 		return 1 ;
@@ -34,10 +33,10 @@ int update_prflag(char * arg1, char * arg2, int noisy)
 
 	snprintf(str,sizeof(str),"map %s %s", arg1, arg2);
 	condlog (2, "%s: pr flag message=%s", arg1, str);
-	send_packet(fd, str, strlen(str) + 1);
-	ret = recv_packet(fd, &reply, &len, DEFAULT_UXSOCK_TIMEOUT);
+	send_packet(fd, str);
+	ret = recv_packet(fd, &reply, DEFAULT_REPLY_TIMEOUT);
 	if (ret < 0) {
-		condlog(2, "%s: message=%s error=%d", arg1, str, -ret);
+		condlog(2, "%s: message=%s error=%d", arg1, str, errno);
 		ret = -2;
 	} else {
 		condlog (2, "%s: message=%s reply=%s", arg1, str, reply);
@@ -51,5 +50,6 @@ int update_prflag(char * arg1, char * arg2, int noisy)
 	}
 
 	free(reply);
+	mpath_disconnect(fd);
 	return ret;
 }
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index fc0f3d6..11750c2 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -7,7 +7,8 @@ include ../Makefile.inc
 SONAME=0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
-LIBDEPS = -lpthread -ldl -ldevmapper -ludev
+CFLAGS += -I$(mpathcmddir)
+LIBDEPS = -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
 ifdef SYSTEMD
 	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
 		LIBDEPS += -lsystemd
diff --git a/libmultipath/config.c b/libmultipath/config.c
index f0aae53..746459c 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -24,6 +24,7 @@
 #include "defaults.h"
 #include "prio.h"
 #include "devmapper.h"
+#include "mpath_cmd.h"
 
 static int
 hwe_strmatch (struct hwentry *hwe1, struct hwentry *hwe2)
@@ -617,7 +618,7 @@ load_config (char * file, struct udev *udev)
 	conf->partition_delim = NULL;
 	conf->processed_main_config = 0;
 	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
-	conf->uxsock_timeout = DEFAULT_UXSOCK_TIMEOUT;
+	conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
 	conf->uid_attribute = set_default(DEFAULT_UID_ATTRIBUTE);
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3559c01..3c9badd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -14,6 +14,7 @@
 #include <errno.h>
 #include <libdevmapper.h>
 #include <libudev.h>
+#include <mpath_cmd.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -708,16 +709,15 @@ int check_daemon(void)
 {
 	int fd;
 	char *reply;
-	size_t len;
 	int ret = 0;
 
-	fd = ux_socket_connect(DEFAULT_SOCKET);
+	fd = mpath_connect();
 	if (fd == -1)
 		return 0;
 
-	if (send_packet(fd, "show daemon", 12) != 0)
+	if (send_packet(fd, "show daemon") != 0)
 		goto out;
-	if (recv_packet(fd, &reply, &len, conf->uxsock_timeout) != 0)
+	if (recv_packet(fd, &reply, conf->uxsock_timeout) != 0)
 		goto out;
 
 	if (strstr(reply, "shutdown"))
@@ -728,7 +728,7 @@ int check_daemon(void)
 out_free:
 	FREE(reply);
 out:
-	close(fd);
+	mpath_disconnect(fd);
 	return ret;
 }
 
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 025a016..e2d2779 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -20,7 +20,6 @@
 #define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF
 #define DEFAULT_UEVENT_STACKSIZE 256
-#define DEFAULT_UXSOCK_TIMEOUT  1000
 #define DEFAULT_RETRIGGER_DELAY 10
 #define DEFAULT_RETRIGGER_TRIES 3
 
@@ -29,7 +28,6 @@
 
 #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
 #define DEFAULT_PIDFILE		"/run/multipathd.pid"
-#define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 1952b1e..1fabc54 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -21,6 +21,7 @@
 #include "prio.h"
 #include "errno.h"
 #include <inttypes.h>
+#include <mpath_cmd.h>
 
 static int
 set_int(vector strvec, void *ptr)
@@ -1054,10 +1055,10 @@ def_uxsock_timeout_handler(vector strvec)
 		return 1;
 
 	if (sscanf(buff, "%u", &uxsock_timeout) == 1 &&
-	    uxsock_timeout > DEFAULT_UXSOCK_TIMEOUT)
+	    uxsock_timeout > DEFAULT_REPLY_TIMEOUT)
 		conf->uxsock_timeout = uxsock_timeout;
 	else
-		conf->uxsock_timeout = DEFAULT_UXSOCK_TIMEOUT;
+		conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
 
 	free(buff);
 	return 0;
@@ -1146,9 +1147,6 @@ declare_ble_handler(elist_property)
 static int
 snprint_def_uxsock_timeout(char * buff, int len, void * data)
 {
-	if (conf->uxsock_timeout == DEFAULT_UXSOCK_TIMEOUT)
-		return 0;
-
 	return snprintf(buff, len, "%u", conf->uxsock_timeout);
 }
 
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 300d657..e91abd9 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -19,40 +19,11 @@
 #ifdef USE_SYSTEMD
 #include <systemd/sd-daemon.h>
 #endif
+#include <mpath_cmd.h>
 
 #include "memory.h"
 #include "uxsock.h"
 #include "debug.h"
-
-/*
- * connect to a unix domain socket
- */
-int ux_socket_connect(const char *name)
-{
-	int fd, len;
-	struct sockaddr_un addr;
-
-	memset(&addr, 0, sizeof(addr));
-	addr.sun_family = AF_LOCAL;
-	addr.sun_path[0] = '\0';
-	len = strlen(name) + 1 + sizeof(sa_family_t);
-	strncpy(&addr.sun_path[1], name, len);
-
-	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
-	if (fd == -1) {
-		condlog(3, "Couldn't create ux_socket, error %d", errno);
-		return -1;
-	}
-
-	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
-		condlog(3, "Couldn't connect to ux_socket, error %d", errno);
-		close(fd);
-		return -1;
-	}
-
-	return fd;
-}
-
 /*
  * create a unix domain socket and start listening on it
  * return a file descriptor open on the socket
@@ -165,7 +136,7 @@ ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
 /*
  * send a packet in length prefix format
  */
-int send_packet(int fd, const char *buf, size_t len)
+int send_packet(int fd, const char *buf)
 {
 	int ret = 0;
 	sigset_t set, old;
@@ -175,10 +146,7 @@ int send_packet(int fd, const char *buf, size_t len)
 	sigaddset(&set, SIGPIPE);
 	pthread_sigmask(SIG_BLOCK, &set, &old);
 
-	if (write_all(fd, &len, sizeof(len)) != sizeof(len))
-		ret = -1;
-	if (!ret && write_all(fd, buf, len) != len)
-		ret = -1;
+	ret = mpath_send_cmd(fd, buf);
 
 	/* And unblock it again */
 	pthread_sigmask(SIG_SETMASK, &old, NULL);
@@ -189,34 +157,23 @@ int send_packet(int fd, const char *buf, size_t len)
 /*
  * receive a packet in length prefix format
  */
-int recv_packet(int fd, char **buf, size_t *len, unsigned int timeout)
+int recv_packet(int fd, char **buf, unsigned int timeout)
 {
-	ssize_t ret;
-
-	ret = read_all(fd, len, sizeof(*len), timeout);
-	if (ret < 0) {
-		(*buf) = NULL;
-		*len = 0;
-		return ret;
-	}
-	if (ret < sizeof(*len)) {
-		(*buf) = NULL;
-		*len = 0;
-		return -EIO;
-	}
-	if (len == 0) {
-		(*buf) = NULL;
-		return 0;
-	}
-	(*buf) = MALLOC(*len);
+	int err;
+	ssize_t len;
+
+	*buf = NULL;
+	len = mpath_recv_reply_len(fd, timeout);
+	if (len <= 0)
+		return len;
+	(*buf) = MALLOC(len);
 	if (!*buf)
 		return -ENOMEM;
-	ret = read_all(fd, *buf, *len, timeout);
-	if (ret != *len) {
+	err = mpath_recv_reply_data(fd, *buf, len, timeout);
+	if (err) {
 		FREE(*buf);
 		(*buf) = NULL;
-		*len = 0;
-		return ret < 0 ? ret : -EIO;
+		return err;
 	}
 	return 0;
 }
diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h
index 94af8d8..c1cf81f 100644
--- a/libmultipath/uxsock.h
+++ b/libmultipath/uxsock.h
@@ -1,7 +1,6 @@
 /* some prototypes */
-int ux_socket_connect(const char *name);
 int ux_socket_listen(const char *name);
-int send_packet(int fd, const char *buf, size_t len);
-int recv_packet(int fd, char **buf, size_t *len, unsigned int timeout);
+int send_packet(int fd, const char *buf);
+int recv_packet(int fd, char **buf, unsigned int timeout);
 size_t write_all(int fd, const void *buf, size_t len);
 ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout);
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index ad8e607..6f7a5cf 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -5,7 +5,7 @@ include ../Makefile.inc
 OBJS = main.o 
 
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) 
-LDFLAGS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -lmultipath -ludev
+LDFLAGS += -lpthread -ldevmapper -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -L$(mpathcmddir) -lmpathcmd -lmultipath -ludev
 
 EXEC = mpathpersist
 
diff --git a/multipath/Makefile b/multipath/Makefile
index 4b3de81..b5bcb3b 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -6,8 +6,9 @@ include ../Makefile.inc
 
 OBJS = main.o
 
-CFLAGS += -I$(multipathdir)
-LDFLAGS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev
+CFLAGS += -I$(multipathdir) -I$(mpathcmddir)
+LDFLAGS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev \
+	-L$(mpathcmddir) -lmpathcmd
 
 EXEC = multipath
 
diff --git a/multipath/main.c b/multipath/main.c
index d761621..decb590 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -57,6 +57,7 @@
 #include <sys/resource.h>
 #include <wwids.h>
 #include <uxsock.h>
+#include <mpath_cmd.h>
 
 int logsink;
 
@@ -633,13 +634,13 @@ main (int argc, char *argv[])
 	    conf->dev_type == DEV_UEVENT) {
 		int fd;
 
-		fd = ux_socket_connect(DEFAULT_SOCKET);
+		fd = mpath_connect();
 		if (fd == -1) {
 			printf("%s is not a valid multipath device path\n",
 				conf->dev);
 			goto out;
 		}
-		close(fd);
+		mpath_disconnect(fd);
 	}
 	if (conf->cmd == CMD_REMOVE_WWID && !conf->dev) {
 		condlog(0, "the -w option requires a device");
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 901d1e4..9b0210f 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -5,7 +5,7 @@ include ../Makefile.inc
 #
 # basic flags setting
 #
-CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
+CFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
 endif
@@ -18,7 +18,8 @@ ifdef SYSTEMD
 	endif
 endif
 LDFLAGS += -ludev -ldl \
-	-L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
+	-L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
+	-L$(mpathcmddir) -lmpathcmd
 
 #
 # debuging stuff
diff --git a/multipathd/main.c b/multipathd/main.c
index ea67324..f17b7da 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -21,6 +21,7 @@
 #include <systemd/sd-daemon.h>
 #endif
 #include <semaphore.h>
+#include <mpath_cmd.h>
 #include <mpath_persist.h>
 #include <time.h>
 
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 536579f..06c1bf8 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -18,6 +18,7 @@
 #include <readline/readline.h>
 #include <readline/history.h>
 
+#include <mpath_cmd.h>
 #include <uxsock.h>
 #include <memory.h>
 #include <defaults.h>
@@ -74,7 +75,6 @@ static void process(int fd, unsigned int timeout)
 	rl_readline_name = "multipathd";
 	rl_completion_entry_function = key_generator;
 	while ((line = readline("multipathd> "))) {
-		size_t len;
 		size_t llen = strlen(line);
 
 		if (!llen) {
@@ -85,8 +85,8 @@ static void process(int fd, unsigned int timeout)
 		if (need_quit(line, llen))
 			break;
 
-		if (send_packet(fd, line, llen + 1) != 0) break;
-		ret = recv_packet(fd, &reply, &len, timeout);
+		if (send_packet(fd, line) != 0) break;
+		ret = recv_packet(fd, &reply, timeout);
 		if (ret != 0) break;
 
 		print_reply(reply);
@@ -102,14 +102,13 @@ static void process(int fd, unsigned int timeout)
 static void process_req(int fd, char * inbuf, unsigned int timeout)
 {
 	char *reply;
-	size_t len;
 	int ret;
 
-	if (send_packet(fd, inbuf, strlen(inbuf) + 1) != 0) {
+	if (send_packet(fd, inbuf) != 0) {
 		printf("cannot send packet\n");
 		return;
 	}
-	ret = recv_packet(fd, &reply, &len, timeout);
+	ret = recv_packet(fd, &reply, timeout);
 	if (ret < 0) {
 		if (ret == -ETIMEDOUT)
 			printf("timeout receiving packet\n");
@@ -128,7 +127,7 @@ int uxclnt(char * inbuf, unsigned int timeout)
 {
 	int fd;
 
-	fd = ux_socket_connect(DEFAULT_SOCKET);
+	fd = mpath_connect();
 	if (fd == -1)
 		exit(1);
 
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 64bd35c..740d1e7 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -31,6 +31,7 @@
 #include <uxsock.h>
 #include <defaults.h>
 #include <config.h>
+#include <mpath_cmd.h>
 
 #include "main.h"
 #include "cli.h"
@@ -128,7 +129,6 @@ void uxsock_cleanup(void *arg)
 void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 {
 	int ux_sock;
-	size_t len;
 	int rlen, timeout;
 	char *inbuf;
 	char *reply;
@@ -236,18 +236,15 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				}
 				if (gettimeofday(&start_time, NULL) != 0)
 					start_time.tv_sec = 0;
-
-				if (recv_packet(c->fd, &inbuf, &len,
-						timeout) != 0) {
+				if (recv_packet(c->fd, &inbuf, timeout) != 0) {
 					dead_client(c);
 				} else {
-					inbuf[len - 1] = 0;
 					condlog(4, "Got request [%s]", inbuf);
 					uxsock_trigger(inbuf, &reply, &rlen,
 						       trigger_data);
 					if (reply) {
-						if (send_packet(c->fd, reply,
-								rlen) != 0) {
+						if (send_packet(c->fd,
+								reply) != 0) {
 							dead_client(c);
 						}
 						condlog(4, "Reply [%d bytes]",
-- 
1.8.3.1
