From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Subject: [PATCH 3 of 4] struct path: Move struct path from fs/namei.c into
	include/linux
Date: Wed, 18 Oct 2006 20:57:10 -0400
Message-ID: <17ebaa342f0525a5f34e.1161219430@thor.fsl.cs.sunysb.edu>
References: <patchbomb.1161219427@thor.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <patchbomb.1161219427@thor.fsl.cs.sunysb.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@osdl.org, hch@infradead.org, viro@ftp.linux.org.uk, mhalcrow@us.ibm.com, chris.mason@oracle.com, ezk@cs.sunysb.edu, penberg@cs.helsinki.fi, dm-devel@redhat.com, mingo@redhat.com, reiserfs-dev@namesys.com
List-Id: dm-devel.ids

From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Moved struct path from fs/namei.c to include/linux/namei.h. This allows many
places in the VFS, as well as any stackable filesystem to easily keep track
of dentry-vfsmount pairs.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

---

2 files changed, 5 insertions(+), 5 deletions(-)
fs/namei.c            |    5 -----
include/linux/namei.h |    5 +++++

diff --git a/fs/namei.c b/fs/namei.c
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -569,11 +569,6 @@ fail:
 	path_release(nd);
 	return PTR_ERR(link);
 }
-
-struct path {
-	struct vfsmount *mnt;
-	struct dentry *dentry;
-};
 
 static inline void dput_path(struct path *path, struct nameidata *nd)
 {
diff --git a/include/linux/namei.h b/include/linux/namei.h
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -27,6 +27,11 @@ struct nameidata {
 	union {
 		struct open_intent open;
 	} intent;
+};
+
+struct path {
+	struct vfsmount *mnt;
+	struct dentry *dentry;
 };
 
 /*


