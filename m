From: mwilck@suse.com
Subject: [PATCH 3/4] tests/Makefile: add test_clean target
Date: Mon,  2 Mar 2020 23:20:24 +0100
Message-ID: <20200302222025.21022-4-mwilck@suse.com>
References: <20200302222025.21022-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200302222025.21022-1-mwilck@suse.com>
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

This is a convenience target to remove only the test output files.
It's useful for those tests which require root permissions to run,
as "make" doesn't delete the .out file if a test fails (we could
force "make" to do so, but we don't want to do that, because usually
we want to inspect the output file when a test has failed). With
test_clean, we can run "make" as normal user, then "make test_clean"
and finally run "make" as root again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/Makefile b/tests/Makefile
index 5f6583a0..77ff3249 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -67,8 +67,11 @@ lib/libchecktur.so:
 
 OBJS = $(TESTS:%=%.o) test-lib.o
 
-clean: dep_clean
-	$(RM) $(TESTS:%=%-test) $(TESTS:%=%.out) $(OBJS) *.o.wrap
+test_clean:
+	$(RM) $(TESTS:%=%.out)
+
+clean: test_clean dep_clean
+	$(RM) $(TESTS:%=%-test) $(OBJS) *.o.wrap
 	$(RM) -rf lib
 
 .SECONDARY: $(OBJS)
-- 
2.25.0
