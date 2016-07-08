From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/3] multipath-tools: delete INSTALL_PROGRAM from
	libmpathpersist/Makefile
Date: Fri,  8 Jul 2016 18:28:21 +0200
Message-ID: <1467995301-14226-4-git-send-email-xose.vazquez@gmail.com>
References: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
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

It's already taken from "include ../Makefile.inc"

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 2f91401..a2dd7ed 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -3,8 +3,6 @@
 BUILD = glibc
 include ../Makefile.inc
 
-INSTALL_PROGRAM = install
-
 SONAME=0
 DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
-- 
2.7.4
