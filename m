From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH] check info.exists to get valid value
Date: Wed, 25 Jun 2014 16:08:28 +0800
Message-ID: <1403683708-14220-1-git-send-email-vaughan.cao@oracle.com>
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
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com, vaughan.cao@oracle.com
List-Id: dm-devel.ids

dm_task_get_info will still return 1 if device doesn't exist.
Check info.exists to ensure major and minor values are valid.

There is no reason to assign info.open_count to @r here.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 libmultipath/devmapper.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 30e9351..3d4c111 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -567,10 +567,9 @@ dm_dev_t (const char * mapname, char * dev_t, int len)
 	if (!dm_task_run(dmt))
 		goto out;
 
-	if (!dm_task_get_info(dmt, &info))
+	if (!dm_task_get_info(dmt, &info) || !info.exists)
 		goto out;
 
-	r = info.open_count;
 	if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) > len)
 		    goto out;
 
-- 
1.9.0
