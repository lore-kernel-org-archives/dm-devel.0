From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH RFC] multipath-tools: *untested* use sysfs prio
 also for arrays with dual implicit/explicit alua support
Date: Sat, 25 Jul 2020 00:34:27 +0200
Message-ID: <acc2f009-c4b8-0c09-c77c-9400aac38cb1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids


Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 897e48ca..5a82234f 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -595,7 +595,7 @@ detect_prio(struct config *conf, struct path * pp)
  		tpgs = path_get_tpgs(pp);
  		if (tpgs == TPGS_NONE)
  			return;
-		if ((tpgs == TPGS_EXPLICIT || !check_rdac(pp)) &&
+		if ((tpgs == TPGS_EXPLICIT || tpgs == TPGS_BOTH || !check_rdac(pp)) &&
  		    sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
  			default_prio = PRIO_SYSFS;
  		else

In short:

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 897e48ca..a9609a01 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -595,7 +595,7 @@ detect_prio(struct config *conf, struct path * pp)
  		tpgs = path_get_tpgs(pp);
  		if (tpgs == TPGS_NONE)
  			return;
-		if ((tpgs == TPGS_EXPLICIT || !check_rdac(pp)) &&
+		if ((tpgs != TPGS_IMPLICIT || !check_rdac(pp)) &&
  		    sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
  			default_prio = PRIO_SYSFS;
  		else
