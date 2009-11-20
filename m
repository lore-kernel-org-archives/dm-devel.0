From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 00/13] snapshot-merge target
Date: Fri, 20 Nov 2009 15:27:40 -0500
Message-ID: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The snapshot-merge target allows a snapshot to be merged back into the
snapshot's origin device.

One expected use of snapshot merging is the rollback of a root
filesystem after system upgrades (e.g.: yum update).  snapshot-merge
enables "system rollback" support for any filesystem that is using the
associated DM/LVM devices.

* "[PATCH v4 05/13] dm snapshot: add snapshot-merge target" adds further
  documentation to: Documentation/device-mapper/snapshot.txt

* All patch headers have been revised/audited for added clarity.

* Both the latest handover (v10) and origin-write patch have been
  included in this series.

* Aside from snapshot-merge specific testing these patches have
  survived 75+ iterations of lvm2's testsuite without any failures.
  The test kernel was 2.6.32-rc8 and lvm2 was 2.0.55 (with udev_sync
  enabled and dmeventd disabled).

The snapshot-merge quilt tree is maintained here:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.33/

For LVM2 support please see:
http://people.redhat.com/msnitzer/patches/snapshot-merge/lvm2/LVM2-2.02.55/

Mike Snitzer (3):
  dm snapshot: allow live exception store handover between tables
  dm exception store: snapshot-merge usage accounting
  dm snapshot: merge a linear region of chunks using one large IO

Mikulas Patocka (10):
  dm snapshot: rework writing to snapshot origin
  dm exception store: add snapshot-merge specific methods
  dm snapshot: add snapshot-merge target
  dm snapshot: merge target should not allocate new exceptions
  dm snapshot: do not allow more than one merging snapshot.
  dm snapshot: the merge procedure
  dm snapshot: queue writes to an area that is actively being merged
  dm snapshot: do not merge a chunk until active writes to it finish
  dm snapshot: make exceptions in other snapshots when merging
  dm snapshot: redirect accesses to origin if merging snap invalidated

 Documentation/device-mapper/snapshot.txt |   52 ++-
 drivers/md/dm-exception-store.h          |   27 +
 drivers/md/dm-snap-persistent.c          |   91 ++++-
 drivers/md/dm-snap.c                     |  827 ++++++++++++++++++++++++------
 4 files changed, 839 insertions(+), 158 deletions(-)
