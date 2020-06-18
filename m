From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/7] Fix muitpath/multipathd flush issue
Date: Wed, 17 Jun 2020 19:24:20 -0500
Message-ID: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If a multipath device is removed, and check_path() checks one of its
paths before multipathd processes either the uevent or the dm event from
removing it, multipathd will recreate the removed device. This happens
because check_path() will continute to check the removed device's former
paths until an event arrives removing the device.  A missing multpath
device will cause the update_multipath_strings() call to fail, setting
pp->dmstate to PSTATE_UNDEF.  If the path is up, this dmstate will cause
reinstate_path() to be called, which will also fail, because the
multipath device doesn't exist.  This will trigger a reload, restoring
the recently removed device.

This patchset handles this is two ways. The first two patches directly
fix these issues in check_path(), so that a missing multipath device
will no longer get recreated when checking one of its former paths. 

The other 5 patches add a "multipathd del maps" command, and make the
mutipath command delegate flush operations to multipathd so multipathd's
state remains in sync with the kernel's, while doing removes.

One source of complexity in these patches is that multipath suspends the
device with flushing before removing it, while multipathd doesn't.  It
does seem possible that the suspend could hang for a while, so I can
understand multipathd not using it.  However, that would take the
multipath device getting opened and IO being issued, between the time
when _dm_flush_map() verifies that the device isn't opened, and when it
suspends the device.  But more importantly, I don't understand how
suspending the device is useful.  If the device were to be opened
between when _dm_flush_map() checks the usage, and when it tries to
delete the device, device-mapper would simply fail the remove.  And if
the device isn't in use, there can't be any outstanding IO to flush.
When this code was added in commit 9a4ff93, there was no check if the
device was in use, and disabling queue_if_no_path could cause anything
that had the device open to error out and close it. But now that
multipath checks first if the device is open, I don't see the benefit to
doing this anymore. Removing it would allow multipathd and multipath to
use the same code to remove maps. Any thoughts?

Benjamin Marzinski (7):
  libmultipath: change do_get_info returns
  multipathd: fix check_path errors with removed map
  libmultipath: make dm_flush_maps only return 0 on success
  multipathd: add "del maps" multipathd command
  multipath: make flushing maps work like other commands
  multipath: delegate flushing maps to multipathd
  multipath: add option to skip multipathd delegation

 libmultipath/config.h     |  4 ++-
 libmultipath/configure.h  |  3 ---
 libmultipath/devmapper.c  | 41 ++++++++++++++++++-------------
 libmultipath/devmapper.h  |  3 ++-
 multipath/main.c          | 51 +++++++++++++++++++++++++++------------
 multipath/multipath.8     | 16 ++++++++----
 multipathd/cli.c          |  1 +
 multipathd/cli_handlers.c | 19 +++++++++++++++
 multipathd/cli_handlers.h |  1 +
 multipathd/main.c         | 39 ++++++++++++------------------
 multipathd/main.h         |  1 +
 11 files changed, 114 insertions(+), 65 deletions(-)

-- 
2.17.2
