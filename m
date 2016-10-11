From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/9] tests: Add check for printing of overlength strings to
	ioctl_dm test
Date: Wed, 12 Oct 2016 01:38:19 +0300
Message-ID: <20161011223819.GA8545@obsidian>
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
 tests/ioctl_dm.c    |    2 +-
 tests/ioctl_dm.test |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 6ad4ea9..0a3bbf4 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -77,7 +77,7 @@ main(void)
 	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "string=\"10 20 30 40\"}) = -1 EBADF (%m)\n",
+	       "string=\"10 20 30 \"...}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
diff --git a/tests/ioctl_dm.test b/tests/ioctl_dm.test
index db77616..78866d3 100755
--- a/tests/ioctl_dm.test
+++ b/tests/ioctl_dm.test
@@ -5,7 +5,7 @@
 . "${srcdir=.}/init.sh"
 
 run_prog > /dev/null
-run_strace -a16 -veioctl $args > "$EXP"
+run_strace -a16 -s9 -veioctl $args > "$EXP"
 check_prog grep
 grep -v '^ioctl([012],' < "$LOG" > "$OUT"
 match_diff "$OUT" "$EXP"
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
