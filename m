From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: [PATCH] multipath-tools: add library dependencies
Date: Sat, 21 Nov 2009 18:19:55 +0100
Message-ID: <20091121171955.GA15229@bogon.sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
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


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
attached patch adds dependent libraries when building the shared lib.
This allows other tools like dpkg-shlibdeps to deduce the needed
dependencies automatically.
Cheers,
 -- Guido

--ZGiS0Q5IWpPtfppv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0006-add-library-dependencies.patch"

From: =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Date: Sun, 30 Aug 2009 14:18:21 +0200
Subject: [PATCH] add library dependencies

---
 libmultipath/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 3f2a48d..ec1ab9f 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -7,6 +7,7 @@ include ../Makefile.inc
 SONAME=0d
 DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
+LIBDEPS = -lpthread -ldl -ldevmapper
 
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        hwtable.o blacklist.o util.o dmparser.o config.o \
@@ -25,7 +26,7 @@ endif
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
-	$(CC) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
+	$(CC) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
 	ln -sf $@ $(DEVLIB)
 
 install:
-- 

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--ZGiS0Q5IWpPtfppv--
