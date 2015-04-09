From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 1/3] PM suspend/hibernate: Call notifier after freezing processes
Date: Thu, 09 Apr 2015 19:13:55 +0200
Message-ID: <1856560.gNHsvxOS0D@vostro.rjw.lan>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com> <1530775.n2Kjx1bffW@vostro.rjw.lan> <201504090836.57365@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <201504090836.57365@pali>
Sender: linux-pm-owner@vger.kernel.org
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Thursday, April 09, 2015 08:36:57 AM Pali Roh=C3=A1r wrote:
>=20
> --nextPart2566388.gOmNIJrIqI
> Content-Type: Text/Plain;
>   charset=3D"utf-8"
> Content-Transfer-Encoding: quoted-printable
>=20
> On Thursday 09 April 2015 02:28:41 Rafael J. Wysocki wrote:
> > On Sunday, April 05, 2015 07:20:17 PM Pali Roh=3DC3=3DA1r wrote:
> > > To prevent race conditions on userspace processes with I/O
> > > some taks must be called after processes are freezed. This
> > > patch adds new events which are delivered by
> > > pm_notifier_call_chain() after freezing processes when
> > > doing suspend or hibernate action.
> > >=3D20
> > > Signed-off-by: Pali Roh=3DC3=3DA1r <pali.rohar@gmail.com>
> >=3D20
> > Please don't add more notifiers.  Just call whatever you need
> > directly from where you need to call that.
> >=3D20
> > If that is device-related, try to use device PM
> > suspend/hibernate callbacks instead.
> >=3D20
>=20
> Hi! It is not possible to use any exiting pm notifiers! This is=3D20
> reason why I added new ones. As I wrote wiping dm crypt keys must=3D2=
0
> be done *after* userspace processes are freezed to prevent race=3D20
> conditions...

I'm not talking about using the existing notifiers.  I'm talking about
calling the function you need to call directly from a suitable place
in the system suspend code.


--=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
