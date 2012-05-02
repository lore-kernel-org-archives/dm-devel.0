From: okozina@redhat.com
Subject: [RFC PATCH 0/4] Allow user w/o CAP_SYS_ADMIN to submit
	ioctl commands into DM
Date: Wed,  2 May 2012 21:13:49 +0200
Message-ID: <1335986033-15236-1-git-send-email-okozina@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mgrac@redhat.com, kas@fi.muni.cz
List-Id: dm-devel.ids

From: Ondrej Kozina <okozina@redhat.com>

Hi,

I would like to post RFC with a set of changes for device-mapper that would
enable user w/o CAP_SYS_ADMIN capability to create and manage his own devices
in more or less distant future. I`ll try to be as brief as possible, so:

Simple use cases:
^^^^^^^^^^^^^^^^
(1) Non-root user would be able to create dm-crypt device from USB stick
    (assuming the user has permission to access backing device)
(2) You can create pool of storage space for virtual machines. VM managers
    would be able to administrate the pool w/o root permissions. Each VM would
    be able to create it's own device (same premise as before)

Short Overview:
^^^^^^^^^^^^^^
(1) The first checkpoint that decides whether the user has an access right to
    submit ioctl cmds into DM driver are actually the attributes on dentry of
    /dev/mapper/control (through general perm., ACL, LSM checks).

(2) After the DM_DEV_CREATE ioctl, new block device will receive FSUID and
    FSGID from the context on behalf of which we entered into kernel

(3) Whenever user asks to manipulate DM device he must pass the test whether
    he's the owner of DM device or not

(4) During the table creation process we check whether the user has right to
    READ/WRITE the backing device, according to table mode (there's possibly
    major drawback when user submits target device as major:minor couple, more
    on that later). For that purpose I added a new function into target_type
    interface - dm_security_fn.

Note: It's still work in progress. I would jusk like to ask you humbly for any
comments, if you may miss a few minutes.

Another note: I'm prety sure that there are many bugs and many mistakes in my
concept (locking, maybe even reference leaks,...) but what I'm looking for
right now, is rather a proof of concept than patchset ready for upstream.

With regards
O.

Ondrej Kozina (4):
  Adds support for user-submitted ioctl commands
  Adds support for the dentry lookup from path or major:minor couple
    during target security check
  Adds support for security checks in the linear target
  Adds support for security checks in the crypt target

 drivers/md/dm-crypt.c         |   37 +++++++++++-
 drivers/md/dm-ioctl.c         |  138 +++++++++++++++++++++++++++++++++++------
 drivers/md/dm-linear.c        |   49 ++++++++++++++-
 drivers/md/dm-sysfs.c         |   30 +++++++++
 drivers/md/dm-table.c         |   16 +++++
 drivers/md/dm-target.c        |  126 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |   86 +++++++++++++++++++++++++
 drivers/md/dm.h               |   14 ++++
 include/linux/device-mapper.h |    3 +
 9 files changed, 477 insertions(+), 22 deletions(-)

-- 
1.7.8.5
