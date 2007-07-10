From: Ric Wheeler <ric@emc.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Tue, 10 Jul 2007 14:39:41 -0400
Message-ID: <4693D26D.2060004@emc.com>
References: <18006.38689.818186.221707@notabene.brown>  <18010.12472.209452.148229@notabene.brown>  <20070528094358.GM25091@agk.fab.redhat.com>  <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>  <20070529220500.GA6513@agk.fab.redhat.com>  <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>  <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm> <465FC7B1.3060309@gmail.com>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <465FC7B1.3060309@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids



Tejun Heo wrote:
> [ cc'ing Ric Wheeler for storage array thingie.  Hi, whole thread is at
> http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/3344 ]

I am actually on the list, just really, really far behind in the thread ;-)

> 
> Hello,
> 
> david@lang.hm wrote:
>> but when you consider the self-contained disk arrays it's an entirely
>> different story. you can easily have a few gig of cache and a complete
>> OS pretending to be a single drive as far as you are concerned.
>>
>> and the price of such devices is plummeting (in large part thanks to
>> Linux moving into this space), you can now readily buy a 10TB array for
>> $10k that looks like a single drive.
> 
> Don't those thingies usually have NV cache or backed by battery such
> that ORDERED_DRAIN is enough?

All of the high end arrays have non-volatile cache (read, on power loss, it is a 
promise that it will get all of your data out to permanent storage). You don't 
need to ask this kind of array to drain the cache. In fact, it might just ignore 
you if you send it that kind of request ;-)

The size of the NV cache can run from a few gigabytes up to hundreds of 
gigabytes, so you really don't want to invoke cache flushes here if you can 
avoid it.

For this class of device, you can get the required in order completion and data 
integrity semantics as long as we send the IO's to the device in the correct order.

> 
> The problem is that the interface between the host and a storage device
> (ATA or SCSI) is not built to communicate that kind of information
> (grouped flush, relaxed ordering...).  I think battery backed
> ORDERED_DRAIN combined with fine-grained host queue flush would be
> pretty good.  It doesn't require some fancy new interface which isn't
> gonna be used widely anyway and can achieve most of performance gain if
> the storage plays it smart.
> 
> Thanks.
> 

I am not really sure that you need this ORDERED_DRAIN for big arrays...

ric
