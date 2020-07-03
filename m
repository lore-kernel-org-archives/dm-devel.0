From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 4/4] libmultipath: fix checker detection for
	nvme devices
Date: Thu,  2 Jul 2020 19:38:27 -0500
Message-ID: <1593736707-14216-5-git-send-email-bmarzins@redhat.com>
References: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
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

In order to fix hwhandler autodetection, commit 8794a776 made
detect_alua() differentiate between failures to detect whether alua was
supported, and successfully detecting that it was not supported.
However, this causes nvme devices to get the TUR checker assigned to
them. This is because there is nothing in detect_alua() to make it only
work on scsi devices, and select_checker wasn't updated to handle
detect_alua() failing without setting pp->tpgs to TPGS_NONE.

detect_alua() should automatically set pp->tpgs to TPGS_NONE and exit on
non-scsi devices. Also, select_checker() should not assume that a
devices is ALUA, simply because if failed to detect if alua was
supported.

Fixes: 8794a776 "libmultipath: fix ALUA autodetection when paths are
                 down"
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 6 ++++++
 libmultipath/propsel.c   | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 83a41a4a..aa5942c3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -887,6 +887,12 @@ detect_alua(struct path * pp)
 	int tpgs;
 	unsigned int timeout;
 
+
+	if (pp->bus != SYSFS_BUS_SCSI) {
+		pp->tpgs = TPGS_NONE;
+		return;
+	}
+
 	if (sysfs_get_timeout(pp, &timeout) <= 0)
 		timeout = DEF_TIMEOUT;
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 897e48ca..d362beb4 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -521,7 +521,9 @@ int select_checker(struct config *conf, struct path *pp)
 		if (check_rdac(pp)) {
 			ckr_name = RDAC;
 			goto out;
-		} else if (path_get_tpgs(pp) != TPGS_NONE) {
+		}
+		path_get_tpgs(pp);
+		if (pp->tpgs != TPGS_NONE && pp->tpgs != TPGS_UNDEF) {
 			ckr_name = TUR;
 			goto out;
 		}
-- 
2.17.2
