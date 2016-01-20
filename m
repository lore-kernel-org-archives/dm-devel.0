From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: WANTED new maintainer for Linux/md (and mdadm)
Date: Wed, 20 Jan 2016 09:27:49 +0100
Message-ID: <569F4505.6060308@intel.com>
References: <87k2o849j5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k2o849j5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "J. Bruce Fields" <bfields@fieldses.org>, Phil Turmel <philip@turmel.org>
List-Id: dm-devel.ids

On 12/21/2015 07:10 AM, NeilBrown wrote:
> 
> hi,
>  I became maintainer for md (Linux Software RAID) in late 2001 and on
>  the whole it has been fun and a valuable experience.  But I have been
>  losing interest in recent years (https://lwn.net/Articles/511073/) and
>  as was mentioned at the kernel summit, I would like to resign.  Some
>  years ago I managed to hand over nfsd to the excellent Bruce Fields,
>  but I do not seem to have the gift that Linus has of attracting
>  maintainers.  While there are a number of people who know quite a bit
>  about md and/or have contributed to development, there is no obvious
>  candidate for replacement maintainer - no one who has already been
>  doing significant parts of the maintainer role.
> 
>  So I have decided to fall back on the mechanism by which I ended up
>  being maintainer in the first place.  I will create a vacuum and hope
>  someone fills it (yes: I was sucked-in....).  So as of 1st February
>  2016 I will be resigning.
> 
>  At the kernel summit in October Linus talked about the value of
>  maintainership teams (https://lwn.net/Articles/662979/).  I think it
>  would be great if a (small) team formed to continue to oversee md
>  rather than just a single individual (or maybe the dm team could extend
>  to include md??).  If I had managed to be part of a team rather than
>  "going it alone" for so long, I might feel less tired of the whole
>  thing now.
> 
>  I don't see it as my place to appoint that team or any individuals, or
>  even to nominate any candidates.  A very important attribute of a
>  maintainer is that they need to care about the code and the subsystem
>  and I cannot tell other people to care (or even know if they do).  It
>  is really up to individuals to volunteer.  A few people have been
>  mentioned to me in earlier less-public conversations.  Any of them may
>  well be suitable, but I would rather they named themselves if
>  interested.
> 
>  So I'm hoping to get one or more volunteers to be maintainer:
>    - to gather and manage patches and outstanding issues,
>    - to review patches or get them reviewed
>    - to follow up bug reports and get them resolved
>    - to feed patches upstream, maybe directly to Linus,
>      maybe through some other maintainer, depending on what
>      relationships already exist or can be formed,
>    - to guide the longer term direction (saying "no" is important
>      sometimes),
>    - to care,
>  but also to be aware that maintainership takes real effort and time, as
>  does anything that is really worthwhile.
> 
>  This all applies to mdadm as well as md (except you would ultimately
>  *be* upstream for mdadm, not needing to send it anywhere).  Even if a
>  clear team doesn't form it would be great if different people
>  maintained mdadm and md.
> 
>  One part of the job that I have put a lot of time in to is following
>  the linux-raid@vger.kernel.org list and providing support.  This makes
>  people feel good about md and so more adventurous in using it.
>  Consequently I tend to hear about bugs and usability issues nice and
>  early (well before paying customers hit them in most cases) and that is
>  a big win.
>  In recent times I've been doing less of this and have been absolutely
>  thrilled that the gap has been more than filled by other very competent
>  community members.  Not developers particular but a number of md users
>  have been providing excellent support.  I'd particularly like to
>  high-light Phil Turmel who is very forthcoming with excellent advice,
>  but he is certainly not the only one who deserves a lot of thanks.
>  So "Thank you" to everyone who answers questions on linux-raid.
> 
>  This would be a good place for any future maintainer to hang out to
>  receive wisdom as well as to provide support.
> 
>  I will still be around.  I can certainly help out in some sort of
>  mentor role, and can probably be convinced to review patches and
>  comment on designs.  But I really want to head towards spending less
>  time on md (there are so many other interesting things to learn about).
> 
>  So: if anyone is interested - please announce yourself, ask questions
>  and start doing things.  I have no clear idea about how a transition
>  will happen.  That is really up to you (plural). Take the bull by the
>  horns and start *being* a maintainer(team).  I won't get in your way
>  and I'll help where I can.
> 
> Thanks,
> NeilBrown
> 
> P.S. I'm committed to continue to work with the raid5-journal effort
> From Facebook and the raid1-cluster effort from SUSE and the
> line-in-the-sand of 1st February won't affect my support for those.
> 

Hi Neil,

Thank you for your work and time spent on maintaining MD/mdadm. I would also
like to offer help for the emerging maintainership team. I've been working with
MD RAID for more than 4 years, mostly testing and developing the IMSM-related
parts on behalf of my employer - Intel. I realize that I was not very visible
on this mailing list, but I think I have a pretty good knowledge about mdadm
and the MD drivers. Now I have Intel's approval to take on maintaining MD RAID
as part of my job, not focusing primarily on IMSM. I definitely feel more
confident with maintaining mdadm, but I would certainly like to learn more
about the kernel MD stack and help with it as much as I can.

Regards,
Artur
