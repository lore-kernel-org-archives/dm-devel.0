From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/4] multipath-tools: build: prevent intermediate
	file deletion
Date: Thu,  8 Mar 2018 00:08:59 +0100
Message-ID: <20180307230859.14926-5-mwilck@suse.com>
References: <20180307230859.14926-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307230859.14926-1-mwilck@suse.com>
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

By default, "make" removes intermediate files from implicit rules
if they are the only dependency. Prevent that by using .SECONDARY.
Otherwise some files will be re-built upon second invocation of "make".

Fixes: e39283ebd79b "multipath-tools: add dependency tracking to Makefiles"
Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc                       | 1 +
 libmultipath/checkers/Makefile     | 2 ++
 libmultipath/foreign/Makefile      | 2 ++
 libmultipath/prioritizers/Makefile | 2 ++
 tests/Makefile                     | 5 ++---
 5 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index a5b9d4e3fa74..5d6123ded51a 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -127,4 +127,5 @@ check_file = $(shell	\
 	)
 
 %.o:	%.c
+	@echo building $@ because of $?
 	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 9559038a770d..87c15bd777c3 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -40,6 +40,8 @@ clean: dep_clean
 	$(RM) core *.a *.o *.gz *.so
 
 OBJS := $(LIBS:libcheck%.so=%.o) libsg.o directio.o
+.SECONDARY: $(OBJS)
+
 include $(wildcard $(OBJS:.o=.d))
 
 dep_clean:
diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
index dfba11e86d76..fe98ddf7e4e9 100644
--- a/libmultipath/foreign/Makefile
+++ b/libmultipath/foreign/Makefile
@@ -24,6 +24,8 @@ clean: dep_clean
 	$(RM) core *.a *.o *.gz *.so
 
 OBJS := $(LIBS:libforeign-%.so=%.o)
+.SECONDARY: $(OBJS)
+
 include $(wildcard $(OBJS:.o=.d))
 
 dep_clean:
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index b3cc944c810d..ab7bc07572ec 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -42,6 +42,8 @@ clean: dep_clean
 	$(RM) core *.a *.o *.gz *.so
 
 OBJS = $(LIBS:libprio%.so=%.o) alua_rtpg.o
+.SECONDARY: $(OBJS)
+
 include $(wildcard $(OBJS:.o=.d))
 
 dep_clean:
diff --git a/tests/Makefile b/tests/Makefile
index f6b55836a434..7ae6b9012b5a 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -21,10 +21,9 @@ clean: dep_clean
 	rm -f $(TESTS:%=%-test) $(TESTS:%=%.out) $(TESTS:%=%.o)
 
 OBJS = $(TESTS:%=%.o)
+.SECONDARY: $(OBJS)
+
 include $(wildcard $(OBJS:.o=.d))
 
-
-
-
 dep_clean:
 	$(RM) $(OBJS:.o=.d)
-- 
2.16.1
