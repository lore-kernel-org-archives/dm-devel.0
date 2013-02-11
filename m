From: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Date: Mon, 11 Feb 2013 15:04:18 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6879@MYMBX.MY.STEC-INC.AD>
References: <20130202004459.GA4760@blackbox.djwong.org>
	<CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
	<C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D66FE@MYMBX.MY.STEC-INC.AD>
	<20130207000045.GE27179@google.com>
	<C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6719@MYMBX.MY.STEC-INC.AD>
 <CAOzFzEhPWNmYEr8wzjV4YLjGo_JrSwVJkL9144qaiNfc1gLoyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEhPWNmYEr8wzjV4YLjGo_JrSwVJkL9144qaiNfc1gLoyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Warr <jason-/cow75dQlsI@public.gmane.org>, "thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Joseph Glanville [mailto:joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org]
> Sent: Saturday, February 09, 2013 1:10 AM
> To: Amit Kale
> Cc: Kent Overstreet; Michel Lespinasse; Darrick J. Wong; linux-bcache;
> device-mapper development; Kent Overstreet; Mike Snitzer; LKML; Jason
> Warr; thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
> caching software for Linux kernel
> 
> On 7 February 2013 12:54, Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org> wrote:
> >> -----Original Message-----
> >> From: Kent Overstreet [mailto:koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org]
> >> Sent: Wednesday, February 06, 2013 4:01 PM
> >> To: Amit Kale
> >> Cc: Michel Lespinasse; Darrick J. Wong; linux-bcache; device-mapper
> >> development; Kent Overstreet; Mike Snitzer; LKML; Jason Warr;
> >> thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> >> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO
> SSD
> >> caching software for Linux kernel
> >>
> >> On Thu, Feb 07, 2013 at 06:57:40AM +0800, Amit Kale wrote:
> >> > > -----Original Message-----
> >> > > From: Michel Lespinasse [mailto:walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org]
> >> > > Sent: Friday, February 01, 2013 4:58 PM
> >> > > To: Darrick J. Wong
> >> > > Cc: Amit Kale; linux-bcache; device-mapper development; Kent
> >> > > Overstreet; Mike Snitzer; LKML; Jason Warr; thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> >> > > Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC
> EnhanceIO
> >> > > SSD caching software for Linux kernel
> >> > >
> >> > > On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong
> >> > > <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >> > > > This is a patch to migrate STEC's enhanceio driver out of
> their
> >> > > github
> >> > > > repository and into the staging tree.  From their README:
> >> > > >
> >> > > > "EnhanceIO driver is based on EnhanceIO SSD caching software
> >> > > > product developed by STEC Inc. EnhanceIO was derived from
> >> > > > Facebook's open source Flashcache project. EnhanceIO uses SSDs
> >> > > > as cache devices for traditional rotating hard disk drives
> >> > > > (referred to as source volumes
> >> > > throughout this document).
> >> > > > EnhanceIO can work with any block device, be it an entire
> >> physical
> >> > > > disk, an individual disk partition,  a RAIDed DAS device, a
> SAN
> >> > > > volume, a device mapper volume or a software RAID (md)
> device."
> >> > >
> >> > > What's your take on the benefits of this vs bcache ?
> >> >
> >> > EnhanceIO was designed for and has been validated in enterprise
> >> > environments. The important benefits are - 1. There is no downtime
> >> for cache creation, deletion, editing properties,
> >> writeback/readonly/writethrough mode change.
> >>
> >> True of bcache.
> >>
> >> > 2. Wb mode comes with an option to control whether dirty data
> >> > should
> >> be clean-up across reboots, which prevents SSD/HDD going out of
> sync.
> >>
> >> No idea why you'd want this. You have to be able to handle a
> >> rebooting with a dirty cache, if you hope to handle unclean shutdown
> >> - bcache does this. And if you're running in writeback mode there's
> >> probably going to be many gigabytes of dirty data in your cache, at
> >> least sometimes, and you aren't going to want to wait for that to
> >> flush before you reboot.
> >>
> >> If you want to flush dirty data with bcache, you can switch back to
> >> writethrough mode whenever you want.
> >
> > We have two modes of operation with writeback
> >
> > 1. Warm restart mode (default) - Reboots are quick. Dirty data is
> kept as it is across reboots. So is clean data. Abrupt reboots are
> handled correctly by throwing away clean data and retaining dirty data.
> The throwing away clean data is a fallout of an optimization done to
> skip metadata updates for clean data.
> >
> > 2. Cold restart mode - A reboot or a shutdown involves clean-up of
> dirty data. This is for paranoid sysads who are afraid that iSCSI HDD
> setup may cause them to be reattached. Switching to writethrough mode
> will achieve the same thing, however with a persistent cache
> configuration in place, the cache will be write-through after a reboot.
> 
> How does Enhance-IO prevent mounting of the backing device if the cache
> device doesn't show up due to failure etc?
> I was reviewing the setup/tear-down code but I couldn't find where EIO
> writes any superblock etc to the backing device to prevent udev etc
> from mounting the filesystem.

EnhanceIO kernel driver doesn't do anything to prevent it. User level scripts have to do that. Kindly check the documentation for an example of how to do this using udev. We have tested several failure scenarios and udev scripts to handle them correctly.

-Amit

> 
> >
> > I am happy to see bcache being compliant with the rest of the items I
> had noted.
> >
> > -Amit
> >
> >>
> >> > 3. Our in-house testing was done for large setups with 500GB+SSDs
> >> > and
> >> proportionately large HDDs, on 24CPU machines with plenty of RAM.
> >> It's survived heavy IO loads without any locking or corruption
> problems.
> >>
> >> True of bcache.
> >>
> >> > 4. Error handling is exactly what enterprises look for -
> >> writethrough/readonly modes work seamlessly regardless of SSD
> failures.
> >> In all the three caching modes, the guarantees of completion in
> >> presence of IO errors or shutdowns, in terms of granularity and
> >> persistence of data written, is identical to underlying HDDs.
> >>
> >> True of bcache.
> >>
> >> > 5. It works for all known block devices - Software RAIDs, full
> >> > block
> >> devices with or without partitions, individual partitions, various
> >> intelligent block devices.
> >>
> >> True of bcache.
> >>
> >> > -Amit
> >> >
> >> > PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
> >> >
> >> > This electronic transmission, and any documents attached hereto,
> >> > may
> >> contain confidential, proprietary and/or legally privileged
> >> information. The information is intended only for use by the
> >> recipient named above. If you received this electronic message in
> >> error, please notify the sender and delete the electronic message.
> >> Any disclosure, copying, distribution, or use of the contents of
> >> information received in error is strictly prohibited, and violators
> will be pursued legally.
> >>
> >> Which of the above information was proprietary, and should I not be
> >> resending this to lkml or - who?
> >>
> >> ...
> >
> > PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
> >
> > This electronic transmission, and any documents attached hereto, may
> contain confidential, proprietary and/or legally privileged
> information. The information is intended only for use by the recipient
> named above. If you received this electronic message in error, please
> notify the sender and delete the electronic message. Any disclosure,
> copying, distribution, or use of the contents of information received
> in error is strictly prohibited, and violators will be pursued legally.
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-bcache" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
