From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/19] tests/hwtable: set multipath_dir in local
	configuration
Date: Wed, 21 Nov 2018 11:18:21 +0100
Message-ID: <20181121101839.30784-2-mwilck@suse.com>
References: <20181121101839.30784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181121101839.30784-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If internal libmultipath APIs change (such as, recently, the
checker API), test programs will fail because they'll link
with the standard system prioritizer / checker / foreign APIs.

Make sure we always link with our own shared libraries.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile  | 7 ++++++-
 tests/hwtable.c | 5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index b37b5027..ef900866 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -26,7 +26,11 @@ hwtable-test_LIBDEPS := -ludev -lpthread -ldl
 blacklist-test_OBJDEPS := ../libmultipath/blacklist.o
 blacklist-test_LIBDEPS := -ludev
 
-%.out:	%-test
+lib/libchecktur.so:
+	mkdir lib
+	ln -t lib ../libmultipath/{checkers,prioritizers,foreign}/*.so
+
+%.out:	%-test lib/libchecktur.so
 	@echo == running $< ==
 	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) ./$< >$@
 
@@ -34,6 +38,7 @@ OBJS = $(TESTS:%=%.o) test-lib.o
 
 clean: dep_clean
 	$(RM) $(TESTS:%=%-test) $(TESTS:%=%.out) $(OBJS)
+	$(RM) -rf lib
 
 .SECONDARY: $(OBJS)
 
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 9146ecc3..1cd788ac 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -250,14 +250,19 @@ static void write_defaults(const struct hwt_state *hwt)
 	static struct key_value defaults[] = {
 		{ "config_dir", NULL },
 		{ "bindings_file", NULL },
+		{ "multipath_dir", NULL },
 		{ "detect_prio", "no" },
 		{ "detect_checker", "no" },
 	};
 	char buf[sizeof(tmplate) + sizeof(bindings_name)];
+	char dirbuf[PATH_MAX];
 
 	snprintf(buf, sizeof(buf), "%s/%s", hwt->tmpname, bindings_name);
 	defaults[0].value = hwt->dirname;
 	defaults[1].value = buf;
+	assert_ptr_not_equal(getcwd(dirbuf, sizeof(dirbuf)), NULL);
+	strncat(dirbuf, "/lib", sizeof(dirbuf));
+	defaults[2].value = dirbuf;
 	write_section(hwt->config_file, "defaults",
 		      ARRAY_SIZE(defaults), defaults);
 }
-- 
2.19.1
