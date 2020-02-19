From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 16/18] fixup! libmultipath: add code to get
	vendor specific vpd data
Date: Wed, 19 Feb 2020 00:48:38 -0600
Message-ID: <1582094920-9883-17-git-send-email-bmarzins@redhat.com>
References: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 2 +-
 libmultipath/propsel.c   | 2 +-
 libmultipath/propsel.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 33a313a2..23a7889c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1646,7 +1646,7 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 	if (!(mask & DI_SERIAL))
 		return;
 
-	select_vpd_vendor_id(conf, pp);
+	select_vpd_vendor_id(pp);
 	vpd_id = pp->vpd_vendor_id;
 
 	if (vpd_id != VPD_VP_UNDEF && get_vpd_sgio(pp->fd, vpd_vendor_pages[vpd_id].pg, vpd_id, pp->vpd_data, sizeof(pp->vpd_data)) < 0)
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 8a2d9872..897e48ca 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -1218,7 +1218,7 @@ out:
 	return 0;
 }
 
-int select_vpd_vendor_id (struct config *conf, struct path *pp)
+int select_vpd_vendor_id (struct path *pp)
 {
 	const char *origin;
 
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 4fa08e1f..3d6edd8a 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -37,4 +37,4 @@ void reconcile_features_with_options(const char *id, char **features,
 				     int* no_path_retry,
 				     int *retain_hwhandler);
 int select_all_tg_pt (struct config *conf, struct multipath * mp);
-int select_vpd_vendor_id (struct config *conf, struct path *pp);
+int select_vpd_vendor_id (struct path *pp);
-- 
2.17.2
