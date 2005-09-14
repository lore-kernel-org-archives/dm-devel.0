From: Neil Brown <neilb@suse.de>
Subject: PATCH - pvmove doesn't terminate sometimes on 64-bit
	bigendian machines
Date: Wed, 14 Sep 2005 14:32:59 +1000
Message-ID: <17191.43003.616513.15285@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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


Hi,
 I recently had to track down a problem with pvmove not terminating on
 an s390x.
 The patch below fixes the problem.

 The problem is specific to 64-bit bigendian machines such as s390x or
 ppc-64.

 The linux bitset operators (test_bit, set_bit etc) work on arrays of 
 "unsigned long".
 dm-log uses such bitsets but treats them often as arrays of uint32_t,
 only allocateing a multiple of 4 bytes (as 'clean_bits' is a uint32_t).
 Further, it only zeros a multiple of 4 bytes.

 In the simplest case, if "region_count" were (say) 30, then
 bitset_size (below) would be 4 and bitset_uint32_count would be 1.
 Thus the memory for this butset, after allocation and zeroing would
 be
    0 0 0 0 X X X X 
 On a bigendian 64bit machine, bit 0 for this bitset is in the 8th
 byte! (and every bit that dm-log would use would be in the X area).

    0 0 0 0 X X X X 
                  ^
                  here

 which hasn't been cleared properly.

 As the dm-raid1 code only syncs and counts regions which have a 0 in
 the 'sync_bits' bitset, and only finishes when it has counted high
 enough, a large number of 1's among those 'X's will cause the sync to
 not complete.

 It is worth noting that the code uses the same bitsets for in-memory
 and on-disk logs.  As these bitsets are host-endian and host-sized,
 this means that they cannot safely be moved between computers with
 different architectures.  I don't know if the dm doco makes this
 clear...

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-log.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/dm-log.c~current~ ./drivers/md/dm-log.c
--- ./drivers/md/dm-log.c~current~	2005-09-14 14:19:51.000000000 +1000
+++ ./drivers/md/dm-log.c	2005-09-14 14:21:56.000000000 +1000
@@ -333,10 +333,10 @@ static int core_ctr(struct dirty_log *lo
 	lc->sync = sync;
 
 	/*
-	 * Work out how many words we need to hold the bitset.
+	 * Work out how many "unsigned long"s we need to hold the bitset.
 	 */
 	bitset_size = dm_round_up(region_count,
-				  sizeof(*lc->clean_bits) << BYTE_SHIFT);
+				  sizeof(unsigned long) << BYTE_SHIFT);
 	bitset_size >>= BYTE_SHIFT;
 
 	lc->bitset_uint32_count = bitset_size / 4;
