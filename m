From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 02/32] libmultipath: fix detect alua corner case
Date: Wed,  1 Aug 2018 15:56:48 -0500
Message-ID: <1533157038-3924-3-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If retain_attach_hw_handler = no, then the paths tpgs state will never
be checked, and the multipath device will always select the alua
handler, if no other handler is selected. the paths tpgs state
should be checked, regardless of the retain_hwhandler value.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index af3ed62..fdb5953 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -420,9 +420,11 @@ int select_hwhandler(struct config *conf, struct multipath *mp)
 	bool all_tpgs = true;
 
 	dh_state = &handler[2];
+
+	vector_foreach_slot(mp->paths, pp, i)
+		all_tpgs = all_tpgs && (pp->tpgs > 0);
 	if (mp->retain_hwhandler != RETAIN_HWHANDLER_OFF) {
 		vector_foreach_slot(mp->paths, pp, i) {
-			all_tpgs = all_tpgs && (pp->tpgs > 0);
 			if (get_dh_state(pp, dh_state, sizeof(handler) - 2) > 0
 			    && strcmp(dh_state, "detached")) {
 				memcpy(handler, "1 ", 2);
-- 
2.7.4
