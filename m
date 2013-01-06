From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] fix extended partition mapping
Date: Sat,  5 Jan 2013 21:57:30 -0500
Message-ID: <1357441050-21997-1-git-send-email-psusi@ubuntu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The linux kernel maps the extended partition only
so that LILO can be installed there.  The length is always set
to two sectors to allow this, and most tools know to ignore the
device.  kpartx was mapping the entire extended partition, then
stacking the logical partitions on top of it.  This presented
a device that looked like an entirely separate disk that
contains only the logical partitions.  This patch fixes kpartx
to conform with the normal Linux behavior.
---
 kpartx/dos.c    |    2 ++
 kpartx/kpartx.c |    9 +++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kpartx/dos.c b/kpartx/dos.c
index 1691105..a1a9961 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -98,6 +98,8 @@ read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
 			break;
 		}
 		if (is_extended(p.sys_type)) {
+			sp[i].size = 2; /* extended partitions only get two
+					   sectors mapped for LILO to install */
 			n += read_extended_partition(fd, &p, i, sp+n, ns-n);
 		}
 	}
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index b5e0a32..f359afe 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -515,7 +515,6 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
-					uint64_t start;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -541,11 +540,9 @@ main(int argc, char **argv){
 					}
 					strip_slash(partname);
 
-					start = slices[j].start - slices[k].start;
-					if (safe_sprintf(params, "%d:%d %" PRIu64,
-							 slices[k].major,
-							 slices[k].minor,
-							 start)) {
+					if (safe_sprintf(params, "%s %" PRIu64,
+							 device,
+							 slices[j].start)) {
 						fprintf(stderr, "params too small\n");
 						exit(1);
 					}
-- 
1.7.10.4
