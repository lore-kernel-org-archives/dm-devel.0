From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 40/57] libmultipath: fixup dm_rename to complete
	cookie on failure
Date: Wed, 27 Apr 2016 13:10:41 +0200
Message-ID: <1461755458-29225-41-git-send-email-hare@suse.de>
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

From my understanding we should be calling udev_complete() on
a cookie if dm_task_set_cookie() failed.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/devmapper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c2ae83b..b10f9e6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1440,8 +1440,10 @@ dm_rename (const char * old, char * new)
 	dm_task_no_open_count(dmt);
 
 	if (!dm_task_set_cookie(dmt, &cookie,
-				DM_UDEV_DISABLE_LIBRARY_FALLBACK))
+				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
+		dm_udev_complete(cookie);
 		goto out;
+	}
 	r = dm_task_run(dmt);
 
 	if (!r)
-- 
2.6.6
