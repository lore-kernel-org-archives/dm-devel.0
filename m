From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
  filesystems, and dm/md.
Date: Fri, 01 Jun 2007 20:04:19 -0400
Message-ID: <4660B403.3000202@tmr.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <465DAA15.3070703@cfl.rr.com> <465DDE1D.3000809@cfl.rr.com> <20070531062404.GH32105@kernel.dk> <465F15ED.1070304@cfl.rr.com> <20070531185836.GC32105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070531185836.GC32105@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, device-mapper development <dm-devel@redhat.com>, David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>, Stefan Bader <Stefan.Bader@de.ibm.com>
List-Id: dm-devel.ids

Jens Axboe wrote:
> On Thu, May 31 2007, Phillip Susi wrote:
>   
>> Jens Axboe wrote:
>>     
>>> No Stephan is right, the barrier is both an ordering and integrity
>>> constraint. If a driver completes a barrier request before that request
>>> and previously submitted requests are on STABLE storage, then it
>>> violates that principle. Look at the code and the various ordering
>>> options.
>>>       
>> I am saying that is the wrong thing to do.  Barrier should be about 
>> ordering only.  So long as the order they hit the media is maintained, 
>> the order the requests are completed in can change.  barrier.txt bears 
>>     
>
> But you can't guarentee ordering without flushing the data out as well.
> It all depends on the type of cache on the device, of course. If you
> look at the ordinary sata/ide drive with write back caching, you can't
> just issue the requests in order and pray that the drive cache will make
> it to platter.
>
> If you don't have write back caching, or if the cache is battery backed
> and thus guarenteed to never be lost, maintaining order is naturally
> enough.
>   

Do I misread this? If ordered doesn't reach all the way to the platter 
then there will be failure modes which result in order not preserved. 
Battery backed cache doesn't prevect failures between the cache and the 
platter.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

