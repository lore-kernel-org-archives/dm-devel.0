From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [dm-devel] WANTED new maintainer for Linux/md (and mdadm)
Date: Mon, 4 Jan 2016 14:40:46 -0600
Message-ID: <0AAF8A3C-BE70-4510-A8EA-F64B2F4A0B4D@redhat.com>
References: <87k2o849j5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87k2o849j5.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Phil Turmel <philip@turmel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

Many thanks Neil for all the work you=E2=80=99ve done and the help you =
gave me while working on the DM/MD interactions bits.  I=E2=80=99m happ=
y you are sticking around for the raid1-cluster and raid5-journal bits =
and I=E2=80=99m interested to see what comes out of those.

I know there are a number of folks around Red Hat who are capable and p=
ossibly interested to share the load.  They should be back from PTO soo=
n and we=E2=80=99ll make sure they know about the opportunity.

thanks,
 brassow

> On Dec 21, 2015, at 12:10 AM, NeilBrown <neilb@suse.com> wrote:
>=20
>=20
> hi,
> I became maintainer for md (Linux Software RAID) in late 2001 and on
> the whole it has been fun and a valuable experience.  But I have been
> losing interest in recent years (https://lwn.net/Articles/511073/) an=
d
> as was mentioned at the kernel summit, I would like to resign.  Some
> years ago I managed to hand over nfsd to the excellent Bruce Fields,
> but I do not seem to have the gift that Linus has of attracting
> maintainers.  While there are a number of people who know quite a bit
> about md and/or have contributed to development, there is no obvious
> candidate for replacement maintainer - no one who has already been
> doing significant parts of the maintainer role.
>=20
> So I have decided to fall back on the mechanism by which I ended up
> being maintainer in the first place.  I will create a vacuum and hope
> someone fills it (yes: I was sucked-in....).  So as of 1st February
> 2016 I will be resigning.
>=20
> At the kernel summit in October Linus talked about the value of
> maintainership teams (https://lwn.net/Articles/662979/).  I think it
> would be great if a (small) team formed to continue to oversee md
> rather than just a single individual (or maybe the dm team could exte=
nd
> to include md??).  If I had managed to be part of a team rather than
> "going it alone" for so long, I might feel less tired of the whole
> thing now.
>=20
> I don't see it as my place to appoint that team or any individuals, o=
r
> even to nominate any candidates.  A very important attribute of a
> maintainer is that they need to care about the code and the subsystem
> and I cannot tell other people to care (or even know if they do).  It
> is really up to individuals to volunteer.  A few people have been
> mentioned to me in earlier less-public conversations.  Any of them ma=
y
> well be suitable, but I would rather they named themselves if
> interested.
>=20
> So I'm hoping to get one or more volunteers to be maintainer:
>   - to gather and manage patches and outstanding issues,
>   - to review patches or get them reviewed
>   - to follow up bug reports and get them resolved
>   - to feed patches upstream, maybe directly to Linus,
>     maybe through some other maintainer, depending on what
>     relationships already exist or can be formed,
>   - to guide the longer term direction (saying "no" is important
>     sometimes),
>   - to care,
> but also to be aware that maintainership takes real effort and time, =
as
> does anything that is really worthwhile.
>=20
> This all applies to mdadm as well as md (except you would ultimately
> *be* upstream for mdadm, not needing to send it anywhere).  Even if a
> clear team doesn't form it would be great if different people
> maintained mdadm and md.
>=20
> One part of the job that I have put a lot of time in to is following
> the linux-raid@vger.kernel.org list and providing support.  This make=
s
> people feel good about md and so more adventurous in using it.
> Consequently I tend to hear about bugs and usability issues nice and
> early (well before paying customers hit them in most cases) and that =
is
> a big win.
> In recent times I've been doing less of this and have been absolutely
> thrilled that the gap has been more than filled by other very compete=
nt
> community members.  Not developers particular but a number of md user=
s
> have been providing excellent support.  I'd particularly like to
> high-light Phil Turmel who is very forthcoming with excellent advice,
> but he is certainly not the only one who deserves a lot of thanks.
> So "Thank you" to everyone who answers questions on linux-raid.
>=20
> This would be a good place for any future maintainer to hang out to
> receive wisdom as well as to provide support.
>=20
> I will still be around.  I can certainly help out in some sort of
> mentor role, and can probably be convinced to review patches and
> comment on designs.  But I really want to head towards spending less
> time on md (there are so many other interesting things to learn about=
).
>=20
> So: if anyone is interested - please announce yourself, ask questions
> and start doing things.  I have no clear idea about how a transition
> will happen.  That is really up to you (plural). Take the bull by the
> horns and start *being* a maintainer(team).  I won't get in your way
> and I'll help where I can.
>=20
> Thanks,
> NeilBrown
>=20
> P.S. I'm committed to continue to work with the raid5-journal effort
> From Facebook and the raid1-cluster effort from SUSE and the
> line-in-the-sand of 1st February won't affect my support for those.
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
