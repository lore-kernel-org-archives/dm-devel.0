From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/4] sysfs: use rb-tree for name lookups
Date: Mon, 25 Jul 2011 17:55:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107251752560.21717@hs20-bc2-1.build.redhat.com>
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



On Thu, 21 Jul 2011, Mikulas Patocka wrote:

> sysfs: use rb-tree for name lookups
> 
> Use red-black tree for name lookups.
> 
> This patch improves time to create 10000 block devices from 120 seconds to 
> 68 seconds.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  fs/sysfs/dir.c   |   45 +++++++++++++++++++++++++++++++++++++++------
>  fs/sysfs/sysfs.h |    5 +++++
>  2 files changed, 44 insertions(+), 6 deletions(-)
> 
> Index: linux-3.0-rc7-fast/fs/sysfs/sysfs.h
> ===================================================================
> --- linux-3.0-rc7-fast.orig/fs/sysfs/sysfs.h	2011-07-18 20:06:24.000000000 +0200
> +++ linux-3.0-rc7-fast/fs/sysfs/sysfs.h	2011-07-18 20:16:32.000000000 +0200
> @@ -11,6 +11,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/kobject_ns.h>
>  #include <linux/fs.h>
> +#include <linux/rbtree.h>
>  
>  struct sysfs_open_dirent;
>  
> @@ -21,6 +22,8 @@ struct sysfs_elem_dir {
>  	struct sysfs_dirent	*children;
>  
>  	unsigned long		subdirs;
> +
> +	struct rb_root		name_tree;
>  };
>  
>  struct sysfs_elem_symlink {
> @@ -61,6 +64,8 @@ struct sysfs_dirent {
>  	struct sysfs_dirent	*s_sibling;
>  	const char		*s_name;
>  
> +	struct rb_node		name_node;
> +
>  	const void		*s_ns; /* namespace tag */
>  	union {
>  		struct sysfs_elem_dir		s_dir;
> Index: linux-3.0-rc7-fast/fs/sysfs/dir.c
> ===================================================================
> --- linux-3.0-rc7-fast.orig/fs/sysfs/dir.c	2011-07-18 20:06:24.000000000 +0200
> +++ linux-3.0-rc7-fast/fs/sysfs/dir.c	2011-07-18 20:16:02.000000000 +0200
> @@ -45,6 +45,9 @@ static void sysfs_link_sibling(struct sy
>  	struct sysfs_dirent *parent_sd = sd->s_parent;
>  	struct sysfs_dirent **pos;
>  
> +	struct rb_node **p;
> +	struct rb_node *parent;
> +
>  	BUG_ON(sd->s_sibling);
>  
>  	if (sysfs_type(sd) == SYSFS_DIR)
> @@ -60,6 +63,26 @@ static void sysfs_link_sibling(struct sy
>  	}
>  	sd->s_sibling = *pos;
>  	*pos = sd;
> +
> +	p = &parent_sd->s_dir.name_tree.rb_node;
> +	parent = NULL;
> +	while (*p) {
> +		int c;
> +		parent = *p;
> +#define node	rb_entry(parent, struct sysfs_dirent, name_node)
> +		c = strcmp(sd->s_name, node->s_name);
> +		if (c < 0) {
> +			p = &node->name_node.rb_left;
> +		} else if (c > 0) {
> +			p = &node->name_node.rb_right;
> +		} else {
> +			printk(KERN_CRIT "sysfs: inserting duplicate filename '%s'\n", sd->s_name);
> +			BUG();
> +		}
> +#undef node
> +	}
> +	rb_link_node(&sd->name_node, parent, p);
> +	rb_insert_color(&sd->name_node, &parent_sd->s_dir.name_tree);
>  }
>  
>  /**
> @@ -87,6 +110,8 @@ static void sysfs_unlink_sibling(struct 
>  			break;
>  		}
>  	}
> +
> +	rb_erase(&sd->name_node, &sd->s_parent->s_dir.name_tree);
>  }
>  
>  /**
> @@ -546,14 +571,22 @@ struct sysfs_dirent *sysfs_find_dirent(s
>  				       const void *ns,
>  				       const unsigned char *name)
>  {
> -	struct sysfs_dirent *sd;
> +	struct rb_node *p = parent_sd->s_dir.name_tree.rb_node;
>  
> -	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
> -		if (ns && sd->s_ns && (sd->s_ns != ns))
> -			continue;
> -		if (!strcmp(sd->s_name, name))
> -			return sd;
> +	while (p) {
> +		int c;
> +#define node	rb_entry(p, struct sysfs_dirent, name_node)
> +		c = strcmp(name, node->s_name);
> +		if (c < 0) {
> +			p = node->name_node.rb_left;
> +		} else if (c > 0) {
> +			p = node->name_node.rb_right;
> +		} else {
> +			return node;
> +		}
> +#undef node
>  	}
> +
>  	return NULL;
>  }
>  
> 
> 

This is updated path. The previous patch accidentally ignored namespaces.

Mikulas

---

sysfs: use rb-tree for name lookups

Use red-black tree for name lookups.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/sysfs/dir.c   |   57 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/sysfs/sysfs.h |    5 ++++
 2 files changed, 55 insertions(+), 7 deletions(-)

Index: linux-3.0-fast/fs/sysfs/sysfs.h
===================================================================
--- linux-3.0-fast.orig/fs/sysfs/sysfs.h	2011-07-25 23:31:18.000000000 +0200
+++ linux-3.0-fast/fs/sysfs/sysfs.h	2011-07-25 23:54:34.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/lockdep.h>
 #include <linux/kobject_ns.h>
 #include <linux/fs.h>
+#include <linux/rbtree.h>
 
 struct sysfs_open_dirent;
 
@@ -21,6 +22,8 @@ struct sysfs_elem_dir {
 	struct sysfs_dirent	*children;
 
 	unsigned long		subdirs;
+
+	struct rb_root		name_tree;
 };
 
 struct sysfs_elem_symlink {
@@ -61,6 +64,8 @@ struct sysfs_dirent {
 	struct sysfs_dirent	*s_sibling;
 	const char		*s_name;
 
+	struct rb_node		name_node;
+
 	const void		*s_ns; /* namespace tag */
 	union {
 		struct sysfs_elem_dir		s_dir;
Index: linux-3.0-fast/fs/sysfs/dir.c
===================================================================
--- linux-3.0-fast.orig/fs/sysfs/dir.c	2011-07-25 23:31:18.000000000 +0200
+++ linux-3.0-fast/fs/sysfs/dir.c	2011-07-25 23:54:34.000000000 +0200
@@ -45,6 +45,9 @@ static void sysfs_link_sibling(struct sy
 	struct sysfs_dirent *parent_sd = sd->s_parent;
 	struct sysfs_dirent **pos;
 
+	struct rb_node **p;
+	struct rb_node *parent;
+
 	BUG_ON(sd->s_sibling);
 
 	if (sysfs_type(sd) == SYSFS_DIR)
@@ -60,6 +63,23 @@ static void sysfs_link_sibling(struct sy
 	}
 	sd->s_sibling = *pos;
 	*pos = sd;
+
+	p = &parent_sd->s_dir.name_tree.rb_node;
+	parent = NULL;
+	while (*p) {
+		int c;
+		parent = *p;
+#define node	rb_entry(parent, struct sysfs_dirent, name_node)
+		c = strcmp(sd->s_name, node->s_name);
+		if (c < 0) {
+			p = &node->name_node.rb_left;
+		} else {
+			p = &node->name_node.rb_right;
+		}
+#undef node
+	}
+	rb_link_node(&sd->name_node, parent, p);
+	rb_insert_color(&sd->name_node, &parent_sd->s_dir.name_tree);
 }
 
 /**
@@ -87,6 +107,8 @@ static void sysfs_unlink_sibling(struct 
 			break;
 		}
 	}
+
+	rb_erase(&sd->name_node, &sd->s_parent->s_dir.name_tree);
 }
 
 /**
@@ -546,15 +568,36 @@ struct sysfs_dirent *sysfs_find_dirent(s
 				       const void *ns,
 				       const unsigned char *name)
 {
-	struct sysfs_dirent *sd;
+	struct rb_node *p = parent_sd->s_dir.name_tree.rb_node;
+	struct sysfs_dirent *found = NULL;
 
-	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
-		if (ns && sd->s_ns && (sd->s_ns != ns))
-			continue;
-		if (!strcmp(sd->s_name, name))
-			return sd;
+	while (p) {
+		int c;
+#define node	rb_entry(p, struct sysfs_dirent, name_node)
+		c = strcmp(name, node->s_name);
+		if (c < 0) {
+			p = node->name_node.rb_left;
+		} else if (c > 0) {
+			p = node->name_node.rb_right;
+		} else {
+			found = node;
+			p = node->name_node.rb_left;
+		}
+#undef node
 	}
-	return NULL;
+
+	if (found && ns) {
+		while (found->s_ns && found->s_ns != ns) {
+			p = rb_next(&found->name_node);
+			if (!p)
+				return NULL;
+			found = rb_entry(p, struct sysfs_dirent, name_node);
+			if (strcmp(name, found->s_name))
+				return NULL;
+		}
+	}
+
+	return found;
 }
 
 /**
