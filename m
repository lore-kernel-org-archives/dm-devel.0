From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: BIO_RW_SYNCIO
Date: Tue, 27 Jul 2010 19:09:50 -0400
Message-ID: <20100727230950.GI7347@redhat.com>
References: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
	<20090417063615.GE4593@kernel.dk>
	<Pine.LNX.4.64.0904200220290.22707@hs20-bc2-1.build.redhat.com>
	<20090421072903.GY4593@kernel.dk>
	<Pine.LNX.4.64.1007261747560.12939@hs20-bc2-1.build.redhat.com>
	<20100727020919.GC18940@redhat.com>
	<Pine.LNX.4.64.1007271452180.1954@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007271452180.1954@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 27, 2010 at 03:48:52PM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 26 Jul 2010, Vivek Goyal wrote:
> 
> > On Mon, Jul 26, 2010 at 05:53:40PM -0400, Mikulas Patocka wrote:
> > > Hi Jens
> > > 
> > [ Jens's mail id has changed. Ccing him on different mail id ]
> > 
> > > I found out that when I remove BIO_RW_SYNCIO from dm-kcopyd.c, performance 
> > > when writing to the snapshot origin is increased twice. In this workload, 
> > > snapshot driver reads a lot of 8k chunks from one place on the disk and 
> > > writes them to the other place on the same disk. Without BIO_RW_SYNCIO, it 
> > > is twice faster with CFQ scheduler.
> > > 
> > > What does BIO_RW_SYNCIO exactly do?  Does it attempt to decrease latency 
> > > and decrease throughput? (so that disk head seeks more between the source 
> > > and destination and it causes performance degradation) Is there some 
> > > general guidance, when use BIO_RW_SYNCIO and when not?
> > 
> > BIO_RW_SYNC marks a request as SYNC. reads are by default sync. Writes
> > can be marked as SYNC so that they get priority of ASYNC WRITES.
> > 
> > Marking writes as SYNC has advantage that it gets its own queue, it can
> > preempt ASYNC WRITES and CFQ also idles on the cfq queue waiting for
> > more requests.
> > 
> > I suspect if it is idling on SYNC WRITES which is a problem here.
> > 
> > - Is it the same thread which is submitting both read and write requests?
> 
> Yes.
> 
> > - Are you interleaving reads and writes. Like reading some data, then
> >   writting it and reading again...
> 
> I issue write immediatelly when read finishes.
> 
> > I guess after writting some data, CFQ is idling on WRITE_SYNC and next
> > READ does not get dispatched immediately to the disk.
> > 
> > Is it possible to provide some 30 second blktrace of the underlying device
> > where CFQ is running. You can also try setting slice_idle to 0 and see if
> > it helps.
> > 
> > If setting slice_idle=0 helps you, can you please also give a try to
> > following patch.
> > 
> > https://patchwork.kernel.org/patch/113061/
> > 
> > Thanks
> > Vivek
> 
> I took the traces and placed them at 
> http://people.redhat.com/mpatocka/data/blktrace/
> 
> It shows that WRITE requests are merged without SYNCIO flags and are not 
> merged if SYNCIO is used.

Yes you are right. So I think following is happening.

Key is that requests don't get merged once they are on dispatch list. They
get merged only when they are still sitting in some cfq queue and are with
elevator.

In case of sync IO, both reads and writes are on single cfq queue. We are
driving good dispatch list depth (drv=65). That means there are 65 reads
and writes on dispatch list and none of the new requests can be merged with
those.

In case of async IO, reads and writes are going on different cfq queues.
While reads are being dispatched from one queue, writes are sitting in 
CFQ and are open to merge. That's the reason we are seeing lot more WRITE
merging with async case.

Not sure what we can do about it though. But had a couple of questions.

- You seem to be issuing lots of 4K size adjacent READS and WRITES. Is
  there a way that you can club these together and issue a bigger request.

- What kind of device this is where request queue depth is 65. Can you
  try reducing request queue depth to say 16 and see if things improve
  a bit. (/sys/block/<dev>/device/queue_depth).

> 
> slice_idle=0 or the patch don't help.

So it is a case of single cfq queue, so slice_idle will not help.

Thanks
Vivek
