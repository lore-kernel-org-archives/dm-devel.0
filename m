From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 14/18] Replicator: activate change for vgchange
Date: Mon,  2 Nov 2009 15:20:18 +0100
Message-ID: <1257171622-8380-15-git-send-email-zkabelac@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-5-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-6-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-7-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-8-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-9-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-10-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-11-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-12-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-13-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-14-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-14-git-send-email-zkabelac@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Activate only replicator-dev lv. Activation of one replicator-dev LV
will activivate also all other related LVs.

NOTE:
When the patch for skipping of utomatic activation of hidden volumes
is applied this patch can be simplified

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
---
 tools/vgchange.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/vgchange.c b/tools/vgchange.c
index d6af3b0..7fefe0a 100644
--- a/tools/vgchange.c
+++ b/tools/vgchange.c
@@ -69,6 +69,12 @@ static int _activate_lvs_in_vg(struct cmd_context *cmd,
 		if ((lv->status & MIRROR_IMAGE) || (lv->status & MIRROR_LOG))
 			continue;
 
+		/* Only request activation of the first replicator-dev LV */
+		if (lv_is_rlog(lv) || lv_is_slog(lv) || lv_is_rimage(lv) ||
+		    lv_is_replicator(lv) ||
+		    (lv_is_replicator_dev(lv) && (lv != first_replicator_dev(lv))))
+			continue;
+
 		/* Can't deactivate a pvmove LV */
 		/* FIXME There needs to be a controlled way of doing this */
 		if (((activate == CHANGE_AN) || (activate == CHANGE_ALN)) &&
-- 
1.6.5.1
