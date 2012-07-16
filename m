From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Mon, 16 Jul 2012 16:14:31 +1000
Message-ID: <20120716161431.42749a15@notabene.brown>
References: <1342057001.22214.6.camel@f16>
	<20120712162205.GA13485@www5.open-std.org>
	<331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com>
	<20120713011505.GA3099@www5.open-std.org>
	<20120713112717.3b15647c@notabene.brown>
	<20120713082923.GA19771@www5.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rjzdFMz/MLjkEzDJN9vOEid"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120713082923.GA19771@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Brassow Jonathan <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/rjzdFMz/MLjkEzDJN9vOEid
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2012 10:29:23 +0200 keld@keldix.com wrote:

> On Fri, Jul 13, 2012 at 11:27:17AM +1000, NeilBrown wrote:
> > On Fri, 13 Jul 2012 03:15:05 +0200 keld@keldix.com wrote:
> >=20
> > > I think the layout you described should not be promoted at all,
> > > and only kept for backward compatibility. As there is no backward=20
> > > compatibility in your case I think it is an error to implement it.
> > > I understand that you do not reuse any of the MD code here?
> >=20
> > Not correct.  The whole point of this exercise is to reuse md code.
>=20
> OK, I also think it is only sensible to reuse the code already done.
> I misunderstood then your mail on not to repeat mistakes - which I took t=
o mean that
> Barrow should not implement things with mistakes. Maybe that means to not=
 make hooks
> to MD code that is a mistake?
>=20
> So Barrow will implement the improved far layout once there is MD code fo=
r it, and
> then he can make the neceessary hooks in DM code?
>=20
> > > The flaw is worse than Neil described, as far as I understand.
> > > With n=3D2 you can in the current implementation only have 1 disk fai=
ling,
> > > for any numbers of drives in the array. With the suggested layout
> > > then for 4 drives you have the probability of surviving 66 %=20
> > > of 2 drives failing. This get even better for 6, 8 .. disks in the ar=
ray.
> > > And you may even survive 3 or more disk failures, dependent on the nu=
mber
> > > of drives employed. The probability is the same as  for raid-1+0
> >=20
> > Also not correct.  You can certainly have more than one failed device
> > providing you don't have 'n' adjacent devices all failed.
> > So e.g. if you have 2 drives in a far-2 layout then you can survive the
> > failure of three devices if they are 0,2,4 or 1,3,5.
>=20
> On further investigations I agree that you can survive more than one driv=
e failing with
> the current layout.
>=20
> > > > When it is available to MD, I'll make it available to dm-raid also.
> > >=20
> > > Please dont implement it in the flawed  way. It will just create a nu=
mber of problems
> > > for when to switch over and convert between the two formats, and then=
 which should
> > > be the default (I fear some would say the old flawed should be the de=
fault), and we need
> > > to explain the two formats and implement two sets of repairs and so o=
n.
> >=20
> > This "flawed" arrangement is the only one that makes sense for an odd n=
umber
> > of devices (assuming 2 copies).
>=20
> Well, I have an idea for the odd number of devices:
> Have the disks arranged in groups (for N=3D2 in pairs) and then the last =
group extended with
> the leftover disks in the way it is done now.
>=20
> For 2 copies, this would be a number of pairs, and then a rest group of 3=
 disks.
> For 3 copies, this would be a number of triplets, and then 4 or 5 disks i=
n the last group.

Certainly possible, but it feels clumsy.  I'm not convinced it is a good id=
ea.

>=20
> Can I assume, Neil, that you agree with the rest I wrote? :-)

You can agree that I don't strongly disagree...

> Especially that we should only advice the new layout, and there is no rea=
son for the
> current implementation except for backwards compatibility?

The main reason for the current implementation is that is currently
implemented.
Until an alternate implementation exists, it seems pointless to recommend
that people use it.
Maybe you are suggesting that dmraid should not support raid10-far or
raid10-offset until the "new" approach is implemented.
Maybe that is sensible, but only if someone steps forwards and actually
implements the "new" approach.

NeilBrown

--Sig_/rjzdFMz/MLjkEzDJN9vOEid
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOxRznsnt1WYoG5AQLHnhAAqS1LtbsQ3rT61FEWmRcRbs29lFA8ZyRI
S2FXA7QqQAIyjPCKqDLwlfreOO0GVww3oG/VXXvHC9hkf5qmOrS6UfmD9N46o19i
wAYn3M8ryWgIF6GkeB4SV8kWOlTB3OKrVHQFfH2snwrPljnD/dHRQpM0f7O9G43i
Vkoiv0hT5BLsLTSwxoTrUBC4DISlTBARhfShUl/+rQto98dENflPni2WG1cmFxXl
e0xqrNm22/DCoWaLsa0Ytv33HhP3xFtkt2rKF9/DQZMHhHR+uy7oBuP2ImQfvsBM
8MeQePrwqDAEif7CFLS+AhDa6wHcd6XVma9WGK/S83Qmc6W74j1Nit+3esnvQeyI
iGerpToAqF55S9J/ALj1XnW+6SM/5rSSLkzMHmOuXEDJgdKJ8kiHumCkMSSAQ2Yf
f36jwNuMn3M/v3mMdJztibTFCwRYPBQurxZ5+Kvj0+NOEeb+/rjxlLpl1GCzj743
iRoYqByxKhwp4s4KHpLx+CcKVysHroIZ2njpXiPiOMmG4T3Avi6LifLQt/SrY8JC
0/FGksRFGBbV4TFyaj/5VYvZ91IWjCZHBs5djjMKmhm6S1veQwuZ72bodAlUoB3k
3keD+NeWuTZCqYBLExRBFU/YA5fbACRh/etCeOSmx7bCnI9bv5SITQlFd48MABAe
/QvLTgF1G7k=
=TauN
-----END PGP SIGNATURE-----

--Sig_/rjzdFMz/MLjkEzDJN9vOEid--
