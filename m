From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 07/10] dm-integrity: update documentation
Date: Mon, 29 Apr 2019 14:57:23 +0200
Message-ID: <20190429125744.763120000@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-docs.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Update documentation with the "meta_device" parameter and flags.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/dm-integrity.txt |   10 +++++++++-
 drivers/md/dm-integrity.c                    |    4 +++-
 2 files changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6/Documentation/device-mapper/dm-integrity.txt
===================================================================
--- linux-2.6.orig/Documentation/device-mapper/dm-integrity.txt	2019-04-26 16:29:56.000000000 +0200
+++ linux-2.6/Documentation/device-mapper/dm-integrity.txt	2019-04-26 17:12:29.000000000 +0200
@@ -79,6 +79,10 @@ interleave_sectors:number
 	a power of two. If the device is already formatted, the value from
 	the superblock is used.
 
+meta_device:device
+	Don't interleave the data and metadata on on device. Use a
+	separate device for metadata.
+
 buffer_sectors:number
 	The number of sectors in one buffer. The value is rounded down to
 	a power of two.
@@ -167,7 +171,11 @@ The layout of the formatted block device
 	  provides (i.e. the size of the device minus the size of all
 	  metadata and padding). The user of this target should not send
 	  bios that access data beyond the "provided data sectors" limit.
-	* flags - a flag is set if journal_mac is used
+	* flags
+	  SB_FLAG_HAVE_JOURNAL_MAC - a flag is set if journal_mac is used
+	  SB_FLAG_RECALCULATING - recalculating is in progress
+	* log2(sectors per block)
+	* a position where recalculating finished
 * journal
 	The journal is divided into sections, each section contains:
 	* metadata area (4kiB), it contains journal entries
Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-26 16:29:03.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-26 17:13:19.000000000 +0200
@@ -3093,10 +3093,12 @@ bad:
  *		buffer_sectors
  *		journal_watermark
  *		commit_time
+ *		meta_device
+ *		block_size
  *		internal_hash
  *		journal_crypt
  *		journal_mac
- *		block_size
+ *		recalculate
  */
 static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
