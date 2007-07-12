From: Ric Wheeler <ric@emc.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Thu, 12 Jul 2007 15:43:10 -0400
Message-ID: <4696844E.5060407@emc.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm> <465FC7B1.3060309@gmail.com> <4693D26D.2060004@emc.com> <4758.1184110800@turing-police.cc.vt.edu>            <46955D45.8010606@emc.com> <7718.1184261676@turing-police.cc.vt.edu>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7718.1184261676@turing-police.cc.vt.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <htejun@gmail.com>, david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids



Valdis.Kletnieks@vt.edu wrote:
> On Wed, 11 Jul 2007 18:44:21 EDT, Ric Wheeler said:
>> Valdis.Kletnieks@vt.edu wrote:
>>> On Tue, 10 Jul 2007 14:39:41 EDT, Ric Wheeler said:
>>>
>>>> All of the high end arrays have non-volatile cache (read, on power loss, it is a 
>>>> promise that it will get all of your data out to permanent storage). You don't 
>>>> need to ask this kind of array to drain the cache. In fact, it might just ignore 
>>>> you if you send it that kind of request ;-)
>>> OK, I'll bite - how does the kernel know whether the other end of that
>>> fiberchannel cable is attached to a DMX-3 or to some no-name product that
>>> may not have the same assurances?  Is there a "I'm a high-end array" bit
>>> in the sense data that I'm unaware of?
>>>
>> There are ways to query devices (think of hdparm -I in S-ATA/P-ATA drives, SCSI 
>> has similar queries) to see what kind of device you are talking to. I am not
>> sure it is worth the trouble to do any automatic detection/handling of this.
>>
>> In this specific case, it is more a case of when you attach a high end (or 
>> mid-tier) device to a server, you should configure it without barriers for its
>> exported LUNs.
> 
> I don't have a problem with the sysadmin *telling* the system "the other end of
> that fiber cable has characteristics X, Y and Z".  What worried me was that it
> looked like conflating "device reported writeback cache" with "device actually
> has enough battery/hamster/whatever backup to flush everything on a power loss".
> (My back-of-envelope calculation shows for a worst-case of needing a 1ms seek
> for each 4K block, a 1G cache can take up to 4 1/2 minutes to sync.  That's
> a lot of battery..)

I think that we are on the same page here - just let the sys admin mount without 
barriers for big arrays.

1GB of cache, by the way, is really small for some of us ;-)

ric

