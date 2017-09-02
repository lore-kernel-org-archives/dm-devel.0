From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 20/31] 11-dm-mpath.rules: don't set
	READY->ACTIVATION
Date: Sun,  3 Sep 2017 00:38:49 +0200
Message-ID: <20170902223900.7339-21-mwilck@suse.com>
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

The fact alone that a map changes from not ready to ready does
not imply that it is activating.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 0be22ae4..3f47744f 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -64,8 +64,7 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1",\
 ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
 ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="",\
-	ENV{DM_ACTIVATION}="1"
+	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=""
 
 LABEL="scan_import"
 ENV{DM_NOSCAN}!="1", GOTO="mpath_end"
-- 
2.14.0
