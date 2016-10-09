From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/21] dm: Add inttypes.h, include reorder
Date: Sun, 9 Oct 2016 16:30:40 +0300
Message-ID: <20161009133040.GA3677@obsidian>
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

Build failed otherwise on RHEL 5.
---
 dm.c             |    3 ++-
 tests/ioctl_dm.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/dm.c b/dm.c
index b6fb11d..a11196f 100644
--- a/dm.c
+++ b/dm.c
@@ -2,8 +2,9 @@
 
 #ifdef HAVE_LINUX_DM_IOCTL_H
 
-# include <sys/ioctl.h>
+# include <inttypes.h>
 # include <linux/dm-ioctl.h>
+# include <sys/ioctl.h>
 
 # if DM_VERSION_MAJOR == 4
 
diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 31f474c..94dbe93 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -1,4 +1,5 @@
 #include "tests.h"
+#include <inttypes.h>
 #include <stdio.h>
 #include <stddef.h>
 #include <string.h>
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
