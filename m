From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: [PATCH 0/2] Introduce new raid0 state 'broken'
Date: Mon, 29 Jul 2019 17:31:33 -0300
Message-ID: <20190729203135.12934-1-gpiccoli@canonical.com>
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
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, gpiccoli@canonical.com, neilb@suse.com, linux-block@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

Currently the md/raid0 device behaves quite differently of other block
devices when it comes to failure. While other md levels contain vast
logic to deal with failures, and other non-md devices like scsi disks
or nvme rely on a dying queue when they fail, md/raid0 for instance
does not signal failures if an array member is removed while the array
is mounted; in that case, udev signals the device removal but mdadm
cannot succeed in the STOP_ARRAY ioctl, since it's mounted.

This behavior was tentatively changed in the past to match the scsi/nvme
devices (see [0]), but this attempt was quite complex, it had some corner
cases and (the few) community reviews weren't generally positive.
So, we are trying again with a simpler approach this time.

This series introduces a new array state 'broken' (for raid0 only), which
mimics the state 'clean'. The main goal for this new state is a way to
signal the user that something is wrong with the array. We also included a
warn_once-style message in kernel log to alert the user when the array has
one failed member.

The series encompass changes in the kernel and in mdadm tool. To get the
'broken' state completely functional one requires both changes, but mdadm
and kernel can live without their counterpart changes (in case some users
gets an updated mdadm for example, but keeps using an old kernel).

This series does not affect at all the way md/raid0 will react to I/O
failures. It was discussed in [0] that it should be better if raid0 could
fail faster in case it gets a member removed; we just proposed a change in
that realm too (see [1]), but it seems better to have them reviewed/treated
separately.

This series was tested with raid0 arrays holding both an ext4 and xfs
filesystems. Thanks in advance for the reviews/feedbacks.
Cheers,


Guilherme


[0] lore.kernel.org/linux-block/20190418220448.7219-1-gpiccoli@canonical.com
[1] lore.kernel.org/linux-block/20190729193359.11040-1-gpiccoli@canonical.com


Guilherme G. Piccoli (1):
  md/raid0: Introduce new array state 'broken' for raid0

[kernel part]
 drivers/md/md.c    | 23 +++++++++++++++++++----
 drivers/md/md.h    |  2 ++
 drivers/md/raid0.c | 26 ++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 4 deletions(-)

[mdadm]
 Detail.c  | 16 ++++++++++++++--
 Monitor.c |  9 +++++++--
 maps.c    |  1 +
 mdadm.h   |  1 +
 mdmon.h   |  2 +-
 monitor.c |  4 ++--
 6 files changed, 26 insertions(+), 7 deletions(-)

-- 
2.22.0
