From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Tue, 17 Jul 2012 12:40:59 +1000
Message-ID: <20120717124059.59d1f8b0@notabene.brown>
References: <1342057001.22214.6.camel@f16>
	<20120712162205.GA13485@www5.open-std.org>
	<331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com>
	<20120713011505.GA3099@www5.open-std.org>
	<20120713112717.3b15647c@notabene.brown>
	<20120713082923.GA19771@www5.open-std.org>
	<20120716161431.42749a15@notabene.brown>
	<20120716082843.GA30247@www5.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uMaAdC9u.aSFoZqU3I/9j0+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120716082843.GA30247@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Brassow Jonathan <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/uMaAdC9u.aSFoZqU3I/9j0+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 10:28:43 +0200 keld@keldix.com wrote:

> On Mon, Jul 16, 2012 at 04:14:31PM +1000, NeilBrown wrote:
> > On Fri, 13 Jul 2012 10:29:23 +0200 keld@keldix.com wrote:
> >=20
> > > On Fri, Jul 13, 2012 at 11:27:17AM +1000, NeilBrown wrote:
> > > > On Fri, 13 Jul 2012 03:15:05 +0200 keld@keldix.com wrote:
> > > >=20
> > > Well, I have an idea for the odd number of devices:
> > > Have the disks arranged in groups (for N=3D2 in pairs) and then the l=
ast group extended with
> > > the leftover disks in the way it is done now.
> > >=20
> > > For 2 copies, this would be a number of pairs, and then a rest group =
of 3 disks.
> > > For 3 copies, this would be a number of triplets, and then 4 or 5 dis=
ks in the last group.
> >=20
> > Certainly possible, but it feels clumsy.  I'm not convinced it is a goo=
d idea.
>=20
> Well, it is for this time only a proposal. I do think it preserves all th=
e benefits of raid10,far
> especially the striping for reading, and I believe it brings redundancy b=
eyond 1 drive up
> from zero for odd-drive arrays to almost raid-1+0 - in my mind this is as=
 good as it can get theoretically.
> In my guts it feels like good design. I am exited about it:-)
>=20
> Why do you feel it is clumsy? Because it is not as general as the current=
 code, but it would take a few more lines to do it?
> We do gain a lot of redundancy for say 20 more lines of code.

Yes, because it is not general.   That makes it hard to explain or describe.
That in turn makes mistake easier.

That doesn't mean that I am dead-set against it, but I'm not sure I want to
encourage it.
I don't think RAID10 array with 'odd' numbers of drives are that common in
the first place.
You suggestion would make no difference for 3 devices, a small difference f=
or
5 (4 vulnerable pairs instead of 5) and only becomes significant with 7 or
more devices.  Are people going to make arrays with 7 devices (with 5
vulnerable pairs) instead of 8 devices (with 4 vulnerable pairs)?

>=20
> > Maybe that is sensible, but only if someone steps forwards and actually
> > implements the "new" approach.
>=20
> I would have hoped you would do it!

In my copious spare time.


>=20
> I am not a seasoned kernel hacker like you, but could you point me to the=
 code where
> the sequence of the blocks is done for far and offset? I would think it w=
ould only be a few places.
>=20
> And then how to handle the two different layouts, and how to do a migrati=
on? Where would that be done?

Let's see if Jon comes up with something.

NeilBrown


--Sig_/uMaAdC9u.aSFoZqU3I/9j0+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUATQuznsnt1WYoG5AQIwVg//SRVPhLrc+WhC3sGUEir7LETM4NTgeT2l
ZQp2WR7XPmgi/SYWP3ut6t1EkjEVhQzkB1cAintfYSZMBhc8JtJmmxB2San40R4y
vFzAe9QVOPPAywnaaViaHntiqVgh/t72lxezXe7ABaEObBG7pl/AX9YU4ri6cvse
zHhdd/F+UqUrxtmdPDVGSiy3v5ruIQxFM5QNYjJYbt0taGywG3TQIKL1WKBI+Si1
apuxiU6SCBs4BIvQYonuWktSHf65jUY3JWdRkgccgDFyZGpcHJUIMrIAfQS1QvIz
2ph3jurGoIY+N6gQr0KwQMPYLTmRnNSmCw/QY10VsYI4FkbAGxYH0OdnLrXX4mO+
mHpJv5OWMtKEJhMVoXtsA0xseUSQRDjKq7RE8CLKcEdupb88GEcIyLp9Ug8fIcBf
DphRVapG0cOKcj7v9kDuEtJ0HDG68cz1drHncN02EerVkPLSb0OMbSXcfPHUCg8D
RQ5xf2v+Fhx6o6yYv4bCFgsjGoNQ8gA3PkYDQQu7eb6D/Xnn5scx3F3U3qJQMyXn
UGcMK6k5FrYT0R8TvGYB17I/ROH+AxCoAIZYxH3NxmDOtXFo1Z6zL13SiBEwJnxX
5H6Q25z9ki66iT3cQuei9RrTW2UD5+gmYEZXld6OCJ5iCut/bogt8YMwA+i1vZE8
Dl5vGlnS1WE=
=pvjU
-----END PGP SIGNATURE-----

--Sig_/uMaAdC9u.aSFoZqU3I/9j0+--
