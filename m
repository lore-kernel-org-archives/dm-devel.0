From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 19/31] 11-dm-mpath.rules: handle new maps with
	READY==0
Date: Sun,  3 Sep 2017 00:38:48 +0200
Message-ID: <20170902223900.7339-20-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

We need to distinguish the case where a device came up with
ENV{MPATH_DEVICE_READY}=="0" in the first place from the case
where it changed from "ready" to "not ready".

Otherwise, we may save a wrong state in DM_DISABLE_OTHER_RULES_FLAG_OLD.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index abf7987b..0be22ae4 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -39,7 +39,7 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
 
 # This event is either a PATH_REINSTATED or a table reload where
 # there are active paths. Mark the device ready
-ENV{MPATH_DEVICE_READY}=""
+ENV{MPATH_DEVICE_READY}="1"
 
 LABEL="mpath_action"
 # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
@@ -58,10 +58,10 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
 # Also skip all foreign rules if no path is available.
 # Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
 # and restore it back once we have at least one path available.
-ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}!="0",\
+ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1",\
 	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="",\
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}",\
-	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
+	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
+ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
 ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
 	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="",\
-- 
2.14.0
