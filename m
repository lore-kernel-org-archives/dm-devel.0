From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 00/22] multipath path classification
Date: Fri, 13 Apr 2018 23:59:53 +0200
Message-ID: <20180413220015.7032-1-mwilck@suse.com>
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

Hello Christophe,

(this set is based on 1cb704b2 plus those recent patches that have been
positively reviewed, see
https://github.com/openSUSE/multipath-tools/commits/upstream-queue).

This patch set implements a new, improved path detection logic based
on the previous discussions in the dm-devel threads "Multipath path 
classification revisited" and "RFC: multipath path classification", as well
as Ben's review of v2 of this series. Up to 08/20, this series is the same
as v2. Patch 11/20ff are substantially changed from v2. I left out the log
level changes I'd included in the v2 series, they will be submitted as a
separate series later.

The ideas of this patch set are:

 1. Avoid boot failures due to "blocked" devices, in particular setting
   SYSTEMD_READY=0 for path devices while multipathd can't setup maps for
   some reason. To this end, a means to indicate mapping failure
   has been added in patch 9-10. This was not in the RFC series.
   In contrast the v2 series, failure is not considered permanent;
   multipath and multipathd retry to setup the map under normal operations.
   Only "multipath -u/-c" checks and honors the failed flag always.
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
    "local SATA root" case. This is implemented in patch 11-20, implementation
    details have changed wrt the RFC series.
 5. Don't break compatibility with default setups of major distros. The
   semantics of "find_multipaths yes" and "find_multipaths no" was preserved
   for backwards compatibility (see commit message of patch 7 for details).

A side effect of this patch set is that the user visible output of "multipath -u"
and "multipath -c" has been changed to udev-friendly KEY="value" format.
Also, with v5 of the set, the exit status of "multipath -u" is 0 even if the
path is not a multipath member, in order to make udev happy.

Changes v4->v5:

 - rebased on top of latest reviewed patches, see above
 - numbering v4->v5: 17->20, 18->18, 19->21, 20->22
 - whitespace and other style fixes in 05/22, 06/22, 07/22, 09/22, 15/22,
   16/22, 18/22 (checkpatch.pl; I took the freedom to keep Ben's reviewed-by tags).
 - 07/22: fixed error I made in v4 while rebasing to latest upstream
 - 15/22: fixed a compilation warning regarding "const"
 - 16/22: symbolic return code in find_multipaths_check_timeout (Ben)
 - 16/22: add udev rule to remove timeout marker on remove uevent (Ben)
 - 17/22: NEW, make "multipath -u" logic a bit simpler to read
 - 19/22: NEW, avoid returning "maybe" or "yes" after "no" (Ben)
 - 20/22: by virtue of 19/22, the O_EXCL test is never run after a device
   has been been released to systemd. This was Ben's main concern for v4.

Only 16, 17, 19, 20 are lacking Reviewed-by: tags now.

This series is also available here:
https://github.com/mwilck/multipath-tools/commits/path-detection-v5

A broken-out version showing the FIX patches v4->v5 is here:
https://github.com/mwilck/multipath-tools/commits/path-detection-v4_v5

Changes v3->v4:

 - Rebased onto latest upstream, commit 1cb704b
 - 07/20: changed macro names to ignore_wwids_on, ignore_new_devs_on to
   avoid ambiguity with variable names

Changes v2->v3:

Almost all of these are direct or indirect outcomes of Ben Marzinski's review
of the v2 series. Kudos to Ben for the excellent review!

 - 09/20: use symbolic return codes for the helper functions for map failure
 - 09/20: use pthread_once() for path initialization
 - 11/20: added one more common code path invocation I'd forgotten in v2. 
 - 13/20 "multipath -u: treat failed wwids as invalid" replaces v2 11/20
   "don't try to setup failed wwids again" (we do try now, just not in
   "multipath -u").
 - 16/20 and 19-20/20 change the way the udev rules communicate with multipath -u.
   In contrast to v2, we directly calculate the expiry time in "multipath -u" itself
   now, saving several callouts in the udev rules. Moreover, we remember the
   timeouts as timestamps under /dev/shm, allowing to pass this information
   across pivot-root.
 - 17/20 introduces a test if a path is busy, addressing Ben's valid concern that
   a file system mounted on a path device in the initrd might be unmounted
   because rules setting SYSTEMD_READY=0 on the device, permanently or
   temporarily. 
 - 18/20 is an new addition, a speed-up for some cases where multipath -u would
   otherwise need to scan all paths and dm maps.
 - In 20/20, added the code path to multipath.rules for
   cancelling a running systemd timer and thus avoiding a spurious "add" event.
 - dropped v2 18/20-20/20.

Patch 1-8 and 12, 14, 15, 19 are identical or only minimally modified wrt
their counterparts in v2 (numbering changed from 11 on, though).

Changes RFC->v2 not described above:

 - 03/17 "should_multipath: keep existing maps": don't check for empty
   pathvec; rather check if the mapping actually exists in device-mapper (Ben
   Marzinski)

Regards,
Martin

Benjamin Marzinski (1):
  libmultipath: trigger change uevent on new device creation

Martin Wilck (21):
  Revert "multipath: ignore -i if find_multipaths is set"
  Revert "multipathd: imply -n if find_multipaths is set"
  libmultipath: should_multipath: keep existing maps
  multipath -u -i: respect entries in WWIDs file
  libmultipath: trigger path uevent only when necessary
  libmultipath: change find_multipaths option to multi-value
  libmultipath: use const char* in open_file()
  libmultipath: functions to indicate mapping failure in /dev/shm
  libmultipath: indicate wwid failure in dm_addmap_create()
  multipath -u: common code path for result message
  multipath -u: change output to environment/key format
  multipath -u: treat failed wwids as invalid
  multipath -u: add DM_MULTIPATH_DEVICE_PATH=2 for "maybe"
  libmultipath: implement find_multipaths_timeout
  multipath -u : set FIND_MULTIPATHS_WAIT_UNTIL from /dev/shm
  multipath -u: cleanup logic
  multipath -u: quick check if path is multipathed
  multipath -u: don't grab devices already passed to system
  multipath -u: test if path is busy
  libmultipath: enable find_multipaths "smart"
  multipath.rules: find_multipaths "smart" logic

 libmultipath/config.h      |   3 +-
 libmultipath/configure.c   |  70 ++++++++++-
 libmultipath/configure.h   |   1 +
 libmultipath/defaults.h    |   5 +-
 libmultipath/devmapper.c   |   9 +-
 libmultipath/dict.c        |  55 ++++++++-
 libmultipath/file.c        |   8 +-
 libmultipath/file.h        |   3 +-
 libmultipath/propsel.c     |  25 ++++
 libmultipath/propsel.h     |   1 +
 libmultipath/structs.h     |  28 +++++
 libmultipath/sysfs.c       |  66 ++++++++++
 libmultipath/sysfs.h       |   2 +
 libmultipath/wwids.c       | 128 ++++++++++++++++++-
 libmultipath/wwids.h       |  13 +-
 multipath/main.c           | 297 ++++++++++++++++++++++++++++++++++++++++-----
 multipath/multipath.8      |   9 +-
 multipath/multipath.conf.5 |  79 ++++++++----
 multipath/multipath.rules  |  70 ++++++++++-
 multipathd/main.c          |  15 +--
 multipathd/multipathd.8    |   8 +-
 21 files changed, 802 insertions(+), 93 deletions(-)

-- 
2.16.1
