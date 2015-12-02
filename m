From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 02/19] block_dev: Check permissions towards block device inode
 when mounting
Date: Wed,  2 Dec 2015 09:40:02 -0600
Message-ID: <1449070821-73820-3-git-send-email-seth.forshee@canonical.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Seth Forshee <seth.forshee@canonical.com>, dm-devel@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, linux-security-module@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, fuse-devel@lists.sourceforge.net, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-mtd@lists.infradead.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

Unprivileged users should not be able to mount block devices when
they lack sufficient privileges towards the block device inode.
Update blkdev_get_by_path() to validate that the user has the
required access to the inode at the specified path. The check
will be skipped for CAP_SYS_ADMIN, so privileged mounts will
continue working as before.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/block_dev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3ebbde85d898..4fdb6ab59816 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1424,9 +1424,14 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
 					void *holder)
 {
 	struct block_device *bdev;
+	int perm = 0;
 	int err;
 
-	bdev = lookup_bdev(path, 0);
+	if (mode & FMODE_READ)
+		perm |= MAY_READ;
+	if (mode & FMODE_WRITE)
+		perm |= MAY_WRITE;
+	bdev = lookup_bdev(path, perm);
 	if (IS_ERR(bdev))
 		return bdev;
 
-- 
1.9.1


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
