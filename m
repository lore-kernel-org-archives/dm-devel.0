From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/28] tests/Makefile: autogenerate list of
	symbols to be wrapped
Date: Fri,  8 Jun 2018 12:20:21 +0200
Message-ID: <20180608102041.22904-9-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Rather than manually listing all the -Wl,--wrap=... options, autogenerate
a list of functions to be wrapped in a cmocka test. Allowing this not only
for the test file itself but also for additional "test library" source files
requires some Makefile incantations.

Moreover, no need to list globals.c in dependencies, automatic dependency
tracking takes care for this (and avoids recompilation of tests that don't
pull in global.c).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/tests/Makefile b/tests/Makefile
index 1f364110..7439c8c3 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -10,23 +10,39 @@ TESTS := uevent parser util dmevents
 
 all:	$(TESTS:%=%.out)
 
-dmevents-test: dmevents.o ../multipathd/dmevents.c globals.c $(multipathdir)/libmultipath.so
-	@$(CC) -o $@ $< $(LDFLAGS) $(LIBDEPS) -lpthread -ldevmapper -lurcu -Wl,--wrap=open -Wl,--wrap=close -Wl,--wrap=dm_is_mpath -Wl,--wrap=dm_geteventnr -Wl,--wrap=ioctl -Wl,--wrap=libmp_dm_task_create -Wl,--wrap=dm_task_no_open_count -Wl,--wrap=dm_task_run -Wl,--wrap=dm_task_get_names -Wl,--wrap=dm_task_destroy -Wl,--wrap=poll -Wl,--wrap=remove_map_by_alias -Wl,--wrap=update_multipath
+# test-specific linker flags
+# XYZ-test-TESTDEPS: test libraries containing __wrap_xyz functions
+# XYZ-test_OBJDEPS: object files from libraries to link in explicitly
+#    That may be necessary if functions called from the object file are wrapped
+#    (wrapping works only for symbols which are undefined after processing a
+#    linker input file).
+# XYZ-test_LIBDEPS: Additional libs to link for this test
 
-%-test:	%.o globals.c $(multipathdir)/libmultipath.so
-	@$(CC) -o $@ $< $(LDFLAGS) $(LIBDEPS)
+dmevents-test_LIBDEPS = -lpthread -ldevmapper -lurcu
 
 %.out:	%-test
 	@echo == running $< ==
 	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) ./$< >$@
 
 clean: dep_clean
-	rm -f $(TESTS:%=%-test) $(TESTS:%=%.out) $(TESTS:%=%.o)
+	$(RM) $(TESTS:%=%-test) $(TESTS:%=%.out) $(OBJS)
 
-OBJS = $(TESTS:%=%.o)
 .SECONDARY: $(OBJS)
 
 include $(wildcard $(OBJS:.o=.d))
 
 dep_clean:
 	$(RM) $(OBJS:.o=.d)
+
+%.o.wrap:	%.c
+	@sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' $< | \
+		sort -u | tr '\n' ' ' >$@
+
+# COLON will get expanded during second expansion below
+COLON:=:
+.SECONDEXPANSION:
+%-test:	%.o %.o.wrap $$($$@_OBJDEPS) $$($$@_TESTDEPS) $$($$@_TESTDEPS$$(COLON).o=.o.wrap) \
+		$(multipathdir)/libmultipath.so Makefile
+	$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $< $($@_TESTDEPS) $($@_OBJDEPS) \
+		$(LIBDEPS) $($@_LIBDEPS) \
+		$(file <$<.wrap) $(foreach dep,$($@_TESTDEPS),$(file <$(dep).wrap))
-- 
2.17.0
