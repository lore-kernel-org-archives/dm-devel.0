From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/21] tests/ioctl_dm: Allow passing size and data_start to
	init_s
Date: Sun, 9 Oct 2016 16:31:22 +0300
Message-ID: <20161009133122.GA4364@obsidian>
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
 tests/ioctl_dm.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 6967ca2..c120ed2 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -21,32 +21,30 @@ static struct s {
 	} u;
 } s;
 
-static void init_s(void)
+static void init_s(struct dm_ioctl *s, size_t size, size_t offs)
 {
-	memset(&s, 0, sizeof s);
-	s.ioc.version[0] = DM_VERSION_MAJOR;
-	s.ioc.version[1] = 1;
-	s.ioc.version[2] = 2;
-	s.ioc.data_size = sizeof(s);
-	s.ioc.data_start = offsetof(struct s, u);
-	s.ioc.dev = 0x1234;
-	strcpy(s.ioc.name, "nnn");
-	strcpy(s.ioc.uuid, "uuu");
+	memset(s, 0, size);
+	s->version[0] = DM_VERSION_MAJOR;
+	s->version[1] = 1;
+	s->version[2] = 2;
+	s->data_size = size;
+	s->data_start = offs;
+	s->dev = 0x1234;
+	strcpy(s->name, "nnn");
+	strcpy(s->uuid, "uuu");
 }
 
 int
 main(void)
 {
-	init_s();
-	s.ioc.data_size = sizeof(s.ioc);
-	s.ioc.data_start = 0;
+	init_s(&s.ioc, sizeof(s.ioc), 0);
 	ioctl(-1, DM_VERSION, &s);
 	printf("ioctl(-1, DM_VERSION, "
 	       "{version=4.1.2, data_size=%zu, data_start=0, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = "
 	       "-1 EBADF (%m)\n", sizeof(s.ioc));
 
-	init_s();
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	s.ioc.target_count = 1;
 	s.u.ts.target_spec.sector_start = 0x10;
 	s.u.ts.target_spec.length = 0x20;
@@ -62,7 +60,7 @@ main(void)
 	       "length=32, target_type=\"tgt\", string=\"tparams\"}}) = "
 	       "-1 EBADF (%m)\n", s.ioc.data_size, s.ioc.data_start);
 
-	init_s();
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	s.u.tm.target_msg.sector = 0x1234;
 	strcpy(s.u.string + offsetof(struct dm_target_msg, message),
 		"tmsg");
@@ -73,7 +71,7 @@ main(void)
 	       "{sector=4660, message=\"tmsg\"}}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
-	init_s();
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	strcpy(s.u.string, "10 20 30 40");
 	ioctl(-1, DM_DEV_SET_GEOMETRY, &s);
 	printf("ioctl(-1, DM_DEV_SET_GEOMETRY, "
@@ -82,7 +80,7 @@ main(void)
 	       "string=\"10 20 30 40\"}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
-	init_s();
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	strcpy(s.u.string, "new-name");
 	ioctl(-1, DM_DEV_RENAME, &s);
 	printf("ioctl(-1, DM_DEV_RENAME, "
@@ -91,7 +89,7 @@ main(void)
 	       "flags=0, string=\"new-name\"}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
-	init_s();
+	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	s.ioc.target_count = -1U;
 	ioctl(-1, DM_TABLE_LOAD, &s);
 	printf("ioctl(-1, DM_TABLE_LOAD, "
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
