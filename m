From: Hannes Reinecke <hare@suse.de>
Subject: link against libsystemd, not libsystemd-daemon
Date: Thu, 13 Mar 2014 12:50:11 +0100
Message-ID: <1394711411-28933-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

With systemd version 210 libsystemd-daemon has been merged
into libsystemd.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/Makefile | 6 +++++-
 multipathd/Makefile   | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 6364364..4b4f707 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -9,7 +9,11 @@ DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 LIBDEPS = -lpthread -ldl -ldevmapper -ludev
 ifdef SYSTEMD
-	LIBDEPS += -lsystemd-daemon
+	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
+		LIBDEPS += -lsystemd
+	else
+		LIBDEPS += -lsystemd-daemon
+	endif
 endif
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 781122a..901d1e4 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -11,7 +11,11 @@ ifdef SYSTEMD
 endif
 LDFLAGS += -lpthread -ldevmapper -lreadline
 ifdef SYSTEMD
-	LDFLAGS += -lsystemd-daemon
+	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
+		LDFLAGS += -lsystemd
+	else
+		LDFLAGS += -lsystemd-daemon
+	endif
 endif
 LDFLAGS += -ludev -ldl \
 	-L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
-- 
1.8.1.4
