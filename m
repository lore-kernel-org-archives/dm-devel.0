From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/21] dm: use => instead of , for splitting output structure
	from input
Date: Sun, 9 Oct 2016 16:30:24 +0300
Message-ID: <20161009133024.GA3397@obsidian>
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
 dm.c             |    4 ++--
 tests/ioctl_dm.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/dm.c b/dm.c
index 3ee74c3..f23a65d 100644
--- a/dm.c
+++ b/dm.c
@@ -288,8 +288,8 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 
 	if (umoven(tcp, arg, sizeof(ioc) - sizeof(ioc.data), &ioc) < 0)
 		return 0;
-	tprintf(", {version=%d.%d.%d", ioc.version[0], ioc.version[1],
-		ioc.version[2]);
+	tprintf("%s{version=%d.%d.%d",  entering(tcp) ? ", " : " => ",
+		ioc.version[0], ioc.version[1], ioc.version[2]);
 
 	/*
 	 * if we use a different version of ABI, do not attempt to decode
diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index ba484ee..3c43913 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -42,7 +42,7 @@ main(void)
 	ioctl(-1, DM_VERSION, &s);
 	printf("ioctl(-1, DM_VERSION, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0}, "
+	       "uuid=\"uuu\", flags=0} => "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
@@ -58,7 +58,7 @@ main(void)
 	printf("ioctl(-1, DM_TABLE_LOAD, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", target_count=1, flags=0, {sector_start=16, "
-	       "length=32, target_type=\"tgt\", string=\"tparams\"}}, "
+	       "length=32, target_type=\"tgt\", string=\"tparams\"}} => "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
@@ -69,7 +69,7 @@ main(void)
 	ioctl(-1, DM_TARGET_MSG, &s);
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}}, "
+	       "uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}} => "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
@@ -78,7 +78,7 @@ main(void)
 	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
 	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0, string=\"10 20 30 40\"}, "
+	       "uuid=\"uuu\", flags=0, string=\"10 20 30 40\"} => "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
@@ -87,7 +87,7 @@ main(void)
 	ioctl(-1, DM_DEV_RENAME, &s);
 	printf("ioctl(-1, DM_DEV_RENAME, "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"}, "
+	       "uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"} => "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
@@ -98,7 +98,7 @@ main(void)
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", target_count=4294967295, flags=0, "
 	       "{sector_start=0, length=0, target_type=\"\", string=\"\"}, "
-	       "/* misplaced struct dm_target_spec */ ...}, "
+	       "/* misplaced struct dm_target_spec */ ...} => "
 	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
 	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
