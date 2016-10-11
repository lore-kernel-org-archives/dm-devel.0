From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/9] tests: Add check for presence of HAVE_LINUX_DM_IOCTL_H
	macro definition to ioctl_dm test
Date: Wed, 12 Oct 2016 01:38:25 +0300
Message-ID: <20161011223825.GA8649@obsidian>
References: <20161005.192828.566127461630656590.yamato@redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005.192828.566127461630656590.yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

---
 tests/ioctl_dm.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 0a3bbf4..5f2689c 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -1,10 +1,13 @@
 #include "tests.h"
-#include <inttypes.h>
-#include <stdio.h>
-#include <stddef.h>
-#include <string.h>
-#include <sys/ioctl.h>
-#include <linux/dm-ioctl.h>
+
+#ifdef HAVE_LINUX_DM_IOCTL_H
+
+# include <inttypes.h>
+# include <stdio.h>
+# include <stddef.h>
+# include <string.h>
+# include <sys/ioctl.h>
+# include <linux/dm-ioctl.h>
 
 static struct s {
 	struct dm_ioctl ioc;
@@ -103,3 +106,9 @@ main(void)
 	puts("+++ exited with 0 +++");
 	return 0;
 }
+
+#else /* !HAVE_LINUX_DM_IOCTL_H */
+
+SKIP_MAIN_UNDEFINED("HAVE_LINUX_DM_IOCTL_H")
+
+#endif /* HAVE_LINUX_DM_IOCTL_H */
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
