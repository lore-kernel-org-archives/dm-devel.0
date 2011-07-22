From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] sysfs: remove s_sibling hacks
Date: Thu, 21 Jul 2011 20:01:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107212000310.19975@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1107211957210.19975@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1107211959390.19975@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1107211959390.19975@hs20-bc2-1.build.redhat.com>
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

sysfs: remove s_sibling hacks

s_sibling was used for three different purposes:
1) as a linked list of entries in the directory
2) as a linked list of entries to be deleted
3) as a pointer to "struct completion"

This patch removes the hack and introduces new union u which
holds pointers for cases 2) and 3).

This change is needed for the following patch that removes s_sibling at all
and replaces it with a rb tree.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/sysfs/dir.c   |   19 +++++++------------
 fs/sysfs/sysfs.h |    5 +++++
 2 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-3.0-rc7-fast/fs/sysfs/dir.c
===================================================================
--- linux-3.0-rc7-fast.orig/fs/sysfs/dir.c	2011-07-20 20:42:25.000000000 +0200
+++ linux-3.0-rc7-fast/fs/sysfs/dir.c	2011-07-20 20:55:15.000000000 +0200
@@ -157,7 +157,6 @@ struct sysfs_dirent *sysfs_get_active(st
  */
 void sysfs_put_active(struct sysfs_dirent *sd)
 {
-	struct completion *cmpl;
 	int v;
 
 	if (unlikely(!sd))
@@ -169,10 +168,9 @@ void sysfs_put_active(struct sysfs_diren
 		return;
 
 	/* atomic_dec_return() is a mb(), we'll always see the updated
-	 * sd->s_sibling.
+	 * sd->u.completion.
 	 */
-	cmpl = (void *)sd->s_sibling;
-	complete(cmpl);
+	complete(sd->u.completion);
 }
 
 /**
@@ -186,16 +184,16 @@ static void sysfs_deactivate(struct sysf
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
+	BUG_ON(!(sd->s_flags & SYSFS_FLAG_REMOVED));
 
 	if (!(sysfs_type(sd) & SYSFS_ACTIVE_REF))
 		return;
 
-	sd->s_sibling = (void *)&wait;
+	sd->u.completion = (void *)&wait;
 
 	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
 	/* atomic_add_return() is a mb(), put_active() will always see
-	 * the updated sd->s_sibling.
+	 * the updated sd->u.completion.
 	 */
 	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
 
@@ -204,8 +202,6 @@ static void sysfs_deactivate(struct sysf
 		wait_for_completion(&wait);
 	}
 
-	sd->s_sibling = NULL;
-
 	lock_acquired(&sd->dep_map, _RET_IP_);
 	rwsem_release(&sd->dep_map, 1, _RET_IP_);
 }
@@ -521,7 +517,7 @@ void sysfs_remove_one(struct sysfs_addrm
 	}
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
-	sd->s_sibling = acxt->removed;
+	sd->u.removed_list = acxt->removed;
 	acxt->removed = sd;
 }
 
@@ -545,8 +541,7 @@ void sysfs_addrm_finish(struct sysfs_add
 	while (acxt->removed) {
 		struct sysfs_dirent *sd = acxt->removed;
 
-		acxt->removed = sd->s_sibling;
-		sd->s_sibling = NULL;
+		acxt->removed = sd->u.removed_list;
 
 		sysfs_deactivate(sd);
 		unmap_bin_file(sd);
Index: linux-3.0-rc7-fast/fs/sysfs/sysfs.h
===================================================================
--- linux-3.0-rc7-fast.orig/fs/sysfs/sysfs.h	2011-07-20 20:42:12.000000000 +0200
+++ linux-3.0-rc7-fast/fs/sysfs/sysfs.h	2011-07-20 20:46:50.000000000 +0200
@@ -66,6 +66,11 @@ struct sysfs_dirent {
 
 	struct rb_node		name_node;
 
+	union {
+		struct completion	*completion;
+		struct sysfs_dirent	*removed_list;
+	} u;
+
 	const void		*s_ns; /* namespace tag */
 	union {
 		struct sysfs_elem_dir		s_dir;
