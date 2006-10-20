From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [RFC] Change to the mirror table map
Date: Fri, 20 Oct 2006 18:18:06 +0200
Message-ID: <OF75AC1D80.D78E8F6A-ONC125720D.005489B7-C125720D.0059457E@de.ibm.com>
References: <1161291378.26135.3.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1161291378.26135.3.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

Hi Jonathan,


> New features:
> 
================================================================================
> I've added a format argument ("format2" in example).  It is always the 
first
> argument to the mirror target.  If it isn't present, we can assume 
> the original
> format.  If it is present, we can use the format specified.
> 
Probably isn't needed with section keywords. Something not "core" od 
"disk"
is format2.

> The mapping table is broken up into sections.  The sections are allowed 
to be
> in any order, and we should be able to add sections in the future if
> necessary.
> 
From the user side good since it allows more flexibility. The downside is 
that
it adds complexity to the kernel parsing. And there might be sections that
depend on each other...

> The devices section starts with the keyword 'devices' and is followed by 
the
> number of devices then the number of per device arguments.  This is not
> consistent with the other sections.  It may be better to have the 
keyword
> followed by the argument count, followed by the per device argument 
count.
> Something like:
>     devices 5 1 253:3 S 253:4 A
> or
>     devices 5 2 253:3 S 253:4 A
>
Or something like
        devices 2 2 543:3 S 2 253:4 A
so each device can have a different number of arguments?

> depending on if you want to include the device in the per device 
argument
> count.  Notice that I have done away with the 'offset' parameter found 
in
> the original.  Multipath doesn't have that, and neither does mirroring
> when specifying the log device.  For the above example, I did add an
>
Personally I think the offset is useful if doing mappings for complete
partitions/disks and the log should rather have it as well.

> The read balancing section starts with the keyword 'read-balance' and is
> followed by the number of read balancing arguments.  After that, it is
> just like multipathing.  If we were certain that the devices section did
> not need any device specific arguments, we could combine the devices 
section
> and the read-balance section.  (This could be the case if we decided to
> add a section for initial device status and didn't need the offset 
argument.)
> Mirror does need to keep it's own list of devices, however; and it might 
be
> nice to be able to parse that section separate - rather than parse the
> read-balancing section twice.
> 
I don't know if this can be solved in a nice way without completely 
changing
the way the layout is today. :/ I undestand why going this way but it 
feels
a bit ugly to have the same device specification twice. If there would be
something like
        devices 2 2 253:3 rr_min=1000 3 253:4 mstate=m rr_min=1000
every per device option would be in one place. But parsing would have to 
be
done more than once...

> Multipath takes the approach of having positional arguments (e.g. the 
'number
> of features' argument is in a known place).  If we took this approach, 
we
> could eliminate the keywords.  However, I think I prefer the ability to
> identify sections.
> 
It makes identification of section simpler to parse by the human reader 
which
I like as well. ;-)

Stefan
