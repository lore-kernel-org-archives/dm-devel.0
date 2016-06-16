From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/39] multipath: coverity fixes
Date: Thu, 16 Jun 2016 11:47:06 +0200
Message-ID: <1466070465-1021-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

here's a bunch of fixes from a recent coverity run.
Nothing critical, mostly memory leaks and possible
buffer overflows. And the usual missing return value
check.

As usual, comments and reviews are welcome.

The whole patchset can be found at
github.com:/hreinecke/multipath-tools.git
branch coverity

Hannes Reinecke (39):
  multipathd: correctly free refwwid in cli_add_map()
  libmultipath: fixup string copy and comparison
  libmultipath: fixup uninitialized return value in dm_reassign_table()
  libmultipath: free pathgroup in group_by_prio()
  libmultipath: memory leak in remove_feature()
  libmultipath: memory leak in add_map_without_path()
  libmultipath: missing NULL check in set_pgfailback()
  libmultipath: remove stale references to fd_ep in uevent_listen()
  libmultipath/devmapper.c: Remove unused 'next' argument
  libmultipath/alias.c: check return value from strchr()
  libmultipath/devmapper.c: check for errors from sscanf()
  libmultipath/uevent.c: handle errors from setsockopt()
  libmultipath/discovery.c: handle errors from sscanf()
  libmultipath: drop unused variable 'diop' in libsg.c
  libmultipath: use fstat() when reading sysfs attributes
  libmultipath: fixup possible buffer overflow in alua_rtpg.c
  libmultipath: memory leak in iet.c
  libmpathcmd: limit size of the CLI buffer
  libmpathpersist: Fix possible overrun in devt2devname()
  libmpathpersist: memory leak in mpath_persistent_reserve_(in,out)()
  libmpathpersist: Pass sensebuffer as pointer
  libmpathpersist: Handle send error
  libmultipath: missing break in hds prioritizer
  kpartx: fixup fd leakage in lopart.c
  kpartx: Memory leak in get_hotplug_device()
  kpartx: fixup filedescriptor leak in set_loop()
  kpartx: do not use 'const' for mapname in get_hotplug_device()
  kpartx: Handle errors from lseek()
  kpartx/devmapper.c: Remove unused 'next' argument
  kpartx: use fstat() when reading sysfs attributes
  kpartx/lopart.c: use fstat() when reading device nodes
  libmultipath/sysfs.c: always terminate value from
    sysfs_attr_get_value()
  multipathd: missing mpath_disconnect() in uxclnt()
  multipathd: pid fd resource leak
  libmultipath: mark return value from dup() as unused
  libmultipath: Ignore errors from fcntl() in directio.c
  libmultipath: add spin_lock in tur.c
  libmultipath/devmapper.c: fixup possible buffer overflow
  libmultipath/discovery.c: Fixup possible range overflow

 kpartx/devmapper.c                    |  5 ++-
 kpartx/gpt.c                          |  5 +--
 kpartx/kpartx.c                       | 13 ++++---
 kpartx/lopart.c                       | 39 ++++++++++-----------
 libmpathcmd/mpath_cmd.c               |  2 ++
 libmpathcmd/mpath_cmd.h               |  1 +
 libmpathpersist/mpath_persist.c       | 21 +++++++++---
 libmpathpersist/mpath_pr_ioctl.c      | 35 ++++++++++---------
 libmpathpersist/mpath_updatepr.c      |  8 +++--
 libmultipath/alias.c                  |  3 +-
 libmultipath/callout.c                |  4 ++-
 libmultipath/checkers/directio.c      |  4 ++-
 libmultipath/checkers/libsg.c         |  3 --
 libmultipath/checkers/tur.c           |  4 ++-
 libmultipath/configure.c              | 10 +++---
 libmultipath/devmapper.c              | 40 +++++++++++++---------
 libmultipath/dict.c                   |  2 ++
 libmultipath/discovery.c              | 13 +++----
 libmultipath/dmparser.c               | 16 +++++----
 libmultipath/pgpolicies.c             | 14 +++++---
 libmultipath/prio.c                   |  2 +-
 libmultipath/prioritizers/alua_rtpg.c |  8 ++++-
 libmultipath/prioritizers/hds.c       |  2 ++
 libmultipath/prioritizers/iet.c       |  3 +-
 libmultipath/structs.c                |  4 ++-
 libmultipath/structs_vec.c            | 10 ++++--
 libmultipath/sysfs.c                  | 64 ++++++++++++++++++++---------------
 libmultipath/uevent.c                 | 19 +++++++----
 libmultipath/waiter.c                 |  2 +-
 multipathd/cli_handlers.c             |  2 +-
 multipathd/main.c                     |  6 +++-
 multipathd/pidfile.c                  |  6 ++--
 multipathd/uxclnt.c                   |  2 +-
 33 files changed, 226 insertions(+), 146 deletions(-)

-- 
2.6.6
