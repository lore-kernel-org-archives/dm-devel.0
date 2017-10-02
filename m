From: Michael Lass <bevan@bi-co.net>
Subject: [PATCH] multipath-tools: libdmmp: Fix build for members
	of samba domain
Date: Mon,  2 Oct 2017 20:27:32 +0200
Message-ID: <20171002182732.5367-1-bevan@bi-co.net>
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
Cc: Michael Lass <bevan@bi-co.net>
List-Id: dm-devel.ids

When the user building libdmmp is part of a samba domain, mktemp will create
a path like /tmp/MYDOMAIN\mylogin/tmp.* Use quotation marks to allow using a
path containing backslashes as build otherwise fails for these users.

Signed-off-by: Michael Lass <bevan@bi-co.net>
---
 libdmmp/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index cdd26ed7..a5031b67 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -75,10 +75,10 @@ docs/man/$(EXTRA_MAN_FILES).gz: $(HEADERS)
 		$(INSTALL_PROGRAM) -v -m 644 -D docs/$$file docs/man/$$file; \
 	done
 	cat $(HEADERS) | \
-	    perl docs/doc-preclean.pl > $(TEMPFILE)
-	perl docs/kernel-doc -man $(TEMPFILE) | \
+	    perl docs/doc-preclean.pl > "$(TEMPFILE)"
+	perl docs/kernel-doc -man "$(TEMPFILE)" | \
 	    perl docs/split-man.pl docs/man
-	-rm -f $(TEMPFILE)
+	-rm -f "$(TEMPFILE)"
 	@for file in docs/man/*.3; do \
 		gzip -f $$file; \
 	done
-- 
2.14.2
