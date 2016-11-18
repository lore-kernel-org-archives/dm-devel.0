From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Avoid that reloading a map sporadically triggers
	I/O errors
Date: Fri, 18 Nov 2016 13:33:44 -0800
Message-ID: <85315cb2-6908-70c6-78b7-06b6c1071f6b@sandisk.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Avoid that reloading a map while there are no paths triggers a flush
and hence unwanted I/O errors if 'queue_if_no_path' is enabled.

Fixes: commit d569988e7528 ("libmultipath: Fixup 'DM_DEVICE_RELOAD' handling")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f92ebce..31f1962 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -390,7 +390,7 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 			      params, ADDMAP_RO, SKIP_KPARTX_OFF);
 	}
 	if (r)
-		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, flush,
+		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
 				 1, udev_flags, 0);
 	return r;
 }
-- 
2.10.1
