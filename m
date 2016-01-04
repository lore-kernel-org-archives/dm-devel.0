From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH RESEND v2 00/19] Support fuse mounts in user namespaces
Date: Mon,  4 Jan 2016 12:03:39 -0600
Message-ID: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

These patches implement support for mounting filesystems in user
namespaces using fuse. They are based on the patches in the for-testing
branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git,
but I've rebased them onto 4.4-rc3. I've pushed all of this to:

 git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/linux.git fuse-userns

The patches are organized into three high-level groups.

Patches 1-6 are related to security, adding restrictions for
unprivileged mounts and updating the LSMs as needed. Patches 1-2
(checking inode permissions for block device mounts) may not be strictly
necessary for fuseblk mounts since fuse doesn't do any IO on the block
device in the kernel, but it still seems like a good idea to fail the
mount if the user doesn't have the required permissions for the inode
(though this is a bit misleading with fuse since the mounts are done via
a suid-root helper).

Patches 7-14 update most of the vfs to translate ids correctly and deal
with inodes which may have invalid user/group ids. I've omitted patches
for anything not used by fuse - quota, fs freezing, some helper
functions, etc. - but if these are wanted for the sake of completeness I
can include them.

Patches 15-18 update fuse to deal with mounts from non-init pid and user
namespaces and enable mounting from user namespaces.

Changes since v1:
 - Drop patch for FIBMAP.
 - Use current_in_userns in fuse_allow_current_process.
 - Remove checks for uid/gid validity in fuse. Intead, ids from the
   backing store which do not map into s_user_ns will result in invalid
   ids in the vfs inode. Checks in the vfs will prevent unmappable ids
   from being passed in from above.
 - Update a couple of commit messages to provide more detail about
   changes.

Thanks,
Seth

Andy Lutomirski (1):
  fs: Treat foreign mounts as nosuid

Seth Forshee (17):
  block_dev: Support checking inode permissions in lookup_bdev()
  block_dev: Check permissions towards block device inode when mounting
  selinux: Add support for unprivileged mounts from user namespaces
  userns: Replace in_userns with current_in_userns
  Smack: Handle labels consistently in untrusted mounts
  fs: Check for invalid i_uid in may_follow_link()
  cred: Reject inodes with invalid ids in set_create_file_as()
  fs: Refuse uid/gid changes which don't map into s_user_ns
  fs: Update posix_acl support to handle user namespace mounts
  fs: Ensure the mounter of a filesystem is privileged towards its
    inodes
  fs: Don't remove suid for CAP_FSETID in s_user_ns
  fs: Allow superblock owner to access do_remount_sb()
  capabilities: Allow privileged user in s_user_ns to set security.*
    xattrs
  fuse: Add support for pid namespaces
  fuse: Support fuse filesystems outside of init_user_ns
  fuse: Restrict allow_other to the superblock's namespace or a
    descendant
  fuse: Allow user namespace mounts

 drivers/md/bcache/super.c       |  2 +-
 drivers/md/dm-table.c           |  2 +-
 drivers/mtd/mtdsuper.c          |  2 +-
 fs/attr.c                       | 11 +++++++
 fs/block_dev.c                  | 18 +++++++++--
 fs/exec.c                       |  2 +-
 fs/fuse/cuse.c                  |  3 +-
 fs/fuse/dev.c                   | 26 ++++++++++++----
 fs/fuse/dir.c                   | 16 +++++-----
 fs/fuse/file.c                  | 22 +++++++++++---
 fs/fuse/fuse_i.h                | 10 +++++-
 fs/fuse/inode.c                 | 42 +++++++++++++++++---------
 fs/inode.c                      |  6 +++-
 fs/namei.c                      |  2 +-
 fs/namespace.c                  | 17 +++++++++--
 fs/posix_acl.c                  | 67 ++++++++++++++++++++++++++---------------
 fs/quota/quota.c                |  2 +-
 fs/xattr.c                      | 19 +++++++++---
 include/linux/fs.h              |  2 +-
 include/linux/mount.h           |  1 +
 include/linux/posix_acl_xattr.h | 17 ++++++++---
 include/linux/uidgid.h          | 10 ++++++
 include/linux/user_namespace.h  |  6 ++--
 kernel/capability.c             | 13 +++++---
 kernel/cred.c                   |  2 ++
 kernel/user_namespace.c         |  6 ++--
 security/commoncap.c            | 16 ++++++----
 security/selinux/hooks.c        | 25 ++++++++++++++-
 security/smack/smack_lsm.c      | 29 ++++++++++++------
 29 files changed, 287 insertions(+), 109 deletions(-)

-- 
1.9.1

