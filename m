From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: use "+=" instead of only "="
	for variables in Makefile
Date: Fri, 12 Aug 2016 19:45:01 +0200
Message-ID: <1471023901-12515-1-git-send-email-xose.vazquez@gmail.com>
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
 kpartx/Makefile       | 2 +-
 libmultipath/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 6f32680..8af0dc6 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -5,7 +5,7 @@ include ../Makefile.inc
 
 CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 
-LDFLAGS = -ldevmapper
+LDFLAGS += -ldevmapper
 
 LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie' /usr/include/libdevmapper.h)
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 3a20f8e..92f130c 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -9,7 +9,7 @@ LIBS = $(DEVLIB).$(SONAME)
 
 CFLAGS += -I$(mpathcmddir)
 
-LIBDEPS = -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
+LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd
 
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
-- 
2.7.4
