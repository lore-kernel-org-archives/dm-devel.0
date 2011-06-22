From: Krzysztof =?UTF-8?Q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: newbie question regarding target_type's map callback
Date: Wed, 22 Jun 2011 15:09:52 +0200
Message-ID: <1308748192.23392.720.camel@linux-zhyd.site>
References: <1308412649.23392.621.camel@linux-zhyd.site>
	<20110619014806.GI19996@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110619014806.GI19996@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello again,

On Sun, 2011-06-19 at 02:48 +0100, Alasdair G Kergon wrote:
> All I can suggest is studying the existing upstream targets to
> understand better how they work and perhaps avoid problems like the ones
> you are seeing.


I would like rather to discuss operation principles than study code like
e.g.: dm-raid1, dm-hash-region, dm-log and dm (although i've done it a
bit and not everything is clear to me)

Regarding ordering i found this:
http://markmail.org/message/qa7weh3gdorqw7p4#query:+page:1
+mid:djfewqc645ldatf2+state:results 

There was one note i reckon is important to me:
"
Ordering is certainly maintained for the simple targets (linear,
striped). Snapshots and mirroring still need some work in this
regard, ..
"

And how does this look like nowadays ?

According to dm-raid1 example i changed my model of target. And now map
function adds bios to bio list which is drained later in worker thread
in order bios appeared in map. In this worker i do update block
bookkeeping table - set e.g. first bio and queue more bios for same
block lba.

I reckon this map queue may be more safe than updating bookkeeping table
directly in map because worker uses a list where bios order is
predefined and doesn't depend on e.g. map preemption.

The bookkeeping table is updated again in dm's end_io callback where, i
reckon, bio is considered to be done. I do not use dm_io() callback for
updating bookkeeping table, only bio_endio() is used there to complete
bio sent to map function.

I was thinking about following problem:
let's suppose there are e.g. 3 scsi requests, simple queue (e.g.
write10, read10, write10), they arrived in time:
Rq1 which dm will divide into blocks {A1, B1, C1, D1},
Rq2 : {B2, C2}, and Rq3 of {A3-F3},

index next to Rq stands for order in time. Lower index means earlier
request. Same letter stands for a block with the same block lba.

My concern is: if these blocks A1, B1, C1, .., B2, A3, .. F3 will arrive
in correct order in map function ? Is map function serialized by some
means inside dm ? (can map preemption change order of seeing these block
by dm target ?)

And is following thesis safe ? (that's very important) :
#1. it is always true that data corruption due to wrong reordering will
not happen if dm target will preserve time order of blocks (of the same
lba) passed back to dm_io always. e.g. {B1, B2, B3} or {C1, C2, C3} and
e.g. {B2, B1, B3} is example of dm target failure.

the above stands for that real sequence of passing back these blocks to
dm_io may look like this: A1, B1, C1, B2, C2, C3, B3, A3 ... or e.g. A1,
D1, B1, B2, B3, D2, A3 or any other similar.

What will be order of completing Rq1, Rq2, Rq3 for any possible
combination of block processing with exception according to thesis #1



> 
> What is your target trying to do?
> (Why is split_io important?  Did you implement a merge fn?)
> 

dm-raid1 doesn't use merge fn (neither me).


> Alasdair
> 

Regards,

-- 
Krzysztof Blaszkowski
