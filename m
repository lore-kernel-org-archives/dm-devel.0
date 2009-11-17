From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 00/12] snapshot-merge target
Date: Tue, 17 Nov 2009 11:12:12 -0500
Message-ID: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
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
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.33/

For LVM2 support please see:
http://people.redhat.com/msnitzer/patches/snapshot-merge/lvm2/LVM2-2.02.55/

This patch series builds on Alasdair's latest 'editing' quilt tree;
but also depends on "dm snapshot: rework writing to snapshot origin",
see: http://patchwork.kernel.org/patch/60691/

Mike Snitzer (2):
  dm exception store: snapshot-merge usage accounting
  dm snapshot: merge a linear region of chunks using one large IO

Mikulas Patocka (10):
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

 drivers/md/dm-exception-store.h |   27 +++
 drivers/md/dm-snap-persistent.c |   91 +++++++++-
 drivers/md/dm-snap.c            |  409 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 509 insertions(+), 18 deletions(-)
