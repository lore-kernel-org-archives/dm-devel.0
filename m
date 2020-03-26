From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 3/3] libmultipath: allow force reload with no
	active paths
Date: Wed, 25 Mar 2020 23:22:48 -0500
Message-ID: <1585196568-23714-3-git-send-email-bmarzins@redhat.com>
References: <1585196568-23714-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585196568-23714-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If the partition information has changed on multipath devices (say,
because it was updated on another node that has access to the same
storage), users expect that running "multipathd reconfigure" will update
that.  However, if the checkers for the multipath device are pending for
too long when the the device is reconfigured, multipathd will give up
waiting for them, and refuse to reload the device, since there are no
active paths. This means that no kpartx update will be triggered.

Multipath is fully capable of reloading a multipath device that has no
active paths. This has been possible for years. If multipath is supposed
to reload the device, it should do so, even if there are no active paths.

Generally, when multipath is force reloaded, kpartx will be updated.
However when a device is reloaded with no paths, the udev rules won't
run kpartx.  But they also weren't running kpartx when the first valid
path appeared, even though the dm activation rules get run in this case.
This changes 11-dm-mpath.rules to run kpartx when a device goes from no
usable paths to having usable paths.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c    | 6 ------
 multipath/11-dm-mpath.rules | 2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index c95848a0..96c79610 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -710,12 +710,6 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		return;
 	}
 
-	if (pathcount(mpp, PATH_UP) == 0) {
-		mpp->action = ACT_IMPOSSIBLE;
-		condlog(3, "%s: set ACT_IMPOSSIBLE (no usable path)",
-			mpp->alias);
-		return;
-	}
 	if (force_reload) {
 		mpp->force_udev_reload = 1;
 		mpp->action = ACT_RELOAD;
diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 07320a14..cd522e8c 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -75,7 +75,7 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
 ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
 	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
 	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="",\
-	ENV{DM_ACTIVATION}="1"
+	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
-- 
2.17.2
