From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/7] Fix muitpath/multipathd flush issue
Date: Thu, 25 Jun 2020 15:42:14 -0500
Message-ID: <1593117741-28750-1-git-send-email-bmarzins@redhat.com>
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

Changes from v1:
0001:	This is completely different. I've change how patch 0002 detects
	when a multipath device has disappeared. Instead of do_get_info,
	I need more return values on dm_get_map/status, and the
	update_multipath_* functions. I have used symbolic return
	values, which was the objection to the previous patch. I tried
	to picked generic enough names that they could be used for other
	devmapper.c functions as well.

0002:	At Martin's suggestion, multipath now differentiates between dm
	failures and a missing multipath device in
	update_multipath_strings(). So there is no need to recheck if
	the device is missing.

0006:	Added some man page info that was previously in patch 0007

0007:	Removed mentions of the -D option in the man page and usage
	output.

I did not change anything about suspending the device on remove.  It was
not obvious how to break that up between multipath and multipathd, and
there are likely still some conversations to be had about what we need
to do to remove a device in multipath, and in what order.  So, for now,
I just kept all those functions the same, and just added the code
necessary to make multpathd work with them correctly, as is.

Benjamin Marzinski (7):
  libmultipath: make dm_get_map/status return codes symbolic
  multipathd: fix check_path errors with removed map
  libmultipath: make dm_flush_maps only return 0 on success
  multipathd: add "del maps" multipathd command
  multipath: make flushing maps work like other commands
  multipath: delegate flushing maps to multipathd
  multipath: add option to skip multipathd delegation

 libmultipath/config.h      |  4 ++-
 libmultipath/configure.h   |  3 --
 libmultipath/devmapper.c   | 63 +++++++++++++++++++++++++-------------
 libmultipath/devmapper.h   |  8 ++++-
 libmultipath/structs_vec.c | 45 +++++++++++++++------------
 multipath/main.c           | 44 ++++++++++++++++++--------
 multipath/multipath.8      |  4 +--
 multipathd/cli.c           |  1 +
 multipathd/cli_handlers.c  | 19 ++++++++++++
 multipathd/cli_handlers.h  |  1 +
 multipathd/main.c          | 50 +++++++++++++-----------------
 multipathd/main.h          |  1 +
 12 files changed, 155 insertions(+), 88 deletions(-)

-- 
2.17.2
