From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.39
Date: Thu, 24 Mar 2011 14:22:36 +0000
Message-ID: <20110324142235.GO27449@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josef Bacik <josef@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Babu Moger <babu.moger@lsi.com>, Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mustafa Mesanovic <mume@linux.vnet.ibm.com>, Milan Broz <mbroz@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes and enhancements for inclusion in
2.6.39.

Josef Bacik (1):
      dm: add flakey target

Mike Snitzer (2):
      dm mpath: fail message ioctl if specified path is not valid
      dm mpath: allow table load with no priority groups

Milan Broz (4):
      dm: fix opening log and cow devices for read only tables
      dm crypt: wipe keys string immediately after key is set
      dm ioctl: prepare for crypt key wiping
      dm ioctl: add flag to wipe buffers for secure data

Mustafa Mesanovic (1):
      dm stripe: implement merge method

 Documentation/device-mapper/dm-flakey.txt |   17 +++
 drivers/md/Kconfig                        |    6 +
 drivers/md/Makefile                       |    1 +
 drivers/md/dm-crypt.c                     |   19 ++-
 drivers/md/dm-flakey.c                    |  212 +++++++++++++++++++++++++++++
 drivers/md/dm-ioctl.c                     |   46 ++++--
 drivers/md/dm-log.c                       |    2 +-
 drivers/md/dm-mpath.c                     |   17 ++-
 drivers/md/dm-snap.c                      |    2 +-
 drivers/md/dm-stripe.c                    |   23 +++-
 include/linux/dm-ioctl.h                  |   12 ++-
 11 files changed, 326 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-flakey.txt
 create mode 100644 drivers/md/dm-flakey.c

Thanks,
Alasdair.
