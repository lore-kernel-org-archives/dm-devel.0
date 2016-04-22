From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 21/21] fuse: Allow user namespace mounts
Date: Fri, 22 Apr 2016 10:38:38 -0500
Message-ID: <1461339521-123191-22-git-send-email-seth.forshee@canonical.com>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 0a771145d853..254f1944ee98 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1199,7 +1199,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 	.mount		= fuse_mount,
 	.kill_sb	= fuse_kill_sb_anon,
 };
@@ -1231,7 +1231,7 @@ static struct file_system_type fuseblk_fs_type = {
 	.name		= "fuseblk",
 	.mount		= fuse_mount_blk,
 	.kill_sb	= fuse_kill_sb_blk,
-	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 };
 MODULE_ALIAS_FS("fuseblk");
 
-- 
1.9.1

