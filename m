From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/9] util: Add support for QUOTE_0_TERMINATED in user_style
	to ptrintstr_ex
Date: Wed, 12 Oct 2016 01:38:13 +0300
Message-ID: <20161011223813.GA8414@obsidian>
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

This enables printing size-limited (expectedly) ASCIZ strings.
---
 util.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/util.c b/util.c
index 23a5fdb..00148d4 100644
--- a/util.c
+++ b/util.c
@@ -820,13 +820,13 @@ printstr_ex(struct tcb *tcp, long addr, long len, unsigned int user_style)
 		outstr = xmalloc(outstr_size);
 	}
 
-	size = max_strlen;
+	size = max_strlen + 1;
 	if (len == -1) {
 		/*
 		 * Treat as a NUL-terminated string: fetch one byte more
 		 * because string_quote may look one byte ahead.
 		 */
-		if (umovestr(tcp, addr, size + 1, str) < 0) {
+		if (umovestr(tcp, addr, size, str) < 0) {
 			printaddr(addr);
 			return;
 		}
@@ -844,11 +844,23 @@ printstr_ex(struct tcb *tcp, long addr, long len, unsigned int user_style)
 
 	style |= user_style;
 
+	if (style & QUOTE_0_TERMINATED) {
+		if (size) {
+			--size;
+		} else {
+			tprints((len == -1) || (len == 0) ? "\"\"" : "\"\"...");
+			return;
+		}
+	}
+	if (size > max_strlen)
+		size = max_strlen;
+
 	/* If string_quote didn't see NUL and (it was supposed to be ASCIZ str
 	 * or we were requested to print more than -s NUM chars)...
 	 */
 	ellipsis = (string_quote(str, outstr, size, style) &&
-			(len < 0 || (unsigned long) len > max_strlen));
+			((style & QUOTE_0_TERMINATED) ||
+				(unsigned long) len > max_strlen));
 
 	tprints(outstr);
 	if (ellipsis)
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
