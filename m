From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/39] libmpathpersist: Fix possible overrun in
	devt2devname()
Date: Thu, 16 Jun 2016 11:47:25 +0200
Message-ID: <1466070465-1021-20-git-send-email-hare@suse.de>
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

pp->dev is of size FILE_NAME_SIZE, not PATH_SIZE.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index d2c3e53..c4b8521 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -84,7 +84,7 @@ updatepaths (struct multipath * mpp)
 
 		vector_foreach_slot (pgp->paths, pp, j){
 			if (!strlen(pp->dev)){
-				if (devt2devname(pp->dev, PATH_SIZE,
+				if (devt2devname(pp->dev, FILE_NAME_SIZE,
 						 pp->dev_t)){
 					/*
 					 * path is not in sysfs anymore
-- 
2.6.6
