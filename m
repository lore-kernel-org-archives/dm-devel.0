From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [RFC PATCH 0/5] alternate dmevents waiter method
Date: Fri,  9 Feb 2018 23:07:26 -0600
Message-ID: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

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

This patchset is based on top of my recent "[PATCH v2 0/7] multipath:
miscellaneous bug fixes". It doesn't touch the tur checker, so changes
to "[PATCH v2 1/7] libmultipath: fix tur checker locking" won't change
anything in this set.

Benjamin Marzinski (5):
  libmultipath: move remove_map waiter code to multipathd
  move waiter code from libmultipath to multipathd
  call start_waiter_thread() before setup_multipath()
  libmultipath: add helper functions
  multipathd: RFC add new polling dmevents waiter thread

 libmultipath/Makefile      |   2 +-
 libmultipath/devmapper.c   |  28 +++-
 libmultipath/devmapper.h   |   3 +-
 libmultipath/structs_vec.c | 138 +---------------
 libmultipath/structs_vec.h |   6 +-
 libmultipath/vector.c      |  16 +-
 libmultipath/vector.h      |   1 +
 libmultipath/waiter.c      | 215 ------------------------
 libmultipath/waiter.h      |  17 --
 multipathd/Makefile        |   3 +-
 multipathd/dmevents.c      | 396 +++++++++++++++++++++++++++++++++++++++++++++
 multipathd/dmevents.h      |  13 ++
 multipathd/main.c          | 194 ++++++++++++++++++++--
 multipathd/waiter.c        | 215 ++++++++++++++++++++++++
 multipathd/waiter.h        |  17 ++
 15 files changed, 869 insertions(+), 395 deletions(-)
 delete mode 100644 libmultipath/waiter.c
 delete mode 100644 libmultipath/waiter.h
 create mode 100644 multipathd/dmevents.c
 create mode 100644 multipathd/dmevents.h
 create mode 100644 multipathd/waiter.c
 create mode 100644 multipathd/waiter.h

-- 
2.7.4
