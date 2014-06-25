From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH] Don't forget to reload table when both reload
	and rename is required
Date: Wed, 25 Jun 2014 16:57:33 +0800
Message-ID: <1403686653-14879-1-git-send-email-vaughan.cao@oracle.com>
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

We encounter the following case:

@ After adding a multipaths section into /etc/multipath.conf to specify 'alias'
@ and other attributes for a particular multipath device and
@ reloading/restarting the multipathd service, only renaming of the multipath
@ device is done, other attribute changes are ignored.
@
@ It is more evident if you directly run 'multipath -r' to reload devmap after
@ adding the 'multipaths' section with alias into /etc/multipath.conf.
@
@ When reload/restart multipathd service or 'multipath -r' again, new settings
@ can be applied right.

It's because that in select_action() when force_reload is set, if we also need
rename the mpp device, reload action won't be taken any more.

I did this patch by introducing a new action ACT_RENAME2 to group these two
action. Test passed. However, it seems to be a rough patch and I am not
certain if this bind is fine refering to dm_reassign. Please comment, Thanks.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 libmultipath/configure.c | 11 +++++++++++
 libmultipath/configure.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3ed6b55..7331f90 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -385,6 +385,8 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 				cmpp->alias, mpp->alias);
 			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
 			mpp->action = ACT_RENAME;
+			if (force_reload)
+				mpp->action = ACT_RENAME2;
 			return;
 		}
 		mpp->action = ACT_CREATE;
@@ -623,6 +625,15 @@ domap (struct multipath * mpp, char * params)
 		r = dm_rename(mpp->alias_old, mpp->alias);
 		break;
 
+	case ACT_RENAME2:
+		r = dm_rename(mpp->alias_old, mpp->alias);
+		if (r) {
+			r = dm_addmap_reload(mpp, params);
+			if (r)
+				r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, MPATH_UDEV_RELOAD_FLAG);
+		}
+		break;
+
 	default:
 		break;
 	}
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index b3a6bb8..c014b55 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -18,6 +18,7 @@ enum actions {
 	ACT_RENAME,
 	ACT_CREATE,
 	ACT_RESIZE,
+	ACT_RENAME2,
 };
 
 #define FLUSH_ONE 1
-- 
1.9.0
