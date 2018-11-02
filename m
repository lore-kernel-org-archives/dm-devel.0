From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 20/21] libmultipath: sync_map_state: log
	failing paths
Date: Fri,  2 Nov 2018 13:21:24 +0100
Message-ID: <20181102122125.30906-21-mwilck@suse.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Emit a log message when force-failing exisiting paths.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f87d69d4..c85823a0 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -318,8 +318,11 @@ sync_map_state(struct multipath *mpp)
 			else if ((pp->dmstate == PSTATE_ACTIVE ||
 				  pp->dmstate == PSTATE_UNDEF) &&
 				 (pp->state == PATH_DOWN ||
-				  pp->state == PATH_SHAKY))
+				  pp->state == PATH_SHAKY)) {
+				condlog(2, "sync_map_state: failing %s state %d dmstate %d",
+					pp->dev, pp->state, pp->dmstate);
 				dm_fail_path(mpp->alias, pp->dev_t);
+			}
 		}
 	}
 }
-- 
2.19.1
