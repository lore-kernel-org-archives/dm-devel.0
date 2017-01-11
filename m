From: Hou Tao <houtao1@huawei.com>
Subject: Re: question about block-throttle on data device of
 dm-thin pool
Date: Wed, 11 Jan 2017 09:21:56 +0800
Message-ID: <546a1fdf-6c85-6cef-7572-337cbdcf6492@huawei.com>
References: <86d82254-b548-ae88-ddfe-e60af2cc009a@huawei.com>
	<20170110194259.GH23108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170110194259.GH23108@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids


On 2017/1/11 3:42, Vivek Goyal wrote:
> On Tue, Jan 10, 2017 at 02:47:02PM +0800, Hou Tao wrote:
>> Hi, all.
>>
>> I am trying to test block-throttle on dm-thin devices. I find the throttling
>> on dm-thin device is OK, but the throttling doesn't work for the data device
>> of dm-thin pool.
>>
>> The following is my test case:
>> #!/bin/sh
>>
>> dmsetup create pool --table '0 41943040 thin-pool /dev/vdb /dev/vda \
>> 	128 6553 1 skip_block_zeroing
>> dmsetup message /dev/mapper/pool 0 'create_thin 1'
>> dmsetup create thin_1 --table '0 41943040 thin /dev/mapper/pool 1'
>>
>> mp=/thin_1
>> mkfs.xfs /dev/mapper/thin_1
>> mount /dev/mapper/thin_1 $mp
>>
>> cg=/sys/fs/cgroup/blkio/test
>> mkdir -p $cg
>> # get the block device id of the data device
>> data_dev=$(dmsetup table /dev/mapper/pool | awk '{print $5}')
>> echo "${data_dev} 1048576" > $cg/blkio.throttle.write_bps_device
>> echo $$ > $cg/cgroup.procs
>> dd if=/dev/zero of=$mp/zero bs=1M count=1 oflag=direct
>>
>> I read the dm-thin code roughly and find out that most bios are submitted
>> by the workqueue of thin pool instead of the dd process which initiates the
>> O_DIRECT write operations. The bios belong to the block cgroup "blkcg_root"
>> instead of the created block cgroup "test" in test case, so the write
>> limitation of blkcg "test" doesn't work.
>>
>> In order to make the throttling work out, can we save the original block
>> cgroup info of the deferred bios and use the saved block cgroup info to
>> submit the bios ? Is the method reasonable and is there a better way to
>> complete the throttling on the data device of the thin pool ?
> 
> I thought we had a patches where bio_clone_bioset() also retained
> cgroup information of original bio.
> 
> commit 20bd723ec6a3261df5e02250cd3a1fbb09a343f2
> Author: Paolo Valente <paolo.valente@linaro.org>
> Date:   Wed Jul 27 07:22:05 2016 +0200
> 
>     block: add missing group association in bio-cloning functions
> 
> Are you running new enough kernel. If not, may be there are still
> some places either in generic code or dm code where cloned/newly
> created bios are attributed to root cgroup and not to the cgroup
> of bio which caused creation of that new bio.
>
> Vivek
>
Hi, Vivek.

Thanks for your reply.

The version of the used linux kernel is 4.10-rc3.

bio_clone_blkcg_association() works only when the bi_css of source bio has
been initializaed before. In my test case, the bios submitted to dm-thin
device will not by throttled, so the bi_css is NULL.

Maybe we need assign the bi_css field of bio by usingbio_associate_current()
when the bi_css field is NULL and the target may defer the submit of the bio.
Something likes the following patch does:

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d1c05c1..97392a9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4177,6 +4177,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 static int thin_map(struct dm_target *ti, struct bio *bio)
 {
        bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
+       dm_retain_bio_blkcg(bio);

        return thin_bio_map(ti, bio);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5..f129ca4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1290,9 +1290,10 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
        if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
                dm_put_live_table(md, srcu_idx);

-               if (!(bio->bi_opf & REQ_RAHEAD))
+               if (!(bio->bi_opf & REQ_RAHEAD)) {
+                       dm_retain_bio_blkcg(bio);
                        queue_io(md, bio);
-               else
+               } else
                        bio_io_error(bio);
                return BLK_QC_T_NONE;
        }
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f0aad08..e86c74f 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -214,4 +214,10 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
  */
 unsigned dm_get_reserved_bio_based_ios(void);

+static inline void dm_retain_bio_blkcg(struct bio *bio)
+{
+       if (!bio->bi_css)
+               bio_associate_current(bio);
+}
+
 #endif
