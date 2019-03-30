From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 00/17] Misc Multipath patches
Date: Sat, 30 Mar 2019 01:05:49 -0500
Message-ID: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The series is a mix of resends an new patches.

Patches 0001-0005 are simply resends of patches I've submitted earlier,
with no changes other that adding Reviewed-by's where appropriate.

Patches 0006-0009 are the result of running into some bugs during
firmare updates on an array.

Changes in v3:
0007:	This is actually the same as the v2 version.  Martin's issues
	for this and 0011 are addressed in the new 0012 patch.
	However, since I don't think that failing paths on NULL wwids
	is a good policy for reasons I outlined in
	https://www.redhat.com/archives/dm-devel/2019-March/msg00207.html
	and I scrapped the v2 0012 patch, I'm leaving off Martin's
	ACK from this one.

0010:	Hopefully I've got all the missing man page options now.

0012:	Cleanup to deal with Martin's objection to uid_fallback()
	deciding on whether to actually run the fallback code. This
	also removes the need for the poorly named old_len variable.

0013:	This is heavily based on Martin's
	"multipathd: handle changed wwids by removal and addition"
	The changes stem from not removing paths with NULL wwids.
	Martin, if you want to be creditted as the Author, that's
	fine.

0014 &	The later two patches in Martin's "New approach at handling
0015:	changed WWIDs" patchset

0016:	The more I think about it, the less I like the fallback code
	as well. However, it has helped get multipath devices up in
	situations where udev is having issues, so I don't want
	to scrap it.  But I do think that once the device is up, we
	should only use the configured method of getting the uuid.

0017:	A completely unrelated patch to stop multipath error messages
	when removing a device with kpartx paritions.

Changes in v2:

0007:   simply fixes the issue with multipathd not resetting the wwid
        when get_uid() fails, and makes scsi_uid_fallback return the
        correct value, when it is still waiting for the retriggers
        to max out. The Changes that Martin suggested are dealt with
        in patch 0012

0010:   This patch adds some missing options to the multipath.conf(5)
        man page, including "user_friendly_names" like Martin metioned
        in his earlier review of patch 0001.

0011:   This patch adds a fallback method for nvme devices, to grab the
        wwid directly from sysfs.


Benjamin Marzinski (15):
  libmulitpath: disable user_friendly_names for NetApp
  libmultipath: handle existing paths in marginal_path enqueue
  multipathd: cleanup marginal paths checking timers
  libmultipath: fix marginal paths queueing errors
  libmultipath: fix marginal_paths nr_active check
  multipathd: Fix miscounting active paths
  multipathd: ignore failed wwid recheck
  libmutipath: continue to use old state on PATH_PENDING
  multipathd: use update_path_groups instead of reload_map
  multipath.conf: add missing options to man page
  libmultipath: add get_uid fallback code for NVMe devices
  libmulitpath: cleanup uid_fallback code
  multipathd: handle changed wwids by removal and addition
  multipathd: Don't use fallback code after getting wwid
  libmultipath: silence dm_is_mpath error messages

Martin Wilck (2):
  multipathd: remove "wwid_changed" path attribute
  multipathd: ignore "disable_changed_wwids"

 libmultipath/config.c      |  1 -
 libmultipath/config.h      |  1 -
 libmultipath/devmapper.c   |  2 +-
 libmultipath/dict.c        | 18 ++++++++--
 libmultipath/discovery.c   | 70 +++++++++++++++++++++++++------------
 libmultipath/discovery.h   |  3 +-
 libmultipath/hwtable.c     |  1 +
 libmultipath/io_err_stat.c | 71 +++++++++++++++-----------------------
 libmultipath/io_err_stat.h |  2 +-
 libmultipath/structs.h     |  1 -
 multipath/main.c           |  2 +-
 multipath/multipath.conf.5 | 18 ++++++----
 multipathd/cli_handlers.c  |  2 +-
 multipathd/main.c          | 58 ++++++++++++-------------------
 multipathd/main.h          |  2 ++
 15 files changed, 134 insertions(+), 118 deletions(-)

-- 
2.17.2
