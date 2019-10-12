From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 69/72] multipath tests: Makefile: fix "clean"
	target
Date: Sat, 12 Oct 2019 21:29:03 +0000
Message-ID: <20191012212703.12989-70-martin.wilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index 60338f14..c70b8399 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -42,7 +42,7 @@ lib/libchecktur.so:
 OBJS = $(TESTS:%=%.o) test-lib.o
 
 clean: dep_clean
-	$(RM) $(TESTS:%=%-test) $(TESTS:%=%.out) $(OBJS)
+	$(RM) $(TESTS:%=%-test) $(TESTS:%=%.out) $(OBJS) *.o.wrap
 	$(RM) -rf lib
 
 .SECONDARY: $(OBJS)
-- 
2.23.0
