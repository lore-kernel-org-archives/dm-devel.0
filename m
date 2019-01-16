From: Daniel Axtens <dja@axtens.net>
Subject: Re: NULL ptr deref in blk_queue_split with bcache:
	bio->bi_io_vec == NULL
Date: Wed, 16 Jan 2019 11:04:18 +1100
Message-ID: <87h8e9ii2l.fsf@linkitivity.dja.id.au>
References: <87zhs3ogd6.fsf@linkitivity.dja.id.au>
	<a2eee193-df00-047e-0600-61e6b96ff824@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a2eee193-df00-047e-0600-61e6b96ff824@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, gpiccoli@canonical.com, Kent Overstreet <kent.overstreet@gmail.com>, Mauricio Oliveira <mauricio.oliveira@canonical.com>
List-Id: dm-devel.ids

+dm-devel

I think I have made some progress here. One of my colleagues ran a test
with tracepoints on and I spotted that the last write has its flags
flipped compared to the other writes:

fstrim-18019 [022] .... 91107.302026: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4260112 + 196352 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302050: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4456464 + 262144 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302075: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4718608 + 81920 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302094: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5324816 + 180224 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302121: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5505040 + 262144 hit 0 bypass 1
fstrim-18019 [022] .... 91107.302145: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5767184 + 81920 hit 0 bypass 1
fstrim-18019 [022] .... 91107.308777: bcache_write: 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 6373392 + 180224 hit 1 bypass 0

I think this causes it to go down a different path in cached_dev_write
which leads to the issue.

Instrumenting cached_dev_write confirmed that this block was being hit:

	if (should_writeback(dc, s->orig_bio,
			     cache_mode(dc),
			     s->iop.bypass)) {
		s->iop.bypass = false;
		s->iop.writeback = true;
	}

Looking at should_writeback(), the relevant bits are:

