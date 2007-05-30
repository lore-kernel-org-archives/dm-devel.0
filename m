From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Wed, 30 May 2007 12:45:09 -0400
Message-ID: <465DAA15.3070703@cfl.rr.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070529234832.GT85884050@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

David Chinner wrote:
>> Barrier != synchronous write,
> 
> Of course. FYI, XFS only issues barriers on *async* writes.
> 
> But barrier semantics - as far as they've been described by everyone
> but you indicate that the barrier write is guaranteed to be on stable
> storage when it returns.

Hrm... I may have misunderstood the perspective you were talking from. 
Yes, when the bio is completed it must be on the media, but the 
filesystem should issue both requests, and then really not care when 
they complete.  That is to say, the filesystem should not wait for block 
A to finish before issuing block B; it should issue both, and use 
barriers to make sure they hit the disk in the correct order.

> XFS relies on the block being stable before any other write
> goes to disk. That is the semantic that the barrier I/Os currently
> have. How that is implemented in the device is irrelevant to me,
> but if I issue a barrier I/O, I do not expect *any* I/O to be
> reordered around it.

Right... it just needs to control the order of the requests, just not 
wait on one to finish before issuing the next.


