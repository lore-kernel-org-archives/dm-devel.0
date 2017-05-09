From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/6] multipathd: force reload device on all
	resizes
Date: Tue,  9 May 2017 11:57:01 -0500
Message-ID: <1494349025-6561-3-git-send-email-bmarzins@redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

My previous patch missed setting force_udev_reload on resizes initiated
by

multipathd resize map <map>

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index efc12dd..d598039 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -870,6 +870,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 	update_mpp_paths(mpp, vecs->pathvec);
 	setup_map(mpp, params, PARAMS_SIZE);
 	mpp->action = ACT_RESIZE;
+	mpp->force_udev_reload = 1;
 	if (domap(mpp, params, 1) <= 0) {
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
-- 
1.8.3.1
