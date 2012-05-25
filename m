From: Ondrej Kozina <okozina@redhat.com>
Subject: [RFC PATCH v2 0/3] Allow user w/o CAP_SYS_ADMIN to
	submit ioctl commands into DM
Date: Fri, 25 May 2012 15:22:25 +0200
Message-ID: <1337952148-20888-1-git-send-email-okozina@redhat.com>
References: <1335986033-15236-1-git-send-email-okozina@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335986033-15236-1-git-send-email-okozina@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, mgrac@redhat.com, kas@fi.muni.cz, mbroz@redhat.com
List-Id: dm-devel.ids

Hi,

I would like to post new version of my previous RFC with a set of changes for
device-mapper that would enable user w/o CAP_SYS_ADMIN capability to create 
and manage his own devices.

Changes in version No. 2:
^^^^^^^^^^^^^^^^^^^^^^^^

(*) No major:minor translation to dentry (inode) in kernel space. Supposing
    userspace should resolve that.

(*) Load time parameter to enable security enhancements

(*) Supposing security is enabled, userspace should handle open file descriptors
    and kernel checks whether the user is authorised to access the device
    linked to the device node.

The rest of message is the same as in original RFC

Simple use cases:
^^^^^^^^^^^^^^^^
(1) Non-root user would be able to create dm-crypt device from USB stick
    (assuming the user has permission to access backing device)
(2) You can create pool of storage space for virtual machines. VM managers
    would be able to administrate the pool w/o root permissions:

    .--------------. .----------------.
    |_owner: VM 01_| |__owner: VM 02__|
           |                |
           |                |
    .---------------------------------.
    |____owner: VM manager____________|

Short Overview:
^^^^^^^^^^^^^^
(1) The first checkpoint that decides whether the user has an access right to
    submit ioctl cmds into DM driver are actually the attributes on dentry of
    /dev/mapper/control (through general perm., ACL, LSM checks).

(2) After the DM_DEV_CREATE ioctl, new block device will receive FSUID and
    from the context on behalf of which we entered into kernel

(3) Whenever user asks to manipulate DM device he must pass the test whether
    he's the owner of DM device or he has CAP_FOWNER capability.

(4) During the table creation process we check whether the user has right to
    READ/WRITE the backing device, according to table mode. For that purpose
    I added a new function into target_type interface - dm_security_fn.

With regards
O.

Ondrej Kozina (3):
  Adds support for user-submitted ioctl commands
  Adds support for security checks in the linear target
  Adds support for security checks in the crypt target

 drivers/md/Makefile           |    2 +-
 drivers/md/dm-crypt.c         |   18 +++++-
 drivers/md/dm-ioctl.c         |  141 +++++++++++++++++++++++++++++++++++------
 drivers/md/dm-linear.c        |   19 +++++-
 drivers/md/dm-security.c      |   95 +++++++++++++++++++++++++++
 drivers/md/dm-sysfs.c         |   15 +++++
 drivers/md/dm-table.c         |   23 +++++++-
 drivers/md/dm.c               |   87 +++++++++++++++++++++++++
 drivers/md/dm.h               |   12 ++++
 include/linux/device-mapper.h |    5 ++
 10 files changed, 393 insertions(+), 24 deletions(-)
 create mode 100644 drivers/md/dm-security.c

-- 
1.7.8.6
