From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/13] multipathd: switch to socket activation
	for systemd
Date: Fri, 15 Nov 2013 11:29:37 +0100
Message-ID: <1384511384-27642-7-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

multipathd already has a netlink socket for CLI commands, which
can be used for socket activation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/Makefile         |  2 +-
 libmultipath/uxsock.c         | 24 +++++++++++++++++++++---
 multipathd/Makefile           |  4 +++-
 multipathd/multipathd.service |  7 +++----
 multipathd/multipathd.socket  |  5 +++++
 multipathd/uxclnt.c           |  4 +---
 multipathd/uxlsnr.c           |  4 +---
 7 files changed, 35 insertions(+), 15 deletions(-)
 create mode 100644 multipathd/multipathd.socket

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index ae1d8a3..c28413c 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -7,7 +7,7 @@ include ../Makefile.inc
 SONAME=0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
-LIBDEPS = -lpthread -ldl -ldevmapper -ludev
+LIBDEPS = -lpthread -ldl -ldevmapper -lsystemd-daemon -ludev
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index fcad56e..58f0bca 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -16,9 +16,11 @@
 #include <sys/poll.h>
 #include <signal.h>
 #include <errno.h>
+#include <systemd/sd-daemon.h>
 
 #include "memory.h"
 #include "uxsock.h"
+#include "debug.h"
 
 /*
  * connect to a unix domain socket
@@ -36,10 +38,12 @@ int ux_socket_connect(const char *name)
 
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1) {
+		condlog(3, "Couldn't create ux_socket, error %d", errno);
 		return -1;
 	}
 
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
+		condlog(3, "Couldn't connect to ux_socket, error %d", errno);
 		close(fd);
 		return -1;
 	}
@@ -53,11 +57,24 @@ int ux_socket_connect(const char *name)
  */
 int ux_socket_listen(const char *name)
 {
-	int fd, len;
+	int fd, len, num;
 	struct sockaddr_un addr;
 
+	num = sd_listen_fds(0);
+	if (num > 1) {
+		condlog(3, "sd_listen_fds returned %d fds", num);
+		return -1;
+	} else if (num == 1) {
+		fd = SD_LISTEN_FDS_START + 0;
+		condlog(3, "using fd %d from sd_listen_fds", fd);
+		return fd;
+	}
+
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
-	if (fd == -1) return -1;
+	if (fd == -1) {
+		condlog(3, "Couldn't create ux_socket, error %d", errno);
+		return -1;
+	}
 
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_LOCAL;
@@ -66,15 +83,16 @@ int ux_socket_listen(const char *name)
 	strncpy(&addr.sun_path[1], name, len);
 
 	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
+		condlog(3, "Couldn't bind to ux_socket, error %d", errno);
 		close(fd);
 		return -1;
 	}
 
 	if (listen(fd, 10) == -1) {
+		condlog(3, "Couldn't listen to ux_socket, error %d", errno);
 		close(fd);
 		return -1;
 	}
-
 	return fd;
 }
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index b490c1d..f9801b0 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -6,7 +6,7 @@ include ../Makefile.inc
 # basic flags setting
 #
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
-LDFLAGS += -lpthread -ldevmapper -lreadline -ludev -ldl \
+LDFLAGS += -lpthread -ldevmapper -lreadline -lsystemd-daemon -ludev -ldl \
 	   -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
 
 #
@@ -37,6 +37,7 @@ install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(rcdir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(unitdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DESTDIR)$(unitdir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
@@ -45,6 +46,7 @@ uninstall:
 	rm -f $(DESTDIR)$(rcdir)/$(EXEC)
 	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm -f $(DESTDIR)$(unitdir)/$(EXEC).service
+	rm -f $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean:
 	rm -f core *.o $(EXEC) *.gz
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index d6da067..bc62bc5 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -6,11 +6,10 @@ DefaultDependencies=no
 Conflicts=shutdown.target
 
 [Service]
-Type=forking
-PIDFile=/var/run/multipathd.pid
-ExecStart=/sbin/multipathd
+ExecStart=/sbin/multipathd -d
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
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 3e4e381..e86be21 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -121,10 +121,8 @@ int uxclnt(char * inbuf)
 	int fd;
 
 	fd = ux_socket_connect(DEFAULT_SOCKET);
-	if (fd == -1) {
-		perror("ux_socket_connect");
+	if (fd == -1)
 		exit(1);
-	}
 
 	if (inbuf)
 		process_req(fd, inbuf);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index c0ddd8d..ed8e012 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -112,10 +112,8 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 
 	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
 
-	if (ux_sock == -1) {
-		condlog(0, "ux_socket_listen error");
+	if (ux_sock == -1)
 		exit(1);
-	}
 
 	pthread_cleanup_push(uxsock_cleanup, NULL);
 
-- 
1.8.1.4
