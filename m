From: mwilck@suse.com
Subject: [PATCH v3 00/80] multipath-tools series part VI:
	incomplete udev initialization
Date: Wed, 19 Aug 2020 15:17:45 +0200
Message-ID: <20200819131747.13400-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

This is v3 of part VI of a larger patch series for multipath-tools I've been
preparing. It's based on the previously submitted part V.

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-200819
This part is tagged "submit-200819-6".

The series handles an issue observed in certain partner installations, where
DM devices were incompletely initialized by udev - during initrd procesing,
the "add" event had been processed, but the subsequent "change" event had not,
because udevd had been killed before getting around to handle them.

My first attempt to fix this was based on udev rules ("11-dm-mpath.rules: Fix
udev rule processing during coldplug"), but this patch was wrong. We have to
add logic in multipathd itself. The most important patch in the series that
fixed the actual customer problem is patch 76. Patch 75 was supposed to handle
a slightly different incarnation of the same problem, which so far hasn't been
actually observed. But I think having this patch "just in case" doesn't hurt,
either.

Patch 78 and 79 rename "update_path_groups()", which over time has grown
to be the main entry point for reloading maps.

Patch 80 fixes an issue which I observed while testing the first 3 patches.
Logically, it rather belongs to part III.

Changes v2 -> v3, as suggested by Ben Marzinski:

 * 76/80 "libmultipath: select_action(): force udev reload for uninitialized
   maps"
   - moved configure.c changes from 77/80 to this patch, where it belongs
 * 77/80 "libmultipath: log dm_task_run() errors"
   - moved some hunks to 76/80, see above

Changes v1 -> v2, as suggested by Ben Marzinski:

 * 76/80 "libmultipath: select_action(): force udev reload for uninitialized
   maps"
    - fetch udevice from cmpp, not mpp (was fixed in "libmultipath: log
      dm_task_run() errors" in v1)
    - force reload only if active paths are available
 * 77/80 "libmultipath: log dm_task_run() errors"
    - moved cmpp fix to previous patch, where it belongs
    - remove pointless debug msg
 * 79/80 "multipathd: rename update_path_groups() -> reload_and_sync_map()"
    - context changes
 * 80/80 "libmultipath: select_action(): don't drop map if alias clashes"
    - fixed wrong strlcpy() (mpp->alias is a pointer)

Regards,
Martin

Martin Wilck (6):
  multipathd: uev_trigger(): handle incomplete ADD events
  libmultipath: select_action(): force udev reload for uninitialized
    maps
  libmultipath: log dm_task_run() errors
  libmultipath: move reload_map() to multipathd
  multipathd: rename update_path_groups() -> reload_and_sync_map()
  libmultipath: select_action(): don't drop map if alias clashes

 libmultipath/configure.c  | 112 +++++++++++++++-----------------------
 libmultipath/configure.h  |   3 +-
 libmultipath/devmapper.c  |  61 +++++++++++++++++----
 libmultipath/devmapper.h  |   4 ++
 multipathd/cli_handlers.c |   8 +--
 multipathd/dmevents.c     |   4 +-
 multipathd/main.c         |  71 ++++++++++++++++++++++--
 multipathd/main.h         |   4 +-
 multipathd/waiter.c       |   2 +
 9 files changed, 178 insertions(+), 91 deletions(-)

-- 
2.28.0
