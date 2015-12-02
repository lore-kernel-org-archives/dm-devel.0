From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 08/19] cred: Reject inodes with invalid ids in
 set_create_file_as()
Date: Wed,  2 Dec 2015 09:40:08 -0600
Message-ID: <1449070821-73820-9-git-send-email-seth.forshee@canonical.com>
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
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Seth Forshee <seth.forshee@canonical.com>, dm-devel@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, linux-security-module@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, fuse-devel@lists.sourceforge.net, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-mtd@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

Using INVALID_[UG]ID for the LSM file creation context doesn't
make sense, so return an error if the inode passed to
set_create_file_as() has an invalid id.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 kernel/cred.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cred.c b/kernel/cred.c
index 71179a09c1d6..ff8606f77d90 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -689,6 +689,8 @@ EXPORT_SYMBOL(set_security_override_from_ctx);
  */
 int set_create_files_as(struct cred *new, struct inode *inode)
 {
+	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
+		return -EINVAL;
 	new->fsuid = inode->i_uid;
 	new->fsgid = inode->i_gid;
 	return security_kernel_create_files_as(new, inode);
-- 
1.9.1


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
