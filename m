From: Dave Wysochanski <dwysocha@redhat.com>
Subject: [PATCH] Increase bindings file lock timeout to avoid
	failure of user_friendly_names map.
Date: Tue, 23 Sep 2008 14:00:19 -0400
Message-ID: <1222192819-15794-1-git-send-email-dwysocha@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On setups with a large number of paths / multipath maps, contention for
the advisory lock on the bindings file may take longer than 3 seconds,
and some multipath processes may create maps based on WWID despite having
user_friendly_names set.  Increasing the timeout is a simple fix that
gets us a bit further.

More extensive fixes might include:
1) improving the efficiency of the critical section code
2) use shared/read locks initially, then use exclusive/write locks only when
it is known the bindings file needs updated

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
---
 libmultipath/alias.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index 3d64b9b..fe1191b 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -1,4 +1,4 @@
-#define BINDINGS_FILE_TIMEOUT 3
+#define BINDINGS_FILE_TIMEOUT 30
 #define BINDINGS_FILE_HEADER \
 "# Multipath bindings, Version : 1.0\n" \
 "# NOTE: this file is automatically maintained by the multipath program.\n" \
-- 
1.5.5.1
