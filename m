From: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Date: Sat, 2 Feb 2013 09:39:00 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6474@MYMBX.MY.STEC-INC.AD>
References: <20130202004459.GA4760@blackbox.djwong.org>
	<CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
	<CAH+dOxLDVsrmuh2b+RVxwOd0+JOQ+LsbuRYB5zqTE7DnoA+XTA@mail.gmail.com>
 <CAH+dOxKUdxF1Ds9ogncBF1K-A979j46SqGq1rVeqii8LtgHxQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxKUdxF1Ds9ogncBF1K-A979j46SqGq1rVeqii8LtgHxQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Warr <jason-/cow75dQlsI@public.gmane.org>, "thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

End user documentation is on our github. I think it should go with the user level utilities, rather than the kernel driver.
-Amit

> -----Original Message-----
> From: Kent Overstreet [mailto:koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org]
> Sent: Friday, February 01, 2013 5:25 PM
> To: Michel Lespinasse
> Cc: Darrick J. Wong; Amit Kale; linux-bcache; device-mapper
> development; Kent Overstreet; Mike Snitzer; LKML; Jason Warr;
> thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
> caching software for Linux kernel
> 
> Also, where's the end user documentation?
> 
> On Fri, Feb 1, 2013 at 5:23 PM, Kent Overstreet
> <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, Feb 1, 2013 at 4:57 PM, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> wrote:
> >> On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong
> <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >>> This is a patch to migrate STEC's enhanceio driver out of their
> >>> github repository and into the staging tree.  From their README:
> >>>
> >>> "EnhanceIO driver is based on EnhanceIO SSD caching software
> product
> >>> developed by STEC Inc. EnhanceIO was derived from Facebook's open
> >>> source Flashcache project. EnhanceIO uses SSDs as cache devices for
> >>> traditional rotating hard disk drives (referred to as source
> volumes throughout this document).
> >>> EnhanceIO can work with any block device, be it an entire physical
> >>> disk, an individual disk partition,  a RAIDed DAS device, a SAN
> >>> volume, a device mapper volume or a software RAID (md) device."
> >>
> >> What's your take on the benefits of this vs bcache ?
> >
> > I've been trying to review it it for cache coherency and consistency
> > wrt. power failures, but the complete lack of high level
> documentation
> > is making that difficult.
> >
> > I saw some benchmarks the other day where on writes EIO was faster
> > than the raw device, which was... suspicious.

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
