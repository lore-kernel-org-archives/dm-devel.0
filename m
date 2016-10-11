From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/9] tests/ioctl_dm: overly long string printing checks
Date: Wed, 12 Oct 2016 01:39:02 +0300
Message-ID: <20161011223902.GA8975@obsidian>
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
 tests/ioctl_dm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index 261983c..24232b7 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -67,12 +67,12 @@ main(void)
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
 	s.u.tm.target_msg.sector = 0x1234;
 	strcpy(s.u.string + offsetof(struct dm_target_msg, message),
-		"tmsg");
+		"long target msg");
 	ioctl(-1, DM_TARGET_MSG, &s);
 	printf("ioctl(-1, DM_TARGET_MSG, "
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0, "
-	       "{sector=4660, message=\"tmsg\"}}) = -1 EBADF (%m)\n",
+	       "{sector=4660, message=\"long targ\"...}}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
@@ -85,12 +85,12 @@ main(void)
 	       s.ioc.data_size, s.ioc.data_start);
 
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
-	strcpy(s.u.string, "new-name");
+	strcpy(s.u.string, "new long name");
 	ioctl(-1, DM_DEV_RENAME, &s);
 	printf("ioctl(-1, DM_DEV_RENAME, "
 	       "{version=4.1.2, data_size=%u, data_start=%u, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", event_nr=0, "
-	       "flags=0, string=\"new-name\"}) = -1 EBADF (%m)\n",
+	       "flags=0, string=\"new long \"...}) = -1 EBADF (%m)\n",
 	       s.ioc.data_size, s.ioc.data_start);
 
 	init_s(&s.ioc, sizeof(s), offsetof(struct s, u));
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
