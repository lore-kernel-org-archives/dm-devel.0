From: david@lang.hm
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Tue, 29 May 2007 17:01:24 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
References: <18006.38689.818186.221707@notabene.brown>
 <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com>
 <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070529234832.GT85884050@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Wed, 30 May 2007, David Chinner wrote:

> On Tue, May 29, 2007 at 04:03:43PM -0400, Phillip Susi wrote:
>> David Chinner wrote:
>>> The use of barriers in XFS assumes the commit write to be on stable
>>> storage before it returns.  One of the ordering guarantees that we
>>> need is that the transaction (commit write) is on disk before the
>>> metadata block containing the change in the transaction is written
>>> to disk and the current barrier behaviour gives us that.
>>
>> Barrier != synchronous write,
>
> Of course. FYI, XFS only issues barriers on *async* writes.
>
> But barrier semantics - as far as they've been described by everyone
> but you indicate that the barrier write is guaranteed to be on stable
> storage when it returns.

this doesn't match what I have seen

wtih barriers it's perfectly legal to have the following sequence of 
events

1. app writes block 10 to OS
2. app writes block 4 to OS
3. app writes barrier to OS
4. app writes block 5 to OS
5. app writes block 20 to OS
6. OS writes block 4 to disk drive
7. OS writes block 10 to disk drive
8. OS writes barrier to disk drive
9. OS writes block 5 to disk drive
10. OS writes block 20 to disk drive
11. disk drive writes block 10 to platter
12. disk drive writes block 4 to platter
13. disk drive writes block 20 to platter
14. disk drive writes block 5 to platter

there is nothing that says that when the app finishes step #3 that the OS 
has even sent the data to the drive, let alone that the drive has flushed 
it to a platter

if the disk drive doesn't support barriers then step #8 becomes 'issue 
flush' and steps 11 and 12 take place before step #9, 13, 14

David Lang
