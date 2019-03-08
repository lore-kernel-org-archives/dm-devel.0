From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 00/12] Misc Multipath patches
Date: Fri,  8 Mar 2019 17:11:53 -0600
Message-ID: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
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

Changes in v2:

0007:	simply fixes the issue with multipathd not resetting the wwid
	when get_uid() fails, and makes scsi_uid_fallback return the
	correct value, when it is still waiting for the retriggers
	to max out. The Changes that Martin suggested are dealt with
	in patch 0012

0010:	This patch adds some missing options to the multipath.conf(5)
	man page, including "user_friendly_names" like Martin metioned
	in his earlier review of patch 0001.

0011:	This patch adds a fallback method for nvme devices, to grab the
	wwid directly from sysfs.

0012:	I kept this patch seperate from 0007, because I'm not sure that
	it is the right thing to do. First, it's not very hard to have
	get_uid() fail. For a scsi device, all that needs to happen is
	for a change event to occur while the path is down and cannot be
	opened. scsi_id will fail, and ID_SERIAL will not be set. This
	seems far more likely than a device changing wwids because it
	switched LUNs.

	If we fail the device for getting a blank wwid, we then have to
	get the new wwid before we can decide what needs to be done to
	the path.  There are two options. One is to trigger more
	uevents, so that multipathd gets a uevent with the updated
	uid_attribute. This assumes that the original problem wasn't
	udev timing out because it was overloaded. If that was the
	problem, adding more uevents just makes things work. Even
	still, this means that once the new wwid is available, we have
	to run check_path, then wait for the uevent, and then run
	check_path again before we can restore the path. For these
	reasons, I didn't go down this route.

	The other way to get the new wwid is to run the fallback
	methods. This doesn't require multipathd to get a new uevent
	with the updated wwid, but it does do something that worries
	me.  When we run the fallback methods, we clear uid_attribute
	for the path. We do this because, presumably, we can't be
	certain that the fallback method and the uid_attribute method
	will return the same wwid. If this is really a possiblity
	then the fallback methods aren't any help at all. I don't
	know of any cases where this is true, which is why I'm
	submitting the patch. But I still not sure that its not
	better simply to assume that if get_uid() fails, that it
	did so for some mundane reason, and simply keep the old
	wwid.

Benjamin Marzinski (12):
  libmultipath: disable user_friendly_names for NetApp
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
  multipathd: change failed get_uid handling

 libmultipath/discovery.c   | 73 +++++++++++++++++++++++++-------------
 libmultipath/hwtable.c     |  1 +
 libmultipath/io_err_stat.c | 71 +++++++++++++++---------------------
 libmultipath/io_err_stat.h |  2 +-
 libmultipath/structs.h     |  6 ++++
 multipath/main.c           |  2 +-
 multipath/multipath.conf.5 |  8 +++++
 multipathd/cli_handlers.c  |  2 +-
 multipathd/main.c          | 50 ++++++++++++++++++--------
 multipathd/main.h          |  2 ++
 10 files changed, 133 insertions(+), 84 deletions(-)

-- 
2.17.2
