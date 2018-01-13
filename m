From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/20] libmultipath: select ALUA prioritizer
	for RDAC arrays only
Date: Sat, 13 Jan 2018 22:19:26 +0100
Message-ID: <20180113211938.31552-9-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Since commit 7e2f46d3, multipathd with "detect_prio" setting (=default)
chooses ALUA prioritizer rather than sysfs prioritizer for arrays with
implicit TPGS. But the intention of that patch was to choose ALUA for
NetApp E-Series (RDAC) storage arrays *only*, not for every array
with implicit TPGS.
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 4db0913a95a8..58a6a42fe333 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -497,7 +497,7 @@ detect_prio(struct config *conf, struct path * pp)
 
 	if (pp->tpgs <= 0)
 		return;
-	if (pp->tpgs == 2 && !check_rdac(pp)) {
+	if (pp->tpgs == 2 || !check_rdac(pp)) {
 		if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
 			default_prio = PRIO_SYSFS;
 	}
-- 
2.15.1
