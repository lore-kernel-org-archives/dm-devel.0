From: Tejun Heo <htejun@gmail.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Sat, 02 Jun 2007 03:09:06 +0900
Message-ID: <466060C2.4060506@gmail.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm>            <465FC7B1.3060309@gmail.com> <10553.1180717627@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10553.1180717627@turing-police.cc.vt.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, ric@emc.com
List-Id: dm-devel.ids

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 01 Jun 2007 16:16:01 +0900, Tejun Heo said:
>> Don't those thingies usually have NV cache or backed by battery such
>> that ORDERED_DRAIN is enough?
> 
> Probably *most* do, but do you really want to bet the user's data on it?

Thought we were talking about high-end storage stuff.  I don't think
I'll be too uncomfortable.  The reason why we're talking about this at
all is because high-end stuff with fancy NV cache and a hunk of battery
will unnecessarily suffer from the current barrier implementation.

>> The problem is that the interface between the host and a storage device
>> (ATA or SCSI) is not built to communicate that kind of information
>> (grouped flush, relaxed ordering...).  I think battery backed
>> ORDERED_DRAIN combined with fine-grained host queue flush would be
>> pretty good.  It doesn't require some fancy new interface which isn't
>> gonna be used widely anyway and can achieve most of performance gain if
>> the storage plays it smart.
> 
> Yes, that would probably be "pretty good".  But how do you get the storage
> device to *reliably* tell the truth about what it actually implements? (Consider
> the number of devices that downright lie about their implementation of cache
> flushing....)

SCSI NV bit or report write through cache?  Again, we're talking about
large arrays and we already trust the write through thing even on cheap
single spindle drives.  sd currently doesn't honor NV bit and it's
causing some troubles on some arrays.  We'll probably have to honor them
at least conditionally.

-- 
tejun
