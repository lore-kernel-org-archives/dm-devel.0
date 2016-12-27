From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2 1/3] PM suspend/hibernate: Call notifier after freezing processes
Date: Tue, 27 Dec 2016 15:29:59 +0100
Message-ID: <201612271529.59652@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <CAJZ5v0h-0Jo7A0hmPSfHcZbkRU7wKwVtSqTCCwX1rs=iBE9G5g@mail.gmail.com> <CAJZ5v0jGuLTJbsjW3WPe2Y8OgwMgcSSwTRNB8+PWaxwKpSDP-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4057816.mhXr7E65Lq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0jGuLTJbsjW3WPe2Y8OgwMgcSSwTRNB8+PWaxwKpSDP-g@mail.gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: NeilBrown <neilb@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: dm-devel.ids

--nextPart4057816.mhXr7E65Lq
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 22 July 2015 01:03:23 Rafael J. Wysocki wrote:
> On Wed, Jul 22, 2015 at 1:00 AM, Rafael J. Wysocki <rafael@kernel.org>
> wrote:
> > Hi Neil,
> >=20
> > On Wed, Jul 22, 2015 at 12:08 AM, NeilBrown <neilb@suse.com> wrote:
> >> On Mon, 20 Jul 2015 23:46:32 +0200 "Rafael J. Wysocki"
> >>=20
> >> <rjw@rjwysocki.net> wrote:
> >>> On Monday, July 20, 2015 09:32:26 AM Pali Roh=C3=A1r wrote:
> >>> > On Saturday 18 July 2015 01:27:15 Rafael J. Wysocki wrote:
> >>> > > On Thursday, July 16, 2015 09:33:02 AM Pali Roh=C3=A1r wrote:
> >>> > > > On Thursday 16 July 2015 03:02:03 Rafael J. Wysocki wrote:
> >>> > > > > Also, if you're adding AFTER_FREEZE, it would be good to
> >>> > > > > add BEFORE_THAW too for symmetry.
> >>> > > >=20
> >>> > > > But there is no use case for BEFORE_THAW. At least it is
> >>> > > > not needed for now.
> >>> > >=20
> >>> > > For your use case, a single function pointer would be
> >>> > > sufficient too.
> >>> >=20
> >>> > What do you mean by single function pointer? kernel/power is
> >>> > part of kernel image and dm-crypt is external kernel module.
> >>>=20
> >>> Well, if there is a function pointer in the core suspend code
> >>> initially set to NULL and exported to modules such that the
> >>> dm-crypt code can set it to something else, that should be
> >>> sufficient, shouldn't it?
> >>=20
> >> As long as the dm-crypt module is never unloaded.
> >=20
> > OK, there is a race related to that.
> >=20
> >> And as long as no other module could very possible want
> >> functionality like this. Ever.
> >=20
> > The point was that there were no other users currently, so dm-crypt
> > is going to be the only user for the time being.
> >=20
> >> If a module wants to be notified - the providing a notifier chain
> >> really seems like the right thing to do...
> >=20
> > Well, so please see my last response in this thread. :-)
>=20
> So it was below: "Anyway, I guess the "post freeze" new one should be
> enough for now" which doesn't mean I'm really against the notifier.
> Or at least it is not supposed to mean so.  If there's any confusion
> related to that, I'm sorry.
>=20
> Thanks,
> Rafael

In that case we are not able to distinguish if computer is going to be=20
hibernated or just suspended to RAM.

If we have both notifier (one for suspend and for hibernate) then=20
different actions can be configured for suspend and hibernate.

And it makes sense to configure different behaviour for suspend and for=20
hibernate. E.g. when you have encrypted partition where is stored=20
hibernation image then you do not have to wipe keys before going to do=20
hibernation. But for suspend to RAM you may want to wipe them.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4057816.mhXr7E65Lq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlhieucACgkQi/DJPQPkQ1JBTQCfR4Ic5rHsu15SxmiTkMkc5p1e
SgMAnjr32h44Mspa3FV/NART53tkYicj
=tOeL
-----END PGP SIGNATURE-----

--nextPart4057816.mhXr7E65Lq--
