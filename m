From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: correct entry for LVM
Date: Mon, 11 Apr 2016 14:08:54 -0700
Message-ID: <1460408934.1800.87.camel@perches.com>
References: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <20160411155147.GB9288@agk-dp.fab.redhat.com> <570BCD85.6090807@gmail.com>
	 <20160411162306.GC9288@agk-dp.fab.redhat.com> <570BD354.2000100@gmail.com>
	 <570BF1DB.1040700@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <570BF1DB.1040700@youngman.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 2016-04-11 at 19:50 +0100, Wols Lists wrote:
> On 11/04/16 17:39, Sudip Mukherjee wrote:
> >=20
> > On Monday 11 April 2016 09:53 PM, Alasdair G Kergon wrote:
> > >=20
> > > On Mon, Apr 11, 2016 at 09:45:01PM +0530, Sudip Mukherjee wrote:
> > > >=20
> > > > L stands for "Mailing list that is relevant to this area", and =
this is a
> > > > mailing list. :)
> > > Your proposed patch isn't changing the L entry, so this is of no
> > > relevance.
> > Sorry, I am not understanding.
> >=20
> > The current entry in MAINTAINERS is:
> > DEVICE-MAPPER=A0=A0(LVM)
> > M:=A0=A0=A0=A0=A0=A0Alasdair Kergon <agk@redhat.com>
> > M:=A0=A0=A0=A0=A0=A0Mike Snitzer <snitzer@redhat.com>
> > M:=A0=A0=A0=A0=A0=A0dm-devel@redhat.com
> > L:=A0=A0=A0=A0=A0=A0dm-devel@redhat.com
> > ...
> >=20
> > So my patch just removed the line : "M:=A0=A0=A0=A0=A0=A0dm-devel@r=
edhat.com"
> >=20
> > So now the entry becomes :
> > DEVICE-MAPPER=A0=A0(LVM)
> > M:=A0=A0=A0=A0=A0=A0Alasdair Kergon <agk@redhat.com>
> > M:=A0=A0=A0=A0=A0=A0Mike Snitzer <snitzer@redhat.com>
> > L:=A0=A0=A0=A0=A0=A0dm-devel@redhat.com
> > ...
> >=20
> > So, now it correctly shows dm-devel@redhat.com as a mailing list wh=
ich
> > should have cc to all the patches related to LVM.
> >=20
> > Or am I understanding this wrong?
> Yes. Because (I guess M stands for maintainer) this list has maintain=
er
> status. As all patches should be sent to the maintainers therefore al=
l
> patches should be sent to this list.
>=20
> The same person can appear twice in a phone book, once under their na=
me
> and once under their job title. This is exactly the same situation -
> this list should appear once as a list to tell people that it's a lis=
t,
> AND ALSO as a maintainer to tell people that patches must be sent to =
the
> list.
>=20
> I guess English is not your first language, but the important point i=
s
> that M and L are not mutually exclusive.
>=20
I'm a native English speaker and I think that's a not
a good argument.

Having the same entry for M: and L: where M: isn't an
actual person is not a great idea.

The list is not a maintainer.
