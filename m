From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/78] kpartx.rules: Skip kpartx for multipath
	events
Date: Mon, 16 Mar 2015 13:36:14 +0100
Message-ID: <1426509425-15978-28-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Whenever multipath signals a PATH_FAILED or PATH_REINSTATED
event we don't have to call 'kpartx'; the contents on the disk
haven't changed.
And we should never call kpartx if all paths are down, irrespective
of the uevent.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 226e44a..022361f 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -40,8 +40,8 @@ ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
 	SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
 
 # Create dm tables for partitions
-ENV{DM_ACTION}=="PATH_FAILED", ENV{DM_NR_VALID_PATHS}=="0", \
-	GOTO="kpartx_end"
+ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
+ENV{DM_NR_VALID_PATHS}=="0", GOTO="kpartx_end"
 ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
         RUN+="/sbin/kpartx -u -p -part /dev/$name"
 
-- 
1.8.4.5
