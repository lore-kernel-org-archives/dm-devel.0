From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/20] multipath path classification
Date: Mon, 19 Mar 2018 16:01:35 +0100
Message-ID: <20180319150155.5363-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christophe,

(This patch set is based on Ben's late series "multipath: new and rebased
patches" and "multipathd per-device waiter fixes". If preferred, I can of
course submit a series based on plain 0.7.6. There's only one minor conflict).

This patch set implements a new, improved path detection logic based
on the previous discussions in the dm-devel threads "Multipath path 
classification revisited" and "RFC: multipath path classification". I believe
that this is ready for upstream inclusion now. My testing has shown that this
is as close to "it just works" as we may be able to get. Changes wrt the RFC
submission are substantial, I've been trying hard to meet Ben's concerns, and
fixed various bugs that showed up in tests.

The ideas of this patch set are:

 1. Avoid boot failures due to "blocked" devices, in particular setting
   SYSTEMD_READY=0 for path devices while multipathd can't setup maps for
   some reason. To this end, a means to indicate mapping failure
   has been added in patch 9-11. This was not in the RFC series.
 2. Try to be as consistent as possible between udev rule processing
   (multipath -u) and multipathd. Patch 1-4 contain the necessary logic
   fixes. That alone doesn't fully avoid inconsistencies because udev rule
   processing and multipathd processing occur at different points in time.
   Therefore, Logic to retrigger uevents if multipathd detects inconsistencies
   has been added in patch 5 and 6.
 3. Disallow combinations of options that are dangerous or inconsistent, and
    generally simplify configuration. This is done by merging
   "find_multipaths", "multipath -i", and "multipathd -n" into a multi-value
   "find_multipaths" option in patch 7. This was not in the RFC series.
 4. Try to a achieve "it just works" autodetection, I've called it "smart".
    This requires waiting for siblings, which necessarily inflicts a certain
    delay on initial set-up (boot). To meet the criticism raised on the RFC
   series, I've tried to minimize these delays, in particular for the common
   "local SATA root" case. This is implemented in patch 12-17, implementation
   details have changed wrt the RFC series.
 5. Don't break compatibility with default setups of major distros. The
   semantics of "find_multipaths yes" and "find_multipaths no" was preserved
   for backwards compatibility (see commit message of patch 7 for details).

A side effect of this patch set is that the user visible output of "multipath
-u" and "multipath -c" has been changed to udev-friendly KEY="value" format.

Changes wrt RFC series not described above:
 - 03/17 "should_multipath: keep existing maps": don't check for empty
 pathvec; rather check if the mapping actually exists in device-mapper (Ben
 Marzinski)
 - added three minor patches at the end changing log levels (18-20)

Regards,
Martin

Benjamin Marzinski (1):
  libmultipath: trigger change uevent on new device creation

Martin Wilck (19):
  Revert "multipath: ignore -i if find_multipaths is set"
  Revert "multipathd: imply -n if find_multipaths is set"
  libmultipath: should_multipath: keep existing maps
  multipath -u -i: respect entries in WWIDs file
  libmultipath: trigger path uevent only when necessary
  libmultipath: change find_multipaths option to multi-value
  libmultipath: use const char* in open_file()
  libmultipath: functions to indicate mapping failure in /dev/shm
  libmultipath: indicate wwid failure in dm_addmap_create()
  libmultipath: don't try to set up failed wwids again
  multipath -u: common code path for result message
  multipath -u: change output to environment/key format
  multipath -u: add DM_MULTIPATH_DEVICE_PATH=2 for "maybe"
  libmultipath: implement find_multipaths_timeout
  libmultipath: enable find_multipaths "smart"
  multipath.rules: find_multipaths "smart" logic
  multipathd: decrease log level of "spurious uevent" message
  libmultipath: decrease log level of uevent filter/merge messages
  multipathd: decrease log level of waiter thread start/stop msgs

 libmultipath/config.h      |   3 +-
 libmultipath/configure.c   |  73 +++++++++++++++++++++++--
 libmultipath/configure.h   |   4 +-
 libmultipath/defaults.h    |   4 +-
 libmultipath/devmapper.c   |   8 ++-
 libmultipath/dict.c        |  54 ++++++++++++++++++-
 libmultipath/file.c        |   6 +--
 libmultipath/file.h        |   2 +-
 libmultipath/propsel.c     |  25 +++++++++
 libmultipath/propsel.h     |   1 +
 libmultipath/structs.h     |  28 ++++++++++
 libmultipath/uevent.c      |   4 +-
 libmultipath/wwids.c       | 129 ++++++++++++++++++++++++++++++++++++++++++---
 libmultipath/wwids.h       |   7 ++-
 multipath/main.c           |  79 ++++++++++++++++-----------
 multipath/multipath.8      |   9 +++-
 multipath/multipath.conf.5 |  75 +++++++++++++++++++-------
 multipath/multipath.rules  |  84 +++++++++++++++++++++++++++--
 multipathd/cli_handlers.c  |   5 +-
 multipathd/main.c          |  28 ++++------
 multipathd/main.h          |   8 +++
 multipathd/multipathd.8    |   8 +--
 multipathd/waiter.c        |   4 +-
 23 files changed, 544 insertions(+), 104 deletions(-)

-- 
2.16.1
