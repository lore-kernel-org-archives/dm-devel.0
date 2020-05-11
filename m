From: Lars Wendler <polynomial-c@gentoo.org>
Subject: [PATCH] (resent) multipath-tools: Fix parallel make
	issues
Date: Mon, 11 May 2020 12:09:12 +0200
Message-ID: <20200511100911.3561-1-polynomial-c@gentoo.org>
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
To: dm-devel@redhat.com
Cc: Lars Wendler <polynomial-c@gentoo.org>
List-Id: dm-devel.ids

build is broken like this (tested with -j16):

  x86_64-pc-linux-gnu-gcc -Wl,-O1 -Wl,--hash-style=gnu -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -shared -lpthread -ldevmapper -ldl -L../libmultipath -lmultipath -L../libmpathcmd -lmpathcmd -Wl,-soname=libmpathpersist.so.0 -o libmpathpersist.so.0 mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
  building defaults.o because of defaults.c
  ...
  /usr/lib/gcc/x86_64-pc-linux-gnu/9.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lmultipath
  collect2: error: ld returned 1 exit status
  make[1]: *** [Makefile:17: libmpathpersist.so.0] Error 1
  make: *** [Makefile:29: libmpathpersist] Error 2
  make: *** Waiting for unfinished jobs....

install is broken like this:

  install -m 755 libprio*.so /var/tmp/portage/sys-fs/multipath-tools-0.8.4/image/lib64/multipath
  install -m 755 libcheckcciss_tur.so libcheckreadsector0.so libchecktur.so libcheckdirectio.so libcheckemc_clariion.so libcheckhp_sw.so libcheckrdac.so /var/tmp/portage/sys-fs/multipath-tools-0.8.4/image/lib64/multipath
  ...
  /usr/bin/install: target '/var/tmp/portage/sys-fs/multipath-tools-0.8.4/image/lib64/multipath' is not a directory
  /usr/bin/install: target '/var/tmp/portage/sys-fs/multipath-tools-0.8.4/image/lib64/multipath' is not a directory
  make[1]: *** [Makefile:28: install] Error 1
  make[1]: *** [Makefile:38: install] Error 1
---
 Makefile                           | 3 ++-
 libmultipath/checkers/Makefile     | 1 +
 libmultipath/foreign/Makefile      | 1 +
 libmultipath/prioritizers/Makefile | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1dee3680..a9ade94f 100644
--- a/Makefile
+++ b/Makefile
@@ -29,7 +29,8 @@ $(BUILDDIRS):
 	$(MAKE) -C $@
 
 multipath multipathd mpathpersist: libmultipath
-mpathpersist:  libmpathpersist
+libmpathpersist: libmultipath
+mpathpersist:  libmultipath libmpathpersist
 
 $(BUILDDIRS.clean):
 	$(MAKE) -C ${@:.clean=} clean
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 02caea64..f201ca4c 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -24,6 +24,7 @@ libcheck%.so: libsg.o %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
 install:
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
 
 uninstall:
diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
index fae58a0d..567deebd 100644
--- a/libmultipath/foreign/Makefile
+++ b/libmultipath/foreign/Makefile
@@ -14,6 +14,7 @@ libforeign-%.so: %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
 install:
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
 
 uninstall:
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 9d0fe03c..b0b0b522 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -35,6 +35,7 @@ libprio%.so: %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
 install: $(LIBS)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
 	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
 
 uninstall:
-- 
2.26.2
