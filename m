From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/5] kpartx: default to running in sync mode
Date: Mon, 24 Apr 2017 17:39:29 -0500
Message-ID: <1493073570-17167-5-git-send-email-bmarzins@redhat.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
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

When users run kpartx, they would naturally assume that when it
completes, the devices have been created. However, kpartx runs in async
mode by default.  This seems like it is likely to trip up users.  So,
switch the default to sync mode, add a -n option to enable async mode,
and set async mode when kpartx is called by the udev rules.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c     | 10 +++++++---
 kpartx/kpartx.rules |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 58e60ff..d1edd5e 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -58,7 +58,7 @@ struct pt {
 } pts[MAXTYPES];
 
 int ptct = 0;
-int udev_sync = 0;
+int udev_sync = 1;
 
 static void
 addpts(char *t, ptreader f)
@@ -86,7 +86,7 @@ initpts(void)
 	addpts("ps3", read_ps3_pt);
 }
 
-static char short_opts[] = "rladfgvp:t:su";
+static char short_opts[] = "rladfgvp:t:snu";
 
 /* Used in gpt.c */
 int force_gpt=0;
@@ -105,7 +105,8 @@ usage(void) {
 	printf("\t-g force GUID partition table (GPT)\n");
 	printf("\t-f force devmap create\n");
 	printf("\t-v verbose\n");
-	printf("\t-s sync mode. Don't return until the partitions are created\n");
+	printf("\t-n nosync mode. Return before the partitions are created\n");
+	printf("\t-s sync mode. Don't return until the partitions are created. Default.\n");
 	return 1;
 }
 
@@ -291,6 +292,9 @@ main(int argc, char **argv){
 		case 's':
 			udev_sync = 1;
 			break;
+		case 'n':
+			udev_sync = 0;
+			break;
 		case 'u':
 			what = UPDATE;
 			break;
diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 48a4d6c..a958791 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -40,6 +40,6 @@ ENV{DM_NR_VALID_PATHS}=="0", GOTO="kpartx_end"
 ENV{ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", IMPORT{db}="DM_SUBSYSTEM_UDEV_FLAG1"
 ENV{DM_SUBSYSTEM_UDEV_FLAG1}=="1", GOTO="kpartx_end"
 ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
-	RUN+="/sbin/kpartx -u -p -part /dev/$name"
+	RUN+="/sbin/kpartx -un -p -part /dev/$name"
 
 LABEL="kpartx_end"
-- 
1.8.3.1
