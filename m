From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/39] libmultipath: fixup uninitialized return
	value in dm_reassign_table()
Date: Thu, 16 Jun 2016 11:47:09 +0200
Message-ID: <1466070465-1021-4-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index ce884e2..6e675fe 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1447,7 +1447,7 @@ void dm_reassign_deps(char *table, char *dep, char *newdep)
 
 int dm_reassign_table(const char *name, char *old, char *new)
 {
-	int r, modified = 0;
+	int r = 0, modified = 0;
 	uint64_t start, length;
 	struct dm_task *dmt, *reload_dmt;
 	char *target, *params = NULL;
-- 
2.6.6
