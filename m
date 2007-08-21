From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] Avoid theoretical buffer overrun in
	find_mount_point
Date: Tue, 21 Aug 2007 19:58:42 +0200
Message-ID: <877inodb1p.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is probably purely theoretical, but nonetheless,
if there's ever a /proc/mounts with an fstype string that's
30 bytes or longer, (or a mount point that longer than 4KB),
find_mount_point's use of fscanf would clobber bits of the stack.

I note that if this code had used c99's declare-after-stmt,
those two declarations could have been near enough to the
offending fscanf stmt that everything would have been
within the default diff-context window:

	static char mpoint[4096];
	char fstype[30];
	while (fscanf(fp, "%*s%4096s%30s%*s%*d%*d", mpoint, fstype) == 2) {
		if (!strcmp(fstype, "dmfs")) {
			fclose(fp);
			return mpoint;
		}
	}


Signed-off-by: Jim Meyering <jim@meyering.net>
---
 WHATS_NEW             |    1 +
 lib/fs/libdevmapper.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/WHATS_NEW b/WHATS_NEW
index fccac50..81dd1d6 100644
--- a/WHATS_NEW
+++ b/WHATS_NEW
@@ -1,5 +1,6 @@
 Version 1.02.22 - 21st August 2007
 ==================================
+  Avoid theoretical buffer overrun in find_mount_point.
   Fix inconsistent licence notices: executables are GPLv2; libraries LGPLv2.1.
   Update to use autoconf 2.61, while still supporting 2.57.
   Avoid repeated dm_task free on some dm_event_get_registered_device errors.
diff --git a/lib/fs/libdevmapper.c b/lib/fs/libdevmapper.c
index b0d8470..5b84969 100644
--- a/lib/fs/libdevmapper.c
+++ b/lib/fs/libdevmapper.c
@@ -334,8 +334,8 @@ static int do_error_check(char *mnt, char *name)
 static char *find_mount_point(void)
 {
 	FILE *fp;
-	static char mpoint[4096];
-	char fstype[30];
+	static char mpoint[4097];
+	char fstype[31];

 	if (!(fp = fopen("/proc/mounts", "r"))) {
 		log_sys_error("fopen", "/proc/mounts");
--
1.5.3.rc5
