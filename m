From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Fri, 01 Jun 2007 12:16:01 +0900
Message-ID: <465F8F71.20302@gmail.com>
References: <18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com>
	<20070529234832.GT85884050@sgi.com>
	<Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
	<20070530061723.GY85884050@sgi.com>
	<Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
	<20070531002011.GC85884050@sgi.com>
	<20070531062644.GI32105@kernel.dk>
	<20070531070307.GK85884050@sgi.com>
	<20070531070656.GK32105@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070531070656.GK32105@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: david@lang.hm, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Jens Axboe wrote:
> On Thu, May 31 2007, David Chinner wrote:
>> On Thu, May 31, 2007 at 08:26:45AM +0200, Jens Axboe wrote:
>>> On Thu, May 31 2007, David Chinner wrote:
>>>> IOWs, there are two parts to the problem:
>>>>
>>>> 	1 - guaranteeing I/O ordering
>>>> 	2 - guaranteeing blocks are on persistent storage.
>>>>
>>>> Right now, a single barrier I/O is used to provide both of these
>>>> guarantees. In most cases, all we really need to provide is 1); the
>>>> need for 2) is a much rarer condition but still needs to be
>>>> provided.
>>>>
>>>>> if I am understanding it correctly, the big win for barriers is that you 
>>>>> do NOT have to stop and wait until the data is on persistant media before 
>>>>> you can continue.
>>>> Yes, if we define a barrier to only guarantee 1), then yes this
>>>> would be a big win (esp. for XFS). But that requires all filesystems
>>>> to handle sync writes differently, and sync_blockdev() needs to
>>>> call blkdev_issue_flush() as well....
>>>>
>>>> So, what do we do here? Do we define a barrier I/O to only provide
>>>> ordering, or do we define it to also provide persistent storage
>>>> writeback? Whatever we decide, it needs to be documented....
>>> The block layer already has a notion of the two types of barriers, with
>>> a very small amount of tweaking we could expose that. There's absolutely
>>> zero reason we can't easily support both types of barriers.
>> That sounds like a good idea - we can leave the existing
>> WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
>> behaviour that only guarantees ordering. The filesystem can then
>> choose which to use where appropriate....
> 
> Precisely. The current definition of barriers are what Chris and I came
> up with many years ago, when solving the problem for reiserfs
> originally. It is by no means the only feasible approach.
> 
> I'll add a WRITE_ORDERED command to the #barrier branch, it already
> contains the empty-bio barrier support I posted yesterday (well a
> slightly modified and cleaned up version).

Would that be very different from issuing barrier and not waiting for
its completion?  For ATA and SCSI, we'll have to flush write back cache
anyway, so I don't see how we can get performance advantage by
implementing separate WRITE_ORDERED.  I think zero-length barrier
(haven't looked at the code yet, still recovering from jet lag :-) can
serve as genuine barrier without the extra write tho.

Thanks.

-- 
tejun
