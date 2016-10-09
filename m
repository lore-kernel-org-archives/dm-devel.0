From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/21] tests/ioctl_dm: Formatting
Date: Sun, 9 Oct 2016 16:28:30 +0300
Message-ID: <20161009132830.GA1756@obsidian>
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
 tests/ioctl_dm.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index f4c3c8b..a5945ae 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -40,38 +40,66 @@ main(void)
 	s.ioc.data_size = sizeof(s.ioc);
 	s.ioc.data_start = 0;
 	ioctl(-1, DM_VERSION, &s);
-	printf("ioctl(-1, DM_VERSION, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	printf("ioctl(-1, DM_VERSION, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0}, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
 	init_s();
 	s.ioc.target_count = 1;
 	s.u.ts.target_spec.sector_start = 0x10;
 	s.u.ts.target_spec.length = 0x20;
-	s.u.ts.target_spec.next = sizeof(s.u.ts.target_spec) + sizeof(s.u.ts.target_params);
+	s.u.ts.target_spec.next =
+		sizeof(s.u.ts.target_spec) + sizeof(s.u.ts.target_params);
 	strcpy(s.u.ts.target_spec.target_type, "tgt");
 	strcpy(s.u.ts.target_params, "tparams");
 	ioctl(-1, DM_TABLE_LOAD, &s);
-	printf("ioctl(-1, DM_TABLE_LOAD, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", target_count=1, flags=0, {sector_start=16, length=32, target_type=\"tgt\", string=\"tparams\"}}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", target_count=1, flags=0, {sector_start=16, "
+	       "length=32, target_type=\"tgt\", string=\"tparams\"}}, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
 	init_s();
 	s.u.tm.target_msg.sector = 0x1234;
 	strcpy(s.u.tm.target_msg.message, "tmsg");
 	ioctl(-1, DM_TARGET_MSG, &s);
-	printf("ioctl(-1, DM_TARGET_MSG, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	printf("ioctl(-1, DM_TARGET_MSG, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0, {sector=4660, message=\"tmsg\"}}, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
 	init_s();
 	strcpy(s.u.string, "10 20 30 40");
 	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
-	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, string=\"10 20 30 40\"}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0, string=\"10 20 30 40\"}, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
 	init_s();
 	strcpy(s.u.string, "new-name");
 	ioctl(-1, DM_DEV_RENAME, &s);
-	printf("ioctl(-1, DM_DEV_RENAME, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	printf("ioctl(-1, DM_DEV_RENAME, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", event_nr=0, flags=0, string=\"new-name\"}, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
 	init_s();
 	s.ioc.target_count = -1U;
 	ioctl(-1, DM_TABLE_LOAD, &s);
-	printf("ioctl(-1, DM_TABLE_LOAD, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", target_count=4294967295, flags=0, {sector_start=0, length=0, target_type=\"\", string=\"\"}, misplaced struct dm_target_spec}, {version=4.1.2, dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
+	printf("ioctl(-1, DM_TABLE_LOAD, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", target_count=4294967295, flags=0, "
+	       "{sector_start=0, length=0, target_type=\"\", string=\"\"}, "
+	       "misplaced struct dm_target_spec}, "
+	       "{version=4.1.2, dev=makedev(18, 52), name=\"nnn\", "
+	       "uuid=\"uuu\", flags=0}) = -1 EBADF (%m)\n");
 
 	puts("+++ exited with 0 +++");
 	return 0;
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
