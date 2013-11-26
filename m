From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/9] multipathd: switch to socket activation for
	systemd
Date: Tue, 26 Nov 2013 12:41:25 +0100
Message-ID: <1385466090-24290-5-git-send-email-hare@suse.de>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1385466090-24290-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

multipathd already has a netlink socket for CLI commands, which
can be used for socket activation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Makefile.inc                  |  6 ++++++
 libmultipath/Makefile         |  6 ++++++
 libmultipath/uxsock.c         | 17 +++++++++++++++++
 multipathd/Makefile           | 12 ++++++++++--
 multipathd/multipathd.service |  8 ++++----
 multipathd/multipathd.socket  |  5 +++++
 6 files changed, 48 insertions(+), 6 deletions(-)
 create mode 100644 multipathd/multipathd.socket

diff --git a/Makefile.inc b/Makefile.inc
index 92d2289..7186484 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -21,6 +21,12 @@ ifndef LIB
 	endif
 endif
 
+ifndef SYSTEMD
+	ifeq ($(shell systemctl --version > /dev/null 2>&1 && echo 1), 1)
+		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\)/\1/p')
+	endif
+endif
+
 prefix      = 
 exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index f760f24..6364364 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -8,6 +8,9 @@ SONAME=0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 LIBDEPS = -lpthread -ldl -ldevmapper -ludev
+ifdef SYSTEMD
+	LIBDEPS += -lsystemd-daemon
+endif
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \
@@ -35,6 +38,9 @@ ifneq ($(strip $(LIBUDEV_API_RECVBUF)),0)
 	CFLAGS += -DLIBUDEV_API_RECVBUF
 endif
 
+ifdef SYSTEMD
+	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
+endif
 
 all: $(LIBS)
 
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index e93edff..aff7a62 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -16,6 +16,9 @@
 #include <sys/poll.h>
 #include <signal.h>
 #include <errno.h>
+#ifdef USE_SYSTEMD
+#include <systemd/sd-daemon.h>
+#endif
 
 #include "memory.h"
 #include "uxsock.h"
@@ -57,8 +60,22 @@ int ux_socket_connect(const char *name)
 int ux_socket_listen(const char *name)
 {
 	int fd, len;
+#ifdef USE_SYSTEMD
+	int num;
+#endif
 	struct sockaddr_un addr;
 
+#ifdef USE_SYSTEMD
+	num = sd_listen_fds(0);
+	if (num > 1) {
+		condlog(3, "sd_listen_fds returned %d fds", num);
+		return -1;
+	} else if (num == 1) {
+		fd = SD_LISTEN_FDS_START + 0;
+		condlog(3, "using fd %d from sd_listen_fds", fd);
+		return fd;
+	}
+#endif
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1) {
 		condlog(3, "Couldn't create ux_socket, error %d", errno);
diff --git a/multipathd/Makefile b/multipathd/Makefile
index b490c1d..3b9f2cf 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -6,8 +6,12 @@ include ../Makefile.inc
 # basic flags setting
 #
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
-LDFLAGS += -lpthread -ldevmapper -lreadline -ludev -ldl \
-	   -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
+LDFLAGS += -lpthread -ldevmapper -lreadline
+ifdef SYSTEMD
+	LDFLAGS += -lsystemd-daemon
+endif
+LDFLAGS += -ludev -ldl \
+	-L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
 
 #
 # debuging stuff
@@ -35,8 +39,11 @@ install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(rcdir)
+ifdef SYSTEMD
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(unitdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DESTDIR)$(unitdir)
+endif
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
@@ -45,6 +52,7 @@ uninstall:
 	rm -f $(DESTDIR)$(rcdir)/$(EXEC)
 	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm -f $(DESTDIR)$(unitdir)/$(EXEC).service
+	rm -f $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean:
 	rm -f core *.o $(EXEC) *.gz
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index d6da067..ec38ef1 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -6,11 +6,11 @@ DefaultDependencies=no
 Conflicts=shutdown.target
 
 [Service]
-Type=forking
-PIDFile=/var/run/multipathd.pid
-ExecStart=/sbin/multipathd
+ExecStartPre=/sbin/modprobe dm-multipath
+ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
-#ExecStop=/path/to/scrip delete-me if not necessary
+ExecStop=/sbin/multipathd shutdown
 
 [Install]
 WantedBy=sysinit.target
+Also=multipathd.socket
diff --git a/multipathd/multipathd.socket b/multipathd/multipathd.socket
new file mode 100644
index 0000000..3d4b6da
--- /dev/null
+++ b/multipathd/multipathd.socket
@@ -0,0 +1,5 @@
+[Socket]
+ListenStream=@/org/kernel/linux/storage/multipathd
+
+[Install]
+WantedBy=sockets.target
-- 
1.8.1.4
