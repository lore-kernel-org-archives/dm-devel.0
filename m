From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v5 00/11] simplify block layer based on immutable biovecs
Date: Mon, 27 Jul 2015 15:11:30 -0700
Message-ID: <1438035090.28978.19.camel@ssi>
References: <1436166674-31362-1-git-send-email-mlin@kernel.org>
	 <1436764355.30675.10.camel@hasee> <20150713153537.GA30898@redhat.com>
	 <1437675702.11359.25.camel@ssi> <20150727175048.GA18183@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150727175048.GA18183@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Dongsu Park <dpark@posteo.net>, Kent Overstreet <kent.overstreet@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, 2015-07-27 at 13:50 -0400, Mike Snitzer wrote:
> On Thu, Jul 23 2015 at  2:21pm -0400,
> Ming Lin <mlin@kernel.org> wrote:
> 
> > On Mon, 2015-07-13 at 11:35 -0400, Mike Snitzer wrote:
> > > On Mon, Jul 13 2015 at  1:12am -0400,
> > > Ming Lin <mlin@kernel.org> wrote:
> > > 
> > > > On Mon, 2015-07-06 at 00:11 -0700, mlin@kernel.org wrote:
> > > > > Hi Mike,
> > > > > 
> > > > > On Wed, 2015-06-10 at 17:46 -0400, Mike Snitzer wrote:
> > > > > > I've been busy getting DM changes for the 4.2 merge window finalized.
> > > > > > As such I haven't connected with others on the team to discuss this
> > > > > > issue.
> > > > > > 
> > > > > > I'll see if we can make time in the next 2 days.  But I also have
> > > > > > RHEL-specific kernel deadlines I'm coming up against.
> > > > > > 
> > > > > > Seems late to be staging this extensive a change for 4.2... are you
> > > > > > pushing for this code to land in the 4.2 merge window?  Or do we have
> > > > > > time to work this further and target the 4.3 merge?
> > > > > > 
> > > > > 
> > > > > 4.2-rc1 was out.
> > > > > Would you have time to work together for 4.3 merge? 
> > > > 
> > > > Ping ...
> > > > 
> > > > What can I do to move forward?
> > > 
> > > You can show further testing.  Particularly that you've covered all the
> > > edge cases.
> > > 
> > > Until someone can produce some perf test results where they are actually
> > > properly controlling for the splitting, we have no useful information.
> > > 
> > > The primary concerns associated with this patchset are:
> > > 1) In the context of RAID, XFS's use of bio_add_page() used to build up
> > >    optimal IOs when the underlying block device provides striping info
> > >    via IO limits.  With this patchset how large will bios become in
> > >    practice _without_ bio_add_page() being bounded by the underlying IO
> > >    limits?
> > 
> > Totally new to XFS code.
> > Did you mean xfs_buf_ioapply_map() -> bio_add_page()?
> 
> Yes.  But there is also:
> xfs_vm_writepage -> xfs_submit_ioend -> xfs_bio_add_buffer -> bio_add_page
> 
> Basically in the old code XFS sized IO accordingly based on the
> bio_add_page feedback loop.
> 
> > The largest size could be BIO_MAX_PAGES pages, that is 256 pages(1M
> > bytes).
> 
> Independent of this late splitting work (but related): we really should
> look to fixup/extend BIO_MAX_PAGES to cover just barely "too large"
> configurations, e.g. 10+2 RAID6 with 128K chunk, so 1280K for a full
> stripe.  Ideally we'd be able to read/reite full stripes.
> 
> > > 2) The late splitting that occurs for the (presummably) large bios that
> > >    are sent down.. how does it cope/perform in the face of very
> > >    low/fragmented system memory?
> > 
> > I tested in qemu-kvm with 1G/1100M/1200M memory.
> > 10 HDDs were attached to qemu via virtio-blk.
> > Then created MD RAID6 array and mkfs.xfs on it.
> > 
> > I use bs=2M, so there will be a lot of bio splits.
> > 
> > [global]
> > ioengine=libaio
> > iodepth=64
> > direct=1
> > runtime=1200
> > time_based
> > group_reporting
> > numjobs=8
> > gtod_reduce=0
> > norandommap
> > 
> > [job1]
> > bs=2M
> > directory=/mnt
> > size=100M
> > rw=write
> > 
> > Here is the results:
> > 
> > memory		4.2-rc2		4.2-rc2-patched
> > ------		-------		---------------
> > 1G		OOM		OOM
> > 1100M		fail		OK
> > 1200M		OK		OK
> > 
> > "fail" means it hit a page allocation failure.
> > http://minggr.net/pub/block_patches_tests/dmesg.4.2.0-rc2
> > 
> > I tested 3 times for each kernel to confirm that with 1100M memory,
> > 4.2-rc2 always hit a page allocation failure and 4.2-rc2-patched is OK.
> > 
> > So the patched kernel performs better in this case.
> 
> Interesting.  Seems to prove Kent's broader point that he used mempools
> and handles allocations better than the old code did.
> 
> > > 3) More open-ended comment than question: Linux has evolved to perform
> > >    well on "enterprise" systems.  We generally don't fall off a cliff on 
> > >    performance like we used to.  The concern associated with this
> > >    patchset is that if it goes in without _real_ due-diligence on
> > >    "enterprise" scale systems and workloads it'll be too late once we
> > >    notice the problem(s).
> > > 
> > > So we really need answers to 1 and 2 above in order to feel better about
> > > the risks associated 3.
> > > 
> > > Alasdair's feedback to you on testing still applies (and hasn't been
> > > done AFAIK):
> > > https://www.redhat.com/archives/dm-devel/2015-May/msg00203.html
> > > 
> > > Particularly:
> > > "you might need to instrument the kernels to tell you the sizes of the
> > > bios being created and the amount of splitting actually happening."
> > 
> > I added a debug patch to record the amount of splitting actually
> > happened. https://goo.gl/Iiyg4Y
> > 
> > In the qemu 1200M memory test case,
> > 
> > $ cat /sys/block/md0/queue/split
> > discard split: 0, write same split: 0, segment split: 27400
> > 
> > > 
> > > and
> > > 
> > > "You may also want to test systems with a restricted amount of available
> > > memory to show how the splitting via worker thread performs.  (Again,
> > > instrument to prove the extent to which the new code is being exercised.)"
> > 
> > Does above test with qemu make sense?
> 
> The test is showing that systems with limited memory are performing
> better but, without looking at the patchset in detail, I'm not sure what
> your splitting accounting patch is showing.
> 
> Are you saying that:
> 1) the code only splits via worker threads
> 2) with 27400 splits in the 1200M case the splitting certainly isn't
>    making things any worse.

