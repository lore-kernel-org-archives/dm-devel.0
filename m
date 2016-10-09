From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/21] dm: Some future-proofing by means of compile-time
	DM_VERSION_MAJOR check
Date: Sun, 9 Oct 2016 16:29:48 +0300
Message-ID: <20161009132948.GA2910@obsidian>
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

* dm.c: Add check whether DM_VERSION_MAJOR equals to 4, provide empty
dm_ioctl if check fails.
---
 dm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/dm.c b/dm.c
index ebdfc44..79bb7c7 100644
--- a/dm.c
+++ b/dm.c
@@ -5,6 +5,8 @@
 # include <sys/ioctl.h>
 # include <linux/dm-ioctl.h>
 
+# if DM_VERSION_MAJOR == 4
+
 static void
 dm_decode_device(const unsigned int code, const struct dm_ioctl *ioc)
 {
@@ -375,4 +377,13 @@ dm_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	}
 }
 
-#endif
+# else /* !(DM_VERSION_MAJOR == 4) */
+
+int
+dm_ioctl(struct tcb *tcp, const unsigned int code, long arg)
+{
+	return 0;
+}
+
+# endif /* DM_VERSION_MAJOR == 4 */
+#endif /* HAVE_LINUX_DM_IOCTL_H */
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
