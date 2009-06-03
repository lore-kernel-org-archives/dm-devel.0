From: Neil Brown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
Date: Wed, 3 Jun 2009 13:56:35 +1000
Message-ID: <18981.62579.171350.910761@notabene.brown>
References: <18980.48553.328662.80987@notabene.brown>
	<4A25876A.1010901@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Jeff Garzik on Tuesday June 2
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com, Arjan van de Ven <arjan@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: dm-devel.ids


[dm-devel added for completeness]

Hi Jeff,
 thanks for your thoughts.
 I agree this is a conversation worth having.

On Tuesday June 2, jeff@garzik.org wrote:
> Neil Brown wrote:

> > The significant change which justifies the new major version number is
> > that mdadm can now handle metadata updates entirely in userspace.
> > This allows mdadm to support metadata formats that the kernel knows
> > nothing about.
> > 
> > Currently two such metadata formats are supported:
> >   - DDF  - The SNIA standard format
> >   - Intel Matrix - The metadata used by recent Intel ICH controlers.
> 
> This seems pretty awful from a support standpoint:  dmraid has been the 
> sole provider of support for vendor-proprietary up until this point.

And mdadm has been the sole provider of raid5 and raid6 (and,
arguably, reliable raid1 - there was a thread recently about
architectural issues in dm/raid1 that allowed data corruption).
So either dmraid would have to support raid5, or mdadm would have to
support IMSM.  or both?

> 
> Now Linux users -- and distro installers -- must choose between software 
> RAID stack "MD" and software RAID stack "DM".  That choice is made _not_ 
> based on features, but on knowing the underlying RAID metadata format 
> that is required, and what features you need out of it.

If you replace the word "required" by "supported", then the metadata
format becomes a feature.  And only md provides raid5/raid6.  And only
dm provides LVM.  So I think there are plenty of "feature" issues
between them.
Maybe there are now more use-cases where the choice cannot be made
based on features.  I guess things like familiarity and track-record
come in to play there.  But choice is a crucial element of freedom.


> 
> dmraid already supports
> 	- Intel RAID format, touched by Intel as recently as 2007
> 	- DDF, the SNIA standard format
> 
> This obviously generates some relevant questions...
> 
> 1) Why?  This obviously duplicates existing effort and code.  The only 
> compelling reason I see is RAID5 support, which DM lacks IIRC -- but the 
> huge issue of user support and duplicated code remains.

Yes, RAID5 (and RAID6) are big parts of the reason.  RAID1 is not an
immaterial part.
But my initial motivation was that this was the direction I wanted the
md code base to move in.  It was previously locked to two internal
metadata formats.  I wanted to move the metadata support into
userspace where I felt it belonged, and DDF was a good vehicle to
drive that.
Intel then approached me about adding IMSM support and I was happy to
co-operate.

> 
> 2) Adding container-like handling obviously moves MD in the direction of 
> DM.  Does that imply someone will be looking at integrating the two 
> codebases, or will this begin to implement features also found in DM's 
> codebase?

I wonder why you think "container-like" handling moves in the
direction of DM.  I see nothing in the DM that explicitly relates to
this.  There was something in MD (internal metadata support) which
explicitly worked against it.  I have since made that less of an issue.
All the knowledge of containers  is really in lvm2/dmraid and mdadm - the
user-space tools (and I do think it is important to be aware of the
distinction between the kernel side and the user side of each
system). 

So this is really a case of md "seeing" the wisdom in that aspect of
the design of "dm" and taking a similar approach - though with
significantly different details.

As for integrating the two code bases.... people have been suggesting
that for years, but I suspect few of them have looked deeply at the
practicalities.  Apparently it was suggested at the recent "storage
summit".  However as the primary md and dm developers were absent, I
have doubts about how truly well-informed that conversation could have
been.

I do have my own sketchy ideas about how unification could be
achieved.  It would involve creating a third "thing" and then
migrating md and dm (and loop and nbd and drbd and ...) to mesh with
that new model.
But it is hard to make this a priority where there are more
practically useful things to be done.

It is worth reflecting again on the distinction between lvm2 or dmraid
and dm, and between mdadm and md.
lvm2 could conceivably use md.  mdadm could conceivably use dm.
I have certainly considered teaching mdadm to work with dm-multipath
so that I could justifiably remove md/multipath without the risk of
breaking someone's installation.  But it isn't much of a priority.
The dmraid developers might think that utilising md to provide some
raid levels might be a good thing (now that I have shown it to be
possible).  I would be happy to support that to the extent of
explaining how it can work and even refining interfaces if that proved
to be necessary.  Who knows - that could eventually lead to me being
able to end-of-life mdadm and leave everyone using dmraid :-)

Will md implement features found in dm's code base?
For things like LVM, Multipath, crypt and snapshot : no, definitely not.
For things like suspend/resume of incoming IO (so a device can be
reconfigured), maybe.  I recently added that so that I could effect 
raid5->raid6 conversions.  I would much rather this was implemented in
the block layer than in md or dm.  I added it to md because that was
the fastest path, and it allowed me to explore and come to understand
the issues.  I tried to arrange the implementation so that it could be
moved up to the block layer without user-space noticing.  Hopefully I
will get around to attempting that before I forget all that I learnt.


> 
> 3) What is the status of distro integration efforts?  I wager the distro 
> installer guys will grumble at having to choose among duplicated RAID 
> code and formats.

Some distros are shipping mdadm-3.0-pre releases, but I don't think
any have seriously tried to integrate the DDF or IMSM support with
installers or the boot process yet.
Intel have engineers working to make sure such integration is
possible, reliable, and relatively simple.

Installers already understand lvm and mdadm for different use cases.
Adding some new use cases that overlap should not be a big headache.
They also already support ext3-vs-xfs, gnome-vs-kde etc.

There is an issue of "if the drives appear to have DDF metadata, which
tool shall I use".  I am not well placed to give an objective answer
to that.
mdadm can easily be told to ignore such arrays unless explicitly
requested to deal with them.  A line like
   AUTO -ddf -imsm
in mdadm.conf would ensure that auto-assembly and incremental assembly
will ignore both DDF and IMSM.

> 
> 4) What is the plan for handling existing Intel RAID users (e.g. dmraid 
> + Intel RAID)?  Has Intel been contacted about dmraid issues?  What does 
> Intel think about this lovely user confusion shoved into their laps?

The above mentioned AUTO line can disable mdadm auto-management of
such arrays.  Maybe dmraid auto-management can be equally disabled.
Distros might be well-advise to make the choice a configurable
option.

I cannot speak for Intel, except to acknowledge that their engineers
have done most of the work to support IMSM is mdadm.  I just provided
the infrastructure and general consulting.

> 
> 5) Have the dmraid maintainer and DM folks been queried, given that you 
> are duplicating their functionality via Intel and DDF RAID formats? 
> What was their response, what issues were raised and resolved?

I haven't spoken to them, no (except for a couple of barely-related
chats with Alasdair).
By and large, they live in their little walled garden, and I/we live
in ours.

NeilBrown
