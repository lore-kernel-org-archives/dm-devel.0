From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 0/5] User namespace mount updates
Date: Wed, 30 Sep 2015 15:15:09 -0500
Message-ID: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

Hi Eric,

Here's a batch of updates for the unprivileged user namespace mount
patches based on your feedback. I think everything you mentioned should
be addressed here.

These are now based on your for-testing branch.

Updates include:
 - Fix for incorrect use of flags argument in mount_mtd.
 - Eliminate lookup_bdev_perm and instead add an access mode argument to
   lookup_bdev.
 - Use __inode_permission instead of inode_permission when checking for
   rights towards a block device inode.
 - Add a patch replacing in_user_ns with current_in_user_ns.
 - Add a patch to handle Smack security labels consistently.

Thanks,
Seth

Andy Lutomirski (1):
  fs: Treat foreign mounts as nosuid

Seth Forshee (4):
  fs: Verify access of user towards block device file when mounting
  selinux: Add support for unprivileged mounts from user namespaces
  userns: Replace in_userns with current_in_userns
  Smack: Handle labels consistently in untrusted mounts

 drivers/md/bcache/super.c      |  2 +-
 drivers/md/dm-table.c          |  2 +-
 drivers/mtd/mtdsuper.c         |  6 +++++-
 fs/block_dev.c                 | 18 +++++++++++++++---
 fs/exec.c                      |  2 +-
 fs/namespace.c                 | 13 +++++++++++++
 fs/quota/quota.c               |  2 +-
 include/linux/fs.h             |  2 +-
 include/linux/mount.h          |  1 +
 include/linux/user_namespace.h |  6 ++----
 kernel/user_namespace.c        |  6 +++---
 security/commoncap.c           |  4 ++--
 security/selinux/hooks.c       | 25 ++++++++++++++++++++++++-
 security/smack/smack_lsm.c     | 28 ++++++++++++++++++----------
 14 files changed, 88 insertions(+), 29 deletions(-)
