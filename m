From: mwilck@suse.com
Subject: [PATCH v2 04/10] multipath-tools tests: fix memory leak
	in hwtable test
Date: Wed, 26 Aug 2020 11:59:01 +0200
Message-ID: <20200826095907.5576-5-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 84d2b35..12660da 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -25,6 +25,7 @@
 #include "test-lib.h"
 #include "print.h"
 #include "util.h"
+#include "foreign.h"
 
 #define N_CONF_FILES 2
 
@@ -187,6 +188,9 @@ static int teardown(void **state)
 
 	free_hwt(*state);
 	*state = NULL;
+	cleanup_prio();
+	cleanup_checkers();
+	cleanup_foreign();
 
 	return 0;
 }
-- 
2.28.0
