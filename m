From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 00/17] snapshot-merge target
Date: Tue, 20 Oct 2009 18:46:48 -0400
Message-ID: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
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

snapshot-merge target, quilt tree is maintained here:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.32/

For userspace LVM2 support please see:
http://people.redhat.com/msnitzer/patches/snapshot-merge/lvm2/LVM2-2.02.54/

Mike Snitzer (4):
  dm snapshot: add suspended flag to dm_snapshot
  dm snapshot: exception handover improvements
  dm exception store: snapshot-merge usage accounting
  dm snapshot: merge a linear region of chunks using one large IO

Mikulas Patocka (13):
  dm snapshot: rework writing to snapshot origin
  dm snapshot: initial support for exception handover
  dm exception store: do not read metadata if going to handover exceptions
  dm exception store: add snapshot-merge specific methods
  dm snapshot: add snapshot-merge target
  dm snapshot: merge target should not allocate new exceptions
  dm snapshot: do not allow more than one merging snapshot.
  dm snapshot: the merge procedure
  dm snapshot: queue writes to an area that is actively being merged
  dm snapshot: do not merge a chunk until active writes to it finish
  dm snapshot: make exceptions in other snapshots when merging
  dm snapshot: make exceptions if merge is dispatching to origin
  dm snapshot: redirect accesses to origin if merging snap invalidated

 drivers/md/dm-exception-store.h |   33 ++-
 drivers/md/dm-snap-persistent.c |   96 ++++++-
 drivers/md/dm-snap-transient.c  |    2 +-
 drivers/md/dm-snap.c            |  687 ++++++++++++++++++++++++++++++++-------
 4 files changed, 689 insertions(+), 129 deletions(-)
