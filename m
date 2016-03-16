From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/5] Use uevent for thin pool events
Date: Wed, 16 Mar 2016 16:27:42 -0700
Message-ID: <1458170867-429-1-git-send-email-agrover@redhat.com>
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

uevents both let us attach additional info to the event, and also
allow interested user processes to receive them without having to
create and manage threads to sit in DEV_WAIT ioctls for each target
we're interested in.

dm-mpath already supports generating uevents. This patchset
generalizes this code a little to allow another target to also
generate uevents, dm-thin, as a first step for what we might like to
do for all targets' events. DEV_WAIT ioctl support is unchanged.

Andy Grover (5):
  dm: Do not export dm_send_uevents
  dm: Move multipath-specific stuff out of dm-uevent.c
  dm: Inline dm_build_path_uevent into dm_path_uevent
  dm: Add uevent support for dm-thin
  dm: Update dm-uevent.txt

 Documentation/device-mapper/dm-uevent.txt | 48 ++++++++++++++++---
 drivers/md/dm-mpath.c                     | 56 +++++++++++++++++++++++
 drivers/md/dm-thin.c                      | 18 ++++++++
 drivers/md/dm-uevent.c                    | 76 +++----------------------------
 drivers/md/dm-uevent.h                    | 30 +++++++++---
 drivers/md/dm.c                           |  1 +
 6 files changed, 147 insertions(+), 82 deletions(-)

-- 
2.5.0
