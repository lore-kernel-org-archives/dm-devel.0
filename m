From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.13
Date: Thu, 6 Jul 2017 11:42:56 -0400
Message-ID: <20170706154255.GA675@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Geliang Tang <geliangtang@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Perches <joe@perches.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

These DM changes were layered ontop of linux-block.git to avoid
conflicts associated with all the 4.13 block changes.

The following changes since commit 443bd90f2cca9dec3db9ef9460a9c2a6f095f789:

  nvme: host: unquiesce queue in nvme_kill_queues() (2017-06-18 20:52:58 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.13/dm-changes

for you to fetch changes up to 3908c9839b1077e677ef9e92d2bce7f224519c59:

  dm zoned: fix overflow when converting zone ID to sectors (2017-07-05 16:08:47 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Add the ability to select or poll /dev/mapper/control to wait for
  events from multiple DM devices.

- Convert DM's printk macros over to using pr_<level> macros.

- Add a big-endian variant of plain64 IV to dm-crypt.

- Add support for zoned (aka SMR) devices to DM core.  DM kcopyd was
  also improved to provide a sequential write feature needed by zoned
  devices.

- Introduce DM zoned target that provides support for host-managed zoned
  devices, the result dm-zoned device acts as a drive-managed interface
  to the underlying host-managed device.

- A DM raid fix to avoid using BUG() for error handling.

----------------------------------------------------------------
Damien Le Moal (9):
      dm table: add zoned block devices validation
      dm: fix REQ_OP_ZONE_RESET bio handling
      dm: fix REQ_OP_ZONE_REPORT bio handling
      dm: introduce dm_remap_zone_report()
      dm flakey: add support for zoned block devices
      dm linear: add support for zoned block devices
      dm kcopyd: add sequential write feature
      dm zoned: drive-managed zoned block device target
      dm zoned: fix overflow when converting zone ID to sectors

Geliang Tang (1):
      dm bio prison: use rb_entry() rather than container_of()

Heinz Mauelshagen (1):
      dm raid: stop using BUG() in __rdev_sectors()

Joe Perches (1):
      dm: convert DM printk macros to pr_<level> macros

Mikulas Patocka (3):
      dm: add basic support for using the select or poll function
      dm ioctl: add a new DM_DEV_ARM_POLL ioctl
      dm ioctl: report event number in DM_LIST_DEVICES

Milan Broz (1):
      dm crypt: add big-endian variant of plain64 IV

 Documentation/device-mapper/dm-zoned.txt |  144 ++
 drivers/md/Kconfig                       |   17 +
 drivers/md/Makefile                      |    2 +
 drivers/md/dm-bio-prison-v1.c            |    2 +-
 drivers/md/dm-bio-prison-v2.c            |    2 +-
 drivers/md/dm-core.h                     |    3 +
 drivers/md/dm-crypt.c                    |   21 +-
 drivers/md/dm-flakey.c                   |   23 +-
 drivers/md/dm-ioctl.c                    |  109 +-
 drivers/md/dm-kcopyd.c                   |   65 +-
 drivers/md/dm-linear.c                   |   18 +-
 drivers/md/dm-raid.c                     |   13 +-
 drivers/md/dm-table.c                    |  162 ++
 drivers/md/dm-zoned-metadata.c           | 2509 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c            |  570 +++++++
 drivers/md/dm-zoned-target.c             |  967 ++++++++++++
 drivers/md/dm-zoned.h                    |  228 +++
 drivers/md/dm.c                          |   97 +-
 include/linux/device-mapper.h            |   79 +-
 include/linux/dm-kcopyd.h                |    1 +
 include/uapi/linux/dm-ioctl.h            |    4 +-
 21 files changed, 4958 insertions(+), 78 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-zoned.txt
 create mode 100644 drivers/md/dm-zoned-metadata.c
 create mode 100644 drivers/md/dm-zoned-reclaim.c
 create mode 100644 drivers/md/dm-zoned-target.c
 create mode 100644 drivers/md/dm-zoned.h
