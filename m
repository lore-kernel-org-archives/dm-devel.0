From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] dm-io: reject unsupported DISCARD requests
	with EOPNOTSUPP
Date: Fri, 13 Feb 2015 11:05:37 -0800
Message-ID: <20150213190537.GA5519@birch.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com
Cc: Todd Vierling <todd.vierling@oracle.com>, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Srinivas Eeda <srinivas.eeda@oracle.com>
List-Id: dm-devel.ids

I created a dm-raid1 device backed by a device that supports DISCARD
and another device that does NOT support DISCARD with the following
dm configuration:

# echo '0 2048 mirror core 1 512 2 /dev/sda 0 /dev/sdb 0' | dmsetup create moo
# lsblk -D
NAME         DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
sda                 0        4K       1G         0
`-moo (dm-0)        0        4K       1G         0
sdb                 0        0B       0B         0
`-moo (dm-0)        0        4K       1G         0

Notice that the mirror device /dev/mapper/moo advertises DISCARD
support even though one of the mirror halves doesn't.

If I issue a DISCARD request (via fstrim, mount -o discard, or ioctl
BLKDISCARD) through the mirror, kmirrord gets stuck in an infinite
loop in do_region() when it tries to issue a DISCARD request to sdb.
The problem is that when we call do_region() against sdb, num_sectors
is set to zero because q->limits.max_discard_sectors is zero.
Therefore, "remaining" never decreases and the loop never terminates.

Before entering the loop, check for the combination of REQ_DISCARD and
no discard and return -EOPNOTSUPP to avoid hanging up the mirror
device.

This bug was found by the unfortunate coincidence of pvmove and a
discard operation in the RHEL 6.5 kernel; 3.19 is also affected.

v2: Remove the WRITE SAME part since dm won't allow it unless all
component devices support it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Todd Vierling <todd.vierling@oracle.com>
---
 drivers/md/dm-io.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index c09359d..37de017 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -290,6 +290,12 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 	unsigned short logical_block_size = queue_logical_block_size(q);
 	sector_t num_sectors;
 
+	/* Reject unsupported discard requests */
+	if ((rw & REQ_DISCARD) && !blk_queue_discard(q)) {
+		dec_count(io, region, -EOPNOTSUPP);
+		return;
+	}
+
 	/*
 	 * where->count may be zero if rw holds a flush and we need to
 	 * send a zero-sized flush.
