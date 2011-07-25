From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] sysfs: use rb-tree for inode number
	lookup
Date: Mon, 25 Jul 2011 17:57:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107251756030.21717@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1107211957210.19975@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1107211959390.19975@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1107212000310.19975@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1107212001170.19975@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1107212001170.19975@hs20-bc2-1.build.redhat.com>
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



On Thu, 21 Jul 2011, Mikulas Patocka wrote:

> sysfs: use rb-tree for inode number lookup
> 
> This patch makes sysfs use red-black tree for inode number lookup.
> Together with a previous patch to use red-black tree for name lookup,
> this patch makes all sysfs lookups to have O(log n) complexity.
> 
> This patch improves time to create 10000 block devices from 68 seconds to 
> 37 seconds. It improves time to delete 10000 block devices from 11 seconds 
> to 3.3 seconds.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  fs/sysfs/dir.c   |   89 ++++++++++++++++++++++++++++++-------------------------
>  fs/sysfs/sysfs.h |    5 +--
>  2 files changed, 52 insertions(+), 42 deletions(-)
> 
> Index: linux-3.0-rc7-fast/fs/sysfs/dir.c
> ===================================================================
> --- linux-3.0-rc7-fast.orig/fs/sysfs/dir.c	2011-07-20 20:55:15.000000000 +0200
> +++ linux-3.0-rc7-fast/fs/sysfs/dir.c	2011-07-20 23:30:47.000000000 +0200
> @@ -43,26 +43,30 @@ static DEFINE_IDA(sysfs_ino_ida);
>  static void sysfs_link_sibling(struct sysfs_dirent *sd)
>  {
>  	struct sysfs_dirent *parent_sd = sd->s_parent;
> -	struct sysfs_dirent **pos;
>  
>  	struct rb_node **p;
>  	struct rb_node *parent;
>  
> -	BUG_ON(sd->s_sibling);
> -
>  	if (sysfs_type(sd) == SYSFS_DIR)
>  		parent_sd->s_dir.subdirs++;
>  
> -	/* Store directory entries in order by ino.  This allows
> -	 * readdir to properly restart without having to add a
> -	 * cursor into the s_dir.children list.
> -	 */
> -	for (pos = &parent_sd->s_dir.children; *pos; pos = &(*pos)->s_sibling) {
> -		if (sd->s_ino < (*pos)->s_ino)
> -			break;
> +	p = &parent_sd->s_dir.inode_tree.rb_node;
> +	parent = NULL;
> +	while (*p) {
> +		parent = *p;
> +#define node	rb_entry(parent, struct sysfs_dirent, inode_node)
> +		if (sd->s_ino < node->s_ino) {
> +			p = &node->inode_node.rb_left;
> +		} else if (sd->s_ino > node->s_ino) {
> +			p = &node->inode_node.rb_right;
> +		} else {
> +			printk(KERN_CRIT "sysfs: inserting duplicate inode '%lx'\n", sd->s_ino);
> +			BUG();
> +		}
> +#undef node
>  	}
> -	sd->s_sibling = *pos;
> -	*pos = sd;
> +	rb_link_node(&sd->inode_node, parent, p);
> +	rb_insert_color(&sd->inode_node, &parent_sd->s_dir.inode_tree);
>  
>  	p = &parent_sd->s_dir.name_tree.rb_node;
>  	parent = NULL;
> @@ -97,20 +101,10 @@ static void sysfs_link_sibling(struct sy
>   */
>  static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
>  {
> -	struct sysfs_dirent **pos;
> -
>  	if (sysfs_type(sd) == SYSFS_DIR)
>  		sd->s_parent->s_dir.subdirs--;
>  
> -	for (pos = &sd->s_parent->s_dir.children; *pos;
> -	     pos = &(*pos)->s_sibling) {
> -		if (*pos == sd) {
> -			*pos = sd->s_sibling;
> -			sd->s_sibling = NULL;
> -			break;
> -		}
> -	}
> -
> +	rb_erase(&sd->inode_node, &sd->s_parent->s_dir.inode_tree);
>  	rb_erase(&sd->name_node, &sd->s_parent->s_dir.name_tree);
>  }
>  
> @@ -778,21 +772,19 @@ void sysfs_remove_subdir(struct sysfs_di
>  static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
>  {
>  	struct sysfs_addrm_cxt acxt;
> -	struct sysfs_dirent **pos;
> +	struct rb_node *pos;
>  
>  	if (!dir_sd)
>  		return;
>  
>  	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
>  	sysfs_addrm_start(&acxt, dir_sd);
> -	pos = &dir_sd->s_dir.children;
> -	while (*pos) {
> -		struct sysfs_dirent *sd = *pos;
> -
> +	pos = rb_first(&dir_sd->s_dir.inode_tree);
> +	while (pos) {
> +		struct sysfs_dirent *sd = rb_entry(pos, struct sysfs_dirent, inode_node);
> +		pos = rb_next(pos);
>  		if (sysfs_type(sd) != SYSFS_DIR)
>  			sysfs_remove_one(&acxt, sd);
> -		else
> -			pos = &(*pos)->s_sibling;
>  	}
>  	sysfs_addrm_finish(&acxt);
>  
> @@ -915,12 +907,28 @@ static struct sysfs_dirent *sysfs_dir_po
>  			pos = NULL;
>  	}
>  	if (!pos && (ino > 1) && (ino < INT_MAX)) {
> -		pos = parent_sd->s_dir.children;
> -		while (pos && (ino > pos->s_ino))
> -			pos = pos->s_sibling;
> +		struct rb_node *p = parent_sd->s_dir.inode_tree.rb_node;
> +		while (p) {
> +#define node	rb_entry(p, struct sysfs_dirent, inode_node)
> +			if (ino < node->s_ino) {
> +				pos = node;
> +				p = node->inode_node.rb_left;
> +			} else if (node->s_ino > ino) {
> +				p = node->inode_node.rb_right;
> +			} else {
> +				pos = node;
> +				break;
> +			}
> +#undef node
> +		}
> +	}
> +	while (pos && pos->s_ns && pos->s_ns != ns) {
> +		struct rb_node *p = rb_next(&pos->inode_node);
> +		if (!p)
> +			pos = NULL;
> +		else
> +			pos = rb_entry(p, struct sysfs_dirent, inode_node);
>  	}
> -	while (pos && pos->s_ns && pos->s_ns != ns)
> -		pos = pos->s_sibling;
>  	return pos;
>  }
>  
> @@ -928,10 +936,13 @@ static struct sysfs_dirent *sysfs_dir_ne
>  	struct sysfs_dirent *parent_sd,	ino_t ino, struct sysfs_dirent *pos)
>  {
>  	pos = sysfs_dir_pos(ns, parent_sd, ino, pos);
> -	if (pos)
> -		pos = pos->s_sibling;
> -	while (pos && pos->s_ns && pos->s_ns != ns)
> -		pos = pos->s_sibling;
> +	if (pos) do {
> +		struct rb_node *p = rb_next(&pos->inode_node);
> +		if (!p)
> +			pos = NULL;
> +		else
> +			pos = rb_entry(p, struct sysfs_dirent, inode_node);
> +	} while (pos && pos->s_ns && pos->s_ns != ns);
>  	return pos;
>  }
>  
> Index: linux-3.0-rc7-fast/fs/sysfs/sysfs.h
> ===================================================================
> --- linux-3.0-rc7-fast.orig/fs/sysfs/sysfs.h	2011-07-20 20:46:50.000000000 +0200
> +++ linux-3.0-rc7-fast/fs/sysfs/sysfs.h	2011-07-20 21:00:28.000000000 +0200
> @@ -18,11 +18,10 @@ struct sysfs_open_dirent;
>  /* type-specific structures for sysfs_dirent->s_* union members */
>  struct sysfs_elem_dir {
>  	struct kobject		*kobj;
> -	/* children list starts here and goes through sd->s_sibling */
> -	struct sysfs_dirent	*children;
>  
>  	unsigned long		subdirs;
>  
> +	struct rb_root		inode_tree;
>  	struct rb_root		name_tree;
>  };
>  
> @@ -61,9 +60,9 @@ struct sysfs_dirent {
>  	struct lockdep_map	dep_map;
>  #endif
>  	struct sysfs_dirent	*s_parent;
> -	struct sysfs_dirent	*s_sibling;
>  	const char		*s_name;
>  
> +	struct rb_node		inode_node;
>  	struct rb_node		name_node;
>  
>  	union {
> 
> 

Hi

This is updated patch. It fixes a typo in the rbtree search.

Mikulas

---

sysfs: use rb-tree for inode number lookup

This patch makes sysfs use red-black tree for inode number lookup.
Together with a previous patch to use red-black tree for name lookup,
this patch makes all sysfs lookups to have O(log n) complexity.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/sysfs/dir.c   |   89 ++++++++++++++++++++++++++++++-------------------------
 fs/sysfs/sysfs.h |    5 +--
 2 files changed, 52 insertions(+), 42 deletions(-)

Index: linux-3.0-fast/fs/sysfs/dir.c
===================================================================
--- linux-3.0-fast.orig/fs/sysfs/dir.c	2011-07-25 23:41:10.000000000 +0200
+++ linux-3.0-fast/fs/sysfs/dir.c	2011-07-25 23:41:13.000000000 +0200
@@ -43,26 +43,30 @@ static DEFINE_IDA(sysfs_ino_ida);
 static void sysfs_link_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *parent_sd = sd->s_parent;
-	struct sysfs_dirent **pos;
 
 	struct rb_node **p;
 	struct rb_node *parent;
 
-	BUG_ON(sd->s_sibling);
-
 	if (sysfs_type(sd) == SYSFS_DIR)
 		parent_sd->s_dir.subdirs++;
 
-	/* Store directory entries in order by ino.  This allows
-	 * readdir to properly restart without having to add a
-	 * cursor into the s_dir.children list.
-	 */
-	for (pos = &parent_sd->s_dir.children; *pos; pos = &(*pos)->s_sibling) {
-		if (sd->s_ino < (*pos)->s_ino)
-			break;
+	p = &parent_sd->s_dir.inode_tree.rb_node;
+	parent = NULL;
+	while (*p) {
+		parent = *p;
+#define node	rb_entry(parent, struct sysfs_dirent, inode_node)
+		if (sd->s_ino < node->s_ino) {
+			p = &node->inode_node.rb_left;
+		} else if (sd->s_ino > node->s_ino) {
+			p = &node->inode_node.rb_right;
+		} else {
+			printk(KERN_CRIT "sysfs: inserting duplicate inode '%lx'\n", sd->s_ino);
+			BUG();
+		}
+#undef node
 	}
-	sd->s_sibling = *pos;
-	*pos = sd;
+	rb_link_node(&sd->inode_node, parent, p);
+	rb_insert_color(&sd->inode_node, &parent_sd->s_dir.inode_tree);
 
 	p = &parent_sd->s_dir.name_tree.rb_node;
 	parent = NULL;
@@ -94,20 +98,10 @@ static void sysfs_link_sibling(struct sy
  */
 static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
-	struct sysfs_dirent **pos;
-
 	if (sysfs_type(sd) == SYSFS_DIR)
 		sd->s_parent->s_dir.subdirs--;
 
-	for (pos = &sd->s_parent->s_dir.children; *pos;
-	     pos = &(*pos)->s_sibling) {
-		if (*pos == sd) {
-			*pos = sd->s_sibling;
-			sd->s_sibling = NULL;
-			break;
-		}
-	}
-
+	rb_erase(&sd->inode_node, &sd->s_parent->s_dir.inode_tree);
 	rb_erase(&sd->name_node, &sd->s_parent->s_dir.name_tree);
 }
 
@@ -788,21 +782,19 @@ void sysfs_remove_subdir(struct sysfs_di
 static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent **pos;
+	struct rb_node *pos;
 
 	if (!dir_sd)
 		return;
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt, dir_sd);
-	pos = &dir_sd->s_dir.children;
-	while (*pos) {
-		struct sysfs_dirent *sd = *pos;
-
+	pos = rb_first(&dir_sd->s_dir.inode_tree);
+	while (pos) {
+		struct sysfs_dirent *sd = rb_entry(pos, struct sysfs_dirent, inode_node);
+		pos = rb_next(pos);
 		if (sysfs_type(sd) != SYSFS_DIR)
 			sysfs_remove_one(&acxt, sd);
-		else
-			pos = &(*pos)->s_sibling;
 	}
 	sysfs_addrm_finish(&acxt);
 
@@ -925,12 +917,28 @@ static struct sysfs_dirent *sysfs_dir_po
 			pos = NULL;
 	}
 	if (!pos && (ino > 1) && (ino < INT_MAX)) {
-		pos = parent_sd->s_dir.children;
-		while (pos && (ino > pos->s_ino))
-			pos = pos->s_sibling;
+		struct rb_node *p = parent_sd->s_dir.inode_tree.rb_node;
+		while (p) {
+#define node	rb_entry(p, struct sysfs_dirent, inode_node)
+			if (ino < node->s_ino) {
+				pos = node;
+				p = node->inode_node.rb_left;
+			} else if (ino > node->s_ino) {
+				p = node->inode_node.rb_right;
+			} else {
+				pos = node;
+				break;
+			}
+#undef node
+		}
+	}
+	while (pos && pos->s_ns && pos->s_ns != ns) {
+		struct rb_node *p = rb_next(&pos->inode_node);
+		if (!p)
+			pos = NULL;
+		else
+			pos = rb_entry(p, struct sysfs_dirent, inode_node);
 	}
-	while (pos && pos->s_ns && pos->s_ns != ns)
-		pos = pos->s_sibling;
 	return pos;
 }
 
@@ -938,10 +946,13 @@ static struct sysfs_dirent *sysfs_dir_ne
 	struct sysfs_dirent *parent_sd,	ino_t ino, struct sysfs_dirent *pos)
 {
 	pos = sysfs_dir_pos(ns, parent_sd, ino, pos);
-	if (pos)
-		pos = pos->s_sibling;
-	while (pos && pos->s_ns && pos->s_ns != ns)
-		pos = pos->s_sibling;
+	if (pos) do {
+		struct rb_node *p = rb_next(&pos->inode_node);
+		if (!p)
+			pos = NULL;
+		else
+			pos = rb_entry(p, struct sysfs_dirent, inode_node);
+	} while (pos && pos->s_ns && pos->s_ns != ns);
 	return pos;
 }
 
Index: linux-3.0-fast/fs/sysfs/sysfs.h
===================================================================
--- linux-3.0-fast.orig/fs/sysfs/sysfs.h	2011-07-25 23:41:10.000000000 +0200
+++ linux-3.0-fast/fs/sysfs/sysfs.h	2011-07-25 23:41:13.000000000 +0200
@@ -18,11 +18,10 @@ struct sysfs_open_dirent;
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
-	/* children list starts here and goes through sd->s_sibling */
-	struct sysfs_dirent	*children;
 
 	unsigned long		subdirs;
 
+	struct rb_root		inode_tree;
 	struct rb_root		name_tree;
 };
 
@@ -61,9 +60,9 @@ struct sysfs_dirent {
 	struct lockdep_map	dep_map;
 #endif
 	struct sysfs_dirent	*s_parent;
-	struct sysfs_dirent	*s_sibling;
 	const char		*s_name;
 
+	struct rb_node		inode_node;
 	struct rb_node		name_node;
 
 	union {
