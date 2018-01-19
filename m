From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] multipath-tools: add dependency tracking to
	Makefiles
Date: Fri, 19 Jan 2018 01:19:44 +0100
Message-ID: <20180119001944.9565-3-mwilck@suse.com>
References: <20180119001944.9565-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119001944.9565-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore                         |  1 +
 Makefile.inc                       |  2 +-
 kpartx/Makefile                    |  7 ++++++-
 libdmmp/Makefile                   |  7 ++++++-
 libdmmp/test/Makefile              |  9 ++++++++-
 libmpathcmd/Makefile               | 10 ++++++++--
 libmpathpersist/Makefile           |  8 +++++++-
 libmultipath/Makefile              |  7 ++++++-
 libmultipath/checkers/Makefile     |  8 +++++++-
 libmultipath/prioritizers/Makefile |  8 +++++++-
 mpathpersist/Makefile              |  7 ++++++-
 multipath/Makefile                 |  7 ++++++-
 multipathd/Makefile                |  7 ++++++-
 tests/Makefile                     |  9 ++++++++-
 14 files changed, 83 insertions(+), 14 deletions(-)

diff --git a/.gitignore b/.gitignore
index 371b8758c0a1..35c59a7e2d51 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,6 +5,7 @@
 *.so.0
 *.a
 *.gz
+*.d
 kpartx/kpartx
 multipath/multipath
 multipathd/multipathd
diff --git a/Makefile.inc b/Makefile.inc
index d82d3b5df3fe..eb99c36010c1 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -91,7 +91,7 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  --param=ssp-buffer-size=4
 
 CFLAGS		:= $(OPTFLAGS) -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
-		   $(CFLAGS)
+		   -MMD -MP $(CFLAGS)
 BIN_CFLAGS	= -fPIE -DPIE
 LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
diff --git a/kpartx/Makefile b/kpartx/Makefile
index bf7362d95efd..7eb467ee3efb 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -44,5 +44,10 @@ uninstall:
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/67-kpartx-compat.rules
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
 
-clean:
+clean: dep_clean
 	$(RM) core *.o $(EXEC) *.gz
+
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index bf231ace1a1b..1dd3f34069b9 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -56,11 +56,13 @@ uninstall:
 	$(RM) $(DESTDIR)$(man3dir)/libdmmp.h*
 	$(RM) $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 
-clean:
+clean: dep_clean
 	$(RM) core *.a *.o *.gz *.so *.so.*
 	$(RM) -r docs/man
 	$(MAKE) -C test clean
 
+include $(wildcard $(OBJS:.o=.d))
+
 check: all
 	$(MAKE) -C test check
 
@@ -84,3 +86,6 @@ docs/man/$(EXTRA_MAN_FILES).gz: $(HEADERS)
 		gzip -f $$file; \
 	done
 	find docs/man -type f -name \*[0-9].gz
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libdmmp/test/Makefile b/libdmmp/test/Makefile
index acfb3bffb7f5..20b394587c4a 100644
--- a/libdmmp/test/Makefile
+++ b/libdmmp/test/Makefile
@@ -26,5 +26,12 @@ speed_test: $(SPD_TEST_EXEC)
 	sudo env LD_LIBRARY_PATH=$(_libdmmpdir):$(_mpathcmddir) \
 		time -p ./$(SPD_TEST_EXEC)
 
-clean:
+clean: dep_clean
 	rm -f $(TEST_EXEC) $(SPD_TEST_EXEC)
+
+OBJS = $(TEST_EXEC).o $(SPD_TEST_EXEC).o
+include $(wildcard $(OBJS:.o=.d))
+
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 4f321017361d..53c08992420b 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -26,5 +26,11 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(RM) $(DESTDIR)$(includedir)/mpath_cmd.h
 
-clean:
-	$(RM) core *.a *.o *.so *.so.* *.gz
+clean: dep_clean
+	$(RM) core *.a *.o *.so *.so.* *.gz 
+
+include $(wildcard $(OBJS:.o=.d))
+
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 1b4ec16a18f7..21fdad805f10 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -37,5 +37,11 @@ uninstall:
 	$(RM) $(DESTDIR)$(includedir)/mpath_persist.h
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
-clean:
+clean: dep_clean
 	$(RM) core *.a *.o *.so *.so.* *.gz
+
+include $(wildcard $(OBJS:.o=.d))
+
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 6447d8dafb4f..25b052729d48 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -61,5 +61,10 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
-clean:
+clean: dep_clean
 	$(RM) core *.a *.o *.so *.so.* *.gz
+
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index bce6b8b7be75..9559038a770d 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -36,5 +36,11 @@ install:
 uninstall:
 	for file in $(LIBS); do $(RM) $(DESTDIR)$(libdir)/$$file; done
 
-clean:
+clean: dep_clean
 	$(RM) core *.a *.o *.gz *.so
+
+OBJS := $(LIBS:libcheck%.so=%.o) libsg.o directio.o
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 0c71e6334473..b3cc944c810d 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -38,5 +38,11 @@ install: $(LIBS)
 uninstall:
 	for file in $(LIBS); do $(RM) $(DESTDIR)$(libdir)/$$file; done
 
-clean:
+clean: dep_clean
 	$(RM) core *.a *.o *.gz *.so
+
+OBJS = $(LIBS:libprio%.so=%.o) alua_rtpg.o
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 6e5acd3b751e..51268010b31d 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -22,9 +22,14 @@ install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
 
-clean:
+clean: dep_clean
 	$(RM) core *.o $(EXEC) *.gz
 
+include $(wildcard $(OBJS:.o=.d))
+
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/multipath/Makefile b/multipath/Makefile
index 468c056d49d0..654568af3576 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -37,5 +37,10 @@ uninstall:
 	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
 	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
 
-clean:
+clean: dep_clean
 	$(RM) core *.o $(EXEC) *.gz
+
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/multipathd/Makefile b/multipathd/Makefile
index e6f140bf3b91..251690ec5e2a 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -49,5 +49,10 @@ uninstall:
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
-clean:
+clean: dep_clean
 	$(RM) core *.o $(EXEC) *.gz
+
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/tests/Makefile b/tests/Makefile
index ff58cb8bb207..f6b55836a434 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -17,7 +17,14 @@ TESTS := uevent
 
 all:	$(TESTS:%=%.out)
 
-clean:
+clean: dep_clean
 	rm -f $(TESTS:%=%-test) $(TESTS:%=%.out) $(TESTS:%=%.o)
 
+OBJS = $(TESTS:%=%.o)
+include $(wildcard $(OBJS:.o=.d))
 
+
+
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
-- 
2.15.1
