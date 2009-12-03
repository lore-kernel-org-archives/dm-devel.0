From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: fix soname
Date: Wed, 2 Dec 2009 19:45:56 -0600
Message-ID: <20091203014555.GE2406@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I assume that the soname wasn't supposed to have a 'd' at the end.

-Ben

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-091202/libmultipath/Makefile
===================================================================
--- multipath-tools-091202.orig/libmultipath/Makefile
+++ multipath-tools-091202/libmultipath/Makefile
@@ -4,7 +4,7 @@
 #
 include ../Makefile.inc
 
-SONAME=0d
+SONAME=0
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 LIBDEPS = -lpthread -ldl -ldevmapper
