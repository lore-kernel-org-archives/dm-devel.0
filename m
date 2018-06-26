From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-thin metadata operation failed due to -ENOSPC
 returned by dm_pool_alloc_data_block() after processing DISCARD bios
Date: Tue, 26 Jun 2018 16:26:11 -0400
Message-ID: <20180626202611.GA7525@redhat.com>
References: <CAAR726JcYQpSSXAhL6=yPmzT0MOZRG_WwjC63q0QSMzT5qNPSg@mail.gmail.com>
	<20180626200155.GA7427@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180626200155.GA7427@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>
Cc: ejt@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 26 2018 at  4:01pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Apr 03 2018 at 12:07am -0400,
> Dennis Yang <dennisyang@qnap.com> wrote:
> 
> > Hi,
> > 
> > Recently we have came across an issue that dm-thin pool will be
> > switched to READ_ONLY mode because dm_pool_alloc_data_block() returns
> > -ENOSPC. AFAIK, this should not happen since alloc_data_block() will
> > check if there is any free space (and commit metadata if it first
> > reports no free space) before it allocates pool block. In addition,
> > total virtual space of all thin volumes is smaller than the pool
> > physical space in my testing environment which makes pool impossible
> > to run out of space.
> > 
> > This issue could be easily reproduced by the following steps.
> > 
> > 1) Create a thin pool and a slightly smaller thin volume
> > > sudo dmsetup create meta --table "0 40000000 linear /dev/sdf 0"
> > > sudo dmsetup create data --table "0 10240000 linear /dev/md125 0"
> > > sudo dd if=/dev/zero of=/dev/mapper/meta bs=1M count=1
> > > sudo dmsetup create pool --table "0 10240000 thin-pool /dev/mapper/meta /dev/mapper/data 1024 0 2 skip_block_zeroing error_if_no_space"
> > > sudo dmsetup message pool 0 "create_thin 0"
> > > sudo dmsetup create thin --table "0 10238976 thin /dev/mapper/pool 0"
> > 
> > 2) Make a filesystem and mount it
> > > sudo mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 /dev/mapper/thin
> > > sudo mount /dev/mapper/thin /mnt
> > 
> > 3) Write a file to mount point until it takes all the space
> > > sudo dd if=/dev/zero of=/mnt/zero.img bs=1M
> > 
> > 4) Remove this file and trim mount point
> > > sudo rm /mnt/zero.img
> > > sudo fstrim /mnt
> > 
> > Repeat step 3 and 4 multiple times and the pool will be switched to
> > READ_ONLY mode and need_checks flag will be set. Kernel message shows
> > the following messages.
> > [ 3952.723937] device-mapper: thin: 252:2: metadata operation
> > 'dm_pool_alloc_data_block' failed: error = -28
> > [ 3952.723940] device-mapper: thin: 252:2: aborting current metadata transaction
> > [ 3952.725860] device-mapper: thin: 252:2: switching pool to read-only mode
> > 
> > This root cause of this issue is that dm-thin will first remove
> > mapping and increase corresponding blocks' reference count to prevent
> > them from being reused before DISCARD bios get processed by the
> > underlying layers. However. increasing blocks' reference count could
> > also increase the nr_allocated_this_transaction in struct sm_disk
> > which makes smd->old_ll.nr_allocated +
> > smd->nr_allocated_this_transaction bigger than smd->old_ll.nr_blocks.
> > In this case, alloc_data_block() will never commit metadata to reset
> > the begin pointer of struct sm_disk, because sm_disk_get_nr_free()
> > always return an underflow value.
> > 
> > If you need more information, please feel free to let me know.
> 
> FYI, I just staged the following fix:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=2b21877316f3a517554c1b34e6b32f4d1ad10493

(following output is with a debugging patch to print process_discard_bio
extents)

Using the test in the report, with the referenced patch applied, without
waiting for fstrim to complete:

[  734.449585] device-mapper: thin: process_discard_bio: begin=0 end=319
[  734.474426] XFS (dm-6): Mounting V5 Filesystem
[  734.481787] XFS (dm-6): Ending clean mount
[  734.577167] device-mapper: thin: process_discard_bio: begin=50 end=319
[  734.587850] device-mapper: thin: 253:4: switching pool to out-of-data-space (queue IO) mode
[  736.484991] device-mapper: thin: 253:4: switching pool to write mode
[  737.586929] device-mapper: thin: process_discard_bio: begin=50 end=319
[  737.597587] device-mapper: thin: 253:4: switching pool to out-of-data-space (queue IO) mode
[  739.560326] device-mapper: thin: 253:4: switching pool to write mode
[  740.651914] device-mapper: thin: process_discard_bio: begin=50 end=319
[  740.662223] device-mapper: thin: 253:4: switching pool to out-of-data-space (queue IO) mode
[  742.628723] device-mapper: thin: 253:4: switching pool to write mode
[  743.727873] device-mapper: thin: process_discard_bio: begin=50 end=319
[  743.738578] device-mapper: thin: 253:4: switching pool to out-of-data-space (queue IO) mode
[  745.700557] device-mapper: thin: 253:4: switching pool to write mode
[  746.799316] device-mapper: thin: process_discard_bio: begin=50 end=319
[  746.809928] device-mapper: thin: 253:4: switching pool to out-of-data-space (queue IO) mode
[  748.772334] device-mapper: thin: 253:4: switching pool to write mode
[  749.876049] device-mapper: thin: process_discard_bio: begin=50 end=319
[  749.916739] XFS (dm-6): Unmounting Filesystem

with sleep after fstrim:

[ 1462.939299] device-mapper: thin: process_discard_bio: begin=0 end=319
[ 1462.968260] XFS (dm-6): Mounting V5 Filesystem
[ 1462.976490] XFS (dm-6): Ending clean mount
[ 1463.074625] device-mapper: thin: process_discard_bio: begin=50 end=319
[ 1468.177317] device-mapper: thin: process_discard_bio: begin=50 end=319
[ 1473.271058] device-mapper: thin: process_discard_bio: begin=50 end=319
[ 1478.364355] device-mapper: thin: process_discard_bio: begin=50 end=319
[ 1483.456330] device-mapper: thin: process_discard_bio: begin=50 end=319
[ 1488.553290] device-mapper: thin: process_discard_bio: begin=50 end=319
[ 1493.593228] XFS (dm-6): Unmounting Filesystem
