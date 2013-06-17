From: taget@linux.vnet.ibm.com
Subject: [PATCH] multipathd/cli_handlers cli_resize : check pp
	and pgp before calling them to avoid multipathd core dump.
Date: Mon, 17 Jun 2013 11:53:22 +0800
Message-ID: <1371441202-10938-1-git-send-email-taget@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Eli Qiao <taget@linux.vnet.ibm.com>
List-Id: dm-devel.ids

From: Eli Qiao <taget@linux.vnet.ibm.com>

Signed-off-by: Eli Qiao <taget@linux.vnet.ibm.com>
---
 multipathd/cli_handlers.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 7b1cb62..4b860bb 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -603,7 +603,18 @@ cli_resize(void *v, char **reply, int *len, void *data)
 	}
 
 	pgp = VECTOR_SLOT(mpp->pg, 0);
+
+	if (!pgp){
+		condlog(0, "%s: couldn't get path group. cannot resize",
+			mapname);
+		return 1;
+	}
 	pp = VECTOR_SLOT(pgp->paths, 0);
+
+	if (!pp){
+		condlog(0, "%s: couldn't get path. cannot resize", mapname);
+		return 1;
+	}
 	if (!pp->udev || sysfs_get_size(pp, &size)) {
 		condlog(0, "%s: couldn't get size for sysfs. cannot resize",
 			mapname);
-- 
1.8.1.4
