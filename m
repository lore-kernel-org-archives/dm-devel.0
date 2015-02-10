From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 1/3] init: Export name_to_dev_t and mark it const
Date: Tue, 10 Feb 2015 15:20:49 -0800
Message-ID: <1423610451-22600-1-git-send-email-dehrenberg@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, snitzer@redhat.com, agk@redhat.com
Cc: grundler@chromium.org, gwendal@chromium.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com, Dan Ehrenberg <dehrenberg@chromium.org>
List-Id: dm-devel.ids

name_to_dev_t is useful in other pieces of code to initialize rootfs.
In the case of dm, the code is sometimes built in a module and other
times used to construct the rootfs; therefore it must be exported
as a symbol.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 include/linux/mount.h | 2 +-
 init/do_mounts.c      | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..bca086d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -92,6 +92,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index eb41008..4b2daf1 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -207,7 +207,7 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
@@ -286,6 +286,7 @@ fail:
 done:
 	return res;
 }
+EXPORT_SYMBOL(name_to_dev_t);
 
 static int __init root_dev_setup(char *line)
 {
-- 
2.2.0.rc0.207.ga3a616c
