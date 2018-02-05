From: Julian Andres Klode <julian.klode@canonical.com>
Subject: [PATCH] kpartx: Improve finding loopback device by file
Date: Mon,  5 Feb 2018 09:58:31 +0100
Message-ID: <20180205085831.23923-1-julian.klode@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Device-mapper development mailing list <dm-devel@redhat.com>
Cc: Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

Commit 9bdfa3eb8e24b668e6c2bb882cddb0ccfe23ed5b changed kpartx
to lookup files by absolute path, using realpath(). This introduced
a regression when part of the filename where symbolic links. While
the kernel stores the absolute path to the backing file, it does not
resolve symbolic links, and hence kpartx would fail to find the loopback
device because it resolves symbolic links when deleting.

This introduces two workarounds in find_loop_by_file()

(1) We match against the specified file name as is as well
(2) We canonicalize the loopinfo.lo_name and match the canonicalized filename
    against that.

Bug-Ubuntu: https://bugs.launchpad.net/ubuntu/+source/multipath-tools/+bug/1747044
Signed-off-by: Julian Andres Klode <julian.klode@canonical.com>
---
 kpartx/kpartx.c |  8 +-------
 kpartx/lopart.c | 12 +++++++++++-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 442b6bd9..c1af1c5e 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -327,13 +327,7 @@ main(int argc, char **argv){
 
 	if (S_ISREG (buf.st_mode)) {
 		/* already looped file ? */
-		char rpath[PATH_MAX];
-		if (realpath(device, rpath) == NULL) {
-			fprintf(stderr, "Error: %s: %s\n", device,
-				strerror(errno));
-			exit (1);
-		}
-		loopdev = find_loop_by_file(rpath);
+		loopdev = find_loop_by_file(device);
 
 		if (!loopdev && what == DELETE)
 			exit (0);
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 02b29e8c..26b2678c 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -69,6 +69,13 @@ char *find_loop_by_file(const char *filename)
 	struct loop_info loopinfo;
 	const char VIRT_BLOCK[] = "/sys/devices/virtual/block";
 	char path[PATH_MAX];
+	char rfilename[PATH_MAX];
+	char rloopfilename[PATH_MAX];
+	if (realpath(filename, rfilename) == NULL) {
+		fprintf(stderr, "Error: %s: %s\n", filename,
+				strerror(errno));
+		exit (1);
+	}
 
 	dir = opendir(VIRT_BLOCK);
 	if (!dir)
@@ -117,7 +124,10 @@ char *find_loop_by_file(const char *filename)
 
 		close (fd);
 
-		if (0 == strcmp(filename, loopinfo.lo_name)) {
+		if (0 == strcmp(filename, loopinfo.lo_name) ||
+		    0 == strcmp(rfilename, loopinfo.lo_name) ||
+		    (realpath(loopinfo.lo_name, rloopfilename) &&
+		     0 == strcmp(rfilename, rloopfilename))) {
 			found = realpath(path, NULL);
 			break;
 		}
-- 
2.15.1