With this patchset, bio_add_page() always create as large as possible
bio(1M bytes max). The patch accounts how many times the bio was split
due to device limitation, for example, bio->bi_phys_segments >
queue_max_segments(q).

It's more interesting if we look at how many bios are allocated for each
application IO request.

e.g. 10+2 RAID6 with 128K chunk.

Assume we only consider device max_segments limitation.

# cat /sys/block/md0/queue/max_segments 
126

So blk_queue_split() will split the bio if its size > 126 pages(504K
bytes).

Let's do a 1280K request.

# dd if=/dev/zero of=/dev/md0 bs=1280k count=1 oflag=direct

With below debug patch,

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a4aa6e5..2fde2ce 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -259,6 +259,10 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 
 	blk_queue_split(q, &bio, q->bio_split);
 
+	if (!strcmp(current->comm, "dd") && bio_data_dir(bio) == WRITE)
+		printk("%s: bio %p, offset %lu, size %uK\n", __func__,
+			bio, bio->bi_iter.bi_sector<<9, bio->bi_iter.bi_size>>10);
+
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
 		bio_io_error(bio);

For non-patched kernel, 10 bios were allocated.

[   11.921775] md_make_request: bio ffff8800469c5d00, offset 0, size 128K
[   11.945692] md_make_request: bio ffff8800471df700, offset 131072, size 128K
[   11.946596] md_make_request: bio ffff8800471df200, offset 262144, size 128K
[   11.947694] md_make_request: bio ffff8800471df300, offset 393216, size 128K
[   11.949421] md_make_request: bio ffff8800471df900, offset 524288, size 128K
[   11.956345] md_make_request: bio ffff8800471df000, offset 655360, size 128K
[   11.957586] md_make_request: bio ffff8800471dfb00, offset 786432, size 128K
[   11.959086] md_make_request: bio ffff8800471dfc00, offset 917504, size 128K
[   11.964221] md_make_request: bio ffff8800471df400, offset 1048576, size 128K
[   11.965117] md_make_request: bio ffff8800471df800, offset 1179648, size 128K

For patched kernel, only 2 bios were allocated at base case and 0 split.

[   20.034036] md_make_request: bio ffff880046a2ee00, offset 0, size 1024K
[   20.046104] md_make_request: bio ffff880046a2e500, offset 1048576, size 256K

4 bios allocated for worst case and 2 splits.
One of the worst case could be the memory is so segmented that 1M bio comprised
of 256 bi_phys_segments. So it needs 2 splits.

1280K = 1M + 256K

ffff880046a30900 and ffff880046a21500 are the original bios.
ffff880046a30200 and ffff880046a21e00 are the split bios.

[   13.049323] md_make_request: bio ffff880046a30200, offset 0, size 504K
[   13.080057] md_make_request: bio ffff880046a21e00, offset 516096, size 504K
[   13.082857] md_make_request: bio ffff880046a30900, offset 1032192, size 16K
[   13.084983] md_make_request: bio ffff880046a21500, offset 1048576, size 256K

# cat /sys/block/md0/queue/split 
discard split: 0, write same split: 0, segment split: 2

> 
> But for me the bigger take away is: the old merge_bvec code (no late
> splitting) is more prone to allocation failure then the new code.

Yes, as I showed above.

> 
> On that point alone I'm OK with this patchset going forward.
> 
> I'll reviewer the implementation details as they relate to DM now, but
> that is just a formality.  My hope is that I'll be abke to provide my
> Acked-by very soon.

Great! Thanks.

> 
> Mike
