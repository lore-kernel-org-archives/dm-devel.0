From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 01/21] fs: fix a posible leak of allocated superblock
Date: Fri, 22 Apr 2016 10:38:18 -0500
Message-ID: <1461339521-123191-2-git-send-email-seth.forshee@canonical.com>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

We probably need to fix superblock leak in patch (v4 "fs: Add user
namesapace member to struct super_block"):

Imagine posible code path in sget_userns: we iterate through
type->fs_supers and do not find suitable sb, we drop sb_lock to
allocate s and go to retry. After we dropped sb_lock some other
task from different userns takes sb_lock, it is already in retry
stage and has s allocated, so it puts its s in type->fs_supers
list. So in retry we will find these sb in list and check it has
a different userns, and finally we will return without freeing s.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Acked-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 829841e0ae7e..092a7828442e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -474,6 +474,10 @@ retry:
 				continue;
 			if (user_ns != old->s_user_ns) {
 				spin_unlock(&sb_lock);
+				if (s) {
+					up_write(&s->s_umount);
+					destroy_super(s);
+				}
 				return ERR_PTR(-EBUSY);
 			}
 			if (!grab_super(old))
-- 
1.9.1

