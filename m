From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD caching
 software for Linux kernel
Date: Fri, 1 Feb 2013 17:23:00 -0800
Message-ID: <CAH+dOxLDVsrmuh2b+RVxwOd0+JOQ+LsbuRYB5zqTE7DnoA+XTA@mail.gmail.com>
References: <20130202004459.GA4760@blackbox.djwong.org>
	<CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Warr <jason-/cow75dQlsI@public.gmane.org>, thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Fri, Feb 1, 2013 at 4:57 PM, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> This is a patch to migrate STEC's enhanceio driver out of their github
>> repository and into the staging tree.  From their README:
>>
>> "EnhanceIO driver is based on EnhanceIO SSD caching software product developed
>> by STEC Inc. EnhanceIO was derived from Facebook's open source Flashcache
>> project. EnhanceIO uses SSDs as cache devices for traditional rotating hard
>> disk drives (referred to as source volumes throughout this document).
>> EnhanceIO can work with any block device, be it an entire physical disk, an
>> individual disk partition,  a RAIDed DAS device, a SAN volume, a device mapper
>> volume or a software RAID (md) device."
>
> What's your take on the benefits of this vs bcache ?

I've been trying to review it it for cache coherency and consistency
wrt. power failures, but the complete lack of high level documentation
is making that difficult.

I saw some benchmarks the other day where on writes EIO was faster
than the raw device, which was... suspicious.
