From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/21] dm: Add data_size and data_offset fields to output
Date: Sun, 9 Oct 2016 16:31:16 +0300
Message-ID: <20161009133116.GA4266@obsidian>
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
 dm.c             |    4 +++-
 tests/ioctl_dm.c |   41 ++++++++++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/dm.c b/dm.c
index 5c908c9..caffc55 100644
--- a/dm.c
+++ b/dm.c
@@ -327,7 +327,6 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 
 	tprintf("%s{version=%d.%d.%d",  entering(tcp) ? ", " : " => ",
 		ioc->version[0], ioc->version[1], ioc->version[2]);
-
 	/*
 	 * if we use a different version of ABI, do not attempt to decode
 	 * ioctl fields
@@ -337,6 +336,9 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 		goto skip;
 	}
 
+	tprintf(", data_size=%u, data_start=%u",
+		ioc->data_size, ioc->data_start);
+
 	if (ioc->data_size < (sizeof(*ioc) - sizeof(ioc->data))) {
 		tprints(", /* Incorrect data_size */ ...");
 		goto skip;
diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 94dbe93..6967ca2 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -42,8 +42,9 @@ main(void)
 	s.ioc.data_start = 0;
 	ioctl(-1, DM_VERSION, &s);
 	printf("ioctl(-1, DM_VERSION, "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	       "{version=4.1.2, data_size=%zu, data_start=0, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = "
+	       "-1 EBADF (%m)\n", sizeof(s.ioc));
 
 	init_s();
 	s.ioc.target_count = 1;
@@ -55,10 +56,11 @@ main(void)
 	strcpy(s.u.ts.target_params, "tparams");
 	ioctl(-1, DM_TABLE_LOAD, &s);
 	printf("ioctl(-1, DM_TABLE_LOAD, "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", target_count=1, flags=0, {sector_start=16, "
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=1, flags=0, {sector_start=16, "
 	       "length=32, target_type=\"tgt\", string=\"tparams\"}}) = "
-	       "-1 EBADF (%m)\n");
+	       "-1 EBADF (%m)\n", s.ioc.data_size, s.ioc.data_start);
 
 	init_s();
 	s.u.tm.target_msg.sector = 0x1234;
@@ -66,34 +68,39 @@ main(void)
 		"tmsg");
 	ioctl(-1, DM_TARGET_MSG, &s);
 	printf("ioctl(-1, DM_TARGET_MSG, "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}}) = "
-	       "-1 EBADF (%m)\n");
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+	       "{sector=4660, message=\"tmsg\"}}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
 
 	init_s();
 	strcpy(s.u.string, "10 20 30 40");
 	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
 	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", flags=0, string=\"10 20 30 40\"}) = "
-	       "-1 EBADF (%m)\n");
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
+	       "string=\"10 20 30 40\"}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
 
 	init_s();
 	strcpy(s.u.string, "new-name");
 	ioctl(-1, DM_DEV_RENAME, &s);
 	printf("ioctl(-1, DM_DEV_RENAME, "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"}) = "
-	       "-1 EBADF (%m)\n");
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
+	       "flags=0, string=\"new-name\"}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
 
 	init_s();
 	s.ioc.target_count = -1U;
 	ioctl(-1, DM_TABLE_LOAD, &s);
 	printf("ioctl(-1, DM_TABLE_LOAD, "
-	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
-	       "uuid=\"uuu\", target_count=4294967295, flags=0, "
+	       "{version=4.1.2, data_size=%u, data_start=%u, "
+	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", "
+	       "target_count=4294967295, flags=0, "
 	       "{sector_start=0, length=0, target_type=\"\", string=\"\"}, "
-	       "/* misplaced struct dm_target_spec */ ...}) = -1 EBADF (%m)\n");
+	       "/* misplaced struct dm_target_spec */ ...}) = -1 EBADF (%m)\n",
+	       s.ioc.data_size, s.ioc.data_start);
 
 	puts("+++ exited with 0 +++");
 	return 0;
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
