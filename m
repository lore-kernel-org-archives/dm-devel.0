From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: [PATCH] multipath-tools: add a soname to the library
Date: Sat, 21 Nov 2009 18:17:20 +0100
Message-ID: <20091121171720.GA15157@bogon.sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
attached patch adds a fake soname to the created lib making tools such
as lintian happy. I can keep this debian specific if need be but having
a soname certainly won't hurt.
Cheers,
 -- Guido

--sdtB3X0nJg68CQEu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0005-set-a-soname.patch"

From: =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Date: Sun, 30 Aug 2009 14:30:34 +0200
Subject: [PATCH] set a soname

---
 libmultipath/Makefile |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index d59e2f3..3f2a48d 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -4,7 +4,9 @@
 #
 include ../Makefile.inc
 
-LIBS = libmultipath.so
+SONAME=0d
+DEVLIB = libmultipath.so
+LIBS = $(DEVLIB).$(SONAME)
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \
@@ -23,7 +25,8 @@ endif
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
-	$(CC) $(SHARED_FLAGS) -Wl,-soname,$@ $(CFLAGS) -o $@ $(OBJS)
+	$(CC) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
+	ln -sf $@ $(DEVLIB)
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
@@ -34,4 +37,4 @@ uninstall:
 	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
 
 clean:
-	rm -f core *.a *.o *.gz *.so
+	rm -f core *.a *.o *.gz *.so *.so.*
-- 

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--sdtB3X0nJg68CQEu--
