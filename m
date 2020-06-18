From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 7/7] multipath: add option to skip multipathd
	delegation
Date: Thu, 18 Jun 2020 18:15:44 -0500
Message-ID: <20200618231544.GL5894@octiron.msp.redhat.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-8-git-send-email-bmarzins@redhat.com>
	<05515ff45562db8013db838cd13bdb1f106f1e87.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <05515ff45562db8013db838cd13bdb1f106f1e87.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 18, 2020 at 08:44:10PM +0000, Martin Wilck wrote:
> On Wed, 2020-06-17 at 19:24 -0500, Benjamin Marzinski wrote:
> > Add the -D option to allow users to skip delegating commands to
> > multipathd.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.h |  1 +
> >  multipath/main.c      | 15 +++++++++++----
> >  multipath/multipath.8 | 16 +++++++++++-----
> >  3 files changed, 23 insertions(+), 9 deletions(-)
> >=20
>=20
> I wonder if we really need this. We fall back to NOT_DELEGATED anyway.
> If users really, really want this, they can run multipath while
> multipathd is stopped.
>=20
> I'm not saying it's totally useless, but the presence of this option
> suggests to users that they may want to use it, which I doubt.
> Perhaps we want to have it, for debugging or expert usage purpose, as a
> hidden/undocumented option?

I'm fine with having it as an undocumented option.

-Ben

>=20
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
