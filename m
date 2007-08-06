From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] kpartx: Handle extended partitions correctly
Date: Mon, 06 Aug 2007 13:21:16 +0200
Message-ID: <46B7042C.5080609@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040606090909000004080605"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040606090909000004080605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

there is actually a small bug in kpartx; it calculates the size
for an extended partition relative to the entire disk, not
the contained partition. This patch fixes this.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------040606090909000004080605
Content-Type: text/plain;
 name="kpartx-fixup-extended-partitions"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kpartx-fixup-extended-partitions"

kpartx: Handle extended partitions correctly

When creating the device-mapper table for an extended partition we
should calculate the size relative to the containing partition, not
to the entire device.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index dbe2ee2..f60e5f4 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -265,7 +265,7 @@ main(int argc, char **argv){
 	}
 
 	if (dm_prereq(DM_TARGET, 0, 0, 0) && (what == ADD || what == DELETE)) {
-		fprintf(stderr, "device mapper prerequisites not met\n"); 
+		fprintf(stderr, "device mapper prerequisites not met\n");
 		exit(1);
 	}
 
@@ -387,10 +387,10 @@ main(int argc, char **argv){
 					slices[j].minor = m++;
 
 					start = slices[j].start - slices[k].start;
-					printf("%s%s%d : 0 %lu /dev/dm-%d %lu\n",
+					printf("%s%s%d : 0 %lu %s%s%d %lu\n",
 					       mapname, delim, j+1,
 					       (unsigned long) slices[j].size,
-					       slices[k].minor, start);
+					       mapname, delim, k, start);
 					c--;
 				}
 				/* Terminate loop if nothing more to resolve */
@@ -431,7 +431,7 @@ main(int argc, char **argv){
 			break;
 
 		case ADD:
-			for (j=0, c = 0; j<n; j++) {
+			for (j = 0, c = 0; j < n; j++) {
 				if (slices[j].size == 0)
 					continue;
 
@@ -477,6 +477,7 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
+					unsigned long start;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -487,7 +488,7 @@ main(int argc, char **argv){
 						continue;
 
 					/* Skip all simple slices */
-					if (k < 0)
+					if (slices[j].container == 0)
 						continue;
 
 					/* Check container slice */
@@ -502,10 +503,11 @@ main(int argc, char **argv){
 					}
 					strip_slash(partname);
 
+					start = slices[j].start - slices[k].start;
 					if (safe_sprintf(params, "%d:%d %lu",
 							 slices[k].major,
 							 slices[k].minor,
-							 (unsigned long)slices[j].start)) {
+							 start)) {
 						fprintf(stderr, "params too small\n");
 						exit(1);
 					}
@@ -524,9 +526,12 @@ main(int argc, char **argv){
 						&slices[j].minor);
 
 					if (verbose)
-						printf("add map %s : 0 %lu %s %s\n",
-						       partname, slices[j].size,
-						       DM_TARGET, params);
+						printf("add map %s (%d:%d): 0 %lu %s\n",
+						       partname, 
+						       slices[j].major,
+						       slices[j].minor,
+						       slices[j].size,
+						       params);
 					c--;
 				}
 				/* Terminate loop */

--------------040606090909000004080605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040606090909000004080605--
