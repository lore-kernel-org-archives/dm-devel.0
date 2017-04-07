From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/9] libdmmp: minor Makefile cleanup
Date: Fri,  7 Apr 2017 01:16:30 -0500
Message-ID: <1491545798-22183-2-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

This patch deletes the "/" after $(DESTDIR) and removes
libdmmp_speed_test on 'make clean'

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libdmmp/Makefile      | 18 +++++++++---------
 libdmmp/test/Makefile |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 082078a..1c5329a 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -29,27 +29,27 @@ $(LIBS): $(OBJS)
 install:
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 644 -D \
-		$(HEADERS) $(DESTDIR)/$(includedir)/$(HEADERS)
-	$(LN) $(LIBS) $(DESTDIR)/$(syslibdir)/$(DEVLIB)
+		$(HEADERS) $(DESTDIR)$(includedir)/$(HEADERS)
+	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 	$(INSTALL_PROGRAM) -m 644 -D \
-		$(PKGFILE).in $(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
+		$(PKGFILE).in $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 	perl -i -pe 's|__VERSION__|$(LIBDMMP_VERSION)|g' \
-		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
+		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 	perl -i -pe 's|__LIBDIR__|$(syslibdir)|g' \
-		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
+		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 	perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
-		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
+		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 	@for file in docs/man/*.3.gz; do \
 		$(INSTALL_PROGRAM) -m 644 -D \
 			$$file \
-			$(DESTDIR)/$(man3dir)/ || exit $?; \
+			$(DESTDIR)$(man3dir)/ || exit $?; \
 	done
 
 uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(RM) $(DESTDIR)$(includedir)/$(HEADERS)
-	$(RM) $(DESTDIR)/$(syslibdir)/$(DEVLIB)
-	@for file in $(DESTDIR)/$(man3dir)/dmmp_*; do \
+	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	@for file in $(DESTDIR)$(man3dir)/dmmp_*; do \
 		$(RM) $$file; \
 	done
 	$(RM) $(DESTDIR)$(man3dir)/libdmmp.h*
diff --git a/libdmmp/test/Makefile b/libdmmp/test/Makefile
index 68f1af3..acfb3bf 100644
--- a/libdmmp/test/Makefile
+++ b/libdmmp/test/Makefile
@@ -27,4 +27,4 @@ speed_test: $(SPD_TEST_EXEC)
 		time -p ./$(SPD_TEST_EXEC)
 
 clean:
-	rm -f $(TEST_EXEC)
+	rm -f $(TEST_EXEC) $(SPD_TEST_EXEC)
-- 
1.8.3.1
