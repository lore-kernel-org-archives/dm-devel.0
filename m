From: Paul Wise <pabs3@bonedaddy.net>
Subject: [PATCH 0/3] dm raid/raid1: enable discard support when any devices support discard
Date: Sun, 19 Apr 2020 15:30:23 +0800
Message-ID: <20200419073026.197967-1-pabs3@bonedaddy.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Paul Wise <pabs3@bonedaddy.net>
List-Id: dm-devel.ids

This makes dm raid and dm raid1 (mirroring) consistent with md raid,
which supports discard when only some of the devices support discard.

Another patch will be needed to fix the queue discard limits sysfs files,
fixing `fstrim --fstab`, but these patches suffice to fix `fstrim /` and
I haven't finished figuring out how the queue discard limits are set yet.

Paul Wise (3):
  dm: add support for targets that allow discard when one device does
  dm raid: only check for RAID 4/5/6 once during discard support setup
  dm raid/raid1: enable discard support when any devices support discard

 drivers/md/dm-cache-target.c  |  2 +-
 drivers/md/dm-clone-target.c  |  2 +-
 drivers/md/dm-log-writes.c    |  2 +-
 drivers/md/dm-raid.c          | 21 ++++++++++-----------
 drivers/md/dm-raid1.c         |  1 +
 drivers/md/dm-table.c         | 32 +++++++++++++++++++++-----------
 drivers/md/dm-thin.c          |  8 ++++----
 drivers/md/dm-zoned-target.c  |  2 +-
 include/linux/device-mapper.h | 13 ++++++++-----
 include/uapi/linux/dm-ioctl.h |  4 ++--
 10 files changed, 50 insertions(+), 37 deletions(-)

-- 
2.26.1
