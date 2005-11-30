From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH RFC 4/4] Sample user space program (dm_nld)
Date: Wed, 30 Nov 2005 00:29:34 -0800
Message-ID: <20051130082934.GD18284@us.ibm.com>
References: <20051130082311.GA18453@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051130082311.GA18453@us.ibm.com>
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

 Sample program that receives dm netlink events and prints them out. This
 program uses the netlink library (libnl)
 http://people.suug.ch/~tgr/libnl/

 Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 Makefile |   31 ++++++++++++
 dm_nld.c |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 dm_nld.h |   53 +++++++++++++++++++++
 3 files changed, 243 insertions(+)

--- /dev/null	2005-11-13 12:06:42.576962000 -0800
+++ dm_nld/dm_nld.c	2005-11-29 21:03:14.000000000 -0800
@@ -0,0 +1,159 @@
+/*
+ * Device Mapper Netlink User Space Daemon (dm-nld)
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
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
+ * This program is a proto example of using the dm netlink interface
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <sys/socket.h>
+#include <sys/user.h>
+#include <asm/types.h>
+#include <linux/netlink.h>
+#include <time.h>
+#include "dm_nld.h"
+
+static struct nla_policy dm_e_attr_policy[DM_E_ATTR_MAX] = {
+	[DM_E_ATTR_SEQNUM]	= { .type = NLA_U64 },
+	[DM_E_ATTR_TSSEC]	= { .type = NLA_U64 },
+	[DM_E_ATTR_TSUSEC]	= { .type = NLA_U64 },
+	[DM_E_ATTR_DMNAME]	= { .type = NLA_STRING },
+	[DM_E_ATTR_BLKERR]	= { .type = NLA_U32 },
+};
+
+char * build_evt_msg(struct nlattr *dm_attr[])
+{
+	int n, size = 1024;
+	char *bmark, *str = NULL;
+
+	str = calloc(1, size);
+	if (!str)
+		goto out;
+	bmark = str;
+
+	n = snprintf(bmark, size, "[Event]:");
+	size -= n;
+	bmark += n;
+
+	if (dm_attr[DM_E_ATTR_SEQNUM] && size) {
+		n = snprintf(bmark, size, " SEQNUM: %" PRIu64,
+			     nla_get_u64(dm_attr[DM_E_ATTR_SEQNUM]));
+		size -= n;
+		bmark += n;
+	}
+
+	if (dm_attr[DM_E_ATTR_TSSEC] && size) {
+		const time_t t = nla_get_u64(dm_attr[DM_E_ATTR_TSSEC]),
+		n = snprintf(bmark, size, ", Time: %s", ctime(&t));
+		size -= n;
+		bmark += n - 1;
+	}
+
+	if (dm_attr[DM_E_ATTR_DMNAME] && size) {
+		n = snprintf(bmark, size, ", DMNAME: %s", (char *)
+			     nla_data(dm_attr[DM_E_ATTR_DMNAME]));
+		size -= n;
+		bmark += n;
+	}
+
+	if (dm_attr[DM_E_ATTR_BLKERR] && size) {
+		n = snprintf(bmark, size, ", BLKERR: 0x%x",
+			     nla_get_u32(dm_attr[DM_E_ATTR_BLKERR]));
+	}
+
+out:
+	return str;
+}
+
+int main (int argc, char *argv[])
+{
+	int err = -1;
+	struct sockaddr_nl addr;
+	struct nlmsghdr *nlh;
+	struct dm_nl_msghdr *dm_nlh;
+	unsigned char *msg;
+	char *evt_str = NULL;
+	struct nlattr *dm_attr[DM_E_ATTR_MAX];
+
+	struct nl_handle *handle;
+
+	handle = nl_handle_alloc();
+	if (!handle)
+		goto handle_out;
+
+	nl_disable_sequence_check(handle);
+
+	err = nl_connect(handle, NETLINK_DM);
+	if (err < 0)
+		goto connect_out;
+
+	err = nl_send_simple(handle, NLMSG_NOOP, 0, NULL, 0);
+	if (err < 0)
+		goto simple_out;
+
+	memset(&addr, 0, sizeof(addr));
+	addr.nl_family = AF_NETLINK;
+	addr.nl_pid = 0;
+	addr.nl_groups = 0;
+
+	do {
+		err = nl_recv(handle, &addr, &msg);
+		if (err <= 0)
+			break;
+		nlh = (struct nlmsghdr *) msg;
+		fprintf(stdout, "Msg Type: %d Recevied\n",
+			nlh->nlmsg_type);
+		if (nlh->nlmsg_type == DM_EVT) {
+			dm_nlh = nlmsg_data(nlh);
+			fprintf(stdout, "Event Type: %d Version: %d\n",
+				dm_nlh->type, dm_nlh->version);
+			
+			err = nla_parse(dm_attr, DM_E_ATTR_MAX - 1,
+					nlmsg_attrdata(nlh, 
+						sizeof(struct dm_nl_msghdr)),
+					nlmsg_attrlen(nlh, 
+					      sizeof(struct dm_nl_msghdr)),
+					dm_e_attr_policy);
+			if (err < 0)
+				break;
+
+			evt_str = build_evt_msg(dm_attr);
+			if (evt_str)
+				fprintf(stdout, "%s\n", evt_str);
+		}
+
+		free(evt_str);
+		free(msg);
+	} while (1);
+
+simple_out:
+	nl_close(handle);
+connect_out:
+	nl_handle_destroy(handle);
+handle_out:
+	exit(err == 0 ? 0 : 1);
+}
--- /dev/null	2005-11-13 12:06:42.576962000 -0800
+++ dm_nld/dm_nld.h	2005-11-23 01:23:56.000000000 -0800
@@ -0,0 +1,53 @@
+/*
+ * Device Mapper Netlink Daemon
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * 	Author: Mike Anderson <andmike@us.ibm.com>
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
+#ifndef DM_NLD_H
+#define DM_NLD_H
+#include <stdint.h>
+#include <netlink/attr.h>
+#include <netlink/msg.h>
+
+enum dm_evt_attr {
+	DM_E_ATTR_SEQNUM	= 1,
+	DM_E_ATTR_TSSEC		= 2,
+	DM_E_ATTR_TSUSEC	= 3,
+	DM_E_ATTR_DMNAME	= 4,
+	DM_E_ATTR_BLKERR	= 5,
+	DM_E_ATTR_MAX,
+};
+
+#ifndef NLMSG_MIN_TYPE
+#define NLMSG_MIN_TYPE 0x10
+#endif
+
+#define DM_EVT NLMSG_MIN_TYPE + 0x1
+
+#define DM_EVT_FAIL_PATH 0x1
+#define DM_EVT_REINSTATE_PATH 0x2
+
+struct dm_nl_msghdr {
+	uint16_t type;
+	uint16_t version;
+	uint16_t reserved1;
+	uint16_t reserved2;
+} __attribute__((aligned(sizeof(uint64_t))));
+
+#endif /* DM_NLD_H */
--- /dev/null	2005-11-13 12:06:42.576962000 -0800
+++ dm_nld/Makefile	2005-11-23 01:37:40.000000000 -0800
@@ -0,0 +1,31 @@
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
+CFLAGS		+= -DNETLINK_DM=17
+
+LDFLAGS		= -lnl
+ifeq ($(strip $(DEBUG)),true)
+CFLAGS		+= -O1 -g
+else
+CFLAGS		+= -Os
+endif
+
+PROGRAM	= dm_nld
+
+all: $(PROGRAM)
+
+dm_evtd: dm_nld.o
+	$(CC) $^ -o $@
+
+clean:
+	rm -f *.o $(PROGRAM)
