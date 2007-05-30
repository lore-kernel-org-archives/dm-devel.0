From: david@lang.hm
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Wed, 30 May 2007 09:52:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com>
	<465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com>
	<Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
	<20070530061723.GY85884050@sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070530061723.GY85884050@sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Wed, 30 May 2007, David Chinner wrote:

> On Tue, May 29, 2007 at 05:01:24PM -0700, david@lang.hm wrote:
>> On Wed, 30 May 2007, David Chinner wrote:
>>
>>> On Tue, May 29, 2007 at 04:03:43PM -0400, Phillip Susi wrote:
>>>> David Chinner wrote:
>>>>> The use of barriers in XFS assumes the commit write to be on stable
>>>>> storage before it returns.  One of the ordering guarantees that we
>>>>> need is that the transaction (commit write) is on disk before the
>>>>> metadata block containing the change in the transaction is written
>>>>> to disk and the current barrier behaviour gives us that.
>>>>
>>>> Barrier != synchronous write,
>>>
>>> Of course. FYI, XFS only issues barriers on *async* writes.
>>>
>>> But barrier semantics - as far as they've been described by everyone
>>> but you indicate that the barrier write is guaranteed to be on stable
>>> storage when it returns.
>>
>> this doesn't match what I have seen
>>
>> wtih barriers it's perfectly legal to have the following sequence of
>> events
>>
>> 1. app writes block 10 to OS
>> 2. app writes block 4 to OS
>> 3. app writes barrier to OS
>> 4. app writes block 5 to OS
>> 5. app writes block 20 to OS
>
> hmmmmm - applications can't issue barriers to the filesystem.
> However, if you consider the barrier to be an "fsync()" for example,
> then it's still the filesystem that is issuing the barrier and
> there's a block that needs to be written that is associated with
> that barrier (either an inode or a transaction commit) that needs to
> be on stable storage before the filesystem returns to userspace.
>
>> 6. OS writes block 4 to disk drive
>> 7. OS writes block 10 to disk drive
>> 8. OS writes barrier to disk drive
>> 9. OS writes block 5 to disk drive
>> 10. OS writes block 20 to disk drive
>
> Replace OS with filesystem, and combine 7+8 together - we don't have
> zero-length barriers and hence they are *always* associated with a
> write to a certain block on disk. i.e.:
>
> 1. FS writes block 4 to disk drive
> 2. FS writes block 10 to disk drive
> 3. FS writes *barrier* block X to disk drive
> 4. FS writes block 5 to disk drive
> 5. FS writes block 20 to disk drive
>
> The order that these are expected by the filesystem to hit stable
> storage are:
>
> 1. block 4 and 10 on stable storage in any order
> 2. barrier block X on stable storage
> 3. block 5 and 20 on stable storage in any order
>
> The point I'm trying to make is that in XFS,  block 5 and 20 cannot
> be allowed to hit the disk before the barrier block because they
> have strict order dependency on block X being stable before them,
> just like block X has strict order dependency that block 4 and 10
> must be stable before we start the barrier block write.
>
>> 11. disk drive writes block 10 to platter
>> 12. disk drive writes block 4 to platter
>> 13. disk drive writes block 20 to platter
>> 14. disk drive writes block 5 to platter
>
>> if the disk drive doesn't support barriers then step #8 becomes 'issue
>> flush' and steps 11 and 12 take place before step #9, 13, 14
>
> No, you need a flush on either side of the block X write to maintain
> the same semantics as barrier writes currently have.
>
> We have filesystems that require barriers to prevent reordering of
> writes in both directions and to ensure that the block associated
> with the barrier is on stable storage when I/o completion is
> signalled.  The existing barrier implementation (where it works)
> provide these requirements. We need barriers to retain these
> semantics, otherwise we'll still have to do special stuff in
> the filesystems to get the semantics that we need.

one of us is misunderstanding barriers here.

you are understanding barriers to be the same as syncronous writes. (and 
therefor the data is on persistant media before the call returns)

I am understanding barriers to only indicate ordering requirements. things 
before the barrier can be reordered freely, things after the barrier can 
be reordered freely, but things cannot be reordered across the barrier.

if I am understanding it correctly, the big win for barriers is that you 
do NOT have to stop and wait until the data is on persistant media before 
you can continue.

in the past barriers have not been fully implmented in most cases, and as 
a result they have been simulated by forcing a full flush of the buffers 
to persistant media before any other writes are allowed. This has made 
them _in practice_ operate the same way as syncronous writes (matching 
your understanding), but the current thread is talking about fixing the 
implementation to the official symantics for all hardware that can 
actually support barriers (and fix it at the OS level)

David Lang
