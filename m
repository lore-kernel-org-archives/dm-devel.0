From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2] dm pref-path: provides preferred path load balance
 policy
Date: Sat, 30 Jan 2016 14:25:25 -0600
Message-ID: <20160130202525.GE24960@octiron.msp.redhat.com>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
 <56A231C8.90602@suse.de>
 <20160122165932.GA28761@redhat.com>
 <49D617FA63152941907AADE32CF072F12FD72905@G4W3202.americas.hpqcorp.net>
 <20160129175059.GB24960@octiron.msp.redhat.com>
 <56AC7535.2090401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AC7535.2090401@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Nalla, Ravikanth" <ravikanth.nalla@hpe.com>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>
List-Id: dm-devel.ids

On Sat, Jan 30, 2016 at 09:32:53AM +0100, Hannes Reinecke wrote:
> On 01/29/2016 06:50 PM, Benjamin Marzinski wrote:
> >On Fri, Jan 29, 2016 at 02:10:52PM +0000, Nalla, Ravikanth wrote:
> >>Hi Mike, Hannes, Ben
> >>>This seems like a problem that has already been solved with path g=
roups.
> >>>If the path(s) in your preferred path group are there, multipath w=
ill
> >>> use them.  If not, then it will use your less preferred path(s), =
and
> >>> load balance across them > how ever you choose with the path_sele=
ctors.
> >>>
> >>>I admit that we don't have a path prioritizer that does a good job=
 of
> >>> allowing users to manually pick a specific path to prefer.  But i=
t seems
> >>> to me that there is > >where we should be solving the issue.
> >>>
> >>Yes as  mentioned , it appears that we will be able to achieve the =
same
> >> result using the above multipath{...} configuration. However as yo=
u
> >> mentioned I felt that it is not that user friendly in specify the =
path
> >> to prefer. So when you mentioned about solving the problem there, =
could
> >> you please clarify on what you had in mind and is there anything s=
pecific
> >> from our implementation that can be used there ?
> >>
> >
> >There are two changes that I'm working on.
> >
> >1. I'm adding an option for the alua prioritizer so that setting the
> >ALUA TPG Preferred Bit will cause the alau prioritizer to put that p=
ath
> >in a group by itself (with the highest priority). Currently if the
> >preferred bit is set for an active/optimized path, and there are oth=
er
> >active/optimized paths, they are all grouped together, and there is =
no
> >way to change that. So, for people with ALUA enabled hardware, they =
can
> >just enable the option, and set the Preferred Bit.
> >
> Hmm? I was under the distinct impression that it's exactly the other =
way
> round; at least in my code I have this:
>=20
>                 switch(aas) {
>                         case AAS_OPTIMIZED:
>                                 rc =3D 50;
>                                 break;
>                         case AAS_NON_OPTIMIZED:
>                                 rc =3D 10;
>                                 break;
>                         case AAS_LBA_DEPENDENT:
>                                 rc =3D 5;
>                                 break;
>                         case AAS_STANDBY:
>                                 rc =3D 1;
>                                 break;
>                         default:
>                                 rc =3D 0;
>                 }
>                 if (priopath && aas !=3D AAS_OPTIMIZED)
>                         rc +=3D 80;
>=20
> ie any path with the 'prio' bit set will be getting a differen priori=
ty than
> those without. Consequently they'll be grouped into different priorit=
y
> groups.
> I'd be surprised if your code is different, but what do I know ...

No. That's only true if the path doesn't have AAS_OPTIMIZED set.  So if
you have a non-optimized path with the pref bit set, it will be in a
group by itself. If the path is AAS_OPTIMIZED, the pref bit is ignored.

Like I mentioned before, you are the one who changed this

commit b330bf8a5e6a29b51af0d8b4088e0d8554e5cfb4
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Jul 16 09:12:54 2013 +0200

    alua: Do not add preferred path priority for active/optimized
   =20
    When a path is in active/optimized we should disregard the
    'preferred path' bit when calculating the priority.
    Otherwise we'll end up with having two different priorities
    (one for 'active/optimized (preferred)' and one for
    'active/optimized (non-preferred)').
    Which will result in two different path groups and a
    sub-optimal path usage.
   =20
    Signed-off-by: Hannes Reinecke <hare@suse.de>


Before this commit, it always used the pref bit. Again, like I said
before, I'm saying that this was the wrong thing to do.  The Spec is
pretty vague on what you should expect to happen when you set to pref
bit.  When the path was in a group by itself, I got complaints. Now tha=
t
the path is is a group with other active/optimized paths, I get
complaints.  The only answer is to allow the user to say what they want
the pref bit to mean.

-Ben=20

=20
> >2. For people that need to be able to control the exact priority, I'=
m
> >redoing the weighted handler to allow better ways to specify the pat=
hs
> >in a presistent manner.  It won't be as simple as the alua method, b=
ut
> >it will be actually usable, unlike it's current state.
> >
> That, however, is greatly appreciated :-)
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
