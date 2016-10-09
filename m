From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/21] dm: Additional data_size/data_start checks
Date: Sun, 9 Oct 2016 16:31:02 +0300
Message-ID: <20161009133102.GA4014@obsidian>
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
 dm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/dm.c b/dm.c
index 814d7d2..289bc0d 100644
--- a/dm.c
+++ b/dm.c
@@ -293,7 +293,8 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	if (!ioc)
 		return 0;
 
-	if (umoven(tcp, arg, sizeof(*ioc) - sizeof(ioc->data), ioc) < 0) {
+	if ((umoven(tcp, arg, sizeof(*ioc) - sizeof(ioc->data), ioc) < 0) ||
+	    (ioc->data_size < offsetof(struct dm_ioctl, data_size))) {
 		free(ioc);
 		return 0;
 	}
@@ -335,6 +336,11 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 		goto skip;
 	}
 
+	if (ioc->data_size < (sizeof(*ioc) - sizeof(ioc->data))) {
+		tprints(", /* Incorrect data_size */ ...");
+		goto skip;
+	}
+
 	dm_decode_device(code, ioc);
 	dm_decode_values(tcp, code, ioc);
 	dm_decode_flags(ioc);
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
