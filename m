From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 22/23] multipathd: update path group prio in
	check_path
Date: Tue,  6 Mar 2018 00:15:06 +0100
Message-ID: <20180305231507.10386-23-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The previous patch "libmultipath: don't update path groups when printing"
removed the call to path_group_prio_update() in the printing code path.
To compensate for that, recalculate path group prio also when it's not
strictly necessary (i.e. if failback "manual" is set).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 465a1e291226..4abdd8f071c3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -252,8 +252,9 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 	struct path * pp;
 	unsigned int i, j;
 	struct config *conf;
+	int bestpg;
 
-	if (!mpp || mpp->pgfailback == -FAILBACK_MANUAL)
+	if (!mpp)
 		return 0;
 
 	/*
@@ -272,8 +273,11 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 	if (!mpp->pg || VECTOR_SIZE(mpp->paths) == 0)
 		return 0;
 
-	mpp->bestpg = select_path_group(mpp);
+	bestpg = select_path_group(mpp);
+	if (mpp->pgfailback == -FAILBACK_MANUAL)
+		return 0;
 
+	mpp->bestpg = bestpg;
 	if (mpp->bestpg != mpp->nextpg)
 		return 1;
 
-- 
2.16.1
