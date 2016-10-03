From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/9] Generate uevents for all DM events
Date: Mon,  3 Oct 2016 12:22:51 -0700
Message-ID: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Mike and GregKH,

I want a way to get devicemapper events without using the DM ioctl,
because that requires creating a thread to sleep in the ioctl for each
dm device I want events from.

It would seem like using uevents and KOBJ_CHANGE would be a good way
to do this, but Mike said that the uevent maintainers (Greg that's
you?) did not think this was a good idea?

If so, I was hoping you could talk a little more about why -- grep
shows KOBJ_CHANGE used all over, but its usage is not documented in
kobject.txt. In any case I can update kobject.txt with some more
guidelines.

The following patchset may be appliable if you're actually ok with
using KOBJ_CHANGE for dm events, or if not, then I'll look to rework
it to use a dm-specific genetlink approach.

Thanks -- Regards -- Andy

Andy Grover (9):
  dm: Do not export dm_send_uevents
  dm: Move multipath-specific stuff out of dm-uevent.c
  dm: Inline dm_build_path_uevent into dm_path_uevent
  dm: Update dm-uevent.txt
  dm: Rename dm_build_uevent to dm_uevent_build
  dm: Rename dm_event_add to dm_event_queue
  dm: Implement dm_uevent_add()
  dm: Generate uevents for thin targets
  dm: Generate uevents for other targets

 Documentation/device-mapper/dm-uevent.txt |  54 ++++++++++++++--
 drivers/md/dm-cache-target.c              |   5 +-
 drivers/md/dm-log-userspace-base.c        |   8 ++-
 drivers/md/dm-log.c                       |   1 +
 drivers/md/dm-mpath.c                     |  56 ++++++++++++++++
 drivers/md/dm-raid1.c                     |   1 +
 drivers/md/dm-snap.c                      |   1 +
 drivers/md/dm-thin.c                      |   3 +
 drivers/md/dm-uevent.c                    | 102 ++++++++++--------------------
 drivers/md/dm-uevent.h                    |  30 +++++++--
 drivers/md/dm.c                           |   3 +-
 include/linux/device-mapper.h             |   3 +-
 12 files changed, 180 insertions(+), 87 deletions(-)

-- 
2.7.4
