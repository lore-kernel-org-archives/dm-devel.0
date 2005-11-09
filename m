From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH RFC 2/2] user space program for dm-evt netlink
	messages
Date: Tue, 8 Nov 2005 23:57:44 -0800
Message-ID: <20051109075744.GC11492@us.ibm.com>
References: <20051109075423.GA11492@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051109075423.GA11492@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

 This patch adds a user space program the listens for netlink messages
 sent by the dm-mp dm_evt hardware handler.

 Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 ---

 Makefile  |   30 ++++++++++
 dm_evtd.c |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 dm_evtd.h |   46 ++++++++++++++++
 3 files changed, 253 insertions(+)

--- /dev/null	2005-11-08 02:47:22.640591000 -0800
+++ dm_evtd/dm_evtd.c	2005-11-07 13:04:02.000000000 -0800
@@ -0,0 +1,177 @@
+/*
+ * Device Mapper Event User Space Daemon (dm-evtd)
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * Copyright (C) 2005 Mike Anderson <andmike@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+/*
+ * This program is a proto example of using the dm-evt hardward handler
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/socket.h>
+#include <sys/user.h>
+#include <asm/types.h>
+#include <linux/netlink.h>
+#include <time.h>
+#include "dm_evtd.h"
+
+static int socket_open(int *sock)
+{
+	struct sockaddr_nl snl;
+	int err = -1;
+
+	memset(&snl, 0x00, sizeof(snl));
+	snl.nl_family = AF_NETLINK;
+	snl.nl_pid = getpid();
+	snl.nl_groups = 0; /* not in mcast groups */
+
+	*sock = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_DM_EVENT);
+	if (*sock == -1) {
+		fprintf(stderr, "%s: socket failed (%s)\n", __FUNCTION__,
+			strerror(errno));
+		goto sock_failed;
+	}
+
+	err = bind(*sock, (struct sockaddr *) &snl,
+		      sizeof(snl));
+	if (err < 0) {
+		fprintf(stderr, "%s: bind failed (%s)\n", __FUNCTION__,
+		       strerror(errno));
+		goto bind_failed;
+	}
+
+	return err;
+bind_failed:
+	close(*sock);
+sock_failed:
+	return err;
+}
+
+static int evt_connect(int socket, unsigned short type)
+{
+	struct nlmsghdr *nlh;
+	struct sockaddr_nl addr;
+	struct msghdr msg;
+	struct iovec iov;
+	int err = -1;
+
+	nlh = calloc(1, sizeof(*nlh));
+	if (!nlh) {
+		fprintf(stderr, "%s: calloc failed (%s)\n", __FUNCTION__,
+			strerror(errno));
+		goto calloc_failed;
+	}
+
+	nlh->nlmsg_len = NLMSG_SPACE(0);
+	nlh->nlmsg_pid = getpid();
+	nlh->nlmsg_flags = 0;
+	nlh->nlmsg_type = type;
+
+	memset(&addr, 0, sizeof(addr));
+	addr.nl_family = AF_NETLINK;
+	addr.nl_pid = 0;
+	addr.nl_groups = 0;
+
+	iov.iov_base = (void*)nlh;
+	iov.iov_len = nlh->nlmsg_len;
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_name= (void*)&addr;
+	msg.msg_namelen = sizeof(addr);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	err = sendmsg(socket, &msg, 0);
+
+	if (err <= 0)
+		fprintf(stderr, "%s: sendmsg failed (%s)\n", __FUNCTION__,
+			strerror(errno));
+
+calloc_failed:
+	return err;
+}
+
+static int evt_read(int socket, char *data, int count, int flags)
+{
+	int err;
+	struct iovec iov;
+	static struct sockaddr_nl addr;
+	struct msghdr msg;
+
+	iov.iov_base = data;
+	iov.iov_len = count;
+	memset(iov.iov_base, 0, iov.iov_len);
+
+	memset(&addr, 0, sizeof(addr));
+	addr.nl_family = AF_NETLINK;
+	addr.nl_pid = 0;
+	addr.nl_groups = 0;
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_name= (void*)&addr;
+	msg.msg_namelen = sizeof(addr);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	err = recvmsg(socket, &msg, flags);
+	if (err <= 0) {
+		fprintf(stderr, "%s: recvmsg failed (%s)\n", __FUNCTION__,
+			strerror(errno));
+	}
+
+	return err;
+}
+
+int main (int argc, char *argv[])
+{
+	int err, socket = -1;
+	void *msg;
+	struct dm_evt_msg *evt_msg;
+	struct nlmsghdr *nlh;
+
+	err = socket_open(&socket);
+	if (err)
+		exit(1);
+	err = evt_connect(socket, NLMSG_NOOP);
+
+	msg = calloc(1, NLMSG_SPACE(sizeof(struct dm_evt_msg)));
+	do {
+		err = evt_read(socket, msg, 
+			       NLMSG_SPACE(sizeof(struct dm_evt_msg)),
+			       0);
+		if (err <= 0)
+			break;
+		nlh = (struct nlmsghdr *)msg;
+		evt_msg = NLMSG_DATA(nlh);
+
+		fprintf(stdout,"[DM_EVT]: dm_name: %s, blk_err: 0x%x,"
+			" Time: %s", evt_msg->dm_name,
+			evt_msg->u.patherr.blk_err, 
+			ctime((time_t *)&evt_msg->tv_sec));
+
+		bzero(msg, NLMSG_SPACE(sizeof(struct dm_evt_msg)));
+	} while (1);
+
+	exit(err == 0 ? 0 : 1);
+}
--- /dev/null	2005-11-08 02:47:22.640591000 -0800
+++ dm_evtd/dm_evtd.h	2005-11-07 11:42:41.000000000 -0800
@@ -0,0 +1,46 @@
+/*
+ * Device Mapper Event Handler
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * Copyright (C) 2005 Mike Anderson <andmike@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+#ifndef DM_EVENT_H
+#define DM_EVENT_H
+#include <stdint.h>
+
+#define EVT_DM_NAME_LEN 16
+
+#define DM_EVENT_BASE	10
+enum dm_evt_e {
+	DM_EVENT_UNKOWN		= 0,
+	DM_EVENT_PATH_ERR	= DM_EVENT_BASE + 1,
+};
+
+struct dm_evt_msg {
+	uint8_t dm_name[EVT_DM_NAME_LEN];
+	uint64_t tv_sec;
+	uint64_t tv_usec;
+
+	union {
+		struct msg_path_err {
+			uint32_t blk_err; /* BLKERR Values */
+		} patherr;
+	} u;
+} __attribute__((aligned(sizeof(uint64_t))));
+
+#endif
--- /dev/null	2005-11-08 02:47:22.640591000 -0800
+++ dm_evtd/Makefile	2005-11-08 22:13:36.000000000 -0800
@@ -0,0 +1,30 @@
+# Make variables (CC, etc...)
+AS              = $(CROSS_COMPILE)as
+LD              = $(CROSS_COMPILE)ld
+CC              = $(CROSS_COMPILE)gcc
+CPP             = $(CC) -E
+AR              = $(CROSS_COMPILE)ar
+NM              = $(CROSS_COMPILE)nm
+STRIP           = $(CROSS_COMPILE)strip
+OBJCOPY         = $(CROSS_COMPILE)objcopy
+OBJDUMP         = $(CROSS_COMPILE)objdump
+
+CFLAGS		+= -fno-builtin -Wall -Wchar-subscripts -Wundef \
+		   -Wstrict-prototypes -Wpointer-arith -Wsign-compare
+CFLAGS		+= -DNETLINK_DM_EVENT=17
+
+ifeq ($(strip $(DEBUG)),true)
+CFLAGS		+= -O1 -g
+else
+CFLAGS		+= -Os
+endif
+
+PROGRAM	= dm_evtd
+
+all: $(PROGRAM)
+
+dm_evtd: dm_evtd.o
+	$(CC) $^ -o $@
+
+clean:
+	rm -f *.o $(PROGRAM)
