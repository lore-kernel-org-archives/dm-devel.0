From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/9] dm flakey: add features
Date: Mon, 27 Jun 2011 15:53:34 -0400
Message-ID: <1309204423-8599-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Add "drop_writes", "corrupt_bio_byte" and "debug" features to the
flakey target.  This work was motivated by a need to test the checksum
support of the new DM multisnapshot target.

I was able to successfully test multisnap checksums with the
following:

load a previously created multisnapshot pool that has a valid
multisnap metadata superblock, when reading write 1 to the 352rd byte
of the bio (352 happens to the offset to an unused compat_flags field
in 'struct multisnap_super_block; the change causes the multisnap crc
code to notice):

echo "0 20971520 flakey 254:16 2048 0 5 5 corrupt_bio_byte 352 0 1 debug" | dmsetup create multisnap-metadata
echo "0 209715200 multisnap-pool 253:0 253:1 128 32" | dmsetup create pool
device-mapper: reload ioctl failed: Cannot allocate memory
Command failed

(NOTE: I need to cleanup the multisnapshot code so it doesn't throw
errors on the floor, checksum failure returns -EILSEQ not -ENOMEM)

The kernel log showed:
corrupting data bio=ffff88007c8d5140 by writing 1 to byte 352 (rw=0 flags=0 bi_sector=2056 cur_bytes=4096)
multisnap sb_check failed csum 4189028790 wanted 227629054
superblock validator check failed for block 0
couldn't lock superblock
tm_open_with_sm failed
device-mapper: table: 253:2: multisnap-pool: Error creating metadata object
device-mapper: ioctl: error adding target to table

Mike Snitzer (9):
  dm: factor out target argument parsing helpers
  dm flakey: use dm_target_offset() and support discards
  dm flakey: start of adding features
  dm flakey: add drop_writes feature
  dm flakey: add corrupt_bio_byte feature
  dm flakey: add corrupt_bio_byte read support
  dm flakey: switch corrupt_bio_data_dir to corrupt_bio_flags
  dm flakey: add ability to specify the corrupting value to be written
  dm flakey: add debug feature to control debug output

 drivers/md/dm-flakey.c        |  203 +++++++++++++++++++++++++++++++++++++---
 drivers/md/dm-mpath.c         |  119 ++++++++-----------------
 drivers/md/dm-table.c         |   40 ++++++++
 include/linux/device-mapper.h |   18 ++++
 4 files changed, 282 insertions(+), 98 deletions(-)
