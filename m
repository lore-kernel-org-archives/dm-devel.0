From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 44/57] multipathd: Do not switch paths on empty
	multipath tables
Date: Wed, 27 Apr 2016 13:10:45 +0200
Message-ID: <1461755458-29225-45-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

If all paths are removed from a multipath table there is no
point in trying to switch path groups as we don't have any.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index ebb9a50..a86530f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -126,6 +126,9 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 			vector_foreach_slot (pgp->paths, pp, j)
 				pathinfo(pp, conf->hwtable, DI_PRIO);
 
+	if (!mpp->pg || VECTOR_SIZE(mpp->paths) == 0)
+		return 0;
+
 	mpp->bestpg = select_path_group(mpp);
 
 	if (mpp->bestpg != mpp->nextpg)
-- 
2.6.6
