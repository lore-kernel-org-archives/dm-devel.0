From: Petr Uzel <petr.uzel@suse.cz>
Subject: [PATCH] kpartx: work correctly with empty GPT table
Date: Wed, 25 Jul 2012 14:54:07 +0200
Message-ID: <1343220847-22830-1-git-send-email-petr.uzel@suse.cz>
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
Cc: Hannes Reinecke <hare@suse.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When running the partition table probes, the code considered empty
tables as invalid ones. Because of this, kpartx -u / -d does not work
correctly on empty tables (with zero partitions).

The return value of the probes should be:
-1: not our partition table type
0: our partition table, but no partitions exist
>0: number of partitions found

Adapt read_gpt_pt() to this semantics.

CC: Hannes Reinecke <hare@suse.com>
CC: Christophe Varoqui <christophe.varoqui@gmail.com>

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 kpartx/gpt.c    |    6 +++---
 kpartx/kpartx.c |    6 ++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 3082cae..18be035 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -625,8 +625,8 @@ find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
  * @fd
  * @all - slice with start/size of whole disk
  *
- *  0 if this isn't our partition table
- *  number of partitions if successful
+ *  -1 if this isn't our partition table
+ *  number of partitions if successful (>= 0)
  *
  */
 int
@@ -643,7 +643,7 @@ read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns)
 			free (gpt);
 		if (ptes)
 			free (ptes);
-		return 0;
+		return -1;
 	}
 
 	for (i = 0; i < __le32_to_cpu(gpt->num_partition_entries) && i < ns; i++) {
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index b5e0a32..9a4c694 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -368,12 +368,10 @@ main(int argc, char **argv){
 		/* here we get partitions */
 		n = ptp->fn(fd, all, slices, SIZE(slices));
 
+		if (n >= 0) {
 #ifdef DEBUG
-		if (n >= 0)
 			printf("%s: %d slices\n", ptp->type, n);
 #endif
-
-		if (n > 0) {
 			close(fd);
 			fd = -1;
 		}
@@ -607,7 +605,7 @@ main(int argc, char **argv){
 			break;
 
 		}
-		if (n > 0)
+		if (n >= 0)
 			break;
 	}
 	if (what == LIST && loopcreated && S_ISREG (buf.st_mode)) {
-- 
1.7.7
