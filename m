From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 5/21] [kpartx] Use mapname for device-mapper
	devices
Date: Mon, 21 May 2007 11:23:30 +0200
Message-ID: <20070521092330.8A9C9D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


When kpartx is run on a device-mapper device it makes more sense
to use the mapname for generating the device name, not the supplied
commandline arguments. This way we can run kpartx on '/dev/dm-X'
and still get sensible names.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 0ee0cb3..b406b95 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -193,6 +193,7 @@ main(int argc, char **argv){
 	char * loopdev = NULL;
 	char * delim = NULL;
 	char *uuid = NULL;
+	char *mapname = NULL;
 	int loopro = 0;
 	int hotplug = 0;
 	struct stat buf;
@@ -310,12 +311,19 @@ main(int argc, char **argv){
 	
 	off = find_devname_offset(device);
 
-	if (!loopdev)
+	if (!loopdev) {
 		uuid = dm_mapuuid((unsigned int)MAJOR(buf.st_rdev),
 				  (unsigned int)MINOR(buf.st_rdev));
+		mapname = dm_mapname((unsigned int)MAJOR(buf.st_rdev),
+				     (unsigned int)MINOR(buf.st_rdev));
+	}
+
 	if (!uuid)
 		uuid = device + off;
 		
+	if (!mapname)
+		mapname = device + off;
+
 	fd = open(device, O_RDONLY);
 
 	if (fd == -1) {
@@ -365,7 +373,7 @@ main(int argc, char **argv){
 					continue;
 
 				printf("%s%s%d : 0 %lu %s %lu\n",
-					device + off, delim, j+1,
+					mapname, delim, j+1,
 					(unsigned long) slices[j].size, device,
 				        (unsigned long) slices[j].start);
 			}
@@ -374,7 +382,7 @@ main(int argc, char **argv){
 		case DELETE:
 			for (j = 0; j < n; j++) {
 				if (safe_sprintf(partname, "%s%s%d",
-					     device + off , delim, j+1)) {
+					     mapname, delim, j+1)) {
 					fprintf(stderr, "partname too small\n");
 					exit(1);
 				}
@@ -407,7 +415,7 @@ main(int argc, char **argv){
 					continue;
 
 				if (safe_sprintf(partname, "%s%s%d",
-					     device + off , delim, j+1)) {
+					     mapname, delim, j+1)) {
 					fprintf(stderr, "partname too small\n");
 					exit(1);
 				}
-- 
1.4.3.4
