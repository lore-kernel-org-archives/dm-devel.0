From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Revert 'multipathd: Do not print misleading
	message "not found in pathvec"'
Date: Tue,  3 May 2016 11:18:53 +0200
Message-ID: <1462267133-15935-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

As discussed on the mailing list the logging messages should remain,
so revert the patch, increase the logging level and update the
message itself to be more instructive.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/structs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 937e4a2..502d98e 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -418,6 +418,7 @@ find_path_by_dev (vector pathvec, char * dev)
 		if (!strcmp(pp->dev, dev))
 			return pp;
 
+	condlog(4, "%s: dev not found in pathvec", dev);
 	return NULL;
 }
 
@@ -434,6 +435,7 @@ find_path_by_devt (vector pathvec, char * dev_t)
 		if (!strcmp(pp->dev_t, dev_t))
 			return pp;
 
+	condlog(4, "%s: dev_t not found in pathvec", dev_t);
 	return NULL;
 }
 
-- 
2.6.6
