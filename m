From: tang.junhui@zte.com.cn
Subject: [PATCH] kpartx: partitions of mapped devices cannot be
	created in redhat OS
Date: Mon, 29 Aug 2016 19:09:18 +0800
Message-ID: <1472468958-11300-1-git-send-email-tang.junhui@zte.com.cn>
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

Environment variables such as DM_TABLE_STATE are used in kpartx.rules which exported
by "dmsetup export" in previous udev rules in SuSE OS, however, there is no such command
"dmsetup export" in redhat OS, so these environment variables are not initialized and
 partitions cannot be created. This patch replace "dmsetup export" with "dmsetup info"
 to get the status of mapped device, which can work well both in SuSE and redhat OS.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 kpartx/kpartx.rules | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 1713f3c..8c8b836 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -7,8 +7,12 @@
 KERNEL!="dm-*", GOTO="kpartx_end"
 ACTION=="remove", GOTO="kpartx_end"
 
-ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
-ENV{DM_DEPS}=="0", GOTO="kpartx_end"
+ENV{DMSETUP_SBIN_PATH}="/sbin"
+TEST!="$env{DMSETUP_SBIN_PATH}/dmsetup", ENV{DMSETUP_SBIN_PATH}="/usr/sbin"
+IMPORT{program}="$env{DMSETUP_SBIN_PATH}/dmsetup info -j %M -m %m -c --nameprefixes --noheadings --rows -o tables_loaded,device_count"
+
+ENV{DM_TABLES_LOADED}!="Live", GOTO="kpartx_end"
+ENV{DM_DEVICE_COUNT}=="0", GOTO="kpartx_end"
 
 ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
@@ -37,7 +41,7 @@ ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
 # Create dm tables for partitions
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
 ENV{DM_NR_VALID_PATHS}=="0", GOTO="kpartx_end"
-ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
+ENV{DM_SUSPENDED}!="Suspended", ENV{DM_UUID}=="mpath-*", \
 	RUN+="/sbin/kpartx -u -p -part /dev/$name"
 
 LABEL="kpartx_end"
-- 
2.8.1.windows.1
