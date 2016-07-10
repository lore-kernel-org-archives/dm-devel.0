From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: clean stealth whitespaces
	for the rest
Date: Sun, 10 Jul 2016 12:28:17 +0200
Message-ID: <1468146497-8170-3-git-send-email-xose.vazquez@gmail.com>
References: <1468146497-8170-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468146497-8170-1-git-send-email-xose.vazquez@gmail.com>
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
 Makefile.inc           | 1 -
 kpartx/kpartx.8        | 1 -
 kpartx/kpartx.rules    | 2 --
 multipath/02_multipath | 1 -
 multipathd/Makefile    | 1 -
 5 files changed, 6 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index b7077fc..9eb0d4c 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -67,4 +67,3 @@ SHARED_FLAGS = -shared
 
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
-
diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 11141f3..4c55831 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -71,4 +71,3 @@ kpartx \-d disk.img
 This man page was assembled By Patrick Caulfield
 for the Debian project. From documentation provided
 by the multipath author Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
-
diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index f6a3706..8858a60 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -41,5 +41,3 @@ ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
         RUN+="/sbin/kpartx -u -p -part /dev/$name"
 
 LABEL="kpartx_end"
-
-
diff --git a/multipath/02_multipath b/multipath/02_multipath
index adf9e64..523f0ef 100755
--- a/multipath/02_multipath
+++ b/multipath/02_multipath
@@ -30,4 +30,3 @@ if [ -f /etc/multipath.conf ]
 then
 	cp /etc/multipath.conf $INITRDDIR/etc/
 fi
-
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 1552458..092b74b 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -62,4 +62,3 @@ uninstall:
 
 clean:
 	$(RM) core *.o $(EXEC) *.gz
-
-- 
2.7.4
