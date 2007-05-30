From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Wed, 30 May 2007 16:27:09 -0400
Message-ID: <465DDE1D.3000809@cfl.rr.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <465DAA15.3070703@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <465DAA15.3070703@cfl.rr.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>, Stefan Bader <Stefan.Bader@de.ibm.com>
List-Id: dm-devel.ids

Phillip Susi wrote:
> Hrm... I may have misunderstood the perspective you were talking from. 
> Yes, when the bio is completed it must be on the media, but the 
> filesystem should issue both requests, and then really not care when 
> they complete.  That is to say, the filesystem should not wait for block 
> A to finish before issuing block B; it should issue both, and use 
> barriers to make sure they hit the disk in the correct order.

Actually now that I think about it, that wasn't correct.  The request 
CAN be completed before the data has hit the medium.  The barrier just 
constrains the ordering of the writes, but they can still sit in the 
disk write back cache for some time.

Stefan Bader wrote:
> That would be the exactly how I understand Documentation/block/barrier.txt:
> 
> "In other words, I/O barrier requests have the following two properties.
> 1. Request ordering
> ...
> 2. Forced flushing to physical medium"
> 
> "So, I/O barriers need to guarantee that requests actually get written
> to non-volatile medium in order." 

I think you misinterpret this, and it probably could be worded a bit 
better.  The barrier request is about constraining the order.  The 
forced flushing is one means to implement that constraint.  The other 
alternative mentioned there is to use ordered tags.  The key part there 
is "requests actually get written to non-volatile medium _in order_", 
not "before the request completes", which would be synchronous IO.

