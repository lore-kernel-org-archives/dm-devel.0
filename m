From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] sysfs: count subdirectories
Date: Thu, 21 Jul 2011 19:59:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107211957210.19975@hs20-bc2-1.build.redhat.com>
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
To: Greg KH <gregkh@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

sysfs: count subdirectories

This patch introduces a subdirectory counter for each sysfs directory.

Without the patch, sysfs_refresh_inode would walk all entries of the directory
to calculate the number of subdirectories.

This patch improves time of "ls -la /sys/block" when there are 10000 block 
devices from 9 seconds to 0.19 seconds.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/sysfs/dir.c   |    6 ++++++
 fs/sysfs/inode.c |   14 +-------------
 fs/sysfs/sysfs.h |    2 ++
 3 files changed, 9 insertions(+), 13 deletions(-)

Index: linux-3.0-rc7-fast/fs/sysfs/dir.c
===================================================================
--- linux-3.0-rc7-fast.orig/fs/sysfs/dir.c	2011-07-18 19:43:05.000000000 +0200
+++ linux-3.0-rc7-fast/fs/sysfs/dir.c	2011-07-18 19:45:06.000000000 +0200
@@ -47,6 +47,9 @@ static void sysfs_link_sibling(struct sy
 
 	BUG_ON(sd->s_sibling);
 
+	if (sysfs_type(sd) == SYSFS_DIR)
+		parent_sd->s_dir.subdirs++;
+
 	/* Store directory entries in order by ino.  This allows
 	 * readdir to properly restart without having to add a
 	 * cursor into the s_dir.children list.
@@ -73,6 +76,9 @@ static void sysfs_unlink_sibling(struct 
 {
 	struct sysfs_dirent **pos;
 
+	if (sysfs_type(sd) == SYSFS_DIR)
+		sd->s_parent->s_dir.subdirs--;
+
 	for (pos = &sd->s_parent->s_dir.children; *pos;
 	     pos = &(*pos)->s_sibling) {
 		if (*pos == sd) {
Index: linux-3.0-rc7-fast/fs/sysfs/inode.c
===================================================================
--- linux-3.0-rc7-fast.orig/fs/sysfs/inode.c	2011-07-18 19:43:33.000000000 +0200
+++ linux-3.0-rc7-fast/fs/sysfs/inode.c	2011-07-18 19:45:50.000000000 +0200
@@ -202,18 +202,6 @@ static inline void set_inode_attr(struct
 	inode->i_ctime = iattr->ia_ctime;
 }
 
-static int sysfs_count_nlink(struct sysfs_dirent *sd)
-{
-	struct sysfs_dirent *child;
-	int nr = 0;
-
-	for (child = sd->s_dir.children; child; child = child->s_sibling)
-		if (sysfs_type(child) == SYSFS_DIR)
-			nr++;
-
-	return nr + 2;
-}
-
 static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	struct sysfs_inode_attrs *iattrs = sd->s_iattr;
@@ -230,7 +218,7 @@ static void sysfs_refresh_inode(struct s
 	}
 
 	if (sysfs_type(sd) == SYSFS_DIR)
-		inode->i_nlink = sysfs_count_nlink(sd);
+		inode->i_nlink = sd->s_dir.subdirs + 2;
 }
 
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
Index: linux-3.0-rc7-fast/fs/sysfs/sysfs.h
===================================================================
--- linux-3.0-rc7-fast.orig/fs/sysfs/sysfs.h	2011-07-18 19:42:42.000000000 +0200
+++ linux-3.0-rc7-fast/fs/sysfs/sysfs.h	2011-07-18 19:44:28.000000000 +0200
@@ -19,6 +19,8 @@ struct sysfs_elem_dir {
 	struct kobject		*kobj;
 	/* children list starts here and goes through sd->s_sibling */
 	struct sysfs_dirent	*children;
+
+	unsigned long		subdirs;
 };
 
 struct sysfs_elem_symlink {
