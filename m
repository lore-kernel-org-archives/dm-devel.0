From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 00/13] snapshot-merge target
Date: Thu,  3 Dec 2009 21:23:41 -0500
Message-ID: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

The snapshot-merge target allows a snapshot to be merged back into the
snapshot's origin device.

One expected use of snapshot merging is the rollback of a root
filesystem after system upgrades (e.g.: yum update).  snapshot-merge
enables "system rollback" support for any filesystem that is using the
associated DM/LVM devices.

For LVM2 support please see:
http://people.redhat.com/msnitzer/patches/snapshot-merge/lvm2/LVM2-2.02.57/

v5 of this snapshot-merge series has the following changes:

* Updated to stack on agk's latest 'editing' quilt tree
* Added more content to Documentation/device-mapper/snapshot.txt
* Added comment block above snapshot_merge_map()
* Improved DMERR messages in merge_callback()
* Changed is_merge() macro to compare ti->type->name with a static
  string constant rather than checking ->map
* 'merging' flag is no longer cleared in persistent_prepare_exception
* Initialized 'merging_snap' to NULL in __find_merging_snapshot
* Removed one level of nesting in __validate_exception_handover
* Added 'merge_failed' flag to dm_snapshot structure and report merge
  failure accordingly in snapshot_status()

Mike Snitzer (3):
  dm exception store: snapshot-merge usage accounting
  dm snapshot: merge a linear region of chunks using one large IO
  dm snapshot: report merge failure in status

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

 Documentation/device-mapper/snapshot.txt |   60 +++-
 drivers/md/dm-exception-store.h          |   27 ++
 drivers/md/dm-snap-persistent.c          |   89 +++++-
 drivers/md/dm-snap.c                     |  603 +++++++++++++++++++++++-------
 4 files changed, 647 insertions(+), 132 deletions(-)
