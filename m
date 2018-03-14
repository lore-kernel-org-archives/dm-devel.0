From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/12] multipath: new and rebased patches
Date: Wed, 14 Mar 2018 12:46:33 -0500
Message-ID: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
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
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Patches 1-5 are minor bug fixes and a unit test for basenamecpy.

Patch 6 is revised version of my nanosleep patch, that only changes
the checkerloop code, since that is the only time when multipathd
actually sets an alarm without locking.

Patches 7-11 are a rebase of my "alternate dmevents waiter method"
patchset.  The only code that has changed outside of rebasing them is in
patch 11.  It adds a function, remove_map_by_alias(), and uses it in
dmevent_loop(). This simply moves the code the gets the multipath device
out of dmevents.c, so it can work exclusively in device names.  It also
changes the names of the functions the initialize and cleanup the
dmevents polling code to match similar multipathd functions and adds
a Makefile define to disable using the polling code, both suggested
by Martin Wilck.

Patch 12 is unit testing code for the new code in dmevents.c

Here is the description from my initial posting of the alternate dmevents
waiter method" patchset:

This patchset implements a new method of getting dmevents for
multipathd.

With the existing wait code, multipathd needs to create a waiter thread
for every multipath device. This can become very wasteful in setups with
large numbers of multipath devices. These duplicate threads all are
serialized to update the multipath devices, so they don't actually speed
up dmevent handling.

The new method uses the new dmevent polling ability introduced in the
4.37.0 device-mapper kernel module.  The original method has been
retained for backwards compatablility, and it is possible to force
multipathd to use the orignal method on newer kernels. The benefit of
this new method is that there is only one thread necessary to wait on
dmevents, which can be started when device-mapper starts, and stopped
during shutdown, just like the other main threads.

These patches use device-mapper features that don't have a libdevmapper
API.  They will switch over as soon as support is available in
libdevmapper.

Benjamin Marzinski (12):
  Unit tests for basenamecpy
  libmultipath: fix basenamecpy
  libmultipath: set dm_conf_verbosity
  multipathd: log thread cleanup
  libmultipath: fix log_pthread processing
  multipathd: use nanosleep for strict timing
  libmultipath: move remove_map waiter code to multipathd
  move waiter code from libmultipath to multipathd
  call start_waiter_thread() before setup_multipath()
  libmultipath: add helper functions
  multipathd: add new polling dmevents waiter thread
  multipath: add unit tests for dmevents code

 Makefile.inc               |   3 +
 libmultipath/Makefile      |   2 +-
 libmultipath/devmapper.c   |  29 +-
 libmultipath/devmapper.h   |   3 +-
 libmultipath/log_pthread.c |  40 +--
 libmultipath/log_pthread.h |  10 +-
 libmultipath/structs_vec.c | 140 +-------
 libmultipath/structs_vec.h |   8 +-
 libmultipath/util.c        |  25 +-
 libmultipath/util.h        |   2 +-
 libmultipath/vector.c      |  16 +-
 libmultipath/vector.h      |   1 +
 libmultipath/waiter.c      | 215 ------------
 libmultipath/waiter.h      |  17 -
 multipathd/Makefile        |   6 +-
 multipathd/dmevents.c      | 392 +++++++++++++++++++++
 multipathd/dmevents.h      |  13 +
 multipathd/main.c          | 230 ++++++++++--
 multipathd/waiter.c        | 215 ++++++++++++
 multipathd/waiter.h        |  17 +
 tests/Makefile             |   9 +-
 tests/dmevents.c           | 847 +++++++++++++++++++++++++++++++++++++++++++++
 tests/util.c               | 167 +++++++++
 23 files changed, 1944 insertions(+), 463 deletions(-)
 delete mode 100644 libmultipath/waiter.c
 delete mode 100644 libmultipath/waiter.h
 create mode 100644 multipathd/dmevents.c
 create mode 100644 multipathd/dmevents.h
 create mode 100644 multipathd/waiter.c
 create mode 100644 multipathd/waiter.h
 create mode 100644 tests/dmevents.c
 create mode 100644 tests/util.c

-- 
2.7.4
