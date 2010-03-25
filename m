From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: fix offset for containted slices.
Date: Thu, 25 Mar 2010 16:48:42 -0500
Message-ID: <20100325214842.GH23952@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

For contained slices, the offset of the new device should be from the start
of the containing device, which is what you are creating the new device on top
of.  It should not be the offset from the start of the entire disk.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
:100644 100644 b61a81f... 103ed0a... M	kpartx/kpartx.c
 kpartx/kpartx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: multipath-tools-100322/kpartx/kpartx.c
===================================================================
--- multipath-tools-100322.orig/kpartx/kpartx.c
+++ multipath-tools-100322/kpartx/kpartx.c
@@ -488,6 +488,7 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
+					uint64_t start;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -498,7 +499,7 @@ main(int argc, char **argv){
 						continue;
 
 					/* Skip all simple slices */
-					if (k < 0)
+					if (slices[j].container == 0)
 						continue;
 
 					/* Check container slice */
@@ -513,10 +514,11 @@ main(int argc, char **argv){
 					}
 					strip_slash(partname);
 
+					start = slices[j].start - slices[k].start;
 					if (safe_sprintf(params, "%d:%d %" PRIu64,
 							 slices[k].major,
 							 slices[k].minor,
-							 slices[j].start)) {
+							 start)) {
 						fprintf(stderr, "params too small\n");
 						exit(1);
 					}
