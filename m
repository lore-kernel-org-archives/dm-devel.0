From: Ric Wheeler <ric@emc.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Fri, 13 Jul 2007 07:30:09 -0400
Message-ID: <46976241.6040800@emc.com>
References: <200707122310.l6CNAoo08224@www.watkins-home.com>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707122310.l6CNAoo08224@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: Valdis.Kletnieks@vt.edu, 'Tejun Heo' <htejun@gmail.com>, david@lang.hm, 'Stefan Bader' <Stefan.Bader@de.ibm.com>, 'Phillip Susi' <psusi@cfl.rr.com>, 'device-mapper development' <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 'Jens Axboe' <jens.axboe@oracle.com>, 'David Chinner' <dgc@sgi.com>, 'Andreas Dilger' <adilger@clusterfs.com>
List-Id: dm-devel.ids



Guy Watkins wrote:
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Valdis.Kletnieks@vt.edu
> } Sent: Thursday, July 12, 2007 1:35 PM
> } To: ric@emc.com
> } Cc: Tejun Heo; david@lang.hm; Stefan Bader; Phillip Susi; device-mapper
> } development; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> } linux-raid@vger.kernel.org; Jens Axboe; David Chinner; Andreas Dilger
> } Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for
> } devices, filesystems, and dm/md.
> } 
> } On Wed, 11 Jul 2007 18:44:21 EDT, Ric Wheeler said:
> } > Valdis.Kletnieks@vt.edu wrote:
> } > > On Tue, 10 Jul 2007 14:39:41 EDT, Ric Wheeler said:
> } > >
> } > >> All of the high end arrays have non-volatile cache (read, on power
> } loss, it is a
> } > >> promise that it will get all of your data out to permanent storage).
> } You don't
> } > >> need to ask this kind of array to drain the cache. In fact, it might
> } just ignore
> } > >> you if you send it that kind of request ;-)
> } > >
> } > > OK, I'll bite - how does the kernel know whether the other end of that
> } > > fiberchannel cable is attached to a DMX-3 or to some no-name product
> } that
> } > > may not have the same assurances?  Is there a "I'm a high-end array"
> } bit
> } > > in the sense data that I'm unaware of?
> } > >
> } >
> } > There are ways to query devices (think of hdparm -I in S-ATA/P-ATA
> } drives, SCSI
> } > has similar queries) to see what kind of device you are talking to. I am
> } not
> } > sure it is worth the trouble to do any automatic detection/handling of
> } this.
> } >
> } > In this specific case, it is more a case of when you attach a high end
> } (or
> } > mid-tier) device to a server, you should configure it without barriers
> } for its
> } > exported LUNs.
> } 
> } I don't have a problem with the sysadmin *telling* the system "the other
> } end of
> } that fiber cable has characteristics X, Y and Z".  What worried me was
> } that it
> } looked like conflating "device reported writeback cache" with "device
> } actually
> } has enough battery/hamster/whatever backup to flush everything on a power
> } loss".
> } (My back-of-envelope calculation shows for a worst-case of needing a 1ms
> } seek
> } for each 4K block, a 1G cache can take up to 4 1/2 minutes to sync.
> } That's
> } a lot of battery..)
> 
> Most hardware RAID devices I know of use the battery to save the cache while
> the power is off.  When the power is restored it flushes the cache to disk.
> If the power failure lasts longer than the batteries then the cache data is
> lost, but the batteries last 24+ hours I beleve.

Most mid-range and high end arrays actually use that battery to insure that data 
is all written out to permanent media when the power is lost. I won't go into 
how that is done, but it clearly would not be a safe assumption to assume that 
your power outage is only going to be a certain length of time (and if not, you 
would lose data).

> 
> A big EMC array we had had enough battery power to power about 400 disks
> while the 16 Gig of cache was flushed.  I think EMC told me the batteries
> would last about 20 minutes.  I don't recall if the array was usable during
> the 20 minutes.  We never tested a power failure.
> 
> Guy

I worked on the team that designed that big array.

At one point, we had an array on loan to a partner who tried to put it in a very 
small data center. A few weeks later, they brought in an electrician who needed 
to run more power into the center.  It was pretty funny - he tried to find a 
power button to turn it off and then just walked over and dropped power trying 
to get the Symm to turn off.  When that didn't work, he was really, really 
confused ;-)

ric
