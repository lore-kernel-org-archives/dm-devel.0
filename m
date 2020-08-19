From: mwilck@suse.com
Subject: [PATCH v3 00/35] multipath-tools series part I: minor
	changes
Date: Wed, 19 Aug 2020 15:17:19 +0200
Message-ID: <20200819131720.13290-1-mwilck@suse.com>
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

This is part I of a larger patch series for multpath-tools I've been preparing.
It contains self-contained fixes and cleanups, and unit test additions.

This is v3 of the series I posted on 2020-07-09 and 2020-08-12.
To avoid spamming, I will resend only the patches that have changed wrt v2
(including context changes). There are changes only in part 1, 6, and 7.
I took care to make sure the numbering is preserved. 

The full series will be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-200819
There are tags in that repo for each part of the series.
This part is tagged "submit-200819-1".

The series is based on 0.8.4, plus the following set of previously
submitted and reviewed patches (latest first):

 - [PATCH 4/5] multipathd: disable queueing for recreated map in uev_remove_map
   (lixiaokeng)
 - [PATCH 4/6] libmultipath: check blist before calling MALLOC in alloc_ble_device func
   (Zihiqiang)
 - [PATCH 1/5 v4] libmultipath fix a memory leak in set_ble_device (From:
   (lixiaokeng)
 - [PATCH v2 0/8] multipath cleanups (v2 8-part series from Ben,
       without 7/8 "multipathd: unset mpp->hwe when removing map")
 - [PATCH v3] vector: return false if realloc fails in vector_alloc_slot func (Zhiqiang Liu)
 - libmultipath: free pgp if add_pathgroup fails in disassemble_map func (Zhiqiang Liu)
 - checker: add input check of state in checker_state_name func (Zhiqiang Liu)
 - libmultipath: fix null dereference in add (lixiaokeng)
 - tests/hwtable: fix a memory free in replicate_config (Zhiqiang Liu)
 - vector: fix upper boundary check of vector size in vector_del_slot (Zhiqiang Liu)
 - vector: add lower bound check of E in VECTOR_SLOT (Zhiqiang Liu)
 - devmapper: remove useless using of memset in dm_get_info func (Zhiqiang Liu)
 - libmultipath: fix a memory leak in dm_get_maps (lixiaokeng)
 - libmultipath: fix a memory leak in disassemble_status func (Zhiqiang Liu)
 - [PATCH 0/4] Fix segfault on access to mpp->hwe (4-part series, me)

(below is where the v1 series was based on)

 - libmultipath: add device to hwtable.c (Steve Schremmer)
 - [PATCH v3 0/7] Fix muitpath/multipathd flush issue (v3 7-part series, Ben)
 - [PATCH v2 0/4] misc patches (v2 4-part series, Ben)
 - multipath: Fix compiler warnings when built without systemd. (Marius Bakke)
 - [PATCH v2 0/3] multipath: change default devnode blacklist
   (v2 3-part series, Ben)
 - multipath: add "-e" option to enable foreign libraries (me)
 - libmultipath: set "enable_foreign" to NONE by default (me)
 - libmultipath: fix condlog NULL argument in uevent_get_env_var (Ben)
 - fix boolean value with json-c 0.14 (Christian Hesse) 
 - [PATCH v3 0/6] multipath: path validation library prep work
   (v3 6-part series, me)
 - [PATCH 0/2] More minor libmultipath fixes (2-part series, me)
 - [PATCH 00/11] Minor fixes for multipath-tools (11-part series, me)
 - libmpathpersist: depend on libmultipath (Christian Hesse)
 - [PATCH v2 0/2] multipath-tools: fixes for kpartx.rules and skip_kpartx
   (v2 2-part series, me)
 - libmultipath: allow force reload with no active paths (Ben)
 - libmutipath: don't close fd on dm_lib_release (Ben)-
 - libmultipath: assign variable to make gcc happy (Ben)
 - [PATCH v2 0/4] libmpathpersist allocation size fixes (v2 4-part series, me)

You can find a full tree of the code this is based on here:
https://github.com/openSUSE/multipath-tools/tree/upstream-queue

Regards, Martin

Changes v2 -> v3:

 * 13/35 "libmultipath: constify blacklist code"
    - rebased

Changes v1 -> v2, as suggested by Ben Marzinski:

 *  8/35 "libmultipath: create bitfield abstraction"
    - return NULL for 0 bitfield size
    - fixed error handling for bf == NULL
    - removed unused find_first_set() and related tests
 * 12/35 "libmultipath: strlcpy()/strlcat(): use restrict qualifier"
    - unchanged, but resubmitting as it has no Reviewed-by: tag yet
      (corner case of unterminated "dst" still unresolved, but if at
       all, it should be changed in a separate patch).

Martin Wilck (35):
  multipath-tools tests/util: separate group for bitmask tests
  multipath-tools tests/directio: fix missing initializers
  tests: __wrap_dlog: use check_expected()
  multipath tools tests: add strchop() test
  libmultipath: improve strchop()
  multipath-tools tests: add test for devt2devname
  libmultipath: devt2devname(): simplify using libudev
  libmultipath: create bitfield abstraction
  libmultipath: use bitfields in group_by_match()
  libmultipath: util: constify function arguments
  multipath-tools tests: add unit tests for strlcat
  libmultipath: strlcpy()/strlcat(): use restrict qualifier
  libmultipath: constify blacklist code
  libmultipath: rlookup_binding(): remove newline in log message
  libmultipath: fix missing initializer warning from clang 3.9
  libmultipath: fix gcc -Wstringop-overflow warning
  libmultipath: remove uevent listener failback
  libmultipath: uevent: use static linkage where possible
  libmultipath: uevent: inline trivial functions
  libmultipath: decrease log level of "SCSI target" log message
  libmultipath: get_udev_uid(): more appropriate error code
  libmultipath: get_uid(): improve log message on udev failure
  libmultipath: make sysfs_pathinfo() static and use const
  libmultipath: pathinfo(): improve a log message
  libmultipath: pathinfo(): don't filter emtpy devnode names
  libmultipath: io_err_stat_handle_pathfail(): less error conditions
  libmultipath: improve libdm logging
  libmultipath: snprint_devices(): use udev_enumerate
  libmultipath: snprint_devices(): print hidden/foreign status
  libmultipath: alloc_path(): initialize pp->initialized
  libmultipath: alloc_path_with_pathinfo(): treat devname overflow as
    error
  libmultipath: log table params in addmap()
  multipathd: remove set_multipath_wwid()
  kpartx: print an error message if removing a partition fails
  kpartx: add missing newline

 kpartx/devmapper.c               |   2 +-
 kpartx/kpartx.c                  |   2 +
 libmultipath/alias.c             |   2 +-
 libmultipath/blacklist.c         |  34 +-
 libmultipath/blacklist.h         |  17 +-
 libmultipath/checkers/directio.c |   2 +-
 libmultipath/configure.c         |  11 +-
 libmultipath/defaults.h          |   2 +
 libmultipath/devmapper.c         |  27 +-
 libmultipath/discovery.c         |  30 +-
 libmultipath/dmparser.c          |   2 +-
 libmultipath/io_err_stat.c       |  25 +-
 libmultipath/parser.c            |   2 +-
 libmultipath/pgpolicies.c        |  12 +-
 libmultipath/print.c             |  90 ++---
 libmultipath/print.h             |   2 +-
 libmultipath/propsel.c           |   6 +
 libmultipath/structs.c           |   1 +
 libmultipath/uevent.c            | 324 ++----------------
 libmultipath/uevent.h            |  47 ++-
 libmultipath/util.c              | 155 +++------
 libmultipath/util.h              |  72 +++-
 multipathd/main.c                |  14 +-
 tests/Makefile                   |   3 +-
 tests/alias.c                    |   4 +-
 tests/devt.c                     | 192 +++++++++++
 tests/directio.c                 |  28 +-
 tests/test-log.c                 |   5 +-
 tests/uevent.c                   |   4 -
 tests/util.c                     | 554 ++++++++++++++++++++++++++++---
 30 files changed, 1035 insertions(+), 636 deletions(-)
 create mode 100644 tests/devt.c

-- 
2.28.0
