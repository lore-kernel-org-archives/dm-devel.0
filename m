From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/14] libmultipath: select ALUA prioritizer for
	RDAC arrays only
Date: Fri, 12 Jan 2018 23:07:38 +0100
Message-ID: <20180112220743.11513-10-mwilck@suse.com>
References: <20180112220743.11513-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112220743.11513-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Since commit 7e2f46d3, multipathd with "detect_prio" setting (=default)
chooses ALUA prioritizer rather than sysfs prioritizer for arrays with
implicit TPGS. But the intention of that patch was to choose ALUA for
NetApp E-Series (RDAC) storage arrays *only*, not for every array
with implicit TPGS.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d08954ac8464..4dba4c50beb9 100644
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
