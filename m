From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] kpartx.rules: Fix syntax error in skip_kpartx
	code
Date: Fri, 23 Jun 2017 23:57:40 +0200
Message-ID: <20170623215740.27628-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Fixes: 22736419 "kpartx.rules: respect skip_kpartx flag"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index a9587917..64d550de 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -37,7 +37,7 @@ ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
 # Create dm tables for partitions
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
 ENV{DM_NR_VALID_PATHS}=="0", GOTO="kpartx_end"
-ENV{ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", IMPORT{db}="DM_SUBSYSTEM_UDEV_FLAG1"
+ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", IMPORT{db}="DM_SUBSYSTEM_UDEV_FLAG1"
 ENV{DM_SUBSYSTEM_UDEV_FLAG1}=="1", GOTO="kpartx_end"
 ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
 	RUN+="/sbin/kpartx -un -p -part /dev/$name"
-- 
2.13.1
