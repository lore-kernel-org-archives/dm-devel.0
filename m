From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/3] poll() for DM events
Date: Mon,  9 Jan 2017 10:20:37 -0800
Message-ID: <20170109182040.31337-1-agrover@redhat.com>
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
List-Id: dm-devel.ids

Hi all,

This patchset allows events for multiple DM devices to be monitored by
a single thread, instead of requiring one thread per device. This is
made possible by a new ioctl to create an association between an open
file descriptor to /dev/mapper/control and a DM device. A program can
open and associate multiple times, and then poll() all the fds.

Since we now track something per-fd - the association - our new ioctl
handler needs the struct file*. lookup_ioctl() requires all ioctl
handlers have the same arguments, so patch 1 changes all ioctl_fns to
add this.

Patch 2 implements support, but limits associated fds to just being
used with poll(), and the VERSION ioctl.

Patch 3 (optional) shows how we could use the associated device to do
additional ioctls without needing to specify the device in the
ioctl().

There's also a simple test program at:

https://github.com/agrover/dm-poll-test

Thanks -- Andy

Andy Grover (3):
  dm: Change ioctl handlers to take struct file*
  dm: Add support to poll for dm events
  dm: Allow associated fd to be used for TABLE_STATUS

 drivers/md/dm-core.h          |  10 +++
 drivers/md/dm-ioctl.c         | 149 +++++++++++++++++++++++++++++++++++-------
 drivers/md/dm.c               |  12 ++++
 include/uapi/linux/dm-ioctl.h |   6 +-
 4 files changed, 151 insertions(+), 26 deletions(-)

-- 
2.9.3
