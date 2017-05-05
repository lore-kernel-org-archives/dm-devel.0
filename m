From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/10] fixes for kpartx -d
Date: Sat,  6 May 2017 00:05:49 +0200
Message-ID: <20170505220559.7248-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Working on a bug report about kpartx not properly removing
partitions for loop devices, I realized a number of glitches
and improperly handled corner cases in the kpartx code for
deleting partitions. Some mappings are not deleted although
they should be, and others are deleted although that is clearly
wrong.

This patch series fixes the issues I found. The series starts
with a test program demonstrating the problems. The program
succeeds only after all patches of this series are applied.

Here is my summary of what I think how kpartx should behave:

  1) kpartx should delete all mappings it created beforehand.
  2) kpartx should handle partitions on dm devices and other devices
     (e.g. loop devices) equally well.
  3) kpartx should only delete "partitions", which are single-target
     linear mappings into a block device. Other maps should not be touched.
  4) kpartx should only delete mappings it created itself beforehand.
     In particular, it shouldn't delete LVM LVs, even if they are fully
     contained in the block device at hand and thus look like partitions
     in the first place. (For historical compatibility reasons, allow
     such mappings to be deleted with the -f/--force flag).
  5) DM map names may be changed, thus kpartx shouldn't rely on them to
     check whether a mapping is a partition of a particular device. It is
     legal for a partition of /dev/loop0 to be named "loop0".

One patch has an obvious libdevmapper equivalent and is therefore
included although this series is otherwise focused only on kpartx.

Feedback is welcome.

Martin Wilck (10):
  kpartx: test-kpartx: new unit test program
  kpartx: avoid ioctl error for loop devices
  kpartx: remove is_loop_device
  kpartx: dm_remove_partmaps: support non-dm devices
  kpartx: dm_devn: return error for non-existent device
  kpartx: don't treat multi-linear mappings as partitions
  libmultipath: don't treat multi-linear mappings as partitions
  kpartx: use partition UUID for non-DM devices
  kpartx: use absolute path for regular files
  kpartx: find_loop_by_file: use sysfs

 kpartx/devmapper.c       |  39 +++++---
 kpartx/devmapper.h       |   2 +-
 kpartx/kpartx.c          |  42 +++++++-
 kpartx/lopart.c          |  73 ++++++--------
 kpartx/lopart.h          |   1 -
 kpartx/test-kpartx       | 253 +++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/devmapper.c |  15 +--
 7 files changed, 356 insertions(+), 69 deletions(-)
 create mode 100755 kpartx/test-kpartx

-- 
2.12.2
