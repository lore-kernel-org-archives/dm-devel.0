From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm log: use PTR_ERR value instead of -ENOMEM
Date: Fri,  7 Jan 2011 15:21:17 -0500
Message-ID: <1294431677-6561-1-git-send-email-snitzer@redhat.com>
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
Cc: Dan Carpenter <error27@gmail.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Dan Carpenter <error27@gmail.com>

It's nicer to return the PTR_ERR() value instead of just returning
-ENOMEM.  In the current code the PTR_ERR() value is always equal to
-ENOMEM so this doesn't actually affect anything, but still...

In addition, dm_dirty_log_create() doesn't check for a specific -ENOMEM
return.  So this change is safe relative to potential for a non -ENOMEM
return in the future.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: just tweaked the header
    - v1 is available here: https://patchwork.kernel.org/patch/101776/

Index: linux-2.6/drivers/md/dm-log.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log.c
+++ linux-2.6/drivers/md/dm-log.c
@@ -455,7 +455,7 @@ static int create_log_context(struct dm_
 			r = PTR_ERR(lc->io_req.client);
 			DMWARN("couldn't allocate disk io client");
 			kfree(lc);
-			return -ENOMEM;
+			return r;
 		}
 
 		lc->disk_header = vmalloc(buf_size);
