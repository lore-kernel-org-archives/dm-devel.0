From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/10] kpartx: dm_devn: return error for
	non-existent device
Date: Sat,  6 May 2017 00:05:54 +0200
Message-ID: <20170505220559.7248-6-mwilck@suse.com>
References: <20170505220559.7248-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170505220559.7248-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

For non-existent maps (ENXIO from ioctl()), dm_task_run and
dm_task_get_info return success. We need to check info.exists.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 8f48a705..d6ccd000 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -293,7 +293,7 @@ dm_devn (const char * mapname, int *major, int *minor)
 	if (!dm_task_run(dmt))
 		goto out;
 
-	if (!dm_task_get_info(dmt, &info))
+	if (!dm_task_get_info(dmt, &info) || info.exists == 0)
 		goto out;
 
 	*major = info.major;
-- 
2.12.2
