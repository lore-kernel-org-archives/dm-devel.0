From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/19] libmultipath: add ARRAY_SIZE helper
Date: Wed, 19 Dec 2018 00:19:20 +0100
Message-ID: <20181218231931.10762-9-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.h | 1 +
 tests/hwtable.c     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/util.h b/libmultipath/util.h
index 1f13c913..dea3fa04 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -25,6 +25,7 @@ int safe_write(int fd, const void *buf, size_t count);
 void set_max_fds(int max_fds);
 
 #define KERNEL_VERSION(maj, min, ptc) ((((maj) * 256) + (min)) * 256 + (ptc))
+#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 789481ff..ad863b08 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -24,8 +24,8 @@
 #include "pgpolicies.h"
 #include "test-lib.h"
 #include "print.h"
+#include "util.h"
 
-#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
 #define N_CONF_FILES 2
 
 static const char tmplate[] = "/tmp/hwtable-XXXXXX";
-- 
2.19.2