static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
				    unsigned cache_mode, bool would_skip)
{
...

	if (dc->partial_stripes_expensive &&
	    bcache_dev_stripe_dirty(dc, bio->bi_iter.bi_sector,
				    bio_sectors(bio)))
		return true;

	if (would_skip)
		return false;

We were hitting a case where that partial strip condition was returning
true and so should_writeback() was returning true early.

If that hadn't been the case, it would have hit the would_skip test, and
as would_skip == s->iop.bypass == true, should_writeback() would have
returned false.

Looking at the git history from 72c270612bd3 ("bcache: Write out full
stripes"), it looks like the idea was to optimise for raid5/6:

     * If a stripe is already dirty, force writes to that stripe to
       writeback mode - to help build up full stripes of dirty data
    
If I swap those two conditions so that the would_skip test is earlier,
my system no longer crashes with the reproducer:

diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index a0bb87894a6f..de3c58c2da11 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -72,14 +72,14 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
            in_use > CUTOFF_WRITEBACK_SYNC)
                return false;
 
+       if (would_skip)
+               return false;
+
        if (dc->partial_stripes_expensive &&
            bcache_dev_stripe_dirty(dc, bio->bi_iter.bi_sector,
                                    bio_sectors(bio)))
                return true;
 
-       if (would_skip)
-               return false;
-
        return (op_is_sync(bio->bi_opf) ||
                bio->bi_opf & (REQ_META|REQ_PRIO) ||
                in_use <= CUTOFF_WRITEBACK);


I think this change just undoes the optimisation in some cases. However,
looking at the structure and history I'm a bit worried that it's too big
of a hammer. Perhaps a more specific test might be preferable - maybe
one that checks for a discard? I'm happy to assemble a patch, I just
wanted to check in with people with more experience in this area of the
kernel first!

Regards,
Daniel

>> We have a couple of machines that are experiencing NULL pointer
>> dereferences when executing fstrim.
>> 
>> It can be reliably reproduced on at least:
>>  - HP ProLiant DL360 Gen9/ProLiant DL360 Gen9, BIOS P89 12/27/2015
>>  - Cisco Systems Inc UCSC-C240-M5L/UCSC-C240-M5L
>> 
>> In both cases we have:
>> 1) LVM/devmapper involved (bcache backing device is LVM volume) 
>> 2) writeback cache involved (bcache cache_mode is writeback) 
>> 
>> On the HP box, we can reliably reproduce it with:
>> 
>> # echo writeback > /sys/block/bcache0/bcache/cache_mode # not sure if this is required
>> # mount /dev/bcache0 /test 
>> # for i in {0..10}; do file="$(mktemp /test/zero.XXX)"; dd if=/dev/zero of="$file" bs=1M count=256; sync; rm $file; done; fstrim -v /test 
>> This has been Oopsing in the first try.
>> 
>> We have seen it on mainline (commit 40a31da), and as far back as v4.15.
>> 
>> The panic reads as follows:
>> 
>> [  421.796849] EXT4-fs (bcache0): mounted filesystem with ordered data mode. Opts: (null)
>> [  529.803060] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> [  530.183928] #PF error: [normal kernel read fault]
>> [  530.412392] PGD 8000001f42163067 P4D 8000001f42163067 PUD 1f42168067 PMD 0 
>> [  530.750887] Oops: 0000 [#1] SMP PTI
>> [  530.920869] CPU: 10 PID: 4167 Comm: fstrim Kdump: loaded Not tainted 5.0.0-rc1+ #3
>> [  531.290204] Hardware name: HP ProLiant DL360 Gen9/ProLiant DL360 Gen9, BIOS P89 12/27/2015
>> [  531.693137] RIP: 0010:blk_queue_split+0x148/0x620
>> [  531.922205] Code: 60 38 89 55 a0 45 31 db 45 31 f6 45 31 c9 31 ff 89 4d 98 85 db 0f 84 7f 04 00 00 44 8b 6d 98 4c 89 ee 48 c1 e6 04 49 03 70 78 <8b> 46 08 44 8b 56 0c 48 8b 16 44 29 e0 39 d8 48 89 55 a8 0f 47 c3
>> [  532.838634] RSP: 0018:ffffb9b708df39b0 EFLAGS: 00010246
>> [  533.093571] RAX: 00000000ffffffff RBX: 0000000000046000 RCX: 0000000000000000
>> [  533.441865] RDX: 0000000000000200 RSI: 0000000000000000 RDI: 0000000000000000
>> [  533.789922] RBP: ffffb9b708df3a48 R08: ffff940d3b3fdd20 R09: 0000000000000000
>> [  534.137512] R10: ffffb9b708df3958 R11: 0000000000000000 R12: 0000000000000000
>> [  534.485329] R13: 0000000000000000 R14: 0000000000000000 R15: ffff940d39212020
>> [  534.833319] FS:  00007efec26e3840(0000) GS:ffff940d1f480000(0000) knlGS:0000000000000000
>> [  535.224098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  535.504318] CR2: 0000000000000008 CR3: 0000001f4e256004 CR4: 00000000001606e0
>> [  535.851759] Call Trace:
>> [  535.970308]  ? mempool_alloc_slab+0x15/0x20
>> [  536.174152]  ? bch_data_insert+0x42/0xd0 [bcache]
>> [  536.403399]  blk_mq_make_request+0x97/0x4f0
>> [  536.607036]  generic_make_request+0x1e2/0x410
>> [  536.819164]  submit_bio+0x73/0x150
>> [  536.980168]  ? submit_bio+0x73/0x150
>> [  537.149731]  ? bio_associate_blkg_from_css+0x3b/0x60
>> [  537.391595]  ? _cond_resched+0x1a/0x50
>> [  537.573774]  submit_bio_wait+0x59/0x90
>> [  537.756105]  blkdev_issue_discard+0x80/0xd0
>> [  537.959590]  ext4_trim_fs+0x4a9/0x9e0
>> [  538.137636]  ? ext4_trim_fs+0x4a9/0x9e0
>> [  538.324087]  ext4_ioctl+0xea4/0x1530
>> [  538.497712]  ? _copy_to_user+0x2a/0x40
>> [  538.679632]  do_vfs_ioctl+0xa6/0x600
>> [  538.853127]  ? __do_sys_newfstat+0x44/0x70
>> [  539.051951]  ksys_ioctl+0x6d/0x80
>> [  539.212785]  __x64_sys_ioctl+0x1a/0x20
>> [  539.394918]  do_syscall_64+0x5a/0x110
>> [  539.568674]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> 
>> Looking at the disassembly for blk_queue_split, it appears that the
>> issue is that bi_io_vec is NULL.  The address of the bio is in r8, and
>> indeed bi_io_vec is NULL:
>> 
>> crash> struct bio ffff940d3b3fdd20
>> struct bio {
>>   bi_next = 0x0, 
>>   bi_disk = 0xffff940c17c56800, 
>>   bi_opf = 1, 
>>   bi_flags = 1540, 
>>   bi_ioprio = 0, 
>>   bi_write_hint = 0, 
>>   bi_status = 0 '\000', 
>>   bi_partno = 0 '\000', 
>>   bi_phys_segments = 0, 
>>   bi_seg_front_size = 0, 
>>   bi_seg_back_size = 0, 
>>   bi_iter = {
>>     bi_sector = 212452816, 
>>     bi_size = 286720, 
>>     bi_idx = 0, 
>>     bi_bvec_done = 0
>>   }, 
>>   __bi_remaining = {
>>     counter = 1
>>   }, 
>>   bi_end_io = 0xffffffffc0455810 <bch_data_insert_endio>, 
>>   bi_private = 0xffff940c04f698a0, 
>>   bi_blkg = 0xffff940c129a7400, 
>>   bi_issue = {
>>     value = 1261008425052734119
>>   }, 
>>   {
>>     bi_integrity = 0x0
>>   }, 
>>   bi_vcnt = 0, 
>>   bi_max_vecs = 0, 
>>   __bi_cnt = {
>>     counter = 1
>>   }, 
>>   bi_io_vec = 0x0, 
>>   bi_pool = 0xffff940d3a280de0, 
>>   bi_inline_vecs = 0xffff940d3b3fdda8
>> }
>> 
>> 
>> The stack being a bit odd, we used ftrace to get a function graph
>> trace. That clarified things a bit - here is the chronology:
>> 
>> Looking at generic_make_request(), we see:
>> 
>> 	bio_list_init(&bio_list_on_stack[0]);
>> 	current->bio_list = bio_list_on_stack;
>> 	do {
>> 		struct request_queue *q = bio->bi_disk->queue;
>> 		blk_mq_req_flags_t flags = bio->bi_opf & REQ_NOWAIT ?
>> 			BLK_MQ_REQ_NOWAIT : 0;
>> 
>> 		if (likely(blk_queue_enter(q, flags) == 0)) {
>> 			struct bio_list lower, same;
>> 
>> 			/* Create a fresh bio_list for all subordinate requests */
>> 			bio_list_on_stack[1] = bio_list_on_stack[0];
>> 			bio_list_init(&bio_list_on_stack[0]);
>> 			ret = q->make_request_fn(q, bio);
>> 
>> On the first iteration of the loop, q->make_request_function invokes
>> cached_dev_make_request(). That calls generic_make_request a few times -
>> making what I understand to be requests to write out to the underlying
>> device. Then cached_dev_make_request returns, and in the next iteration
>> of the loop, one of the new entries is pulled off the list,
>> blk_mq_make_request attempts to call blk_queue_split on it, and that
>> explodes.
>> 
>> I'm not quite sure why the new bios have bi_io_vec as NULL - it would
>> seem to imply the original bio had it as NULL too. I don't know why
>> that would be and I haven't been able to trace that far backwards just
>> yet.
>> 
>> I'm having some trouble unpicking the closures that make up bcache, so
>> I was hoping someone would be able to point me in the right direction?
>> 
>> As I said, we can reproduce this easily so we're happy to gather any
>> extra information required or test anything.
>> 
>> Regards,
>> Daniel
>> 
>
>
> +linux-block
>
> Cheers,
>
>
> Guilherme
