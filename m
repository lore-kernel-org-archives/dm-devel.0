From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/7] devmapper: wait for udev in
	dm_simplecmd_noflush()
Date: Mon,  9 May 2016 12:53:02 +0200
Message-ID: <1462791185-2903-5-git-send-email-hare@suse.de>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462791185-2903-1-git-send-email-hare@suse.de>
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

When calling dm_simplecmd_noflush() with udev_flags set we
need to set the 'need_sync' flag otherwise the udev flags
will never be set.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b976da7..9c6904a 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -628,7 +628,7 @@ domap (struct multipath * mpp, char * params)
 		r = dm_addmap_reload(mpp, params);
 		if (r)
 			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
-						 0, MPATH_UDEV_RELOAD_FLAG);
+						 1, MPATH_UDEV_RELOAD_FLAG);
 		break;
 
 	case ACT_RESIZE:
@@ -646,7 +646,9 @@ domap (struct multipath * mpp, char * params)
 		if (r) {
 			r = dm_addmap_reload(mpp, params);
 			if (r)
-				r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, 0, MPATH_UDEV_RELOAD_FLAG);
+				r = dm_simplecmd_noflush(DM_DEVICE_RESUME,
+							 mpp->alias, 1,
+							 MPATH_UDEV_RELOAD_FLAG);
 		}
 		break;
 
-- 
2.6.6
