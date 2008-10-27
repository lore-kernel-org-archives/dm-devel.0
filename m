From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 0/3] freeze feature ver 1.14
Date: Mon, 27 Oct 2008 21:58:11 +0900
Message-ID: <20081027215811t-sato__34377.7061476887$1225112465$gmane$org@mail.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redh>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Hi, 

We need to discuss about the timeout feature more,
so I send patches only of the generic freeze feature.

I've addressed the comment from Shaggy,
combined patches that were divided into each filesystems into one patch 
because of the avoidance of a bisection.

Currently, ext3 in mainline Linux doesn't have the freeze feature which
suspends write requests.  So, we cannot take a backup which keeps
the filesystem's consistency with the storage device's features
(snapshot and replication) while it is mounted.
In many case, a commercial filesystem (e.g. VxFS) has
the freeze feature and it would be used to get the consistent backup.
If Linux's standard filesystem ext3 has the freeze feature, we can do it
without a commercial filesystem.

So I have implemented the ioctls of the freeze feature.
I think we can take the consistent backup with the following steps.
1. Freeze the filesystem with the freeze ioctl.
2. Separate the replication volume or create the snapshot
   with the storage device's feature.
3. Unfreeze the filesystem with the unfreeze ioctl.
4. Take the backup from the separated replication volume
   or the snapshot.

[PATCH 1/3] Add error handling of write_super_lockfs and unlockfs
  VFS:
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that they can return an error. 
  Rename write_super_lockfs and unlockfs of the super block operation
  freeze_fs and unfreeze_fs to avoid a confusion.

  ext3, ext4, xfs, gfs2, jfs:
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that write_super_lockfs returns an error if needed,
  and unlockfs always returns 0.

  reiserfs:
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that they always return 0 (success) to keep a current behavior.

[PATCH 2/3] Implement generic freeze feature
  The ioctls for the generic freeze feature are below.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, arg)
      fd: The file descriptor of the mountpoint
      FIFREEZE: request code for the freeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1

  o Unfreeze the filesystem
    int ioctl(int fd, int FITHAW, arg)
      fd: The file descriptor of the mountpoint
      FITHAW: request code for unfreeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1
      Error number: If the filesystem has already been unfrozen,
                    errno is set to EINVAL.

[PATCH 3/3] Remove XFS specific ioctl interfaces for freeze feature
  It removes XFS specific ioctl interfaces and request codes
  for freeze feature.
  This patch has been supplied by David Chinner.

Any comments are very welcome.

Cheers, Takashi
