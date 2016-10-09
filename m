From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/21] dm: Add check whether command uses parameters
Date: Sun, 9 Oct 2016 16:31:29 +0300
Message-ID: <20161009133129.GA4492@obsidian>
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
 dm.c             |   25 ++++++++++++++++++++++---
 tests/ioctl_dm.c |    2 +-
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/dm.c b/dm.c
index caffc55..a48aa72 100644
--- a/dm.c
+++ b/dm.c
@@ -281,6 +281,23 @@ dm_decode_string(const struct dm_ioctl *ioc, const char *extra,
 	}
 }
 
+static inline bool
+dm_ioctl_has_params(const unsigned int code)
+{
+	switch (code) {
+	case DM_VERSION:
+	case DM_REMOVE_ALL:
+	case DM_DEV_CREATE:
+	case DM_DEV_REMOVE:
+	case DM_DEV_SUSPEND:
+	case DM_DEV_STATUS:
+	case DM_TABLE_CLEAR:
+		return false;
+	}
+
+	return true;
+}
+
 static int
 dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 {
@@ -336,8 +353,10 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 		goto skip;
 	}
 
-	tprintf(", data_size=%u, data_start=%u",
-		ioc->data_size, ioc->data_start);
+	tprintf(", data_size=%u", ioc->data_size);
+
+	if (dm_ioctl_has_params(code))
+		tprintf(", data_start=%u", ioc->data_start);
 
 	if (ioc->data_size < (sizeof(*ioc) - sizeof(ioc->data))) {
 		tprints(", /* Incorrect data_size */ ...");
@@ -348,7 +367,7 @@ dm_known_ioctl(struct tcb *tcp, const unsigned int code, long arg)
 	dm_decode_values(tcp, code, ioc);
 	dm_decode_flags(ioc);
 
-	if (ioc->data_size > sizeof(ioc)) {
+	if (dm_ioctl_has_params(code) && (ioc->data_size > sizeof(ioc))) {
 		extra = malloc(ioc->data_size);
 		if (extra) {
 			extra_size = ioc->data_size;
diff --git a/tests/ioctl_dm.c b/tests/ioctl_dm.c
index c120ed2..6ad4ea9 100644
--- a/tests/ioctl_dm.c
+++ b/tests/ioctl_dm.c
@@ -40,7 +40,7 @@ main(void)
 	init_s(&s.ioc, sizeof(s.ioc), 0);
 	ioctl(-1, DM_VERSION, &s);
 	printf("ioctl(-1, DM_VERSION, "
-	       "{version=4.1.2, data_size=%zu, data_start=0, "
+	       "{version=4.1.2, data_size=%zu, "
 	       "dev=makedev(18, 52), name=\"nnn\", uuid=\"uuu\", flags=0}) = "
 	       "-1 EBADF (%m)\n", sizeof(s.ioc));
 
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
