From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 10:39:03 -0600
Message-ID: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

Hi Eric,

Here's another update to my patches for user namespace mounts, based on
your for-testing branch. These patches add safeguards necessary to allow
unprivileged mounts and update SELinux and Smack to safely handle
device-backed mounts from unprivileged users.

The v2 posting received very little in the way of feedback, so changes
are minimal. I've made a trivial style change to the Smack changes at
Casey's request, and I've added Stephen's ack for the SELinux changes.

Thanks,
Seth

Andy Lutomirski (1):
  fs: Treat foreign mounts as nosuid

Seth Forshee (6):
  block_dev: Support checking inode permissions in lookup_bdev()
  block_dev: Check permissions towards block device inode when mounting
  mtd: Check permissions towards mtd block device inode when mounting
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
 security/smack/smack_lsm.c     | 29 +++++++++++++++++++----------
 14 files changed, 89 insertions(+), 29 deletions(-)

