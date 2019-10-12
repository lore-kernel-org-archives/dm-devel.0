From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 68/72] multipath-tools: Makefile: use proper
 directory recursion
Date: Sat, 12 Oct 2019 21:29:02 +0000
Message-ID: <20191012212703.12989-69-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

"make -k" didn't work with the Makefile's subdirectory handling.
Do it the proper "make" way.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/Makefile b/Makefile
index 4b145c59..1dee3680 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 
-BUILDDIRS = \
+BUILDDIRS := \
 	libmpathcmd \
 	libmultipath \
 	libmultipath/prioritizers \
@@ -19,32 +19,30 @@ BUILDDIRS += \
 	libdmmp
 endif
 
-all: recurse
+BUILDDIRS.clean := $(BUILDDIRS:=.clean) tests.clean
 
-recurse:
-	@for dir in $(BUILDDIRS); do $(MAKE) -C $$dir || exit $?; done
+.PHONY:	$(BUILDDIRS) $(BUILDDIRS:=.uninstall) $(BUILDDIRS:=.install) $(BUILDDIRS.clean)
 
-recurse_clean:
-	@for dir in $(BUILDDIRS); do \
-	$(MAKE) -C $$dir clean || exit $?; \
-	done
-	$(MAKE) -C tests clean
+all:	$(BUILDDIRS)
 
-recurse_install:
-	@for dir in $(BUILDDIRS); do \
-	$(MAKE) -C $$dir install || exit $?; \
-	done
+$(BUILDDIRS):
+	$(MAKE) -C $@
 
-recurse_uninstall:
-	@for dir in $(BUILDDIRS); do \
-	$(MAKE) -C $$dir uninstall || exit $?; \
-	done
+multipath multipathd mpathpersist: libmultipath
+mpathpersist:  libmpathpersist
 
-clean: recurse_clean
+$(BUILDDIRS.clean):
+	$(MAKE) -C ${@:.clean=} clean
 
-install: recurse_install
+$(BUILDDIRS:=.install):
+	$(MAKE) -C ${@:.install=} install
 
-uninstall: recurse_uninstall
+$(BUILDDIRS:=.uninstall):
+	$(MAKE) -C ${@:.uninstall=} uninstall
+
+clean: $(BUILDDIRS.clean)
+install: $(BUILDDIRS:=.install)
+uninstall: $(BUILDDIRS:=.uninstall)
 
 test:	all
 	$(MAKE) -C tests
-- 
2.23.0
