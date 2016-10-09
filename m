From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/21] dm: Move printing of dm_ioctl fields before allocation
	of extra data
Date: Sun, 9 Oct 2016 16:30:48 +0300
Message-ID: <20161009133048.GA3769@obsidian>
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
 dm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/dm.c b/dm.c
index a11196f..73a9b57 100644
--- a/dm.c
+++ b/dm.c
@@ -335,6 +335,10 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 		goto skip;
 	}
 
+	dm_decode_device(code, ioc);
+	dm_decode_values(tcp, code, ioc);
+	dm_decode_flags(ioc);
+
 	if (ioc->data_size > sizeof(ioc)) {
 		extra = malloc(ioc->data_size);
 		if (extra) {
@@ -346,9 +350,6 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 			}
 		}
 	}
-	dm_decode_device(code, ioc);
-	dm_decode_values(tcp, code, ioc);
-	dm_decode_flags(ioc);
 	if (abbrev(tcp))
 		tprints(", ...");
 	else
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
