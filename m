From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 00/12] snapshot-merge target
Date: Mon,  5 Oct 2009 15:02:35 -0400
Message-ID: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
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

Mike Snitzer (1):
  dm-snapshot-merge-use-larger-io-when-merging

Mikulas Patocka (11):
  dm-exception-store-merge-methods
  dm-exception-store-merge-accounting
  dm-snapshot-target-merge
  dm-snapshot-target-merge-no-new-alloc
  dm-snapshot-no-more-merging-snapshots
  dm-snapshot-merge-process
  dm-snapshot-merge-interlock-writes
  dm-snapshot-merge-track-writes
  dm-snapshot-merge-make-exceptions-in-other-snapshots-when-merging
  dm-snapshot-merge-make-exceptions-in-other-snapshots-if-remapped-to-origin
  dm-snapshot-merge-redirect-to-origin-if-invalidated

 drivers/md/dm-exception-store.h |   27 +++
 drivers/md/dm-snap-persistent.c |   89 +++++++++-
 drivers/md/dm-snap.c            |  379 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 482 insertions(+), 13 deletions(-)
