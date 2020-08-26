From: mwilck@suse.com
Subject: [PATCH v2 02/10] multipath-tools: Makefile: add
	"valgrind-test" target
Date: Wed, 26 Aug 2020 11:58:59 +0200
Message-ID: <20200826095907.5576-3-mwilck@suse.com>
References: <20200826095907.5576-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200826095907.5576-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The new target "valgrind-test" (or "valgrind" in the tests/
subdirectory) allows running the unit tests under valgrind.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile        |  3 +++
 tests/Makefile  | 13 +++++++++++--
 tests/README.md |  8 ++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 8bcaba6..4a3491d 100644
--- a/Makefile
+++ b/Makefile
@@ -52,6 +52,9 @@ uninstall: $(BUILDDIRS:=.uninstall)
 test:	all
 	$(MAKE) -C tests
 
+valgrind-test:	all
+	$(MAKE) -C tests valgrind
+
 .PHONY:	TAGS
 TAGS:
 	etags -a libmultipath/*.c
diff --git a/tests/Makefile b/tests/Makefile
index 5f00a3a..502377f 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -19,6 +19,7 @@ TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
 .PRECIOUS: $(TESTS:%=%-test)
 
 all:	$(TESTS:%=%.out)
+valgrind:	$(TESTS:%=%.vgr)
 
 # test-specific compiler flags
 # XYZ-test_FLAGS: Additional compiler flags for this test
@@ -68,12 +69,20 @@ lib/libchecktur.so:
 	@echo == running $< ==
 	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) ./$< >$@
 
+%.vgr:  %-test lib/libchecktur.so
+	@echo == running valgrind for $< ==
+	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) \
+		valgrind --leak-check=full --error-exitcode=128 ./$< >$@ 2>&1
+
 OBJS = $(TESTS:%=%.o) test-lib.o
 
 test_clean:
-	$(RM) $(TESTS:%=%.out)
+	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr)
+
+valgrind_clean:
+	$(RM) $(TESTS:%=%.vgr)
 
-clean: test_clean dep_clean
+clean: test_clean valgrind_clean dep_clean
 	$(RM) $(TESTS:%=%-test) $(OBJS) *.o.wrap
 	$(RM) -rf lib
 
diff --git a/tests/README.md b/tests/README.md
index 6438a82..6e7ad40 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -5,6 +5,14 @@ or simply `make` in the `tests` subdirectory. The test output is saved as
 `<testname>.out`. The test programs are called `<testname>-test`, and can
 be run standalone e.g. for debugging purposes.
 
+## Running tests under valgrind
+
+The unit tests can be run under the valgrind debugger with `make valgrind`
+in the `tests` directory, or `make valgrind-test` in the top directory.
+If valgrind detects a bad memory access or leak, the test will fail. The
+output of the test run, including valgrind output, is stored as
+`<testname>.vgr`.
+
 ## Notes on individual tests
 
 ### Tests that require root permissions
-- 
2.28.0
