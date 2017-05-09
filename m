From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/3] poll()able DM events
Date: Tue,  9 May 2017 12:10:25 -0700
Message-ID: <20170509191028.6898-1-agrover@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

Hi Mike,

We've been working off-list to develop a method of getting DM events
that is reliable, and also can monitor events from multiple DM devices
from a single thread.

In short, these enable an open file descriptor to /dev/mapper/control
to be polled. If the fd indicates POLLIN, some DM device has
experienced an event. Figuring out which is made easier by adding
event_nr in a backwards-compatible way to DM_LIST_DEVICES, so
userspace can compare against previously seen per-device
event_nrs. A new ioctl is also added, to rearm the fd so it may be
re-poll()ed. See individual patch commitlogs for more details.

Thanks to Mikulas for redeveloping earlier versions into this patchset,
as well as the other RH LVM devs who provided early internal feedback!

Regards -- Andy

Mikulas Patocka (3):
  dm: a basic support for using the select or poll function
  dm-ioctl: add a new DM_DEV_ARM_POLL ioctl
  dm-ioctl: report event number in DM_LIST_DEVICES

 drivers/md/dm-core.h          |   3 ++
 drivers/md/dm-ioctl.c         | 109 +++++++++++++++++++++++++++++++++---------
 drivers/md/dm.c               |   5 ++
 include/uapi/linux/dm-ioctl.h |   6 ++-
 4 files changed, 99 insertions(+), 24 deletions(-)

-- 
2.9.3
