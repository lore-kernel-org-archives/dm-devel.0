From: mwilck@suse.com
Subject: [PATCH 09/11] multipath tools tests/Makefile: Fix
	OBJDEPS for hwtable-test
Date: Tue, 12 May 2020 00:39:29 +0200
Message-ID: <20200511223931.18261-10-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
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

OBJDEPS needs to list object files that _call_ functions we want
to wrap, but it should _not_ list the object files where these
functions are defined; otherwise the linker might resolve these
symbols before they can be wrapped.

(Observed on i586 with gcc 9.3.1, ld 2.34.0, where wrapping
prio_getprio() doesn't work with prio.o in OBJDEPS).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 028c9ea7..1b8706a7 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -41,7 +41,7 @@ endif
 dmevents-test_LIBDEPS = -lpthread -ldevmapper -lurcu
 hwtable-test_TESTDEPS := test-lib.o
 hwtable-test_OBJDEPS := ../libmultipath/discovery.o ../libmultipath/blacklist.o \
-	../libmultipath/prio.o ../libmultipath/callout.o ../libmultipath/structs.o
+	../libmultipath/structs.o
 hwtable-test_LIBDEPS := -ludev -lpthread -ldl
 blacklist-test_TESTDEPS := test-log.o
 blacklist-test_OBJDEPS := ../libmultipath/blacklist.o
-- 
2.26.2
