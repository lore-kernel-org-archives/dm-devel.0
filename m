From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 07/10] make kpartx -d remove all partitions
Date: Fri, 15 May 2015 18:14:10 -0500
Message-ID: <1431731653-3892-8-git-send-email-bmarzins@redhat.com>
References: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Currently kpartx -d only removes the partitions that have entries in the
partition table.  If you remove a partition from the device, and then
run kpartx -d, it will not delete that partition (kpartx -u will).  I don't
see any value in leaving partition devices for partitions that don't even
exist anymore, so this patch makes -d delete all partitions.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index d69f9af..a9d4c98 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -426,7 +426,7 @@ main(int argc, char **argv){
 			break;
 
 		case DELETE:
-			for (j = n-1; j >= 0; j--) {
+			for (j = MAXSLICES-1; j >= 0; j--) {
 				if (safe_sprintf(partname, "%s%s%d",
 					     mapname, delim, j+1)) {
 					fprintf(stderr, "partname too small\n");
@@ -434,7 +434,7 @@ main(int argc, char **argv){
 				}
 				strip_slash(partname);
 
-				if (!slices[j].size || !dm_map_present(partname))
+				if (!dm_map_present(partname))
 					continue;
 
 				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname,
-- 
1.8.3.1
