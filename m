From: Tejun Heo <htejun@gmail.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Wed, 11 Jul 2007 11:51:40 +0900
Message-ID: <469445BC.1010709@gmail.com>
References: <18006.38689.818186.221707@notabene.brown>  <18010.12472.209452.148229@notabene.brown>  <20070528094358.GM25091@agk.fab.redhat.com>  <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>  <20070529220500.GA6513@agk.fab.redhat.com>  <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>  <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm> <465FC7B1.3060309@gmail.com> <4693D26D.2060004@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4693D26D.2060004@emc.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: ric@emc.com
Cc: david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Ric Wheeler wrote:
>> Don't those thingies usually have NV cache or backed by battery such
>> that ORDERED_DRAIN is enough?
> 
> All of the high end arrays have non-volatile cache (read, on power loss,
> it is a promise that it will get all of your data out to permanent
> storage). You don't need to ask this kind of array to drain the cache.
> In fact, it might just ignore you if you send it that kind of request ;-)
> 
> The size of the NV cache can run from a few gigabytes up to hundreds of
> gigabytes, so you really don't want to invoke cache flushes here if you
> can avoid it.
> 
> For this class of device, you can get the required in order completion
> and data integrity semantics as long as we send the IO's to the device
> in the correct order.

Thanks for clarification.

>> The problem is that the interface between the host and a storage device
>> (ATA or SCSI) is not built to communicate that kind of information
>> (grouped flush, relaxed ordering...).  I think battery backed
>> ORDERED_DRAIN combined with fine-grained host queue flush would be
>> pretty good.  It doesn't require some fancy new interface which isn't
>> gonna be used widely anyway and can achieve most of performance gain if
>> the storage plays it smart.
> 
> I am not really sure that you need this ORDERED_DRAIN for big arrays...

ORDERED_DRAIN is to properly order requests from host request queue
(elevator/iosched).  We can make it finer-grained but we do need to put
some ordering restrictions.

-- 
tejun
