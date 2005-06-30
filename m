From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: mirroring: [patch 1 of 8] device failure tolerance
Date: Thu, 30 Jun 2005 12:38:17 -0400
Message-ID: <87f94c370506300938213c1ad8@mail.gmail.com>
References: <16a7b346170f3909d57592016a32abc0@redhat.com>
	<87f94c37050630081370347a28@mail.gmail.com>
	<3333970fb0e372a4637169a2b97b46f7@redhat.com>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3333970fb0e372a4637169a2b97b46f7@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan E Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 6/30/05, Jonathan E Brassow <jbrassow@redhat.com> wrote:
>=20
> On Jun 30, 2005, at 10:13 AM, Greg Freemyer wrote:
>=20
> > On 6/29/05, Jonathan E Brassow <jbrassow@redhat.com> wrote:
> >> This patch defines a couple more states that logs can return, and
> >> checks for those states in the mirror code.  The states are useful f=
or
> >> logs that have cluster support.
> >>
> >>   brassow
> >
> > Have I been asleep?  This is the first I heard of DM having cluster
> > mirror support.  I assume the goal is something along the lines of
> > what DRBD provides.
> >
> > Can someone give a very high-level overview of current status, plans,
> > etc. related to DM Cluster Mirror support.  And if this related to th=
e
> > DRBD project?
>=20
> Please note that the "mirroring [patch x of 8]..." set for device fault
> tolerance has been replaced with the "mirroring [patch x of 6]..." set.
>=20
> The cluster mirroring that I'm talking about is active/active and
> capable of handling more than 2 nodes.  It would be used in conjunction
> with a clustered file system - like GFS.  The application sitting on
> the cluster mirror should be cluster-aware.  You wouldn't be able to
> just put ext3 on there and expect it to work in a cluster capacity.
>=20
> Although there are some minor things that need to happen in the mirror
> proper code (as can be seen from the smallness of the cluster patch),
> the heavy lifting is done by a cluster-aware log.  That is were you are
> keeping track of clean/dirty/recovering state.
>=20
> An out-dated (but still useful for background) dock can be found at
> http://www.brassow.com/mirroring/index.html
>=20
>   brassow
>=20

Sounds like you have more ambitious plans than DRBD.   (They have
active-passive now and IIRC they plan the next major release to have
active-active, but I think only on 2 nodes.)

Is the GFS team planning on supporting this infrastructure.  I hope so.

Greg
--=20
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
